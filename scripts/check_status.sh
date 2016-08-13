#!/bin/bash

git pull
echo
#for i in `echo oxog-aws-jobs oxog-collab-jobs oxog-tcga-jobs oxog-gtdownload-jobs`
for i in `echo oxog-collab-jobs oxog-gtdownload-jobs`
do
  echo $i
  cd $i
  for j in `echo backlog* queued* downloading* running* uploading* failed* completed*`
  do
    k=`ls $j/*json 2> /dev/null | wc -l`
    echo -e $j "\t" $k
  done
  echo
  cd ..
done
