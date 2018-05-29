#Load all package dependencies 
library(shiny)
library(stringr)
library(shinythemes)
library(dplyr)
library(compare)
library(leaflet)

#Load files that house distances that have been calculated between each trail

#dists file here is a sum of 2 matrices - 1st based off distances between each rating. 2nd based off spatial distance between each trail calculated from geocodes
dists <- read.csv('dists_euclidean.csv',stringsAsFactors = FALSE, check.names = FALSE)

#helper code houses the similarity function that takes an a trail as an input, and outputs 5 trails that are most similar 
source('helpercode.R')

#UI for the shiny application 
ui <- fluidPage(
 sidebarLayout(
    sidebarPanel(width = 8,
      selectInput(inputId = "selected_type",
                  label = "Pick a trail here",
                  choices = unique(dists$hike_name[-(0:4)]),
                  multiple = FALSE), 
                  #select = "Potato Chip Rock via Mt. Woodson Trail"),
      submitButton("Search")
                     
      ),
    
    mainPanel(
     tableOutput("table")
    )
  )
)

#The server portion that calculates users' selections in the UI piece and calculates similar hikes via helpercode.R file
server <- function(input, output) {
  #specification for a table output
  output$table <- renderTable({
  #contains similar hikes based off helpercode
  sims <- as.data.frame(getSimilarhikes(input$selected_type))
  #merge similarity matrix and df to extract similar hikes' attributes 
  merged.1 <- merge(sims,trail.attributes, by = 'hike_name')
  #sort similar hikes based off ascending similarity metric
  merged.1 <- merged.1[order(merged.1$similarity),]
  #publish top five hikes w/ hike length, elevation, difficulty and type attributes from trail.attributes file
  head(merged.1[c(1:5),c(1,3,4,14,15)])
  })
#,editable = FALSE,class = 'cell-border stripe',colnames = c('Trail Name', 'Length', 'Elevation', 'Difficulty', 'Type'))
  
}

#launch application
shinyApp(ui = ui, server = server)
