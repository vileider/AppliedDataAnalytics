# DO NOT CHANGE THE PRE-WRITTEN CODE EXCEPT WHERE MARKED
# load package
library(tidyverse)
# Add any additional packages required here


# set seed - PLEASE EDIT
# CHANGE THE VALUE OF 1 TO A NUMBER OF YOUR CHOICE
set.seed(2) 

################################################################################
# code to create three datasets to work with - DO NOT EDIT
# NOTE - comments have been removed
base_price <- rnorm(1, 26.5, 1)

first <- sample(LETTERS[1:3], 1)
second <- sample(LETTERS[1:3][LETTERS[1:3] != first], 1)
third <- sample(c(first, second), 1)

order_of <- sample(c(first, second, third))
exs <- sample(c(-0.1, 0.05, 0.2))

dates <- seq.Date(as.Date("2023/01/01"), as.Date("2026/01/01"), by = "day")

fn1 <- function(dates, this, ex) {
  x <- 0.2 * abs(as.numeric(fn2(dates, this) - dates) / length(dates))
  
  val <- base_price + x + 20*x^2 - 30*x^3 + runif(length(dates), -0.05, 0.05) + ex
  
  val <- str_glue("{round(val, 2)}{sample(c('p', 'P'), 1)}")
  
  val[sample(c(1:length(dates)), size = length(dates)/25)] <- NA
  
  return(val)
}

create_data <- function() {
  
  ds1 <- tibble(date = as.character(dates),
                price = fn1(dates, order_of[1], exs[1])) %>%
    slice_sample(prop = 1)
  ds2 <- tibble(dates = as.character(dates), 
                elec = fn1(as.Date(dates), order_of[2], exs[2])) %>%
    slice_sample(prop = 1)
  ds3 <- tibble(date = as.character(dates), 
                electricity = fn1(dates, order_of[3], exs[3])) %>%
  slice_sample(prop = 1)
  return(sample(list(ds1, ds2, ds3)))
}

fn2 <- function(x, this) {
  switch(this, 
         A = mean(x),
         B = min(x),
         C = max(x))
}

all_datasets <- create_data()
England <- all_datasets[[1]]
Scotland <- all_datasets[[2]]
Wales <- all_datasets[[3]]
################################################################################
# The datasets England, Scotland and Wales should now exist.
# Please enter code below to complete the outlined tasks.
# PLEASE EDIT THE AREA BELOW

# What is in the datasets? 
names(England)
names(Scotland)
names(Wales)

glimpse(England)
glimpse(Scotland)
glimpse(Wales)
# Join the three datasets together
# ADD CODE AND COMMENTS HERE

#first thing I noticed is Two differed column name "date" nad "dates"
# I am assuming "price", "electericity" and "elec" means the ELECTRICITY PRICE
# In all 3 datasets date is as a "chr" I think it should  be date
# the ELECTRICITY PRICE columns are "glue" type what is it?..
# R for Data Science 2e, Chapter 14, section 14.3.2
# str_glue() creates strings using the glue package.
#From my research I cant just use simply str_unglue()
#That would be to easy just with "glue" there are also "NA's" just
#in ELECTRICITY PRICE("kWh of electricity") on a first glimps.
#I will need to check it
#I will need to use some funciton to simplify that and be able to recreate fo each dataset
#(edit: I just noticed I have to join those datasets first)
#(edit: but I can do it in any order I want)
#I need to check if the same dates are present in each datasets before inner_join
setequal(England$dates, Wales$date) &&
  setequal(England$dates, Scotland$date)
#..ok dates are the same in each dataset
#.. now I want to prepare some function just for fun
change_column_name <-function(dataset, oldColumnName, newColumnName){
  dataset %>%
    rename_with(
      ~ newColumnName,
      all_of(oldColumnName)
    )
}
# ok now I need to make sure coulmn names are all the same in each dataset
England <- change_column_name(England, "dates", "date")
England <- change_column_name(England, "elec", "ELECTRICITY PRICE")
Scotland <- change_column_name(Scotland, "electricity", "ELECTRICITY PRICE")
Wales <- change_column_name(Wales, "price", "ELECTRICITY PRICE")
#lets check this out
names(England)
names(Scotland)
names(Wales)
#ok all good, I need to bind rows now
combined_data <- England %>%
  select(date, England = `ELECTRICITY PRICE`) %>%
  inner_join(
    Scotland %>% select(date, Scotland = `ELECTRICITY PRICE`),
    by = "date"
  ) %>%
  inner_join(
    Wales %>% select(date, Wales = `ELECTRICITY PRICE`),
    by = "date"
  ) %>%
  pivot_longer(
    cols = c(England, Scotland, Wales),
    names_to = "where",
    values_to = "ELECTRICITY PRICE"
  )
#or I could do:
# combined_data <- bind_rows(
#   England = England,
#   Scotland = Scotland,
#   Wales = Wales,
#   .id = "where"
# )
#but I did not know if you wanted me to literally use join method
combined_data

# Clean the data - ensure to identify the problems in the data
# and how you have fixed them
# ADD CODE AND COMMENTS HERE

combined_data
#its:
# A tibble: 3,291 × 3
# where   date       `ELECTRICITY PRICE`
# <chr>   <chr>      <glue>             
#   1 England 2025-04-25 25.87P 
# I would prefer to have date as first column and as "date" type
# I can do it in one go
combined_data <- combined_data %>%
  relocate(date) %>%
  mutate(date = as.Date(date))

combined_data
#ok I have it, Now I need to do something with "glue" electric price
#I must get rid of "p's" and turn it into a number if I want to use this column 
#in a ggplot that make sense.
combined_data <- combined_data %>%
  mutate(
    `ELECTRICITY PRICE` = str_replace_all(`ELECTRICITY PRICE`, "[pP]", ""),
    `ELECTRICITY PRICE` = as.numeric(`ELECTRICITY PRICE`)
  )
combined_data
#I think that is it
#I see I forgot to sort it out(by date) before visualisation
combined_data <- combined_data %>%
  arrange(date)

combined_data
#I almost fogot about NA
sum(is.na(combined_data$`ELECTRICITY PRICE`))
#129 records
combined_data <- combined_data %>%
  filter(!is.na(`ELECTRICITY PRICE`))

sum(is.na(combined_data$`ELECTRICITY PRICE`))
#now is 0
# Create at least two visualisations of the data
# ADD CODE AND COMMENTS HERE

#Lets do ggplot wher I could see the rising price(I presume), over time in each country
ggplot(
  combined_data,
  aes(
    x = date,
    y = `ELECTRICITY PRICE`,
    colour = where
  )
) +
  geom_line(linewidth = 0.8) +
  labs(
    title = "Electricity price over time",
    x = "Date",
    y = "Electricity price (p/kWh)",
    colour = "Country"
  ) +
  guides(
    colour = guide_legend(
      override.aes = list(linewidth = 2)
    )
  )
#I added thicker line in legend to see each coutry clearly
#It is a suprise for me seeing that actualy England and Scotland is going down but Wales
#EP is going up, but after a moment I realised "data represents the fictional value"
#Ok lets think what data other ggplot could be interesting
#I want to se how prices changed between winter and Summer
#(or I would say ther is only Autumn and spring in UK)
#but on 3 separate face wraps
season_data <- combined_data %>%
  mutate(
    season = case_when(
      month(date) %in% c(12, 1, 2) ~ "Winter",
      month(date) %in% c(6, 7, 8) ~ "Summer",
      TRUE ~ NA_character_
    )
  ) %>%
  filter(!is.na(season))
#I have created a new dataset just for Winter and summer based on combined_data

ggplot(
  season_data,
  aes(
    x = season,
    y = `ELECTRICITY PRICE`,
    fill = season
  )
) +
  geom_boxplot() +
  facet_wrap(~where) +
  scale_fill_manual(
    values = c(
      "Winter" = "blue",
      "Summer" = "orange"
    )
  )
#I had to add colors to each season because ggplot gave warm color for Winter
# and cold color for Summer(oryginally) -it was misleading for me like I would write
#"this is a red phrase" with blue pen
# ok, the ggplot show in Wales prices were slightly highier during the Summer
# In England and Scotland it stays as expected electricity prices are highier during the winter
# Lets think what else could I show
#I could just use the simplest ggplot wher I show average price
#I need to prepare data setfirst
average_price <- combined_data %>%
  group_by(where) %>%
  summarise(
    average_price = mean(`ELECTRICITY PRICE`, na.rm = TRUE)
  )

average_price
#and now
ggplot(
  average_price,
  aes(
    x = where,
    y = average_price,
    fill = where
  )
) +
  geom_col() +
  geom_text(
    aes(label = round(average_price, 2)),
    vjust = -0.5
  ) +
  labs(
    title = "Average Electricity Price by Country",
    x = "Country",
    y = "Average electricity price (p/kWh)"
  ) +
  coord_cartesian(ylim = c(25, 26.2)) +
  theme(
    legend.position = "none"
  )
#Diference between average price is so small that I had to start from 25
#It shows that England has the highiest average prices, than scotland and 
#Wales has the smallest average price


# Critically evaluate your choices and code
# For example (but not limited to)
#   - Why are your visualisations appropriate?
#   - Could your visualisations be improved?
#   - Were you successful in cleaning the data?
# ADD COMMENTS HERE

#I think my visualisations are appropriate because they show most 
#Interesting data plots, at lease for me. 
#the visualsations could be improved by adding more data frm differend datasets
# I could get wider range of dates or more countries(Irland, etc)
#I think I catch all the problems in oryginal dataset and I managed to clear the data