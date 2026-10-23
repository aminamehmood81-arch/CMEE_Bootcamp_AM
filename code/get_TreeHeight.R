# 1. Read only input path from the command line
args <- commandArgs(trailingOnly = TRUE)
# if no arguments: stop with a clear message
if (length(args) == 0) {
  stop("No input file provided.")
}
# if more than one argument: stop with a clear message
if (length(args) > 1) {
  stop("Too many arguments provided.")
}
# if the file doesn't exist: stop with a clear message
if (!file.exists(args[1])) {
  stop("Input file does not exist.")
}
# read the file into df
df <- read.csv(args[1])

# 2. Inspect: dimensions, column names, header, rows
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

# 7. Creating results
out_path <- paste0("results/", sub("\\.csv$", "", basename(args[1])), "_treeheights.csv")
dir.create("results", showWarnings = FALSE)
write.csv(df, out_path, row.names = FALSE)
df_check <- read.csv(out_path)
str(df_check)
head(df_check)
if (identical(names(df_check), c("Species", "Distance.m", "Angle.degrees", "height_m"))){
  cat("Success: height_m is the fourth column.\n")
} else {
  stop("Warning: height_m is not the fourth column.")
}
if (nrow(df_check) == nrow(df)) {
  cat("Success: output has the same number of rows as the input.\n")
} else {
  stop("Output row count does not match the input.")
}

