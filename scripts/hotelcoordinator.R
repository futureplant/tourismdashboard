# function that adds longitude and latitude to the hotel dataframe
tryWrite <- function(hoteldata, coordinates, row){
  hotels[row,"lat"] <- coordinates$lat
  hotels[row,"lon"] <- coordinates$lon
}

exceptWrite <- function(hoteldata, row){
  hotels[row,"lat"] <- NA
  hotels[row,"lon"] <- NA
}
