library(plotly)
my_ui <- fluidPage(
  tabsetPanel(
    tabPanel(titlePanel("Home"),
         h2("Introduction: Child Labor"),
         h3("By: Ashlea Lau, Judi Wong, Nitya Krishna Kumar, Manhong Gan"),
         mainPanel(
           h3("Goal:"),
           h4("Our goal is to build visualizations for chosen dataset to 
              better answer questions about child labor. The data that we 
              use comes from the Department of Labor's Bureau Of International 
              Labor Affairs. Database contains information on countries, 
              regions, territories, advancement levels, sectors, goods, 
              statistics, conventions, etc."),
           h3("Target Audience: Policy makers and Organizations"),
           h4("This is data is important so that they can seek ways 
              improve call to action plans, identify areas that are 
              in serious conditions, identify factors that contribute
              to child labor. Our end goal is to strive to decrease 
              child labor and improve their conditions"))),
    tabPanel("Highest and Lowest Child Labor Countries",
         sidebarPanel(radioButtons("select", 
                                  h3("Choose to view highest or lowest percentage:"), 
                                  c("Highest" = "pickHigh", "Lowest" = "pickLow"))),
         mainPanel(plotOutput("barplot"))),
    tabPanel("Percent child labor per area",
             sidebarPanel(uiOutput("country")),
             mainPanel(plotOutput("piechart"))),
    tabPanel("Percent of children working and studying",
             sidebarPanel(uiOutput("working_studying")),
             mainPanel(plotOutput("world_map"))),
    tabPanel("Working children vs Primary completion rate",
             mainPanel(plotlyOutput("scatterplot", )),#click = "plot_click")),
             verbatimTextOutput("click_info")))
)

shinyUI(my_ui)
