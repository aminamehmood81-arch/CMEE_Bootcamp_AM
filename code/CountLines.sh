#!/bin/bash
# Author: Amina Mehmood <amina.mehmood26@imperial.ac.uk>
# Script: CountLines.sh
# Desc: Counts the lines in a file
# Arguments: one file path
# Date: Nov 2026

# Stop if the file does not exist
if [[ ! -f "$1" ]]; then
    printf 'Error: file not found: %s\n' "$1" >&2
    exit 1
fi

NumLines=`wc -l < "$1"`
echo "The file $1 has $NumLines lines"
echo
