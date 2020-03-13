library(gdistance)
library(rgeos)
install.packages("harrietr")
library(harrietr)
library(otuSummary)
library('geosphere')
library(gdata)

test_tr <- transition(test_raster, transitionFunction=mean, directions=8)

trueCentroids <- gCentroid(polAll, byid=TRUE)

#Euclidean distance between points - STILL NEED TO REMOVE POINTS HIGHER THAN CERTAIN DISTANCE AND KEEP NEWID NUMBER
EUpts <- spDists(x= trueCentroids, y = trueCentroids, longlat = FALSE, segments = FALSE, diagonal = FALSE)

#calculate resistance distance
test_trR <- geoCorrection(test_tr, type="r", multpl=FALSE, scl=TRUE) #geocorrection for resistance distance
resDist <- commuteDistance(test_trR, trueCentroids)

#convert distance matrix to dataframe and then write text file
resmatrix <- matrixConvert(resDist, colname = c("pola", "polb2", "dist"))
write.table(resmatrix, file="disance.txt", row.names=FALSE, col.names=FALSE)

#calculate least cost path
#test_trC <- geoCorrection(test_tr, type="c") #geocorrection for least cost path
#costDist <- costDistance(test_trC, trueCentroids) 

Landis_standmap <- raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_landscape_basic_Sor_1/StandMap_r7.tif",sep=""))
Stand_poly <- rasterToPolygons(Landis_standmap, fun=NULL)
