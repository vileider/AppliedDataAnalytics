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
