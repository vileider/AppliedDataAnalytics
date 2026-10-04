library(readr)
library(ggplot2)
library(tidyverse)
library(readxl)
#Exercise 1
#Practice using read_csv() and read_tsv() by reading in several of the provided data files.
#Attempt 1
getwd()
setwd("C:/projects/AppliedDataAnalytics/datasets")
getwd()
#ok, all is set
student_marks <- read.csv("student_marks.csv")
#student_marks
student_marks <- read_csv("student_marks.csv")
nairn <- read_tsv("nairn_raw.tsv")
class(student_marks)
names(student_marks)
student_marks
# Exercise 2
# Try writing a dataset to a file and reading it back in again. For example:
#   
#   library(tidyverse)
# write_csv(storms, path = "path/to/file/storms.csv")
# What is your working directory? Have you chosen the Intro to 
#R project to help control it? The way I have set things up 
#in my videos I would need to have:
#   
#   library(tidyverse)
# write_csv(storms, path = "data/storms.csv")
# Optional Extension: Open the storms.csv file in Microsoft Excel 
#and save it as an Excel file. Read this in using
# 
# library(readxl)
# read_excel("path/to/file/storms.xlsx")

#Attempt 1
write_csv(diamonds, file ="diamonds.csv")
#yup, 2.3MB diamonds.csv in my folder
new_old_diamonds <- read_csv("diamonds.csv")
new_old_diamonds
# ok
student_marks_shoveled <- student_marks %>%
  pivot_longer(maths:economics, names_to = "subject", values_to = "mark")
#shovel column into subject and values into mark -it extends the length drastically

# ggplot(student_marks_shoveled,aes(x=subject, mark)) +
#   geom_boxplot()

# to open storms in excel I need to save it first
write_csv(storms, file ="storms.csv")
#opened in excel and saved as a xlcs
storms_from_excel <- read_excel("storms.xlsx")
storms_from_excel
#looks allright

#what about json
#install.packages("jsonlite")
library(jsonlite)

write_json(
  student_marks_shoveled,
  "student_marks.json"
)
data_from_json <- fromJSON("student_marks.json")
data_from_json
# Exercise 3
# From either the storms.csv file or Excel file,
#change the status column into a factor. 
#Are the levels in the correct order? Use this variable with geom_bar().
#Try using fct_rev() to reverse the order of the factors.

#Attempt 1
my_storms <- read_csv("storms.csv")
levels(my_storms$status)
my_storms$status <- factor(my_storms$status)
levels(my_storms$status)
my_storms
levels(my_storms$status)
#levels are not in correct order
ggplot(my_storms, aes(x = status)) +
 geom_bar()
#not really looking good
ggplot(my_storms, aes(x = fct_rev(status))) +
  geom_bar()
#... and thats it, might be useful later

# Exercise 4
# Following the video, read in the student_marks.csv file 
#(which is an entirely made up dataset by the way). 
#This dataset is currently in wide format. 
#Convert it to long format and plot the results 
#for each student with a different colour for each subject. 
#What type of plot are you going to use?

#Attempt 1
#student_marks  are already loaded looks like I did the first part already
# ggplot(student_marks_shoveled,
#        aes(x = student, y = mark, colour = subject)) +
#   geom_point()
#geom point looks like the best choice
#I will try something to make it look better

#what about...
ggplot(student_marks_shoveled,
       aes(x = factor(student), y = mark, colour = subject)) +
  geom_point() +
  labs(
    x = "Student",
    y = "Mark"
  )

#about average score what subject is students "favorite"
favourite_subject <- student_marks_shoveled %>%
  group_by(subject) %>%
  summarise(
    average_mark = mean(mark)
  ) %>%
  arrange(desc(average_mark))

favourite_subject

ggplot(favourite_subject, aes(x=subject, y=average_mark))+
  geom_col()
#economics Rules?