#!/bin/bash

counter=0

while :
do
  ((counter++)) 
  gh issue create --title "issue $counter" --body "$counter" --repo "smalldrew/commit-world-record"
  sleep 4
done

