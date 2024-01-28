#!/bin/bash

counter=0

while :
do
  ((counter++))
  git commit --quiet --date "1970-01-01: 00:00" --allow-empty -m "commit"

  if [ $counter -eq 10000 ];
    then
      git push
      echo "Pushed 10,000 commits."
      counter=0
    fi
done
