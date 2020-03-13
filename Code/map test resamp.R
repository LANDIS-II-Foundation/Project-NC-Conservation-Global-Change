library(raster)

#Ecoregion <- raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_landscape_basic_Sor_1/ECO_outNEW.tif",sep=""))
Ecoregion <- raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_random_strat/ECO_outNEW.tif",sep=""))
crs(Ecoregion)
plot(Ecoregion)
crst<- "+proj=utm +zone=17 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs"
Ecoregion100 <- resample(Ecoregion, claynew, method = "ngb")
plot(Ecoregion100)
#here creating new ecoregion that makes areas with field capacity of zero inactive in the ecoregion map
Ecoregion100[field_proj <1] <- 1
writeRaster(Ecoregion100, "R:/fer/rschell/Mozelewski/NECN_Tina/NewMaps/Ecoregion100f.tif", 
            datatype='INT4S', overwrite=TRUE)


sandnew <- raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/Sandnew1.tif",sep=""))
plot(sandnew)
sand_proj<-projectRaster(sandnew,res=100, crs=crst)
#sand_cut<-raster::crop(sand_proj,extent(Storm))
plot(sand_proj)
sandnew <- sand_proj/100
#cellStats(sandnew, stat='mean', na.rm=TRUE) #mean was 0.408
sandnew[is.na(sandnew[])] <- -9999
sandnew[Ecoregion100 == 2 & sandnew == -9999] <-0.408
hist(sandnew)
writeRaster(sandnew, "R:/fer/rschell/Mozelewski/NECN_Tina/NewMaps/sand100.tif", 
            datatype='FLT4S', overwrite=TRUE)

claynew <- raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/Claynew1.tif",sep=""))
plot(claynew)
clay_proj<-projectRaster(claynew,res=100, crs=crst)
claynew <- clay_proj/100
#cellStats(claynew, stat='mean', na.rm=TRUE) #mean was 0.274
claynew[is.na(claynew[])] <- -9999
claynew[Ecoregion100 == 2 & claynew == -9999] <-0.274
plot(claynew)
hist(claynew)
#extent(claynew)<-raster::extent(Ecoregion)
writeRaster(claynew, "R:/fer/rschell/Mozelewski/NECN_Tina/NewMaps/clay100.tif", 
            datatype='FLT4S', overwrite=TRUE)

fieldnew <- raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/fieldnew1.tif",sep=""))
plot(fieldnew)
field_proj<-projectRaster(fieldnew,res=100, crs=crst)
field_proj[field_proj < 1] <- 46 #tried doing this to assign mean value to 0-value cells
plot(field_proj)
fieldnew <- field_proj/100
plot(fieldnew)
#cellStats(fieldnew, stat='mean', na.rm=TRUE) #mean was 0.467
fieldnew <- fieldnew * 1.9
plot(fieldnew)
fieldnew[is.na(fieldnew[])] <- -9999 
fieldnew[Ecoregion100 == 2 & fieldnew == -9999,] <-0.467
#as.data.frame(fieldnew[Ecoregion100 == 2 & fieldnew<=0,])
#plot()
#fieldnew[Ecoregion100 == 2 & fieldnew == -9999,]<-10000
#cellFromRowCol(fieldnew,263,1362)
plot(fieldnew)
#fieldnew[cellFromRowCol(fieldnew,1362,1362)]
#plot(fieldnew,zlim=c(0,1))
#Testing<-fieldnew-Ecoregion100
#plot(Testing,zlim=c(-1,5))
#plot(fieldnew,zlim=c(0,.1))
#min(as.data.frame(fieldnew[fieldnew!=-9999]))
writeRaster(fieldnew, "R:/fer/rschell/Mozelewski/NECN_Tina/NewMaps/field100.tif", 
            datatype='FLT4S', overwrite=TRUE)


depthnew <- raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/depthnew1.tif",sep=""))
plot(depthnew)
depthnew<-projectRaster(depthnew,res=100, crs=crst)
depthnew[depthnew == 255] <- -9999 #255 is the value assigned for n/a soil depth in the original depth map
depthnew[depthnew < 1] <- 165 #had issue with small number of cells that were zero or juuuuuuust above zero. Reset those to mean value.
hist(depthnew)
#depthnew[is.na(depthnew[])] <- -9999
depthnew[Ecoregion100 == 2 & depthnew == -9999] <-165
#cellStats(depthnew, stat='mean', na.rm=TRUE) #mean = 165
writeRaster(depthnew, "R:/fer/rschell/Mozelewski/NECN_Tina/NewMaps/depth100.tif", 
            datatype='FLT4S', overwrite=TRUE)

wiltnew <- raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/wiltnew1.tif",sep=""))
plot(wiltnew)
wilt_proj<-projectRaster(wiltnew,res=100, crs=crst)
wiltnew <- wilt_proj/100
wiltnew <- wiltnew * 1.9
wiltnew[wiltnew > fieldnew] <- (fieldnew[fieldnew <= wiltnew]) - 0.05
wiltnew[wiltnew <=0] <- 0.01
#cellStats(wiltnew, stat='mean', na.rm=TRUE) #mean value is 0.285
wiltnew[is.na(wiltnew[])] <- -9999
wiltnew[Ecoregion100 == 2 & wiltnew == -9999] <-0.285
writeRaster(wiltnew, "R:/fer/rschell/Mozelewski/NECN_Tina/NewMaps/wilt100.tif", 
            datatype='FLT4S', overwrite=TRUE)

drainnew <- raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/drainnew1.tif",sep=""))
plot(drainnew)
drainnew<-projectRaster(drainnew,res=100, crs=crst)
drainnew[drainnew < 1] <- -9999
drainnew[drainnew >= 1 & drainnew < 2] <- 1 #well drained
drainnew[drainnew >= 2 & drainnew <3] <- 1
drainnew[drainnew >= 3 & drainnew <4] <- 1 #mod well
drainnew[drainnew >= 4 & drainnew <5] <- 0.75 #somewhat poor
drainnew[drainnew >= 5 & drainnew <6] <- 0.5 #poor
drainnew[drainnew >= 6 & drainnew <7] <- 1 #somewhat excessively
drainnew[drainnew >= 7& drainnew <8] <- 0.25 #very poor
drainnew[drainnew >= 8] <- 1 #excessive
drainnew[Ecoregion100 == 2 & drainnew == -9999] <-1
writeRaster(drainnew, "R:/fer/rschell/Mozelewski/NECN_Tina/NewMaps/drain100.tif", 
            datatype='FLT4S', overwrite=TRUE)

IC250 <- raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_random_strat/IC_InsideOut.tif",sep=""))
IC100 <- resample(IC250, claynew, method = "ngb")
plot(IC100)
writeRaster(IC100, "R:/fer/rschell/Mozelewski/NECN_Tina/NewMaps/IC100.tif", 
            datatype='INT4S', overwrite=TRUE)

Storm <- raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_random_strat/New_Stormflow.tif",sep=""))
Storm100 <- resample(Storm, claynew, method = "ngb")
par(mfrow=c(2,1))
plot(Storm100)
table(getValues(Storm100))
plot(sand_cut,add=TRUE)
writeRaster(Storm100, "R:/fer/rschell/Mozelewski/NECN_Tina/NewMaps/Stormflow100.tif", 
            datatype='FLT4S', overwrite=TRUE)

SurfC <- raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_random_strat/MRSOM1surfCmap.tif",sep=""))
SurfC100 <- resample(SurfC, claynew, method = "ngb")
writeRaster(SurfC100, "R:/fer/rschell/Mozelewski/NECN_Tina/NewMaps/SurfC100.tif", 
            datatype='FLT4S', overwrite=TRUE)

SurfN <- raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_random_strat/SOM1surflC1N15.tif",sep=""))
SurfN100 <- resample(SurfN, claynew, method = "ngb")
writeRaster(SurfN100, "R:/fer/rschell/Mozelewski/NECN_Tina/NewMaps/SurfN100.tif", 
            datatype='FLT4S', overwrite=TRUE)
###
SoilC <- raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_random_strat/MRSOM1soilCmap.tif",sep=""))
SoilC100 <- resample(SoilC, claynew, method = "ngb")
writeRaster(SoilC100, "R:/fer/rschell/Mozelewski/NECN_Tina/NewMaps/SoilC100.tif", 
            datatype='FLT4S', overwrite=TRUE)

SoilN <- raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_random_strat/SOM1SoilC1N15.tif",sep=""))
SoilN100 <- resample(SoilN, claynew, method = "ngb")
writeRaster(SoilN100, "R:/fer/rschell/Mozelewski/NECN_Tina/NewMaps/SoilN100.tif", 
            datatype='FLT4S', overwrite=TRUE)

SOM2C <- raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_random_strat/MRSOM2Cmap.tif",sep=""))
SOM2C100 <- resample(SOM2C, claynew, method = "ngb")
writeRaster(SOM2C100, "R:/fer/rschell/Mozelewski/NECN_Tina/NewMaps/SOM2C100.tif", 
            datatype='FLT4S', overwrite=TRUE)

SOM2N <- raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_random_strat/MRSOM2Nmap.tif",sep=""))
SOM2N100 <- resample(SOM2N, claynew, method = "ngb")
writeRaster(SOM2N100, "R:/fer/rschell/Mozelewski/NECN_Tina/NewMaps/SOM2N100.tif", 
            datatype='FLT4S', overwrite=TRUE)

SOM3C <- raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_random_strat/MRSOM3Cmap.tif",sep=""))
SOM3C100 <- resample(SOM3C, claynew, method = "ngb")
writeRaster(SOM3C100, "R:/fer/rschell/Mozelewski/NECN_Tina/NewMaps/SOM3C100.tif", 
            datatype='FLT4S', overwrite=TRUE)

SOM3N <- raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_random_strat/MRSOM3Nmap.tif",sep=""))
SOM3N100 <- resample(SOM3N, claynew, method = "ngb")
writeRaster(SOM3N100, "R:/fer/rschell/Mozelewski/NECN_Tina/NewMaps/SOM3N100.tif", 
            datatype='FLT4S', overwrite=TRUE)

DeadWood <- raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_random_strat/DeadWood_wood.tif",sep=""))
DeadWood100 <- resample(DeadWood, claynew, method = "ngb")
writeRaster(DeadWood100, "R:/fer/rschell/Mozelewski/NECN_Tina/NewMaps/DeadWood100.tif", 
            datatype='FLT4S', overwrite=TRUE)

DeadRoot <- raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_random_strat/DeadWood_root.tif",sep=""))
DeadRoot100 <- resample(DeadRoot, claynew, method = "ngb")
writeRaster(DeadRoot100, "R:/fer/rschell/Mozelewski/NECN_Tina/NewMaps/DeadRoot100.tif", 
            datatype='FLT4S', overwrite=TRUE)

flist <- list.files(path = "R:/fer/rschell/Mozelewski/NECN_Tina/LU/", pattern = "*.tif$", full = TRUE)
TimestepList <- as.character(seq(from=0, to=80, by=10))

for (i in TimestepList) {
  print(i)
  map <- raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/LU/land-use-", i, ".tif", sep=""))
  newmap <- resample(map, claynew, method = "ngb")
  writeRaster(newmap, paste("R:/fer/rschell/Mozelewski/NECN_Tina/NewMaps/land-use-", i, ".tif", sep=""), format="GTiff", datatype="INT2S", overwrite=T) 
}

#Is this best way to resample stand and management maps? What if stands are broken up in a way that splits them into different management units?
Standmap <- raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_random_strat/StandMap_r7.tif",sep=""))
Standmap100 <- resample(Standmap, claynew, method = "ngb")
writeRaster(Standmap100, "R:/fer/rschell/Mozelewski/NECN_Tina/NewMaps/Standmap100.tif", 
            datatype='INT4S', overwrite=TRUE)
#aggregate by stand

Mgmtmapr2 <- raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_random_strat2/MgmtMap_rand2.tif",sep=""))
R2Mgmtmap100 <- resample(Mgmtmapr2, claynew, method = "ngb")
writeRaster(R1Mgmtmap100, "R:/fer/rschell/Mozelewski/NECN_Tina/NewMaps/R2Mgmtmap100.tif", 
            datatype='INT4S', overwrite=TRUE)
