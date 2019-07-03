###################################################################################################################################################
## Script that performs a clustering analysis on retrieved data for the neihbourhoods of Amsterdam as described in Chapter 4 of the report        #
##    Inputs are data retrieved in scripts with an A prefix but can be adjusted to incorporte more variables                                      #
##    Output is a geojson and a leaflet visualization of the clustered neighbourhoods                                                             #
###################################################################################################################################################


# Load functions
library(geojsonio)
library(leaflet)
library(sf)
source('scripts/F_ggbiplot.R')


# Load data ---------------------
nghbrhd <- geojson_read("output/neighbourhoods.geojson", what = "sp")
nghbrhd_data <- nghbrhd@data

# Choose which columns will serve as input variables for the clustering algorithm
names(nghbrhd_data)
nghbrhd_stats <- nghbrhd_data[, c('X2018_tot', 'hotelbed_pressure', 'airbnbbed_pressure')]


# Data handling ---------------------

# Remove NA values
nghbrhd_stats$hotelbed_pressure[is.na(nghbrhd_stats$hotelbed_pressure)] <-  0
nghbrhd_stats$airbnbbed_pressure[is.na(nghbrhd_stats$airbnbbed_pressure)] <-  0

# Create a lookup table with the region names and codes
region_codes <- nghbrhd$Stadsdeel_code
codes <- as.character(unique(region_codes))
names <- c('Centrum', 'Westpoort', 'West', 'Nieuw-West', 'Zuid', 'Oost', 'Noord', 'Zuidoost')
lookup_region <- as.data.frame(cbind(codes, names))

# Add the region names to the neighbourhood dataframe
nghbrhd_data <- merge(nghbrhd_data, lookup_region, by.x = 'Stadsdeel_code', by.y = 'codes')
region_names <- nghbrhd_data$names

# Scale all variables (important when variables have different ranges)  
nghbrhd_stats_sc <- scale(nghbrhd_stats )  


# Principal Component Analysis (PCA) to see how variables are grouped together ---------------------
pca <- prcomp(nghbrhd_stats_sc)

ggbiplot(pca, choices = 1:2, groups = region_names, ellipse = TRUE) +
  ggtitle('Principal Components Analysis', 'Neighbourhoods of Amsterdam')

ggbiplot(pca, choices = 2:3, groups = region_names, ellipse = TRUE) +
  ggtitle('Principal Components Analysis', 'Neighbourhoods of Amsterdam')


# Kmeans clustering ---------------------

number_clusters <- 3 # Adjust based on hypotheses on the input variables
clustering <- kmeans(nghbrhd_stats_sc, centers = number_clusters)
clusters <- clustering$cluster

# Visual check on the clusters, can be done with different columns
plot(nghbrhd_stats_sc[,1], nghbrhd_stats_sc[,3], col = palette()[clusters])

# Pie chart to show which regions appear most in which cluster
cols <- terrain.colors(length(unique(region_names)))
names(cols) <- unique(region_names)
par(mfrow = c(1,3))
for (i in 1:number_clusters) {
  region.tab <- table(region_names[clusters == i])
  colors = cols[sort(unique(region_names[clusters == i]))]
  
  pie(region.tab, labels = names(region.tab), col = colors, main = paste('Cluster', i), clockwise = TRUE)
}


# Prepare clustering output ---------------------

# Add clusters to neighbourhood spatial object as well as a label
# Note: infer from the clusters and the PCA which labels fit which cluster
clust <- factor(clusters, levels = c(1,2,3), labels = c('Hotel', 'Mix', 'Airbnb'))
nghbrhd$clust <- clust

# Write the output to geojson
nghbrhd <- st_as_sf(nghbrhd)
st_write(nghbrhd, dsn = 'output/neighbourhoods_clustered.geojson', driver = 'GeoJSON', delete_dsn = T)


# Visualization of the neighbourhoods assigned to clusters ---------------------
pal1 <- colorFactor(rainbow(n=number_clusters), domain = nghbrhd$clust)

cluster_map <- leaflet() %>% setView(lng = 4.898940, lat = 52.382676, zoom = 11)
cluster_map %>% addProviderTiles(providers$OpenStreetMap.BlackAndWhite) %>%
  addPolygons(data = nghbrhd,color = "#444444", weight = 0.4, smoothFactor = 0.5,
              opacity = 1.0, fillOpacity = 0.5,
              fillColor = ~pal1(clust),
              popup = ~as.character(clust),
              highlightOptions = highlightOptions(color = "white", weight = 2, bringToFront = TRUE)) %>%
  addLegend("bottomright", pal = pal1, values = nghbrhd$clust,
            title = "Clusters", opacity = 0.5)
