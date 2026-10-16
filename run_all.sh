#!/bin/bash
echo "Today is " `date` #date sourrounded by backlits    
echo -e "\nenter the path to directory"  #prompt the path to enter  
read "the_path"                          #read the path info from the 'the_path' variable
echo  -e "\n you path has the following  files and  folders: " #display the list of files and folders
ls $the_path  #actual command to list the files and folders in the path provided by the user
