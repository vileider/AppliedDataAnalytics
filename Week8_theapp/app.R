#Part 1

library(shiny)
library(tidyverse)
library(plotly)
library(zoo)

source("functions/mostly_weather_functions.R")
# nairn_clean <- read_clean_weather2("data/nairn_raw.tsv")
# dunstaffnage_clean <- read_clean_weather2("data/dunstaffnage_raw.tsv")

# nairn_long <- nairn_clean %>%
#   pivot_longer(
#     cols = -year_month,
#     names_to = "measurement",
#     values_to = "value"
#   )
#I need to make something more generic In case in the future i will be adding more weather stations
#I am assuming i put only weather station tsv's into data directiry
station_files <- list.files("data", pattern = "_raw\\.tsv$", full.names = TRUE)
print(station_files)
#It shows the path in a strange way but its ok

#this one have been here before ,just tweaking a little bit
weather_to_long <- function(dataset, columns) {
  dataset %>%
    pivot_longer(
      cols = {{ columns }},
      names_to = "measurement",
      values_to = "value"
    )
}
#I need to trim names a little bit
station_names <- basename(station_files) %>%
  str_remove("_raw\\.tsv$") %>%
  str_to_title()

#I want names not just station "1" and "2"
names(station_files) <- station_names

weather_long <- station_files %>%
  map(read_clean_weather2) %>%
  bind_rows(.id = "station") %>%
  weather_to_long(-c(station, year_month))
ui <- fluidPage(
  "Bogdan's Weather Super APP",
  #https://mastering-shiny.org/basic-ui.html
  #Selecet input from chapter 2 basic UI
  selectInput(
    inputId = "station",
    label = "Choose a weather station:",
    choices = unique(weather_long$station)
  ),
  selectInput(
    inputId = "measurement",
    label = "Choose a measurement:",
    choices = unique(weather_long$measurement)
  ),
  
  #https://shiny.posit.co/r/components/outputs/plot-plotly/
  #about Plot(plotly) in chapter Outputs
  plotlyOutput(outputId = "weather_plot"),
  #adding another plot (task4 based on week5)
  plotlyOutput(outputId = "my_weather_trend")
)

server <- function(input, output, session) {
  # selected_weather <- reactive({
  #   nairn_long %>%
  #     filter(measurement == input$measurement)
  # })
  #updating select weather to be able to pick station and measurment type
  selected_weather <- reactive({
    weather_long %>%
      filter(
        station == input$station,
        measurement == input$measurement
      )
  })
  output$weather_plot <- renderPlotly({
    weather_plot <- ggplot(
      selected_weather(),
      aes(x = year_month, y = value))+
      geom_line() +
      zoo::scale_x_yearmon(format = "%Y-%m") +
      #labs(title = paste("Nairn:", input$measurment),
      labs(title = paste(input$station, input$measurement, sep = ": "),
           x = "Years and months",
          y = input$measurement)
    
  ggplotly(weather_plot)
  })
  
  # Part 4: reuse the points and smoothing from Week 5, Exercise 5
  output$my_weather_trend <- renderPlotly({
    
   weather_trend <- ggplot(
      selected_weather(),
      aes(x = year_month, y = value)
    ) +
      geom_point() +
      geom_smooth() +
      zoo::scale_x_yearmon(format = "%Y-%m") +
      labs(
        #title = paste("Nairn: smoothed trend of", input$measurement),
        title = paste(input$station, "– smoothed trend of", input$measurement),
        x = "Year and month",
        y = input$measurement
      )
    
    ggplotly(weather_trend)
  })
}



#I am not sure wehre to write so I will write here
# Instead creating a new shiny app with the "wizard"
# I just coped syntax from https://mastering-shiny.org/basic-app.html
# and it works smooth like a charm Listening on http://127.0.0.1:4903
#I will copy function file and datase as well into wee8app directory

# source("functions/mostly_weather_functions.R")
# nairn_clean <- read_clean_weather2("data/nairn_raw.tsv")
#(edit: moved to the top after task 2)

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
# nairn_long <- nairn_clean %>%
#   pivot_longer(
#     cols = -year_month,
#     names_to = "measurement",
#     values_to = "value"
#   )
#moved highier


#Part 2

# Create a selectInput() that allows the user to select the measurement (tmax, tmin etc) of their choice.
# Create a reactive function to filter() the data of the chosen measurement. 
# Commit your progress.

#nairn_long
#doesnt work, you lied to me Andrew, I need to use print (;])
#print(nairn_long)
#I get error:
# > runApp('C:/projects/AppliedDataAnalytics/Week8_theapp')
# Error in  'eval(exprs, envir)': did not find object 'nairn_clean'
#
#I have to reorganise the code


# Part 3
# 
# Add a plotlyOutput() and renderPlotly() to draw a line graph
# of the chosen variable. (Hint: Use your previous code and create a ggplot,
# then use ggplotly()).
# Commit your progress. 
#I think It is done as in task

# Part 4
# 
# Try adding another type of plot. This could be added below
# the existing plot or as part of a set of tabs. 
# Commit your progress.

#I hve been already working on simmilar stuff on week5 5
# I added another plot under the 1st one, plot visualisation is not clear for the user
# but I am assuming it is just a proof of concept to show an example of shiny app use

# Part 5
# 
# Try adding another weather dataset and an input to allow the user to choose the dataset. There are two general approaches here. 
# You could read both of them in and combine them into a single dataframe, then use two selectInput()s and filter the data appropriately. 
# You could have two separate datasets and just call a function on the dataset that corresponds to the choice of the user. 
# Commit your progress. 

shinyApp(ui = ui, server = server)