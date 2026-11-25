# Author: Amina Mehmood <amina.mehmood26@imperial.ac.uk>
# Script: next.R
# Desc: Using next to skip one round of a loop 
# Arguments: None
# Date: Oct 2026

for (i in 1:10) {
  if ((i %% 2) == 0) {   # if i is even
    next                 # skip the rest of this round, go to the next i
  }
  print(i)
}