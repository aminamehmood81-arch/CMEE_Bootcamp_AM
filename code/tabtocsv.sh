#!/bin/bash
# Author: Amina Mehmood <amina.mehmood26@imperial.ac.uk>
# Script: tabtocsv.sh
# Desc: Substitute tabs in a file with commas and save as a CSV file.
# Arguments: one tab-delimited file path
# Date: Oct 2026

if [[ $# -ne 1 ]]; then # Need exactly one argument
    printf 'Usage: %s tab-delimited-file\n' "$0" >&2
    exit 2
fi


if [[ ! -f "$1" ]]; then # Input must be an existing file
    printf 'not a valid file: %s\n' "$1" >&2
    exit 3
fi


if [[ ! -r "$1" ]]; then # Input must be readable
    printf 'cannot read: %s\n' "$1" >&2
    exit 3
fi


filename=$(basename -- "$1") # Output goes to results/, named after the input
out="results/${filename}.csv"


if ! mkdir -p results/; then
    printf 'cannot create results directory\n' >&2
    exit 1
fi


if ! tr '\t' ',' < "$1" > "$out"; then # Replace tabs with commas; > replaces old output
    printf 'Error: conversion failed\n' >&2
    exit 1
fi

printf 'Success: %s\n' "$out"
exit 0
