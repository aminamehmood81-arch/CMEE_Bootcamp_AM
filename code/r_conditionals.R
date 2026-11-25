# Author: Amina Mehmood <amina.mehmood26@imperial.ac.uk>
# Script: r_conditionals.R
# Desc: Functions using if/else to test numbers (even, power of 2, prime)
# Arguments: None
# Date: Nov 2026

# Checks if a number is even
is.even <- function(n) {
  if (n %% 2 == 0) {
    return(paste(n, 'is even!'))
  } else {
    return(paste(n, 'is odd!'))
  }
}
print(is.even(4))

# Checks if a number is a power of 2
is.power2 <- function(n) {
  if (log2(n) %% 1==0) {
    return(paste(n, 'is a power of 2!'))
   } else {
    return(paste(n, 'is not a power of 2!'))
  }
}
print(is.power2(4))

# Checks if a number is prime
is.prime <- function(n) {
  if (n==0) {
    return(paste(n,'is a zero!'))
  } else if (n==1) {
    return(paste(n,'is just a unit!'))
  } else if (n==2) {                      
    return(paste(n,'is a prime!'))        
  }

  ints <- 2:(n-1)

  if (all(n%%ints!=0)) {
    return(paste(n,'is a prime!'))
  } else {
    return(paste(n,'is a composite!'))
  }
}
print(is.prime(3))
print(is.prime(2))