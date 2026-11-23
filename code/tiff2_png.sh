#!/bin/bash
# Author: Amina Mehmood <amina.mehmood26@imperial.ac.uk>
# Script: tiff2_png.sh
# Desc: Converts .tif images in the current folder to .png
# Arguments: None; run inside the image folder
# Date: Nov 2026

for filename in *.tif
do
    echo "Converting $filename"
    convert "$filename" "$(basename "$filename" .tif).png"
done