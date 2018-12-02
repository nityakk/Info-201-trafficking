## add pages
my_ui <- fluidPage(
  sidebarPanel(uiOutput("time"), uiOutput("state")),
  
  mainPanel(plotOutput("map"), textOutput("text"))
)

shinyUI(my_ui)