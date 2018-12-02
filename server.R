library(maptools)
library(mapproj)
library(mapdata)
library(ggplot2)
library(R.utils)
library(dplyr)

my_server <- function(input, output) {
  ##usa <- map_data("world", c("usa", "Canada"))
  
  ##data <- data.table::fread("data/UFOCoords.csv.bz2", stringsAsFactors=FALSE)
  
  output$time <- renderUI(radioButtons("time", label = h3("Time of Day"),
                                       choices = list("AM", "PM")))
  ##output$state <- renderUI(selectInput("state", label = h3("Pick a state"),
  ##                                     choices = sort(unique(data$State))))
  output$piechart <- renderPlot({
    data <- filter(sweat_toil_data, country == input$select)
    
  })
  
  
  output$map <- renderPlot({
    if(is.null(input$time)){
      return()
    }
    data(wrld_simpl)
    myCountries = wrld_simpl@data$NAME %in% c("Australia", "United Kingdom", "Germany", "United States", "Sweden", "Netherlands", "New Zealand")
    plot(wrld_simpl, col = c(gray(.80), "red")[myCountries+1])
  })
}