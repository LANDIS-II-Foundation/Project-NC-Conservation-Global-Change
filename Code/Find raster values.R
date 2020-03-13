w_dir<-"R:/fer/rschell/Mozelewski/"
setwd(w_dir)


install.packages("raster")
library(raster)  
LossYear<-raster(paste(w_dir,"Hansen_lossyear_study_extent11.tif",sep=""))
#f <- system.file("Hansen_lossyear_study_extent11.tif", package="raster")  
#r <- raster(f) #r is the object  

#Raster to matrix
r_matrix<-as.matrix(LossYear)
#Proportion of zero value pixels
P2<-length(which(r_matrix==2))/(length(r_matrix)-length(which(is.na(r_matrix))))
P2

install.packages("rgdal")
library(rgdal)
plot(LossYear)

#Proportion of values < 3rd Quantile     
value=as.numeric(summary(as.vector(r_matrix))[5])#position of the 3rd quantile value
P3<-length(which(r_matrix<value))/(length(r_matrix)-length(which(is.na(r_matrix))))