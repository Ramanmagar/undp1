# Gca Project

library(shiny)
library(shinydashboard)
library(leaflet)
library(leaflet.extras)
library(rgdal)
library(sp)
library(sf)
library(RPostgreSQL)
library(rjson)
library(pool)
library(DBI)
library(DT)
library(htmltools)
library(dplyr)
library(purrr)
library(shinyjs)
library(raster)
library(rgdal)
library(plotly)
library(stringr)
library(timevis)
library(circular)
library(knitr)
library(tinytex)
library(googleVis)
library(sjmisc)
library(tidyr)



conn <- dbConnect("PostgreSQL", user = "sts", password = "stspostgres$$$", host = "78.138.127.90", port = 5432, dbname = "undp_gca")

##conn <- dbConnect("PostgreSQL",user="postgres",password="123456",host = "localhost", port=5432, dbname="gca")


server <- function(input, output, session) {
  
  observeEvent(input$timeOut,{
    print(paste0("Session (", session$token, ") timed out at: ", Sys.time()))
    showModal(modalDialog(
      title = "Timeout",
      paste("Session timeout due to", input$timeOut, "inactivity -", Sys.time()),
      footer = NULL
    ))
    session$close()
  })

  
  #server database            #  local
  #gca_project_unions         #  gca_project_unions1
  #gca_upazilas1              #  gca_upazilas1
  
output$mymap <- renderLeaflet({
  
  qry <- paste0("SELECT * FROM gca_project_unions;")
  df_1 <- st_read(conn, query=qry, geom="geom")
  df_1 <- st_zm(df_1)
  #print(df_1)
  
  qry2 <- paste0("SELECT * FROM gca_upazilas1;")
  df_2 <- st_read(conn, query=qry2, geom="geom")
  df_2 <- st_zm(df_2)
  
  lon <- map_dbl(df_1$geom, ~st_centroid(.x)[[1]])
  lat <- map_dbl(df_1$geom, ~st_centroid(.x)[[2]])

  leaflet() %>%
    #setView(lng = lon, lat = lat, zoom = 10) %>%
    
    addProviderTiles("OpenStreetMap" , options = providerTileOptions( maxZoom = 18)) %>%
    
    addPolygons(data = df_1, fillColor = "white", stroke = T,weight = 3,
                smoothFactor = 1,opacity = 0.3, color = 'green',
                highlight = highlightOptions(weight = 3,
                                             color = "red",
                                             fillOpacity = 0.1,
                                             bringToFront = TRUE),
                label =  lapply(paste("<h4 style='color: #006400;'>", df_1$uniname, " <h4>") , HTML),
                labelOptions = labelOptions(noHide = T, textOnly = TRUE, opacity=1, textsize='1px')
    ) %>%
    
    addPolygons(data = df_2, fillColor = "white",
                weight = 5,
                smoothFactor = 0,opacity = 1, color = 'blue',
                label =  lapply(paste("<b style='color: #000000;'> ", df_2$thaname,"<b>", " <h3>"), HTML),
                labelOptions = labelOptions(noHide = T, textOnly = TRUE, opacity=1, textsize='20px'),
                highlight = highlightOptions(weight = 5,
                                             color = "red",
                                             fillOpacity = 0.1,
                                             bringToFront = T)
    ) %>%
    
    addResetMapButton()
})


#(shiny)
#folder_address = 'E://undp_gca//code'

#x <- system("ipconfig", intern=TRUE)
#z <- x[grep("IPv4", x)]
#ip <- gsub(".*? ([[:digit:]])", "\\1", z)
#print(paste0("the Shiny Web application runs on: http://", '127.0.0.1', ":3838/"))

#runApp(folder_address, launch.browser=FALSE, port = 3838, host = '127.0.0.1')

}






















