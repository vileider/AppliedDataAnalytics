library(tidyverse)
library(zoo)

if (Sys.info()[["sysname"]] == "Windows") {
  setwd("C:/projects/AppliedDataAnalytics")
} else if (Sys.info()[["sysname"]] == "Linux") {
  setwd("~/admin/projects/AppliedDataAnalytics")
}

source("functions/mostly_weather_functions.R")
# Week 7 - Functions Part 2
# Before starting on these exercises, create a new R script and make sure you
# include library(tidyverse) as one of the first few lines.
# Taking the work on reading in and cleaning weather data that we have already
# completed on the nairn_raw.tsv dataset, complete the following tasks.
# This is where we start to really use functions by taking something that worked
# on one dataset and applying it to a nearly identically formed one.
# 1. Rewrite the cleaning steps as a function (or functions)
# 2. Rewrite the reading in of the dataset and cleaning into a function that takes a filepath
# 3. Having tested them, put them it into a separate .R file and use source() to read it in.
# 4. Apply the scripts to dunstaffnage_raw.tsv.
# Do the functions work on both datasets? How about the other weather datasets?
# Extension work
# Create a function (or modify any of your earlier functions) to use tidy evaluation.

my_dataset <- read_tsv("datasets/nairn_raw.tsv")
my_dataset

#I see It is a mess, double on a date, chr on numbers, I am not sure 
#if I will find strange characters on multiple rows hmm..
# I need to start frm something, I need something generic
#I will create a function that will show me which column potentially could be numeric
# I need to consider some amount of errors in datasets or NA
#Let see

check_numeric_columns <- function(dataset) {
  
  dataset %>%
    summarise(
      across(
        everything(),
        ~ round(
          mean(
            !is.na(suppressWarnings(parse_number(as.character(.x))))
          ) * 100,
          2
        )
      )
    ) %>%
    pivot_longer(
      cols = everything(),
      names_to = "column",
      values_to = "numeric_percentage"
    )
}

check_numeric_columns(my_dataset)
#hmm very interesting
# column      numeric_percentage
# <chr>                    <dbl>
#   1 yyyy                     100  
# 2 mm                       100  
# 3 tmax (degC)               98.3
# 4 tmin (degC)               97.9
# 5 af (days)                 98.7
# 6 rain (mm)                 99.2
# 7 sun (hours)               97.8
# 8 ...8                       0  

#ok I see dates are fully numeric that is good
# I see problems from 3rd till 7th column 
# Lets chcek what is causing the issues

my_dataset %>%
  filter(
    if_any(
      3:7,
      ~ is.na(parse_number(as.character(.x))) & !is.na(.x)
    )
  )


#mostly "---" i causing the issues
#I wanto see see what values and what is the % of the column
inspect_column <- function(dataset, column) {
  
  dataset %>%
    count(
      value = .data[[column]],
      name = "count",
      sort = TRUE
    ) %>%
    mutate(
      percentage = round(count / sum(count) * 100, 2)
    )
}
inspect_column(my_dataset,"...8")
# value       count percentage
# <chr>       <int>      <dbl>
#   1 NA           1055      98.3 
# 2 Provisional    17       1.58
# 3 ||              1       0.09

#No point to keep it, 98% NA
my_dataset <- my_dataset %>%
  select(-`...8`)

names(my_dataset)

#ok , I need to take care of 1st and 2nd column
#and change the date, but.. maybe better to create some
#generic function to change column data type
change_column_type <- function(dataset, column, newType) {
  
  converter <- switch(
    newType,
    "double" = as.double,
    "integer" = as.integer,
    "character" = as.character,
    "date" = as.Date,
    "yearmon" = function(x) zoo::as.yearmon(x, format = "%Y-%m"),
    stop("Unsupported data type")
  )
  
  dataset[[column]] <- converter(dataset[[column]])
  
  return(dataset)
}


#another one to combine columns after
combine_columns <- function(dataset, col1, col2, newColumn, separator = "-") {
  
  dataset[[newColumn]] <- paste(
    dataset[[col1]],
    dataset[[col2]],
    sep = separator
  )
  
  dataset <- dataset %>%
    select(-all_of(c(col1, col2)))
  
  return(dataset)
}

my_dataset <- combine_columns(my_dataset,"yyyy","mm","year_month")
names(my_dataset)
my_dataset
#my_dataset <- change_column_type(my_dataset,6,"date")
my_dataset
#"change_column_type" is having issue with date,
#I need a library that will show month and a year only
#install.packages("zoo")
#updating function a little bit and..
my_dataset <- change_column_type(my_dataset,6,"yearmon")
my_dataset
#ok
#another function to cleare rows with non digit values
remove_non_numeric_rows <- function(dataset, column) {
  
  dataset %>%
    filter(
      !is.na(
        suppressWarnings(as.numeric(.data[[column]]))
      )
    )
}

#lets do cleaning in a loop
columns_to_clean <- c(
  "tmax (degC)",
  "tmin (degC)",
  "af (days)",
  "rain (mm)",
  "sun (hours)"
)
#inspeciting first
for (column in columns_to_clean) {
  print(inspect_column(my_dataset, column))
}
#looks ok, I dont see stars or strange characters apart from ---


for (column in columns_to_clean) {
  my_dataset <- remove_non_numeric_rows(my_dataset, column)
}
#I will add array as value next time

my_dataset %>%
  filter(
    if_any(
      1:6,
      ~ is.na(parse_number(as.character(.x))) & !is.na(.x)
    )
  )

#Dataset looks clean
my_dataset
#now lets change all types into inte...double
for (column in columns_to_clean) {
  my_dataset <- change_column_type(my_dataset,column,"double")
}

my_dataset
#looks good nice clean and formated

#AD2 
#now I will try to create whole big function that sorts everything for me
read_clean_weather <- function(filepath) {
  
  dataset <- read_tsv(filepath, show_col_types = FALSE)
  
  dataset <- dataset %>%
    select(-any_of("...8"))
  
  dataset <- combine_columns(
    dataset, "yyyy", "mm", "year_month"
  )
  
  dataset <- change_column_type(
    dataset, "year_month", "yearmon"
  )

  columns_to_clean <- c(
    "tmax (degC)",
    "tmin (degC)",
    "af (days)",
    "rain (mm)",
    "sun (hours)"
  )
  
  for (column in columns_to_clean) {
    dataset <- remove_non_numeric_rows(dataset, column)
  }

  for (column in columns_to_clean) {
    dataset <- change_column_type(dataset, column, "double")
  }
  
  return(dataset)
}

nairn_clean <- read_clean_weather("datasets/nairn_raw.tsv")
nairn_clean
#ok, nice!

#AD.3
nairn_clean2 <- read_clean_weather2("datasets/nairn_raw.tsv")
nairn_clean2
#Works wow, i like it

#AD.4
dunstaffnage_clean <- read_clean_weather2("datasets/dunstaffnage_raw.tsv")
dunstaffnage_clean

#without an issue, nice!


#Ad.Extension work
#as I mentioned before I will modify funciton to add a list as an attribute
remove_non_numeric_rows_tidy <- function(dataset, columns) {
  
  dataset %>%
    filter(
      if_all(
        {{columns}},
        ~ !is.na(suppressWarnings(as.numeric(.x)))
      )
    )
}

#and I would use it 
my_dataset <- remove_non_numeric_rows_tidy(
  my_dataset,
  c(
    `tmax (degC)`,
    `tmin (degC)`,
    `af (days)`,
    `rain (mm)`,
    `sun (hours)`
  )
)
#very simmilar to javascript