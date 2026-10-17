#!/bin/bash
i=1
while [[ $i -le 15 ]] ; do
   echo "$i"
  (( i += 1 ))
done