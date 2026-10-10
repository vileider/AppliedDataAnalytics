library(tidyverse)



#Using your method Andrew :
Sys.info()
#it returns a list of information 
#I would rather:
Sys.info()[["sysname"]]
#and
if (Sys.info()[["sysname"]] == "Windows") {
  setwd("C:/projects/AppliedDataAnalytics/datasets")
} else if (Sys.info()[["sysname"]] == "Linux") {
  setwd("~/admin/projects/AppliedDataAnalytics/datasets")
}
# now checking the path
getwd()
# yes I am working in Windows(..this time)
#Ok now lets bac to task for week 5

# Exercise 1
# Load the dataset reg_exp_test.csv and complete the following tasks, 
# the starting point of the code needed is included:
#   
#   str_detect(dataframe$column_to_check, "INSERT REGULAR EXPRESSION")
# # or 
# filter(dataframe, str_detect(column_to_check, "INSERT REGULAR EXPRESSION"))
# find the rows in col3 that have a space
# For a particular columns try to
# 
# find those rows that contain at least two letters
# find those rows that start with two letters
# find those rows with more than three numbers
# Extension (Difficult): Can this be combined with if_any() and filter() 
#to apply it to all columns? Hint: Have a read of this part of the colwise vignette.
#Attempt 1
reg_exp_test <- read_csv("reg_exp_test.csv")
reg_exp_test
#all good
#col 3 has space between letters so
reg_exp_test %>%
  filter(str_detect(col3, " "))
#1 nzg   Y     a a   1432
#in other words..
str_detect(reg_exp_test$col3, " ")
#ok one filters other shows the results
str_detect(reg_exp_test$col3, "[A-Za-z]{2,}")
#A-z any letter from A to z, {2,} at least two times
#it supposed to show FALSE  TRUE  FALSE  TRUE but is :  FALSE  TRUE FALSE FALSE hmm...
#Attempt 2
str_detect(reg_exp_test$col3, "[A-Za-z].*[A-Za-z]")
#this look better
#and now filter
reg_exp_test %>%
  filter(str_detect(col3, "[A-Za-z].*[A-Za-z]"))
#works like a charm
#"^"-starts with
str_detect(reg_exp_test$col1, "^[A-Za-z]{2}")
reg_exp_test %>%
  filter(str_detect(col1, "^[A-Za-z]{2}"))
#seems right
#next...
str_detect(reg_exp_test$col4, "[0-9]{4,}")
#hmm..  FALSE  TRUE  TRUE  TRUE , first one has 3 digits
#next
#colwise vignette:

# df |>
#   filter(if_any(where(is.numeric), ~ .x > 0))
#leave a row if any numeric column has value more than 0
#or
# df %>%
#   filter(
#     if_any(
#       where(is.numeric),
#       ~ .x > 0
#     )
#   )
#so it means i take everything() from tidyverse and make:
reg_exp_test %>%
  filter(
    if_any(
      everything(),
      ~ str_detect(as.character(.x), "[0-9]{4,}")
    )
  )

#or
reg_exp_test %>%
  filter(
    if_any(
      everything(),
      ~ str_detect(as.character(.x), "[A-Za-z]{3,}")
    )
  )
#where is ZZ two times
reg_exp_test %>%
  filter(
    if_any(
      everything(),
      ~ str_detect(as.character(.x), "Z{2}")
    )
  )


# Exercise 2
# Read in the nairn_raw.tsv file from the provided datasets
# (Source: https://www.metoffice.gov.uk/research/climate/maps-and-data/historic-station-data). 
# Note: This is a tab separated file (rather than a comma separated file)
# and can be loaded using the read_tsv() function from the readr package.

#Attempt 1
nairn_raw <- read_tsv("nairn_raw.tsv")
nairn_raw
glimpse(nairn_raw)
names(nairn_raw)
head(nairn_raw)