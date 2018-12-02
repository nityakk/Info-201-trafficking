## add pages
my_ui <- fluidPage(
  tabsetPanel(
    tabPanel("Highest and Lowest Child Labor Countries", "contents"),
    tabPanel("Percent child labor per area", "contents"),
    tabPanel("Percent of children working and studying",
             sidebarPanel(uiOutput("working_studying")),
             mainPanel(plotOutput("world_map"))))
  )

shinyUI(my_ui)