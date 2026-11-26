#!/bin/bash
# Author: Amina Mehmood <amina.mehmood26@imperial.ac.uk>
# Script: tiff2_png.sh
# Desc: Converts .tif images in the current folder to .png
# Arguments: None; run inside the image folder
# Date: Nov 2026

# ImageMagick must be installed
if ! command -v convert > /dev/null; then
    printf 'Error: ImageMagick (convert) is not installed\n' >&2
    exit 1
fi

for filename in *.tif
do
    # If no .tif files exist, the loop gets the literal text "*.tif"
    if [[ ! -f "$filename" ]]; then
        printf 'No .tif files found in %s\n' "$(pwd)" >&2
        exit 1
    fi

    echo "Converting $filename"
    convert "$filename" "$(basename "$filename" .tif).png"
done