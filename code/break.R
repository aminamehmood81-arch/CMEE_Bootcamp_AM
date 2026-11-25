# Author: Amina Mehmood <amina.mehmood26@imperial.ac.uk>
# Script: break.R
# Desc: Using break to leave a loop early
# Arguments: None
# Date: Oct 2026

i <- 0
while (i < Inf) {        # would run forever on its own...
  if (i == 10) {
    break                # ...but break stops it when i reaches 10
  } else {
    cat("i equals", i, "\n")
    i <- i + 1
  }
}