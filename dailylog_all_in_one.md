### 27.8.2026
I noticed that aes() is basically the connection between the dataset and the visual part of ggplot. Instead of giving ggplot fixed values, I can tell it which columns should control things like x, y, colour or size.
### 9.9.2026
R seems quite forgiving with formatting compared with Python. Indentation is mostly for readability, but the placement of operators such as + in ggplot still matters when splitting code across multiple lines.
### 12.9.2026
I am starting to understand that not every message printed by R is an error. Package masking messages, for example, only tell me that two packages contain functions with the same name.
### 20.9.2026
I noticed that geom_line() and geom_smooth() may look similar at first, but they do very different things. geom_line() connects actual observations, while geom_smooth() tries to show the general tendency in the data.
#
While working with the storms dataset, I noticed that as pressure decreases, wind speed generally increases. It was useful to see that relationship visually rather than only looking at the numbers.
### 27.9.2026
Joins need more attention than I originally thought. They do not only add columns, they can also remove records or create duplicates depending on the keys and the structure of both datasets.
#
Not every statistic can simply be added or averaged. ERA was a good example because I had to understand what the value actually represents before deciding how to summarise it.
### 28.9.2026
I am starting to notice that R is less about writing complicated code and more about understanding what the data represents. Once the dataset is structured correctly, operations such as filtering, joining and plotting are relatively straightforward. The difficult part is deciding how the data should be grouped or summarised before applying those operations.
