library(tidyverse)
#library(lubridate)


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
# Exercise 3
# Clean and tidy the dataset. This file is still large enough to
# be opened in RStudio or another program to help us find the problematic values.
# How could we do this without being able to open it?
#   
# Examine what the different columns are stored as.
# You will need to remove certain parts of strings and then convert from character to numeric.
# 
# Things to consider:
#   
#   Are the columns the correct type?
#   
#   What is in column X8?
#   
#   Why are the columns mostly read in as characters?
#   
#   Are all the numbers converting from character to number correctly?
#   
#   * is a special character, so you will need to use 
# the regular expression "\\*" when trying to remove or replace it.
# 
# Hint 1: Check the most recent years.
# 
# Hint 2: Opening the tsv file on its own (before importing it) might help with this example.
#Attempt 1
#investigating X8
# nairn_raw %>%
#   count(X8, sort = TRUE)
# hmm... 
names(nairn_raw)
#no such a column X8 there is only "...8"
nairn_raw %>%
  count(...8, sort = TRUE)
#what is the "||"
nairn_raw %>%
  filter(`...8` == "||")
#1998 and lots of "---", where are "---" empty spaces
# lets use function from previous task

nairn_raw %>%
  filter(
    if_any(
      everything(),
      ~ str_detect(as.character(.x), "---")
    )
  )
# lots of columns with numbers as a chr because of "---"?
#I will use a special character given in task
nairn_raw %>%
  filter(
    if_any(
      everything(),
      ~ str_detect(as.character(.x), "\\*")
    )
  )
#Is "*" causing columns to be a string?
#I think I need to remove * and --- into NA
#R for Data Science- Regular expressions:
# x <- c("apple", "pear", "banana")
# str_replace_all(x, "[aeiou]", "-")

#so I can try
nairn_almost_clean <- nairn_raw %>%
  mutate(
    across(
      3:7,
      ~ str_replace_all(.x, "\\*", "")
    )
  )
nairn_almost_clean
#ok so I get rid of *, now I need to replace ---
nairn_clean <- nairn_almost_clean %>%
  mutate(
    across(
      3:7,
      ~ str_replace_all(.x, "---", NA_character_)
    )
  )

nairn_clean 
#looks ok lets chcek it
nairn_clean %>%
  filter(
    if_any(
      everything(),
      ~ str_detect(as.character(.x), "---|\\*")
    )
  )
#it did not detect anything, now I need to convert those into number(numeric)
nairn_cooked <- nairn_clean %>%
  mutate(
    across(
      3:7,
      as.numeric
    )
  )
nairn_cooked
#lets check something
summary(nairn_cooked)
glimpse(nairn_cooked)
#looks good
# Exercise 4
# Create a date column using the ymd() or make_date() functions from the lubridate package.
# 
# Note: This needs to be loaded separately as it isn’t part of the tidyverse.

#Attempt 1
#adding lubridate library at the top but...
#It works without it, latest tidyverse has it already
#Andrew you can update brightspace <3

#I will use make_date

nairn_cooked <- nairn_cooked %>%
  mutate(
    date = make_date(
      year = yyyy,
      month = mm,
      day = 1
    )
  )

class(nairn_cooked$date)
#all good

# Exercise 5
# Having created a date column plot the data over time
# to see if any trends can be established. Can you use geom_smooth() to help?

#Atempt 1
nairn_cooked
#what is max temperature in years?
ggplot(nairn_cooked, aes(x = date, y = `tmax (degC)`)) +
  geom_point()
#that is too much data..
#I need average each month
nairn_monthly_temp <- nairn_cooked %>%
  mutate(
    average_temp = (`tmax (degC)` + `tmin (degC)`) / 2
  )
#and lets test it
ggplot(nairn_monthly_temp, aes(x = date, y = `tmax (degC)`)) +
  geom_point()

#Attempt 2
#I forgot I changed the column name

ggplot(nairn_monthly_temp, aes(x = date, y = average_temp)) +
  geom_line() +
  geom_point()+
  geom_smooth()

#hmm this does not seem to show much trend
#looks stable
#what if I will take yearly avaerage temp
#renaming because I can
nairn_monthly_temp <- nairn_monthly_temp %>%
  rename(year = yyyy)
#geting average
nairn_yearly_temp <- nairn_monthly_temp %>%
  group_by(year) %>%
  summarise(
    average_yearly_temp = mean(average_temp, na.rm = TRUE),
    .groups = "drop"
  )
#and..
ggplot(nairn_yearly_temp, aes(x = year, y = average_yearly_temp)) +
  geom_line() +
  geom_point()+
  geom_smooth()
#average temp going down and up slowly, since ~1967
#every 25year average_yearly_temp lowest temp is much lower than in other years


#Extension Work
#Try cleaning the other weather datasets. 
#Note: There are additional problems to those identified above in some of the other datasets.

braemar_raw<- read_tsv("braemar_raw.tsv")
braemar_raw
#looks like the same story
braemar_clean <- braemar_raw %>%
  mutate(
    across(
      3:7,
      ~ str_replace_all(.x, "---", NA_character_)
    )
  )

braemar_clean %>%
  mutate(
    across(
      3:7,
      as.numeric
    )
  )
#looks like braemar_clean is not so clean
braemar_clean
#lets find what is not numeric
braemar_clean %>%
  filter(
    if_any(
      3:7,
      ~ !is.na(.x) & str_detect(.x, "[^0-9.-]")
    )
  )
# ok I have seen that * before
braemar_clean <- braemar_clean %>%
  mutate(
    across(
      3:7,
      ~ str_replace_all(.x, "\\*", "")
    )
  )
#one more time
braemar_clean %>%
  mutate(
    across(
      3:7,
      as.numeric
    )
  )
#warning again
braemar_clean
#lets try to find what is causing the issue
braemar_clean %>%
  filter(
    if_any(
      3:7,
      ~ !is.na(.x) & is.na(suppressWarnings(as.numeric(.x)))
    )
  )
# "#NAME"?, oh no!
#i need to change that into NA
braemar_clean <- braemar_clean %>%
  mutate(
    across(
      3:7,
      ~ str_replace_all(.x, "#NAME\\?", NA_character_)
    )
  )
#and lets hope this thime it will work
braemar_cooked <- braemar_clean %>%
  mutate(
    across(
      3:7,
      as.numeric
    )
  )
braemar_cooked
#yay!