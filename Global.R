# G1 Load large wood, river, and bridge data ----
lw_points <- st_read("cleaned_lw_shapefile.shp")
river <- st_read("RiverTorridge.shp")
bridges <- st_read("relevant bridges.shp")
bridges <- bridges[!st_is_empty(bridges$geometry), ]
bridges_snapped2 <- read.csv("Bridges_snapped2")
bridges <- left_join(bridges, bridges_snapped2, by = "BRIDGE.NAM")

#Convert vectors to CRS 4326
lw_points <- st_transform(lw_points, crs = 4326)
river <- st_transform(river, crs = 4326)
bridges <- st_transform(bridges, crs = 4326)

# Add Wood catchers
wood_catchers <- st_read("wood_catcher_R2.shp")
wood_catchers <- st_transform(wood_catchers, crs = 4326)
relabel_map <- c(
  "1" = 2,
  "2" = 1,
  "3" = 3,
  "4" = 6,
  "5" = 4,
  "6" = 5
)

wood_catchers$id <- relabel_map[as.character(wood_catchers$id)]

# Perform clustering
clusters2 <- st_read("Clusters for Practical 6.shp")
clusters2 <- st_transform(clusters2, crs = 4326)
# Dynamically generate colours based on number of unique clusters
num_clusters <- length(unique(clusters2$CLUSTER_ID))
pal_clusters <- colorFactor(palette = colorRampPalette(brewer.pal(12, "Paired"))(num_clusters), 
                            domain = clusters2$CLUSTER_ID)

heatmap <- rast("Heatmap.tif")
heatmap <- project(heatmap, crs(river))

pal_heatmap <- colorNumeric(palette = "plasma", domain = na.omit(values(heatmap)), na.color = "transparent")


#slope1 <- rast("/Users/milliereynolds/slope.tif")
#slope1 <- project(slope1, crs(river))
#slope1 <- aggregate(slope1, fact = 3)

#pal_slope1 <- colorNumeric(palette = "rocket", domain = na.omit(values(slope1)), na.color = "transparent")

aspect1 <- rast("aspect.tif")
aspect1 <- project(aspect1, crs(river))
aspect1 <- aggregate(aspect1, fact = 3)
pal_aspect1 <- colorNumeric(palette = "viridis", domain = na.omit(values(aspect1)), na.color = "transparent")

heatmap <- raster(heatmap)
#slope1 <- raster(slope1)
aspect1 <- raster(aspect1)



