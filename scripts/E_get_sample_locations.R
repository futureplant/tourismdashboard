#################################################################################################################################
## This function creates sampling points on a regular grid from an area of interest and a radius (distance between points)      #
##    Inputs are a polygon object from the area of interest and a radius parameter                                              #
##    Output is a SpatialPoints object according to the desired sampling scheme                                                 #
#################################################################################################################################

# The overlapfactor equal to 1 means that the radius of each pair of neighbour points overlaps, when > 1 there is less overlap

library(raster)

sample_locations <- function(area_object, radius, overlapfactor = 1.5){
  
  # Derive extent from polygon of area of interest
  area_extent <- raster::extent(area_object)
  xlength <- area_extent[2] - area_extent[1]
  ylength <- area_extent[4] - area_extent[3]
  
  # Determine number of sampling points based on radius and extent
  if(xlength > ylength){
    numberlocs <- round(xlength / (radius*overlapfactor))
  } else numberlocs <- round(ylength / (radius*overlapfactor))
  
  # Execute the sampling algorithm (regular grid)
  locations <- spsample(area_object, n = numberlocs, type = 'regular')
  
  return(locations)
}
