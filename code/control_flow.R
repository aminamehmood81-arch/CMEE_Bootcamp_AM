# Author: Amina Mehmood <amina.mehmood26@imperial.ac.uk>
# Script: control_flow.R
# Desc: Examples of if/else, for and while in R
# Arguments: None
# Date: Oct 2026

# if/else
a <- TRUE
if (a) {
  print("a is TRUE")
} else {
  print("a is FALSE")
}

set.seed(1)    # same random number every run, so the output is reproducible
z <- runif(1)
if (z <= 0.5) {
  print("Less than a half")
}

# for loop
for (i in seq(10)) {
  j <- i * i
  print(paste(i, "squared is", j))
}

# while loop
i <- 0
while (i < 10) {
  i <- i + 1
  print(i^2)
}