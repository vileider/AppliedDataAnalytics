library(shiny)
library(tidyverse)

# I am using solutions form previous tasks
# station_files <- list.files(
#   "data",
#   pattern = "_raw\\.tsv$",
#   full.names = TRUE
# )

#map takies all paths from station files and pass it to read_tsv
# weather_raw <- station_files %>%
#   map(read_tsv)

#weather_raw
#length(weather_raw) 
# names(weather_raw)
# print(class(weather_raw))
# print(length(weather_raw))
# print(names)
#weather_raw contains [1] "list" [1] 2 but I need actual names
#names(weather_raw) <- basename(station_files)
#print(names(weather_raw))
#ok I think that is task 1
#I think I can refer to each table by name
#print(weather_raw[["nairn_raw.tsv"]])
#yes its confirmed

#I created a wh
source("functions/mostly_weather_functions.R")

#update I created whole new function to read datasets and clean them
#directly from folder
weather_clean <- create_packOf_weathers_from_folder("data")
#print(names(weather_clean))
#print(weather_clean[["nairn_raw.tsv"]])
#I think task 2 is done, I see list(s) returned

#I will try to create ggplot, use map and save it to variable
saved_plots <- weather_clean %>%
  map(function(dataset) {
    
    ggplot(dataset, aes(
      x = year_month,
      y = `tmax (degC)`
    )) +
      geom_line() +
      zoo::scale_x_yearmon(format = "%Y") +
      labs(
        x = "Year",
        y = "Maximum temperature (°C)"
      )
  })

#..and now what does it show?
#saved_plots[[1]]
#desont work, what about:
#print(saved_plots[[1]])
#ok this is working

ui <- fluidPage(
  titlePanel("Bogdan's Weather Super APP2"),
#adding dropdown and space for visualisation(task3... kind of)
  selectInput(
    inputId = "station",
    label = "Choose weather station:",
    choices = names(saved_plots)
  ),
  
  plotOutput("weather_plot")
)

server <- function(input, output, session) {
#displaying my weather_plot
  output$weather_plot <- renderPlot({
    print(saved_plots[[input$station]])
  })
}

shinyApp(ui = ui, server = server)

# Part 1
# Following the demo in the notes: Create a list of
# data frames/tibbles from the *_raw.tsv weather datasets using map() and read_tsv().

# Part 2
# Using the list of data frames/tibbles, apply the cleaning functions
# we worked on earlier to each data frame/tibble. Ensure that a list is returned.