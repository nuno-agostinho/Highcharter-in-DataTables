library(shiny)
library(highcharter)
library(jsonlite)

source("hc.R")

# Define UI for application that calls JavaScript functions and renders the
# DataTables 
ui <- shinyUI(fluidPage(
    titlePanel("Highcharts sparklines in DataTables"),
    includeScript("www/functions.js"),
    dataTableOutput("table"),
    highchartOutput("") # Only used to load the Highcharts library
))

# Define server logic required to draw the sparklines within the DataTable
server <- shinyServer(function(input, output) {
    output$table <- renderDataTableSparklines({
        hc <- highchart()
        
        for (i in 1:20) {
            hc <- hc %>% 
                hc_chart(type="area") %>%
                hc_add_series(name="Pears", data=sample(100, 5)) %>%
                hc_add_series(name="Oranges", data=sample(100, 5)) %>%
                hc_new_sparkline()
        }
        
        dummy <- data.frame(replicate(5, sample(0:1, 20, rep=TRUE)))
        cbind(dummy, Sparkline=hchart(hc))
    }, options=list(pageLength=10))
})

# Run the application 
shinyApp(ui = ui, server = server)

