library(maptools)
library(ggplot2)
library(dplyr)
library(shiny)
library(rsconnect)

source("process_data.R")

my_server <- function(input, output) {
## widgets
  ## panel 2
  output$working_studying <- renderUI(sliderInput("working_studying",
                             label = h3("Pecentage of Working and Studying Children"),
                             min = 0, max = 100,
                             sweat_toil_data$percent_of_children_working_and_studying))
  
  ## panel 3
  output$country <- renderUI(selectInput("country",
                    label = h3("Select a country:"), 
                    choices = data$country))
  
  
## first panel
  # BARPLOT: Locations with highest and lowest child labor 
  percent_work_df <- filter(sweat_toil_data, !(percent_of_working_children == "Unavailable"),
                            !(percent_of_working_children == "N/A")) %>%
    select(country, percent_of_working_children)
  
  #highest_five <- top_n(percent_work_df, 5) selects the 5 highest percentage and their countries
  #lowest_five <- top_n(percent_work_df, -5) selects the 5 lowest percentage and their countries
  
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
  output$figure1 <- renderText({
    paste("These visualizations identify which countries have the highest and lowest percentages of child labor.
          This allows efforts to combat child labor to be concentrated to areas that need it the most.
          For example, Somalia is one location where efforts should be concentrated because it has the
          highest percentage of child labor.")
  })
  
## second panel
  ## PIE CHART: Percent child labor per area
  data <- filter(sweat_toil_data, percent_of_working_children_industry != "Unavailable")
  data <- filter(data, percent_of_working_children_industry != "N/A")

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
  
  output$figure2 <- renderText({
    paste("This visualization displays the distribution of child labor throughout the
          various types of industries. This information is displayed by country.
          Agriculture appears to be the most common industry to exploit children for
          labor. Using this information, efforts can be concentrated on certain areas of
          industry.")
  })
  
## third panel
  ## WORLD MAP: Percent of children working and studying
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
  
  output$figure3 <- renderText({
    paste("This visualization displays which countires have children working and 
          studying at the same time. From this, it can be determined how education
          and child labor are related. This also highlights countries that have
          lower levels of education, so efforts can be targeted at these places.")
  })
  
# fourth panel
  ## SCATTERPLOT: Working children vs Primary completion rate
  # percent of working children vs primary completion rate
  # select % of working children and primary completion rate
  
  children_data <- filter(sweat_toil_data, 
                          !(percent_of_working_children == "Unavailable"),
                          !(primary_completion_rate == "Unavailable")) 
  children_data <- filter(children_data, !(percent_of_working_children == "N/A"))
  
  output$scatterplot <- renderPlotly({
    
     plot_ly(data = children_data,
            x = ~as.numeric(percent_of_working_children),
            y = ~as.numeric(primary_completion_rate),
            text = ~paste('Country: ', country),
            mode = "markers", type = "scatter") %>% 
      layout(xaxis = list(title = "Primary Completion Rate"), 
             yaxis = list(title = "Percentage of Working Children"))
  })
  
  output$figure4 <- renderText({
    paste("This visualization shows the correlation between child labor
          percentages and the completion of primary school. The negative
          corrolation displayed in this plot suggests that education
          has a direct effect on the percentage of child labor. This
          suggests that efforts to increase education may effectively
          decrease percentages of child labor.")
  })
}

shinyServer(my_server)