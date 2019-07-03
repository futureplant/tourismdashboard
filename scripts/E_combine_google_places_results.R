#########################################################################################################################
## Script that combines all possible results (maximum 60) from a Google Places API request                              #
##    Inputs are the inputs required for the google_places function from  the googleway package                         #
##    Output is a single dataframe with 60 results (if they exist for the request) from the Google Places API           #
#########################################################################################################################

# Note: this script only keeps the attributes 'formatted_address', 'name', 'place_id', 'lat', 'lng'
# the script would have to be altered to include more attributes, however google_places returns attributes 
# of the type list and data.frame which does not work in the rbind function


all_google_places <- function(key, search_string = NULL, location = NULL, radius = NULL,
                              rankby = NULL, keyword = NULL, language = NULL,
                              place_type = NULL){
  
  # Request the results for one location/search_string per 20 results
  # A system sleep is required to have a valid next_page_token
  search1_lst <- google_places(location = location,radius = radius, 
                               place_type = place_type, language = language, 
                               search_string = search_string, key = key)
  Sys.sleep(2)
  search1.2_lst <- google_places(page_token = search1_lst$next_page_token,
                                 search_string = search_string, key = key)
  Sys.sleep(2)
  search1.3_lst <- google_places(page_token = search1.2_lst$next_page_token,
                                 search_string = search_string, key = key)
  
  # Add latitude and longitude to the data frames of the 20 places
  if(search1_lst$status == 'OK'){
    places1 <- search1_lst$results
    places1$lat <- search1_lst$results$geometry$location$lat
    places1$lng <- search1_lst$results$geometry$location$lng
  } else places1 <- NULL
  
  if(search1.2_lst$status == 'OK'){
    places1.2 <- search1.2_lst$results
    places1.2$lat <- search1.2_lst$results$geometry$location$lat
    places1.2$lng <- search1.2_lst$results$geometry$location$lng
  } else places1.2 <- NULL
  
  if(search1.3_lst$status == 'OK'){
    places1.3 <- search1.3_lst$results
    places1.3$lat <- search1.3_lst$results$geometry$location$lat
    places1.3$lng <- search1.3_lst$results$geometry$location$lng
  } else places1.3 <- NULL
 
  # Remove columns that prohibit an rbind of the 3x20 results
  keep_cols <- c('formatted_address', 'name', 'place_id', 'lat', 'lng')
  
  places1 <- places1[keep_cols]
  places1.2 <- places1.2[keep_cols]
  places1.3 <- places1.3[keep_cols]

  
  # Comine the places and remove any duplicates
  all_places <- rbind(places1, places1.2, places1.3)
  all_places <- all_places[!duplicated(all_places$place_id),]
  
  return(all_places)
}