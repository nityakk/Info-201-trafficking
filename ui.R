## add pages
my_ui <- fluidPage(
  tabsetPanel(
    tabPanel("tab 1", "contents"),
    tabPanel("tab 2", "contents"),
    tabPanel("tab 3", "contents")),
  sidebarPanel(uiOutput("time"), uiOutput("state")),
  
  mainPanel(plotOutput("map"), textOutput("text"))
)

shinyUI(my_ui)