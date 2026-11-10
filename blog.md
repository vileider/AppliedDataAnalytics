12/0/2026
I had to install everything again because of some technical issues. At least this gave me another opportunity to look at packages, IDEs and different ways of installing packages.

RStudio looks a bit strange to me at first. I could not get dark mode working, so for now I will use both VS Code and RStudio.

The visualisation I like the most so far is geom_hex(). I also like facet_wrap() because it allows me to look at different parts of the dataset at the same time.
19/9/2026
library(tidyverse)

names(starwars)

select(starwars, name, homeworld, species)

names(starwars) shows the column names. Then select() reduces the dataset to three columns: name, homeworld and species.
20/9/2026
In the Hurricane Andrew exercise, I could see a relationship between wind speed and pressure. When pressure decreased, the wind speed generally increased.

I found geom_smooth() more useful than just connecting the points with a line because it was easier to see the overall trend.

I also liked using the leaflet library. Plotting latitude and longitude on an interactive map made more sense to me than looking at them as normal x and y values. I could zoom in and follow the path of the storm.
26/9/2026
At first, joins looked more complicated than they actually are. I initially thought that the whole row needed to match, but the join only compares the columns selected as keys, for example playerID and yearID.

The different joins decide which rows are kept. inner_join() keeps matching rows from both tables, while left_join() keeps all rows from the left table. semi_join() is a bit different because it filters the left table based on matches, but does not add columns from the right table.

Missing values in join columns also need attention. By default, dplyr can match an NA key with another NA key. This does not mean the missing values have been filled in, and I need to think about whether matching them makes sense for my data.
28/9/2026
I am starting to see that working with R is not only about writing code. Understanding the data is important as well. Filtering, joining and plotting are easier once I know how the data is structured, but I still need to decide how to group or summarise it.
03/10/2026
While listening to Andrew’s video, I was wondering why CSV is used instead of JSON.
04/10/2026
pivot_longer() was confusing at first because it looked like it was just making the table longer. Now I can see why long format can be useful for plotting and grouping.

I am still thinking about the cost of this with a very large dataset, because the number of rows can increase a lot.

I also spent some time on factors. I originally thought factor levels would automatically have a logical order, but that is not necessarily the case. fct_rev() just reverses the existing order; it does not decide what the correct order should be.

Another thing I learned is the difference between geom_bar() and geom_col(). geom_bar() counts observations, while geom_col() uses values that are already in the data. The error message confused me at first, but the difference makes sense now.
10/10/2026
Today I worked with regular expressions using stringr. Regex itself is familiar to me, but using str_detect() with filter() and if_any() was new. if_any() was useful because I could apply the same condition to several columns without writing it separately for each one.

I also continued working with factors. Functions such as fct_rev() and fct_infreq() can change their order, but I still need to decide which order makes sense for the data.

I looked at project structure as well. Hard-coded setwd() paths can work on my computer, but they can cause problems if I move the code somewhere else. An RStudio Project with relative paths seems more practical, especially when working across Windows and Linux.
11/10/2026
Today I spent more time cleaning data than writing complicated code.

When as.numeric() warned that it had introduced NA values, I used the warning to investigate the original values. This helped me find a #NAME? problem in the Braemar dataset that I had not seen in Nairn.

It showed me why it is useful to check the values before converting them. Once an invalid string has been converted to NA, I cannot see the original problem from that value alone.

I also compared monthly and yearly weather plots. The monthly data mainly showed seasonal changes, while yearly averages made it easier to look at longer-term temperature changes.

For the extension, I started thinking about putting the cleaning steps into a function. The same function could be reused, but I would still need to check each dataset for different problems.
24/10/2026
Today I started working with custom functions in R. I already know the general idea from other programming languages, but vectorisation is more noticeable in R. For example, I can subtract two vectors without writing an explicit loop.

I also used str_flatten() from R for Data Science to create a function that joins a character vector. Then I added a Boolean argument so the function could either join the characters directly or add spaces between them.

This felt closer to the type of programming I am used to because I was putting existing functionality into a reusable function.
25/10/2026
I continued working with custom functions today. I ended up spending more time on edge cases than on the original exercises.

My median function worked for normal even and odd vectors, and I reused my earlier mean function to calculate the result for the two middle values. However, a vector containing only NA values caused a problem.

After removing the missing values, the vector had a length of zero. My is_even() function treated zero as even, so the median function followed the wrong branch and eventually returned NaN.

I changed the helper logic so that positive even and odd lengths are handled separately, and an empty vector goes into its own branch.

I also thought about what the function should return when it cannot calculate a median. Returning a string would be awkward if I wanted to use the result in another calculation, so displaying a message and returning NA seemed more useful.

I split the implementation into smaller functions and reused temp_mean2() instead of repeating the calculation.
8/11/2026
I started by checking which columns should be numeric. I created check_numeric_columns() to calculate the percentage of values in each column that could be interpreted as numbers.

The weather columns were around 98–99% numeric, but the extra ...8 column was different. I used inspect_column() to check its values and how often they appeared. Most were NA, with a small number marked Provisional or ||, so I decided not to keep this column.

I also created reusable functions for changing column types and combining columns. When combining yyyy and mm, I noticed that a standard R Date needs a day, but the dataset only represents months. I used the zoo package and added support for yearmon to my type-conversion function.

Next, I looked at the weather values that could not be converted to numbers. The main non-numeric value I found was ---. I used a loop over the names of the weather columns instead of calling the same cleaning function five times.

Once the individual steps worked, I combined them into read_clean_weather(filepath). The function takes a filename and returns a cleaned dataset. I then moved the functions into a separate .R file and loaded them with source().

I tested the same code with dunstaffnage_raw.tsv. It worked without creating a separate cleaning script, which was the reason I wanted to make the functions reusable.

For the extension, I changed the row-cleaning function to use tidy evaluation. With {{columns}}, I could pass unquoted column names to the function and use if_all() instead of looping through them individually. It reminded me slightly of passing property references or expressions in JavaScript, although the way R handles it is different.

One thing I still need to consider is whether removing a whole row when one measurement is missing is the right decision. It also removes the other measurements for that month. Keeping the row and replacing the missing measurement with NA might preserve more information.