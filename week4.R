library(readr)

library(tidyverse)
getwd()
setwd("C:/projects/AppliedDataAnalytics/datasets")
getwd()
#ok, all is set
student_marks <- read.csv("student_marks.csv")
class(student_marks)
names(student_marks)
