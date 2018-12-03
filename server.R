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
 }
