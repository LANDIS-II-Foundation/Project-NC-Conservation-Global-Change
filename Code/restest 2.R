#Random strategy 
reord_stands_base_ha <- read.csv("R:/fer/rschell/Mozelewski/Chapter_2_analysis/random_stands_base.csv")

#read in standmap shapefile
standmap <- readOGR("C:/Users/tgmozele/Documents/ArcGIS/Standmap_no99999.shp")

#isolate stands for random 2% strategy (IGNORE THE NUMBER 5 IN THE NAMES BELOW; THIS IS FOR 2%!!!!!!!!!!!!!)
just_stands_rand <- reord_stands_base_ha[,1]
random_timestep5_1 <- just_stands_rand[1:178]
random_timestep5_2 <- just_stands_rand[179:361]
random_timestep5_3 <- just_stands_rand[362:567]
random_timestep5_4 <- just_stands_rand[568:755]
random_timestep5_5 <- just_stands_rand[756:942]
random_timestep5_6 <- just_stands_rand[943:1136]
random_timestep5_7 <- just_stands_rand[1137:1295]
random_timestep5_8 <- just_stands_rand[1296:1509]
random5_percent_all <- c(random_timestep5_1, random_timestep5_2, random_timestep5_3, random_timestep5_4, random_timestep5_5,
                         random_timestep5_6, random_timestep5_7, random_timestep5_8)   

#create shapefile of random selection 5% at each timestep
standmap_timestep_5_1 <- standmap[standmap$gridcode %in% random_timestep5_1,]
standmap_timestep_5_2 <- standmap[standmap$gridcode %in% random_timestep5_2,]
standmap_timestep_5_3 <- standmap[standmap$gridcode %in% random_timestep5_3,]
standmap_timestep_5_4 <- standmap[standmap$gridcode %in% random_timestep5_4,]
standmap_timestep_5_5 <- standmap[standmap$gridcode %in% random_timestep5_5,]
standmap_timestep_5_6 <- standmap[standmap$gridcode %in% random_timestep5_6,]
standmap_timestep_5_7 <- standmap[standmap$gridcode %in% random_timestep5_7,]
standmap_timestep_5_8 <- standmap[standmap$gridcode %in% random_timestep5_8,]

MgmtMap <- raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_landscape_basic_Sor_1/MgmtMap11.tif",sep=""))
random5_conserved_1 <- Landis_standmap %in% random_timestep5_1
random5_conserved_2 <- Landis_standmap %in% random_timestep5_2
random5_conserved_3 <- Landis_standmap %in% random_timestep5_3
random5_conserved_4 <- Landis_standmap %in% random_timestep5_4
random5_conserved_5 <- Landis_standmap %in% random_timestep5_5
random5_conserved_6 <- Landis_standmap %in% random_timestep5_6
random5_conserved_7 <- Landis_standmap %in% random_timestep5_7
random5_conserved_8 <- Landis_standmap %in% random_timestep5_8

Landis_standmap <- raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_landscape_basic_Sor_1/StandMap_r7.tif",sep=""))

#select random stands for 2% in standmap
random5_conserved_all <- Landis_standmap %in% random5_percent_all
plot(random5_conserved_all)

######### LUC maps subtract newly protected areas at each timestep 2%
LUC0 <- raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_random_strat2_LUC/land-use-0_OLD.tif",sep=""))
table(getValues(LUC0))
LUC0[random5_conserved_1] <- 10
table(getValues(LUC0))
writeRaster(LUC0, "R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_random_strat2_LUC/land-use-0.tif", 
            datatype='INT2S', overwrite=TRUE)

LUC10 <- raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_random_strat2_LUC/land-use-10_OLD.tif",sep=""))
LUC10[random5_conserved_1] <- 10
LUC10[random5_conserved_2] <- 10
writeRaster(LUC10, "R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_random_strat2_LUC/land-use-10.tif", 
            datatype='INT2S', overwrite=TRUE)

LUC20 <- raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_random_strat2_LUC/land-use-20_OLD.tif",sep=""))
LUC20[random5_conserved_1] <- 10
LUC20[random5_conserved_2] <- 10
LUC20[random5_conserved_3] <- 10
writeRaster(LUC20, "R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_random_strat2_LUC/land-use-20.tif", 
            datatype='INT2S', overwrite=TRUE)


LUC30 <- raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_random_strat2_LUC/land-use-30_OLD.tif",sep=""))
LUC30[random5_conserved_1] <- 10
LUC30[random5_conserved_2] <- 10
LUC30[random5_conserved_3] <- 10
LUC30[random5_conserved_4] <- 10
writeRaster(LUC30, "R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_random_strat2_LUC/land-use-30.tif", 
            datatype='INT2S', overwrite=TRUE)


LUC40 <- raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_random_strat2_LUC/land-use-40_OLD.tif",sep=""))
LUC40[random5_conserved_1] <- 10
LUC40[random5_conserved_2] <- 10
LUC40[random5_conserved_3] <- 10
LUC40[random5_conserved_4] <- 10
LUC40[random5_conserved_5] <- 10
writeRaster(LUC40, "R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_random_strat2_LUC/land-use-40.tif", 
            datatype='INT2S', overwrite=TRUE)


LUC50 <- raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_random_strat2_LUC/land-use-50_OLD.tif",sep=""))
LUC50[random5_conserved_1] <- 10
LUC50[random5_conserved_2] <- 10
LUC50[random5_conserved_3] <- 10
LUC50[random5_conserved_4] <- 10
LUC50[random5_conserved_5] <- 10
LUC50[random5_conserved_6] <- 10
writeRaster(LUC50, "R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_random_strat2_LUC/land-use-50.tif", 
            datatype='INT2S', overwrite=TRUE)


LUC60 <- raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_random_strat2_LUC/land-use-60_OLD.tif",sep=""))
LUC60[random5_conserved_1] <- 10
LUC60[random5_conserved_2] <- 10
LUC60[random5_conserved_3] <- 10
LUC60[random5_conserved_4] <- 10
LUC60[random5_conserved_5] <- 10
LUC60[random5_conserved_6] <- 10
LUC60[random5_conserved_7] <- 10
writeRaster(LUC60, "R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_random_strat2_LUC/land-use-60.tif", 
            datatype='INT2S', overwrite=TRUE)


LUC70 <- raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_random_strat2_LUC/land-use-70_OLD.tif",sep=""))
LUC70[random5_conserved_1] <- 10
LUC70[random5_conserved_2] <- 10
LUC70[random5_conserved_3] <- 10
LUC70[random5_conserved_4] <- 10
LUC70[random5_conserved_5] <- 10
LUC70[random5_conserved_6] <- 10
LUC70[random5_conserved_7] <- 10
LUC70[random5_conserved_8] <- 10
writeRaster(LUC70, "R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_random_strat2_LUC/land-use-70.tif", 
            datatype='INT2S', overwrite=TRUE)


LUC80 <- raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_random_strat2_LUC/land-use-80_OLD.tif",sep=""))
LUC80[random5_conserved_1] <- 10
LUC80[random5_conserved_2] <- 10
LUC80[random5_conserved_3] <- 10
LUC80[random5_conserved_4] <- 10
LUC80[random5_conserved_5] <- 10
LUC80[random5_conserved_6] <- 10
LUC80[random5_conserved_7] <- 10
LUC80[random5_conserved_8] <- 10
writeRaster(LUC80, "R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_random_strat2_LUC/land-use-80.tif", 
            datatype='INT2S', overwrite=TRUE)


########################## geodiv #######################################
reord_stands_geo_ha <- read.csv("R:/fer/rschell/Mozelewski/Chapter_2_analysis/stands_geo.csv")

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

######### LUC maps subtract newly protected areas at each timestep 2%
LUC0 <- raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_geo_strat2_LUC/land-use-0_OLD.tif",sep=""))
table(getValues(LUC0))
LUC0[geo5_conserved_1] <- 10
table(getValues(LUC0))
writeRaster(LUC0, "R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_geo_strat2_LUC/land-use-0.tif", 
            datatype='INT2S', overwrite=TRUE)

LUC10 <- raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_geo_strat2_LUC/land-use-10_OLD.tif",sep=""))
LUC10[geo5_conserved_1] <- 10
LUC10[geo5_conserved_2] <- 10
writeRaster(LUC10, "R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_geo_strat2_LUC/land-use-10.tif", 
            datatype='INT2S', overwrite=TRUE)

LUC20 <- raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_geo_strat2_LUC/land-use-20_OLD.tif",sep=""))
LUC20[geo5_conserved_1] <- 10
LUC20[geo5_conserved_2] <- 10
LUC20[geo5_conserved_3] <- 10
writeRaster(LUC20, "R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_geo_strat2_LUC/land-use-20.tif", 
            datatype='INT2S', overwrite=TRUE)


LUC30 <- raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_geo_strat2_LUC/land-use-30_OLD.tif",sep=""))
LUC30[geo5_conserved_1] <- 10
LUC30[geo5_conserved_2] <- 10
LUC30[geo5_conserved_3] <- 10
LUC30[geo5_conserved_4] <- 10
writeRaster(LUC30, "R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_geo_strat2_LUC/land-use-30.tif", 
            datatype='INT2S', overwrite=TRUE)


LUC40 <- raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_geo_strat2_LUC/land-use-40_OLD.tif",sep=""))
LUC40[geo5_conserved_1] <- 10
LUC40[geo5_conserved_2] <- 10
LUC40[geo5_conserved_3] <- 10
LUC40[geo5_conserved_4] <- 10
LUC40[geo5_conserved_5] <- 10
writeRaster(LUC40, "R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_geo_strat2_LUC/land-use-40.tif", 
            datatype='INT2S', overwrite=TRUE)


LUC50 <- raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_geo_strat2_LUC/land-use-50_OLD.tif",sep=""))
LUC50[geo5_conserved_1] <- 10
LUC50[geo5_conserved_2] <- 10
LUC50[geo5_conserved_3] <- 10
LUC50[geo5_conserved_4] <- 10
LUC50[geo5_conserved_5] <- 10
LUC50[geo5_conserved_6] <- 10
writeRaster(LUC50, "R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_geo_strat2_LUC/land-use-50.tif", 
            datatype='INT2S', overwrite=TRUE)


LUC60 <- raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_geo_strat2_LUC/land-use-60_OLD.tif",sep=""))
LUC60[geo5_conserved_1] <- 10
LUC60[geo5_conserved_2] <- 10
LUC60[geo5_conserved_3] <- 10
LUC60[geo5_conserved_4] <- 10
LUC60[geo5_conserved_5] <- 10
LUC60[geo5_conserved_6] <- 10
LUC60[geo5_conserved_7] <- 10
writeRaster(LUC60, "R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_geo_strat2_LUC/land-use-60.tif", 
            datatype='INT2S', overwrite=TRUE)


LUC70 <- raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_geo_strat2_LUC/land-use-70_OLD.tif",sep=""))
LUC70[geo5_conserved_1] <- 10
LUC70[geo5_conserved_2] <- 10
LUC70[geo5_conserved_3] <- 10
LUC70[geo5_conserved_4] <- 10
LUC70[geo5_conserved_5] <- 10
LUC70[geo5_conserved_6] <- 10
LUC70[geo5_conserved_7] <- 10
LUC70[geo5_conserved_8] <- 10
writeRaster(LUC70, "R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_geo_strat2_LUC/land-use-70.tif", 
            datatype='INT2S', overwrite=TRUE)


LUC80 <- raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_geo_strat2_LUC/land-use-80_OLD.tif",sep=""))
LUC80[geo5_conserved_1] <- 10
LUC80[geo5_conserved_2] <- 10
LUC80[geo5_conserved_3] <- 10
LUC80[geo5_conserved_4] <- 10
LUC80[geo5_conserved_5] <- 10
LUC80[geo5_conserved_6] <- 10
LUC80[geo5_conserved_7] <- 10
LUC80[geo5_conserved_8] <- 10
writeRaster(LUC80, "R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_geo_strat2_LUC/land-use-80.tif", 
            datatype='INT2S', overwrite=TRUE)

