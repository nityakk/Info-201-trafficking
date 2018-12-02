## add pages

my_ui <- fluidPage(
  tabsetPanel(
    tabPanel("tab 1", "contents"),
    tabPanel("tab 2", "contents"),
    tabPanel("tab 3", "contents")),
  sidebarPanel(uiOutput("time"), uiOutput("state")
    selectInput(selectInput("select", label = h3("Select a country:"), 
                            choices = list(), 
                            selected = 1))
               
  ),
  
  mainPanel(plotOutput("map"), textOutput("text"), plotOutput("piechart"))
)

shinyUI(my_ui)