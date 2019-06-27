library(shiny)
library(shinydashboard)
library(leaflet)
library(shinyLP)

source('ui.R')
source('scripts/infiltration_visualization.R')
source('scripts/bedpressure_visualization.R')
source('scripts/socialmedia_visualization.R')

nbr <- st_read('data/neighbourhoods.geojson')
hotels <- st_read('data/hotels.geojson')
flickr <- st_read('data/GeotaggedFlickr_24june2019.geojson')
twitter <- st_read('data/tweets.geojson')
url3d <- "https://williamtjiong.github.io/fairbnb-airbnbmapdeck/"

server <- function(input, output, session) {
  output$infiltrationmap <- renderLeaflet({
    infiltration(nbr)
    })
  
  output$bedpressuremap <- renderLeaflet({
    bedpressure(nbr,hotels)
    })
  
  output$socialmediamap <- renderLeaflet({
    FlickrTwitter(flickr,twitter)
  })
  
  output$frame <- renderUI({
    map3d <- tags$iframe(src=url3d, height=600, width=535)
    map3d
    })
  
  
  
}

shinyApp(ui, server)