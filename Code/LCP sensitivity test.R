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

#Bring in landis standmap
Landis_standmap <- raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_landscape_basic_Sor_1/StandMap_r7.tif",sep=""))

#Read in roads file
roads <- readOGR("R:/fer/rschell/Mozelewski/NCRouteCharacteristics_SHP/NCRouteClip.shp")
roads <- spTransform(roads, crs (Ecoregion))


######### Start for loop here ##########

setwd("C:/Users/tgmozele/Desktop/LCP sensitivity test/")

#flist1 <- list.files(path = "geo2/", full = TRUE)
TimestepList <- as.character(seq(from=20, to=80, by=20))

for (i in TimestepList) {
    print(i)
    biore0 <- raster(paste("C:/Users/tgmozele/Desktop/LCP sensitivity test/geo1/bio-reclass1-", i, ".img", sep=""))
    crs(biore0) <- "+proj=utm +zone=17 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs"
    extent(biore0)<-raster::extent(Ecoregion)
    
    median0 <- raster(paste("C:/Users/tgmozele/Desktop/LCP sensitivity test/geo1/AGE-MED-", i, ".img",sep=""))
    crs(median0) <- "+proj=utm +zone=17 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs"
    extent(median0)<-raster::extent(Ecoregion)
    
    LU0 <- raster(paste("C:/Users/tgmozele/Desktop/LCP sensitivity test/geo1/land-use-", i, ".tif",sep=""))
    
    #Create a raster that will become resistance raster
    test_raster <- biore0
    
    #Assign projection and reformat to ecoregion extent for the resistance raster
    crs(test_raster) <- "+proj=utm +zone=17 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs"
    extent(test_raster)<-raster::extent(Ecoregion)
    
    #longleaf community comp
    test_raster[biore0 == 1 & median0 %in% c(0:1),] <- (1/100)
    test_raster[biore0 == 1 & median0 %in% c(2:5),] <- (1/95)
    test_raster[biore0 == 1 & median0 %in% c(6:7),] <- (1/85)
    test_raster[biore0 == 1 & median0 %in% c(8:9),] <- (1/50)
    test_raster[biore0 == 1 & median0 %in% c(10:20),] <- (1/10)
    test_raster[biore0 == 1 & median0 %in% c(21:34),] <- (1/5)
    test_raster[biore0 == 1 & median0 >= 35,] <- 1
    
    #conifer mixed community type
    test_raster[biore0 == 2 & median0 %in% c(0:5),] <- (1/95)
    test_raster[biore0 == 2 & median0 %in% c(6:10),] <- (1/80)
    test_raster[biore0 == 2 & median0 %in% c(11:20),] <- (1/40)
    test_raster[biore0 == 2 & median0 %in% c(21:34),] <- (1/30)
    test_raster[biore0 == 2 & median0 >= 35,] <- (1/20)
    
    #pine plantation community type
    test_raster[biore0 == 3 & median0 %in% c(0:5),] <- (1/100)
    test_raster[biore0 == 3 & median0 %in% c(6:10),] <- (1/90)
    test_raster[biore0 == 3 & median0 %in% c(11:20),] <- (1/80)
    test_raster[biore0 == 3 & median0 %in% c(21:30),] <- (1/70)
    test_raster[biore0 == 3 & median0 >= 31,] <- (1/60)
    
    #mixed hardwood and conifer community type
    test_raster[biore0 == 4 & median0 %in% c(0:10),] <- (1/100)
    test_raster[biore0 == 4 & median0 %in% c(11:20),] <- (1/95)
    test_raster[biore0 == 4 & median0 %in% c(21:30),] <- (1/90)
    test_raster[biore0 == 4 & median0 >= 31,] <- (1/80)
    
    #hardwood community type
    test_raster[biore0 == 5 & median0 %in% c(0:10),] <- (1/100)
    test_raster[biore0 == 5 & median0 %in% c(11:20),] <- (1/95)
    test_raster[biore0 == 5 & median0 %in% c(21:30),] <- (1/90)
    test_raster[biore0 == 5 & median0 >= 31,] <- (1/85)
    
    test_raster2 <- test_raster
  
    #land use type
    test_raster2[LU0 == 13] <- (1/90) #cropland
    test_raster2[LU0 == 14] <- (1/90) #hay/pasture
    test_raster2[LU0 == 1] <- (1/100) #water
    test_raster2[LU0 == 2] <- (1/100) #developed
    test_raster2[LU0 == 6] <- (1/100) #mining
  
    #roads
    test_raster2[roads$RouteClass %in% c(1:2)] <- (1/100)
    test_raster2[roads$RouteClass %in% c(3:4)] <- (1/95)
    test_raster2[roads$RouteClass %in% c(5:89)] <- (1/90)
    
    writeRaster(test_raster2, paste("C:/Users/tgmozele/Desktop/LCP sensitivity test/geo1/raster", i, ".tif", sep=""), format="GTiff", datatype="INT4S", overwrite=T)
    
    #Best habitat
    pol1 <- rasterToPolygons(test_raster2, fun=function(x){x>= 0.1})
    writeOGR(obj=pol1, dsn="geo1", layer=paste("pol1", i), driver="ESRI Shapefile")


  #Dissolve contiguous polygons using 8-neighbor approach
  proj4string(pol1) = "+proj=utm +zone=17 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs"
  pol1$ID<-seq(1,length(pol1[1]))
  #print(pol1$ID)
  polbuf <- gBuffer(pol1, byid=TRUE, id=pol1$ID, width=1.0, quadsegs=5, capStyle="ROUND",
        joinStyle="ROUND", mitreLimit=1.0)
  polbufdis <- gUnaryUnion(polbuf, id = NULL, checkValidity=NULL)
  a<-raster::disaggregate(polbufdis)
  data<-data.frame(ID=seq(1,length(a@polygons)))

  pol1_dis<-SpatialPolygonsDataFrame(a,data)
  pol1_dis$area_ha <- area(pol1_dis)/10000
#pol1_dis$NEWid <- seq(from= 1, to= length(pol1_dis), by =1)

  pol1_dis$num1 <- seq(from = 1, to= length(pol1_dis), by=1)
  pol1_dis$num2 <- seq(from = 1, to= length(pol1_dis), by=1)

#Assign weight to habitat by type and area to be used in Conefor
  pol1_dis$weight <- NA
#polAll$weight[polAll$NEWid < 20000 & polAll$area_ha %in% c(21:35)] <- 56
  pol1_dis$weight[pol1_dis$area_ha <=21 ] <- 60
  pol1_dis$weight[pol1_dis$area_ha > 21] <- 85
  pol1_dis$weight[pol1_dis$area_ha >= 35] <- 100

#maketext <- cbind(pol1_dis$NEWid, pol1_dis$weight)
#write.table(maketext, file = "nodesLL.txt", sep = "\t", row.names = FALSE, col.names = FALSE)


###create transition matrix from resistance raster, which is required by gdistance package to calculate resistance 
###distance and least cost path
  test_tr <- transition(test_raster2, transitionFunction=mean, directions=8)

#find polgyon centroid
#trueCentroids <- gCentroid(pol1_dis, byid=TRUE, id = pol1_dis$NEWid)
  trueCentroids <- gCentroid(pol1_dis, byid=TRUE, id = pol1_dis$ID)

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
  #lookup <- cbind(pol1_dis$NEWid, pol1_dis$num1, pol1_dis$num2)
  lookup <- cbind(pol1_dis$ID, pol1_dis$num1, pol1_dis$num2)
  #colnames(lookup) <- c("NewID", "num1", "num2")
  colnames(lookup) <- c("ID", "num1", "num2")
  #lookup_tab <- data.table(lookup)
  EU_test <- merge(x = EU5000_nodups, y = lookup, by = "num1", all.x = TRUE)
  #colnames(EU_test) <- c("num1", "num2", "EUD", "NewID", "num2.y")
  colnames(EU_test) <- c("num1", "num2", "EUD", "ID", "num2.y")
  EU_test2 <- merge(x = EU_test, y = lookup, by = "num2", all.x = TRUE)
  #EU_fin <- cbind(EU_test2$NewID.x, EU_test2$NewID.y)
  EU_fin <- cbind(EU_test2$ID.x, EU_test2$ID.y)
  EU_fin_df <- data.frame(EU_fin)


  #calculate least cost path
  test_trC <- geoCorrection(test_tr, type="c") #geocorrection for least cost path
  costDist <- costDistance(test_trC, trueCentroids) #LCP
  costmatrix <- matrixConvert(costDist, colname = c("pola", "polb2", "dist"))
  colnames(costmatrix) <- c("X1", "X2", "resistance")
  EU_fin_df$costdis <- NULL
  costdist5000 <- merge (EU_fin_df, costmatrix, by.x= c("X2", "X1"), by.y = c("X1", "X2"))
  costdist5000df <- data.frame(costdist5000)
  #write.csv(costdist5000df, file=paste("C:/Users/tgmozele/Desktop/LCP sensitivity test/rand2/costdistance5_", i, ".csv"), row.names=F)
}
