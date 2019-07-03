##########################################################################
## Script that makes a leaflet visualization of neighbourhood clustering #         
##    Inputs is neighbourhood geojson                                    #  
##    Output is a leaflet visualization                                  #
##########################################################################

cluster <- function(nghbrhd){
  
  pal1 <- colorFactor(rainbow(n=4), domain = nghbrhd$clust_viz)
  m <- leaflet() %>% setView(lng = 4.898940, lat = 52.382676, zoom = 11)
  m %>% addProviderTiles(providers$OpenStreetMap.BlackAndWhite) %>%
    addPolygons(data = nghbrhd,color = "#444444", weight = 0.4, smoothFactor = 0.5,
                opacity = 1.0, fillOpacity = 0.5,
                fillColor = ~pal1(clust_viz),
                popup = ~as.character(clust_viz),
                highlightOptions = highlightOptions(color = "white", weight = 2, bringToFront = TRUE)) %>%
    addLegend("bottomright", pal = pal1, values = nghbrhd$clust_viz,
              title = "Clusters", opacity = 0.5)
  }