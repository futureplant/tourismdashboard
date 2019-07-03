##############################################################################
## Function to create Mapdeck 3D visualizaiton of Airbnb infiltration
##  Inputs is neighbourhoods_infiltration2018 geojson
##  Output is a HTML containing 3D map visualization
##  HTML demo is uploaded in different repository :
##    https://github.com/WilliamTjiong/fairbnb-airbnbmapdeck
###############################################################################

#load libraries
source('./source/EasyLoad.R')
packages <- c('mapdeck','rgdal','sf','geojsonsf','htmlwidgets')
EasyLoad(packages)

key = 'input own key here'

infiltration_geojson <-geojson_sf('./output/airbnbinfiltration_data/neighbourhoods_infiltration2018.geojson')
infiltration_geojson$dist2hot2018 <-as.numeric(infiltration_geojson$dist2hot2018)
infiltration_geojson$Airbnb_TouristIntensity <-as.numeric(infiltration_geojson$Airbnb_TouristIntensity)
infiltration_geojson$Airbnb_TouristIntensity <- infiltration_geojson$Airbnb_TouristIntensity *1000
infiltration_geojson$tooltip <- NA

for(i in 1:nrow(infiltration_geojson)) {
  infiltration_geojson$tooltip[i] <- paste("<strong>",infiltration_geojson$Buurt[i],'</strong><br/>',
                                           '<b>Mean distance Airbnb-Hotel 2018 (m):</b>',infiltration_geojson$dist2hot2018[i],"<br>",
                                           '<b>Hotel bed count 2018:</b>',infiltration_geojson$Airbnb_BedsCount[i],"<br>",
                                           '<b>Airbnb bed intensity 2018:</b>',infiltration_geojson$Airbnb_TouristIntensity[i],"<br>",
                                           '<b>Airbnb bed count 2018:</b>',infiltration_geojson$Airbnb_BedsCount[i],"<br>",
                                           '<b>Population 2018:</b>',infiltration_geojson$Pop2018[i]) 
}



ms = mapdeck_style("light")
m <- mapdeck(token = key,style = ms, pitch = 45, location = c(4.895168, 52.370216),zoom=10) %>%
add_polygon(data = infiltration_geojson,fill_colour = "dist2hot2018", na_colour = "#00ff000",elevation = 'Airbnb_TouristIntensity',legend=T,
    update_view = F,auto_highlight =T,highlight_colour = "#AAFFFFFF",
    tooltip = 'tooltip',palette = 'ylorrd',legend_options = list(title='Mean distance Airbnb-Hotel 2018 (m)')
  )
saveWidget(m, file="./infiltration_mapdeck.html",selfcontained = T)



