# Author: Amina Mehmood <amina.mehmood26@imperial.ac.uk>
# Script: basic_io.R
# Desc: read a CSV, write and append to a new file
# Arguments: None
# Date: Oct 2026
# Run from the coursework project root with: Rscript code/basic_io.R

MyData <- read.csv("data/trees.csv", header = TRUE) # Import with headers

dir.create("results", showWarnings = FALSE) # Make results/ if it does not exist

write.csv(MyData, "results/MyData.csv") # Write it as a new file

write.table(MyData[1, ], file = "results/MyData.csv", append = TRUE, col.names = FALSE) # Append to it

write.csv(MyData, "results/MyData.csv", row.names = TRUE) # Write row names

write.table(MyData, "results/MyData.csv", col.names = FALSE) # Omit column names