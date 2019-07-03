# Clustering analysis for neighbourhoods of Amsterdam


# Load functions
library(geojsonio)
library(leaflet)
source('scripts/ggbiplot.R')


# Load data
nghbrhd <- geojson_read("output/neighbourhoods.geojson",what = "sp")
nghbrhd_data <- nghbrhd@data
names(nghbrhd_data)
nghbrhd_stats <- nghbrhd_data[, c('X2018_tot', 'hotelbed_pressure', 'airbnbbed_pressure')]

nghbrhd_stats$hotelbed_pressure[is.na(nghbrhd_stats$hotelbed_pressure)] <-  0
nghbrhd_stats$airbnbbed_pressure[is.na(nghbrhd_stats$airbnbbed_pressure)] <-  0

region_codes <- nghbrhd$Stadsdeel_code

codes <- as.character(unique(region_codes))
names <- c('Centrum', 'Westpoort', 'West', 'Nieuw-West', 'Zuid', 'Oost', 'Noord', 'Zuidoost')
lookup_region <- as.data.frame(cbind(codes, names))

nghbrhd_data <- merge(nghbrhd_data, lookup_region, by.x = 'Stadsdeel_code', by.y = 'codes')


region_names <- nghbrhd_data$names

# Scale variables  
nghbrhd_stats_sc <- scale(nghbrhd_stats )  
  
# Principal Component Analysis (PCA) to see how variables are grouped together
pca <- prcomp(nghbrhd_stats_sc)


ggbiplot(pca, choices = 1:2, groups = region_names, ellipse = TRUE) +
  ggtitle('Principal Components Analysis', 'Neighbourhoods of Amsterdam')


ggbiplot(pca, choices = 2:3, groups = region_names, ellipse = TRUE) +
  ggtitle('Principal Components Analysis', 'Neighbourhoods of Amsterdam')


# Kmeans clustering
number_clusters <- 3
clustering <- kmeans(nghbrhd_stats_sc, centers = number_clusters)
clusters <- clustering$cluster

plot(nghbrhd_stats_sc[,1], nghbrhd_stats_sc[,3], col = palette()[clusters])



cols <- terrain.colors(length(unique(region_names)))
names(cols) <- unique(region_names)
par(mfrow = c(1,3))
for (i in 1:number_clusters) {
  region.tab <- table(region_names[clusters == i])
  colors = cols[sort(unique(region_names[clusters == i]))]
  
  pie(region.tab, labels = names(region.tab), col = colors, main = paste('Cluster', i), clockwise = TRUE)
}


# Add clusters to neighbourhood spatial object as well as a label
dim(nghbrhd@data)

nghbrhd@data$similarityCluster <- clusters

lookup_cluster <- as.data.frame(cbind(c('Hotel', 'Mix', 'AirBnB'), unique(clusters)))
names(lookup_cluster) <- c('cluster_label', 'cluster_number')

merged <- merge(nghbrhd@data, lookup_cluster, by.x = 'similarityCluster', 
                      by.y = 'cluster_number')

nghbrhd@data$cluster_label <- merged[,'cluster_label']


nghbrhd <- st_as_sf(nghbrhd)
st_write(nghbrhd, dsn = 'output/clusternbr.geojson', driver = 'GeoJSON')

nghbrhd$similarityCluster <- as.factor(nghbrhd$similarityCluster) #, levels = c(1,2,3), labels = c('AirBnB', 'Mix', 'Hotel'))

# 
# pal <- colorFactor(c(rainbow(2), rainbow(3), rainbow(4)), domain = 1:number_clusters)
# pal1 <- colorFactor(rainbow(n=4), domain = 1:number_clusters)
# pal2 <- colorFactor(rainbow(n=4), domain = nghbrhd@data$cluster_label)
# 
# 
# m <- leaflet() %>% setView(lng = 4.898940, lat = 52.382676, zoom = 11)
# m %>% addProviderTiles(providers$OpenStreetMap.BlackAndWhite) %>%
#   addPolygons(data = nghbrhd,color = "#444444", weight = 0.4, smoothFactor = 0.5,
#               opacity = 1.0, fillOpacity = 0.5,
#               fillColor = ~pal1(similarityCluster),
#               popup = ~as.character(similarityCluster),
#               highlightOptions = highlightOptions(color = "white", weight = 2, bringToFront = TRUE)) %>%
#   addLegend("bottomright", pal = pal1, values = nghbrhd$similarityCluster,
#             labels = c('Airbnb','Hotel', 'Mix', ''),
#             title = "Clusters", opacity = 0.5)
# # pal = pal1, values = nghbrhd$similarityCluster, 



clust_viz <- factor(clusters, levels = c(1,2,3), labels = c('AirBnB', 'Mix', 'Hotel'))
nghbrhd$clust_viz <- clust_viz

pal1 <- colorFactor(rainbow(n=4), domain = nghbrhd$clust_viz)

m %>% addProviderTiles(providers$OpenStreetMap.BlackAndWhite) %>%
  addPolygons(data = nghbrhd,color = "#444444", weight = 0.4, smoothFactor = 0.5,
              opacity = 1.0, fillOpacity = 0.5,
              fillColor = ~pal1(clust_viz),
              popup = ~as.character(clust_viz),
              highlightOptions = highlightOptions(color = "white", weight = 2, bringToFront = TRUE)) %>%
  addLegend("bottomright", pal = pal1, values = nghbrhd$clust_viz,
            title = "Clusters", opacity = 0.5)
