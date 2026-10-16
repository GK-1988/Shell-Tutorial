#!/bin/bash
echo "Please enter a number: "
read num

if [ $num -gt 0 ]; then
    echo "$num is Postivie"
elif [ $hum -lt 0 ]; then
    echo "$num is neagative"
else
    echo "$num is zero"
fi

