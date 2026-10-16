#!/bin/bash
echo "Please enter a number: "
read num

if [ $num -gt 0 ]; then
    echo "$num is Positive"
elif [ $num -lt 0 ]; then
    echo "$num is negative"
else
    echo "$num is zero"
fi

