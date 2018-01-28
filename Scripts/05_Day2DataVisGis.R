# Day 2 course 28/01/2018
  # Putting shape files that we made onto maps using leaflet. 
  # Geocoding
  
library(leaflet)  
library(leaflet.extras)
library(sp)
library(raster)
library(rgdal)
library(mapview)

line <- shapefile("QGIS/Line/line_line.shp")
GBR <- shapefile("QGIS/GBR/GBR_poly.shp")

leaflet() %>%
  addTiles() %>%
  addPolylines(data = line) %>% 
  addPolygons(data = GBR)

# ---------
# Geocoding
# ---------

library(leaflet)
library(ggplot2)
library(ggmap)

# Get the coordinates for the following addresses: 

MLO <- geocode("1437 Kilauea Ave. 102 Hilo, Hawaii, 96720, United States", output = "latlon" , source = "google")
MLO

BO <- geocode("Barrow, AK 99723, USA", output = "latlon" , source = "google")
BO

HSU <- geocode("HSU Marine Lab 570 Ewing St Trinidad, California, 95570, United States", output = "latlon" , source = "google")
HSU

SMO <- geocode("Pago Pago, Eastern, 96799, American Samoa", output = "latlon" , source = "google")
SMO

# Make a dataframe of all the lat and longs
df <- as.data.frame(rbind(MLO, BO, HSU, SMO))
df

df$Locations <- c("MLO", "BO", "HSU", "SMO")   #column with Locations
df

leaflet(data = df) %>% 
  addTiles() %>%
  addMarkers(~lon, ~lat, popup = ~as.character(Locations))



