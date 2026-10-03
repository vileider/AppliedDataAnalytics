#PACKAGES

library(tidyverse)
library(Lahman)
library(nycflights13)

#Tibble - QoL data.frame version. Used mainly in tidyverse. It shows column type better and does
# not overflow  console with all dataset. Data stays the same, only the ways of use and display slightly changes


Batting <- as_tibble(Batting)
Pitching <- as_tibble(Pitching)
Salaries <- as_tibble(Salaries)
People <- as_tibble(People)
#class(Lahman::Batting)
#class(Batting)
#is_tibble(Lahman::Batting)
#is_tibble(Batting)
# Batting
# Week 3 - Joining Datasets
# We will continue to work with the Lahman package and the large datasets present
# there to practice *_join(). The tasks below make use of different *_join()
# functions and require different versions of the join_by(col1 == col2) argument.
# 
# Exercise 1
# By joining the Salaries dataset with the Batting datasets,
# pick recent year and plot the salary of every player who 
# played more than 50 games (Hint: G > 50) against the number
# of HR (Home Runs) or RBI (Runs batted in). Can we use both variables?
#   
# Do the same with the Salaries dataset and the Pitching dataset
# and plot salary against ERA (Earned Run Average) or W (Wins) 
# for those pitchers who had started more than 10 games (GS > 10). Can we use both variables?

# names(Salaries)
# names(Batting)
#Finding same columns
#intersect(names(Salaries), names(Batting))

# Salaries %>%
#   select(all_of(intersect(names(Salaries), names(Batting))))
# Salaries %>%
#   select(all_of(intersect(names(Batting), names(Salaries))))

# Attempt 1
# I just realized I dont know much about baseball :(
# I had to refresh my memory what is batting and pitching 
# also I had to write what join is
#inner- only player present on both tables(ex. aardsda01 present on Batting and Pitching)
#left- all from left, ones from right only if match
#right -  -//- but oposite
#full- all from both
#semi - keep only matching rows from left, no columns added from right.
# tldr: filtering and joining

# Batting %>%
#   semi_join(Salaries)
# 
# Batting %>%
#   semi_join(Salaries) %>%
#   select(playerID, yearID, G, HR, RBI)

#Attempt 2
# more_than50_G <- Batting %>%
#     semi_join(Salaries) %>%
#     select(playerID, yearID, G, HR, RBI)
#   
# less_than50_G %>%
#   filter(G>50)

#attempt 3
# recent50s_Gs <- Batting %>%
#   semi_join(Salaries) %>%
#   select(playerID, yearID, G, HR, RBI) %>%
#   filter(yearID == 2026)
# 
# recent50s_Gs
# strange no results hmm...
#attempt 4
# Batting %>%
#   semi_join(Salaries) %>%
#   summarise(latest_year = max(yearID))
#latest  2016
# recent50s_Gs <- Batting %>%
#   semi_join(Salaries) %>%
#   select(playerID, yearID, G, HR, RBI) %>%
#   filter(yearID == 2016,G >50)
# 
# recent50s_Gs
# ok i have my G's

# ggplot(recent50s_Gs,aes(x=HR))+
#   geom_bar()
# 
# ggplot(recent50s_Gs,aes(x=HR, y=RBI)) +
#   geom_point(aes(playerID))+
#   geom_smooth()
#this ggplot does not make sense

#Attempt 5
#"against the number
# of HR (Home Runs) or RBI (Runs batted in)"
# now there is a question if a player doesn haave a record of HR or RBI should I
# Include him? For the purpose of this task I will exclude them
# recent50s_Gs <- Batting %>%
# filter(yearID == 2016, G > 50)
#only 2016 and more than 50 games

# recent50s_with_salary <- recent50s_Gs %>%
#   inner_join(
#     Salaries,
#     by = join_by(playerID, yearID, teamID, lgID)
#   )
#only with sal.... hmm I just realized I need to combine tables first,
# otherwise I will be missing data, an after filter it
#Attempt 6
# Salaries
# hmm there are records of the same player in many years
# combined_tables <- inner_join(
#   Batting,
#   Salaries,
#   by = join_by(playerID, yearID)
# )
# combined_tables
#  but I need to check if a player played for both teams...eh ;/
# Batting %>%
#   group_by(playerID, yearID) %>%
#   summarise(
#     teams = n_distinct(teamID),
#     .groups = "drop"
#   ) %>%
#   filter(teams > 1)
#yes some player played for both teams ;/
#Attempt 7
#looks I need to summarize each player hr or rbi in a year

# Batting <- Batting %>%
#   group_by(playerID, yearID) %>%
#   summarise(
#     G = sum(G),
#     HR = sum(HR),
#     RBI = sum(RBI),
#     .groups = "drop")

#Batting
#and now connect tables
# combined_tables <- inner_join(
#   Batting,
#   Salaries,
#   by = join_by(playerID, yearID))
#   
# combined_tables
# but wait the minute
# Salaries %>%
#   count(playerID, yearID) %>%
#   filter(n > 1)
# yes two team means two salaries ;(
# I need to summrize players sallary, G,RBI,HR in a year 
#Attempt 8

Batting <- Batting %>%
  group_by(playerID, yearID) %>%
  summarise(
    G = sum(G),
    HR = sum(HR),
    RBI = sum(RBI),
    .groups = "drop"
  )
Batting
Salaries <- Salaries %>%
  group_by(playerID, yearID) %>%
  summarise(
    salary = sum(salary),
    .groups = "drop"
  )
Salaries

combined_tables <- Batting %>%
  inner_join(
    Salaries,
    by = join_by(playerID, yearID)
  )

combined_tables
recent50s <- combined_tables %>%
  filter(yearID == 2016, G > 50)

# is home run related to salary?
# ggplot(recent50s, aes(x = HR, y = salary)) +
#   geom_point()
# showed me some funny numbers like "2e+07" I dont understand Chinese
# ggplot(recent50s, aes(x = HR, y = salary)) +
#   geom_point() +
#   scale_y_continuous(labels = scales::comma)
# yup it is
#what about rbi
# ggplot(recent50s, aes(x = RBI, y = salary)) +
#   geom_point() +
#   scale_y_continuous(labels = scales::comma)
#"Can we use both variables?" I am assuming on one ggplot
# I could combine rbi and hr in to one and then do  something like:
#scale_colour_manual(values = c("HR" = "red", "RBI" = "green")..
#or
# ggplot(recent50s, aes(y = salary)) +
#   geom_point(aes(x = HR), colour = "red") +
#   geom_point(aes(x = RBI), colour = "green") +
#   scale_y_continuous(labels = scales::comma)
#player need to make more RBI to get the same salary?
#no it could be the same player
#I need to make that more clear first
# ggplot(recent50s, aes(y = salary)) +
#   geom_point(aes(x = HR, colour = "HR")) +
#   geom_point(aes(x = RBI, colour = "RBI")) +
#   scale_colour_manual(
#     values = c("HR" = "red", "RBI" = "green")
#   ) +
#   labs(
#     x = "Number",
#     y = "Salary",
#     colour = "Statistic"
#   )
#I will try to connect the same player hr and rbi with line
ggplot(recent50s, aes(y = salary)) +
  geom_segment(
    aes(
      x = HR,
      xend = RBI,
      y = salary,
      yend = salary
    ),
    colour = "grey"
  ) +
  geom_point(aes(x = HR), colour = "red") +
  geom_point(aes(x = RBI), colour = "green") +
  labs(
    x = "Number",
    y = "Salary"
  ) +
  scale_y_continuous(labels = scales::comma)
# its hard to interpret this
# Andrew what would you do?
# ok next "Do the same with the Salaries dataset and the Pitching dataset..."
names(Pitching)
# ...i still dont understand baseball
#?Pitching
#help(Pitching)
#IPouts = Outs Pitched (innings pitched × 3)
# https://en.wikipedia.org/wiki/Inning
# 1 inning = 3 outs
# ERA = 9 * ER / innings pitched
# so if there will be different amount of rounds in each Game I cant
# just simply add whole games and divide by the number of games.
# I need to add all ER and divided by its number?

#No! I shall divide by innings, not by games
#ERA is earned runs per 9 innings, so adding up all the ER,
# adding up all the innings, and then:
# ERA = 9 * sum(ER) / sum(innings)
#Lahman doesnt give me direclty innings pitchet, hmm...
# I shoud use: ERA = 27 * sum(ER) / sum(IPouts)
#Attempt 1
Pitching_task1b <- Pitching %>%
  group_by(playerID, yearID) %>%
  summarise(
    GS = sum(GS),
    W = sum(W),
    ER = sum(ER),
    IPouts = sum(IPouts),
    .groups = "drop"
  ) %>%
  mutate(
    ERA = 27 * ER / IPouts
  )

# now I have my dataset
# I need to eliminate those with less than 10 games pick only with recent year


Pitching_task1b <- Pitching_task1b %>%
  filter(yearID == 2016, GS > 10) %>%
  inner_join(Salaries, by = c("playerID", "yearID"))

Pitching_task1b
#lets see how does it look by ERA
ggplot(Pitching_task1b, aes(x = ERA, y = salary)) +
  geom_point() +
  scale_y_continuous(labels = scales::comma)
#it does not appear to be a strong relationship between ERA and salary
# Lets see wins 
ggplot(Pitching_task1b, aes(x = W, y = salary)) +
  geom_point() +
  scale_y_continuous(labels = scales::comma)
#It shows there is a weak relationship between wins and salary.
#I was thinking about using pivot_longer() but it would double the time to process whole dataset
# so I will stay with previous solution
ggplot(Pitching_task1b, aes(y = salary)) +
  geom_point(aes(x = ERA), colour = "red") +
  geom_point(aes(x = W), colour = "blue") +
  labs(
    x = "ERA / Wins",
    y = "Salary"
  ) +
  scale_y_continuous(labels = scales::comma)

#Exercise 2
#Find any players who have more than 20 Home Runs in the Batting 
#dataset and more than 5 Games Started in the Pitching dataset in the same year. 
#Join with another dataset to add their names. What type of *_join() 
#should we be using here
# Comparing to exercise 1 it its easy
