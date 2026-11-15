#Part 1

library(shiny)
library(tidyverse)
library(plotly)
library(zoo)
ui <- fluidPage(
  "Weather app"
)

server <- function(input, output, session) {
  
}



#I am not sure wehre to write so I will write here
# Instead creating a new shiny app with the "wizard"
# I just coped syntax from https://mastering-shiny.org/basic-app.html
# and it works smooth like a charm Listening on http://127.0.0.1:4903
#I will copy function file and datase as well into wee8app directory

source("functions/mostly_weather_functions.R")
nairn_clean <- read_clean_weather2("data/nairn_raw.tsv")

#error:
# Error in remove_non_numeric_rows(dataset, column) : 
#   could not find function "remove_non_numeric_rows"

#hmm..
#Did I miss to add a function into my file?
#added...
#now:
# > runApp('C:/projects/AppliedDataAnalytics/Week8_theapp')
# New names:                                                                                          
#   • `` -> `...8`
# Error in func(fname, ...) : app.R did not return a shiny.appobj object.
# Ok I have got it, a code in "read_clean_weather2"  was printing that "'...8'..."
#and I did not finish THIS file with "shinyApp(ui = ui, server = server)"
#https://readr.tidyverse.org/reference/read_delim.html
# I added ""unique_quiet": Repair with the unique strategy, quietly."
#nothing unnecessary prints out now
#now Coverting to long format all columns apart frm "year_month"
nairn_long <- nairn_clean %>%
  pivot_longer(
    cols = -year_month,
    names_to = "measurement",
    values_to = "value"
  )


#Part 2
nairn_long
#dosnt work
# Create a selectInput() that allows the user to select the measurement (tmax, tmin etc) of their choice.
# Create a reactive function to filter() the data of the chosen measurement. 
# Commit your progress.


shinyApp(ui = ui, server = server)