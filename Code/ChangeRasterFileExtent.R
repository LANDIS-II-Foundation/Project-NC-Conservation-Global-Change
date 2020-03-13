library(raster)
library(rgdal)

data.dir <- "R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_SingleCell_MultSpecies/SingleCellRastersTina/"
raster.name <- "singlecell_100"

singlecell_100 <- raster("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_SingleCell_MultSpecies/SingleCellRastersTina/singlecell_100.img")
writeRaster(singlecell_100, file=paste(data.dir, raster.name, ".tif", sep=""), datatype='FLT4S', overwrite=TRUE)


###writeRaster(new.raster, file=paste(w_dir, "SingleCell",raster.name,".tif", sep=""),datatype='FLT4S')

### ECOREGIONS AND IC MAP MUST BE INTEGERS
###writeRaster(new.raster, file=paste(w_dir, "SingleCell",raster.name, sep=""),datatype='INT4S')

###need to start with 7.88 on Tuesday