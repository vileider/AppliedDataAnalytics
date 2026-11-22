library(shiny)
library(tidyverse)

# I am using solutions form previous tasks
station_files <- list.files(
  "data",
  pattern = "_raw\\.tsv$",
  full.names = TRUE
)

#map takies all paths from station files and pass it to read_tsv
weather_raw <- station_files %>%
  map(read_tsv)

#weather_raw
#length(weather_raw) 
# names(weather_raw)
# print(class(weather_raw))
# print(length(weather_raw))
# print(names)
#weather_raw contains [1] "list" [1] 2 but I need actual names
names(weather_raw) <- basename(station_files)
print(names(weather_raw))
#ok I think that is task 1
#I think I can refer to each table by name
print(weather_raw[["nairn_raw.tsv"]])
#yes its confirmed


ui <- fluidPage(
  "Bogdan's Weather Super APP2"
)

server <- function(input, output, session) {
  
}

shinyApp(ui = ui, server = server)

# Part 1
# Following the demo in the notes: Create a list of
# data frames/tibbles from the *_raw.tsv weather datasets using map() and read_tsv().