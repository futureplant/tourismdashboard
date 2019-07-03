######################################################################################################################
## Script that calculates infiltration in neighbourhoods as described in paragraph 3.2.1 of the report               #
##    Inputs is hotel, neighbourhood and AirBnB data                                                                 #
##    Output is a geojson that contains average distances between airbnb and nearest hotel and leaflet visualization #  
######################################################################################################################


# Load libraries ------------------- 
library(sf)
library(sp)
library(FNN)
library(rgdal)
library(leaflet)
library(dplyr)
library(htmltools)
library(htmlwidgets)



# read data and preprocess data -----------------------
hotels <- st_read('output/hotels.geoJSON')
#airbnb2019 <- st_read('data/products_airbnb/AirbnbPoints_20190408.geojson')
airbnball <- st_read('data/products_airbnb/AirbnbPoints_Concat_2015to2019.geojson')
unique(airbnball$date)

# Filter out hotels that are geolocated
nbr <- st_read('output/neighbourhoods.geojson')
hotels <- st_intersection(hotels,nbr)

# For all airbnb addresses, find distance to nearest hotel ------------
hotels <- st_transform(hotels,28992) #  transform to rd new in order to use planar distances in m
hotels <- as(hotels, 'Spatial') #  transform to sp since get.knnx takes this as argument

airbnball <- st_transform(airbnball,28992) #  transform to rd new in order to use planar distances in m
airbnball <- as(airbnball, 'Spatial') #  transform to sp since get.knnx takes this as argument

# find distances 
distances <- get.knnx(coordinates(hotels), coordinates(airbnball), k=1)
airbnball <- st_as_sf(airbnball)
airbnball$dist2hot <- distances$nn.dist
airbnball <- st_transform(airbnball,4326) # transform back to wgs84 for plotting

# join to neighbourhoods for aggregation
join <- st_join(airbnball, nbr)
keeps <- c('id', 'Buurt_code', 'dist2hot','date')
join <- join[keeps]

dates <- unique(join$date)
nbrnames <- unique(nbr$Buurt_code)

distances <- data.frame(matrix(ncol = 0, nrow = 481),stringsAsFactors = F)

# Aggregate data for every neighbourhood and for ecery year
distances$Buurt_code <- nbrnames 
startyear <- 2015
for (date in dates){
  subset <- join[which(join$date == date),]
  mean_distance <- aggregate(subset, list(as.factor(subset$Buurt_code)), FUN=mean)
  mean_distance <- mean_distance[,-which(names(mean_distance) == "Buurt_code")]
  mean_distance <- mean_distance[,-which(names(mean_distance) == "id")]
  mean_distance <- mean_distance[,-which(names(mean_distance) == "date")]
  st_geometry(mean_distance) <- NULL
  names(mean_distance) <- c("Buurt_code",paste0("dist2hot",startyear))
  distances <- left_join(distances, mean_distance, by="Buurt_code")
  startyear <- startyear + 1
}

nbr <- left_join(nbr,distances,by="Buurt_code")


# Visualization with leaflet -----------------------

pal <- colorNumeric("YlOrRd", c(nbr$dist2hot2019,nbr$dist2hot2018,nbr$dist2hot2017,nbr$dist2hot2016,nbr$dist2hot2015),
                    na.color = "transparent")
st_write(nbr, 'output/neighbourhoods.geojson', delete_dsn=T)

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
  

