# tourismdashboard
The dashboard goes together with a report. The report can be requested by contacting the owner of this repository.

It describes patterns of tourism in the city of Amsterdam and shows what the (dis)similarities between neighbourhoods are. This is based on hotelbed and AirbnB bed densities, the infiltration of AirBnBs, social media geotagged messages and a clustering analysis.
It supplied together with all the data that is needed to run the app.R script.
Run the app.R script to take a look at the dashboard itself. In there you can find additional information about the visualization.

It is important to keep the names app.R and ui.R like they are. Otherwise it is not possible to run the scripts. This is also the reason that they do not have the same numbering fashion as the other scripts.

We will give a short description about the different scripts that handle parts of the data.


Airbnb and hotel beds
A - Airbnb and hotel beds. This shows something about the density and pressure of beds per inhabitant of the neighbourhood. This corresponds with section 3.2.1 of the report.

Geotagged tweets
B - Geotagged tweets. This shows where in the city the people tweet about what they are doing. This can give an insight in where tourists are moving withing the city. This corresponds with section 3.3.1 of the report

Geotagged Flickr
C - Geotagged Flickr. This shows where in the city people took photo's. This can give an insight in where tourists are moving withing the city. This corresponds with section 3.3.2 of the report

TripAvisor 
D - TripAdvisor. This performs linear regression on a small dataset to see if it is possible to make a prediction on how much people visit musea based on TripAdvisor reviews. This corresponds with section 3.3.3 of the report.

Shop Establishments
E - Shop Establishments. This gets the on and shows where in the city souvenir shops are located. This corresponds with 3.4.2 of the report.

Cluster Analysis.
F - Cluster Analysis. This performs and shows the cluster analysis. It gives an insight which accomodations are most present in which neighbourhood. This corresponds to section 4 of the report
