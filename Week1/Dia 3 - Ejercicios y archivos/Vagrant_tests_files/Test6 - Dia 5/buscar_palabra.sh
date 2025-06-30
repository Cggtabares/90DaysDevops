#!/bin/bash

#Asking user for input
read -p "Enter the file name to search in: " file_name
read -p "Enter the word to search for: " word

#Checking if the file exists
if [ -f "$file_name" ]; then
    #Searching for the word in the file
    if grep -q "$word" "$file_name"; then
        echo "The word '$word' was found in the file '$file_name'."
    else
        echo "The word '$word' was not found in the file '$file_name'."
    fi
else
    echo "The file '$file_name' does not exist."
fi