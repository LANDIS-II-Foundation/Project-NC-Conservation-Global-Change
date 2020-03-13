library(raster)
library(sf)
library(rgdal)
library(gdistance)
library(rgeos)
library(otuSummary)
library('geosphere')
library(gdata)
library(maptools)
library(tidyverse)
library(reshape2)
library(data.table)
library(scales)


#Bring in ecoregion map to use for crs and extent template
Ecoregion <- raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_test/Ecoregion100f.tif",sep=""))
crs(Ecoregion)

#Bring in community type map, assign projection, and reformat to ecoregion extent for time step zero
biore80 <- raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_test/output/bio-reclass1-80.img",sep=""))
crs(biore80) <- "+proj=utm +zone=17 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs"
extent(biore80)<-raster::extent(Ecoregion)

#Bring in stand median age map, assign projection, and reformat to ecoregion extent for time step zero
median80 <- raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_test/output/cohort-stats/AGE-MED-80.img",sep=""))
crs(median80) <- "+proj=utm +zone=17 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs"
extent(median80)<-raster::extent(Ecoregion)

#Bring in land use change raster for time step zero
LU80 <- raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_test/land-use-80.tif", sep=""))
plot(LU80)
table(getValues(LU80))

#Create a raster that will become resistance raster
test_raster <- raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_test/output/bio-reclass1-80.img",sep=""))
table(getValues(test_raster))

#Assign projection and reformat to ecoregion extent for the resistance raster
crs(test_raster) <- "+proj=utm +zone=17 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs"
extent(test_raster)<-raster::extent(Ecoregion)


### Create conductance surface (1/resistance) for longleaf pine obligate species
### Include community type, stand median age (species richness considered in community type designations)

#longleaf community comp
test_raster[biore80 == 1 & median80 %in% c(0:1),] <- (1/100)
test_raster[biore80 == 1 & median80 %in% c(2:5),] <- (1/95)
test_raster[biore80 == 1 & median80 %in% c(6:7),] <- (1/85)
test_raster[biore80 == 1 & median80 %in% c(8:9),] <- (1/50)
test_raster[biore80 == 1 & median80 %in% c(10:20),] <- (1/10)
test_raster[biore80 == 1 & median80 %in% c(21:34),] <- (1/5)
test_raster[biore80 == 1 & median80 >= 35,] <- 1

#conifer mixed community type
test_raster[biore80 == 2 & median80 %in% c(0:5),] <- (1/95)
test_raster[biore80 == 2 & median80 %in% c(6:10),] <- (1/80)
test_raster[biore80 == 2 & median80 %in% c(11:20),] <- (1/40)
test_raster[biore80 == 2 & median80 %in% c(21:34),] <- (1/30)
test_raster[biore80 == 2 & median80 >= 35,] <- (1/20)

#pine plantation community type
test_raster[biore80 == 3 & median80 %in% c(0:5),] <- (1/100)
test_raster[biore80 == 3 & median80 %in% c(6:10),] <- (1/90)
test_raster[biore80 == 3 & median80 %in% c(11:20),] <- (1/80)
test_raster[biore80 == 3 & median80 %in% c(21:30),] <- (1/70)
test_raster[biore80 == 3 & median80 >= 31,] <- (1/60)

#mixed hardwood and conifer community type
test_raster[biore80 == 4 & median80 %in% c(0:10),] <- (1/100)
test_raster[biore80 == 4 & median80 %in% c(11:20),] <- (1/95)
test_raster[biore80 == 4 & median80 %in% c(21:30),] <- (1/90)
test_raster[biore80 == 4 & median80 >= 31,] <- (1/80)

#hardwood community type
test_raster[biore80 == 5 & median80 %in% c(0:10),] <- (1/100)
test_raster[biore80 == 5 & median80 %in% c(11:20),] <- (1/95)
test_raster[biore80 == 5 & median80 %in% c(21:30),] <- (1/90)
test_raster[biore80 == 5 & median80 >= 31,] <- (1/85)

plot(test_raster)
table(getValues(test_raster))

test_raster2 <- test_raster

#land use type
test_raster2[LU80 == 13] <- (1/90) #cropland
test_raster2[LU80 == 14] <- (1/90) #hay/pasture
test_raster2[LU80 == 1] <- (1/100) #water
test_raster2[LU80 == 2] <- (1/100) #developed
test_raster2[LU80 == 6] <- (1/100) #mining

table(getValues(test_raster2))

plot(test_raster2)

#roads
roads <- readOGR("R:/fer/rschell/Mozelewski/NCRouteCharacteristics_SHP/NCRouteClip.shp")
roads <- spTransform(roads, crs (Ecoregion))
test_raster2[roads$RouteClass %in% c(1:2)] <- (1/100)
test_raster2[roads$RouteClass %in% c(3:4)] <- (1/95)
test_raster2[roads$RouteClass %in% c(5:89)] <- (1/90)
plot(test_raster2)

rm(roads)

pol1test <- rasterToPolygons(test_raster2, fun=function(x){x>= 0.05})
plot(pol1)
crs(pol1)

setwd("R:/fer/rschell/Mozelewski/Chapter_2_analysis/")
writeOGR(obj=pol1test, dsn="shapefiles", layer="pol80test", driver="ESRI Shapefile")

writeRaster(test_raster2,"R:/fer/rschell/Mozelewski/Chapter_2_analysis/test_cir_raster.asc", 
            format = "ascii", overwrite=TRUE) ###for circuitscape resistance layer


testascii <- raster(paste("R:/fer/rschell/Mozelewski/Chapter_2_analysis/test_cir_raster.asc", sep=""))
