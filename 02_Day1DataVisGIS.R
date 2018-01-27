# Day 1 course 27/01/2018
  # Plotting Hurricane Dennis


# Mapping with QGIS and R studio

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

arrows(Lo[n - 1], La [n - 1], Lo[n], La [n], lwd = 2.5, col = "blue")
