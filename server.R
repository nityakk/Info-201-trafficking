library(maptools)
library(mapproj)
library(mapdata)
library(ggplot2)
library(R.utils)
library(dplyr)
source("process_data.R")
my_server <- function(input, output) {
  ##usa <- map_data("world", c("usa", "Canada"))
  
  ##data <- data.table::fread("data/UFOCoords.csv.bz2", stringsAsFactors=FALSE)
  
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
  
  
  output$map <- renderPlot({
    if(is.null(input$time)){
      return()
    }
    data(wrld_simpl)
    myCountries = wrld_simpl@data$NAME %in% c("Australia", "United Kingdom", "Germany", "United States", "Sweden", "Netherlands", "New Zealand")
    plot(wrld_simpl, col = c(gray(.80), "red")[myCountries+1])
  })
  
  #hello
}