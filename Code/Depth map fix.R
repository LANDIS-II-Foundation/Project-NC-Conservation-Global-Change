library(raster)
library(rgdal)

sa <- readOGR("R:/fer/rschell/Mozelewski/Study extent/studyextent.shp")
crs(sa)

Ecoregion <- raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_landscape_basic_Sor_1/Ecoregion_5_29.img",sep=""))
crs(Ecoregion)

sa_reproj <- spTransform(sa, crs(Ecoregion)) 
crs(sa_reproj)

tm <- file.path("R:/fer/rschell/Mozelewski/Study extent/")
writeOGR(obj=sa_reproj, dsn=tm, layer="sa_reproj", driver="ESRI Shapefile")

plot(Ecoregion)
Eco_crop <- crop(Ecoregion, sa_reproj)
table(getValues(Eco_crop))

table(getValues(Ecoregion))

depth_raster <- raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_landscape_basic_Sor_1/MRNCDepthAOI.tif", sep=""))
table(getValues(depth_raster))
#MgmtMap[random5_conserved_1] <- 11

freq(depth_raster, digits=0, value=-9999)
depth_crop <- crop(depth_raster, sa_reproj)
Depth_df<-as.data.frame(depth_crop)
depth_tbl <- table(Depth_df)

plot(depth_crop)
freq(depth_crop, digits=0, value=-9999)
freq(depth_crop, digits=0, value=0)
###############################################################################################################
############################################# Soils per Zachary ###############################################
###############################################################################################################

w_dir <- setwd("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_landscape_basic_Sor_1/")

proj<-CRS("+init=EPSG:26917")
ecoregions<-raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_landscape_basic_Sor_1/S_Out.tif",sep=""))
#plot(ecoregions)
DummyEco<-ecoregions
##turn all except for the six to 1
DummyEco[DummyEco>=1,]<-2
DummyEco[is.na(DummyEco[,1]),]<-1
DummyEco[DummyEco<1,]<-1
plot(DummyEco)
##Write Raster
writeRaster(MgmtMap, "R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_random_strat/MgmtMap_rand1.tif", 
            datatype='INT4S', overwrite=TRUE)
new_output_file_name<-(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_landscape_basic_Sor_1/DummyEco.tif",sep=""))
writeRaster(DummyEco, filename=new_output_file_name, datatype='FLT8S',overwrite=TRUE)  
ExampleRaster<-DummyEco
###Get just the Carbon/nitrogen files

#Depth
#Depth that are zero can never grow trees and will trigger weird errors. Here I find each of these are turn their ecoregion to off. 
Depth<-(raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_landscape_basic_Sor_1/MRNCDepthAOI.tif",sep="")))
Depth_crop <- crop(Depth, sa_reproj)
Depth<-as.data.frame(raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_landscape_basic_Sor_1/MRNCDepthAOI.tif",sep="")))
ecoregion<-as.data.frame(raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_landscape_basic_Sor_1/Ecoregion_5_29.img",sep="")))
df<-cbind(Depth,ecoregion)
colnames(df)<-c("Input","e")
df$e[df$Input<=(0.0) & df$e!=1]<-1.0
output_matrix<-matrix(df$e,nrow=nrow(ExampleRaster),ncol=ncol(ExampleRaster),byrow=T) 
new_output_raster<-raster(output_matrix,xmn=xmin(ExampleRaster),ymn=ymin(ExampleRaster),xmx=xmax(ExampleRaster),ymx=ymax(ExampleRaster), crs=proj)
new_output_file_name<-paste(w_dir,"Final/MR_FinalDummyEco.tif",sep="")
rast_IC_map<-writeRaster(new_output_raster, filename=new_output_file_name, datatype='INT4S',overwrite=TRUE)#Th



ECO_cut<-(raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_landscape_basic_Sor_1/ECO_cuttodepth.tif",sep="")))
writeRaster(ECO_cut, "R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_landscape_basic_Sor_1/ECO_cutnew.tif", 
            datatype='INT4S', overwrite=TRUE)


ECO_cutnew<-(raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_landscape_basic_Sor_1/ECO_cutnew.tif",sep="")))
Stormflow<-(raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_landscape_basic_Sor_1/MR_Stormflow.tif",sep="")))
table(getValues(Stormflow))
ECO_cutnew[ECO_cutnew == 2]<- 0.300000011920929
table(getValues(ECO_cutnew))
writeRaster(ECO_cutnew, "R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_landscape_basic_Sor_1/New_Stormflow.tif", 
            datatype='INT4S', overwrite=TRUE)
