#!/bin/bash
# Author: Amina Mehmood <amina.mehmood26@imperial.ac.uk>
# Script: ConcatenateTwoFiles.sh
# Desc: Joins two files into a new output file
# Arguments: input1 input2 output
# Date: Nov 2026

# Need exactly three arguments
if [[ $# -ne 3 ]]; then
    printf 'Usage: %s input1 input2 output\n' "$0" >&2
    exit 2
fi

# Both inputs must exist
for f in "$1" "$2"; do
    if [[ ! -f "$f" ]]; then
        printf 'Error: file not found: %s\n' "$f" >&2
        exit 1
    fi
done

cat "$1" > "$3"
cat "$2" >> "$3"
echo "Merged File is"
cat "$3"