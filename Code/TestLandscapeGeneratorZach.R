##This script generates test landscae rasters for LANDIS-II
##Alec Kretchun, 2016
#Load things
library(raster)
library(rgdal)

##Export directory
w_dir <- "C:/Users/zjrobbin/Desktop/Proc_landscapes/"
setwd(w_dir)
thefiles<-list.files(paste(w_dir,sep=""),pattern = ".tif$")
for (file in thefiles)
raster.name <- file
#Setting dimensions of raster
read<-raster(paste(w_dir,file,sep=""))
read<-as.matrix(read)
max(read)
min(read)
null<-median(read[!is.na(read)])
sample<-read[read!=null]
meansample<-mean(sample)
print(meansample)
side1 <- 1 
side2 <- 1
##Setting raster value 
min.random <- meansample

##Creating raster
###FLts
raster.value<-as.double(meansample)
typeof(raster.value)
raster.matrix <- matrix(raster.value, nrow=side1, ncol= side2)
new.raster <- raster(raster.matrix)

writeRaster(new.raster, file=paste(w_dir, "SingleCell",raster.name, sep=""),datatype='INT4S')
}
###Float
fllist<-c("ProcClay_Normal_11_2","ProcSand_11_2","ProcFC_Norm11_2")
for(file in fllist){
raster.name <- file
print(file)
#Setting dimensions of raster
read<-raster(paste(w_dir,file,".tif",sep=""))
read<-as.matrix(read)
max(read)
min(read)
null<-median(read[!is.na(read)])
sample<-read[read!=null]
meansample<-mean(sample)
print(meansample)
side1 <- 1 
side2 <- 1
##Setting raster value 
min.random <- meansample

##Creating raster
raster.value<-as.double(meansample)
typeof(raster.value)
raster.matrix <- matrix(raster.value, nrow=side1, ncol= side2)
new.raster <- raster(raster.matrix)

writeRaster(new.raster, file=paste(w_dir, "SingleCell",raster.name,".tif", sep=""),datatype='FLT4S')
}



###IC
  raster.name<-"ProcInitialCommunities"

  side1 <- 1 
  side2 <- 1
  ##Setting raster value 
  min.random <-1.0 
  
  ##Creating raster
  raster.value<-as.double(min.random)
  typeof(raster.value)
  raster.matrix <- matrix(raster.value, nrow=side1, ncol= side2)
  new.raster <- raster(raster.matrix)
  
  writeRaster(new.raster, file=paste(w_dir, "SingleCell",raster.name,".tif", sep=""),datatype='INT4S')
}
dev.off

