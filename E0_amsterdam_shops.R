##########################################################################################################################################
## Script that searches for shops and souvenir shops in Amsterdam neighbourhoods as described in paragraph 3.4.2 of the report           #
##    Inputs are the neighbourhood of Amsterdam in a json file                                                                           #
##    Output is a geojson of the shops and a leaflet visualization of the percentage of souvenirshops per neighbourhood                  #                                           #
##########################################################################################################################################

# Note: a Google API key is needed for this script

# Libraries
library(geojsonio)
library(ggmap)
library(googleway)
library(leaflet)
library(tidyverse)
library(sf)
library(sp)
library(GISTools)
library(mapview)
library(raster)
source('scripts/E_combine_google_places_results.R')
source('scripts/E_get_sample_locations.R')


# Importing the neighbourhood polygons --------------------------
nbr <- geojsonio::geojson_read("data/GEBIED_BUURTEN.json",what = "sp")

# The polygons should be in a projection system with metrics (not degrees) to get a correct sampling scheme in the next step
nbr <- spTransform(nbr, "+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +units=m +no_defs")


# Create sampling locations for retrieving shops with certain grid interval length --------------------------
# Note: The radius should be adjusted according to an estimate of the density of shops (in meters)

# souvenirshops sampling locations
radius_souv <- 1200
locations_souv <- sample_locations(nbr, radius = radius_souv)
coordslocs_souv <- coordinates(spTransform(locations_souv, '+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs'))

# restaurants sampling locations
radius_rest <- 500
locations_rest <- sample_locations(nbr, radius = radius_rest)
coordslocs_rest <- coordinates(spTransform(locations_rest, '+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs'))

# shops sampling locations
radius_store <- 150
locations_store <- sample_locations(nbr, radius = radius_store)
coordslocs_store <- coordinates(spTransform(locations_store, '+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs'))

# Check if the samples occur in the boundaries of the area of interest
plot(nbr)
plot(locations_souv, add = T, col = 'red')
plot(locations_rest, add = T, col = 'blue')


# Try out the google_places function to get familiar with its outputs -----------------------
restaurant_ams1 <- google_places(key = api_key, location = c(coordslocs_rest[1,2], coordslocs_rest[1,1]), 
                                 radius = radius_rest, search_string = 'restaurant')
restaurant_ams1.2 <- google_places(key = api_key, location = c(coordslocs_rest[1,2], coordslocs_rest[1,1]), 
                                   radius = radius_rest, search_string = 'restaurant', page_token = restaurant_ams1$next_page_token)


# API key (Google API account needed) --------------------------
api_key = # INSERT GOOGLE API KEY


### SOUVENIR SHOPS ### -----------------------------------------

# Try out if the all_google_places function works and returns 60 results 
souvenirshops_ams <- all_google_places(key = api_key, search_string = 'Souvenir shop', 
                                   location = c(coordslocs_souv[1,2], coordslocs_souv[1,1]), radius = radius_souv)

souvenirshops_ams %>% leaflet() %>% addProviderTiles(providers$OpenStreetMap.BlackAndWhite) %>% 
  addMarkers()

# Search the complete area of interest with the designed sampling scheme
souvenirshops_ams <- NULL
for(r in 1:nrow(coordslocs_souv)){
  new_souvenirshops <- all_google_places(key = api_key, search_string = 'Souvenir shop', 
                                     location = c(coordslocs_souv[r,2], coordslocs_souv[r,1]), 
                                     radius = radius_souv)
  souvenirshops_ams <- rbind(souvenirshops_ams, new_souvenirshops)
}

# Make a back_up of all shops found and then remove the duplicates
souvenirshops_backup <- souvenirshops_ams
souvenirshops_ams <- souvenirshops_ams[!duplicated(souvenirshops_ams$place_id),]

# Write the souvenir shop outputs to a CSV file
write.csv(souvenirshops_backup, file = 'output/souvenirshops_amsterdam_backup.csv')
write.csv(souvenirshops_ams, file = 'output/souvenirshops_amsterdam.csv')

# If you have run the code above already and do not want to use credits to run the same code then read in the data:
#souvenirshops_ams <- read.csv('output/souvenirshops_amsterdam.csv', header = T)


### RESTAURANTS (Bonus) ### -----------------------------------------
# all steps taking under the heading souvenirshops are replicated in this section

restaurant_ams <- all_google_places(key = api_key, location = c(coordslocs_rest[25,2], coordslocs_rest[25,1]), 
                                   radius = radius_rest, search_string = 'restaurant')
dim(restaurant_ams)


restaurants_ams <- NULL
for(r in 1:nrow(coordslocs_rest)){
  new_restaurants <- all_google_places(key = api_key, search_string = 'restaurant', 
                                         location = c(coordslocs_rest[r,2], coordslocs_rest[r,1]), 
                                         radius = radius_rest)
  restaurants_ams <- rbind(restaurants_ams, new_restaurants)
}
restaurants_backup <- restaurants_ams
restaurants_ams <- restaurants_backup[!duplicated(restaurants_backup$place_id),]

write.csv(restaurants_backup, file = 'output/restaurants_amsterdam_backup.csv')
write.csv(restaurants_ams, file = 'output/restaurants_amsterdam.csv')

# If you have run the code above already and do not want to use credits to run the same code then read in the data:
#restaurants_ams <- read.csv('output/restaurants_amsterdam.csv', header = T)


### ALL STORES ### ----------------------
# all steps taking under the heading souvenirshops are replicated in this section

stores_ams <- all_google_places(key = api_key, location = c(coordslocs_store[25,2], coordslocs_store[25,1]), 
                                    radius = radius_store, search_string = 'shop')
dim(stores_ams)

stores_ams <- NULL
for(r in 1:nrow(coordslocs_store)){
  new_stores <- all_google_places(key = api_key, search_string = 'shop', 
                                       location = c(coordslocs_store[r,2], coordslocs_store[r,1]), 
                                       radius = radius_store)
  stores_ams <- rbind(stores_ams, new_stores)
}
stores_backup <- stores_ams
stores_ams <- stores_backup[!duplicated(stores_backup$place_id),]

write.csv(stores_backup, file = 'output/stores_amsterdam_backup.csv')
write.csv(stores_ams, file = 'output/stores_amsterdam.csv')

# If you have run the code above already and do not want to use credits to run the same code then read in the data:
#stores_ams <- read.csv('output/stores_amsterdam.csv', header = T)


# Count shops per neighbourhood ------------------------------

# Transformations to ensure neighbourhoods and shops are in same projection system
coordinates(souvenirshops_ams) <- ~lng+lat
crs(souvenirshops_ams) <- "+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs +towgs84=0,0,0"

coordinates(stores_ams) <- ~lng+lat
crs(stores_ams) <- "+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs +towgs84=0,0,0"

nbr <- spTransform(nbr, "+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs +towgs84=0,0,0")

# Check that the shop locations coincide with the area of interest
plot(nbr)
plot(stores_ams, add = T, col = 'blue')
plot(souvenirshops_ams, add = T, col = 'green')

# Count the number of shops per neighbourhood
counts_stores <- poly.counts(stores_ams, nbr)
counts_souv <- poly.counts(souvenirshops_ams, nbr)

# Derive percentages of souvenirshops and clean up the result
nbr$total_stores <- counts_stores
nbr$souvenirshops <- counts_souv
nbr$perc_souvenir <- counts_souv/counts_stores*100
nbr$perc_souvenir <- ifelse(is.nan(nbr$perc_souvenir), NA, nbr$perc_souvenir)
nbr$perc_souvenir <- ifelse(nbr$perc_souvenir == Inf, 100, nbr$perc_souvenir)
nbr$perc_souvenir <- ifelse(nbr$perc_souvenir > 100, 100, nbr$perc_souvenir)


# Final visualization ----------------------------

# Set the color scheme
bins <- seq(0, 100, by = 20)
pal <- colorBin('Purples', domain = nbr@data$perc_souvenir, bins = bins)

north_arrow <- "<img src='http://pluspng.com/img-png/free-png-north-arrow-big-image-png-1659.png' style='width:30px;height:40px;'>"

# create the map object through a function
souvenirshops <- function(nbr){ 
  map <- leaflet() %>% setView(lng = 4.898940, lat = 52.382676, zoom = 11)
  map %>% addProviderTiles(providers$OpenStreetMap.BlackAndWhite) %>% 
    addPolygons(data = nbr,color = "#444444", weight = 0.4, smoothFactor = 0.5,
                opacity = 1.0, fillOpacity = 0.7, fillColor = ~pal(perc_souvenir),
                popup = ~paste('<b>Number of shops:<b>',as.character(total_stores), 
                               '<br/<b>Number of souvenir shops:<b>', as.character(souvenirshops)),
                highlightOptions = highlightOptions(color = "white", weight = 2,
                                                    bringToFront = TRUE)) %>%
    addLegend("bottomright", pal = pal, values = nbr$perc_souvenir,
              title = "Souvenir shops (%)",
              opacity = 0.5, na.label = "No shops") %>%
    addControl(html = north_arrow , position = "topright")%>%
    addScaleBar(position = 'bottomleft',options = scaleBarOptions(maxWidth = 250, imperial = F))
} 

shops_map <- souvenirshops(nbr)
shops_map

# Save the map as a PNG 
mapshot(shops_map, file = 'output/shopsplot.png', remove_controls = 'zoomControl')
