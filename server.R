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
  
  output$time <- renderUI(radioButtons("time", label = h3("Time of Day"),
                                       choices = list("AM", "PM")))
  ##output$state <- renderUI(selectInput("state", label = h3("Pick a state"),
  ##          
  output$country <- renderUI(selectInput("country", label = h3("Select a country:"), 
                                         choices = list(data$country)))
  #choices = sort(unique(data$State))))

  output$piechart <- renderPlot({
    data <- filter(sweat_toil_data, percent_of_working_children_industry != "Unavailable")
    data <- filter(data, percent_of_working_children_industry != "N/A")
    industry <- select(data, country, percent_of_working_children_industry) %>%
    filter(country == input$country) %>%
    select(percent_of_working_children_industry)
    agriculture <- select(data, country, percent_of_working_children_agriculture) %>%
    filter(country == input$country) %>%
      select(percent_of_working_children_agriculture)
    services <- select(data, country, percent_of_working_children_services) %>%
    filter(country == input$country) %>%
      select(percent_of_working_children_services)
    slices <- c(as.double(industry), as.double(agriculture), as.double(services))
    percent <- (slices/sum(slices))
    labor_slices <- c("Industry", "Agriculture", "Services")
    labor_slices <- paste0(labor_slices, " ", percent, "%")
    pie(slices, labels = labor_slices, main="Percentage of Children in areas of Child Labor")
  })
  
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
    
    data(wrld_simpl)
    myCountries = wrld_simpl@data$NAME %in% specific_percentages$country
    plot(wrld_simpl, col = c("gray30", "red")[myCountries+1])
  })
  
  # fourth panel
}