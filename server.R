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
## widgets
  output$working_studying <- renderUI(sliderInput("working_studying",
                             label = h3("Pecentage of Working and Studying Children"),
                             min = 0, max = 100,
                             sweat_toil_data$percent_of_children_working_and_studying))
  output$country <- renderUI(selectInput("country",
                    label = h3("Select a country:"), 
                    choices = data$country))
  
  
## first panel
  # BARPLOT for question 1. Locations with highest and lowest child labor 
  percent_work_df <- filter(sweat_toil_data, !(percent_of_working_children == "Unavailable"),
                            !(percent_of_working_children == "N/A")) %>%
    select(country, percent_of_working_children)
  
  #highest_five <- top_n(percent_work_df, 5) selects the 5 highest percentage and their countries
  #lowest_five <- top_n(percent_work_df, -5) selects the 5 lowest percentage and their countries
  
  # make_bars <- function(df) { #took out input, output because redundant 
  #   result <- barplot(as.matrix(df), main = "Percentage of child labor vs. Countries",
  #                     xlab = "Countries", ylab = "Percentage in Decimal", col = "Blue")
  # }
  
  highest_count <- c("Chad" = 0.488, "Sierra Leone" = 0.513, "Cameroon" = 0.562, "Guinea-Bissau" = 0.574, "Somalia" = 0.995)
  lowest_count <- c("Sri Lanka" = 0.0008, "Jordan" = 0.01, "Costa Rica" = 0.011, "India" = 0.014, "Belize" = 0.016)
  
  high_names <-  c("Chad", "Sierra Leone", "Cameroon", "Guinea-Bissau", "Somalia")
  low_names <- c("Sri Lanka", "Jordan", "Costa Rica", "India", "Belize")
  
  output$barplot <- renderPlot({ 
    result <- switch (input$select, 
                      pickHigh = barplot(highest_count,
                                         main = "Percentage of child labor vs. Countries",
                                         xlab = "Countries", ylab = "Percentage in Decimal",
                                         col = "red"), 
                      pickLow = barplot(lowest_count,
                                        main = "Percentage of child labor vs. Countries",
                                        xlab = "Countries", ylab = "Percentage in Decimal",
                                        col = "blue")
    )
  }) 
  
## second panel
  data <- filter(sweat_toil_data, percent_of_working_children_industry != "Unavailable")
  data <- filter(data, percent_of_working_children_industry != "N/A")
  
  #choices <- data$country
  output$piechart <- renderPlot({
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
    percent <- round((slices/sum(slices)*100), digits = 2)
    labor_slices <- c("Industry", "Agriculture", "Services")
    labor_slices <- paste0(labor_slices, " ", percent, "%")
    pie(slices, labels = labor_slices, main="Percentage of Children in areas of Child Labor")
  })
  
## third panel
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
    plot(wrld_simpl, col = c("gray30", "firebrick1")[myCountries+1])
  })
  
# fourth panel
  # percent of working children vs primary completion rate
  # select % of working children and primary completion rate
  
  
  children_data <- filter(sweat_toil_data, 
                          !(percent_of_working_children == "Unavailable"),
                          !(primary_completion_rate == "Unavailable")) 
  children_data <- filter(children_data, !(percent_of_working_children == "N/A"))
  
  output$scatterplot <- renderPlot({
    plot(x = children_data$percent_of_working_children, 
           y = children_data$primary_completion_rate, 
           main = "Scatterplot",
           xlab = "Primary Completion Rate", ylab = "% of Working Children")
  })
   country_name <- function(e) {
     if(is.null(e)) return("NULL\n")
     country_match <- filter(children_data, 
                             percent_of_working_children == 0.011) %>% #e$y/100.00) %>%
       select(country)
     paste("country:", e$y)
   }
   
#   output$click_info <- renderPrint({
#     paste(country_name(input$plot_click))
#  })
   
  output$click_info <- renderPrint({
    nearPoints(children_data,xvar = children_data$percent_of_working_children, 
               yvar = children_data$primary_completion_rate, 
               input$plot_click, addDist = FALSE)
  })
}

shinyServer(my_server)
