#!/bin/bash
i=1
while [[ $i -lt 15 ]] ; do
   echo "$i"
  (( i += 1 ))
done