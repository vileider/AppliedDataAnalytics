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
             

#Exercise 3
#Write a version of a “Hello World!” function in R.

#Attempt 1
"Hello World"
print("Hello World!")
#ok, both works

hi_method <- function() {
  "Hello hello, have a good day"
}

hi_method()
#ok works good

#Exercise 4
#Write your own function to calculate the mean
#(average value) from a vector.
#How are you going to deal with missing values?
#You should feel free to use the sum() function as 
#it will be the most efficient method, aside from actually 
#using the mean() function

#Attempt 1
#I will try to create function that will do the same as "mean()"

temp_mean <- function(var){
  sum(var)/ length(var)
}

temp_mean(c(3,6,9))
#..6
# but what about missing values?
# I will try to filter only values I need

temp_mean2 <- function(var){
  new_var <- var[!is.na(var)]
  sum(new_var)/ length(new_var)
  
}
temp_mean2(c(3,6,9,NA))
#I could do temp_mean2 shorter but I would loose readability
#JavaScript does something similar with filter
#const newVar = var.filter(x => x != null);

#Extension Work
#Write your own function to calculate the median (middle) value
#from a vector. How are you going to deal with missing values?

#Attempt 1
#median will be easy to make
#I need to be consider what to do with even amount of values
# and create more functions

is_even <- function(number) {
  number %% 2 == 0
}

temp_median <- function(var) {
  
  new_var <- var[!is.na(var)]
  new_var <- sort(new_var)
  
  n <- length(new_var)
  
  if (is_even(n)) {
    
    middle_values <- c(
      new_var[n / 2],
      new_var[n / 2 + 1]
    )
    
    temp_mean2(middle_values)
    
  } else {
    
    new_var[(n + 1) / 2]
    
  }
}

temp_median(c(8, 2, 5, 1, 3,NA))
#now I considered, even, odd, missing values and kept readability..I think
#but what if...
temp_median(c(NA,NA))
#considering exceptions:
#need to fix one method and add one more
is_even2 <- function(number) {
  number > 0 && number %% 2 == 0
}
is_odd <- function(number) {
  number > 0 && number %% 2 != 0
}
temp_median2 <- function(var) {
  
  new_var <- var[!is.na(var)]
  new_var <- sort(new_var)
  
  n <- length(new_var)
  
  if (is_even2(n)) {
    
    middle_values <- c(
      new_var[n / 2],
      new_var[n / 2 + 1]
    )
    
    temp_mean2(middle_values)
    
  } else if (is_odd(n)) {
    
    new_var[(n + 1) / 2]
    
  } else {
    
    message("Sorry, but your vector is empty or contains only missing values.")
    NA
    
  }
}
temp_median2(c(NA,NA))
#I had to add "message()" to return value not a message