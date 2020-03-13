###READ ME####

#This script is set up to shrink a current, larger ecoregion
#to a smaller extent. This script takes in a current ecoregion raster
#and a smaller RASTER providing the desired new ecoregion extent.

###TO RUN: 

#1. set "full_orig_ecoregion_path" = path to your large ecoregion raster
#2. set "out_path" = where you want to write out your shrunk ecoregion
#3. set "smaller_ecoregion_path" = folder where vector file is stored
#4. ALTER variable "m" a matrix identifying raster values of your small raster 
#   and designated what values they should be reclassified to
#   - The original example below: 
#     0-> NA
#     1-> 1
#     2-> NA
##### YOU WILL NEED TO SET THESE CLASSES with classes you want included in  
##### the final raster as output "1" and all other classes as output "NA"

#5a. will be written out as "small_ecoreg.tif"
#5b. out file name can be changed in writeRaster() command in the last line of the script


library(rgdal)
library(raster)
library(sp)


#set path to large ecoregion
full_orig_ecoregion_path<-"C:\\Users\\kejones8\\Dropbox\\DEAL_lab\\landis\\LANDIS_Sapps_Active_v1_1 _Kates_orig\\MR_FourEcoregions.tif"

#designated a place to write new raster when complete
out_path<-"C:\\Users\\kejones8\\Dropbox\\DEAL_lab\\landis\\"

#set path to small ecoregion
#in this case its a raster
smaller_ecoregion_path<-"C:\\Users\\kejones8\\Dropbox\\DEAL_lab\\landis\\LANDIS_Sapps_Active_v1_1 _Kates_orig\\Chris_Ecoregion_Cleaned.tif"

#load in large ecoregion
ecoregions<-raster(full_orig_ecoregion_path)

#load in small ecoregion
small_ecoreg<-raster(smaller_ecoregion_path)

#transform/project small raster to match current (larger) ecoregion
s_ecoreg_t <- projectRaster(small_ecoreg, ecoregions)

#reclassify small ecoregion raster
#2 column reclassification matrix created 0 -> NA, 1 -> 1, 2 -> NA
m <- c(0, NA,  1, 1,  2, NA)
rclmat <- matrix(m, ncol=2, byrow=TRUE)
rc <- reclassify(small_ecoreg, rclmat)

#if rasters are not same extent/res, using crop is a good idea!
new_ecoreg <- mask(crop(ecoregions, rc), rc)

#check to make sure all looks correct
plot(new_ecoreg)

#reclassify one last time to make nas 1
m2 <- c(NA, 1)
rclmat2 <- matrix(m2, ncol=2, byrow=TRUE)
rc2 <- reclassify(new_ecoreg, rclmat2)

plot(rc2)

#write out new raster, same extent as small raster
writeRaster(rc2,paste0(out_path,"new_small_ecoreg.tif"),datatype = 'INT4S')






