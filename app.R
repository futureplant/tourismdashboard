#####################################################################################
## Script that builds a shiny dashboard that includes all leafletvisualizations     #
##    Inputs are outputs from A,B,C,D,E,F parts of project                          #
##    Output is a shiny dashboard that runs on our server                           #
#####################################################################################

# load libraries and source scripts ---------------
library(shiny)
library(shinydashboard)
library(leaflet)
library(shinyLP)
library(sf)
library(ggplot2)

source('ui.R')
source('scripts/G_infiltration_visualization.R')
source('scripts/G_bedpressure_visualization.R')
source('scripts/G_socialmedia_visualization.R')
source('scripts/G_cluster_visualization.R')

# read data ----------------------------------------
nbr <- st_read('output/neighbourhoods.geojson')
hotels <- st_read('data/hotels.geojson')
flickr <- st_read('data/GeotaggedFlickr_24june2019.geojson')
twitter <- st_read('data/tweets.geojson')
clusters <- st_read('data/clusternbr.geojson')
url3d <- "https://williamtjiong.github.io/fairbnb-airbnbmapdeck/"


# construct server ----------------------------------
server <- function(input, output, session) {
  
  # render infiltration visualization
  output$infiltrationmap <- renderLeaflet({
    infiltration(nbr)
    })
  
  # render bedpressure visualization
  output$bedpressuremap <- renderLeaflet({
    bedpressure(nbr,hotels)
    })
  
  # render social media analysis visualization
  output$socialmediamap <- renderLeaflet({
    FlickrTwitter(flickr,twitter)
  })
  
  # render 3d infiltration visualization
  output$frame <- renderUI({
    map3d <- tags$iframe(src=url3d, height=600, width="100%")
    map3d
    })
  
  # render cluster visualization
  output$clustermap <- renderLeaflet({
    cluster(clusters)
  })
  
  # render twitter validation plot
  output$hashtagplot <- renderPlot({
    df_twitter <- read.csv(file="./data/tourist_pct.csv", header=TRUE, sep=",")
    # Draw plot
    plotje <- ggplot(df_twitter, aes(x=hashtag, y=pct)) + 
      geom_bar(stat="identity", width=.5, fill=rainbow(n=length(df_twitter$hashtag))) + 
      labs(title="Percentage of tourists per hashtag",
           caption="source: Twitter") + 
      theme(axis.text.x = element_text(angle=65, vjust=0.6))+
      xlab('Hashtag')+ylab('%')
    plotje
    
  })
  
  
}

shinyApp(ui, server)