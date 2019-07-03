# main script for data analysis

# libraries and scripts
library(geojsonio)
library(sf)
library(leaflet)
library(htmltools)
library(htmlwidgets)
library(tidyverse)

source('scripts/addresslocator.R')


# load in data
hotels <- read.csv('data/hotels_amsterdam.csv', stringsAsFactors = FALSE)

# Clean data
hotels <- hotels[1:nrow(hotels)-1,]
hotels[hotels=="P CORNELISZ HOOFTSTR"]<-"PIETER CORNELISZ HOOFTSTRAAT"
hotels[hotels=="PIETER JACOBSZOONDWARSSTRAAT"]<-"pieter jacobszdwarsstraat"
hotels[hotels=="PROVINCIALE WEG"]<-"provincialeweg"
hotels[hotels=="1054BV"]<-""
hotels[hotels=="1E C HUYGENSSTR"]<- "Eerste+Constantijn+Huygensstraat"
hotels[hotels=="103-105"]<- 103
hotels[hotels=="315-331"] <- 315
hotels[hotels=="387-390"] <- 387

# read neighbourhood data
nbr <- geojsonio::geojson_read("data/GEBIED_BUURTEN.json",what = "sp")
nbr <- st_as_sf(nbr)

# read airbnb data
airbnb <- geojsonio::geojson_read("data/airbnb2019.geojson",what = "sp")
airbnb <- st_as_sf(airbnb)
keeps <- c("Buurt_code", "Airbnb_BedsCount")
airbnb <- airbnb[keeps]

# read demographic data
inhabs_raw <- read.csv('data/inwoners_amsterdam.csv',stringsAsFactors = FALSE)
inhabs <- inhabs_raw[3:(nrow(inhabs_raw)-2),] # drop irrelevant columns
inhabs$code <- substr(inhabs$X1.1a..Bevolking.buurten..1.januari.2014.2018, start=1, stop=4) # only keep buurtcodes, remove name from column
colnames(inhabs) <- c("neighbourhood","2014","2015", "2016", "2017", "2018_tot", "2018_men", "2018_wom", "Buurt_code")
inhabs$`2018_tot` <- replace(inhabs$`2018_tot`, inhabs$`2018_tot`=='-', 0) # replace - with 0
inhabs$`2018_tot` <- as.numeric(inhabs$`2018_tot`) # turn into numeric factor

# merge neighbourhood data with demographic data
nbr <- merge(nbr,inhabs)
keeps <- c("Buurt_code","Buurt","Stadsdeel_code", "2018_tot","geometry") # drop irrelevant columns
nbr<- nbr[keeps]




# # Geolocate hotels, this has already been done, result is saved in intermediates
# for (row in 1:nrow(hotels)){
#   address <- paste(hotels[row,"STRAAT_2014"],hotels[row,"HUISID_2014"], hotels[row,"POSTCODE_2014"], "Amsterdam")
#   coordinates <- locateAddress(address)
#   as.numeric(levels(coordinates))
#   print(coordinates$lat)
#   hotels[row,"lat"] <- as.numeric(coordinates$lat)
#   print(hotels[row,"lat"])
#   hotels[row,"lon"] <- coordinates$lon
# }
# 
# write.csv(hotels, 'intermediate/geo_hotels.csv')

# read hotel data
hotels <- read.csv('intermediate/geo_hotels.csv', stringsAsFactors = FALSE)
hotels <- st_as_sf(hotels, coords = c('lon', 'lat'), crs = 4326, na.fail=F) # turn into spatial (sf) object

# join hotels with neighbourhoods
joined <- st_join(hotels,nbr) 

# create empty dataframe to store the bedcounts in 
beds <- data.frame(matrix(ncol = 2, nrow = 0),stringsAsFactors = F)
x <- c("Buurt_code", "Beds")
colnames(beds) <- x

# Get a tally of beds per neighbourhood
for (neighbourhood in unique(joined$Buurt_code)){
  localHotels <- joined[which(joined$Buurt_code == neighbourhood),]
  bedCount <- sum(localHotels$BED_2014)
  plusbeds <- data.frame(matrix(c(neighbourhood,bedCount),ncol=2),stringsAsFactors = F)
  colnames(plusbeds) <- x
  beds <- rbind(beds,plusbeds)
}
beds$Beds <- as.numeric(beds$Beds)

# merge hotelbed data with neighbourhoods
nbr <- merge(nbr,beds,all.x=T)
options(scipen = 999)

# merge airbnb data with neighbourhoods
airdf <- data.frame(airbnb)
keeps <-  c("Buurt_code","Airbnb_BedsCount")
airdf <- airdf[keeps]
nbr <- merge(nbr, airdf,all.x=T)

# convert data to proper classes
nbr$Beds <- as.numeric(as.character(nbr$Beds))
nbr$`2018_tot` <- as.numeric(as.character(nbr$'2018_tot'))



# calculate hotelbed pressure: bed pressure = hotelbeds / (hotelbeds + inhabitants)
nbr$hotelbed_pressure <- round(nbr$Beds/(nbr$`2018_tot`+nbr$Beds)*100)

# create a column with html text that will display as a popup for the hotel layer
nbr$hotelpopup <- paste("<strong>", nbr$Buurt, "</strong><br/>Hotelbeds: ", 
                   nbr$Beds, "<br/>Inhabitants: ", nbr$`2018_tot`, "<br/>Hotel Bed pressure: ", nbr$hotelbed_pressure )


# calculate airbnb pressure: airbnbbed pressure = airbnbbeds / (inhabitants)
nbr$airbnbbed_pressure <- round(nbr$Airbnb_BedsCount/(nbr$`2018_tot`+nbr$Airbnb_BedsCount)*100)

# create a column with html text that will display as a popup for the airbnb layer
nbr$airbnbpopup <- paste("<strong>", nbr$Buurt, "</strong><br/>AirBnB beds: ", 
                         nbr$Airbnb_BedsCount, "<br/>Inhabitants: ", nbr$`2018_tot`, "<br/>AirBnB Bed pressure: ", nbr$airbnbbed_pressure )

# calculate total pressure: total pressure = airbnbbeds + hotelbeds / (inhabitants)
nbr$total_pressure <- round((nbr$Airbnb_BedsCount+nbr$Beds)/(nbr$`2018_tot`+nbr$Beds + nbr$Airbnb_BedsCount)*100)

# create a column with html text that will display as a popup for the airbnb layer
nbr$totalpopup <- paste("<strong>", nbr$Buurt, "</strong><br/>Total beds: ", 
                         (nbr$Airbnb_BedsCount+nbr$Beds), "<br/>Inhabitants: ", nbr$`2018_tot`, "<br/>Total Bed pressure: ", nbr$airbnbbed_pressure )


# write the neighbourhood datasite to file
st_write(nbr,dsn='output/neighbourhoods.geojson', driver='GeoJSON')


# create a column with html text that will display as a popup
hotels$popup <- paste("<strong>", hotels$ï..HOTELNAAM_2014, "</strong><br/>Beds: ",hotels$BED_2014)
# https://www.google.nl/search?q=IBIS+AMSTERDAM+CITY+WEST&oq=IBIS+AMSTERDAM+CITY+WEST

st_write(hotels,dsn='output/hotels.geojson', driver='GeoJSON')

bins <- c(0, 10, 25, 50, 100)
pal <- colorBin("YlOrRd", domain = states$density, bins = bins)

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

  addPolygons(data = nbr,color = "#444444", weight = 0.4, smoothFactor = 0.5,
              opacity = 1.0, fillOpacity = 0.3,
              fillColor = ~pal(total_pressure),
              highlightOptions = highlightOptions(color = "white", weight = 2,
                                                  bringToFront = TRUE),  popup = ~totalpopup, group = "Total") %>%
  
  addLegend("bottomright", pal = pal, values = nbr$hotelbed_pressure,
            title = "Bed pressure (%)",
            opacity = 0.5, na.label = "No beds") %>%
  addMarkers(data=hotels, clusterOptions = markerClusterOptions(), popup = ~popup) %>%
  addLayersControl(
    baseGroups = c("Hotel Beds", "AirBnB Beds", "Total"),
    options = layersControlOptions(collapsed = FALSE))






