### Script for Chapt. 2a ###

library(sf)
library(rgdal)
library(tidyselect)
library(plyr)

######################################################################################
#################################### Random sort #####################################
######################################################################################

####################### Select random stands for conservation ########################

# Load in stands w developed stands removed along with open water
stands_nodev_water<-read.csv("R:/fer/rschell/Mozelewski/Chapter_2_analysis/stands for analysis 100.csv")
stands_df <- data.frame(stands_nodev_water)

# This combines row entries of stands_base_df that share a gridcode aka stand number. Here I'm combining non-contiguous stands.
#(1) split the data frame df by the "x" column; 
#(2) for each chunk, take the sum of each numeric-valued column; 
#(3) stick the results back into a single data frame.
#stands_base_group<- ddply(stands_base_df,"gridcode",numcolwise(sum))
stands_base_group<- ddply(stands_df,"gridcode",numcolwise(sum))

# check for duplicates, to make sure that non-contiguous stands have actually been combined.
n_occur <- data.frame(table(stands_base_group$gridcode))
n_occur[n_occur$Freq > 1,]
stands_base_group[stands_base_group$gridcode %in% n_occur$Var1[n_occur$Freq > 1],]

# subtract stands that are already currently managed/protected
already_managed<-read.csv("R:/fer/rschell/Mozelewski/Managed and Protected areas/Already Protected Stands 100.csv")
stands_base <- stands_base_group[!stands_base_group$gridcode %in% already_managed$gridcode,]


# Random sort to randomly pick stands to protect as part of the random conservation strategy
set.seed(42)
rows<- sample(nrow(stands_base), replace=FALSE)
reord_stands_base <- stands_base[rows,]

# find area of each stand in hectares
area_ha <- (reord_stands_base[,11])/10000
reord_stands_base_ha <- cbind(reord_stands_base, area_ha)

# cumulative sum of area (ha)
reord_stands_base_ha[,"cum_area_ha"] <- cumsum(reord_stands_base_ha$area_ha)

write.csv(reord_stands_base_ha, "R:/fer/rschell/Mozelewski/Chapter_2_analysis/random_stands_base.csv")
#reord_stands_base_ha <- read.csv("R:/fer/rschell/Mozelewski/Chapter_2_analysis/random_stands_base.csv")
reord_stands_base_ha <- read.csv("R:/fer/rschell/Mozelewski/Chapter_2_analysis/random_stands_base.csv")

#read in standmap shapefile
#Landis_standmap <- raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_landscape_basic_Sor_1/StandMap_r7.tif",sep=""))
Landis_standmap <- raster(paste("Z:/Mozelewski/NECN_Tina/NewMaps/Standmap100.tif",sep=""))
#standmap <- readOGR("C:/Users/tgmozele/Documents/ArcGIS/Standmap_no99999.shp")
#plot(standmap)

#ma_areas <- readOGR("R:/fer/rschell/Mozelewski/Managed and Protected areas/ma_clip_reproj.shp")
#ma_raster <- raster(paste("R:/fer/rschell/Mozelewski/ma_raster2.tif", sep=""))
#stand_raster <- raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_landscape_basic_Sor_1/StandMap_r7.tif", sep=""))
#extent(ma_raster)
#e <- extent(stand_raster)
#ma_raster <- setExtent(ma_raster, e)
#extent(ma_raster)


#####NEED TO REDO STAND NUMBERS AFTER 100M CELLS!!!!!!!!!!!!!!  
#isolate stands for random 1% strategy
just_stands_rand <- reord_stands_base_ha[,1]
random_timestep1_1 <- just_stands_rand[1:91]
random_timestep1_2 <- just_stands_rand[92:182]
random_timestep1_3 <- just_stands_rand[183:277]
random_timestep1_4 <- just_stands_rand[278:365]
random_timestep1_5 <- just_stands_rand[366:462]
random_timestep1_6 <- just_stands_rand[463:559]
random_timestep1_7 <- just_stands_rand[560:640]
random_timestep1_8 <- just_stands_rand[641:732]
random_timestep1_9 <- just_stands_rand[733:808]
random_timestep1_10 <- just_stands_rand[809:894]
random_timestep1_11 <- just_stands_rand[895:1007]
random_timestep1_12 <- just_stands_rand[1008:1109]
random_timestep1_13 <- just_stands_rand[1110:1207]
random_timestep1_14 <- just_stands_rand[1208:1306]
random_timestep1_15 <- just_stands_rand[1307:1378]
random_timestep1_16 <- just_stands_rand[1379:1481]
random_timestep1_17 <- just_stands_rand[1482:1582]


random1_percent_all <- c(random_timestep1_1, random_timestep1_2, random_timestep1_3, random_timestep1_4, random_timestep1_5,
                         random_timestep1_6, random_timestep1_7, random_timestep1_8, random_timestep1_9, random_timestep1_10, 
                         random_timestep1_11, random_timestep1_12, random_timestep1_13, random_timestep1_14, random_timestep1_15,
                         random_timestep1_16, random_timestep1_17)                                     

#create shapefile of random selection 1% at each timestep
#standmap_timestep_1_1 <- standmap[standmap$gridcode %in% random_timestep1_1,]
#standmap_timestep_1_2 <- standmap[standmap$gridcode %in% random_timestep1_2,]
#standmap_timestep_1_3 <- standmap[standmap$gridcode %in% random_timestep1_3,]
#standmap_timestep_1_4 <- standmap[standmap$gridcode %in% random_timestep1_4,]
#standmap_timestep_1_5 <- standmap[standmap$gridcode %in% random_timestep1_5,]
#standmap_timestep_1_6 <- standmap[standmap$gridcode %in% random_timestep1_6,]
#standmap_timestep_1_7 <- standmap[standmap$gridcode %in% random_timestep1_7,]
#standmap_timestep_1_8 <- standmap[standmap$gridcode %in% random_timestep1_8,]

standmap_timestep_1_1 <- Landis_standmap %in% random_timestep1_1
standmap_timestep_1_2 <- Landis_standmap %in% random_timestep1_2
standmap_timestep_1_3 <- Landis_standmap %in% random_timestep1_3
standmap_timestep_1_4 <- Landis_standmap %in% random_timestep1_4
standmap_timestep_1_5 <- Landis_standmap %in% random_timestep1_5
standmap_timestep_1_6 <- Landis_standmap %in% random_timestep1_6
standmap_timestep_1_7 <- Landis_standmap %in% random_timestep1_7
standmap_timestep_1_8 <- Landis_standmap %in% random_timestep1_8
standmap_timestep_1_9 <- Landis_standmap %in% random_timestep1_9
standmap_timestep_1_10 <- Landis_standmap %in% random_timestep1_10
standmap_timestep_1_11 <- Landis_standmap %in% random_timestep1_11
standmap_timestep_1_12 <- Landis_standmap %in% random_timestep1_12
standmap_timestep_1_13 <- Landis_standmap %in% random_timestep1_13
standmap_timestep_1_14 <- Landis_standmap %in% random_timestep1_14
standmap_timestep_1_15 <- Landis_standmap %in% random_timestep1_15
standmap_timestep_1_16 <- Landis_standmap %in% random_timestep1_16
standmap_timestep_1_17 <- Landis_standmap %in% random_timestep1_17

#MgmtMap <- raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_landscape_basic_Sor_1/MgmtMap11.tif",sep=""))
MgmtMap <- raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NewMaps/MgmtMap100.tif", sep=""))
MgmtMap[standmap_timestep_1_1] <- 11
MgmtMap[standmap_timestep_1_2] <- 12
MgmtMap[standmap_timestep_1_3] <- 13
MgmtMap[standmap_timestep_1_4] <- 14
MgmtMap[standmap_timestep_1_5] <- 15
MgmtMap[standmap_timestep_1_6] <- 16
MgmtMap[standmap_timestep_1_7] <- 17
MgmtMap[standmap_timestep_1_8] <- 18
MgmtMap[standmap_timestep_1_9] <- 19
MgmtMap[standmap_timestep_1_10] <- 20
MgmtMap[standmap_timestep_1_11] <- 21
MgmtMap[standmap_timestep_1_12] <- 22
MgmtMap[standmap_timestep_1_13] <- 23
MgmtMap[standmap_timestep_1_14] <- 24
MgmtMap[standmap_timestep_1_15] <- 25
MgmtMap[standmap_timestep_1_16] <- 26
MgmtMap[standmap_timestep_1_17] <- 27
plot(MgmtMap, zlim=c(0,20))

writeRaster(MgmtMap, "R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_test/MgmtMap_rand110.tif", 
            datatype='INT4S', overwrite=TRUE)

#write shapefile
#setwd("R:/fer/rschell/Mozelewski/Chapter_2_analysis/")
#writeOGR(obj=standmap_timestep_1_1, dsn="shapefiles", layer="random1_1", driver="ESRI Shapefile")
#writeOGR(obj=standmap_timestep_1_2, dsn="shapefiles", layer="random1_2", driver="ESRI Shapefile")
#writeOGR(obj=standmap_timestep_1_3, dsn="shapefiles", layer="random1_3", driver="ESRI Shapefile")
#writeOGR(obj=standmap_timestep_1_4, dsn="shapefiles", layer="random1_4", driver="ESRI Shapefile")
#writeOGR(obj=standmap_timestep_1_5, dsn="shapefiles", layer="random1_5", driver="ESRI Shapefile")
#writeOGR(obj=standmap_timestep_1_6, dsn="shapefiles", layer="random1_6", driver="ESRI Shapefile")
#writeOGR(obj=standmap_timestep_1_7, dsn="shapefiles", layer="random1_7", driver="ESRI Shapefile")
#writeOGR(obj=standmap_timestep_1_8, dsn="shapefiles", layer="random1_8", driver="ESRI Shapefile")


#isolate stands for random 2% strategy (IGNORE THE NUMBER 5 IN THE NAMES BELOW; THIS IS FOR 2%!!!!!!!!!!!!!)
#just_stands_rand <- reord_stands_base_ha[,1]
#random_timestep5_1 <- just_stands_rand[1:178]
#random_timestep5_2 <- just_stands_rand[179:361]
#random_timestep5_3 <- just_stands_rand[362:567]
#random_timestep5_4 <- just_stands_rand[568:755]
#random_timestep5_5 <- just_stands_rand[756:942]
#random_timestep5_6 <- just_stands_rand[943:1136]
#random_timestep5_7 <- just_stands_rand[1137:1295]
#random_timestep5_8 <- just_stands_rand[1296:1509]
#random5_percent_all <- c(random_timestep5_1, random_timestep5_2, random_timestep5_3, random_timestep5_4, random_timestep5_5,
                         #random_timestep5_6, random_timestep5_7, random_timestep5_8)   

#create shapefile of random selection 5% at each timestep
#standmap_timestep_5_1 <- standmap[standmap$gridcode %in% random_timestep5_1,]
#standmap_timestep_5_2 <- standmap[standmap$gridcode %in% random_timestep5_2,]
#standmap_timestep_5_3 <- standmap[standmap$gridcode %in% random_timestep5_3,]
#standmap_timestep_5_4 <- standmap[standmap$gridcode %in% random_timestep5_4,]
#standmap_timestep_5_5 <- standmap[standmap$gridcode %in% random_timestep5_5,]
#standmap_timestep_5_6 <- standmap[standmap$gridcode %in% random_timestep5_6,]
#standmap_timestep_5_7 <- standmap[standmap$gridcode %in% random_timestep5_7,]
#standmap_timestep_5_8 <- standmap[standmap$gridcode %in% random_timestep5_8,]

#standmap_timestep_5_1 <- Landis_standmap %in% random_timestep5_1
#standmap_timestep_5_2 <- Landis_standmap %in% random_timestep5_2
#standmap_timestep_5_3 <- Landis_standmap %in% random_timestep5_3
#standmap_timestep_5_4 <- Landis_standmap %in% random_timestep5_4
#standmap_timestep_5_5 <- Landis_standmap %in% random_timestep5_5
#standmap_timestep_5_6 <- Landis_standmap %in% random_timestep5_6
#standmap_timestep_5_7 <- Landis_standmap %in% random_timestep5_7
#standmap_timestep_5_8 <- Landis_standmap %in% random_timestep5_8

#write shapefile
#setwd("R:/fer/rschell/Mozelewski/Chapter_2_analysis/")
#writeOGR(obj=standmap_timestep_5_1, dsn="shapefiles", layer="random5_1", driver="ESRI Shapefile")
#writeOGR(obj=standmap_timestep_5_2, dsn="shapefiles", layer="random5_2", driver="ESRI Shapefile")
#writeOGR(obj=standmap_timestep_5_3, dsn="shapefiles", layer="random5_3", driver="ESRI Shapefile")
#writeOGR(obj=standmap_timestep_5_4, dsn="shapefiles", layer="random5_4", driver="ESRI Shapefile")
#writeOGR(obj=standmap_timestep_5_5, dsn="shapefiles", layer="random5_5", driver="ESRI Shapefile")
#writeOGR(obj=standmap_timestep_5_6, dsn="shapefiles", layer="random5_6", driver="ESRI Shapefile")
#writeOGR(obj=standmap_timestep_5_7, dsn="shapefiles", layer="random5_7", driver="ESRI Shapefile")
#writeOGR(obj=standmap_timestep_5_8, dsn="shapefiles", layer="random5_8", driver="ESRI Shapefile")


### Ecoregion and mgmt map redo for random strategy ###

Ecoregion <- raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_landscape_basic_Sor_1/Ecoregion_5_29.img",sep=""))
MgmtMap <- raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_landscape_basic_Sor_1/MgmtMap11.tif",sep=""))
Landis_standmap <- raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_landscape_basic_Sor_1/StandMap_r7.tif",sep=""))

#select random stands for 1% and 5% in standmap
random1_conserved_all <- Landis_standmap %in% random1_percent_all
#random5_conserved_all <- Landis_standmap %in% random5_percent_all
plot(random1_conserved_all)
#plot(random5_conserved_all)

#Create new mgmt map for random 1%
MgmtMap <- raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_landscape_basic_Sor_1/MgmtMap11.tif",sep=""))
random1_conserved_1 <- Landis_standmap %in% random_timestep1_1
random1_conserved_2 <- Landis_standmap %in% random_timestep1_2
random1_conserved_3 <- Landis_standmap %in% random_timestep1_3
random1_conserved_4 <- Landis_standmap %in% random_timestep1_4
random1_conserved_5 <- Landis_standmap %in% random_timestep1_5
random1_conserved_6 <- Landis_standmap %in% random_timestep1_6
random1_conserved_7 <- Landis_standmap %in% random_timestep1_7
random1_conserved_8 <- Landis_standmap %in% random_timestep1_8

MgmtMap[random1_conserved_1] <- 11
MgmtMap[random1_conserved_2] <- 12
MgmtMap[random1_conserved_3] <- 13
MgmtMap[random1_conserved_4] <- 14
MgmtMap[random1_conserved_5] <- 15
MgmtMap[random1_conserved_6] <- 16
MgmtMap[random1_conserved_7] <- 17
MgmtMap[random1_conserved_8] <- 18

writeRaster(MgmtMap, "R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_random_strat/MgmtMap_rand1.tif", 
            datatype='INT4S', overwrite=TRUE)

#Create new mgmt map for random 5%
MgmtMap <- raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_landscape_basic_Sor_1/MgmtMap11.tif",sep=""))
random5_conserved_1 <- Landis_standmap %in% random_timestep5_1
random5_conserved_2 <- Landis_standmap %in% random_timestep5_2
random5_conserved_3 <- Landis_standmap %in% random_timestep5_3
random5_conserved_4 <- Landis_standmap %in% random_timestep5_4
random5_conserved_5 <- Landis_standmap %in% random_timestep5_5
random5_conserved_6 <- Landis_standmap %in% random_timestep5_6
random5_conserved_7 <- Landis_standmap %in% random_timestep5_7
random5_conserved_8 <- Landis_standmap %in% random_timestep5_8

MgmtMap[random5_conserved_1] <- 11
MgmtMap[random5_conserved_2] <- 12
MgmtMap[random5_conserved_3] <- 13
MgmtMap[random5_conserved_4] <- 14
MgmtMap[random5_conserved_5] <- 15
MgmtMap[random5_conserved_6] <- 16
MgmtMap[random5_conserved_7] <- 17
MgmtMap[random5_conserved_8] <- 18

writeRaster(MgmtMap, "R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_random_strat2/MgmtMap_rand2.tif", 
            datatype='INT4S', overwrite=TRUE)

######### LUC maps subtract newly protected areas at each timestep 1% by assigning them to forest type in LUC maps
#change original map location to NewMaps folder for run or 100 cell size!!!!!!!!!!!!!!!!!!
LUC0 <- raster(paste("R:/fer/rschell/Mozelewski/CONUS_Landcover/CONUS_reproj_B2/CONUS_B2_y2020.tif",sep=""))
table(getValues(LUC0))
LUC0[random1_conserved_1] <- 10
table(getValues(LUC0))
writeRaster(LUC0, "R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_random_strat/land-use-0.tif", 
            datatype='INT2S', overwrite=TRUE)

LUC10 <- raster(paste("R:/fer/rschell/Mozelewski/CONUS_Landcover/CONUS_reproj_B2/CONUS_B2_y2030.tif",sep=""))
table(getValues(LUC10))
LUC10[random1_conserved_1] <- 10
LUC10[random1_conserved_2] <- 10
table(getValues(LUC10))
writeRaster(LUC10, "R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_random_strat/land-use-10.tif", 
            datatype='INT2S', overwrite=TRUE)

LUC20 <- raster(paste("R:/fer/rschell/Mozelewski/CONUS_Landcover/CONUS_reproj_B2/CONUS_B2_y2040.tif",sep=""))
LUC20[random1_conserved_1] <- 10
LUC20[random1_conserved_2] <- 10
LUC20[random1_conserved_3] <- 10
writeRaster(LUC20, "R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_random_strat/land-use-20.tif", 
            datatype='INT2S', overwrite=TRUE)


LUC30 <- raster(paste("R:/fer/rschell/Mozelewski/CONUS_Landcover/CONUS_reproj_B2/CONUS_B2_y2050.tif",sep=""))
LUC30[random1_conserved_1] <- 10
LUC30[random1_conserved_2] <- 10
LUC30[random1_conserved_3] <- 10
LUC30[random1_conserved_4] <- 10
writeRaster(LUC30, "R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_random_strat/land-use-30.tif", 
            datatype='INT2S', overwrite=TRUE)


LUC40 <- raster(paste("R:/fer/rschell/Mozelewski/CONUS_Landcover/CONUS_reproj_B2/CONUS_B2_y2060.tif",sep=""))
LUC40[random1_conserved_1] <- 10
LUC40[random1_conserved_2] <- 10
LUC40[random1_conserved_3] <- 10
LUC40[random1_conserved_4] <- 10
LUC40[random1_conserved_5] <- 10
writeRaster(LUC40, "R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_random_strat/land-use-40.tif", 
            datatype='INT2S', overwrite=TRUE)


LUC50 <- raster(paste("R:/fer/rschell/Mozelewski/CONUS_Landcover/CONUS_reproj_B2/CONUS_B2_y2070.tif",sep=""))
table(getValues(LUC50))
LUC50[random1_conserved_1] <- 10
LUC50[random1_conserved_2] <- 10
LUC50[random1_conserved_3] <- 10
LUC50[random1_conserved_4] <- 10
LUC50[random1_conserved_5] <- 10
LUC50[random1_conserved_6] <- 10
table(getValues(LUC50))
writeRaster(LUC50, "R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_random_strat/land-use-50.tif", 
            datatype='INT2S', overwrite=TRUE)


LUC60 <- raster(paste("R:/fer/rschell/Mozelewski/CONUS_Landcover/CONUS_reproj_B2/CONUS_B2_y2080.tif",sep=""))
LUC60[random1_conserved_1] <- 10
LUC60[random1_conserved_2] <- 10
LUC60[random1_conserved_3] <- 10
LUC60[random1_conserved_4] <- 10
LUC60[random1_conserved_5] <- 10
LUC60[random1_conserved_6] <- 10
LUC60[random1_conserved_7] <- 10
writeRaster(LUC60, "R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_random_strat/land-use-60.tif", 
            datatype='INT2S', overwrite=TRUE)


LUC70 <- raster(paste("R:/fer/rschell/Mozelewski/CONUS_Landcover/CONUS_reproj_B2/CONUS_B2_y2090.tif",sep=""))
LUC70[random1_conserved_1] <- 10
LUC70[random1_conserved_2] <- 10
LUC70[random1_conserved_3] <- 10
LUC70[random1_conserved_4] <- 10
LUC70[random1_conserved_5] <- 10
LUC70[random1_conserved_6] <- 10
LUC70[random1_conserved_7] <- 10
LUC70[random1_conserved_8] <- 10
writeRaster(LUC70, "R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_random_strat/land-use-70.tif", 
            datatype='INT2S', overwrite=TRUE)


LUC80 <- raster(paste("R:/fer/rschell/Mozelewski/CONUS_Landcover/CONUS_reproj_B2/CONUS_B2_y2100.tif",sep=""))
table(getValues(LUC80))
LUC80[random1_conserved_1] <- 10
LUC80[random1_conserved_2] <- 10
LUC80[random1_conserved_3] <- 10
LUC80[random1_conserved_4] <- 10
LUC80[random1_conserved_5] <- 10
LUC80[random1_conserved_6] <- 10
LUC80[random1_conserved_7] <- 10
LUC80[random1_conserved_8] <- 10
table(getValues(LUC80))
writeRaster(LUC80, "R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_random_strat/land-use-80.tif", 
            datatype='INT2S', overwrite=TRUE)


######### LUC maps subtract newly protected areas at each timestep 2%
LUC0 <- raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_random_strat2/land-use-0.tif",sep=""))
table(getValues(LUC0))
LUC0[random5_conserved_1] <- 10
table(getValues(LUC0))
writeRaster(LUC0, "R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_random_strat2/land-use-0-NEW.tif", 
            datatype='INT2S', overwrite=TRUE)

LUC10 <- raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_random_strat2/land-use-10.tif",sep=""))
LUC10[random5_conserved_1] <- 10
LUC10[random5_conserved_2] <- 10
writeRaster(LUC10, "R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_random_strat2/land-use-10-NEW.tif", 
            datatype='INT2S', overwrite=TRUE)

LUC20 <- raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_random_strat2/land-use-20.tif",sep=""))
LUC20[random5_conserved_1] <- 10
LUC20[random5_conserved_2] <- 10
LUC20[random5_conserved_3] <- 10
writeRaster(LUC20, "R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_random_strat2/land-use-20-NEW.tif", 
            datatype='INT2S', overwrite=TRUE)


LUC30 <- raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_random_strat2/land-use-30.tif",sep=""))
LUC30[random5_conserved_1] <- 10
LUC30[random5_conserved_2] <- 10
LUC30[random5_conserved_3] <- 10
LUC30[random5_conserved_4] <- 10
writeRaster(LUC30, "R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_random_strat2/land-use-30-NEW.tif", 
            datatype='INT2S', overwrite=TRUE)


LUC40 <- raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_random_strat2/land-use-40.tif",sep=""))
LUC40[random5_conserved_1] <- 10
LUC40[random5_conserved_2] <- 10
LUC40[random5_conserved_3] <- 10
LUC40[random5_conserved_4] <- 10
LUC40[random5_conserved_5] <- 10
writeRaster(LUC40, "R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_random_strat2/land-use-40-NEW.tif", 
            datatype='INT2S', overwrite=TRUE)


LUC50 <- raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_random_strat2/land-use-50.tif",sep=""))
LUC50[random5_conserved_1] <- 10
LUC50[random5_conserved_2] <- 10
LUC50[random5_conserved_3] <- 10
LUC50[random5_conserved_4] <- 10
LUC50[random5_conserved_5] <- 10
LUC50[random5_conserved_6] <- 10
writeRaster(LUC50, "R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_random_strat2/land-use-50-NEW.tif", 
            datatype='INT2S', overwrite=TRUE)


LUC60 <- raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_random_strat2/land-use-60.tif",sep=""))
LUC60[random5_conserved_1] <- 10
LUC60[random5_conserved_2] <- 10
LUC60[random5_conserved_3] <- 10
LUC60[random5_conserved_4] <- 10
LUC60[random5_conserved_5] <- 10
LUC60[random5_conserved_6] <- 10
LUC60[random5_conserved_7] <- 10
writeRaster(LUC60, "R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_random_strat2/land-use-60-NEW.tif", 
            datatype='INT2S', overwrite=TRUE)


LUC70 <- raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_random_strat2/land-use-70.tif",sep=""))
LUC70[random5_conserved_1] <- 10
LUC70[random5_conserved_2] <- 10
LUC70[random5_conserved_3] <- 10
LUC70[random5_conserved_4] <- 10
LUC70[random5_conserved_5] <- 10
LUC70[random5_conserved_6] <- 10
LUC70[random5_conserved_7] <- 10
LUC70[random5_conserved_8] <- 10
writeRaster(LUC70, "R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_random_strat2/land-use-70-NEW.tif", 
            datatype='INT2S', overwrite=TRUE)


LUC80 <- raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_random_strat2/land-use-80.tif",sep=""))
plot(LUC80)
LUC80[random5_conserved_1] <- 10
LUC80[random5_conserved_2] <- 10
LUC80[random5_conserved_3] <- 10
LUC80[random5_conserved_4] <- 10
LUC80[random5_conserved_5] <- 10
LUC80[random5_conserved_6] <- 10
LUC80[random5_conserved_7] <- 10
LUC80[random5_conserved_8] <- 10
plot(LUC80)
writeRaster(LUC80, "R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_random_strat2/land-use-80-NEW.tif", 
            datatype='INT2S', overwrite=TRUE)

######################################################################################
################################### Economic sort ####################################
######################################################################################

### Weighted random sample for econ

#Econ strategy --> run for 25% more land
econ_nozeros <-read.csv("R:/fer/rschell/Mozelewski/Chapter_2_analysis/Econ_parcels_nozeros_100.csv")
econ_df <- data.frame(econ_nozeros)

#(1) split the data frame df by the "x" column; 
#(2) for each chunk, take the sum of each numeric-valued column; 
#(3) stick the results back into a single data frame.
stands_econ_group<- ddply(econ_df,"gridcode",numcolwise(sum))

#remove alread managed or protected stands from consideration
stands_econ <- stands_econ_group[stands_econ_group$gridcode %in% stands_base$gridcode,]
#formerly had stands_econ <- econ_nozeros[!econ_nozeros$gridcode %in% already_managed$gridcode]

# Find area of each stand in hectares and cost per hectare of each stand
area_ha <- (stands_econ[,9])/10000
stands_econ_ha <- cbind(stands_econ, area_ha)
cost_ha <- stands_econ_ha$gridcode_1/stands_econ_ha$area_ha
stands_econ_f <- cbind(stands_econ_ha, cost_ha)

#Establish probability column to use
prob_econ <- seq(from = 0.96, to = 0.0001, by = -0.00015)
extra <- rep(0.00001, 950)
#prob_num <- prob_econ[1:11014] # used when originally doing prob_econ <- seq(from = 0.9, to = 0.0001, by = -0.00001)
new_prob <- append(prob_econ, extra)

nsample <- 7350
econ_data <- cbind(stands_econ_f, new_prob)
set.seed(43)
samp_econ <- sample(seq_len(nrow(econ_data)), nsample, replace = FALSE, prob=new_prob)
reord_stands_econ_ha <- econ_data[samp_econ, ]


# cumulative sum of area (ha)
reord_stands_econ_ha[,"cum_area_ha"] <- cumsum(reord_stands_econ_ha$area_ha)
write.csv(reord_stands_econ_ha, "R:/fer/rschell/Mozelewski/Chapter_2_analysis/Econ_parcels_prob_ord_100.csv")
reord_stands_econ_ha <- read.csv("Z:/Chapter_2_analysis/Econ_parcels_prob_ord_100.csv")

#CHECK COLUMN NUMBER IN REORD_STANDS_ECON_HA WHEN RERUNNING... I HAVE MADE MISTAKES!!!!!!!!!!!!!
just_stands_econ <- reord_stands_econ_ha[,2]
econ_timestep125_1 <- just_stands_econ[1:142]
econ_timestep125_2 <- just_stands_econ[143:265]
econ_timestep125_3 <- just_stands_econ[266:381]
econ_timestep125_4 <- just_stands_econ[382:541]
econ_timestep125_5 <- just_stands_econ[542:670]
econ_timestep125_6 <- just_stands_econ[671:805]
econ_timestep125_7 <- just_stands_econ[806:936]
econ_timestep125_8 <- just_stands_econ[937:1055]
econ_timestep125_9 <- just_stands_econ[1056:1178]
econ_timestep125_10 <- just_stands_econ[1179:1298]
econ_timestep125_11 <- just_stands_econ[1299:1427]
econ_timestep125_12 <- just_stands_econ[1428:1541]
econ_timestep125_13 <- just_stands_econ[1542:1677]
econ_timestep125_14 <- just_stands_econ[1678:1801]
econ_timestep125_15 <- just_stands_econ[1802:1909]
econ_timestep125_16 <- just_stands_econ[1910:2014]
econ_timestep125_17 <- just_stands_econ[2015:2128]
econ125_percent_all <- c(econ_timestep125_1, econ_timestep125_2, econ_timestep125_3, econ_timestep125_4, econ_timestep125_5,
                         econ_timestep125_6, econ_timestep125_7, econ_timestep125_8,  econ_timestep125_9, econ_timestep125_10, 
                         econ_timestep125_11, econ_timestep125_12, econ_timestep125_13, econ_timestep125_14, econ_timestep125_15,
                         econ_timestep125_16, econ_timestep125_17)                                     


#MgmtMap <- raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_landscape_basic_Sor_1/MgmtMap11.tif",sep=""))
econ5_conserved_1 <- Landis_standmap %in% econ_timestep125_1
econ5_conserved_2 <- Landis_standmap %in% econ_timestep125_2
econ5_conserved_3 <- Landis_standmap %in% econ_timestep125_3
econ5_conserved_4 <- Landis_standmap %in% econ_timestep125_4
econ5_conserved_5 <- Landis_standmap %in% econ_timestep125_5
econ5_conserved_6 <- Landis_standmap %in% econ_timestep125_6
econ5_conserved_7 <- Landis_standmap %in% econ_timestep125_7
econ5_conserved_8 <- Landis_standmap %in% econ_timestep125_8
econ5_conserved_9 <- Landis_standmap %in% econ_timestep125_9
econ5_conserved_10 <- Landis_standmap %in% econ_timestep125_10
econ5_conserved_11 <- Landis_standmap %in% econ_timestep125_11
econ5_conserved_12 <- Landis_standmap %in% econ_timestep125_12
econ5_conserved_13 <- Landis_standmap %in% econ_timestep125_13
econ5_conserved_14 <- Landis_standmap %in% econ_timestep125_14
econ5_conserved_15 <- Landis_standmap %in% econ_timestep125_15
econ5_conserved_16 <- Landis_standmap %in% econ_timestep125_16
econ5_conserved_17 <- Landis_standmap %in% econ_timestep125_17

MgmtMap <- raster(paste("Z:/Mozelewski/NECN_Tina/NewMaps/MgmtMap100.tif", sep=""))
MgmtMap[econ5_conserved_1] <- 11
MgmtMap[econ5_conserved_2] <- 12
MgmtMap[econ5_conserved_3] <- 13
MgmtMap[econ5_conserved_4] <- 14
MgmtMap[econ5_conserved_5] <- 15
MgmtMap[econ5_conserved_6] <- 16
MgmtMap[econ5_conserved_7] <- 17
MgmtMap[econ5_conserved_8] <- 18
MgmtMap[econ5_conserved_9] <- 19
MgmtMap[econ5_conserved_10] <- 20
MgmtMap[econ5_conserved_11] <- 21
MgmtMap[econ5_conserved_12] <- 22
MgmtMap[econ5_conserved_13] <- 23
MgmtMap[econ5_conserved_14] <- 24
MgmtMap[econ5_conserved_15] <- 25
MgmtMap[econ5_conserved_16] <- 26
MgmtMap[econ5_conserved_17] <- 27

writeRaster(MgmtMap, "Z:/Mozelewski/NECN_Tina/NECN_Tina_test/MgmtMap_econ125_5.tif", 
            datatype='INT4S', overwrite=TRUE)
econ_mgmt<- raster(paste("Z:/NECN_Tina/NECN_Tina_test/MgmtMap_econ125_5.tif"))
econ_mgmt2<- raster(paste("E:/NECN_Tina/econ_strat/MgmtMap_econ125_5.tif"))
plot(econ_mgmt, zlim=c(10:28))
plot(econ_mgmt2, zlim=c(10:28))

######### LUC maps subtract newly protected areas at each timestep 2%
LUC0 <- raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_econ_strat/land-use-0_OLD.tif",sep=""))
table(getValues(LUC0))
LUC0[econ5_conserved_1] <- 10
table(getValues(LUC0))
writeRaster(LUC0, "R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_econ_strat/land-use-0.tif", 
            datatype='INT2S', overwrite=TRUE)

LUC10 <- raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_econ_strat/land-use-10_OLD.tif",sep=""))
LUC10[econ5_conserved_1] <- 10
LUC10[econ5_conserved_2] <- 10
writeRaster(LUC10, "R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_econ_strat/land-use-10.tif", 
            datatype='INT2S', overwrite=TRUE)

LUC20 <- raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_econ_strat/land-use-20_OLD.tif",sep=""))
LUC20[econ5_conserved_1] <- 10
LUC20[econ5_conserved_2] <- 10
LUC20[econ5_conserved_3] <- 10
writeRaster(LUC20, "R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_econ_strat/land-use-20.tif", 
            datatype='INT2S', overwrite=TRUE)


LUC30 <- raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_econ_strat/land-use-30_OLD.tif",sep=""))
LUC30[econ5_conserved_1] <- 10
LUC30[econ5_conserved_2] <- 10
LUC30[econ5_conserved_3] <- 10
LUC30[econ5_conserved_4] <- 10
writeRaster(LUC30, "R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_econ_strat/land-use-30.tif", 
            datatype='INT2S', overwrite=TRUE)


LUC40 <- raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_econ_strat/land-use-40_OLD.tif",sep=""))
LUC40[econ5_conserved_1] <- 10
LUC40[econ5_conserved_2] <- 10
LUC40[econ5_conserved_3] <- 10
LUC40[econ5_conserved_4] <- 10
LUC40[econ5_conserved_5] <- 10
writeRaster(LUC40, "R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_econ_strat/land-use-40.tif", 
            datatype='INT2S', overwrite=TRUE)


LUC50 <- raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_econ_strat/land-use-50_OLD.tif",sep=""))
LUC50[econ5_conserved_1] <- 10
LUC50[econ5_conserved_2] <- 10
LUC50[econ5_conserved_3] <- 10
LUC50[econ5_conserved_4] <- 10
LUC50[econ5_conserved_5] <- 10
LUC50[econ5_conserved_6] <- 10
writeRaster(LUC50, "R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_econ_strat/land-use-50.tif", 
            datatype='INT2S', overwrite=TRUE)


LUC60 <- raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_econ_strat/land-use-60_OLD.tif",sep=""))
LUC60[econ5_conserved_1] <- 10
LUC60[econ5_conserved_2] <- 10
LUC60[econ5_conserved_3] <- 10
LUC60[econ5_conserved_4] <- 10
LUC60[econ5_conserved_5] <- 10
LUC60[econ5_conserved_6] <- 10
LUC60[econ5_conserved_7] <- 10
writeRaster(LUC60, "R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_econ_strat/land-use-60.tif", 
            datatype='INT2S', overwrite=TRUE)


LUC70 <- raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_econ_strat/land-use-70_OLD.tif",sep=""))
LUC70[econ5_conserved_1] <- 10
LUC70[econ5_conserved_2] <- 10
LUC70[econ5_conserved_3] <- 10
LUC70[econ5_conserved_4] <- 10
LUC70[econ5_conserved_5] <- 10
LUC70[econ5_conserved_6] <- 10
LUC70[econ5_conserved_7] <- 10
LUC70[econ5_conserved_8] <- 10
writeRaster(LUC70, "R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_econ_strat/land-use-70.tif", 
            datatype='INT2S', overwrite=TRUE)


LUC80 <- raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_econ_strat/land-use-80_OLD.tif",sep=""))
LUC80[econ5_conserved_1] <- 10
LUC80[econ5_conserved_2] <- 10
LUC80[econ5_conserved_3] <- 10
LUC80[econ5_conserved_4] <- 10
LUC80[econ5_conserved_5] <- 10
LUC80[econ5_conserved_6] <- 10
LUC80[econ5_conserved_7] <- 10
LUC80[econ5_conserved_8] <- 10
writeRaster(LUC80, "R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_econ_strat/land-use-80.tif", 
            datatype='INT2S', overwrite=TRUE)



######################################################################################
################################# Geodiversity sort ##################################
######################################################################################

#Load in stands w developed stands removed, subtract stands that are already currently managed
geo_zonal <-read.csv("R:/fer/rschell/Mozelewski/Chapter_2_analysis/Geodiv stands for analysis 100.csv")
geo_df <- data.frame(geo_zonal)


library(dplyr)
geo_stand_ns <- unique(geo_zonal$gridcode)
geo_need <- select(geo_df, 5, 7, 9)
geo_need$mean <- NA
geo_need$area <- NA
geo_need <- data.frame(geo_need)
geo_test <- data.frame()

#test for 
testdf <- geo_zonal[geo_zonal$gridcode == 1,]
testdf2 <- geo_zonal[geo_zonal$gridcode == 18966,]

gridcode_vec <- vector()
diversity_vec <- vector()
area_vec<- vector()

ref_vec <- seq(from=1, to=length(geo_stand_ns))

#for loop to combine gridcode entries into one stand, average geodiversity score, and sum area
for (i in ref_vec){
  gridcode_loop <- geo_stand_ns[i]
  print(gridcode_loop)
  loopdf <- geo_df[geo_df$gridcode == gridcode_loop,]
  gridcode_vec[i] <- gridcode_loop
  diversity_vec[i] <- mean(loopdf$gridcode_1)
  area_vec[i] <- sum(loopdf$Shape_Area)
}

merged_df <- cbind(gridcode_vec, diversity_vec, area_vec)
merged_df <- data.frame(merged_df)

#create column for probability data
merged_df$Prob <- NA

write.csv(stands_geo, "R:/fer/rschell/Mozelewski/Chapter_2_analysis/stands_grouped_geo.csv")

# Create probability based on geodiversity score
# Greater than 2 = far above average, 1-2 = above average, 0.5 -1 = slightly above average,
# -0.5 to 0.5 = average, -0.5 to -1 = slightly below average, -1 to -2 = below average, less than -2 = far below average
merged_df$Prob[diversity_vec>3000]<-0.95
merged_df$Prob[diversity_vec<3000 & diversity_vec>=2500]<- 0.925
merged_df$Prob[diversity_vec<2500 & diversity_vec>=2000]<- 0.9
merged_df$Prob[diversity_vec<2000 & diversity_vec>=1500]<- 0.85
merged_df$Prob[diversity_vec<1500 & diversity_vec>=1000]<- 0.825
merged_df$Prob[diversity_vec<1000 & diversity_vec>=500]<- 0.775
merged_df$Prob[diversity_vec<500 & diversity_vec>=0]<- 0.65
merged_df$Prob[diversity_vec<0 & diversity_vec>=-500]<- 0.6
merged_df$Prob[diversity_vec<(-500) & diversity_vec>=-1000]<- 0.3
merged_df$Prob[diversity_vec<(-1000) & diversity_vec>=-1500]<- 0.1
merged_df$Prob[diversity_vec<(-1500) & diversity_vec>=-2000]<- 0.05
merged_df$Prob[diversity_vec<(-2000)]<- 0.001

# remove already protected/managed stands 
stands_geo <- merged_df[merged_df$gridcode %in% stands_base$gridcode,]
stands_geo <- dplyr::arrange(stands_geo, desc(stands_geo$Prob))

# Random weighted sort to randomly pick stands to protect as part of the geodiversity conservation strategy
# Stands with higher geodiversity scores have higher probability weights = higher likelihood of being selected
nsample <- 7496
set.seed(43)
samp_geo <- sample(seq_len(nrow(stands_geo)), nsample, replace = FALSE, prob=stands_geo$Prob)
final_geo_stands <- stands_geo[samp_geo, ]

# find area of each stand in hectares
area_ha <- (final_geo_stands[,3])/10000
reord_stands_geo_ha <- cbind(final_geo_stands, area_ha)

# cumulative sum of area (ha)
reord_stands_geo_ha[,"cum_area_ha"] <- cumsum(reord_stands_geo_ha$area_ha)

write.csv(reord_stands_geo_ha, "R:/fer/rschell/Mozelewski/Chapter_2_analysis/stands_geo100.csv")
reord_stands_geo_ha <- read.csv("R:/fer/rschell/Mozelewski/Chapter_2_analysis/stands_geo100.csv")


#isolate stands for geodiv 1% strategy
just_stands_geo <- reord_stands_geo_ha[,2]
geo_timestep1_1 <- just_stands_geo[1:82]
geo_timestep1_2 <- just_stands_geo[83:180]
geo_timestep1_3 <- just_stands_geo[181:272]
geo_timestep1_4 <- just_stands_geo[273:359]
geo_timestep1_5 <- just_stands_geo[360:457]
geo_timestep1_6 <- just_stands_geo[458:559]
geo_timestep1_7 <- just_stands_geo[560:650]
geo_timestep1_8 <- just_stands_geo[651:730]
geo_timestep1_9 <- just_stands_geo[731:818]
geo_timestep1_10 <- just_stands_geo[819:902]
geo_timestep1_11 <- just_stands_geo[903:988]
geo_timestep1_12 <- just_stands_geo[989:1072]
geo_timestep1_13 <- just_stands_geo[1073:1167]
geo_timestep1_14 <- just_stands_geo[1168:1255]
geo_timestep1_15 <- just_stands_geo[1256:1356]
geo_timestep1_16 <- just_stands_geo[1357:1454]
geo_timestep1_17 <- just_stands_geo[1455:1539]
#geo1_percent_all <- c(geo_timestep1_1, geo_timestep1_2, geo_timestep1_3, geo_timestep1_4, geo_timestep1_5,
                         #geo_timestep1_6, geo_timestep1_7, geo_timestep1_8)                                     

#create shapefile of geodiv selection 1% at each timestep
#standmap_geo_timestep_1_1 <- standmap[standmap$gridcode %in% geo_timestep1_1,]
#standmap_geo_timestep_1_2 <- standmap[standmap$gridcode %in% geo_timestep1_2,]
#standmap_geo_timestep_1_3 <- standmap[standmap$gridcode %in% geo_timestep1_3,]
#standmap_geo_timestep_1_4 <- standmap[standmap$gridcode %in% geo_timestep1_4,]
#standmap_geo_timestep_1_5 <- standmap[standmap$gridcode %in% geo_timestep1_5,]
#standmap_geo_timestep_1_6 <- standmap[standmap$gridcode %in% geo_timestep1_6,]
#standmap_geo_timestep_1_7 <- standmap[standmap$gridcode %in% geo_timestep1_7,]
#standmap_geo_timestep_1_8 <- standmap[standmap$gridcode %in% geo_timestep1_8,]

geo1_conserved_all <- Landis_standmap %in% geo1_percent_all
plot(geo1_conserved_all)

#Create new mgmt map for geodiv 1%

#MgmtMap <- raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_landscape_basic_Sor_1/MgmtMap11.tif",sep=""))
geo1_conserved_1 <- Landis_standmap %in% geo_timestep1_1
geo1_conserved_2 <- Landis_standmap %in% geo_timestep1_2
geo1_conserved_3 <- Landis_standmap %in% geo_timestep1_3
geo1_conserved_4 <- Landis_standmap %in% geo_timestep1_4
geo1_conserved_5 <- Landis_standmap %in% geo_timestep1_5
geo1_conserved_6 <- Landis_standmap %in% geo_timestep1_6
geo1_conserved_7 <- Landis_standmap %in% geo_timestep1_7
geo1_conserved_8 <- Landis_standmap %in% geo_timestep1_8
geo1_conserved_9 <- Landis_standmap %in% geo_timestep1_9
geo1_conserved_10 <- Landis_standmap %in% geo_timestep1_10
geo1_conserved_11 <- Landis_standmap %in% geo_timestep1_11
geo1_conserved_12 <- Landis_standmap %in% geo_timestep1_12
geo1_conserved_13 <- Landis_standmap %in% geo_timestep1_13
geo1_conserved_14 <- Landis_standmap %in% geo_timestep1_14
geo1_conserved_15 <- Landis_standmap %in% geo_timestep1_15
geo1_conserved_16 <- Landis_standmap %in% geo_timestep1_16
geo1_conserved_17 <- Landis_standmap %in% geo_timestep1_17



MgmtMap <- raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NewMaps/MgmtMap100.tif", sep=""))
MgmtMap[geo1_conserved_1] <- 11
MgmtMap[geo1_conserved_2] <- 12
MgmtMap[geo1_conserved_3] <- 13
MgmtMap[geo1_conserved_4] <- 14
MgmtMap[geo1_conserved_5] <- 15
MgmtMap[geo1_conserved_6] <- 16
MgmtMap[geo1_conserved_7] <- 17
MgmtMap[geo1_conserved_8] <- 18
MgmtMap[geo1_conserved_9] <- 19
MgmtMap[geo1_conserved_10] <- 20
MgmtMap[geo1_conserved_11] <- 21
MgmtMap[geo1_conserved_12] <- 22
MgmtMap[geo1_conserved_13] <- 23
MgmtMap[geo1_conserved_14] <- 24
MgmtMap[geo1_conserved_15] <- 25
MgmtMap[geo1_conserved_16] <- 26
MgmtMap[geo1_conserved_17] <- 27

writeRaster(MgmtMap, "R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_test/MgmtMap_geo110.tif", 
            datatype='INT4S', overwrite=TRUE)

#Isolate stands for geodiv 2% strategy
#Didn't want to have to rename all of the '5s' but DID GO BACK and count 2%
#These are NOT ACTUALLY 5% !!!!!!!!!!!!!!!!!!!!!!!!!!!
just_stands_geo <- reord_stands_geo_ha[,1]
geo_timestep5_1 <- just_stands_geo[1:199]
geo_timestep5_2 <- just_stands_geo[200:364]
geo_timestep5_3 <- just_stands_geo[365:557]
geo_timestep5_4 <- just_stands_geo[558:738]
geo_timestep5_5 <- just_stands_geo[739:908]
geo_timestep5_6 <- just_stands_geo[909:1086]
geo_timestep5_7 <- just_stands_geo[1087:1271]
geo_timestep5_8 <- just_stands_geo[1272:1448]
geo5_percent_all <- c(geo_timestep5_1, geo_timestep5_2, geo_timestep5_3, geo_timestep5_4, geo_timestep5_5,
                      geo_timestep5_6, geo_timestep5_7, geo_timestep5_8)                                     

#create shapefile of gediv selection 2% at each timestep
standmap_geo_timestep_5_1 <- standmap[standmap$gridcode %in% geo_timestep5_1,]
standmap_geo_timestep_5_2 <- standmap[standmap$gridcode %in% geo_timestep5_2,]
standmap_geo_timestep_5_3 <- standmap[standmap$gridcode %in% geo_timestep5_3,]
standmap_geo_timestep_5_4 <- standmap[standmap$gridcode %in% geo_timestep5_4,]
standmap_geo_timestep_5_5 <- standmap[standmap$gridcode %in% geo_timestep5_5,]
standmap_geo_timestep_5_6 <- standmap[standmap$gridcode %in% geo_timestep5_6,]
standmap_geo_timestep_5_7 <- standmap[standmap$gridcode %in% geo_timestep5_7,]
standmap_geo_timestep_5_8 <- standmap[standmap$gridcode %in% geo_timestep5_8,]

geo5_conserved_all <- Landis_standmap %in% geo5_percent_all
plot(geo5_conserved_all)

#Create new mgmt map for geodiv 2%
MgmtMap <- raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_landscape_basic_Sor_1/MgmtMap11.tif",sep=""))
geo5_conserved_1 <- Landis_standmap %in% geo_timestep5_1
geo5_conserved_2 <- Landis_standmap %in% geo_timestep5_2
geo5_conserved_3 <- Landis_standmap %in% geo_timestep5_3
geo5_conserved_4 <- Landis_standmap %in% geo_timestep5_4
geo5_conserved_5 <- Landis_standmap %in% geo_timestep5_5
geo5_conserved_6 <- Landis_standmap %in% geo_timestep5_6
geo5_conserved_7 <- Landis_standmap %in% geo_timestep5_7
geo5_conserved_8 <- Landis_standmap %in% geo_timestep5_8

MgmtMap[geo5_conserved_1] <- 11
MgmtMap[geo5_conserved_2] <- 12
MgmtMap[geo5_conserved_3] <- 13
MgmtMap[geo5_conserved_4] <- 14
MgmtMap[geo5_conserved_5] <- 15
MgmtMap[geo5_conserved_6] <- 16
MgmtMap[geo5_conserved_7] <- 17
MgmtMap[geo5_conserved_8] <- 18

writeRaster(MgmtMap, "R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_geo_strat2/MgmtMap_geo2.tif", 
            datatype='INT4S', overwrite=TRUE)

Mgmt_geo2 <- raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_geo_strat2/MgmtMap_geo2.tif"))
plot(Mgmt_geo2)

######### LUC maps subtract newly protected areas at each timestep 1%
LUC0 <- raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_geo_strat/land-use-0_OLD.tif",sep=""))
table(getValues(LUC0))
LUC0[geo1_conserved_1] <- 10
table(getValues(LUC0))
writeRaster(LUC0, "R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_geo_strat/land-use-0.tif", 
            datatype='INT2S', overwrite=TRUE)

LUC10 <- raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_geo_strat/land-use-10_OLD.tif",sep=""))
LUC10[geo1_conserved_1] <- 10
LUC10[geo1_conserved_2] <- 10
writeRaster(LUC10, "R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_geo_strat/land-use-10.tif", 
            datatype='INT2S', overwrite=TRUE)

LUC20 <- raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_geo_strat/land-use-20_OLD.tif",sep=""))
LUC20[geo1_conserved_1] <- 10
LUC20[geo1_conserved_2] <- 10
LUC20[geo1_conserved_3] <- 10
writeRaster(LUC20, "R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_geo_strat/land-use-20.tif", 
            datatype='INT2S', overwrite=TRUE)


LUC30 <- raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_geo_strat/land-use-30_OLD.tif",sep=""))
LUC30[geo1_conserved_1] <- 10
LUC30[geo1_conserved_2] <- 10
LUC30[geo1_conserved_3] <- 10
LUC30[geo1_conserved_4] <- 10
writeRaster(LUC30, "R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_geo_strat/land-use-30.tif", 
            datatype='INT2S', overwrite=TRUE)


LUC40 <- raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_geo_strat/land-use-40_OLD.tif",sep=""))
LUC40[geo1_conserved_1] <- 10
LUC40[geo1_conserved_2] <- 10
LUC40[geo1_conserved_3] <- 10
LUC40[geo1_conserved_4] <- 10
LUC40[geo1_conserved_5] <- 10
writeRaster(LUC40, "R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_geo_strat/land-use-40.tif", 
            datatype='INT2S', overwrite=TRUE)


LUC50 <- raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_geo_strat/land-use-50_OLD.tif",sep=""))
table(getValues(LUC50))
LUC50[geo1_conserved_1] <- 10
LUC50[geo1_conserved_2] <- 10
LUC50[geo1_conserved_3] <- 10
LUC50[geo1_conserved_4] <- 10
LUC50[geo1_conserved_5] <- 10
LUC50[geo1_conserved_6] <- 10
writeRaster(LUC50, "R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_geo_strat/land-use-50.tif", 
            datatype='INT2S', overwrite=TRUE)


LUC60 <- raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_geo_strat/land-use-60_OLD.tif",sep=""))
LUC60[geo1_conserved_1] <- 10
LUC60[geo1_conserved_2] <- 10
LUC60[geo1_conserved_3] <- 10
LUC60[geo1_conserved_4] <- 10
LUC60[geo1_conserved_5] <- 10
LUC60[geo1_conserved_6] <- 10
LUC60[geo1_conserved_7] <- 10
writeRaster(LUC60, "R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_geo_strat/land-use-60.tif", 
            datatype='INT2S', overwrite=TRUE)


LUC70 <- raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_geo_strat/land-use-70_OLD.tif",sep=""))
LUC70[geo1_conserved_1] <- 10
LUC70[geo1_conserved_2] <- 10
LUC70[geo1_conserved_3] <- 10
LUC70[geo1_conserved_4] <- 10
LUC70[geo1_conserved_5] <- 10
LUC70[geo1_conserved_6] <- 10
LUC70[geo1_conserved_7] <- 10
LUC70[geo1_conserved_8] <- 10
writeRaster(LUC70, "R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_geo_strat/land-use-70.tif", 
            datatype='INT2S', overwrite=TRUE)


LUC80 <- raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_geo_strat/land-use-80_OLD.tif",sep=""))
LUC80[geo1_conserved_1] <- 10
LUC80[geo1_conserved_2] <- 10
LUC80[geo1_conserved_3] <- 10
LUC80[geo1_conserved_4] <- 10
LUC80[geo1_conserved_5] <- 10
LUC80[geo1_conserved_6] <- 10
LUC80[geo1_conserved_7] <- 10
LUC80[geo1_conserved_8] <- 10
writeRaster(LUC80, "R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_geo_strat/land-use-80.tif", 
            datatype='INT2S', overwrite=TRUE)


######### LUC maps subtract newly protected areas at each timestep 2%
LUC0 <- raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_geo_strat2/land-use-0_OLD.tif",sep=""))
table(getValues(LUC0))
LUC0[geo5_conserved_1] <- 10
table(getValues(LUC0))
writeRaster(LUC0, "R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_geo_strat2/land-use-0.tif", 
            datatype='INT2S', overwrite=TRUE)

LUC10 <- raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_geo_strat2/land-use-10_OLD.tif",sep=""))
LUC10[geo5_conserved_1] <- 10
LUC10[geo5_conserved_2] <- 10
writeRaster(LUC10, "R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_geo_strat2/land-use-10.tif", 
            datatype='INT2S', overwrite=TRUE)

LUC20 <- raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_geo_strat2/land-use-20_OLD.tif",sep=""))
LUC20[geo5_conserved_1] <- 10
LUC20[geo5_conserved_2] <- 10
LUC20[geo5_conserved_3] <- 10
writeRaster(LUC20, "R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_geo_strat2/land-use-20.tif", 
            datatype='INT2S', overwrite=TRUE)


LUC30 <- raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_geo_strat2/land-use-30_OLD.tif",sep=""))
LUC30[geo5_conserved_1] <- 10
LUC30[geo5_conserved_2] <- 10
LUC30[geo5_conserved_3] <- 10
LUC30[geo5_conserved_4] <- 10
writeRaster(LUC30, "R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_geo_strat2/land-use-30.tif", 
            datatype='INT2S', overwrite=TRUE)


LUC40 <- raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_geo_strat2/land-use-40_OLD.tif",sep=""))
LUC40[geo5_conserved_1] <- 10
LUC40[geo5_conserved_2] <- 10
LUC40[geo5_conserved_3] <- 10
LUC40[geo5_conserved_4] <- 10
LUC40[geo5_conserved_5] <- 10
writeRaster(LUC40, "R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_geo_strat2/land-use-40.tif", 
            datatype='INT2S', overwrite=TRUE)


LUC50 <- raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_geo_strat2/land-use-50_OLD.tif",sep=""))
LUC50[geo5_conserved_1] <- 10
LUC50[geo5_conserved_2] <- 10
LUC50[geo5_conserved_3] <- 10
LUC50[geo5_conserved_4] <- 10
LUC50[geo5_conserved_5] <- 10
LUC50[geo5_conserved_6] <- 10
writeRaster(LUC50, "R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_geo_strat2/land-use-50.tif", 
            datatype='INT2S', overwrite=TRUE)


LUC60 <- raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_geo_strat2/land-use-60_OLD.tif",sep=""))
LUC60[geo5_conserved_1] <- 10
LUC60[geo5_conserved_2] <- 10
LUC60[geo5_conserved_3] <- 10
LUC60[geo5_conserved_4] <- 10
LUC60[geo5_conserved_5] <- 10
LUC60[geo5_conserved_6] <- 10
LUC60[geo5_conserved_7] <- 10
writeRaster(LUC60, "R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_geo_strat2/land-use-60.tif", 
            datatype='INT2S', overwrite=TRUE)


LUC70 <- raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_geo_strat2/land-use-70_OLD.tif",sep=""))
LUC70[geo5_conserved_1] <- 10
LUC70[geo5_conserved_2] <- 10
LUC70[geo5_conserved_3] <- 10
LUC70[geo5_conserved_4] <- 10
LUC70[geo5_conserved_5] <- 10
LUC70[geo5_conserved_6] <- 10
LUC70[geo5_conserved_7] <- 10
LUC70[geo5_conserved_8] <- 10
writeRaster(LUC70, "R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_geo_strat2/land-use-70.tif", 
            datatype='INT2S', overwrite=TRUE)


LUC80 <- raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_geo_strat2/land-use-80_OLD.tif",sep=""))
LUC80[geo5_conserved_1] <- 10
LUC80[geo5_conserved_2] <- 10
LUC80[geo5_conserved_3] <- 10
LUC80[geo5_conserved_4] <- 10
LUC80[geo5_conserved_5] <- 10
LUC80[geo5_conserved_6] <- 10
LUC80[geo5_conserved_7] <- 10
LUC80[geo5_conserved_8] <- 10
writeRaster(LUC80, "R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_geo_strat2/land-use-80.tif", 
            datatype='INT2S', overwrite=TRUE)


######################################################################################
################################## Clustering sort ###################################
######################################################################################

#Load in stands w developed stands removed, subtract stands that are already currently managed
cluster_100 <-read.csv("R:/fer/rschell/Mozelewski/Chapter_2_analysis/Stands_100buf.csv")
cluster_500 <-read.csv("R:/fer/rschell/Mozelewski/Chapter_2_analysis/Stands_500buf.csv")
cluster_1000 <-read.csv("R:/fer/rschell/Mozelewski/Chapter_2_analysis/Stands_1000buf.csv")
cluster_2500 <-read.csv("R:/fer/rschell/Mozelewski/Chapter_2_analysis/Stands_2500buf.csv")
all_stands <- read.csv("R:/fer/rschell/Mozelewski/Chapter_2_analysis/All_stands.csv")
cluster_100$Prob <- 0.9
cluster_500$Prob <- 0.7
cluster_1000$Prob <- 0.5
cluster_2500$Prob <-0.3
all_stands$Prob <- 0.1

cluster_500f <- subset(cluster_500, !(cluster_500$OBJECTID %in% cluster_100$OBJECTID))
cluster_1000f <- subset(cluster_1000, !(cluster_1000$OBJECTID %in% c(cluster_100$OBJECTID, cluster_500f$OBJECTID)))
cluster_2500f <- subset(cluster_2500, !(cluster_2500$OBJECTID %in% c(cluster_100$OBJECTID, cluster_500f$OBJECTID, cluster_1000f$OBJECTID)))
all_standsf <- subset(all_stands, !(all_stands$OBJECTID %in% c(cluster_100$OBJECTID, cluster_500f$OBJECTID, cluster_1000f$OBJECTID, cluster_2500f$OBJECTID)))

####### where i left off: need to figure out how to remove the stands that are in the 100m buffer from the stands listed 
#in the 500, 1000, and 2500m buffers list (so they get max possible probability ranking). Must also do this for all stands
#in buffer, remove from all stands list. THinking I can probably do this by object id?
cluster_comb <- rbind(cluster_100, cluster_500f, cluster_1000f, cluster_2500f)
cluster_need <- select(cluster_comb, 1,4,5,10,11,12)
all_need <- all_stands[all_stands]
cluster_all <- rbind(cluster_need, all_standsf)

library(dplyr)
cluster_stand_ns <- unique(cluster_all$gridcode)
cluster_need <- select(cluster_all, 3, 5, 6)
cluster_need$mean <- NA
cluster_need$area <- NA
cluster_need <- data.frame(cluster_need)
cluster_test <- data.frame()

#test for 
testdf <- cluster_all[cluster_all$gridcode == 1,]

gridcode_vec <- vector()
prob_vec <- vector()
area_vec<- vector()

ref_vec <- seq(from=1, to=length(cluster_stand_ns))

#for loop to combine gridcode entries into one stand, average geodiversity score, and sum area
for (i in ref_vec){
  gridcode_loop <- cluster_stand_ns[i]
  print(gridcode_loop)
  loopdf <- cluster_all[cluster_all$gridcode == gridcode_loop,]
  gridcode_vec[i] <- gridcode_loop
  prob_vec[i] <- mean(loopdf$Prob)
  area_vec[i] <- sum(loopdf$Shape_Area)
}

merged_df <- cbind(gridcode_vec, prob_vec, area_vec)
merged_df <- data.frame(merged_df)


# remove already protected/managed stands 
stands_cluster <- merged_df[merged_df$gridcode %in% stands_base$gridcode,]


# Random weighted sort to randomly pick stands to protect as part of the geodiversity conservation strategy
# Stands with higher geodiversity scores have higher probability weights = higher likelihood of being selected
nsample <- 7496
set.seed(43)
#samp_cluster <- sample(seq_len(nrow(stands_cluster)), nsample, replace = FALSE, prob=stands_cluster$prob_vec)
samp_cluster <- sample(stands_cluster$gridcode_vec, nsample, replace = FALSE, prob=stands_cluster$prob_vec)
#final_cluster_stands <- stands_cluster[samp_cluster, ]
final_cluster_stands <- stands_cluster[stands_cluster$gridcode_vec %in% samp_cluster,]

# find area of each stand in hectares
area_ha <- (final_cluster_stands[,3])/10000
reord_stands_cluster_ha <- cbind(final_cluster_stands, area_ha)

# cumulative sum of area (ha)
reord_stands_cluster_ha[,"cum_area_ha"] <- cumsum(reord_stands_cluster_ha$area_ha)

write.csv(reord_stands_cluster_ha, "R:/fer/rschell/Mozelewski/Chapter_2_analysis/stands_cluster100.csv")
reord_stands_cluster_ha <- read.csv("R:/fer/rschell/Mozelewski/Chapter_2_analysis/stands_cluster100.csv")

#isolate stands for geodiv 1% strategy
just_stands_cluster <- reord_stands_cluster_ha[,1]
cluster_timestep1_1 <- just_stands_cluster[1:91]
cluster_timestep1_2 <- just_stands_cluster[92:151]
cluster_timestep1_3 <- just_stands_cluster[152:275]
cluster_timestep1_4 <- just_stands_cluster[276:395]
cluster_timestep1_5 <- just_stands_cluster[396:508]
cluster_timestep1_6 <- just_stands_cluster[509:580]
cluster_timestep1_7 <- just_stands_cluster[581:645]
cluster_timestep1_8 <- just_stands_cluster[646:727]
cluster_timestep1_9 <- just_stands_cluster[728:799]
cluster_timestep1_10 <- just_stands_cluster[800:868]
cluster_timestep1_11 <- just_stands_cluster[869:945]
cluster_timestep1_12 <- just_stands_cluster[946:1052]
cluster_timestep1_13 <- just_stands_cluster[1053:1159]
cluster_timestep1_14 <- just_stands_cluster[1160:1280]
cluster_timestep1_15 <- just_stands_cluster[1281:1377]
cluster_timestep1_16 <- just_stands_cluster[1378:1487]
cluster_timestep1_17 <- just_stands_cluster[1488:1573]
#geo1_percent_all <- c(geo_timestep1_1, geo_timestep1_2, geo_timestep1_3, geo_timestep1_4, geo_timestep1_5,
#geo_timestep1_6, geo_timestep1_7, geo_timestep1_8)                                     



cluster1_conserved_all <- Landis_standmap %in% cluster1_percent_all
plot(geo1_conserved_all)

#Create new mgmt map for geodiv 1%

#MgmtMap <- raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_landscape_basic_Sor_1/MgmtMap11.tif",sep=""))
cluster1_conserved_1 <- Landis_standmap %in% cluster_timestep1_1
cluster1_conserved_2 <- Landis_standmap %in% cluster_timestep1_2
cluster1_conserved_3 <- Landis_standmap %in% cluster_timestep1_3
cluster1_conserved_4 <- Landis_standmap %in% cluster_timestep1_4
cluster1_conserved_5 <- Landis_standmap %in% cluster_timestep1_5
cluster1_conserved_6 <- Landis_standmap %in% cluster_timestep1_6
cluster1_conserved_7 <- Landis_standmap %in% cluster_timestep1_7
cluster1_conserved_8 <- Landis_standmap %in% cluster_timestep1_8
cluster1_conserved_9 <- Landis_standmap %in% cluster_timestep1_9
cluster1_conserved_10 <- Landis_standmap %in% cluster_timestep1_10
cluster1_conserved_11 <- Landis_standmap %in% cluster_timestep1_11
cluster1_conserved_12 <- Landis_standmap %in% cluster_timestep1_12
cluster1_conserved_13 <- Landis_standmap %in% cluster_timestep1_13
cluster1_conserved_14 <- Landis_standmap %in% cluster_timestep1_14
cluster1_conserved_15 <- Landis_standmap %in% cluster_timestep1_15
cluster1_conserved_16 <- Landis_standmap %in% cluster_timestep1_16
cluster1_conserved_17 <- Landis_standmap %in% cluster_timestep1_17

MgmtMap <- raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NewMaps/MgmtMap100.tif", sep=""))
MgmtMap[cluster1_conserved_1] <- 11
MgmtMap[cluster1_conserved_2] <- 12
MgmtMap[cluster1_conserved_3] <- 13
MgmtMap[cluster1_conserved_4] <- 14
MgmtMap[cluster1_conserved_5] <- 15
MgmtMap[cluster1_conserved_6] <- 16
MgmtMap[cluster1_conserved_7] <- 17
MgmtMap[cluster1_conserved_8] <- 18
MgmtMap[cluster1_conserved_9] <- 19
MgmtMap[cluster1_conserved_10] <- 20
MgmtMap[cluster1_conserved_11] <- 21
MgmtMap[cluster1_conserved_12] <- 22
MgmtMap[cluster1_conserved_13] <- 23
MgmtMap[cluster1_conserved_14] <- 24
MgmtMap[cluster1_conserved_15] <- 25
MgmtMap[cluster1_conserved_16] <- 26
MgmtMap[cluster1_conserved_17] <- 27

writeRaster(MgmtMap, "R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_test/MgmtMap_cluster110.tif", 
            datatype='INT4S', overwrite=TRUE)


######### LUC maps subtract newly protected areas at each timestep 2%
LUC0 <- raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_geo_strat2/land-use-0_OLD.tif",sep=""))
table(getValues(LUC0))
LUC0[geo5_conserved_1] <- 10
table(getValues(LUC0))
writeRaster(LUC0, "R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_geo_strat2/land-use-0.tif", 
            datatype='INT2S', overwrite=TRUE)

LUC10 <- raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_geo_strat2/land-use-10_OLD.tif",sep=""))
LUC10[geo5_conserved_1] <- 10
LUC10[geo5_conserved_2] <- 10
writeRaster(LUC10, "R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_geo_strat2/land-use-10.tif", 
            datatype='INT2S', overwrite=TRUE)

LUC20 <- raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_geo_strat2/land-use-20_OLD.tif",sep=""))
LUC20[geo5_conserved_1] <- 10
LUC20[geo5_conserved_2] <- 10
LUC20[geo5_conserved_3] <- 10
writeRaster(LUC20, "R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_geo_strat2/land-use-20.tif", 
            datatype='INT2S', overwrite=TRUE)


LUC30 <- raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_geo_strat2/land-use-30_OLD.tif",sep=""))
LUC30[geo5_conserved_1] <- 10
LUC30[geo5_conserved_2] <- 10
LUC30[geo5_conserved_3] <- 10
LUC30[geo5_conserved_4] <- 10
writeRaster(LUC30, "R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_geo_strat2/land-use-30.tif", 
            datatype='INT2S', overwrite=TRUE)


LUC40 <- raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_geo_strat2/land-use-40_OLD.tif",sep=""))
LUC40[geo5_conserved_1] <- 10
LUC40[geo5_conserved_2] <- 10
LUC40[geo5_conserved_3] <- 10
LUC40[geo5_conserved_4] <- 10
LUC40[geo5_conserved_5] <- 10
writeRaster(LUC40, "R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_geo_strat2/land-use-40.tif", 
            datatype='INT2S', overwrite=TRUE)


LUC50 <- raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_geo_strat2/land-use-50_OLD.tif",sep=""))
LUC50[geo5_conserved_1] <- 10
LUC50[geo5_conserved_2] <- 10
LUC50[geo5_conserved_3] <- 10
LUC50[geo5_conserved_4] <- 10
LUC50[geo5_conserved_5] <- 10
LUC50[geo5_conserved_6] <- 10
writeRaster(LUC50, "R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_geo_strat2/land-use-50.tif", 
            datatype='INT2S', overwrite=TRUE)


LUC60 <- raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_geo_strat2/land-use-60_OLD.tif",sep=""))
LUC60[geo5_conserved_1] <- 10
LUC60[geo5_conserved_2] <- 10
LUC60[geo5_conserved_3] <- 10
LUC60[geo5_conserved_4] <- 10
LUC60[geo5_conserved_5] <- 10
LUC60[geo5_conserved_6] <- 10
LUC60[geo5_conserved_7] <- 10
writeRaster(LUC60, "R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_geo_strat2/land-use-60.tif", 
            datatype='INT2S', overwrite=TRUE)


LUC70 <- raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_geo_strat2/land-use-70_OLD.tif",sep=""))
LUC70[geo5_conserved_1] <- 10
LUC70[geo5_conserved_2] <- 10
LUC70[geo5_conserved_3] <- 10
LUC70[geo5_conserved_4] <- 10
LUC70[geo5_conserved_5] <- 10
LUC70[geo5_conserved_6] <- 10
LUC70[geo5_conserved_7] <- 10
LUC70[geo5_conserved_8] <- 10
writeRaster(LUC70, "R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_geo_strat2/land-use-70.tif", 
            datatype='INT2S', overwrite=TRUE)


LUC80 <- raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_geo_strat2/land-use-80_OLD.tif",sep=""))
LUC80[geo5_conserved_1] <- 10
LUC80[geo5_conserved_2] <- 10
LUC80[geo5_conserved_3] <- 10
LUC80[geo5_conserved_4] <- 10
LUC80[geo5_conserved_5] <- 10
LUC80[geo5_conserved_6] <- 10
LUC80[geo5_conserved_7] <- 10
LUC80[geo5_conserved_8] <- 10
writeRaster(LUC80, "R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_geo_strat2/land-use-80.tif", 
            datatype='INT2S', overwrite=TRUE)
