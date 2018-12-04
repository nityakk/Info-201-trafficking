## add pages

my_ui <- fluidPage(
  tabsetPanel(
    tabPanel("Highest and Lowest Child Labor Countries",
             radioButtons("select", "Choose to view highest or lowest percentage:", 
                                  c("Highest" = "pickHigh", "Lowest" = "pickLow")),
         mainPanel(plotOutput("barplot"))),
    tabPanel("Percent child labor per area",
             sidebarPanel(uiOutput("country")),
             mainPanel(plotOutput("piechart"))),
    tabPanel("Percent of children working and studying",
             sidebarPanel(uiOutput("working_studying")),
             mainPanel(plotOutput("world_map"))),
    tabPanel("Percent of working children vs. primary completion rate",
             mainPanel(plotOutput("scatterplot", click = "plot_click")),
             verbatimTextOutput("click_info")))
)

shinyUI(my_ui)
