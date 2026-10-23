#!/bin/bash

# Creating sandbox
mkdir -p sandbox
printf 'Species,Distance.m,Angle.degrees\noak,8,45\nconifer,10,30\n' > sandbox/test_trees.csv

# 1. Run on data/trees.csv; stop if it fails
Rscript code/get_TreeHeight.R data/trees.csv > /dev/null || { echo "FAIL: Step 1 failed to run"; exit 1; }

# 2. Check results/trees_treeheights.csv has 120 data rows
rows=$(( $(wc -l < results/trees_treeheights.csv) - 1 ))
if [ "$rows" -ne 120 ]; then 
    echo "FAIL: Expected 120 data rows, got $rows"; exit 1; 
fi

# 3. Check its header has the four columns
header=$(head -n 1 results/trees_treeheights.csv)
expected_header='"Species","Distance.m","Angle.degrees","height_m"'
if [ "$header" != "$expected_header" ]; then
    echo "FAIL: Header does not match expected columns"; exit 1;
fi

# 4. Run on sandbox/test_trees.csv
Rscript code/get_TreeHeight.R sandbox/test_trees.csv > /dev/null || { echo "FAIL: Step 4 failed to run"; exit 1; }

sandbox_rows=$(( $(wc -l < results/test_trees_treeheights.csv) - 1 ))
if [ "$sandbox_rows" -ne 2 ]; then
    echo "FAIL: Sandbox output row count ($sandbox_rows) does not match input (2)"; exit 1;
fi

# 5. Check the 8 m / 45 degree row gives 8 

awk -F, 'NR==2 { d = $4 - 8; if (d < 0) d = -d; exit !(d < 1e-6) }' results/test_trees_treeheights.csv || { echo "FAIL: height tolerance check failed"; exit 1; }

# 6. Run the sandbox case again; check the row count is unchanged

Rscript code/get_TreeHeight.R sandbox/test_trees.csv > /dev/null
sandbox_rows_after=$(( $(wc -l < results/test_trees_treeheights.csv) - 1 ))
if [ "$sandbox_rows_after" -ne 2 ]; then
    echo "FAIL: File appended instead of overwritten"; exit 1;
fi

# 7. Run with no argument; check it FAILS
if Rscript code/get_TreeHeight.R > /dev/null 2>&1; then 
    echo "FAIL: Script should have failed with no arguments"; exit 1; 
fi


echo "All checks passed!"
