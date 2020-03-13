library(raster)

StandMap<-raster(paste("C:/Users/tgmozele/Documents/ArcGIS/Standraster_Resample1.tif",sep=""))
library(rgdal)
plot(StandMap)
StandMap
min(StandMap)

Standshp <- readOGR("C:/Users/tgmozele/Documents/ArcGIS/streets_waterX_own_shp.shp", stringsAsFactors = FALSE)
Standshp$knewID <- 1:44510
writeOGR(Standshp, "C:/Users/tgmozele/Documents/OwnStandPoly.shp", "OwnStandPoly", driver = "ESRI Shapefile", overwrite_layer = TRUE)


StandRaster<-raster(paste("C:/Users/tgmozele/Documents/ArcGIS/OwnStandPoly_Raster51.tif",sep=""))
plot(StandRaster)
StandRaster



Ecoregion <- raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_landscape_basic_Sor/Ecoregion_5_29.img",sep=""))
plot(Ecoregion)
a<-raster:projectRaster(StandRaster,Ecoregion,method="ngb")
Standresamp <- resample(StandRaster, Ecoregion, method="ngb")

writeRaster(Standresamp, "R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_landscape_basic_Sor/StandMap.tif")


extent(StandRaster)
crs(StandRaster)<-crs(Ecoregion)
extent(Ecoregion)


LandOwn <- readOGR("C:/Users/tgmozele/Documents/ArcGIS/LandOwn.shp", stringsAsFactors = FALSE)
LandOwn$knewID <- 1:7 
writeOGR(LandOwn, "C:/Users/tgmozele/Documents/LandOwnPoly.shp", "LandOwnPoly", driver = "ESRI Shapefile", overwrite_layer = TRUE)

MgmtRaster1<-raster(paste("C:/Users/tgmozele/Documents/ArcGIS/LandOwnPoly11.tif",sep=""))
Mgmtresamp1 <- resample(MgmtRaster1, Ecoregion, method="ngb")
writeRaster(Mgmtresamp1, "R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_landscape_basic_Sor/MgmtMap7.tif")
MgmtMap7 <- raster("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_landscape_basic_Sor/MgmtMap7.tif")

crs(MgmtMap7)
crs(Ecoregion)

#############################################
data.dir <- "R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_landscape_basic_Sor/"
raster.name <- "MgmtMap9"
writeRaster(MgmtMap7, file=paste(data.dir, raster.name, ".tif", sep=""), datatype='INT4S', overwrite=TRUE)
MgmtMap10 <- raster("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_landscape_basic_Sor/MgmtMap10.tif")

MgmtMap10[is.na(MgmtMap10[])] <- 99999
plot(MgmtMap10)
MgmtMap10$MgmtMap10

Map10_test1 <- as.data.frame(MgmtMap10)
Map10_test1[is.na(Map10_test1),]
writeRaster(MgmtMap10, file=paste(data.dir, "MgmtMap11.tif", sep=""), datatype='INT4S', overwrite=TRUE)


raster.name1 <- "StandMap_r1"
StandMap <- raster("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_landscape_basic_Sor/StandMap.tif")
writeRaster(StandMap, file=paste(data.dir, raster.name1, ".tif", sep=""), datatype='FLT4S', overwrite=TRUE)

##############################################
#Creating Land Use Change maps
#############################################
library(rgdal)

Ecoregion <- raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_landscape_basic_Sor/Ecoregion_5_29.img",sep=""))
plot(Ecoregion)
#a<-raster:projectRaster(StandRaster,Ecoregion,method="ngb")

LU2030<-raster(paste("C:/Users/tgmozele/Documents/ArcGIS/serap_urb2030.tif", sep=""))

#crs(LU2020)

LU2030rep<-projectRaster(LU2030, Ecoregion, method="ngb")
crs(LU2030rep)
crs(Ecoregion)

#LU2020resamp <- resample(LU2020rep, Ecoregion, method="ngb")
landuse30_test <- as.data.frame(LU2030rep)
is.na(landuse30_test)

LU2030rep[is.na(LU2030rep[])] <- as.double(0)
landuse30_test2 <- as.data.frame(LU2030rep)
is.na(landuse30_test2)
writeRaster(LU2030rep, file=paste(data.dir, "landuse_2030.tif", sep=""), datatype='INT2S', overwrite=TRUE)

LU10<-raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_landscape_basic_Sor/landuse_2030.tif", sep=""))
LU10[LU10 > 0] <- as.double(2)

writeRaster(LU10, file=paste(data.dir, "land-use-10.tif", sep=""), datatype='INT2S', overwrite=TRUE)
###############################################
library(rgdal)

Ecoregion <- raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_landscape_basic_Sor/Ecoregion_5_29.img",sep=""))
plot(Ecoregion)
#a<-raster:projectRaster(StandRaster,Ecoregion,method="ngb")

LU2020<-raster(paste("C:/Users/tgmozele/Documents/ArcGIS/serap_urb2020.tif", sep=""))

#crs(LU2020)

LU2020rep<-projectRaster(LU2020, Ecoregion, method="ngb")
crs(LU2020rep)
crs(Ecoregion)

#LU2020resamp <- resample(LU2020rep, Ecoregion, method="ngb")
landuse20_test <- as.data.frame(LU2020rep)
is.na(landuse20_test)

LU2020rep[is.na(LU2020rep[])] <- as.numeric(0)
landuse20_test2 <- as.data.frame(LU2020rep)
is.na(landuse20_test2)
writeRaster(LU2020rep, file=paste(data.dir, "landuse_2020.tif", sep=""), datatype='INT2S', overwrite=TRUE)

LU0<-raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_landscape_basic_Sor/landuse_2020.tif", sep=""))
LU0[LU0 > 0] <- as.numeric(2)

writeRaster(LU0, file=paste(data.dir, "land-use-0.tif", sep=""), datatype='INT2S', overwrite=TRUE)



##################################################
LU2100<-raster(paste("C:/Users/tgmozele/Documents/ArcGIS/serap_urb2100.tif", sep=""))

LU2100rep<-projectRaster(LU2100, Ecoregion, method="ngb")
crs(LU2100rep)
crs(Ecoregion)

#landuse50_test <- as.data.frame(LU2050rep)
#is.na(landuse50_test)

LU2100rep[is.na(LU2100rep[])] <- as.numeric(0)
landuse100_test2 <- as.data.frame(LU2100rep)
is.na(landuse100_test2)
writeRaster(LU2100rep, file=paste(data.dir, "landuse_2100.tif", sep=""), datatype='INT2S', overwrite=TRUE)

LU80<-raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_landscape_basic_Sor/landuse_2100.tif", sep=""))
LU80[LU80 > 0] <- as.numeric(2)

writeRaster(LU80, file=paste(data.dir, "land-use-80.tif", sep=""), datatype='INT2S', overwrite=TRUE)
