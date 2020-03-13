library(raster)
library(rgdal)
library(sp)

StandMap<-raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_landscape_basic_Sor_1/StandMap_r5.tif",sep=""))
library(rgdal)
plot(StandMap)
StandMap
min(StandMap)
crs(StandMap)
extent(StandMap)
extent(Ecoregion)
crs(StandMap)<-crs(Ecoregion)

writeRaster(StandMap, "R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_landscape_basic_Sor_1/StandMap_r7.tif", datatype='INT4S', overwrite=TRUE)
StandMapNEW<-raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_landscape_basic_Sor_1/StandMap_r7.tif",sep=""))
plot(StandMapNEW)
crs(StandMapNEW)
extent(StandMapNEW)

Econmap <- raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_landscape_basic_Sor_1/nc_parcels_valacre1.tif",sep=""))
plot(Econmap)
crs(Econmap)
crs(Econmap) <- " +proj=utm +zone=17 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs"

writeRaster(Econmap, "R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_landscape_basic_Sor_1/ParcelValRes.tif")

econ<-raster:projectRaster(Econmap,StandMap,method="ngb")
Econresamp <- resample(Econmap, StandMap, method="ngb")

writeRaster(Econresamp, "R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_landscape_basic_Sor_1/Parcels.tif")


Standshp <- readOGR("C:/Users/tgmozele/Documents/ArcGIS/streets_waterX_own_shp.shp", stringsAsFactors = FALSE)
Standshp$knewID <- 1:44510
writeOGR(Standshp, "C:/Users/tgmozele/Documents/OwnStandPoly.shp", "OwnStandPoly", driver = "ESRI Shapefile", overwrite_layer = TRUE)


StandRaster<-raster(paste("C:/Users/tgmozele/Documents/ArcGIS/OwnStandPoly_Raster51.tif",sep=""))
plot(StandRaster)
StandRaster


Ecoregion <- raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_landscape_basic_Sor_1/Ecoregion_5_29.img",sep=""))
plot(Ecoregion)
crs(Ecoregion)


MgmtMap<-raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_landscape_basic_Sor_1/MgmtMap11.tif",sep=""))
crs(MgmtMap)

#############################################################################################

nlcd_un<-raster(paste("R:/fer/rschell/Mozelewski/nlcd_clip/prj.adf",sep=""))
plot(nlcd_un)
crs(nlcd_un)

Ecoregion <- raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_landscape_basic_Sor_1/Ecoregion_5_29.img",sep=""))
crs(nlcd_un) <- crs(Ecoregion)
crs(nlcd_un)

writeRaster(nlcd_un, "R:/fer/rschell/Mozelewski/nlcd_clip/nlcd_reproj.tif", datatype='INT4S', overwrite=TRUE)
nlcd_reproj <- raster(paste("R:/fer/rschell/Mozelewski/nlcd_clip/nlcd_reproj.tif"))


nlcd_16<-raster(paste("R:/fer/rschell/Mozelewski/nlcd_2016/NLCD_2016_Land_Cover_L48_20190424.img",sep=""))
plot(nlcd_16)
crs(nlcd_16)
crs(nlcd_16) <- crs(Ecoregion)
crs(nlcd_16)
#writeRaster(nlcd_16, "R:/fer/rschell/Mozelewski/nlcd_2016/nlcd_reproj.tif", datatype='INT4S', overwrite=TRUE)

crop_extent <- readOGR("R:/fer/rschell/Mozelewski/Study extent/studyextent.shp")
crs(crop_extent)

nlcd16_crop <- crop(nlcd_16, crop_extent)

eco_proj <- "+proj=utm +zone=17 +datum=WGS84 +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0"
nlcd_reproj <- spTransform(nlcd_16, CRS(eco_proj))

#############################################################

n16 <- raster("R:/fer/rschell/Mozelewski/nlcd_2016/NLCD_2016_Land_Cover_L48_20190424.img") 

### THIS ONE WORKS!!!!!!!!!!!!!!!!!!!!!!
new16 <- projectRaster(n16, Ecoregion, method="ngb")
plot(new16)
crs(new16)
plot(Ecoregion)

setwd("R:/fer/rschell/Mozelewski/nlcd_2016/")
writeRaster(new16, filename="nlcd16_reproj.tif", overwrite=TRUE)

#################### FORE-SCE #########################
### A1B ###

setwd("R:/fer/rschell/Mozelewski/CONUS_Landcover/")

flist <- list.files(path = "CONUS_Landcover_A1B/", pattern = "*.tif$", full = TRUE)

TimestepList <- as.character(seq(from=2006, to=2100, by=1))

for (i in TimestepList) {
  print(i)
   map <- raster(paste("R:/fer/rschell/Mozelewski/CONUS_Landcover/CONUS_Landcover_A1B/CONUS_A1B_y", i, ".tif", sep=""))
  newmap <- projectRaster(map, Ecoregion, method="ngb")
  writeRaster(newmap, paste("R:/fer/rschell/Mozelewski/CONUS_Landcover/CONUS_reproj_A1B/CONUS_A1B_y", i, ".tif", sep=""), format="GTiff", datatype="INT4S", overwrite=T) 
}
 
  
  
### B2 ###

flist <- list.files(path = "CONUS_Landcover_B2/", pattern = "*.tif$", full = TRUE)

TimestepList <- as.character(seq(from=2006, to=2100, by=1))

for (i in TimestepList) {
  print(i)
  map <- raster(paste("R:/fer/rschell/Mozelewski/CONUS_Landcover/CONUS_Landcover_B2/CONUS_B2_y", i, ".tif", sep=""))
  newmap <- projectRaster(map, Ecoregion, method="ngb")
  writeRaster(newmap, paste("R:/fer/rschell/Mozelewski/CONUS_Landcover/CONUS_reproj_B2/CONUS_B2_y", i, ".tif", sep=""), format="GTiff", datatype="INT4S", overwrite=T) 
}

########################################################################################
############################# Geodiversity ############################################
tnc_geo <- raster("C:/Users/tgmozele/Documents/ArcGIS/Landscape_Diversity_Eco_crop.tif")
plot(tnc_geo)

new_tnc_geo <- projectRaster(tnc_geo, Ecoregion, method="ngb")
plot(new_tnc_geo)
crs(new_tnc_geo)
plot(Ecoregion)

setwd("R:/fer/rschell/Mozelewski/nlcd_2016/")
writeRaster(new16, filename="nlcd16_reproj.tif", overwrite=TRUE)


########################################################################################
######################### Clustering around conservation cores #########################
########################################################################################
library(rgdal)
library(raster)
library(rgeos)
options(stringsAsFactors = FALSE)

managed_areas <- readOGR("R:/fer/rschell/Mozelewski/Managed and Protected areas/ma_clip.shp")
ma_reproj <- spTransform(managed_areas, crs(Ecoregion)) 
crs(ma_reproj)
crs(Ecoregion)
plot(ma_reproj)

tm <- file.path("R:/fer/rschell/Mozelewski/Managed and Protected areas/")
writeOGR(obj=ma_reproj, dsn=tm, layer="ma_clip_reproj", driver="ESRI Shapefile")



