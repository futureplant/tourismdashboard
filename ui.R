# TOURISM


sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem("Bed Pressure", tabName = "bedpressure", icon = icon("bed")),
    menuItem("Infiltration", tabName = "infiltration", icon = icon("map-marked-alt")),
    menuItem("Infiltration3D", tabName = "infiltration3d", icon = icon("cube")),
    menuItem("Social Media", tabName = "socialmedia", icon = icon("thumbs-up")),
    menuItem("Clustering", tabName = "clustering", icon = icon("atom"))
  )
)

body <- dashboardBody(
  tabItems(
    tabItem(tabName = "infiltration", h2("Infiltration"),
            fluidRow(column(width = 9,
                            box(width = NULL, solidHeader = TRUE,      #  This constructs a space for the map 
                                leafletOutput("infiltrationmap", height = 500))),
            
            column(width = 3,
                   # Construct box with image and introductory text for the app
                   box(HTML("<strong>Temporary resident PressureAirBnB Infiltration</strong><br/>
                            <p align='justify'>To give an insight on the infiltration of Airbnb in the city of Amsterdam, the average distance from the Airbnb to a hotel was calculated. This shows that for certain neighbourhoods, where there are not many hotels the tourists can still find places to sleep.  The policy makers of the city of Amsterdam have tried to overcome the problem by assigning certain neighbourhoods and places with hotels. The Airbnbs can be of conflict with that policy and allow tourists to be able to spend the night in places where the policy makers have tried to avoid that from happening.<br/ > 
                            </p></p>"), 
                       width = NULL, solidHeader = TRUE
                   )))),
    
    tabItem(tabName = "bedpressure", h2("Bed Pressure"),
            fluidRow(column(width = 9,
                            box(width = NULL, solidHeader = TRUE,      #  This constructs a space for the map 
                                leafletOutput("bedpressuremap", height = 500))),
                     
                     column(width = 3,
                            # Construct box with image and introductory text for the app
                            box(HTML("<strong>Temporary Resident Pressure</strong><br/>
                            <p align='justify'>The popularity of accommodation places has an impact towards communities and housing market in Amsterdam.
Increasing number of accommodations and beds means more places for travelers to stay which leads to increasing pressure in the city and sentiment towards tourism. 
                            Hence, data regarding number of beds can be used as an indicator in explaining the capacity of the city.
                            Tourist intensity, calculated as the number of beds per inhabitant, is a common index used to assess the relative importance of tourism (Gutiérrez et al., 2017; Silva, et al., 2018). 
                            The next map shows both the tourist intensities based on hotel (2014) and Airbnb listing data (2015-2019). <br/ > 
                            </p></p>"), 
                                width = NULL, solidHeader = TRUE
                            )))),
    
    tabItem(tabName = "socialmedia", h2("Social Media"),
            fluidRow(column(width = 9,
                            box(width = NULL, solidHeader = TRUE,      #  This constructs a space for the map 
                                leafletOutput("socialmediamap", height = 500)),
                     plotOutput("hashtagplot", width = "100%", height = "400px", click = NULL,
                                dblclick = NULL, hover = NULL, hoverDelay = NULL,
                                hoverDelayType = NULL, brush = NULL, clickId = NULL,
                                hoverId = NULL, inline = FALSE)),
                     
                     column(width = 3,
                            # Construct box with image and introductory text for the app
                            box(HTML("<strong>Social Media Analysis</strong><br/>
                                     <p align='justify'>Geotagged Flickr photos can be analyzed to discern tourists from local people.
                                      Flickr data contain information about user's country of origin on their profile. 
                                      This information can be used to accurately distinguished geotagged photos and to assess which people from which country visited the city (Bliss, 2015).   
                                      Additionaly, Tourists tend to photograph touristic places frequently, but locals prefer to avoid these places.
                                      Photo locations without information about user's country of origin were labeled using the time the photographs were taken:
                                      +100 photos taken in a month : international
                                      10-10 photos taken in a month : domestic
                                      <10 photos taken in a month: local 
                                      
                                      The map shows the distribution of residents and tourists across cities very well. Geotagged tweets are a textual representation of people's behaviour at a given time and place. The data created from tagging tweets with their location can be used in a number of interesting ways. By looking at what and where in Amsterdam the tourists tweet we get and idea about the tourist density and hot-spot of tourists. For further research is also potential with this kind of data to learn about spatio-temporal pattern for example tourist's behaviour (Di Minin et al., 2015).<br/ > 
                                     </p></p>"), 
                                width = NULL, solidHeader = TRUE
                            )))),
    
    tabItem(tabName = "infiltration3d", h2("Infiltration 3D"),
            fluidRow(column(width = 9, htmlOutput("frame")),
                     
                     column(width = 3,
                            # Construct box with image and introductory text for the app
                            box(HTML("<strong>DAirBnB Infiltration 3D</strong><br/>
                                     <p align='justify'>In order to be able to not only account for the average distance, but also the number of AirBnB addressesm we added an extra dimension to the map that corresponds with airbnb Bed Pressure<br/ > 
                                     </p></p>"), 
                                width = NULL, solidHeader = TRUE
                            )))),
    tabItem(tabName = "clustering", h2("Clusters"),
            fluidRow(column(width = 9,
                            box(width = NULL, solidHeader = TRUE,      #  This constructs a space for the map 
                                leafletOutput("clustermap", height = 500))),
                     
                     column(width = 3,
                            # Construct box with image and introductory text for the app
                            box(HTML("<strong>Clustering</strong><br/>
                            <p align='justify'>Using the variables AirBnB pressure, hotel bed pressure, 
                            number of inhabitants we have carried out a clustering analysis. The clusters 
                            represent the characterization of neighbourhoods based on the input variables. 
                            They show which neighbourhoods are typified by which pressures. </p>
                            <p align='justify'>The map shows that mainly the neighourbourhoods in the 
                            center of Amsterdam have a high ratio of hotels versus inhabitants. Neighbourhoods 
                            adjacent to the city center show higher ratios of airBnBs versus inhabitants. 
                            On the outskirts there is not one of the two that distinguishes them from other 
                            neighbourhoods so they are typified here as a mix.</p>
                            <p align='justify'>This method of clustering could be used on other variables 
                            related to tourist behaviour or sentiment in the neighbourhoods to get a 
                            specification of neighbourhoods and their connection to tourism.<br/ > 
                            </p></p>"), 
                                width = NULL, solidHeader = TRUE
                            ))))
    
    )
    )
  



ui <- dashboardPage(
  dashboardHeader(title = "FairBnB Tourism Dashboard", titleWidth = 450),
  sidebar,
  body,
  skin = "green")
    
  
