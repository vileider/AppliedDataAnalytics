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