#!/bin/bash
i=1
while [[ $i -lt 15 ]] ; do
   echo "I like number $i"
  (( i += 1 ))
done

# read the file lin by line

while read -r line; do
  echo " Proceeding user: $line"
  sleep 1s
done < "123.txt"
