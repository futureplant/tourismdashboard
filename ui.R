# TOURISM


sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem("Bed Pressure", tabName = "bedpressure", icon = icon("bed")),
    menuItem("Infiltration", tabName = "infiltration", icon = icon("map-marked-alt")),
    menuItem("Social Media", tabName = "socialmedia", icon = icon("thumbs-up")),
    menuItem("Housing", tabName = "housing", icon = icon("home"))
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
                   box(HTML("<strong>Dummy text</strong><br/>
                            <p align='justify'>This shows temp resident pressure and this shows nice things.
                            This shows temp resident pressure and this shows nice things.This shows temp resident pressure and this shows nice things.<br/ > 
                            </p></p>"), 
                       width = NULL, solidHeader = TRUE
                   )))),
    
    tabItem(tabName = "bedpressure", h2("Bed Pressure"),
            fluidRow(column(width = 9,
                            box(width = NULL, solidHeader = TRUE,      #  This constructs a space for the map 
                                leafletOutput("bedpressuremap", height = 500))),
                     
                     column(width = 3,
                            # Construct box with image and introductory text for the app
                            box(HTML("<strong>Dummy text</strong><br/>
                            <p align='justify'>This shows temp resident pressure and this shows nice things.
                            This shows temp resident pressure and this shows nice things.This shows temp resident pressure and this shows nice things.<br/ > 
                            </p></p>"), 
                                width = NULL, solidHeader = TRUE
                            )))),
    
    tabItem(tabName = "socialmedia", h2("Social Media"),
            fluidRow(column(width = 9,
                            box(width = NULL, solidHeader = TRUE,      #  This constructs a space for the map 
                                leafletOutput("socialmediamap", height = 500))),
                     
                     column(width = 3,
                            # Construct box with image and introductory text for the app
                            box(HTML("<strong>Dummy text</strong><br/>
                                     <p align='justify'>This shows temp resident pressure and this shows nice things.
                                     This shows temp resident pressure and this shows nice things.This shows temp resident pressure and this shows nice things.<br/ > 
                                     </p></p>"), 
                                width = NULL, solidHeader = TRUE
                            )))),
    
    tabItem(tabName = "housing", h2("Housing"),
            fluidRow(column(width = 9, htmlOutput("frame")),
                     
                     column(width = 3,
                            # Construct box with image and introductory text for the app
                            box(HTML("<strong>Dummy text</strong><br/>
                                     <p align='justify'>This shows temp resident pressure and this shows nice things.
                                     This shows temp resident pressure and this shows nice things.This shows temp resident pressure and this shows nice things.<br/ > 
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
    
  
