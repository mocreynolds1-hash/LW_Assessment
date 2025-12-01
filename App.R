
install.packages("shiny")
install.packages("leaflet")
install.packages("leafem")
install.packages("RColorBrewer")
install.packages("ggiraph")
install.packages("dbscan")
install.packages("terra")
install.packages("sf")
install.packages("raster")
install.packages("ggplot2")
install.packages("dplyr")



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
library(dplyr)

options(shiny.maxRequestSize = 1000 * 1024^2)

# Run global script containing all your relevant data ----
source("Global.R")

# Define UI for visualisation ----
source("UI.R")
ui <-  navbarPage("Instream Large Wood on the River Torridge", id = 'nav', 
             tabPanel("Map", div(class="outer", 
                                 leafletOutput("map", height = "calc(100vh - 70px)") ) ) )

# Define the server that performs all necessary operations ----
server <- function(input, output, session){
  source("Server_Function.R", local = TRUE)
}

shinyApp(ui, server)


