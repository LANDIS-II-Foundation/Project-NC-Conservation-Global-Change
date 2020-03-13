w_dir<-"R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_landscape_basic_Sor/"
setwd(w_dir)

my_data <- read.delim("Tinas_IC_Sorrensons5_6.txt")

files=c("biomass/AcerRubr-ageclass-0. img", "biomass/CornFlor-ageclass-0.img", "biomass/LiquStyr-ageclass-0.img", "biomass/LiriTuli-ageclass-0.img", 
        "biomass/OxydArbo-ageclass-0.img", "biomass/PinuEchi-ageclass-0.img", "biomass/PinuPalu-ageclass-0.img", "biomass/PinuTaed-ageclass-0.img", 
        "biomass/PinuVirg-ageclass-0.img", "biomass/QuerAlba-ageclass-0.img", "biomass/QuerLaev-ageclass-0.img")

install.packages("raster")
install.packages("rgdal")
library(raster)
library(rgdal)

# open raster layer
Sdepth <- raster("MRNCDepthAOI.tif")

# plot
plot(Sdepth)

rsf <- raster("MR_Stormflow.tif")
res(rsf)

rc <- raster("MRClay_Done.tif")
res(rc)