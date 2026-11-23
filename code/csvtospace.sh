#!/bin/bash
# Author: Amina Mehmood <amina.mehmood26@imperial.ac.uk>
# Script: csvtospace.sh
# Desc: Substitute commas in a CSV file with spaces.
# Arguments: one CSV file path
# Date: Oct 2026


if [[ $# -ne 1 ]]; then # Need exactly one argument
    printf 'Usage: %s csv-file\n' "$0" >&2
    exit 2
fi


if [[ ! -f "$1" ]]; then # Input must be an existing file
    printf 'not a valid file: %s\n' "$1" >&2
    exit 3
fi

# Check that the input is readable
if [[ ! -r "$1" ]]; then
    printf 'cannot read file: %s\n' "$1" >&2
    exit 3
fi


filename=$(basename -- "$1") # Output goes to results/, named after the input
out="results/${filename}.txt"


if ! mkdir -p results/; then
    printf 'Error: cannot create results directory\n' >&2
    exit 1
fi


if ! tr ',' ' ' < "$1" > "$out"; then # Replace commas with spaces; > replaces old output
    printf 'Error: conversion failed\n' >&2
    exit 1
fi

printf 'Success: %s\n' "$out"
exit 0
