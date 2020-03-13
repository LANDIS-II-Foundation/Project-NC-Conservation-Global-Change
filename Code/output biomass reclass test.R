Mgmtmap100 <- raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_test/R1Mgmtmap100.tif"))
plot(Mgmtmap100, zlim=c(0,8))


biore80sorLUC <- raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_landscape_basic_Sor_1_LUC/output/bio-reclass1-80.img",sep=""))
biore30sorLUC <- raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_landscape_basic_Sor_1_LUC/output/bio-reclass1-30.img",sep=""))
table(getValues(biore80sorLUC))

biore10sorLUC <- raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_landscape_basic_Sor_1_LUC/output/bio-reclass1-10.img",sep=""))
table(getValues(biore10sorLUC))
plot(biore10sorLUC, zlim=c(3.5,5))

Eco100f <- raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_test/Ecoregion100f.tif",sep=""))
Eco_old <- raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_landscape_basic_Sor_1_LUC/Ecoregion_5_29.img",sep=""))

LU80sorLUC <- raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_landscape_basic_Sor_1_LUC/land-use-80.tif",sep=""))

biore80geoLUC <- raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_geo_strat2_LUC/output/bio-reclass1-80.img",sep=""))
table(getValues(biore80geoLUC))          
