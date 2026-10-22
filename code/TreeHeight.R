# 1. Read data/trees.csv
df<- read.csv("data/trees.csv")

# 2. Inspect: dimensions, column nsmes, header, rows
dim(df)
names(df)
str(df)
head(df)
required <- c("Species", "Distance.m", "Angle.degrees")
if (!all(required %in% names(df))) {
  stop("Columns missing from the input file.")
}
# 3. Check Distance.m and Angle.degrees are numeric and 
if (!all(is.numeric(df$Distance.m) & is.numeric(df$Angle.degrees)))
{
  stop("The required column has non-numeric values")
}
if (!all(is.finite(df$Distance.m) & is.finite(df$Angle.degrees)))
{
  stop("The required column has non-finite values")
}

# 4. Check the ranges
 if (all(0 < df$Distance.m & df$Distance.m <= 100)) {
   cat("Distance.m is within the valid range.\n")
 } else {
   stop("Distance.m is outside the valid range.")
 }

 if (all(0 < df$Angle.degrees & df$Angle.degrees < 90)) {
   cat("Angle.degrees is within the valid range.\n")
 } else {
   stop("Angle.degrees is outside the valid range.")
 }

# 5. Calculate height_m
TreeHeight <- function(Angle.degrees, Distance.m) {
    radians <- Angle.degrees * pi / 180
    height <- Distance.m * tan(radians)
    return(height)
}

# 6. Add height_m as the fourth column
df$height_m <- TreeHeight(df$Angle.degrees, df$Distance.m)

# 7. Create results/ and write results/TreeHts.csv
dir.create("results", showWarnings = FALSE)
write.csv(df, "results/TreeHts.csv", row.names = FALSE)

# 8. Check for the output header order of data rows
df_check <- read.csv("results/TreeHts.csv")
str(df_check)
head(df_check)
if (identical(names(df_check), c("Species", "Distance.m", "Angle.degrees", "height_m"))){
  cat("Success: height_m is the fourth column.\n")
} else {
  stop("Warning: height_m is not the fourth column.")
}

if (nrow(df_check)== 120) {
  cat("Success: There are 120 rows in the output file.\n")
} else {
  stop("Warning: The output file does not have 120 rows.")
}

