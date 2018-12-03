library(maptools)
library(mapproj)
library(mapdata)
library(ggplot2)
library(R.utils)
library(dplyr)

source("process_data.R")

my_server <- function(input, output) {
## widgets
  output$working_studying <- renderUI(sliderInput("working_studying",
                             label = h3("Pecentage of Working and Studying Children"),
                             min = 0, max = 100,
                             sweat_toil_data$percent_of_children_working_and_studying))
  
## first panel
  
## second panel
  
  
## third panel
  
  ##usa <- map_data("world", c("usa", "Canada"))
  
  ##data <- data.table::fread("data/UFOCoords.csv.bz2", stringsAsFactors=FALSE)
  output$world_map <- renderPlot({
    if(is.null(input$working_studying)){
      return()
    }
    
    working_studying_data <- filter(sweat_toil_data, !(percent_of_children_working_and_studying == "Unavailable"),
                                                     !(percent_of_children_working_and_studying == "N/A")) %>%
                             select(country, percent_of_children_working_and_studying)
    
    specific_percentages <- filter(working_studying_data,
                    percent_of_children_working_and_studying >= (input$working_studying[1]/100.0),
                    percent_of_children_working_and_studying <= (input$working_studying[2]/100.0))
    
    # world <- data(wrld_simpl)
    myCountries = wrld_simpl@data$NAME %in% specific_percentages$country
    plot(wrld_simpl, col = c(gray(.80), "red")[myCountries+1])
  })
  
  # fourth panel
}