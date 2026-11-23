#!/bin/bash
# Author: Amina Mehmood <amina.mehmood26@imperial.ac.uk>
# Script: ConcatenateTwoFiles.sh
# Desc: Joins two files into a new output file
# Arguments: input1 input2 output
# Date: Nov 2026

cat "$1" > "$3"
cat "$2" >> "$3"
echo "Merged File is"
cat "$3"