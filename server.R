library(shiny)
library(maptools)
library(mapproj)
library(mapdata)
library(ggplot2)
#library(R.utils)
library(dplyr)
library(shiny)
library(rsconnect)


source("process_data.R")
my_server <- function(input, output) {
  
  # BARPLOT for question 1. Locations with highest and lowest child labor 
  percent_work_df <- filter(sweat_toil_data, !(percent_of_working_children == "Unavailable"),
                                              !(percent_of_working_children == "N/A")) %>%
                     select(country, percent_of_working_children)
  
  highest_five <- top_n(percent_work_df, 5) #selects the 5 highest percentage and their countries
  lowest_five <- top_n(percent_work_df, -5) #selects the 5 lowest percentage and their countries

  # output$country <- renderUI(selectInput("country", label = h3("Select a country:"),
  #                                        choices = choices))
  # #choices <- data$country
  # output$piechart <- renderPlot({
  #   data <- filter(sweat_toil_data, percent_of_working_children_industry != "Unavailable")
  #   data <- filter(data, percent_of_working_children_industry != "N/A")
  #   choices <- c(data$country)
  #   industry <- select(data, country, percent_of_working_children_industry) %>%
  #   filter(country == input$country) %>%
  #   select(percent_of_working_children_industry)
  #   agriculture <- select(data, country, percent_of_working_children_agriculture) %>%
  #   filter(country == input$country) %>%
  #     select(percent_of_working_children_agriculture)
  #   services <- select(data, country, percent_of_working_children_services) %>%
  #   filter(country == input$country) %>%
  #     select(percent_of_working_children_services)
  #   slices <- c(as.double(industry), as.double(agriculture), as.double(services))
  #   percent <- (slices/sum(slices)*100)
  #   labor_slices <- c("Industry", "Agriculture", "Services")
  #   labor_slices <- paste0(labor_slices, " ", percent, "%")
  #   pie(slices, labels = labor_slices, main="Percentage of Children in areas of Child Labor")
  # })

  make_bars <- function(df, input, output) { # took out output
    result <- barplot(as.matrix(df), main = "Percentage of child labor vs. Countries",
                      xlab = "Countries", ylab = "Percentage in Decimal", col = "Blue")
  }

  
      output$barplot <- renderPlot({ 
        result <- switch (input$select, 
                          pickHigh = make_bars(highest_five, input, output), # took out output
                          pickLow = make_bars(lowest_five, input, output) # took out output
        )
      }) 
}
shinyServer(my_server)
