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


#Bring in ecoregion map to use for crs and extent template
Ecoregion <- raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_landscape_basic_Sor_1/Ecoregion_5_29.img",sep=""))
crs(Ecoregion)

#Bring in community type map, assign projection, and reformat to ecoregion extent for time step zero
biore80 <- raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_random_strat/output/bio-reclass1-80.img",sep=""))
crs(biore80) <- "+proj=utm +zone=17 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs"
extent(biore80)<-raster::extent(Ecoregion)

#Bring in stand median age map, assign projection, and reformat to ecoregion extent for time step zero
median80 <- raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_random_strat/output/cohort-stats/AGE-MED-80.img",sep=""))
crs(median80) <- "+proj=utm +zone=17 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs"
extent(median80)<-raster::extent(Ecoregion)

#Bring in land use change raster for time step zero
LU80 <- raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_random_strat/land-use-80.tif", sep=""))
plot(LU80)
table(getValues(LU80))

#Create a raster that will become resistance raster
test_raster <- raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_random_strat/output/bio-reclass1-80.img",sep=""))
table(getValues(test_raster))

#Assign projection and reformat to ecoregion extent for the resistance raster
crs(test_raster) <- "+proj=utm +zone=17 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs"
extent(test_raster)<-raster::extent(Ecoregion)


### Create conductance surface (1/resistance) for longleaf pine obligate species
### Include community type, stand median age (species richness considered in community type designations)

#longleaf community comp
test_raster[biore80 == 1 & median80 %in% c(0:5),] <- (1/95)
test_raster[biore80 == 1 & median80 %in% c(6:10),] <- (1/75)
test_raster[biore80 == 1 & median80 %in% c(11:20),] <- (1/20)
test_raster[biore80 == 1 & median80 %in% c(21:34),] <- (1/10)
test_raster[biore80 == 1 & median80 >= 35,] <- 1

#conifer mixed community type
test_raster[biore80 == 2 & median80 %in% c(0:5),] <- (1/95)
test_raster[biore80 == 2 & median80 %in% c(6:10),] <- (1/75)
test_raster[biore80 == 2 & median80 %in% c(11:20),] <- (1/25)
test_raster[biore80 == 2 & median80 %in% c(21:34),] <- (1/10)
test_raster[biore80 == 2 & median80 >= 35,] <- 1

#pine plantation community type
test_raster[biore80 == 3 & median80 %in% c(0:5),] <- (1/100)
test_raster[biore80 == 3 & median80 %in% c(6:10),] <- (1/90)
test_raster[biore80 == 3 & median80 %in% c(11:20),] <- (1/75)
test_raster[biore80 == 3 & median80 %in% c(21:30),] <- (1/55)
test_raster[biore80 == 3 & median80 >= 31,] <- (1/40)

#mixed hardwood and conifer community type
test_raster[biore80 == 4 & median80 %in% c(0:5),] <- (1/95)
test_raster[biore80 == 4 & median80 %in% c(6:10),] <- (1/80)
test_raster[biore80 == 4 & median80 %in% c(11:20),] <- (1/35)
test_raster[biore80 == 4 & median80 %in% c(21:34),] <- (1/20)
test_raster[biore80 == 4 & median80 >= 35,] <- (1/10)

#hardwood community type
test_raster[biore80 == 5 & median80 %in% c(0:5),] <- (1/100)
test_raster[biore80 == 5 & median80 %in% c(6:10),] <- (1/90)
test_raster[biore80 == 5 & median80 %in% c(11:20),] <- (1/75)
test_raster[biore80 == 5 & median80 %in% c(21:30),] <- (1/55)
test_raster[biore80 == 5 & median80 >= 31,] <- (1/40)

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


###Make shapefiles of habitat
setwd("R:/fer/rschell/Mozelewski/Chapter_2_analysis/")
Landis_standmap <- raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_landscape_basic_Sor_1/StandMap_r7.tif",sep=""))
plot(Landis_standmap)

#Best habitat
pol1 <- rasterToPolygons(test_raster2, fun=function(x){x>= 0.1})
plot(pol1)
#stand_pol1_crop <- crop(Landis_standmap, pol1)
#plot(stand_pol1_crop)
#StandPoly <- rasterToPolygons(stand_pol1_crop)
#pol1_o <- over(pol1, StandPoly)
#pol1@data <- cbind(pol1@data, pol1_o)
writeOGR(obj=pol1, dsn="shapefiles", layer="pol180", driver="ESRI Shapefile")

#Second best habitat
#pol2 <- rasterToPolygons(test_raster2, fun=function(x){x>= 0.03 & x< 0.2})
pol2 <- rasterToPolygons(test_raster2, fun=function(x){x>0.025 & x< 0.1})
plot(pol2)
writeOGR(obj=pol2, dsn="shapefiles", layer="pol280", driver="ESRI Shapefile")


#Needed to combine contiguous polygons to reduce memory requirements, otherwise won't run.
#Did this in ArcGIS. Way to do this in R? unifiedPolygons <- unionSpatialPolygons(myPolygons, rep(1, length(myPolygons))
pol1_dis <- readOGR(dsn="shapefiles", "pol180_dis")
#pol1_dis$Area <- area(pol1_dis) #will prob need to remove this for subsequent model outputs
pol1_dis$area_ha <- area(pol1_dis)/10000
pol1_dis$NEWid <- seq(from= 1, to= 9606, by =1) #have to change this number every time. How to fix??

#Again, combined contiguous habitat class 2 polygons in ArcGIS
pol2_dis <- readOGR(dsn="shapefiles", "pol280_dis")
pol2_dis$area_ha <- area(pol2_dis)/10000
pol2_dis$NEWid <- seq(from= 20001, to= 37098, by =1) #have to change this number every time. How to fix??

#Combine to make one habitat poloygons spatial dataframe
polAll <- rbind(pol1_dis, pol2_dis)
polAll$num1 <- seq(from = 1, to= length(polAll), by=1)
polAll$num2 <- seq(from = 1, to= length(polAll), by=1)
plot(polAll)

polAll$num1 <- seq(from = 1, to= length(pol1_dis), by=1)
polAll$num2 <- seq(from = 1, to= length(pol1_dis), by=1)


#Assign weight to habitat by type and area to be used in Conefor
polAll$weight <- NA
#polAll$weight[polAll$NEWid < 20000 & polAll$area_ha %in% c(21:35)] <- 56
polAll$weight[polAll$NEWid < 20000 & polAll$area_ha <=21 ] <- 60
polAll$weight[polAll$NEWid < 20000 & polAll$area_ha > 21] <- 85
polAll$weight[polAll$NEWid < 20000 & polAll$area_ha >= 35] <- 100

#polAll$weight[polAll$NEWid > 20000 & polAll$area_ha %in% c(21:35)] <- 32
polAll$weight[polAll$NEWid > 20000 & polAll$area_ha <=21] <- 20
polAll$weight[polAll$NEWid > 20000 & polAll$area_ha > 21] <- 30
polAll$weight[polAll$NEWid > 20000 & polAll$area_ha >= 35] <- 45

maketext <- cbind(polAll$NEWid, polAll$weight)
write.table(maketext, file = "nodes80gen.txt", sep = "\t",
            row.names = FALSE, col.names = FALSE)


#writeRaster(rastpol_test, "R:/fer/rschell/Mozelewski/Chapter_2_analysis/testpolrast.tif", datatype='INT2S', overwrite=TRUE)

rm(biore80)
rm(median80)
rm(test_raster)
rm(LU80)
rm(Ecoregion)
rm(pol1_dis)
rm(pol2_dis)

###create transition matrix from resistance raster, which is required by gdistance package to calculate resistance 
###distance and least cost path
test_tr <- transition(test_raster2, transitionFunction=mean, directions=8)

#find polgyon centroid
trueCentroids <- gCentroid(polAll, byid=TRUE, id = polAll$NEWid)


#calculate resistance distance
test_trR <- geoCorrection(test_tr, type="r", multpl=FALSE, scl=TRUE) #geocorrection for resistance distance
resDist <- commuteDistance(test_trR, trueCentroids)


#Euclidean distance between points- if euclidean distance is greater than 2000 meters, remove that pair- STILL NEED TO DO!!
#1500 meters for small songbird (Minor and Urban 2008, Sutherland et al. 2000)
#timber rattlesnake (generalist) ~1200 meters (USFS FEIS)
#~500 (449) for eastern spadefoot toad (Baumberger et al. 2019- Movement and habtiat selecton of western spadefoot)
#10,000 biggest median disersal distance for birds found by Sutherland et al.
EUpts <- spDists(x= trueCentroids, y = trueCentroids, longlat = FALSE, segments = FALSE, diagonal = FALSE)
#EU_tri <- reshape2::melt(EUpts, varnames = c('row', 'col'), na.rm = TRUE)
EUnew <- subset(melt(EUpts), value!=0)
EU5000<-EUnew[!(EUnew$value > 5000),]
EU5000_nodups <- EU5000[!duplicated(data.frame(list(do.call(pmin,EU5000),do.call(pmax,EU5000)))),]
colnames(EU5000_nodups) <- c("num1", "num2", "EUD")
lookup <- cbind(polAll$NEWid, polAll$num1, polAll$num2)
colnames(lookup) <- c("NewID", "num1", "num2")
#lookup_tab <- data.table(lookup)
EU_test <- merge(x = EU5000_nodups, y = lookup, by = "num1", all.x = TRUE)
colnames(EU_test) <- c("num1", "num2", "EUD", "NewID", "num2.y")
EU_test2 <- merge(x = EU_test, y = lookup, by = "num2", all.x = TRUE)
EU_fin <- cbind(EU_test2$NewID.x, EU_test2$NewID.y)
EU_fin_df <- data.frame(EU_fin)

rm(EUpts)
rm(EUnew)
rm(EU5000)
rm(EU5000_nodups)
rm(EU_test)
rm(EU_test2)
rm(EUdist)

#convert distance matrix to dataframe and then write text file
resmatrix <- matrixConvert(resDist, colname = c("pola", "polb2", "dist"))
write.table(resmatrix, file="distance.txt", row.names=FALSE, col.names=FALSE)

#calculate least cost path
test_trC <- geoCorrection(test_tr, type="c") #geocorrection for least cost path
costDist <- costDistance(test_trC, trueCentroids) #LCP
costmatrix <- matrixConvert(costDist, colname = c("pola", "polb2", "dist"))
colnames(costmatrix) <- c("X1", "X2", "resistance")
EU_fin_df$costdis <- NULL
costdist5000 <- merge (EU_fin_df, costmatrix, by.x= c("X2", "X1"), by.y = c("X1", "X2"))



write.table(costdist5000, file="costdistance80.txt", row.names=FALSE, col.names=FALSE)

