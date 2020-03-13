library(raster); options(scipen=999)
library(plyr)
library(dplyr)
library(sp)
library(rgdal)

NC_TREE <- read.csv("C:/Users/tgmozele/Desktop/TREE_tbls/NC_TREE.csv") #load NC_Tree table
#SC_TREE <- read.csv("C:/Users/tgmozele/Desktop/TREE_tbls/SC_TREE.csv") #load NC_Tree table
#VA_TREE <- read.csv("C:/Users/tgmozele/Desktop/TREE_tbls/VA_TREE.csv") #load NC_Tree table
#All_TREE <- rbind(NC_TREE, SC_TREE, VA_TREE)

# Bring in species excel file for my species of interest
spp_file <- read.csv("C:/Users/tgmozele/Desktop/TREE_tbls/spp_code.csv")
spp <- spp_file[,"FIA.code"] # isolate FIA spp codes for my focal species

#This selects just the 11 species of interest from all the species in the FIA plots. Ignores other species.
#tree_data <- All_TREE[All_TREE$SPCD %in% spp,]
tree_data_NC <- NC_TREE[NC_TREE$SPCD %in% spp,]

#Years of intrest, must be selected because we will auto filter to one round of plots#
years <- c(2007:2017)
#tree_data <- tree_data[(tree_data$INVYR %in% years),]
tree_data_NC <- tree_data_NC[(tree_data_NC$INVYR %in% years),]



FIA_study <- read.csv("C:/Users/tgmozele/Desktop/TREE_tbls/FIA_analysis.csv")
FIA <- FIA_study[,"PLT_CN"]
tree_data_study <- tree_data_NC[tree_data_NC$PLT_CN %in% FIA,]
tree_data_study$BA <- tree_data_study$DIA^2 * 0.005454
#tree_data_study$BAplt <- tree_data_study$BA * 3
tree_data_study$BAplt <- tree_data_study$BA * tree_data_study$TPA_UNADJ * 2.47

###Get the name of the plot numbers and aggregate plots by those CNs
#plot_numbers<-tree_data$CN
#tree_data_cn<-aggregate(tree_data$CN, by=list(CN=tree_data$CN),length)

uniquepltcn<-unique(tree_data_study$PLT_CN)

length(uniquepltcn)

#### Set a Null output
Plt_dataframeBA<-NULL


##forloop to find biomass by PLT CN!!!!!!!!!!!! 
#for( i in 1:length(uniquepltcn)) {
  
  #Plt_try <- tree_data_study[tree_data_study$PLT_CN==uniquepltcn[i],]
#Plt_try$carboncombined <- Plt_try$CARBON_AG * Plt_try$TPA_UNADJ
#Plt_try$carboncombined[is.na(Plt_try$carboncombined)] <- 0
#row <- cbind(uniquepltcn[i], sum(Plt_try$carboncombined))
#Plt_dataframe <- rbind(row, Plt_dataframe)
#  }

#forloop to find basal area of FIA data by PLT CN
for( i in 1:length(uniquepltcn)) {

  Plt_tryBA <- tree_data_study[tree_data_study$PLT_CN==uniquepltcn[i],]
  na.omit(Plt_tryBA)
  rowBA <- cbind(uniquepltcn[i], sum(Plt_tryBA$BAplt))
  Plt_dataframeBA <- rbind(rowBA, Plt_dataframeBA)
}

is.na(Plt_dataframeBA)

Plt_BA <- na.omit(Plt_dataframeBA)

w_dir<-"C:/Users/tgmozele/Desktop/TREE_tbls/"
setwd(w_dir)

#find BA Ty Wilson
TWfiles <- c("s110.img", "s121.img", "s131.img", "s132.img", "s316.img",
           "s491.img", "s611.img", "s621.img", "s711.img", "s802.img",
           "s819.img")
t <- stack(TWfiles)
plot(t)
TWsum <- sum(t)
plot(TWsum)


library(rgdal)
crop_extent <- readOGR("C:/Users/tgmozele/Desktop/TREE_tbls/Study_extent/studyextent.shp")
crop_extent <- spTransform(crop_extent, CRS(proj4string(t)))
plot(crop_extent)

TW_crop <- crop(TWsum, extent(crop_extent))
TW_mask <-mask(TW_crop, crop_extent)
plot(TW_mask, main = "Cropped TW")


# Get the extent of each raster
TWExtent<-extent(TW_mask)
# Extract each pixel value for r1 into a dataframe
TWExtraction<-extract(TW_mask,TWExtent, df=TRUE, cellnumbers=TRUE)
TWExtraction$biomass_sums <- rowSums(sExtraction[3:13])
BioM <- cbind(sExtraction$cell, sExtraction$biomass_sums)
length(BioM)

BioM[which(BioM==0)] = NA
BioM_Complete <- na.omit(BioM)
length(BioM_Complete)
BioLANDIS <- BioM_Complete[,2]





# Get the extent of each raster
sExtent<-extent(s)
# Extract each pixel value for r1 into a dataframe
sExtraction<-extract(s,sExtent, df=TRUE, cellnumbers=TRUE)
sExtraction$biomass_sums <- rowSums(sExtraction[3:13])
BioM <- cbind(sExtraction$cell, sExtraction$biomass_sums)
length(BioM)

BioM[which(BioM==0)] = NA
BioM_Complete <- na.omit(BioM)
length(BioM_Complete)
BioLANDIS <- BioM_Complete[,2]


BioM_Calcs <- read.csv("C:/Users/tgmozele/Desktop/TREE_tbls/biomass_calcs.csv")
BioFIA <- BioM_Calcs$biomass_u

files <- c("Biomass/AcerRubr-ageclass-0.img", "Biomass/CornFlor-ageclass-0.img", "Biomass/LiquStyr-ageclass-0.img", "Biomass/LiriTuli-ageclass-0.img", 
           "Biomass/OxydArbo-ageclass-0.img", "Biomass/PinuEchi-ageclass-0.img", "Biomass/PinuPalu-ageclass-0.img", "Biomass/PinuTaed-ageclass-0.img", 
           "Biomass/PinuVirg-ageclass-0.img", "Biomass/QuerAlba-ageclass-0.img", "Biomass/QuerLaev-ageclass-0.img")
s <- stack(files)
plot(s)
LANDISsum <- sum(s)
plot(LANDISsum)


AgeGraphs<-read.csv("C:/Users/tgmozele/Desktop/TREE_tbls/Sorenson's_FIA_AGE_TREE_HT_5_6.csv")
AgeGraphs$BA <- AgeGraphs$DIA^2 * 0.005454 * AgeGraphs$TPA_UNADJ *2.47
####This is step one. 
Plts<-unique(AgeGraphs$PLT_CN)
output<-NULL
for(i in 1:length(Plts)){
  print(i)
  One<-as.data.frame(AgeGraphs[AgeGraphs$PLT_CN==Plts[i],])
  plt<-Plts[i]                                                    ####This needs to be changed to BA (or diam)
  IC<-aggregate(One$BA,by=list(One$PLT_CN),FUN=sum) #change from age to basal area!!!!!!!!!!!!
  IC$PLT_CN<-plt
  colnames(IC)<-c("PLT_CN","BA")
  output<-rbind(IC,output)
}


outputDF<-as.data.frame(output)
outputDF <- outputDF[, -3]

outputBA <- na.omit(outputDF)

###This is the outpput of the sorrensons association
Crosswalk<-read.csv("C:/Users/tgmozele/Desktop/TREE_tbls/NSS_6_3.csv")[,c("cell","Closestplot")]

colnames(Crosswalk)<-c("cell","PLT_CN")
CrosswalkDF <- as.data.frame(Crosswalk)

#i = 131
#One<-as.data.frame(output[output$SPCD==i,])
###Change ot BA
#IC_under<-aggregate(One$BA,by=list(PLT_CN=One$PLT_CN),FUN=mean)
CellswithValues<-join(CrosswalkDF, outputBA, by ="PLT_CN")

#CellswithValues[is.na(CellswithValues)]<-0
LANDIS_BA <- na.omit(CellswithValues)
Print<-LANDIS_BA[order(LANDIS_BA$Cell),]

``
Plots<-CellswithValues$x


#find cumulative distribution function (CDF) for FIA and LANDIS biomass
P1 <- ecdf(BioFIA)
P2 <- ecdf(BioLANDIS)

#plot both CDF curves on the same plot. These two lines must be run AT THE SAME TIME! So highlight both to run simulatenously.
plot(P1)
lines(P2)


df1 <- data.frame(Biomass)
df2 <- data.frame(Biom2)

install.packages("EnvStats")
library(EnvStats)


pdfFIA <- density(Plt_BA[,2])
pdfLANDIS <- density(LANDIS_BA[,3])
pdfTW <- density(TW_mask)

plot(pdfFIA)
plot(pdfLANDIS)

plot(pdfLANDIS)
lines(pdfFIA, col="red")
lines (pdfTW, col="blue")

install.packages("ggplot2")
install.packages("gridExtra")
library(ggplot2)
library(gridExtra)

par(mfrow = c(2,2))


#Aggregate data by PLT CN!!!!!!!!!!!!!!
Plt_agg <- aggregate(tree_data_study$CARBON_AG, by = list(tree_data_study$PLT_CN), FUN=sum)

######################################################################################################
#plt_cn_file <- read.csv("C:/Users/tgmozele/Desktop/TREE_tbls/FIA_analysis_PLTCN.csv")
#pltcn <- plt_cn_file[,"PLT_CN"]
#tree_data_cn <- tree_data[tree_data$PLT_CN %in% pltcn,]

tree_abrev <- tree_data_cn[, c(2,111,121)]

BIOMASS <- (tree_abrev[,2] * tree_abrev[,3])
tree_abrev <- cbind(BIOMASS, tree_abrev)
tree_abrev2<-tree_abrev[!is.na(tree_abrev$BIOMASS),]
tree_abrev[is.na(tree_abrev$BIOMASS),]<-0.0

# Get the unique tree species in each PLT CN (will take a minute or so to run)- code from Melissa's script
#uspecies_treedata <- aggregate(tree_data$SPCD, by = list(PLT_CN = tree_data$PLT_CN), unique)
#unique_cn <- unique(uspecies_treedata[[1]])

ucn_treedata <- aggregate(tree_abrev$PLT_CN, by = list(PLT_CN = tree_abrev$PLT_CN), unique)
#unique_cn <- unique(ucn_treedata[[1]])
unique_cn <- ucn_treedata[,"PLT_CN"]

#unique_cn <- unique(tree_abrev$PLT_CN)

biomass_df <- NULL

for (i in unique_cn) {
  u_pltcn <- tree_abrev[tree_abrev$PLT_CN == i,]
  biomass <- sum(u_pltcn$BIOMASS)
  row <- cbind(i, biomass)
  biomass_df <- rbind(row, biomass_df)
}

write.csv(biomass_df,"C:/Users/tgmozele/Desktop/TREE_tbls/biomass_calcs.csv")

setwd("C:/Users/tgmozele/Desktop/TREE_tbls/")
biomass <- read.csv("biomass_calcs.csv")
hist(biomass$biomass_u, 40)


