#!/usr/bin/perl -w
use strict;

# Put this script to the failed-jobs folder.  The script queries against GNOS for OxoG and minibam analyses for each donor.
# If both OxoG and minibam files are live in GNOS, then the script will move the JSON to the completed-jobs folder.
# Otherwise, the JSON will stay here for debugging and requeuing.

system("git pull");
my @json = glob("*.json");
my $repo = "gtrepo-osdc-icgc";
my $mv_count=0;

foreach my $json (@json) {
  my ($project_code, $donor_id, $tmp) = split(/\./, $json);
  my $oxog_state=`cgquery -s https://$repo.annailabs.com "study=*_pancancer_vcf&dcc_project_code=$project_code&participant_id=$donor_id&filename=*oxoG*" -A | grep -w state | sed 's/ //g' | sed 's/state://'`;
  chomp $oxog_state;
  my $minibam_state=`cgquery -s https://$repo.annailabs.com "study=*_pancancer_vcf&dcc_project_code=$project_code&participant_id=$donor_id&filename=*mini*" -A | grep -w state | sed 's/ //g' | sed 's/state://'`;
  chomp $minibam_state;

  if (($oxog_state =~ /live/) && ($minibam_state =~ /live/)) {
    print "Both in live state. Moving $json to completed-jobs\n";
    system("git mv $json ../completed-jobs");
    $mv_count++;
  }
  print "OxoG in ". ($oxog_state||"not_uploaded") . " state. Minibam in ". ($minibam_state||"not_uploaded") . " state.  Not moving $json\n" if (($oxog_state !~ /live/) || ($minibam_state !~ /live/));
}

print "$mv_count jobs have been moved from failed-jobs to completed-jobs\n\n";

## Not sure if it's a good idea to automatically do git coommit and push here
#system("git commit -am commit -am \"Moved $mv_count jobs from failed-jobs to completed-jobs since both OxoG and minibam are live in GNOS\"");
#system("git push");
