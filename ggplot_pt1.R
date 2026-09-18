# packages
# load packages
library(ggplot2)
library(dplyr)
library(nycflights13)
library(patchwork)
library(tidyverse)
library(nycflights13)
# the data
# diamonds
# storms
# flights
#names(flights)
diamonds_sample = sample_n(diamonds,1000)
names(diamonds_sample)

# scatter plot
# ggplot(diamonds, aes(x= carat, y=price)) + 
#   geom_point()

# first plot
# ggplot(diamonds, aes(x = carat, y = price)) +
#   geom_point()

# storms package
# storms = filter(storms, year == 2015)
# ggplot(storms, aes(x = wind, y = pressure, colour = name)) +
#   geom_point() +
#   geom_path()

# # first attempt:
# print(ggplot(flights, aes(x= year, y= sched_dep_time )) +
#   geom_point()
# )

# second
# print(ggplot(flights, aes(x= month, y= sched_dep_time )) +
#         geom_point()
# )

#third
# ggplot(flights, aes(x= distance, y= air_time, colour=origin )) +
#          geom_point()

#fourth
 # ggplot(flights, aes(x= distance, y= air_time )) +
 #          geom_point() +
 #    facet_wrap(.~origin)

#Exercise 4
#Experiment using one of the datasets that we’ve looked at already to create a plot with either
#facet_wrap() or the patchwork package (loaded above).

# attempt 1
# ggplot(diamonds_sample, aes(x=carat, y=price, colour=cut)) +
#   geom_point()
 
#atempt 2
# ggplot(diamonds_sample, aes(x=carat, y=price, colour=cut)) +
#   geom_point() +
#   facet_wrap(.~depth)

# attempt 3
ggplot(diamonds_sample, aes(x=carat, y=price)) +
  geom_hex() +
  scale_fill_viridis_c() +
  facet_wrap(.~cut)
