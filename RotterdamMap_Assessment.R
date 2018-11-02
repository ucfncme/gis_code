# Install libraries
library(maptools)
library(RColorBrewer)
library(OpenStreetMap)
library(sp)
library(tmap)
library(tmaptools)
library(sf)
library(geojsonio)
library(methods)
# Read shapefile Rotterdam + river
RotterdamMapSF <- read_shape("C:/Users/carlo/OneDrive/Documentos/MSc Smart Cities/GIS/Assessment 1/R Map/Neighbourhoods_RDAM.shp", as.sf = TRUE)
WaterSF <- read_shape("C:/Users/carlo/OneDrive/Documentos/MSc Smart Cities/GIS/Assessment 1/R Map_2/Major_Water_Bodies_RDAM.shp", as.sf = TRUE)
qtm(RotterdamMapSF)
# Check class
class(RotterdamMapSF)
# Calculate areas of polygons
library(raster)
RotterdamData <- shapefile("C:/Users/carlo/OneDrive/Documentos/MSc Smart Cities/GIS/Assessment 1/R Map/Neighbourhoods_RDAM.shp")
crs(RotterdamData)
RotterdamData$area_sqkm <- area(RotterdamData) / 1000000
WaterData <- shapefile("C:/Users/carlo/OneDrive/Documentos/MSc Smart Cities/GIS/Assessment 1/R Map_2/Major_Water_Bodies_RDAM.shp")
# Calculate population density of each neighbourhood
## Transform fields to "numeric"
RotterdamData$AANT_INW <- as.numeric(RotterdamData$AANT_INW)
class(RotterdamData$AANT_INW)
RotterdamData$area_sqkm <- as.numeric(RotterdamData$area_sqkm)
class(RotterdamData$area_sqkm)
## Calculate Density
RotterdamData$Density <- RotterdamData$AANT_INW / RotterdamData$area_sqkm
# Plotting the data
tmap_mode("plot")
RotterdamMapOSM <- read_osm(RotterdamMapSF, type = "esri", zoom = NULL)
qtm(RotterdamData) + 
  tm_shape(RotterdamData) + 
  tm_polygons("Density", 
              style="quantile",
              palette="YlOrRd",
              midpoint=NA,
              title="Population Density (hab/km2)",
              alpha = 1) + 
  tm_compass(position = c("right", "bottom"),type = "arrow") + 
  tm_scale_bar(position = c("right", "bottom")) +
  tm_layout(title = "Population Density of Rotterdam (2011)", 
            title.position = c("center","top"),
            frame.lwd = 1,
            asp = 1.7) +
  qtm (WaterData) +
  tm_shape (WaterData) +
  tm_polygons ("type",
               title= "Natural areas")

