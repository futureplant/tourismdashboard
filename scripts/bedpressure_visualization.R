
bedpressure <- function(nbr, hotels){
  bins <- c(0, 10, 25, 50, 100)
  pal <- colorBin("YlOrRd", domain = nbr$hotelbed_pressure, bins = bins)
  
  m <- leaflet() %>% setView(lng = 4.898940, lat = 52.382676, zoom = 11)
  m %>% addProviderTiles(providers$OpenStreetMap.BlackAndWhite) %>%
    addPolygons(data = nbr,color = "#444444", weight = 0.4, smoothFactor = 0.5,
                opacity = 1.0, fillOpacity = 0.3,
                fillColor = ~pal(hotelbed_pressure),
                highlightOptions = highlightOptions(color = "white", weight = 2,
                                                    bringToFront = TRUE),  popup = ~hotelpopup, group = "Hotel Beds") %>%
    addPolygons(data = nbr,color = "#444444", weight = 0.4, smoothFactor = 0.5,
                opacity = 1.0, fillOpacity = 0.3,
                fillColor = ~pal(airbnbbed_pressure),
                highlightOptions = highlightOptions(color = "white", weight = 2,
                                                    bringToFront = TRUE),  popup = ~airbnbpopup, group = "AirBnB Beds") %>%
    
    addLegend("bottomright", pal = pal, values = nbr$hotelbed_pressure,
              title = "Bed pressure (%)",
              opacity = 0.5, na.label = "No beds") %>%
    addMarkers(data=hotels, clusterOptions = markerClusterOptions(), popup = ~popup) %>%
    addLayersControl(
      baseGroups = c("Hotel Beds", "AirBnB Beds"),
      options = layersControlOptions(collapsed = FALSE))
}