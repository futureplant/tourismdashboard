
sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem("Bed Pressure", tabName = "bedpressure", icon = icon("dashboard")),
    menuItem("Infiltration", icon = icon("th"), tabName = "infiltration",
             badgeLabel = "new", badgeColor = "green")
  )
)

body <- dashboardBody(
  tabItems(
    tabItem(tabName = "bedpressure",
            fluidRow(column(width = 9,
                            box(width = NULL, solidHeader = TRUE,      #  This constructs a space for the map 
                                leafletOutput("map", height = 500))
            )
            ,
            
            column(width = 3,
                   
                   # Construct box with image and introductory text for the app
                   box(HTML("<strong>Dummy text</strong><br/>
                    <p align='justify'>This shows temp resident pressure and this shows nice things.
This shows temp resident pressure and this shows nice things.This shows temp resident pressure and this shows nice things.<br/ > 
                    </p>
                    </p>"), width = NULL, solidHeader = TRUE
                   )
            )
            )
    ),
    tabItem(tabName = "infiltration",
            h2("Dashboard tab content")
    )
    )
  )



ui <- dashboardPage(
  dashboardHeader(title = "Tourism Amsterdam"),
  sidebar,
  body)
    
  
