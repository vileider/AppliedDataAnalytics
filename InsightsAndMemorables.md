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