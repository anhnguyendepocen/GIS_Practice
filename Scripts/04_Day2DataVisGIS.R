# Day 2 course 28/01/2018
  # Firefly map
  # mapview and tmap in R studio
    # Before/after hurricane Irma slide view



library(leaflet)

RI <- read.csv("Data/2017.csv")

#subset the data foreach storm 
tropical1 <- subset(RI, STAT == "TROPICAL STORM",)
tropical2 <- subset(RI, STAT == "TROPICAL DEPRESSION",)
tropical3 <- subset(RI, STAT == "POST-TROPICAL STORM",)
one <- subset(RI, STAT == "HURRICANE-1",)
two <- subset(RI, STAT == "HURRICANE-2",)
three <- subset(RI, STAT == "HURRICANE-3",)
four <- subset(RI, STAT == "HURRICANE-4",)
five <- subset(RI, STAT == "HURRICANE-5",)

# make the icons
a <- makeIcon("Data/FireflyIconsWarm/1.png")
b <- makeIcon("Data/FireflyIconsWarm/2.png")
c <- makeIcon("Data/FireflyIconsWarm/3.png")
d <- makeIcon("Data/FireflyIconsWarm/4.png")
e <- makeIcon("Data/FireflyIconsWarm/5.png")
f <- makeIcon("Data/FireflyIconsWarm/0.png")

#map
leaflet() %>%
  addTiles() %>%
  addProviderTiles("CartoDB.DarkMatterNoLabels") %>%
  addMarkers(data = tropical1, ~LON, ~LAT, icon = f) %>%
  addMarkers(data = tropical2, ~LON, ~LAT, icon = f) %>%
  addMarkers(data = tropical3, ~LON, ~LAT, icon = f) %>%
  addMarkers(data = one, ~LON, ~LAT, icon = a) %>%
  addMarkers(data = two, ~LON, ~LAT, icon = b) %>%
  addMarkers(data = three, ~LON, ~LAT, icon = c) %>%
  addMarkers(data = four, ~LON, ~LAT, icon = d) %>%
  addMarkers(data = five, ~LON, ~LAT, icon = e)

# ----------------------------
# mapview and tmap in R studio
# ---------------------------- 

rm(list = ls())

#mapview
library(leaflet)
library(leaflet.extras)
library(RColorBrewer)
library(mapview)
library(sp)
library(rgdal)

# Data
Hurricanes <- shapefile("Data/2017_RI.shp", stringsAsFactors = FALSE)

# Mapview. This created a really nice basemap, where you can choose from five different base maps.
mapview(Hurricanes)

# Using the sync function we can generate a map side by side by showing different attributes on each.
# Wind and pressure
m1 <- mapview(Hurricanes, zcol = "Wind", cex = "Wind")
m1
m2 <- mapview(Hurricanes, zcol = "Pressure", cex = "Pressure")
m2

# Sync - show the two maps side by side
sync(m1, m2)

# Latticeview - this also works with this function
latticeView(m1, m2)

# Now maybe we want to add an image to a specific point 

# Download the image, and specify a point
library(sf)
pnt = st_as_sf(data.frame(x = -72.4, y = 21.3),
               coords = c("x", "y"),
               crs = 4326)
img = "https://wi-images.condecdn.net/image/MG20lDoe7r4/crop/810"

# Basic map with this point
point <- mapview(pnt, popup = popupImage(img, src = "remote"))
# Basic map with hurricane
map <- mapview(Hurricanes)
sync(map, point)

# Slideview - this is the outcome 
library(jpeg)
library(raster)

# Load image from a website before the hurricane 

web_imgbefore <- "https://wi-images.condecdn.net/image/j0rZlJPQeyX/crop/810"
# Raw image coming from the previous object, 
before<- readJPEG(readBin(web_imgbefore, "raw", 1e6))

# Convert imagedata to raster
rst_bluebefore <- raster(before[, , 1])
rst_greenbefore <- raster(before[, , 2])
rst_redbefore <- raster(before[, , 3])

# Bring these togethr with the brick function 
before <- brick(rst_redbefore, rst_greenbefore, rst_bluebefore)

# Now do the same for after
web_imgafter <- "https://wi-images.condecdn.net/image/MG20lDoe7r4/crop/810"
after <- readJPEG(readBin(web_imgafter, "raw", 1e6))

# Convert imagedata to raster
rst_blueafter <- raster(after[, , 1])
rst_greenafter <- raster(after[, , 2])
rst_redafter <- raster(after[, , 3])

after <- brick(rst_redafter, rst_greenafter, rst_blueafter)

# Now do a before and after 

slideView(before, after, label1 = "before", label2 = "after")

image <- slideView(before, after, label1 = "before", label2 = "after")

# Create another point using a popup image
point2 <- mapview(pnt, popup = popupGraph(image, type = "html"))
map2 <- mapview(Hurricanes)
sync(map2, point2)


# tmap is a basic static map 

library(tmap)

# Need to convert a shape file to a numeric file. 

Hurricanes$Wind <- as.numeric(Hurricanes$Wind)

h <- tm_shape(Hurricanes) +
  tm_bubbles("Wind", col = "Wind")
h

# Overlay it on an interactive map
tmap_leaflet(h)
