# Author: Amina Mehmood <amina.mehmood26@imperial.ac.uk>
# Script: observations_practice.R
# Desc: Validate and summarise observation counts by site, keeping missing and zero distinct
# Arguments: None
# Date: Nov 2026

# Why missing is not zero:because zero is a count observed and missing is something unobserved or not recorded.

read_observations <- function(path) {
  # Read everything as text; blank cells become NA (missing)
  data <- read.csv(path, colClasses = "character",
                   na.strings = "", check.names = FALSE)

  # Rule 1: columns must be exactly site, date, count (in that order)
  if (!identical(names(data), c("site", "date", "count"))) {
    stop("Expected columns site,date,count")
  }

  # Rule 2: every row needs a site and a date
  if (any(is.na(data$site)) || any(is.na(data$date))) {
    stop("Every row needs a site and a date")
  }

  # Rule 3: each count must be blank (NA) or a non-negative whole number
  for (i in seq_len(nrow(data))) {
    value <- data$count[i]
    if (!is.na(value) && !grepl("^(0|[1-9][0-9]*)$", value)) {
      stop("CSV line ", i + 1, ", column 'count': found '", value,
           "'; expected an empty field or a non-negative integer")
    }
  }

  # All counts are safe now, so convert text to whole numbers
  data$count <- as.integer(data$count)
  return(data)
}

summarise_observations <- function(data) {
  # A repeated row is not a new observation: keep one copy of each exact row
  data <- unique(data)

  sites <- sort(unique(data$site))
  result <- data.frame(site = sites, total_known = NA_integer_, missing_count = 0L)

  for (i in seq_along(sites)) {
    counts <- data$count[data$site == sites[i]]      # this site's counts

    result$missing_count[i] <- sum(is.na(counts))       # how many are missing?

    if (all(is.na(counts))) {
      result$total_known[i] <- NA                   # nothing known → missing, not 0
    } else {
      result$total_known[i] <- sum(counts, na.rm = TRUE)  # add the known ones
    }
  }
  return(result)
}

# ---- Run and check ----
ordinary <- read_observations("data/bootcamp_observations.csv")
ordinary_summary <- summarise_observations(ordinary)
print(ordinary_summary)

boundary <- read_observations("data/bootcamp_observations_boundary.csv")
boundary_summary <- summarise_observations(boundary)
print(boundary_summary)

# Expected results from the book: A (2, 1), B (0, 0), C (NA, 2), D (0, 0)
a <- ordinary_summary[ordinary_summary$site == "A", ]
b <- ordinary_summary[ordinary_summary$site == "B", ]
c_site <- boundary_summary[boundary_summary$site == "C", ]
d <- boundary_summary[boundary_summary$site == "D", ]

stopifnot(
  a$total_known == 2, a$missing_count == 1,   # duplicate removed, one missing
  b$total_known == 0, b$missing_count == 0,   # observed zero stays zero
  is.na(c_site$total_known), c_site$missing_count == 2,   # all missing -> NA, not 0
  d$total_known == 0, d$missing_count == 0    # repeated zero counted once
)

# The invalid file must be refused, not silently "fixed"
invalid_error <- tryCatch(
  read_observations("data/bootcamp_observations_invalid.csv"),
  error = function(e) conditionMessage(e)
)
stopifnot(grepl("found '-1'", invalid_error))
print(invalid_error)

# Plot known totals (missing shown as NA, not as zero) 
all_summary <- rbind(ordinary_summary, boundary_summary)   # A, B, C, D in one table

dir.create("results", showWarnings = FALSE)                # make results/ if missing
pdf("results/known_totals.pdf", width = 6, height = 4)                 

bars <- barplot(all_summary$total_known,
                names.arg = all_summary$site,
                ylim = c(0, 3),
                xlab = "Site", ylab = "Known total count",
                main = "Known total counts by site")

# Write each value above its bar, so 0 and NA look different

labels <- ifelse(is.na(all_summary$total_known), "NA", all_summary$total_known)
heights <- ifelse(is.na(all_summary$total_known), 0, all_summary$total_known)
text(bars, heights + 0.2, labels)

mtext("Site C: every count is missing, so no total is shown (NA, not 0).",
      side = 1, line = 4, cex = 0.8)
dev.off()