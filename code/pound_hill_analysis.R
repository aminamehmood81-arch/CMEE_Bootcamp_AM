# Run from the coursework project root with:
# Rscript code/pound_hill_analysis.R

# Load the data ----------------------------------------------------------
library(reshape2)
library(dplyr)
library(ggplot2)

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
# This script keeps the older reshape2 route because it is still common in
# ecological code. For new work, the chapter introduces tidyr::pivot_longer().


MyWrangledData <- melt(
  TempData,
  id = c("Cultivation", "Block", "Plot", "Quadrat"),
  variable.name = "Species",
  value.name = "Count"
)

MyWrangledData[, "Cultivation"] <- as.factor(MyWrangledData[, "Cultivation"])
MyWrangledData[, "Block"] <- as.factor(MyWrangledData[, "Block"])
MyWrangledData[, "Plot"] <- as.factor(MyWrangledData[, "Plot"])
MyWrangledData[, "Quadrat"] <- as.factor(MyWrangledData[, "Quadrat"])
MyWrangledData[, "Count"] <- as.integer(MyWrangledData[, "Count"])

str(MyWrangledData)
head(MyWrangledData)
dim(MyWrangledData)

# Save a derived table while leaving the raw files unchanged.
dir.create("results", showWarnings = FALSE)
write.csv(MyWrangledData, "results/pound_hill_long.csv", row.names = FALSE) # to observe the cleaned data format

# Checks
stopifnot(is.numeric(MyWrangledData$Count)== TRUE)
stopifnot(anyNA(MyWrangledData$Count) == FALSE)
stopifnot(all(MyWrangledData$Count >= 0))
n_plots <- n_distinct(MyWrangledData$Cultivation,MyWrangledData$Block,MyWrangledData$Plot)
n_quadrats <- n_distinct(MyWrangledData$Cultivation,MyWrangledData$Block,MyWrangledData$Plot,MyWrangledData$Quadrat)
n_species <- n_distinct(MyWrangledData$Species)
cat("Species:", n_species, "plots:", n_plots, "quadrats:", n_quadrats, "\n")
stopifnot(n_plots == 12)
print("The data has been wrangled successfully")

# Quadrat richness table
quadrat_richness <- MyWrangledData %>%
 group_by(Cultivation, Block, Plot, Quadrat) %>%
 summarise(Richness = sum(Count > 0))  %>%
 ungroup() %>%
 as.data.frame()
stopifnot(nrow(quadrat_richness) == n_quadrats)

# Plot richness summary
Plot_summary <-quadrat_richness %>%
 group_by(Cultivation, Block, Plot) %>%
 summarise(MeanRichness = mean(Richness)) %>%
 ungroup() %>%
 as.data.frame()
stopifnot(nrow(Plot_summary) == n_plots)
write.csv(Plot_summary, "results/pound_hill_plot_richness.csv", row.names = FALSE)

# Richness Figure
set.seed(1)   # to make the points identical on every run
richness_plot <- ggplot(Plot_summary, aes(x = Cultivation, y = MeanRichness)) +
 geom_boxplot(outlier.shape = NA, alpha = 0.5) +
 labs(title = "Mean Richness vs Cultivation", x = "Cultivation Month", y = "Mean Richness of species per quadrat in each plot") +
geom_jitter(width = 0.1, height = 0, colour = "darkgreen", size = 3) +
 theme_minimal()
ggsave(plot = richness_plot, width = 6, height = 6, filename = "results/pound_hill_plot_richness.pdf")

#Interpretation
# May has the heighest mean richness.
# Variation among months is small, but variation among plots within each month is large, so plot-level differences matter as well.
# The figure alone cannot show causation, as differences in soil and location were not considered.