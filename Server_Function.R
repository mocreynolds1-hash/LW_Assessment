
#################################################################
##           Practical 6 for GEOM184 - Open Source GIS         ##
##                      14/11/2025                             ##
##                  Creating a ShinyApp                        ##
##                       Server.R                              ##
#################################################################

# S1 Render leaflet map ----
# Leaflet map output
output$map <- renderLeaflet({
  
  leaflet() %>% 
    
    setView(lng= -4.206878, lat= 50.916601, zoom=11.3) %>%
    
    addProviderTiles (providers$OpenStreetMap, group = "Colour") %>%
    addRasterImage(heatmap, colors = pal_heatmap, opacity = 0.7, group = "Heatmap") %>%
    addLegend(
      position = "bottomright",        
      pal = pal_heatmap,          
      values = c(minValue(heatmap), maxValue(heatmap)), 
      title = "Largewood Frequency <br> 350m Radius",     
      labFormat = labelFormat(digits = 2),
      opacity = 1, 
      group = "Heatmap"                
    ) %>%
    
    #addRasterImage(slope1, colors = pal_slope1, opacity = 0.7, group = "Slope") %>%
    
  addRasterImage(aspect1, colors = pal_aspect1, opacity = 0.7, group = "Aspect") %>%
  
  #addPolylines(data = river, color = "blue", weight = 2, opacity = 0.8, group = "River") %>%
    addCircles(data = bridges,
               color = "black",
               fillColor="black",
               fillOpacity=0.9,
               weight = 2,
               radius = 50,
               popup = paste("<br><b>BRIDGE.NAM:</b>", bridges$BRIDGE.NAM,
                             "<br><b>Upstream LW:</b>", bridges$LW_upstream),
               group = "Bridges") %>%
    
    # add wood catchers
    addCircles(
      data = wood_catchers,
      color = "red",
      fillColor = "red",
      fillOpacity = 0.8,
      radius = 69,
      weight = 2,
      popup = paste0(
        "<b>ID:</b> ", wood_catchers$id
      ),
      group = "Wood Catchers"
    ) %>%
    
    #Add other rasters

    addImageQuery(
      heatmap,
      layerId = "heatmap",
      prefix = "value:_",
      digits = 2,
      position = "topright",
      type = "mousemove", # Show values on mouse movement
      options = queryOptions(position = "topright"), # Remove the TRUE text
      group = "Heatmap") %>%
    
    addLayersControl(
      overlayGroups = c("Bridges", "Large Wood", "Heatmap", "Wood Catchers", "Aspect"),
      options = layersControlOptions(collapsed = FALSE)
    ) %>%
  addControl(
    html = paste(
      '<div style="background: white; padding: 10px; border: 2px solid #ccc; border-radius: 5px;">',
      '<div style="font-weight: bold; margin-bottom: 8px; font-size: 14px;">Map Features</div>',
      '<div style="margin-bottom: 6px;">',
      '<svg width="20" height="20" style="vertical-align: middle; margin-right: 5px;">',
      '<circle cx="10" cy="10" r="8" fill="black" stroke="black" stroke-width="2"/>',
      '</svg>',
      '<span style="vertical-align: middle;">Bridges</span>',
      '</div>',
      '<div style="margin-bottom: 6px;">',
      '<svg width="20" height="20" style="vertical-align: middle; margin-right: 5px;">',
      '<circle cx="10" cy="10" r="6" fill="none" stroke="black" stroke-width="2"/>',
      '</svg>',
      '<span style="vertical-align: middle;">Large Wood (by cluster)</span>',
      '</div>',
      '<div style="margin-bottom: 6px;">',
      '<svg width="20" height="24" style="vertical-align: middle; margin-right: 5px;">',
      '<path d="M10 2 C6 2 3 5 3 9 C3 13 10 22 10 22 C10 22 17 13 17 9 C17 5 14 2 10 2 Z" fill="#D63E2A" stroke="white" stroke-width="1"/>',
      '<path d="M10 5.5 L10.8 7.5 L13 7.5 L11.3 8.8 L12 10.8 L10 9.5 L8 10.8 L8.7 8.8 L7 7.5 L9.2 7.5 Z" fill="white" stroke="none"/>',
      '</svg>',
      '<span style="vertical-align: middle;">Wood Catchers</span>',
      '</div>',
      '</div>'
    ),
    position = "topleft"
  )
  }) 


# Add popups for large wood points
observe({
  leafletProxy("map") %>%
    clearMarkers() %>%
    addCircleMarkers(data = clusters2, fillColor = ~pal_clusters(CLUSTER_ID), color = "black", 
                     weight = 1, radius = 5, stroke = TRUE, fillOpacity = 0.7,
                     popup = ~paste("<b>Type:</b>", dplyr::recode(LW_Type,
                                                                  "s" = "Single",
                                                                  "j" = "Jam",
                                                                  "b" = "Blockage" ),
                                    "<br><b>Cluster ID:</b>", CLUSTER_ID),
                     group = "Large Wood") %>%
    
    clearGroup("Wood Catchers") %>%
    addAwesomeMarkers(
      data = wood_catchers,
      icon = awesomeIcons(
        icon = "star",
        library = "glyphicon",
        iconColor = "white",
        markerColor = "red"
      ),
      popup = ~paste("<b>ID:</b>", id),
      group = "Wood Catchers"
    )
})


