###READ ME####

#This script is set up to shrink a current, larger ecoregion
#to a smaller extent. This script takes in a current ecoregion raster
#and a smaller VECTOR providing the desired new ecoregion extent.

###TO RUN: 

#1. set "full_orig_ecoregion_path" = path to your large ecoregion raster
#2. set "out_path" = where you want to write out your shrunk ecoregion
#3. set "smaller_ecoregion_path" = folder where vector file is stored
#4. set "small_ecoreg_lyrnm" = name of your vector file, WITHOUT file extension
#5a. will be written out as "small_ecoreg.tif"
#5b. out file name can be changed in writeRaster() command in the last line of the script


library(rgdal)
library(raster)
library(sp)


#set path to large ecoregion
full_orig_ecoregion_path<-"C:\\Users\\kejones8\\Dropbox\\DEAL_lab\\landis\\LANDIS_Sapps_Active_v1_1 _Kates_orig\\MR_FourEcoregions.tif"

#designated a place to write smaller ecoregion raster when complete
out_path<-"C:\\Users\\kejones8\\Dropbox\\DEAL_lab\\landis\\"


#set path to small ecoregion, for this script = vector
smaller_ecoregion_path<-"C:\\Users\\kejones8\\Dropbox\\DEAL_lab\\landis\\Buncombe_County_Boundary"

#small ecoregion layer name
small_ecoreg_lyrnm<-"Buncombe_County_Boundary"

#load in large ecoregion
ecoregions<-raster(full_orig_ecoregion_path)

#load in small ecoregion
small_ecoreg<-readOGR(dsn=smaller_ecoregion_path,layer=small_ecoreg_lyrnm)

#make sure small ecoregion is in the same projection
#as the large ecoregion
s_ecoreg_t <- spTransform(small_ecoreg, crs(ecoregions))


#create small ecoregion raster with res, extent, crs info 
res<-res(ecoregions)
ext<-extent(ecoregions)
r <- raster(ext, res=res)

#rasterize the shapefile following the raster params above
r <- rasterize(s_ecoreg_t, r, field=1)

#see that it worked, should be vals of 1
plot(r)

#now create new raster with correct ecoregion raster vals!
#if rasters are not same extent/res, using crop is a good idea!
new_ecoreg <- mask(crop(ecoregions, r), r)

#write out new raster, same extent as small raster
writeRaster(new_ecoreg,paste0(out_path,"test2_small_ecoreg.tif"),datatype = 'INT4S')



