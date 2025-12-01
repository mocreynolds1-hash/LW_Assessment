
install.packages("shiny")
install.packages("leaflet")
install.packages("leafem")
install.packages("RColorBrewer")
install.packages("ggiraph")




library(shiny)
library(leaflet)
library(sf)
library(raster)
library(ggplot2)
library(dbscan)
library(ggiraph)
library(RColorBrewer)
library(terra)
library(leafem)

options(shiny.maxRequestSize = 1000 * 1024^2)

# Run global script containing all your relevant data ----
source("/Users/milliereynolds/Documents/Masters/GIS/Practicals/Global.R")

# Define UI for visualisation ----
source("/Users/milliereynolds/Documents/Masters/GIS/Practicals/UI.R")
ui <-  navbarPage("Instream Large Wood on the River Torridge", id = 'nav', 
             tabPanel("Map", div(class="outer", 
                                 leafletOutput("map", height = "calc(100vh - 70px)") ) ) )

# Define the server that performs all necessary operations ----
server <- function(input, output, session){
  source("/Users/milliereynolds/Documents/Masters/GIS/Practicals/Server_Function.R", local = TRUE)
}

shinyApp(ui, server)


