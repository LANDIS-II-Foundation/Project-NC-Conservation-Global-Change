library(sf)
library(rgdal)
library(tidyselect)
library(plyr)
library(raster)

######################################################################################
#################################### Random sort #####################################
######################################################################################

####################### random stands for conservation ########################

#read in standmap shapefile
reord_stands_base_ha <- read.csv("Z:/Chapter_2_analysis/random_stands_base.csv")

#read in standmap shapefile
Landis_standmap <- raster(paste("Z:/NECN_Tina/NewMaps/Standmap100.tif",sep=""))

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


######################## Ecoregion and mgmt map redo for random strategy ###########################

Ecoregion <- raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_landscape_basic_Sor_1/Ecoregion_5_29.img",sep=""))
MgmtMap <- raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_landscape_basic_Sor_1/MgmtMap11.tif",sep=""))
Landis_standmap <- raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_landscape_basic_Sor_1/StandMap_r7.tif",sep=""))


######### LUC maps subtract newly protected areas at each timestep 1% by assigning them to forest type in LUC maps
#change original map location to NewMaps folder for run or 100 cell size!!!!!!!!!!!!!!!!!!
LUC0 <- raster(paste("R:/fer/rschell/Mozelewski/CONUS_Landcover/CONUS_reproj_B2/CONUS_B2_y2020.tif",sep=""))
table(getValues(LUC0))
LUC0[random1_conserved_1] <- 10
table(getValues(LUC0))
writeRaster(LUC0, "R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_random_strat3/land-use-0.tif", 
            datatype='INT2S', overwrite=TRUE)

LUC10 <- raster(paste("R:/fer/rschell/Mozelewski/CONUS_Landcover/CONUS_reproj_B2/CONUS_B2_y2030.tif",sep=""))
table(getValues(LUC10))
LUC10[random1_conserved_1] <- 10
LUC10[random1_conserved_2] <- 10
table(getValues(LUC10))
writeRaster(LUC10, "R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_random_strat3/land-use-10.tif", 
            datatype='INT2S', overwrite=TRUE)

LUC20 <- raster(paste("R:/fer/rschell/Mozelewski/CONUS_Landcover/CONUS_reproj_B2/CONUS_B2_y2040.tif",sep=""))
LUC20[random1_conserved_1] <- 10
LUC20[random1_conserved_2] <- 10
LUC20[random1_conserved_3] <- 10
writeRaster(LUC20, "R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_random_strat4/land-use-20.tif", 
            datatype='INT2S', overwrite=TRUE)


LUC30 <- raster(paste("R:/fer/rschell/Mozelewski/CONUS_Landcover/CONUS_reproj_B2/CONUS_B2_y2050.tif",sep=""))
LUC30[random1_conserved_1] <- 10
LUC30[random1_conserved_2] <- 10
LUC30[random1_conserved_3] <- 10
LUC30[random1_conserved_4] <- 10
writeRaster(LUC30, "R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_random_strat4/land-use-30.tif", 
            datatype='INT2S', overwrite=TRUE)


LUC40 <- raster(paste("R:/fer/rschell/Mozelewski/CONUS_Landcover/CONUS_reproj_B2/CONUS_B2_y2060.tif",sep=""))
LUC40[random1_conserved_1] <- 10
LUC40[random1_conserved_2] <- 10
LUC40[random1_conserved_3] <- 10
LUC40[random1_conserved_4] <- 10
LUC40[random1_conserved_5] <- 10
writeRaster(LUC40, "R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_random_strat4/land-use-40.tif", 
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
writeRaster(LUC50, "R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_random_strat4/land-use-50.tif", 
            datatype='INT2S', overwrite=TRUE)


LUC60 <- raster(paste("R:/fer/rschell/Mozelewski/CONUS_Landcover/CONUS_reproj_B2/CONUS_B2_y2080.tif",sep=""))
LUC60[random1_conserved_1] <- 10
LUC60[random1_conserved_2] <- 10
LUC60[random1_conserved_3] <- 10
LUC60[random1_conserved_4] <- 10
LUC60[random1_conserved_5] <- 10
LUC60[random1_conserved_6] <- 10
LUC60[random1_conserved_7] <- 10
writeRaster(LUC60, "R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_random_strat4/land-use-60.tif", 
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
writeRaster(LUC70, "R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_random_strat4/land-use-70.tif", 
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
writeRaster(LUC80, "R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_random_strat3/land-use-80.tif", 
            datatype='INT2S', overwrite=TRUE)



##############################################################################
##########################  geodiversity #####################################
##############################################################################

reord_stands_geo_ha <- read.csv("Z:/Chapter_2_analysis/stands_geo.csv")


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

######### LUC maps RCP45
LUC0 <- raster(paste("Z:/ICLUS_v2_1_1_land_use_conus_ssp2_rcp45_giss_e2_r/land-use-0.tif",sep=""))
table(getValues(LUC0))
LUC0[geo1_conserved_1] <- 3
table(getValues(LUC0))
writeRaster(LUC0, "Z:/CC_LUC_connectivity/geo_strat_RCP45/land-use-0.tif", 
            datatype='INT2S', overwrite=TRUE)

LUC10 <- raster(paste("Z:/ICLUS_v2_1_1_land_use_conus_ssp2_rcp45_giss_e2_r/land-use-10.tif",sep=""))
table(getValues(LUC10))
LUC10[geo1_conserved_1] <- 3
LUC10[geo1_conserved_2] <- 3
table(getValues(LUC10))
writeRaster(LUC10, "Z:/CC_LUC_connectivity/geo_strat_RCP45/land-use-10.tif", 
            datatype='INT2S', overwrite=TRUE)

LUC20 <- raster(paste("Z:/ICLUS_v2_1_1_land_use_conus_ssp2_rcp45_giss_e2_r/land-use-20.tif",sep=""))
LUC20[geo1_conserved_1] <- 3
LUC20[geo1_conserved_2] <- 3
LUC20[geo1_conserved_3] <- 3
writeRaster(LUC20, "Z:/CC_LUC_connectivity/geo_strat_RCP45/land-use-20.tif", 
            datatype='INT2S', overwrite=TRUE)


LUC30 <- raster(paste("Z:/ICLUS_v2_1_1_land_use_conus_ssp2_rcp45_giss_e2_r/land-use-30.tif",sep=""))
LUC30[geo1_conserved_1] <- 3
LUC30[geo1_conserved_2] <- 3
LUC30[geo1_conserved_3] <- 3
LUC30[geo1_conserved_4] <- 3
writeRaster(LUC30, "Z:/CC_LUC_connectivity/geo_strat_RCP45/land-use-30.tif", 
            datatype='INT2S', overwrite=TRUE)


LUC40 <- raster(paste("Z:/ICLUS_v2_1_1_land_use_conus_ssp2_rcp45_giss_e2_r/land-use-40.tif",sep=""))
LUC40[geo1_conserved_1] <- 3
LUC40[geo1_conserved_2] <- 3
LUC40[geo1_conserved_3] <- 3
LUC40[geo1_conserved_4] <- 3
LUC40[geo1_conserved_5] <- 3
writeRaster(LUC40, "Z:/CC_LUC_connectivity/geo_strat_RCP45/land-use-40.tif", 
            datatype='INT2S', overwrite=TRUE)


LUC50 <- raster(paste("Z:/ICLUS_v2_1_1_land_use_conus_ssp2_rcp45_giss_e2_r/land-use-50.tif",sep=""))
table(getValues(LUC50))
LUC50[geo1_conserved_1] <- 3
LUC50[geo1_conserved_2] <- 3
LUC50[geo1_conserved_3] <- 3
LUC50[geo1_conserved_4] <- 3
LUC50[geo1_conserved_5] <- 3
LUC50[geo1_conserved_6] <- 3
table(getValues(LUC50))
writeRaster(LUC50, "Z:/CC_LUC_connectivity/geo_strat_RCP45/land-use-50.tif", 
            datatype='INT2S', overwrite=TRUE)


LUC60 <- raster(paste("Z:/ICLUS_v2_1_1_land_use_conus_ssp2_rcp45_giss_e2_r/land-use-60.tif",sep=""))
LUC60[geo1_conserved_1] <- 3
LUC60[geo1_conserved_2] <- 3
LUC60[geo1_conserved_3] <- 3
LUC60[geo1_conserved_4] <- 3
LUC60[geo1_conserved_5] <- 3
LUC60[geo1_conserved_6] <- 3
LUC60[geo1_conserved_7] <- 3
writeRaster(LUC60, "Z:/CC_LUC_connectivity/geo_strat_RCP45/land-use-60.tif", 
            datatype='INT2S', overwrite=TRUE)


LUC70 <- raster(paste("Z:/ICLUS_v2_1_1_land_use_conus_ssp2_rcp45_giss_e2_r/land-use-70.tif",sep=""))
LUC70[geo1_conserved_1] <- 3
LUC70[geo1_conserved_2] <- 3
LUC70[geo1_conserved_3] <- 3
LUC70[geo1_conserved_4] <- 3
LUC70[geo1_conserved_5] <- 3
LUC70[geo1_conserved_6] <- 3
LUC70[geo1_conserved_7] <- 3
LUC70[geo1_conserved_8] <- 3
writeRaster(LUC70, "Z:/CC_LUC_connectivity/geo_strat_RCP45/land-use-70.tif", 
            datatype='INT2S', overwrite=TRUE)


LUC80 <- raster(paste("Z:/ICLUS_v2_1_1_land_use_conus_ssp2_rcp45_giss_e2_r/land-use-80.tif",sep=""))
table(getValues(LUC80))
LUC80[geo1_conserved_1] <- 3
LUC80[geo1_conserved_2] <- 3
LUC80[geo1_conserved_3] <- 3
LUC80[geo1_conserved_4] <- 3
LUC80[geo1_conserved_5] <- 3
LUC80[geo1_conserved_6] <- 3
LUC80[geo1_conserved_7] <- 3
LUC80[geo1_conserved_8] <- 3
table(getValues(LUC80))
writeRaster(LUC80, "Z:/CC_LUC_connectivity/geo_strat_RCP45/land-use-80.tif", 
            datatype='INT2S', overwrite=TRUE)


######### LUC maps RCP85
LUC0 <- raster(paste("Z:/ICLUS_v2_1_1_land_use_conus_ssp5_rcp85_giss_e2_r/land-use-0.tif",sep=""))
table(getValues(LUC0))
LUC0[geo1_conserved_1] <- 3
table(getValues(LUC0))
writeRaster(LUC0, "Z:/CC_LUC_connectivity/geo_strat_rcp85/land-use-0.tif", 
            datatype='INT2S', overwrite=TRUE)

LUC10 <- raster(paste("Z:/ICLUS_v2_1_1_land_use_conus_ssp5_rcp85_giss_e2_r/land-use-10.tif",sep=""))
table(getValues(LUC10))
LUC10[geo1_conserved_1] <- 3
LUC10[geo1_conserved_2] <- 3
table(getValues(LUC10))
writeRaster(LUC10, "Z:/CC_LUC_connectivity/geo_strat_rcp85/land-use-10.tif", 
            datatype='INT2S', overwrite=TRUE)

LUC20 <- raster(paste("Z:/ICLUS_v2_1_1_land_use_conus_ssp5_rcp85_giss_e2_r/land-use-20.tif",sep=""))
LUC20[geo1_conserved_1] <- 3
LUC20[geo1_conserved_2] <- 3
LUC20[geo1_conserved_3] <- 3
writeRaster(LUC20, "Z:/CC_LUC_connectivity/geo_strat_rcp85/land-use-20.tif", 
            datatype='INT2S', overwrite=TRUE)


LUC30 <- raster(paste("Z:/ICLUS_v2_1_1_land_use_conus_ssp5_rcp85_giss_e2_r/land-use-30.tif",sep=""))
LUC30[geo1_conserved_1] <- 3
LUC30[geo1_conserved_2] <- 3
LUC30[geo1_conserved_3] <- 3
LUC30[geo1_conserved_4] <- 3
writeRaster(LUC30, "Z:/CC_LUC_connectivity/geo_strat_rcp85/land-use-30.tif", 
            datatype='INT2S', overwrite=TRUE)


LUC40 <- raster(paste("Z:/ICLUS_v2_1_1_land_use_conus_ssp5_rcp85_giss_e2_r/land-use-40.tif",sep=""))
LUC40[geo1_conserved_1] <- 3
LUC40[geo1_conserved_2] <- 3
LUC40[geo1_conserved_3] <- 3
LUC40[geo1_conserved_4] <- 3
LUC40[geo1_conserved_5] <- 3
writeRaster(LUC40, "Z:/CC_LUC_connectivity/geo_strat_rcp85/land-use-40.tif", 
            datatype='INT2S', overwrite=TRUE)


LUC50 <- raster(paste("Z:/ICLUS_v2_1_1_land_use_conus_ssp5_rcp85_giss_e2_r/land-use-50.tif",sep=""))
table(getValues(LUC50))
LUC50[geo1_conserved_1] <- 3
LUC50[geo1_conserved_2] <- 3
LUC50[geo1_conserved_3] <- 3
LUC50[geo1_conserved_4] <- 3
LUC50[geo1_conserved_5] <- 3
LUC50[geo1_conserved_6] <- 3
table(getValues(LUC50))
writeRaster(LUC50, "Z:/CC_LUC_connectivity/geo_strat_rcp85/land-use-50.tif", 
            datatype='INT2S', overwrite=TRUE)


LUC60 <- raster(paste("Z:/ICLUS_v2_1_1_land_use_conus_ssp5_rcp85_giss_e2_r/land-use-60.tif",sep=""))
LUC60[geo1_conserved_1] <- 3
LUC60[geo1_conserved_2] <- 3
LUC60[geo1_conserved_3] <- 3
LUC60[geo1_conserved_4] <- 3
LUC60[geo1_conserved_5] <- 3
LUC60[geo1_conserved_6] <- 3
LUC60[geo1_conserved_7] <- 3
writeRaster(LUC60, "Z:/CC_LUC_connectivity/geo_strat_rcp85/land-use-60.tif", 
            datatype='INT2S', overwrite=TRUE)


LUC70 <- raster(paste("Z:/ICLUS_v2_1_1_land_use_conus_ssp5_rcp85_giss_e2_r/land-use-70.tif",sep=""))
LUC70[geo1_conserved_1] <- 3
LUC70[geo1_conserved_2] <- 3
LUC70[geo1_conserved_3] <- 3
LUC70[geo1_conserved_4] <- 3
LUC70[geo1_conserved_5] <- 3
LUC70[geo1_conserved_6] <- 3
LUC70[geo1_conserved_7] <- 3
LUC70[geo1_conserved_8] <- 3
writeRaster(LUC70, "Z:/CC_LUC_connectivity/geo_strat_rcp85/land-use-70.tif", 
            datatype='INT2S', overwrite=TRUE)


LUC80 <- raster(paste("Z:/ICLUS_v2_1_1_land_use_conus_ssp5_rcp85_giss_e2_r/land-use-80.tif",sep=""))
table(getValues(LUC80))
LUC80[geo1_conserved_1] <- 3
LUC80[geo1_conserved_2] <- 3
LUC80[geo1_conserved_3] <- 3
LUC80[geo1_conserved_4] <- 3
LUC80[geo1_conserved_5] <- 3
LUC80[geo1_conserved_6] <- 3
LUC80[geo1_conserved_7] <- 3
LUC80[geo1_conserved_8] <- 3
table(getValues(LUC80))
writeRaster(LUC80, "Z:/CC_LUC_connectivity/geo_strat_rcp85/land-use-80.tif", 
            datatype='INT2S', overwrite=TRUE)

#################################################################
##########################cluster################################
#################################################################

reord_stands_cluster_ha <- read.csv("Z:/Chapter_2_analysis/stands_cluster100.csv")

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

######### LUC maps RCP45
LUC0 <- raster(paste("Z:/ICLUS_v2_1_1_land_use_conus_ssp2_rcp45_giss_e2_r/land-use-0.tif",sep=""))
table(getValues(LUC0))
LUC0[cluster1_conserved_1] <- 3
table(getValues(LUC0))
writeRaster(LUC0, "Z:/CC_LUC_connectivity/cluster_strat_RCP45/land-use-0.tif", 
            datatype='INT2S', overwrite=TRUE)

LUC10 <- raster(paste("Z:/ICLUS_v2_1_1_land_use_conus_ssp2_rcp45_giss_e2_r/land-use-10.tif",sep=""))
table(getValues(LUC10))
LUC10[cluster1_conserved_1] <- 3
LUC10[cluster1_conserved_2] <- 3
table(getValues(LUC10))
writeRaster(LUC10, "Z:/CC_LUC_connectivity/cluster_strat_RCP45/land-use-10.tif", 
            datatype='INT2S', overwrite=TRUE)

LUC20 <- raster(paste("Z:/ICLUS_v2_1_1_land_use_conus_ssp2_rcp45_giss_e2_r/land-use-20.tif",sep=""))
LUC20[cluster1_conserved_1] <- 3
LUC20[cluster1_conserved_2] <- 3
LUC20[cluster1_conserved_3] <- 3
writeRaster(LUC20, "Z:/CC_LUC_connectivity/cluster_strat_RCP45/land-use-20.tif", 
            datatype='INT2S', overwrite=TRUE)


LUC30 <- raster(paste("Z:/ICLUS_v2_1_1_land_use_conus_ssp2_rcp45_giss_e2_r/land-use-30.tif",sep=""))
LUC30[cluster1_conserved_1] <- 3
LUC30[cluster1_conserved_2] <- 3
LUC30[cluster1_conserved_3] <- 3
LUC30[cluster1_conserved_4] <- 3
writeRaster(LUC30, "Z:/CC_LUC_connectivity/cluster_strat_RCP45/land-use-30.tif", 
            datatype='INT2S', overwrite=TRUE)


LUC40 <- raster(paste("Z:/ICLUS_v2_1_1_land_use_conus_ssp2_rcp45_giss_e2_r/land-use-40.tif",sep=""))
LUC40[cluster1_conserved_1] <- 3
LUC40[cluster1_conserved_2] <- 3
LUC40[cluster1_conserved_3] <- 3
LUC40[cluster1_conserved_4] <- 3
LUC40[cluster1_conserved_5] <- 3
writeRaster(LUC40, "Z:/CC_LUC_connectivity/cluster_strat_RCP45/land-use-40.tif", 
            datatype='INT2S', overwrite=TRUE)


LUC50 <- raster(paste("Z:/ICLUS_v2_1_1_land_use_conus_ssp2_rcp45_giss_e2_r/land-use-50.tif",sep=""))
table(getValues(LUC50))
LUC50[cluster1_conserved_1] <- 3
LUC50[cluster1_conserved_2] <- 3
LUC50[cluster1_conserved_3] <- 3
LUC50[cluster1_conserved_4] <- 3
LUC50[cluster1_conserved_5] <- 3
LUC50[cluster1_conserved_6] <- 3
table(getValues(LUC50))
writeRaster(LUC50, "Z:/CC_LUC_connectivity/cluster_strat_RCP45/land-use-50.tif", 
            datatype='INT2S', overwrite=TRUE)


LUC60 <- raster(paste("Z:/ICLUS_v2_1_1_land_use_conus_ssp2_rcp45_giss_e2_r/land-use-60.tif",sep=""))
LUC60[cluster1_conserved_1] <- 3
LUC60[cluster1_conserved_2] <- 3
LUC60[cluster1_conserved_3] <- 3
LUC60[cluster1_conserved_4] <- 3
LUC60[cluster1_conserved_5] <- 3
LUC60[cluster1_conserved_6] <- 3
LUC60[cluster1_conserved_7] <- 3
writeRaster(LUC60, "Z:/CC_LUC_connectivity/cluster_strat_RCP45/land-use-60.tif", 
            datatype='INT2S', overwrite=TRUE)


LUC70 <- raster(paste("Z:/ICLUS_v2_1_1_land_use_conus_ssp2_rcp45_giss_e2_r/land-use-70.tif",sep=""))
LUC70[cluster1_conserved_1] <- 3
LUC70[cluster1_conserved_2] <- 3
LUC70[cluster1_conserved_3] <- 3
LUC70[cluster1_conserved_4] <- 3
LUC70[cluster1_conserved_5] <- 3
LUC70[cluster1_conserved_6] <- 3
LUC70[cluster1_conserved_7] <- 3
LUC70[cluster1_conserved_8] <- 3
writeRaster(LUC70, "Z:/CC_LUC_connectivity/cluster_strat_RCP45/land-use-70.tif", 
            datatype='INT2S', overwrite=TRUE)


LUC80 <- raster(paste("Z:/ICLUS_v2_1_1_land_use_conus_ssp2_rcp45_giss_e2_r/land-use-80.tif",sep=""))
table(getValues(LUC80))
LUC80[cluster1_conserved_1] <- 3
LUC80[cluster1_conserved_2] <- 3
LUC80[cluster1_conserved_3] <- 3
LUC80[cluster1_conserved_4] <- 3
LUC80[cluster1_conserved_5] <- 3
LUC80[cluster1_conserved_6] <- 3
LUC80[cluster1_conserved_7] <- 3
LUC80[cluster1_conserved_8] <- 3
table(getValues(LUC80))
writeRaster(LUC80, "Z:/CC_LUC_connectivity/cluster_strat_RCP45/land-use-80.tif", 
            datatype='INT2S', overwrite=TRUE)


######### LUC maps RCP85
LUC0 <- raster(paste("Z:/ICLUS_v2_1_1_land_use_conus_ssp5_rcp85_giss_e2_r/land-use-0.tif",sep=""))
table(getValues(LUC0))
LUC0[cluster1_conserved_1] <- 3
table(getValues(LUC0))
writeRaster(LUC0, "Z:/CC_LUC_connectivity/cluster_strat_rcp85/land-use-0.tif", 
            datatype='INT2S', overwrite=TRUE)

LUC10 <- raster(paste("Z:/ICLUS_v2_1_1_land_use_conus_ssp5_rcp85_giss_e2_r/land-use-10.tif",sep=""))
table(getValues(LUC10))
LUC10[cluster1_conserved_1] <- 3
LUC10[cluster1_conserved_2] <- 3
table(getValues(LUC10))
writeRaster(LUC10, "Z:/CC_LUC_connectivity/cluster_strat_rcp85/land-use-10.tif", 
            datatype='INT2S', overwrite=TRUE)

LUC20 <- raster(paste("Z:/ICLUS_v2_1_1_land_use_conus_ssp5_rcp85_giss_e2_r/land-use-20.tif",sep=""))
LUC20[cluster1_conserved_1] <- 3
LUC20[cluster1_conserved_2] <- 3
LUC20[cluster1_conserved_3] <- 3
writeRaster(LUC20, "Z:/CC_LUC_connectivity/cluster_strat_rcp85/land-use-20.tif", 
            datatype='INT2S', overwrite=TRUE)


LUC30 <- raster(paste("Z:/ICLUS_v2_1_1_land_use_conus_ssp5_rcp85_giss_e2_r/land-use-30.tif",sep=""))
LUC30[cluster1_conserved_1] <- 3
LUC30[cluster1_conserved_2] <- 3
LUC30[cluster1_conserved_3] <- 3
LUC30[cluster1_conserved_4] <- 3
writeRaster(LUC30, "Z:/CC_LUC_connectivity/cluster_strat_rcp85/land-use-30.tif", 
            datatype='INT2S', overwrite=TRUE)


LUC40 <- raster(paste("Z:/ICLUS_v2_1_1_land_use_conus_ssp5_rcp85_giss_e2_r/land-use-40.tif",sep=""))
LUC40[cluster1_conserved_1] <- 3
LUC40[cluster1_conserved_2] <- 3
LUC40[cluster1_conserved_3] <- 3
LUC40[cluster1_conserved_4] <- 3
LUC40[cluster1_conserved_5] <- 3
writeRaster(LUC40, "Z:/CC_LUC_connectivity/cluster_strat_rcp85/land-use-40.tif", 
            datatype='INT2S', overwrite=TRUE)


LUC50 <- raster(paste("Z:/ICLUS_v2_1_1_land_use_conus_ssp5_rcp85_giss_e2_r/land-use-50.tif",sep=""))
table(getValues(LUC50))
LUC50[cluster1_conserved_1] <- 3
LUC50[cluster1_conserved_2] <- 3
LUC50[cluster1_conserved_3] <- 3
LUC50[cluster1_conserved_4] <- 3
LUC50[cluster1_conserved_5] <- 3
LUC50[cluster1_conserved_6] <- 3
table(getValues(LUC50))
writeRaster(LUC50, "Z:/CC_LUC_connectivity/cluster_strat_rcp85/land-use-50.tif", 
            datatype='INT2S', overwrite=TRUE)


LUC60 <- raster(paste("Z:/ICLUS_v2_1_1_land_use_conus_ssp5_rcp85_giss_e2_r/land-use-60.tif",sep=""))
LUC60[cluster1_conserved_1] <- 3
LUC60[cluster1_conserved_2] <- 3
LUC60[cluster1_conserved_3] <- 3
LUC60[cluster1_conserved_4] <- 3
LUC60[cluster1_conserved_5] <- 3
LUC60[cluster1_conserved_6] <- 3
LUC60[cluster1_conserved_7] <- 3
writeRaster(LUC60, "Z:/CC_LUC_connectivity/cluster_strat_rcp85/land-use-60.tif", 
            datatype='INT2S', overwrite=TRUE)


LUC70 <- raster(paste("Z:/ICLUS_v2_1_1_land_use_conus_ssp5_rcp85_giss_e2_r/land-use-70.tif",sep=""))
LUC70[cluster1_conserved_1] <- 3
LUC70[cluster1_conserved_2] <- 3
LUC70[cluster1_conserved_3] <- 3
LUC70[cluster1_conserved_4] <- 3
LUC70[cluster1_conserved_5] <- 3
LUC70[cluster1_conserved_6] <- 3
LUC70[cluster1_conserved_7] <- 3
LUC70[cluster1_conserved_8] <- 3
writeRaster(LUC70, "Z:/CC_LUC_connectivity/cluster_strat_rcp85/land-use-70.tif", 
            datatype='INT2S', overwrite=TRUE)


LUC80 <- raster(paste("Z:/ICLUS_v2_1_1_land_use_conus_ssp5_rcp85_giss_e2_r/land-use-80.tif",sep=""))
table(getValues(LUC80))
LUC80[cluster1_conserved_1] <- 3
LUC80[cluster1_conserved_2] <- 3
LUC80[cluster1_conserved_3] <- 3
LUC80[cluster1_conserved_4] <- 3
LUC80[cluster1_conserved_5] <- 3
LUC80[cluster1_conserved_6] <- 3
LUC80[cluster1_conserved_7] <- 3
LUC80[cluster1_conserved_8] <- 3
table(getValues(LUC80))
writeRaster(LUC80, "Z:/CC_LUC_connectivity/cluster_strat_rcp85/land-use-80.tif", 
            datatype='INT2S', overwrite=TRUE)

