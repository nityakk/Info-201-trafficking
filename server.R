library(maptools)
library(mapproj)
library(mapdata)
library(ggplot2)
#library(R.utils)
library(dplyr)
library(shiny)
library(rsconnect)

my_server <- function(input, output) {
  
  # BARPLOT for question 1. Locations with highest and lowest child labor 
  percent_work_df <- filter(sweat_toil_data, !(percent_of_working_children == "Unavailable"),
                                              !(percent_of_working_children == "N/A")) %>%
                     select(country, percent_of_working_children)
  
  highest_five <- top_n(percent_work_df, 5) #selects the 5 highest percentage and their countries
  lowest_five <- top_n(percent_work_df, -5) #selects the 5 lowest percentage and their countries
  
  make_bars <- function(df, input, output) { # took out output
    result <- barplot(as.matrix(df), main = "Percentage of child labor vs. Countries",
                      xlab = "Countries", ylab = "Percentage in Decimal", col = "Blue")
  }
  
  shinyServer(
    function(input, output) { # took out output
      output$barplot <- renderPlot({ 
        result <- switch (input$select, 
                          pickHigh = make_bars(highest_five, input, output), # took out output
                          pickLow = make_bars(lowest_five, input, output) # took out output
        )
      }) 
    })

  
  ##usa <- map_data("world", c("usa", "Canada"))
  
  ##data <- data.table::fread("data/UFOCoords.csv.bz2", stringsAsFactors=FALSE)
  
 output$time <- renderUI(radioButtons("time", label = h3("Time of Day"),
                                       choices = list("AM", "PM")))
  #output$state <- renderUI(selectInput("state", label = h3("Pick a state"),
  ##                                     choices = sort(unique(data$State))))

   output$map <- renderPlot({
     if(is.null(input$time)){
       return()
     }
     data(wrld_simpl)
     myCountries = wrld_simpl@data$NAME %in% c("Australia", "United Kingdom", "Germany", "United States", "Sweden", "Netherlands", "New Zealand")
     plot(wrld_simpl, col = c(gray(.80), "red")[myCountries+1])
   })

 }