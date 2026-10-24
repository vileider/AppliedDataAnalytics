library(tidyverse)
#copying from week5
if (Sys.info()[["sysname"]] == "Windows") {
  setwd("C:/projects/AppliedDataAnalytics/datasets")
} else if (Sys.info()[["sysname"]] == "Linux") {
  setwd("~/admin/projects/AppliedDataAnalytics/datasets")
}
#After brief look at week 6 tasks...

# R for Data Science says:

# name <- function(arguments) {
#   body
# }

#I will try my luck

add_this <- function(a,b) {
  a + b
}

add_this(2,3)
#..5

# Exercise 1
# Write a function that takes in two vectors (of numbers)
# and subtracts the first from the second.

#Attempt 1
#this should be easy
substract_vector <- function(vect1,vect2){
  vect2 - vect1
}

#creating vectors:
# R for Data Science
#" create vector of primes
#primes <- c(2, 3, 5, 7, 11, 13)"
a <- c(1, 3)
b <- c(4, 6)

substract_vector(a,b)
#... 3 3

# Exercise 2
# Write a function that takes in a vector of characters
# and sticks them together to form a word.
# Extend this function to include an additional argument
# that tells the function whether the result should be 
# a sentence or a word. If the result should be a sentence,
# we should have spaces between the words.

#Attempt 1
#R for Data Science
#chapter 14.3.3 str_flatten() 
#says:
#"str_flatten(c("x", "y", "z"))
#> [1] "xyz" "

stick_together <- function(chars) {
  str_flatten(chars)
}

totally_random_letters <- c("A", "n", "d", "r","e","w")

stick_together(totally_random_letters)

#R for Data Science
#chapter 14.3.3 str_flatten() 
#says:
#str_flatten(c("x", "y", "z"), ", ")
#> [1] "x, y, z"

is_it_phrase <- function(chars,is_it){
  if(is_it)
    str_flatten(chars, " ")
  else
    str_flatten(chars)
}

is_it_phrase(c("Andrew", "is", "the", "best"),TRUE)
#..We know what ;]
             