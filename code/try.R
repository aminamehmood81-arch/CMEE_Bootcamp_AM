# Author: Amina Mehmood <amina.mehmood26@imperial.ac.uk>
# Script: try.R
# Desc: Error handling with try(): keep going when some runs fail
# Arguments: None
# Date: Oct 2026

# 1. A function that sometimes fails on purpose
doit <- function(x) {
  temp_x <- sample(x, replace = TRUE)
  if (length(unique(temp_x)) > 30) {   # only take the mean if the sample was varied enough
    print(paste("Mean of this sample was:", as.character(mean(temp_x))))
  } else {
    stop("Couldn't calculate mean: too few unique values!")
  }
}

# 2. Population data (seed fixed, so the same runs pass and fail every time)
set.seed(1345)
popn <- rnorm(50)

# 3. Without try(), the first failure stops the whole script (shown in class):
# lapply(1:15, function(i) doit(popn))

# 4. With try() inside lapply: failures are reported, the rest still run
result <- lapply(1:15, function(i) try(doit(popn), FALSE))

# 5. The same with a manual loop
result <- vector("list", 15)   # preallocate
for (i in 1:15) {
  result[[i]] <- try(doit(popn), FALSE)
}