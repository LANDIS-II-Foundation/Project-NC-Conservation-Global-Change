install.packages("raster")
install.packages("rgdal")

library(raster)
library(rgdal)

data.dir <- "R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_landscape_basic_Sor/"
raster.name <- "SorrensonsICflt"
SorrensonsICflt <- raster("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_landscape_basic_Sor/SorrensonsInitialCommunities.img")
writeRaster(SorrensonsICflt, file=paste(data.dir, raster.name, ".tif", sep=""), datatype='INT4S', overwrite=TRUE)


##################################################################
w_dir<-"R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_landscape_basic_Sor/"
setwd(w_dir)

ExampleRaster<-raster(paste(w_dir,"S_Out.tif",sep=""))
input<-raster(paste(w_dir,"S_Out.tif",sep=""))
input<-as.data.frame(input)

#print(max(input[,1]))
#print(min(input[,1]))
#output_matrix<-matrix(input[,1],nrow=nrow(ExampleRaster),ncol=ncol(ExampleRaster),byrow=T) #fir
#new_output_raster<-raster(output_matrix,xmn=xmin(ExampleRaster),ymn=ymin(ExampleRaster),xmx=xmax(ExampleRaster),ymx=ymax(ExampleRaster), crs=proj)
#plot(new_output_raster)
filename=paste(w_dir,"S_Out.tif",sep="")
#print(filename)
writeRaster(new_output_raster, filename=filename, datatype='INT4S',overwrite=TRUE)

###################################################################
data.dir <- "R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_landscape_basic_Sor/"
raster.name <- "MgmtMap_r4"
MgmtMap <- raster("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_landscape_basic_Sor/MgmtMap.tif")
writeRaster(MgmtMap, file=paste(data.dir, raster.name, ".tif", sep=""), datatype='INT4S', overwrite=TRUE)

# are there NAs in raster check
MgmtMap4 <- raster("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_landscape_basic_Sor/MgmtMap_r4.tif")
Map4_test <- as.data.frame(MgmtMap4)
is.na(Map4_test)

MgmtMap4[is.na(MgmtMap4[])] <- 99999
Map4_test1 <- as.data.frame(MgmtMap4)
is.na(Map4_test1)
writeRaster(MgmtMap4, file=paste(data.dir, "MgmtMap_r5.tif", sep=""), datatype='INT4S', overwrite=TRUE)


raster.name1 <- "StandMap_r4"
StandMap <- raster("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_landscape_basic_Sor/StandMap.tif")
writeRaster(StandMap, file=paste(data.dir, raster.name1, ".tif", sep=""), datatype='INT4S', overwrite=TRUE)

StandMap4 <- raster("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_landscape_basic_Sor/StandMap_r4.tif")
StandMap4[is.na(StandMap4[])] <- 99999
writeRaster(StandMap4, file=paste(data.dir, "StandMap_r5.tif", sep=""), datatype='INT4S', overwrite=TRUE)


