# Day 1 course 27/01/2018
  # Plotting Hurricane Dennis
    # rworldmap (package didn't install)
    # ggmap

# ------------------------------
# Mapping with QGIS and R studio
# ------------------------------

library(maps)

# Read in hurricane dennis file 

d <- read.csv("Data/dennis.csv")
head(d)

# Plot the map, using the long and lat you want

map("world", ylim = c(10,60), xlim = c(-120,-40))

# Plot dennis by assigning his lat and long
Lo <- d$Long
La <- d$Lat
n <- length(Lo)

lines(Lo,La, lwd = 2.5, col = "blue")

# Plot arrow head

arrows(Lo[n - 1], La [n - 1], Lo[n], La [n], lwd = 2.5, col = "blue")


# Now have a go plotting with R world Map and R world extra 

# library(rworldmap)

r <- read.csv("Data/rita.csv")

# newmap <- getMap(resolution="high")
# plot(newmap)

# -----
# ggmap
# -----

map <- map_data("world")

ggplot()+
  geom_polygon(data = map, aes(x = long, y = lat, group = group))

# Read in hurricane Wilma 

w <- read.csv("Data/Wilma.csv")

# Carry on with the world map code, and add different geom data layers ontop

ggplot()+
  geom_polygon(data = map, aes(x = long, y = lat, group = group)) +
  geom_point(data = w, aes (Long, Lat, colour = Wind), size = 3) +
  theme_bw() +
  ylab("Latitude") +
  xlab("Longitute")


# add in the sea surface temperature 

library(raster)
library(rasterVis)
library(rgdal)

sst <- raster("Data/sst.tif")

# Convert it to spatial pixel dataframe

sst.spdf <- as(sst,"SpatialPixelsDataFrame")

sst.df <- as.data.frame(sst.spdf)

# Map it, with chosen hex colours to fill a high and low gradient. Use colour brewer for the hex.

ggplot (sst.df, aes(x,y)) +
  geom_tile(aes(fill = sst)) +
  scale_fill_gradient(low = "#fee0d2", high = "#de2d26")+
  coord_equal()+
  ylab("Latitude")+
  xlab("Longitude")+
  theme_bw()+
  theme(legend.position = "none")

# This gives a legend 

ggplot (sst.df, aes(x,y)) +
  geom_tile(aes(fill = sst)) +
  scale_fill_gradient(low = "#fee0d2", high = "#de2d26")+
  coord_equal()+
  ylab("Latitude")+
  xlab("Longitude")+
  theme_bw()
  

# Now we can add the continents geom_polygon, and Hurricane Stan geom_point() to this map.

s <- read.csv(file = "Data/stan.csv")
ggplot() + 
  geom_tile(data = sst.df, aes(x = x, y = y, fill = sst)) +
  scale_fill_gradientn(colours = c("#fee0d2","#fc9272","#de2d26")) +
  geom_polygon(data = map, aes(x = long, y = lat, group = group)) + 
  geom_point(data = s, aes(Long, Lat, colour = Wind), size = 3) +
  ggtitle("Hurricane Stan and SST in 2005") +
  ylab("Latitude") +
  xlab("Longitude") +
  theme_bw() +
  theme(
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    panel.border = element_blank(),
    panel.background = element_blank(),
    axis.text.x = element_blank(),
    axis.ticks.x = element_blank(),
    axis.text.y = element_blank(),
    axis.ticks.y = element_blank(),
    axis.title.x = element_blank(),
    axis.title.y = element_blank(),
    plot.title = element_text(hjust = 0.5),
    legend.position = "none")

# Carry on 

