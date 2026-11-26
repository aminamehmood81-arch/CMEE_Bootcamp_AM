#!/bin/bash
# Author: Amina Mehmood <amina.mehmood26@imperial.ac.uk>
# Script: CountLines.sh
# Desc: Counts the lines in a file
# Arguments: one file path
# Date: Nov 2026

# Need exactly one argument
if [[ $# -ne 1 ]]; then
    printf 'Usage: %s file\n' "$0" >&2
    exit 2
fi

# Stop if the file does not exist
if [[ ! -f "$1" ]]; then
    printf 'Error: file not found: %s\n' "$1" >&2
    exit 1
fi

NumLines=`wc -l < "$1"`
echo "The file $1 has $NumLines lines"
echo
