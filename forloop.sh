#!/bin/bash

for i in apple banana cherry;
do
    echo "$i"
done

fruits=("apple" "banana" "cherry")
for fruit in "${fruits[@]}"; do
    echo "I like $fruit"
done    