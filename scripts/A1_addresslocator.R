# Function that takes in address string and returns dataframe containing longitude and latitude in WGS84

# load libraries
library(httr)
library(jsonlite)

locateAddress <- function(address){
  # Construct Query
  prefix <- "https://nominatim.openstreetmap.org/search?q="
  address <- gsub(" ", "+", address)
  postfix <- '&format=json'
  query <- paste0(prefix,address,postfix)
  
  # Make request
  response <- data.frame(content(GET(query)),stringsAsFactors = F)
  if (length(response) > 0){
  # Format response
  keep <- c("lat","lon")
  response <- response[keep]
  Sys.sleep(1)
  return(response)
  }else{
    response <- data.frame(matrix(data=c(NA,NA),ncol = 2))
    colnames(response)<- c("lat", "lon")
  }
  Sys.sleep(1)
  return(response)
}





