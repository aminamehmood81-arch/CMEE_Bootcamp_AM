#!/bin/env bash
# Author: Amina
# Script: tabtocsv.sh
# Desc: Substitute tabs in a file with commas and save as a CSV file.


if [[ $# -ne 1 ]]; then
    printf 'Usage: %s tab-delimited-file\n' "$0" >&2
    exit 2
fi


if [[ ! -f "$1" ]]; then
    printf 'not a valid file: %s\n' "$1" >&2
    exit 3
fi


if [[ ! -r "$1" ]]; then
    printf 'cannot read: %s\n' "$1" >&2
    exit 3
fi


filename=$(basename "$1")
out="../results/${filename}.csv"


if ! mkdir -p ../results; then
    printf 'cannot create results directory\n' >&2
    exit 1
fi


if ! tr '\t' ',' < "$1" > "$out"; then
    printf 'Error: conversion failed\n' >&2
    exit 1
fi

printf 'Success: %s\n' "$out"
exit 0
