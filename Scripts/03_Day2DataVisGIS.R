# Day 2 course 28/01/2018


# ------------------------------
# Interactive map with R studio
# ------------------------------

# Clear r workspace
rm(list = ls())

library(leaflet)
library(leaflet.extras)
library(RColorBrewer)
library(sp)
library(rgdal)
library(mapview)

# Tell R you want to use the function leaflet
m <- leaflet()

# In addition, we want to addTiles to m
m <- addTiles(m)

m <- addProviderTiles(m, "CartoDB.DarkMatter", group = "CartoDB.DarkMatter")
m

# Use https://leaflet-extras.github.io/leaflet-providers/preview/ to choose map. Copy and paste map name. 

# c <- addProviderTiles(m, "Thunderforest.SpinalMap", group = "Thunderforest.SpinalMap")
c

# Set the long and lat you want the map to be viewed from 
m <- setView(m, lng = -60, lat = 17, zoom = 3)
m

# Load into r the hurricane data 
dennis <- read.csv("Data/dennis.csv")
# Define what colour you want dennis to be. The domain = the wind speed to be coloured.
pal1 <- colorFactor(palette = "Blues", domain = dennis$Wind)

kat <- read.csv("Data/katrina.csv")
pal2 <- colorFactor(palette = "Reds", domain = kat$Wind)

rita <- read.csv("Data/rita.csv")
pal3 <- colorFactor(palette = "Greens", domain = rita$Wind)

stan <- read.csv("Data/stan.csv")
pal4 <- colorFactor(palette = "Purples", domain = stan$Wind)

wilma <- read.csv("Data/wilma.csv")
pal5 <- colorFactor(palette = "Greys", domain = wilma$Wind)

# Add circles onto the map

m <-
  addCircles(
    m,
    data = rita,
    lng = ~Long,
    lat = ~Lat,
    weight =10,
    color = ~pal3(Wind),
    popup = ~as.character(Type),
    group = "Hurricane Rita",
    label =  ~as.character(Wind)
  )
m <-
  addCircles(
    m,
    data = stan,
    lng = ~ Long,
    lat = ~ Lat,
    weight = 10,
    color = ~ pal4(Wind),
    popup = ~ as.character(Type),
    group = "Hurricane Stan",
    label =  ~ as.character(Wind)
  )
m <-
  addCircles(
    m,
    data = wilma,
    lng = ~ Long,
    lat = ~ Lat,
    weight = 10,
    color = ~ pal5(Wind),
    popup = ~ as.character(Type),
    group = "Hurricane Wilma",
    label =  ~ as.character(Wind)
  )
m <-
  addCircles(
    m,
    data = dennis,
    lng = ~ Long,
    lat = ~ Lat,
    weight = 10,
    color = ~ pal1(Wind),
    popup = ~ as.character(Type),
    group = "Hurricane Dennis",
    label =  ~ as.character(Wind)
  )
m <-
  addCircles(
    m,
    data = kat,
    lng = ~ Long,
    lat = ~ Lat,
    weight = 10,
    color = ~ pal2(Wind),
    popup = ~ as.character(Type),
    group = "Hurricane Katrina",
    label = ~ as.character(Wind)
  )
m

# We can now add an icon/gif/image to a specific point in the map. 
k <- iconList(k = makeIcon("Data/katrina_sstHD.gif"))
m <- addMarkers(m, lng = -88.6, lat = 26.3, icon = k, group = 'GIF')
m

# Let's also add the SST data, the coral reef, marine ecoregions and geographic lines shapefiles. 
library(ncdf4)
library(raster)
sst <- raster("Data/g4.timeAvgMap.MODISA_L3m_SST_2014_sst.20050101-20051231.180W_90S_180E_90N.nc")
pal6 <- colorNumeric(c("Reds"), values (sst), na.color = "transparent")

# if you have memory issues, run the following code 
# memory.limit(size = 10000)

# Add the raster to map m
m <- addRasterImage(m, sst, colors = pal6, opacity = 0.8, group = "Sea Surface Temperature")
m

# Add coral data 
coral <- shapefile("Data/ne_10m_reefs.shp")
m <- addPolygons(m, data = coral, fill = F, weight = 5, color = "#F6FA6E", group = "Coral Reefs")

# Add geographic lines
gl <- shapefile("Data/ne_10m_geographic_lines.shp")
m <- addPolygons(m, data = gl, fill = F, weight = 2, color = "Grey", label=~as.character(name))

# Add mairne ecoregions
marineecoz <- shapefile("Data/meow_ecos.shp")
m <- addPolygons(m, data = marineecoz, fill = F, weight = 3, color = "#6EFA73", label=~as.character(ECOREGION), group = "Marine Ecoregions")

m


# Add states damaged by hurricane Katrina

state <- readOGR("Data/states.shp")
pal7 <- colorFactor("Dark2", domain = state$losses_Ins)
m <- addPolygons(m, data = state, stroke = FALSE, smoothFactor = 0.2, fillOpacity = 1,
                 color = ~pal7(losses_Ins),
                 label= ~as.character(NAME), 
                 popup = ~as.character(losses_Ins),
                 group = "Hurricane Katrina damage")
m

# Download data on population density

m <- addWMSTiles(m, "http://sedac.ciesin.columbia.edu/geoserver/wms",
                 layers = "gpw-v4:gpw-v4-population-density_2005",
                 options = WMSTileOptions(format = "image/png", transparent = TRUE),
                 group = "Population density (2005)")
m

# Control which layers are on and off. Collapsed = TRUE means you don't have a legend. 

m <- addLayersControl(m,
                      baseGroups = c("Esri.WorldImagery", "Esri.WorldPhysical", "CartoDB.DarkMatter"), 
                      overlayGroups = c("Hurricane Rita", "Hurricane Stan", "Hurricane Wilma", "Hurricane Dennis", "Hurricane Katrina", "Coral Reefs", "Marine Ecoregions", "Sea Surface Temperature", "Population density (2005)", "GIF"),
                      options = layersControlOptions(collapsed = FALSE), 
                      position = 'topright')
m

# Add a legend to your data

m <- addLegend(m, pal = pal6, values = values(sst),
               title = "Mean SST (2005)", 
               position = c("bottomright"))


m <- addScaleBar(m, position = c("bottomleft"))
m


