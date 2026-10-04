# 12/0/2026
I had to install everything again due to technical issues, but it allowed me to take another look at packages, IDEs, and alternative ways of installing packages.

RStudio seems a bit odd at first glance. I can’t get dark mode working, so I will work with both VS Code and RStudio.

The best data visualisation for me so far is geom_hex().

Also, facet_wrap() shows more possibilities for viewing different parts of a dataset at the same time.

# 19/9/2026
code
```
library(tidyverse)
names(starwars)
select(starwars,name,homeworld,species)
```
 ```names``` are executed and then 
starwars  `shrink` into 3 collumns

# 20/9/2026
One of my main insights from this exercise was seeing the relationship between wind speed and pressure. For Hurricane Andrew, the plot showed that as pressure decreased, wind speed generally increased. I found geom_smooth() more useful than simply connecting the points with a line because it made the overall trend much easier to see.

I also really liked using the leaflet library. Plotting latitude and longitude on an actual interactive map made much more sense than treating them as normal x and y values. Being able to zoom in and follow the storm path made the data much easier to understand and showed me how useful R can be for geographical data visualisation.

# 26/9/2026
My main thought about joins is that at first they looked more confusing than they actually are. The important thing is that the whole row does not need to be identical. The join only compares the columns we choose as keys, for example playerID and yearID.

I also realised that the different joins are mainly about deciding which rows should stay. inner_join() keeps only matching records from both tables, left_join() keeps everything from the left table, while semi_join() works more like a filter because it keeps matching rows from the left table without adding columns from the right table.

One thing I found interesting is how joins deal with missing values. If one table has NA in a key column, R cannot simply take the value from the other table because there may be more than one possible match. At first this seemed unnecessary, but it makes sense because automatically filling missing values could easily create incorrect data.
### 28.9.2026
I am starting to notice that R is less about writing complicated code and more about understanding what the data represents. Once the dataset is structured correctly, operations such as filtering, joining and plotting are relatively straightforward. The difficult part is deciding how the data should be grouped or summarised before applying those operations.
### 03/10/2026
While listeinig Andrew's Video I was thinking on why CSV not json?
### 04/10/2026
I am starting to understand that most of the difficulty in R is not the syntax itself, but understanding what R is actually doing to the data. pivot_longer() was a good example. At first it looked like an unnecessary way of making the table much longer, but I can now see why long format is useful for plotting and grouping. I still think it is worth remembering that this convenience comes at a cost, because with a very large dataset the number of rows could increase dramatically.

Factors were also less obvious than I expected. I originally assumed that factor levels would somehow represent a logical order, but R simply uses the order of the levels it is given, often alphabetical. fct_rev() does not make that order more meaningful, it literally just reverses it. That made me realise that I need to understand what the categories actually represent before deciding how they should be ordered.

Another thing I noticed is that similar-looking plotting functions can behave quite differently. geom_bar() counts observations itself, while geom_col() expects me to provide the values. The error message was confusing at first, but after understanding that distinction it actually made sense.