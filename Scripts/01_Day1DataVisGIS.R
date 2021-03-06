# Day 1 course 27/01/2018

# Making plots with base R 
# Makng plots with ggplot
# XKCD styled plots
# Interactive plots 
    # ggiraph
    # plotly
    # googleVis
# Animated plots 
    # animation 
    # gganimate 

library(ggplot2)
library(ggmap)
library(tidyverse)
library(DT)

# Prelim work 

name <- c("Andrew", "Floyd", "Katrina")
date <- as.date(c("1992-08-24", "1999-11-16", "2005-08-29"))
category <- c(5,2,3)
hurricane.data <- data.frame(name, date, category)
hurricane.data


# -----------------
# Plotting SST data
# -----------------

# Page 12 Making plots with R studio 
# Getting from internet is good, this is the most up to date data

temp1 <-
  read.table(
    url(
      "https://www.metoffice.gov.uk/hadobs/hadsst3/data/HadSST.3.1.1.0/diagnostics/HadSST.3.1.1.0_annual_globe_ts.txt"
    )
  )

# Naming the columns

names(temp1) <- c("Year", "Median")
head(temp1)

datatable(temp1)

# Remove unwanted columns 

temp1[3:12] <- NULL

# First lets make a basic plot 

plot(temp1)

# Lets improve this plot (try this with GGPlot)

plot(temp1, 
     ylab = "Median global average sea-surface temperature anomaly relative to 1961-1990", 
     xlab = "Year")
title("Global Sea Surface Temperature Time Series")

# Lets change this to a line graph

plot(temp1,
     ylab = "Median global average sea-surface temperature anomaly relative to 1961-1990",
     xlab = "Year",
     type = "l")
title("Global Sea Surface Temperature Time Series")

plot(temp1,
     ylab = "Median global average sea-surface temperature anomaly relative to 1961-1990",
     xlab = "Year",
     type = "l",
     col = "blue")
xaxt = "n"
xlim = c(1850,2016)
ylim = c(-0.6,0.6)
axis(side=1, at = c(1850,1875,1900,1925,1950,1975,2000,2016)) 
# Side 1 = x axis, Side 2 = y axis. How to change the tick marks.
title("Global Sea Surface Temperature Time Series")


# --------------------
# Now lets use ggplot
# --------------------

qplot(data = temp1, Year,Median)

ggplot(data = temp1, aes (Year, Median)) +
  geom_point() +
  theme_bw()

ggplot(data = temp1, aes (Year,Median)) +
  geom_point() +
  geom_line() +
  theme_bw()

# Change the colour of the line 

ggplot(data = temp1, aes (Year,Median)) +
  geom_point(colour = "blue") +
  geom_line(colour = "red") +
  theme_bw()

# Can also add a horizontal line at 0, because the data set is relative

ggplot(data = temp1, aes (Year,Median)) +
  geom_point(colour = "blue") +
  geom_line(colour = "red") +
  geom_hline(yintercept = 0, linetype = "dashed")
  theme_bw()
  
# Make a barchat with geom_bar()
  
ggplot(data = temp1, aes (Year, Median)) + 
  geom_bar(stat = "identity", colour = "blue") +
  theme_bw()
  
ggplot(data = temp1, aes (Year, Median)) + 
  geom_bar(stat = "identity", colour = "blue") +
  theme_bw()

# If you want to explore more geom options using ggplot this will give you the options. 

grep("^geom", objects("package:ggplot2"), value = TRUE)

# Lets carry on with ggplot 

ggplot(data = temp1, aes (Year, Median)) +
  geom_point(colour = "blue", size = 2) +
  geom_line(colour = "red", size = 1) +
  geom_hline(yintercept = 0, linetype = "dashed") +
  scale_x_continuous(
    breaks = c(
      1850,
      1860,
      1870,
      1880,
      1890,
      1900,
      1910,
      1920,
      1930,
      1940,
      1950,
      1960,
      1970,
      1980,
      1990,
      2000,
      2010,
      2020
    )
  ) +
  scale_y_continuous(breaks = c(-0.6,-0.3, 0, 0.3, 0.6)) +
  labs(title = "Global Sea Surface Temperature Time Series") +
  labs(y = "Median global average sea-surface temperature anomaly (relative to 1961-1990)") +
  theme_bw()


# Again setting the theme yourself

ggplot(data = temp1, aes(Year, Median)) + 
  geom_point(colour = "blue", size = 2) +
  geom_line(colour = "blue", size = 1) +
  geom_hline(yintercept = 0, linetype = "dashed") +
  scale_x_continuous(breaks=c(1850, 1860, 1870, 1880, 1890, 1900, 1910, 1920, 1930, 1940, 
                              1950, 1960, 1970, 1980, 1990, 2000, 2010, 2020)) +
  scale_y_continuous(breaks=c(-0.6, -0.3, 0, 0.3, 0.6)) +
  labs(title = "Global Sea Surface Temperature Time Series") +
  labs(y = "Median global average sea-surface temperature anomaly (relative to 1961-1990)") +
  theme(panel.background = element_rect(fill = "ivory2")) +  
  theme(plot.background = element_rect(fill = "ivory2"))

# Look at a library of colours 

library(RColorBrewer)
display.brewer.all()

# -----------------
# XKCD styled plots
# -----------------
library(xkcd)



library(extrafont)
library(ggplot2)
library(xkcd)
loadfonts()

#create the XKCD theme
theme_xkcd <- theme(
  plot.background = element_rect(fill = "white"),
  panel.background = element_rect(fill = "white"),
  panel.grid = element_line(colour = "white"),
  axis.text.y = element_text(colour = "black"), 
  axis.text.x = element_text(colour = "black"),
  text = element_text(size = 15, family = "xkcd"))

xrange <- range(temp1$Year) 
yrange <- range(temp1$Median)


ggplot(temp1) + 
  geom_smooth(mapping = aes(x = Year, y = Median), method = "loess") +
  geom_hline(yintercept = 0, linetype = "dashed") +
  scale_x_continuous(breaks=c(1850, 1860, 1870, 1880, 1890, 
                              1900, 1910, 1920, 1930, 1940, 
                              1950, 1960, 1970, 1980, 1990, 
                              2000, 2010, 2016)) +
  scale_y_continuous(breaks=c(-0.6, -0.3, 0, 0.3, 0.6)) +
  labs(title = "Global Sea Surface Temperature Time Series") +
  labs(y = "Median global average sea-surface temperature anomaly (relative to 1961-1990)") +
  theme_xkcd +
  xkcdaxis(xrange, yrange) 

# ----------------
# Interactive maps
# ----------------

land <- read.csv("Data/GLB.Ts.csv")
head(land)

# Remove some columns so that we have the year and the median 
land[2:19] <- NULL

# Look at the structure 
str(land)

library(dplyr)
library(tidyverse)
library(devtools)

# Install the package ggiraph from github
# devtools::install_github("davidgohel/ggiraph")

library(ggiraph)
gg <- ggplot(data = land, 
             aes(Year, Median, colour = Median, tooltip = Median, data_id = Median)) +
  geom_hline(yintercept = 0, linetype = "dashed") +
  labs(y = "Median land temperature anomaly (relative to 1961-1990)") +
  scale_x_continuous(breaks = c(1880, 1890, 1900, 1910, 1920, 
                                1930, 1940, 1950, 1960, 1970, 
                                1980, 1990, 2000, 2010)) +
  scale_y_continuous(breaks = c(-0.8, -0.6, -0.4, -0.2, 0, 0.2, 0.4, 0.6, 0.8, 1, 1.2)) +
  theme(legend.position="none") +
  geom_line_interactive(size = .75)

ggiraph(code = {print(gg)}, hover_css = "stroke:red;")


# Interactive graphs using ggplotly

library(tidyverse)
library(plotly)

# Merge the two datasets 

t <- merge (temp1, land, by = "Year")

names(t) <- c("Year", "Sea", "Land")

library(DT)
datatable(t)

# Now we can look to build a ggplot 

pp <- ggplot (data = t, aes(x=Year)) +
  geom_line(aes(y = Sea, colour = "Sea"), size = 1) +
  geom_line(aes(y = Land, colour = "Land"), size = 1) +
  scale_colour_manual("",
                      breaks = c("Land", "Sea"),
                      values = c("darkgreen", "blue")) +
  geom_hline(yintercept = 0, linetype = "dashed", color = "black") +
  labs(y = "Median sea & land temperature anomaly (relative to 1961-1990)") +
  scale_x_continuous(breaks = c(1880, 1890, 1900, 1910, 1920, 
                                1930, 1940, 1950, 1960, 1970, 
                                1980, 1990, 2000, 2010, 2016)) +
  scale_y_continuous(breaks = c(-0.8, -0.6, -0.4, -0.2, 0, 0.2, 0.4, 0.6, 0.8, 1, 1.2)) +
  theme(panel.background = element_rect(fill = "ivory2")) +
  theme(plot.background = element_rect(fill = "ivory2")) 
pp

# This makes it interactive, YAY
ggplotly(pp)

# Now try this using google vis 

library(googleVis)

line <- gvisLineChart(t, options = list(title = "Global Temperature Time Series"))
plot(line)


print(line, file = "Graphs/GoogleVis_land_sea.htm")

library(googleVis)

line <- gvisLineChart(t, options = list(title = "Global Temperature Time Series"))
plot(line)

library(ggvis)
library(dplyr)
land %>%
  ggvis(~Year, ~Median,
        fill := input_text(label = "Choose color:",
                           value = "black")) %>%
  layer_points() %>%
  add_axis("x", 
           title = "Year", 
           values = c(1880, 1890, 1900, 1910, 1920, 
                      1930, 1940, 1950, 1960, 1970, 
                      1980, 1990, 2000, 2010, 2016), 
           orient = "bottom") %>%
  add_axis("y", 
           title = "Median global land temperature anomaly (relative to 1961-1990)", 
           values = c(-0.8, -0.6, -0.4, -0.2, 0, 0.2, 0.4, 0.6, 0.8, 1, 1.2), 
           orient = "left")

plot <- ggvis(t) %>%
  layer_points(x = ~Year, y= ~Sea, fill := "blue", 
               size := input_slider(0, 500, label = "Data point size (Sea)"), 
               opacity := 0.5) %>%
  layer_points(x = ~Year, y= ~Land, fill := "green",
               size := input_slider(0, 500, label = "Data point size (Land)"), 
               opacity := 0.5) %>%
  add_axis("x", 
           title = "Year", 
           values = c(1880, 1890, 1900, 1910, 1920, 
                      1930, 1940, 1950, 1960, 1970, 
                      1980, 1990, 2000, 2010, 2016), 
           orient = "bottom") %>%
  add_axis("y", 
           title = "Median sea & land temperature anomaly (relative to 1961-1990)", 
           values = c(-0.8, -0.6, -0.4, -0.2, 0, 0.2, 0.4, 0.6, 0.8, 1, 1.2), 
           orient = "left")
plot

# -------------
# Animated plot
# -------------

library(devtools)
library(animation)
devtools::install_github("dgrtwo/gganimate")
library(gganimate)

keeling <- read.csv("Data/keeling.csv")
keeling

ggplot(data = keeling, aes(Year, CO2)) + 
  geom_point(colour = "blue", size = 1) +
  labs(title = "Keeling curve") +
  geom_hline(yintercept = 400, linetype = "dashed") +
  labs(y = "Cabon-dioxide concentration (ppm)") +
  scale_x_continuous(breaks=c(1960, 1965, 1970, 1975, 1980,
                              1985, 1990, 1995, 2000, 2005,
                              2010, 2015)) +
  scale_y_continuous(breaks=c(320, 330, 340, 350, 
                              360, 370, 380, 390, 
                              400)) +
  theme(panel.background = element_rect(fill = "white"),
        plot.background = element_rect(fill = "white"),
        axis.text = element_text(colour = "black"),
        axis.title.x = element_blank())

library(plyr)

# Calculate the yearly mean 

keeling2 <- ddply(keeling, .(Year), summarize, Mn = mean(Mn), CO2 = mean(CO2))
keeling2$Source <- rep("ML", nrow(keeling2))
keeling2

# Plot this. Attention to geom_path - cumulative and group, which is the new column.
library(ggplot2)
carbon <- ggplot(data = keeling2, aes(Year, CO2, frame = Year)) + 
  geom_point(colour = "blue", size = 2) +
  geom_line(colour = "blue", size = 1) +
  labs(title = "Keeling curve") +
  geom_hline(yintercept = 400, linetype = "dashed") +
  labs(y = "Carbon-dioxide concentration (ppm)") +
  geom_path(aes(cumulative = TRUE, group = Source)) +
  scale_x_continuous(breaks=c(1960, 1965, 1970, 1975, 1980,
                              1985, 1990, 1995, 2000, 2005,
                              2010, 2016)) +
  scale_y_continuous(breaks=c(320, 330, 340, 350, 
                              360, 370, 380, 390, 
                              400)) +
  theme(panel.background = element_rect(fill = "white"),
        plot.background = element_rect(fill = "white"),
        axis.text = element_text(colour = "black"),
        axis.title.x = element_blank())

carbon

# define the speed that the line will form in the animation 

ani.options(interval = .2)

# now animate your GIF 

gganimate(carbon, "keeling.gif", ani.width = 600, ani.height = 400)

require(installr)

install.packages("magick")
library(magick)

library(knitr)
