# Author: Amina Mehmood <amina.mehmood26@imperial.ac.uk>
# Script: data_wrang_tidy.R
# Desc: Wrangles the Pound Hill data from wide to long with tidyr::pivot_longer (tidyverse version of data_wrang.R)
# Arguments: None
# Date: Nov 2026
# Run from the project root: Rscript code/data_wrang_tidy.R
# Inputs: data/pound_hill_data.csv, data/pound_hill_meta_data.csv
# Output: results/data_wrang_tidy_long.csv

# Load the data ----------------------------------------------------------
# The first rows describe the sampling design, so do not use one as a header yet.
MyData <- as.matrix(read.csv("data/pound_hill_data.csv", header = FALSE))

# The metadata file does have a header and uses semicolons as separators.
MyMetaData <- read.csv("data/pound_hill_meta_data.csv", header = TRUE, sep = ";")

# Inspect the data -------------------------------------------------------
head(MyData)
dim(MyData)
str(MyData)
head(MyMetaData)

# Transpose so species become columns and sampled quadrats become rows.
MyData <- t(MyData) 
head(MyData)
dim(MyData)

# For this dataset, we have been told that blanks are observed absences.
# That knowledge is what allows us to record them as zero rather than NA.
MyData[MyData == ""] <- 0

# Convert the raw matrix to a data frame --------------------------------

TempData <- as.data.frame(MyData[-1, ], stringsAsFactors = FALSE)
colnames(TempData) <- MyData[1, ]
rownames(TempData) <- NULL

# Convert from wide to long form ----------------------------------------
# This script uses the newer tidyr::pivot_longer() function.
library(dplyr)
library(tidyr)

MyWrangledData <- TempData |>
  pivot_longer(
    cols = -c(Cultivation, Block, Plot, Quadrat),   # every column EXCEPT these is a species
    names_to = "Species",
    values_to = "Count"
  ) |>
  mutate(
    across(c(Cultivation, Block, Plot, Quadrat, Species), as.factor),
    Count = as.integer(Count)
  )

str(MyWrangledData)
head(MyWrangledData)
dim(MyWrangledData)

# Save a derived table while leaving the raw files unchanged.
dir.create("results", showWarnings = FALSE)
write.csv(MyWrangledData, "results/data_wrang_tidy_long.csv", row.names = FALSE)
