#function to create Flickr and Twitter Lealet

FlickrTwitter <- function(flickr_geojson,twitter_geojson){

  pal_flickr <- colorFactor(palette = 'viridis', domain = flickr_geojson$traveler_type)
  pal_twitter <- colorFactor(palette = rainbow(length(unique(twitter_geojson$hashtag))), 
                             domain = twitter_geojson$hashtag)
  
  north_arrow <- "<img src='http://pluspng.com/img-png/free-png-north-arrow-big-image-png-1659.png' style='width:30px;height:40px;'>"
  
  m <- leaflet(options = leafletOptions(zoomControl = F)) %>% 
    setView(lng = 4.895168, lat = 52.370216, zoom = 11) %>%
    addProviderTiles(providers$Esri.WorldGrayCanvas) %>%
    
    #flickr
    addCircleMarkers(group = "Flickr",data = flickr_geojson,radius = 4,stroke=F,fillOpacity = 0.7,color = ~pal_flickr(traveler_type),
                     popup = paste("<b>Photo title:</b>", flickr_geojson$photo_title, "<br>",
                                   "<b>Date taken:</b>", flickr_geojson$date_taken, "<br>",
                                   "<b>User origin:</b>", flickr_geojson$user_location))%>%
    #twitter
    addCircleMarkers(group = "Twitter",data = twitter_geojson,radius = 4,stroke=F,fillOpacity = 0.7,color = ~pal_twitter(hashtag),
                     popup = paste("<b>Neighbourhood:</b>", twitter_geojson$neighbourh, "<br>",
                                   "<b>Tweet date:</b>", twitter_geojson$created, "<br>",
                                   "<b>Text:</b>", twitter_geojson$text))%>%
    
    addLegend(group = "Flickr",data =flickr_geojson ,"topleft", pal = pal_flickr, values = ~traveler_type,title = "Traveler type")%>%
    addLegend(group = "Twitter",data =twitter_geojson ,"topleft", pal = pal_twitter, values = ~hashtag,title = "Twitter hashtag")%>%
    addMiniMap(position = "bottomright",toggleDisplay = T,minimized = T)%>%
    addControl(html = north_arrow , position = "topright")%>%
    addScaleBar(position = 'bottomleft',options = scaleBarOptions(imperial = F))%>%
    addLayersControl(overlayGroups = c("Flickr", "Twitter"),options = layersControlOptions(collapsed = FALSE))%>%
    hideGroup("Twitter")
  return(m)
}
  
