#!/usr/bin/perl -w
use strict;

my @json = `ls ../oxog-*-jobs/backlog-jobs-multitumour/*.json ../oxo*jobs/download*/*.json`;
chomp @json;
my $min = 999;
my $donor;
my $count = 0;

foreach my $json (@json) {
  my $total_size = 0;
  my @fsize = `grep bam\\" -n1 $json | grep file_size | cut -f2 -d: | sed 's/,//' | sed 's/ //'`	;
  chomp @fsize;
  foreach my $fsize (@fsize) {
    $total_size += $fsize;
    $count++;
  }
#  if ($total_size < $min) {
#    $min = $total_size;
#    $donor = $json;
#  }
  print join("\t", $json, $count, sprintf('%.3f', $total_size / (1028*1028*1028))."GB"), "\n";
}

#print "\n", join("\t", $donor, $min."GB"), "\n";
