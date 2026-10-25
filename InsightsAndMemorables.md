### two that shows values in funny way
 geom_hex() + 
  scale_fill_viridis_c() # to help show highest values more easily

### default syntax

ggplot(dataset, aes(x = ..., y = ..., col = ..., ...)) +
  geom_*()

### bin vs binwidth
geom_histogram(bins=5) - 5 column
geom_histogram(binwidth =5) - 5 winds per collumn

### checking what is inside  dataset
names(ebola_count)

or more info:

head(ebola_count)


### boxplot- "boxes on a string"
for better visualisation x and y
ggplot(storms, aes(x=name,y=wind))+
geom_boxplot()

Jasne, teraz widzę format. Insights u Ciebie to krótkie techniczne notatki typu cheat-sheet, a blog to dłuższe własne przemyślenia. Na dziś dopisałbym tak:
Insights
### factor
factor = categorical data with levels
my_storms <- my_storms %>%
  mutate(status = factor(status))

check levels:
levels(my_storms$status)

fct_rev() - reverses factor levels, it does NOT make them logically ordered
fct_infreq() - orders factor levels by frequency
### regex - str_detect()
str_detect(column, "pattern")

examples:
" "              # contains a space
"[A-Za-z]{2,}"   # 2 or more letters together
"^[A-Za-z]{2}"   # starts with 2 letters
"[0-9]{4,}"      # 4 or more numbers together
"Z{2}"           # ZZ

^ = start of string
{2} = exactly 2
{2,} = 2 or more
### if_any() - check multiple columns
reg_exp_test %>%
  filter(
    if_any(
      everything(),
      ~ str_detect(as.character(.x), "[A-Za-z]{3,}")
    )
  )

everything() - all columns
.x - current column
if_any() - TRUE if at least one selected column matches
### csv vs tsv
read_csv("file.csv")
read_tsv("file.tsv")

CSV = comma separated
TSV = tab separated
### RStudio project vs setwd()
Hard-coded:
setwd("C:/projects/...")

is not very portable.
RStudio Projects use the project folder as the working directory, so relative paths like:
read_csv("datasets/file.csv")

work better between different computers and operating systems.
Memorables
### pivot_longer()
shovel column names into one column and values into another column.
Useful for plotting, but can increase number of rows drastically.
### factor
R does not understand the meaning of categories. If I want a meaningful order, I need to define it.
### regex
Looks horrible at first, but it is mostly small rules combined together.
### if_any()
Instead of checking every column separately, I can apply the same condition to all of them.

Jasne. Zrobiłbym to w Twoim dotychczasowym stylu: Insights = krótkie techniczne notatki, Memorables = rzeczy, które szczególnie zwróciły uwagę, a log bardziej jako Twoje faktyczne obserwacje, nie tutorial dla początkującego.
Insights
### regex with multiple columns
filter(
  if_any(
    everything(),
    ~ str_detect(as.character(.x), "pattern")
  )
)

if_any() applies the condition to selected columns and keeps the row if at least one matches.
### checking if values can become numeric
filter(
  if_any(
    3:7,
    ~ !is.na(.x) &
      is.na(suppressWarnings(as.numeric(.x)))
  )
)

Useful for finding values which will break numeric conversion before actually converting the dataset.

### cleaning strings before numeric conversion
str_replace_all(.x, "\\*", "")

removes *
str_replace_all(.x, "---", NA_character_)

changes missing-value markers into proper NA.
Braemar had an additional problem:
#NAME?

in sun (hours).
### warning: NAs introduced by coercion
NAs introduced by coercion

does not necessarily mean that as.numeric() is the problem.
It usually means there is still some non-numeric content in the column which should be investigated before conversion.
### make a date from year and month
make_date(
  year = yyyy,
  month = mm,
  day = 1
)

Useful when the dataset stores year and month separately but I want to analyse it as a time series.
### monthly vs yearly temperature
Monthly data contains a strong seasonal pattern, which can hide a much smaller long-term trend.
Grouping by year and calculating a yearly average makes the long-term trend easier to see:
group_by(year) %>%
summarise(
  average_yearly_temp = mean(average_temp, na.rm = TRUE)
)

# Insights

### basic R function syntax

name <- function(arguments) {
  body
}

The last evaluated expression is returned automatically, so an explicit return() is not always needed.

### functions can operate directly on vectors

subtract_vector <- function(vect1, vect2) {
  vect2 - vect1
}

R applies the subtraction element by element without requiring a loop.

a <- c(1, 3)
b <- c(4, 6)

subtract_vector(a, b)
# 3 3

### str_flatten()

R for Data Science, Chapter 14.3.3:

str_flatten(c("x", "y", "z"))
# "xyz"

Useful for converting a character vector into one string.

stick_together <- function(chars) {
  str_flatten(chars)
}

### str_flatten() with separator

str_flatten(c("x", "y", "z"), " ")

allows the same vector to be joined using a separator.

This makes it easy to control whether the result behaves like a word or a phrase.

is_it_phrase <- function(chars, is_it) {
  if (is_it) {
    str_flatten(chars, " ")
  } else {
    str_flatten(chars)
  }
}

# Memorables

R functions feel very familiar compared with other languages

The syntax is different, but arguments, conditions and reusable logic work in the same general way as functions in Python, C# or JavaScript.

Vectorisation changes how small functions are designed

For something such as subtracting two numeric vectors, I do not need to iterate through them manually. R performs the operation element by element.

The wording of the requirement matters

“Subtract the first from the second” means:

second - first

rather than first - second.

Existing functions can form the core of my own functions

Instead of manually concatenating character values, I can use str_flatten() inside a function and add my own behaviour around it.

# Insights

### vector operations inside functions

R applies arithmetic directly across vectors:

subtract_vector <- function(vect1, vect2) {
  vect2 - vect1
}

No explicit loop is required.

### filtering NA from a vector

new_var <- var[!is.na(var)]

This is conceptually similar to JavaScript:

var.filter(x => x != null)

It keeps the rest of the function cleaner because missing values are removed before calculations start.

### own mean function

temp_mean2 <- function(var) {
  new_var <- var[!is.na(var)]
  sum(new_var) / length(new_var)
}

I could make this shorter, but separating the cleaning step makes the logic easier to read.

### even / odd helper functions

is_even2 <- function(number) {
  number > 0 && number %% 2 == 0
}

is_odd <- function(number) {
  number > 0 && number %% 2 != 0
}

%% returns the remainder from division.

An important edge case is that mathematically 0 %% 2 == 0, so simply checking modulo treats zero as even.

### median logic

For an odd number of values:

new_var[(n + 1) / 2]

For an even number of values, take the two middle values and calculate their mean.

The vector needs to be sorted first:

new_var <- sort(new_var)

### message + NA

A function should preferably keep a consistent return type.

Instead of returning an error message as the result:

"Sorry..."

I can display the message and return NA:

message("Sorry, but your vector is empty or contains only missing values.")
NA

# Memorables

Zero broke my first median exception handling

After filtering:

c(NA, NA)

the vector becomes empty and:

length(new_var)

returns 0.

My original is_even() considered zero even, so the function entered the even branch instead of the empty-vector branch and eventually returned NaN.

NA and NaN are not the same problem

NA represents a missing value, while NaN can be produced by an undefined numeric calculation such as 0 / 0.

In this case, returning NA makes more sense because the median is unavailable because there are no usable observations.

Helper functions improved the median implementation

Instead of putting everything into temp_median(), I separated is_even(), is_odd() and reused temp_mean2().

This made the logic easier to follow and made the edge case easier to debug.

Vectorisation removes a lot of boilerplate

Operations that I would normally think about in terms of iteration in another language often operate directly on whole vectors in R.

