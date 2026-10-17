#!/bin/bash

# custom list and there is no need of braces while using space as word saperator
for i in apple banana cherry;
do
    echo "I love eating $i"
done

# list with braces and using space as word saperator and quotos are important to avoid word splitting
fruits=("apple" "banana" "cherry")

for fruit in "${fruits[@]}";
do
    echo "I like $fruit"
done   

#Number sequences using brace expansion
echo "Counting Start.."

for i in {5..1}; do
    echo "$i"
    sleep 1s   #pauses for 1 second
done

echo "Counting End.."

#Looping through files in a directory

for file in *.sh;do
    echo "Found a script file: $file"
    chmod +x "$file"  # make the file executable    
    sleep 1s
done


