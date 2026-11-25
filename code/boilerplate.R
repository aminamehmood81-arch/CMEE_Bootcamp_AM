# Author: Amina Mehmood <amina.mehmood26@imperial.ac.uk>
# Script: boilerplate.R
# Desc: A boilerplate R script: one function with two arguments, and two test calls
# Arguments: None
# Date: Oct 2026

my_function <- function(arg1, arg2) {
  
  # Statements involving arg1, arg2:
  print(paste("Argument", as.character(arg1), "is a", class(arg1))) # print arg1's type
  print(paste("Argument", as.character(arg2), "is a", class(arg2))) # print arg2's type
    
  return (c(arg1, arg2)) #this is optional, but very useful
}

my_function(1,2) #test the function
my_function("riki","Tiki") #A different test