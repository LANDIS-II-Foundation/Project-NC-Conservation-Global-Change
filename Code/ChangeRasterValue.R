install.packages("raster")
install.packages("rgdal")

#install.packages("sp")
#install.packages("maptools")
#install.packages("rgeos")
#install.packages("dplyr")
#install.packages("ggplot2")

library(raster)
library(rgdal)

data.dir <- "R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_landscape_basic/"
raster.name <- "drain_test"
drain_test <- raster("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_landscape_basic/MRNCDrainAOI.tif")

m <- c(0, 1.1, 0.5,   -9999, 0, -9999)
rclmat <- matrix(m, ncol = 3, byrow = TRUE)
rc <- reclassify(drain_test, rclmat)
writeRaster(rc, file=paste(data.dir, raster.name, ".tif", sep=""), datatype='FLT4S', overwrite=TRUE)

data.dir <- "R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_landscape_test_FcWp/"
raster.name <- "wiltpt_test"
wiltpt <- raster("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_landscape_test_FcWp/MRWP_Normal.tif")

wiltpt_test <- wiltpt/2
writeRaster(rc, file=paste(data.dir, raster.name, ".tif", sep=""), datatype='FLT4S', overwrite=TRUE)
