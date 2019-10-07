
# Note that only part of the data have been used for convenience as of now. crime data may be cut down to recent 3 years of data if the plotting takes too much time.


# install.packages('leaflet')
# install.packages('dplyr')
# install.packages('sp')
# install.packages('RDSTK')
# install.packages('sf')
# install.packages('mapview')
# install.packages('leaflet.extras')

# include libraries
library(dplyr)
library(leaflet)
library(sp)
library(sf)
library(RDSTK)
library(leaflet.extras)

# import cleaned crime data
nyc_crime <- read.csv(file = "nyc_crime.csv", header = TRUE, sep = ",")
tail(nyc_crime)

# import crime data by category
felony <- read.csv(file = "felony.csv", header = TRUE, sep = ",")
misdemeanor <- read.csv(file = "misdemeanor.csv", header = TRUE, sep = ",")
violation <- read.csv(file = "violation.csv", header = TRUE, sep = ",")

# import shooting data
nyc_shooting <- read.csv(file="nyc_shooting.csv", header=TRUE, sep=",")
nyc_shooting

# get user input for the desired address
addr <- readline(prompt = "Enter address (e.g. 2990 Broadway, New York, NY): ")

# generate home icon for to mark the user input
home_icon<- awesomeIcons(
  icon = 'home',
  library = 'ion',
  markerColor = 'green'
)

# get longitude and latitude for the user input
addr_lon <- street2coordinates(addr)$longitude
addr_lat <- street2coordinates(addr)$latitude

street2coordinates(addr)

# create nyc_crime_map
nyc_crime_map <- leaflet() %>%
  addTiles() %>%
  #addPolygons(data=shapeData,weight=1,col = 'red', fill = NA) %>% 
  setView(-73.9, 40.73, zoom = 10) %>%
  addProviderTiles("CartoDB.Positron") 

# mark user input on the map
nyc_crime_map <- nyc_crime_map %>%
  addAwesomeMarkers(lng = addr_lon, lat = addr_lat, icon = home_icon, group = 'home')

# Add heat map of crimes to the map
nyc_crime_map <- nyc_crime_map %>%
  addCircleMarkers(data = nyc_shooting,  radius = 0.5, color = 'black', group = 'Shootings') %>%
  addHeatmap(data = felony,  blur = 20, max = 0.05, radius = 10, group = 'Felonies') %>%
  addHeatmap(data = misdemeanor,  blur = 20, max = 0.05, radius = 10, group = 'Misdemeanors') %>%
  addHeatmap(data = violation,  blur = 20, max = 0.05, radius = 10, group = 'Violations')

# import shapefile for city council districts
zipcode <- st_read('ZIP_CODE/ZIP_CODE_040114.shp')
shapeData1 <- st_transform(zipcode, CRS('+proj=longlat +datum=WGS84'))

# Mark area by zipcode and add layers control
nyc_crime_map <- nyc_crime_map %>%
  addPolygons(data=shapeData1$geometry,weight=1,col = 'grey', fillOpacity = 0,
              highlightOptions = highlightOptions(
                weight = 2,
                color = 'black', fillOpacity = 0,
                bringToFront = TRUE, sendToBack = TRUE),
              popup = shapeData1$ZIPCODE,
              group = "Area by zipcode"
  )

  addLayersControl(overlayGroups = c("Violations", "Misdemeanors", "Felonies", "Shootings", "Area by zipcode"))

nyc_crime_map

# # count number of crimes by zipcode
# shapeData2 <- zipcode %>%
#   st_transform(2263)   # convert to same projection as below
# 
# felony_sf <- felony %>%
#   mutate_at(c("X_COORD_CD", "Y_COORD_CD"), as.numeric) %>%   # coordinates must be numeric
#   st_as_sf(
#     coords = c("X_COORD_CD", "Y_COORD_CD"),
#     agr = "constant",
#     crs = 2263,        # nad83 / new york long island projection
#     stringsAsFactors = FALSE,
#     remove = TRUE
#   )
# 
# felony_in_zip <- st_join(felony_sf,shapeData2)
# felony_zip_count <- count(as_tibble(felony_in_zip), "ZIPCODE")
# 
# felony_in_zip
# 
# misdemeanor_sf <- misdemeanor %>%
#   mutate_at(c("X_COORD_CD", "Y_COORD_CD"), as.numeric) %>%   # coordinates must be numeric
#   st_as_sf(
#     coords = c("X_COORD_CD", "Y_COORD_CD"),
#     agr = "constant",
#     crs = 2263,        # nad83 / new york long island projection
#     stringsAsFactors = FALSE,
#     remove = TRUE
#   )
# 
# misdemeanor_in_zip <- st_join(misdemeanor_sf,shapeData2)
# misdemeanor_zip_count <- count(as_tibble(misdemeanor_in_zip), "ZIPCODE")
# 
# violation_sf <- violation %>%
#   mutate_at(c("X_COORD_CD", "Y_COORD_CD"), as.numeric) %>%   # coordinates must be numeric
#   st_as_sf(
#     coords = c("X_COORD_CD", "Y_COORD_CD"),
#     agr = "constant",
#     crs = 2263,        # nad83 / new york long island projection
#     stringsAsFactors = FALSE,
#     remove = TRUE
#   )
# 
# violation_in_zip <- st_join(violation_sf,shapeData2)
# violation_zip_count <- count(as_tibble(violation_in_zip), "ZIPCODE")
# 
# shooting_sf <- nyc_shooting %>%
#   mutate_at(c("X_COORD_CD", "Y_COORD_CD"), as.numeric) %>%   # coordinates must be numeric
#   st_as_sf(
#     coords = c("X_COORD_CD", "Y_COORD_CD"),
#     agr = "constant",
#     crs = 2263,        # nad83 / new york long island projection
#     stringsAsFactors = FALSE,
#     remove = TRUE
#   )
# 
# shooting_in_zip <- st_join(shooting_sf,shapeData2)
# shooting_zip_count <- count(as_tibble(shooting_in_zip), "ZIPCODE")
# 
# felony_zip_count <- felony_zip_count[complete.cases(felony_zip_count),]
# misdemeanor_zip_count <- misdemeanor_zip_count[complete.cases(misdemeanor_zip_count),]
# violation_zip_count <- violation_zip_count[complete.cases(violation_zip_count),]
# shooting_zip_count <- shooting_zip_count[complete.cases(shooting_zip_count),]
# 
# write.csv(felony_zip_count, "felony_zip_count.csv", row.names = F)
# write.csv(misdemeanor_zip_count, "misdemeanor_zip_count.csv", row.names = F)
# write.csv(violation_zip_count, "violation_zip_count.csv", row.names = F)
# write.csv(shooting_zip_count, "shooting_zip_count.csv", row.names = F)

felony_zip_count = read.csv(file = "felony_zip_count.csv", header = TRUE, sep = ",")
misdemeanor_zip_count = read.csv(file = "misdemeanor_zip_count.csv", header = TRUE, sep = ",")
violation_zip_count = read.csv(file = "violation_zip_count.csv", header = TRUE, sep = ",")
shooting_zip_count = read.csv(file = "shooting_zip_count.csv", header = TRUE, sep = ",")


# longitude and latitude to zip
nyc_summary_map <- leaflet() %>%
  addTiles() %>%
  #addPolygons(data=shapeData,weight=1,col = 'red', fill = NA) %>% 
  setView(-73.9, 40.73, zoom = 10) %>%
  addProviderTiles("CartoDB.Positron")

nyc_summary_map <- nyc_summary_map %>%
  addAwesomeMarkers(lng = addr_lon, lat = addr_lat, icon = home_icon, group = 'home') %>%
  addPolygons(data=shapeData1$geometry,weight=1,col = 'grey', fillOpacity = 0,
              highlightOptions = highlightOptions(
                weight = 2,
                color = 'black', fillOpacity = 0,
                bringToFront = TRUE, sendToBack = TRUE),
              popup = shapeData1$ZIPCODE
              )

nyc_summary_map

# get zipcode from address given by the user
addr_st <- st_point(c(addr_lon, addr_lat))
idx <- as.integer(st_intersects(addr_st, shapeData1$geometry))
addr_zip = shapeData1$ZIPCODE[idx]

# sort felony_zip_count in descending order
felony_zip_count <- felony_zip_count[order(-felony_zip_count$freq),]
rownames(felony_zip_count) <- NULL # reset row index
felony_zip_count

# given address is top n% in number of felonies reported
felony_perc <- as.integer(rownames(felony_zip_count)[felony_zip_count$ZIPCODE == addr_zip]) / length(shapeData$ZIPCODE) * 100
if (length(felony_perc) == 0) {
  felony_perc = 100
}

# sort shooting_zip_count in descending order
shooting_zip_count <- shooting_zip_count[order(-shooting_zip_count$freq),]
rownames(shooting_zip_count) <- NULL # reset row index
shooting_zip_count

# given address is top n% in number of shooting instances reported
shooting_perc <- as.integer(rownames(shooting_zip_count)[shooting_zip_count$ZIPCODE == addr_zip]) / length(shapeData$ZIPCODE)
if (length(shooting_perc) == 0) {
  shooting_perc = 100
}

# sort misdemeanor_zip_count in descending order
misdemeanor_zip_count <- misdemeanor_zip_count[order(-misdemeanor_zip_count$freq),]
rownames(misdemeanor_zip_count) <- NULL # reset row index
misdemeanor_zip_count

# given address is top n% in number of misdemeanors reported
misdemeanor_perc <- as.integer(rownames(misdemeanor_zip_count)[misdemeanor_zip_count$ZIPCODE == addr_zip]) / length(shapeData$ZIPCODE)
if (length(misdemeanor_perc) == 0) {
  misdemeanor_perc = 100
}

# sort violation_zip_count in descending order
violation_zip_count <- violation_zip_count[order(-violation_zip_count$freq),]
rownames(violation_zip_count) <- NULL # reset row index
violation_zip_count

# given address is top n% in number of violations reported
violation_perc <- as.integer(rownames(violation_zip_count)[violation_zip_count$ZIPCODE == addr_zip]) / length(shapeData$ZIPCODE)
if (length(violation_perc) == 0) {
  violation_perc = 100
}

# number of crimes by category in the selected region --> maybe these would be better for the crime map instead of the summary map
shooting_zip_count[shooting_zip_count$ZIPCODE == addr_zip, "freq"]
felony_zip_count[felony_zip_count$ZIPCODE == addr_zip, "freq"]
misdemeanor_zip_count[misdemeanor_zip_count$ZIPCODE == addr_zip, "freq"]
violation_zip_count[violation_zip_count$ZIPCODE == addr_zip, "freq"]

# summary by crime category --> also may be better for the crime map
summary(felony_zip_count$freq)
summary(misdemeanor_zip_count$freq)
summary(violation_zip_count$freq)
summary(shooting_zip_count$freq)
