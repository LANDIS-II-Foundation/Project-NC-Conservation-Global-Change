library(viridis)

par(mfrow=c(1,1))

################## No conservation ###########################
pol1nocon_dis <- readOGR(dsn="shapefiles", "pol80nocLUC_dis")
pol1nocon_dis$area_ha <- area(pol1nocon_dis)/10000
pol1nocon_dis$NEWid <- seq(from= 10001, to= 11835, by =1) #have to change this number every time. How to fix??

pol1nocon_dis$num1 <- seq(from = 1, to= length(pol1nocon_dis), by=1)
pol1nocon_dis$num2 <- seq(from = 1, to= length(pol1nocon_dis), by=1)

#find polgyon centroid
trueCentroidsnocon <- gCentroid(pol1nocon_dis, byid=TRUE, id = pol1nocon_dis$NEWid)

#Euclidean distance between points
EUpts <- spDists(x= trueCentroidsnocon, y = trueCentroidsnocon, longlat = FALSE, segments = FALSE, diagonal = FALSE)
EUnew <- subset(melt(EUpts), value!=0)
EU5000<-EUnew[!(EUnew$value > 5000),]
EU5000_nodups <- EU5000[!duplicated(data.frame(list(do.call(pmin,EU5000),do.call(pmax,EU5000)))),]
colnames(EU5000_nodups) <- c("num1", "num2", "EUD")
lookup <- cbind(pol1nocon_dis$NEWid, pol1nocon_dis$num1, pol1nocon_dis$num2)
colnames(lookup) <- c("NewID", "num1", "num2")
EU_test <- merge(x = EU5000_nodups, y = lookup, by = "num1", all.x = TRUE)
colnames(EU_test) <- c("num1", "num2", "EUD", "NewID", "num2.y")
EU_test2 <- merge(x = EU_test, y = lookup, by = "num2", all.x = TRUE)
EU_fin <- cbind(EU_test2$NewID.x, EU_test2$NewID.y)
EU_fin_df_nocon <- data.frame(EU_fin)


#plot habitat polygons colorcoded by area
sa_reproj <- readOGR("R:/fer/rschell/Mozelewski/Study extent/sa_reproj.shp",  stringsAsFactors = FALSE)
crs(sa_reproj)
sa_right <- spTransform(sa_reproj, crs (Ecoregion))
crs(sa_right)
sa_outline <- list("sp.lines", sa_right, col= "black", bg="grey88")
spplot(pol1nocon_dis, "area_ha", col.regions= rev(terrain.colors(9)[-1]), cuts= 7, sp.layout = sa_outline, 
        main= "Habitat patches no conservation (in hectares)", col ="transparent")


#get coordinates of polygon centroids
centroid.coords<- data.frame(trueCentroidsnocon)
centroid.coords$X1 <- seq(from=10001, to= 11835, by=1)
centroid.coords$X2 <- seq(from=10001, to= 11835, by=1)
EU_fin_df_nocon_X0<- EU_fin_df_nocon[,1]
EU_fin_df_nocon_X1<- EU_fin_df_nocon[,2]
#X0 <- merge(EU_fin_df_nocon, centroid.coords, by= "X1")
cent1 <- merge(x = EU_fin_df_nocon, y = centroid.coords, by = "X1", all.x = TRUE)
colnames(cent1) <- c("X1", "X2", "x", "y", "X2.y")
cent2 <- merge(x = cent1, y = centroid.coords, by = "X2", all.x = TRUE)
X0 <- cent2[, 3]
y0 <- cent2[, 4]
X1 <- cent2[, 6]
y1 <- cent2[, 7]
cent_coords_comb <- cbind(X0, y0, X1, y1)
colnames(cent_coords_comb) <- c("x0", "y0", "x1", "y1")
cent_df_nocon <- data.frame(cent_coords_comb)

trueCentroidsnocon$area_ha <- pol1nocon_dis$area_ha

veg_nocon <- raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_landscape_basic_Sor_1_LUC/output/bio-reclass1-80.img",sep=""))
crs(veg_nocon) <- "+proj=utm +zone=17 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs"
extent(veg_nocon)<-raster::extent(Ecoregion)
mygray <- gray.colors(5, start = 0.2, end=0.8, gamma=2)
plot(veg_nocon, main = "Habitat links no conservation LUC", col=mygray, axes= FALSE, legend = FALSE)
points(trueCentroidsnocon, pch=1, cex= trueCentroidsnocon$area_ha^0.25)
segments(cent_df_nocon$x0,                            # Draw multiple lines
         cent_df_nocon$y0,
         cent_df_nocon$x1,
         cent_df_nocon$y1, col=alpha("lightblue1", 0.15))
#legend(topleft, inset =0.02, legend = 1:length())


############################## Geo strategy 2% ###################################
geo_poly <- readOGR(dsn="shapefiles", "pol80geo_dis")
geo_poly$area_ha <- area(geo_poly)/10000
geo_poly$NEWid <- seq(from= 10001, to= 13726, by =1) #have to change this number every time. How to fix??

geo_poly$num1 <- seq(from = 1, to= length(geo_poly), by=1)
geo_poly$num2 <- seq(from = 1, to= length(geo_poly), by=1)

#find polgyon centroid
trueCentroidsgeo <- gCentroid(geo_poly, byid=TRUE, id = geo_poly$NEWid)

#Euclidean distance between points
EUpts <- spDists(x= trueCentroidsgeo, y = trueCentroidsgeo, longlat = FALSE, segments = FALSE, diagonal = FALSE)
EUnew <- subset(melt(EUpts), value!=0)
EU5000<-EUnew[!(EUnew$value > 5000),]
EU5000_nodups <- EU5000[!duplicated(data.frame(list(do.call(pmin,EU5000),do.call(pmax,EU5000)))),]
colnames(EU5000_nodups) <- c("num1", "num2", "EUD")
lookup <- cbind(geo_poly$NEWid, geo_poly$num1, geo_poly$num2)
colnames(lookup) <- c("NewID", "num1", "num2")
EU_test <- merge(x = EU5000_nodups, y = lookup, by = "num1", all.x = TRUE)
colnames(EU_test) <- c("num1", "num2", "EUD", "NewID", "num2.y")
EU_test2 <- merge(x = EU_test, y = lookup, by = "num2", all.x = TRUE)
EU_fin <- cbind(EU_test2$NewID.x, EU_test2$NewID.y)
EU_fin_df_geo <- data.frame(EU_fin)


#get coordinates of polygon centroids
centroid.coords<- data.frame(trueCentroidsgeo)
centroid.coords$X1 <- seq(from=10001, to= 13726, by=1)
centroid.coords$X2 <- seq(from=10001, to= 13726, by=1)
EU_fin_df_geo_X0<- EU_fin_df_geo[,1]
EU_fin_df_geo_X1<- EU_fin_df_geo[,2]
#X0 <- merge(EU_fin_df_nocon, centroid.coords, by= "X1")
cent1 <- merge(x = EU_fin_df_geo, y = centroid.coords, by = "X1", all.x = TRUE)
colnames(cent1) <- c("X1", "X2", "x", "y", "X2.y")
cent2 <- merge(x = cent1, y = centroid.coords, by = "X2", all.x = TRUE)
X0 <- cent2[, 3]
y0 <- cent2[, 4]
X1 <- cent2[, 6]
y1 <- cent2[, 7]
cent_coords_comb <- cbind(X0, y0, X1, y1)
colnames(cent_coords_comb) <- c("x0", "y0", "x1", "y1")
cent_df_geo <- data.frame(cent_coords_comb)

trueCentroidsgeo$area_ha <- geo_poly$area_ha

veg_geo <- raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_geo_strat2/output/bio-reclass1-80.img",sep=""))
crs(veg_geo) <- "+proj=utm +zone=17 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs"
extent(veg_geo)<-raster::extent(Ecoregion)
mygray <- gray.colors(5, start = 0.2, end=0.8, gamma=2)
plot(veg_geo, main = "Habitat links geodiversity", col=mygray, axes= FALSE, legend = FALSE)
points(trueCentroidsgeo, pch=1, cex= trueCentroidsgeo$area_ha^0.33)
segments(cent_df_geo$x0,                            # Draw multiple lines
         cent_df_geo$y0,
         cent_df_geo$x1,
         cent_df_geo$y1, col=alpha("lightblue1", 0.15))


############################## Random strategy 2% ###################################
#plot habitat polygons colorcoded by area
rand_poly <- readOGR(dsn="shapefiles", "pol1rand2_dis")
rand_poly$area_ha <- area(rand_poly)/10000
rand_poly$NEWid <- seq(from= 10001, to= 12539, by =1) #have to change this number every time. How to fix??

rand_poly$num1 <- seq(from = 1, to= length(rand_poly), by=1)
rand_poly$num2 <- seq(from = 1, to= length(rand_poly), by=1)

#find polgyon centroid
trueCentroidsrand <- gCentroid(rand_poly, byid=TRUE, id = rand_poly$NEWid)

#Euclidean distance between points
EUpts <- spDists(x= trueCentroidsrand, y = trueCentroidsrand, longlat = FALSE, segments = FALSE, diagonal = FALSE)
EUnew <- subset(melt(EUpts), value!=0)
EU5000<-EUnew[!(EUnew$value > 5000),]
EU5000_nodups <- EU5000[!duplicated(data.frame(list(do.call(pmin,EU5000),do.call(pmax,EU5000)))),]
colnames(EU5000_nodups) <- c("num1", "num2", "EUD")
lookup <- cbind(rand_poly$NEWid, rand_poly$num1, rand_poly$num2)
colnames(lookup) <- c("NewID", "num1", "num2")
EU_test <- merge(x = EU5000_nodups, y = lookup, by = "num1", all.x = TRUE)
colnames(EU_test) <- c("num1", "num2", "EUD", "NewID", "num2.y")
EU_test2 <- merge(x = EU_test, y = lookup, by = "num2", all.x = TRUE)
EU_fin <- cbind(EU_test2$NewID.x, EU_test2$NewID.y)
EU_fin_df_rand <- data.frame(EU_fin)

#get coordinates of polygon centroids
centroid.coords<- data.frame(trueCentroidsrand)
centroid.coords$X1 <- seq(from=10001, to= 12539, by=1)
centroid.coords$X2 <- seq(from=10001, to= 12539, by=1)
EU_fin_df_rand_X0<- EU_fin_df_rand[,1]
EU_fin_df_rand_X1<- EU_fin_df_rand[,2]
#X0 <- merge(EU_fin_df_nocon, centroid.coords, by= "X1")
cent1 <- merge(x = EU_fin_df_rand, y = centroid.coords, by = "X1", all.x = TRUE)
colnames(cent1) <- c("X1", "X2", "x", "y", "X2.y")
cent2 <- merge(x = cent1, y = centroid.coords, by = "X2", all.x = TRUE)
X0 <- cent2[, 3]
y0 <- cent2[, 4]
X1 <- cent2[, 6]
y1 <- cent2[, 7]
cent_coords_comb <- cbind(X0, y0, X1, y1)
colnames(cent_coords_comb) <- c("x0", "y0", "x1", "y1")
cent_df_rand <- data.frame(cent_coords_comb)

trueCentroidsrand$area_ha <- rand_poly$area_ha

veg_rand <- raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_basic_random_strat2/output/bio-reclass1-80.img",sep=""))
crs(veg_rand) <- "+proj=utm +zone=17 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs"
extent(veg_rand)<-raster::extent(Ecoregion)
mygray <- gray.colors(5, start = 0.2, end=0.8, gamma=2)
plot(veg_rand, main = "Habitat links random acquisition", col=mygray, axes= FALSE, legend = FALSE)
points(trueCentroidsrand, pch=1, cex= trueCentroidsrand$area_ha^0.33)
segments(cent_df_rand$x0,                            # Draw multiple lines
         cent_df_rand$y0,
         cent_df_rand$x1,
         cent_df_rand$y1, col=alpha("lightblue1", 0.15))


#########################econ ######################################
#Bring in ecoregion map to use for crs and extent template
Ecoregion <- raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_landscape_basic_Sor_1/Ecoregion_5_29.img",sep=""))
crs(Ecoregion)

#Bring in community type map, assign projection, and reformat to ecoregion extent for time step zero
biore80 <- raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_econ_strat/output/bio-reclass1-80.img",sep=""))
crs(biore80) <- "+proj=utm +zone=17 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs"
extent(biore80)<-raster::extent(Ecoregion)

#Bring in stand median age map, assign projection, and reformat to ecoregion extent for time step zero
median80 <- raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_econ_strat/output/cohort-stats/AGE-MED-80.img",sep=""))
crs(median80) <- "+proj=utm +zone=17 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs"
extent(median80)<-raster::extent(Ecoregion)

#Bring in land use change raster for time step zero
LU80 <- raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_econ_strat/land-use-80.tif", sep=""))
plot(LU80)
table(getValues(LU80))

#Create a raster that will become resistance raster
test_raster <- raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_econ_strat/output/bio-reclass1-80.img",sep=""))
table(getValues(test_raster))

#Assign projection and reformat to ecoregion extent for the resistance raster
crs(test_raster) <- "+proj=utm +zone=17 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs"
extent(test_raster)<-raster::extent(Ecoregion)


### Create conductance surface (1/resistance) for longleaf pine obligate species
### Include community type, stand median age (species richness considered in community type designations)

#longleaf community comp
test_raster[biore80 == 1 & median80 %in% c(0:1),] <- (1/100)
test_raster[biore80 == 1 & median80 %in% c(2:5),] <- (1/95)
test_raster[biore80 == 1 & median80 %in% c(6:7),] <- (1/85)
test_raster[biore80 == 1 & median80 %in% c(8:9),] <- (1/50)
test_raster[biore80 == 1 & median80 %in% c(10:20),] <- (1/10)
test_raster[biore80 == 1 & median80 %in% c(21:34),] <- (1/5)
test_raster[biore80 == 1 & median80 >= 35,] <- 1

#conifer mixed community type
test_raster[biore80 == 2 & median80 %in% c(0:5),] <- (1/95)
test_raster[biore80 == 2 & median80 %in% c(6:10),] <- (1/80)
test_raster[biore80 == 2 & median80 %in% c(11:20),] <- (1/40)
test_raster[biore80 == 2 & median80 %in% c(21:34),] <- (1/30)
test_raster[biore80 == 2 & median80 >= 35,] <- (1/20)

#pine plantation community type
test_raster[biore80 == 3 & median80 %in% c(0:5),] <- (1/100)
test_raster[biore80 == 3 & median80 %in% c(6:10),] <- (1/90)
test_raster[biore80 == 3 & median80 %in% c(11:20),] <- (1/80)
test_raster[biore80 == 3 & median80 %in% c(21:30),] <- (1/70)
test_raster[biore80 == 3 & median80 >= 31,] <- (1/60)

#mixed hardwood and conifer community type
test_raster[biore80 == 4 & median80 %in% c(0:10),] <- (1/100)
test_raster[biore80 == 4 & median80 %in% c(11:20),] <- (1/95)
test_raster[biore80 == 4 & median80 %in% c(21:30),] <- (1/90)
test_raster[biore80 == 4 & median80 >= 31,] <- (1/80)

#hardwood community type
test_raster[biore80 == 5 & median80 %in% c(0:10),] <- (1/100)
test_raster[biore80 == 5 & median80 %in% c(11:20),] <- (1/95)
test_raster[biore80 == 5 & median80 %in% c(21:30),] <- (1/90)
test_raster[biore80 == 5 & median80 >= 31,] <- (1/85)

plot(test_raster)
table(getValues(test_raster))

test_raster2 <- test_raster

#land use type
test_raster2[LU80 == 13] <- (1/90) #cropland
test_raster2[LU80 == 14] <- (1/90) #hay/pasture
test_raster2[LU80 == 1] <- (1/100) #water
test_raster2[LU80 == 2] <- (1/100) #developed
test_raster2[LU80 == 6] <- (1/100) #mining

table(getValues(test_raster2))

#test_raster[biore0 == 0] <- NA #how to do this without making open water NA????

plot(test_raster2)

#roads
roads <- readOGR("R:/fer/rschell/Mozelewski/NCRouteCharacteristics_SHP/NCRouteClip.shp")
roads <- spTransform(roads, crs (Ecoregion))
test_raster2[roads$RouteClass %in% c(1:2)] <- (1/100)
test_raster2[roads$RouteClass %in% c(3:4)] <- (1/95)
test_raster2[roads$RouteClass %in% c(5:89)] <- (1/90)
plot(test_raster2)

rm(roads)


###Make shapefiles of habitat
Landis_standmap <- raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_landscape_basic_Sor_1/StandMap_r7.tif",sep=""))
plot(Landis_standmap)

#Best habitat
pol1 <- rasterToPolygons(test_raster2, fun=function(x){x>= 0.02})
plot(pol1)
crs(pol1)

setwd("R:/fer/rschell/Mozelewski/Chapter_2_analysis/")
writeOGR(obj=pol1, dsn="shapefiles", layer="pol80econf", driver="ESRI Shapefile")

#plot habitat polygons colorcoded by area
econ_poly <- readOGR(dsn="shapefiles", "pol80econf_dis")
econ_poly$area_ha <- area(econ_poly)/10000
econ_poly$NEWid <- seq(from= 10001, to= 13960, by =1) #have to change this number every time. How to fix??

econ_poly$num1 <- seq(from = 1, to= length(econ_poly), by=1)
econ_poly$num2 <- seq(from = 1, to= length(econ_poly), by=1)

#find polgyon centroid
trueCentroidsecon <- gCentroid(econ_poly, byid=TRUE, id = econ_poly$NEWid)

#Euclidean distance between points
EUpts <- spDists(x= trueCentroidsecon, y = trueCentroidsecon, longlat = FALSE, segments = FALSE, diagonal = FALSE)
EUnew <- subset(melt(EUpts), value!=0)
EU5000<-EUnew[!(EUnew$value > 5000),]
EU5000_nodups <- EU5000[!duplicated(data.frame(list(do.call(pmin,EU5000),do.call(pmax,EU5000)))),]
colnames(EU5000_nodups) <- c("num1", "num2", "EUD")
lookup <- cbind(econ_poly$NEWid, econ_poly$num1, econ_poly$num2)
colnames(lookup) <- c("NewID", "num1", "num2")
EU_test <- merge(x = EU5000_nodups, y = lookup, by = "num1", all.x = TRUE)
colnames(EU_test) <- c("num1", "num2", "EUD", "NewID", "num2.y")
EU_test2 <- merge(x = EU_test, y = lookup, by = "num2", all.x = TRUE)
EU_fin <- cbind(EU_test2$NewID.x, EU_test2$NewID.y)
EU_fin_df_econ <- data.frame(EU_fin)

#get coordinates of polygon centroids
centroid.coords<- data.frame(trueCentroidsecon)
centroid.coords$X1 <- seq(from=10001, to= 13960, by=1)
centroid.coords$X2 <- seq(from=10001, to= 13960, by=1)
EU_fin_df_econ_X0<- EU_fin_df_econ[,1]
EU_fin_df_econ_X1<- EU_fin_df_econ[,2]
#X0 <- merge(EU_fin_df_nocon, centroid.coords, by= "X1")
cent1 <- merge(x = EU_fin_df_econ, y = centroid.coords, by = "X1", all.x = TRUE)
colnames(cent1) <- c("X1", "X2", "x", "y", "X2.y")
cent2 <- merge(x = cent1, y = centroid.coords, by = "X2", all.x = TRUE)
X0 <- cent2[, 3]
y0 <- cent2[, 4]
X1 <- cent2[, 6]
y1 <- cent2[, 7]
cent_coords_comb <- cbind(X0, y0, X1, y1)
colnames(cent_coords_comb) <- c("x0", "y0", "x1", "y1")
cent_df_econ <- data.frame(cent_coords_comb)

trueCentroidsecon$area_ha <- econ_poly$area_ha

veg_econ <- raster(paste("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_econ_strat/output/bio-reclass1-80.img",sep=""))
crs(veg_econ) <- "+proj=utm +zone=17 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs"
extent(veg_econ)<-raster::extent(Ecoregion)
mygray <- gray.colors(5, start = 0.2, end=0.8, gamma=2)
plot(veg_econ, main = "Habitat links economic", col=mygray, axes= FALSE, legend = FALSE)
points(trueCentroidsecon, pch=1, cex= trueCentroidsecon$area_ha^0.25)
segments(cent_df_econ$x0,                            # Draw multiple lines
         cent_df_econ$y0,
         cent_df_econ$x1,
         cent_df_econ$y1, col=alpha("lightblue1", 0.15))
