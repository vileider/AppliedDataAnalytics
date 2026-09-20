# libraries
library(tidyverse)
library(leaflet)
library(dplyr)
#library(dplyr) tidyverse instead of dplyr etc. separately


# data
#names(starwars)
names(storms)
#storms

#pick columns using select
#select(starwars,name,homeworld,species)

#range
#select(starwars, sex:gender)

#"simply" filter
# filter(starwars, homeworld == "Tatooine", species == "Droid")
# 
# filter(starwars, sex=="female", gender=="masculine")
# filter(starwars, sex=="male", gender=="feminine")
# filter(starwars, sex=="male", gender!="feminine" , gender !="masculine")
# filter(starwars, sex != "male", sex !="female")

# Andrew you did not showed "!" and "c" in video ;] 

#c combine
# filter(starwars, !(sex %in% c("male", "female")))
#Tryign another option:
# filter(
#   starwars,
#   sex != "male" & sex != "female" | is.na(sex)
# )
# with "!(column_name %in%("[value]"))" i exclude [value] and can show all data and n/a as well



#Exercise 1
#Rather than having to type in all the column names we want to select()
#we can use some variations to make choices based on types of data or parts of column names.
# Try these out on the storms dataset.

#attempt 1
# select(storms, year< 2000) BAD!

#attempt 2
 #filter(storms, year < 2000) OK

#attempt 3
#select(storms, where(year < 2000)) BAD!

# attempt 4
#select(storms, where(is.numeric))

#attemt 5
#select(storms(where(2000))) Bad!
#?where
#help(where)
# apropos("^is\\.")
# <- pretty helpfull


#attempt6
# select(storms,(where(is.vector)))
# select(storms,(where(is.Date)))
# select(storms,(where(is.class)))
# select(storms,contains("a")) Ok helpfull if looking for specific column
# select(storms,contains("Amy")) BAD! it sup[sed to be column name


# Exercise 2
# Try working with across() and either everything() 
# or where() to apply the same changes to the storms dataset.

#attempt 1
# more_speed_storms <- mutate(storms, wind_mph = wind * 1.15078)
# more_speed_storms = mutate(storms, wind_mph = wind * 1.15078)
# select(storms,contains("wind_mph"))
# select(more_speed_storms,contains("wind_mph"))

#attempt2
# storms %>%
#   mutate(wind_mph = wind * 1.15078) %>%
#   select(name, year, wind, wind_mph)
# more_speed_storms <- storms %>%
#   mutate(wind_mph = wind * 1.15078) %>%
#   select(name, year, wind, wind_mph)
# 
# more_speed_storms

#attempt 3
# more_speed_storms <- storms %>%
#   mutate(wind_mph = wind * 1.15078) %>%
#   group_by(name) %>%
#   summarise(avg_wind_mph = mean(wind_mph, na.rm = TRUE))
# 
# more_speed_storms
# unique(storms$name)
# storms %>%
#   distinct(name) %>%
#   filter(grepl("^Andrew", name))
# storms %>%
#   filter(name == "Andrew")
# 
# storms %>%
#   filter(name == "Andrew") %>%
#   summarise(avg_wind = mean(wind, na.rm = TRUE))
# 
# storms %>%
#   filter(name == "Andrew") %>%
#   mutate(wind_mph = wind * 1.15078) %>%
#   summarise(avg_wind_mph = mean(wind_mph, na.rm = TRUE))

#attempt 4
#storm_test <- mutate(storms,across(everything(), as.character))
# storm_test <- mutate(storms,across(where(is.numeric), as.character))
# storm_test <- mutate(storms, across(everything(), as.character))
# 
# storm_test <- mutate(storms, across(where(is.numeric), as.character))
# storm_test
# storms
# I think it will be useful when filteringby some character or combining columns

#Exercise 3
#We can order columns using the arrange() function which is 
#often useful when we have done some calculations and want to find
# the biggest/smallest value. Try investigating the use of the count() function,
# combined with arrange() to find the year with the largest number of storms.

#attempt 1
# count(storms, year)
#
# storms %>%
#   count(name, year) %>%
#   arrange(year)

# storms %>%
#   count(name, year,long) %>%
#   arrange(desc(year))

#attempt 2
# storms %>%
#   distinct(year, name) %>%
#   count(year) %>%
#   arrange(desc(n))

# Exercise 4
# Now try combining the select() and filter() and plotting some results using ggplot().
# Using the storms dataset:
#   
#   filter() so only a storm of your choice is shown (watch out for repetitions,
#   you may want to look at a storm combined with a year);
# select() just the name, wind, pressure and category columns;
# plot the wind on the x
# -axis and the pressure on the y
# -axis to observe the path of the storm. Add both points and lines.
# Note: This plot was in the Exercises for Part 1. Feel free to copy/paste.
# Note: You can use the pipe to simplify things slightly but beware using it with ggplot().
# 
# Try adding more storms to this plot and colouring by category.

# attempt1

favourite_storms <- storms %>%
  select(pressure, wind, year, name, category )
# 
# favourite_storms
# 
filtered_favourite_storm <- filter(favourite_storms, (name == "Andrew"))
# filtered_fvourite_storm
# 
# ggplot(filtered_fvourite_storm, aes(x =wind, y=pressure, col=category)) +
#   geom_point() +
#   geom_line()

#attempt 2
# ggplot(filtered_fvourite_storm, aes(x =wind, y=pressure, col=category)) +
#   geom_point() +
#   geom_smooth()

# I think geom_smooth show better the relation between lower pressure and wind
#objects()
#attempt3
# ggplot(filtered_favourite_storm,
#        aes(x = wind, y = pressure)) +
#   geom_point(aes(col = category)) +
#   geom_smooth()

filtered_favourite_storm <- filtered_favourite_storm %>%
  rename(wind_speed = wind)
# #because it is a vague name
# 
# ggplot(filtered_favourite_storm,
#        aes(x = wind_speed, y = pressure)) +
#   geom_point(aes(col = category)) +
#   geom_smooth() +
#   labs(title = "Andrew the huragane")

# 
# Extension Work
# In Exercise 4 we could plot latitude and longitude. However,
# these are values from a spherical coordinate system and
# we would be plotting them as if they weren’t.
# There are several possibly solutions to this which you might
# wish to investigate. This is beyond the content of the module but may be of interest.

# You could try creating a leaflet map which will deal with the latitude and 
# longitude variables appropriately.
# They can be converted into appropriate geometry using several other
# packages such as the sf package.

# Attempt 1
andrew <- storms %>%
  filter(name == "Andrew", year == 1992)

leaflet(andrew) %>%
  addTiles() %>%
  addPolylines(
    lng = ~long,
    lat = ~lat
  )
#very intersting path on the map
