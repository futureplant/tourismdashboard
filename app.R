library(shiny)
library(shinydashboard)
library(leaflet)

source('ui.R')

server <- function(input, output, session) {
  output$map <- renderLeaflet({
    nbr <- st_read('data/neighbourhoods.geojson')
    
    m <- leaflet() %>% setView(lng = 4.898940, lat = 52.382676, zoom = 11)
    m %>% addProviderTiles(providers$OpenStreetMap.BlackAndWhite) %>%
      addPolygons(data = nbr,color = "#444444", weight = 0.4, smoothFactor = 0.5,
                  opacity = 1.0, fillOpacity = 0.3,
                  fillColor = ~pal(dist2hot2015),
                  highlightOptions = highlightOptions(color = "white", weight = 2,
                                                      bringToFront = TRUE), popup = ~airbnbpopup, group="2015") %>%
      addPolygons(data = nbr,color = "#444444", weight = 0.4, smoothFactor = 0.5,
                  opacity = 1.0, fillOpacity = 0.3,
                  fillColor = ~pal(dist2hot2016),
                  highlightOptions = highlightOptions(color = "white", weight = 2,
                                                      bringToFront = TRUE), popup = ~airbnbpopup,group="2016") %>%
      addPolygons(data = nbr,color = "#444444", weight = 0.4, smoothFactor = 0.5,
                  opacity = 1.0, fillOpacity = 0.3,
                  fillColor = ~pal(dist2hot2017),
                  highlightOptions = highlightOptions(color = "white", weight = 2,
                                                      bringToFront = TRUE), popup = ~airbnbpopup,group="2017") %>%
      addPolygons(data = nbr,color = "#444444", weight = 0.4, smoothFactor = 0.5,
                  opacity = 1.0, fillOpacity = 0.3,
                  fillColor = ~pal(dist2hot2018),
                  highlightOptions = highlightOptions(color = "white", weight = 2,
                                                      bringToFront = TRUE), popup = ~airbnbpopup,group="2018") %>%
      addPolygons(data = nbr,color = "#444444", weight = 0.4, smoothFactor = 0.5,
                  opacity = 1.0, fillOpacity = 0.3,
                  fillColor = ~pal(dist2hot2019),
                  highlightOptions = highlightOptions(color = "white", weight = 2,
                                                      bringToFront = TRUE), popup = ~airbnbpopup,group="2019") %>%
      addLayersControl(
        baseGroups = c("2015", "2016", "2017", "2018", "2019"),
        options = layersControlOptions(collapsed = FALSE))
    
  })
}

shinyApp(ui, server)