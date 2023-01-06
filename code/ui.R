# Gca Project


library(shiny)
library(shinydashboard)
library(leaflet)
library(leaflet.extras)
library(sp)
library(htmltools)
library(shinyjs)
library(timevis)
library(plotly)
library(highcharter)
library(flexdashboard)
library(rsconnect)
library(shinydisconnect)

timeoutSeconds <- 5

inactivity <- sprintf("function idleTimer() {
var t = setTimeout(logout, %s);
window.onmousemove = resetTimer; // catches mouse movements
window.onmousedown = resetTimer; // catches mouse movements
window.onclick = resetTimer;     // catches mouse clicks
window.onscroll = resetTimer;    // catches scrolling
window.onkeypress = resetTimer;  //catches keyboard actions

function logout(){
Shiny.setInputValue('timeOut', '%ss')
}

function resetTimer() {
clearTimeout(t);
t = setTimeout(logout, %s);  // time is in milliseconds (1000 is 1 second)
}
}
idleTimer();", timeoutSeconds*1000*31*12*86400, timeoutSeconds, timeoutSeconds*1000*31*12*86400)

shinyUI(
  
  dashboardPage(title = "GCA Project",
                
                dashboardHeader(disable = TRUE),
                dashboardSidebar(disable = TRUE),
                
                dashboardBody(
                  # error hiding
                  tags$style(type="text/css",
                             ".shiny-output-error { visibility: hidden; }",
                             ".shiny-output-error:before { visibility: hidden; }",
                             HTML(".red_style   { border-color: green; color: white; background-color: red; }",
                                  ".butt{color:green;} .butt{width:30%;} .butt{height:35px;} .butt{font-size: 18px;} "
                             )),
                  
                  
                  
                  #HTML("<br/><br/>"),
                  #column(6,fluidRow(leafletOutput("mymap", width = "100%", height = 850))),
                  #useShinyjs()
                  tags$script(inactivity),
                  fluidPage(leafletOutput("mymap", width = "100%", height = 750)),
                  useShinyjs()
                )
  )
)

