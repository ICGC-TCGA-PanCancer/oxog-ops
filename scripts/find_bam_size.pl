#!/usr/bin/perl -w
use strict;

my @json = `ls ../oxog-*-jobs/backlog-jobs-multitumour/*.json`;
chomp @json;
my $min = 999;
my $donor;

foreach my $json (@json) {
  my @fsize = `grep bam\\" -n1 $json | grep file_size | cut -f2 -d: | sed 's/,//' | sed 's/ //'`	;
  chomp @fsize;
  my $total_size = sprintf('%.3f', ($fsize[0] + $fsize[1]) / (1028*1028*1028));
  if ($total_size < $min) {
    $min = $total_size;
    $donor = $json;
  }
  print join("\t", $json, $total_size."GB"), "\n";
}

#print "\n", join("\t", $donor, $min."GB"), "\n";
