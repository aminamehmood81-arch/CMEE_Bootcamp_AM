# Author: Amina Mehmood <amina.mehmood26@imperial.ac.uk>
# Script: browse.R
# Desc: Debugging with browser(): pause inside a loop to inspect variables
# Arguments: None
# Date: Oct 2026
# Run from the project root: Rscript code/browse.R < /dev/null
#   (< /dev/null lets it finish without stopping at browser(); output: results/exponential_growth.pdf)
# To step through it interactively: source("code/browse.R") inside R, then type n (next) or c (continue).

Exponential <- function(N0 = 1, r = 1, generations = 10) {
  N <- rep(NA, generations)   # empty vector for population sizes
  N[1] <- N0
  for (t in 2:generations) {
    N[t] <- N[t - 1] * exp(r)   # exponential growth
    browser()                    # pause here each generation
  }
  return(N)
}

dir.create("results", showWarnings = FALSE)
pdf("results/exponential_growth.pdf")    # send the plot to a file in results/
plot(Exponential(), type = "l", main = "Exponential growth")
dev.off()                                # finish and save the file