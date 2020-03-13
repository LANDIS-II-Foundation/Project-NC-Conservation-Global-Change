##This script generates test landscae rasters for LANDIS-II
##Alec Kretchun, 2016
#Load things
library(raster)
library(rgdal)

##Export directory
data.dir <- "R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_SingleCell_loblolly/SingleCellRastersTina/"
raster.name <- "singlecell_43"
template.raster <- raster("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_SingleCell_loblolly/SingleCellRastersTina/singlecell_31point5.img")

#Setting dimensions of raster

side1 <- 1
side2 <- 1

##Setting raster value
#min.random <- as.integer(0.0)
#max.random <- as.integer(6.0)
#raster.value <- round(runif((side1*side2), min=min.random, max=max.random))
#raster.value <- c(rep(1, 9801/3), rep(2, 9801/3), rep(3, 9801/3))
raster.value <- 43
  
# eco.values <- c(0.068)  
# raster.value.fixed <- matrix(ncol=1, nrow=1)
# raster.value.fixed[,1] <- eco.values
# raster.value.fixed <-  rbind(raster.value.fixed, 9)

##Creating raster

raster.matrix <- matrix(raster.value, nrow=side1, ncol= side2)
new.raster <- raster(raster.matrix, template = template.raster)

writeRaster(new.raster, file=paste(data.dir, raster.name, ".tif", sep=""), overwrite=TRUE)

