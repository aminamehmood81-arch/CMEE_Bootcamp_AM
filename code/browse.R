# Author: Amina Mehmood <amina.mehmood26@imperial.ac.uk>
# Script: browse.R
# Desc: Debugging with browser(): pause inside a loop to inspect variables
# Arguments: None
# Date: Oct 2026
# Interactive: run inside R with source("code/browse.R"), not with Rscript.

Exponential <- function(N0 = 1, r = 1, generations = 10) {
  N <- rep(NA, generations)   # empty vector for population sizes
  N[1] <- N0
  for (t in 2:generations) {
    N[t] <- N[t - 1] * exp(r)   # exponential growth
    browser()                    # pause here each generation
  }
  return(N)
}

plot(Exponential(), type = "l", main = "Exponential growth")