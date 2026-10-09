#!/bin/env bash
# Author: Amina
# Script: csvtospace.sh
# Desc: Substitute commas in a CSV file with spaces.


if [[ $# -ne 1 ]]; then
    printf 'Usage: %s csv-file\n' "$0" >&2
    exit 2
fi


if [[ ! -f "$1" ]]; then
    printf 'not a valid file: %s\n' "$1" >&2
    exit 3
fi

# Check that the input is readable
if [[ ! -r "$1" ]]; then
    printf 'cannot read file: %s\n' "$1" >&2
    exit 3
fi


filename=$(basename -- "$1")
out="../results/${filename}.txt"


if ! mkdir -p ../results; then
    printf 'Error: cannot create results directory\n' >&2
    exit 1
fi


if ! tr ',' ' ' < "$1" > "$out"; then
    printf 'Error: conversion failed\n' >&2
    exit 1
fi

printf 'Success: %s\n' "$out"
exit 0
