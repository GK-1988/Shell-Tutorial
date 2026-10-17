#!/bin/bash

for i in apple banana cherry;
do
    echo "I love eating $i"
done

fruits=("apple" "banana" "cherry")

for fruit in "${fruits[@]}";
do
    echo "I like $fruit"
done    