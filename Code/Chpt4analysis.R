library(rgdal)
library(RColorBrewer)
library(raster)
library(ggplot2)
library(gtable)
library(grid)
library(gridExtra)
library(patchwork)
library(igraph)
library(cowplot)
library(egg)

############### CC No LUC ###############
setwd("Z:/ser2par10/")

RCP <- c("RCP45","RCP85")
rep <- c("bcc","CNRM","Had-GEM","IPSL","NorESM")

for (g in RCP){
  alldata<- NULL
  
  for (r in rep){
    #c="cluster"
    #r="2"
    dataset <- read.table(paste0("Z:/ser2par10/",r,"_",g,"/results_all_overall_indices.txt"), header=FALSE)
    #dataset$rep <- paste0(r)
    #dataset$RCP <- paste0(g)
    #dataset$LUC <- "NoLUC"
    #rownames(dataset$V1) <- c("time","")
    alldata <- rbind(alldata, dataset)
    assign(paste0(r,g,"NoLUC"), dataset)
  }
  assign(paste0(g,"NoLUC_all"), alldata)
}

############### CC LUC ###############
setwd("Z:/ser2par9/")

RCP <- c("RCP45","RCP85")
rep <- c("bcc","CNRM","Had-GEM","IPSL","NorESM")

for (g in RCP){
  alldata<- NULL
  
  for (r in rep){
    #c="cluster"
    #r="2"
    dataset <- read.table(paste0("Z:/ser2par9/",r,"_",g,"/results_all_overall_indices.txt"), header=FALSE)
    #dataset$rep <- paste0(r)
    #dataset$RCP <- paste0(g)
    #dataset$LUC <- "LUC"
    #rownames(dataset$V1) <- c("time","")
    alldata <- rbind(alldata, dataset)
    assign(paste0(r,g,"LUC"), dataset)
  }
  assign(paste0(g,"LUC_all"), alldata)
}

############### conservation ###############
setwd("Z:/ser2par11/")

RCP <- c("RCP45","RCP85")
rep <- c("cluster","geo")
LUC <- c("NoLUC","LUC")

for (g in RCP){
  alldata<- NULL
  
  for (r in rep){
    
    for (l in LUC){
      dataset <- read.table(paste0("Z:/ser2par11/bcc_",r,l,"_",g,"/results_all_overall_indices.txt"), header=FALSE)
      #dataset$rep <- paste0(r)
      #dataset$RCP <- paste0(g)
      #dataset$LUC <- paste0(l)
      #rownames(dataset$V1) <- c("time","")
      alldata <- rbind(alldata, dataset)
      assign(paste0(r,g,l,"bcc"), dataset)
    }
    assign(paste0(r,"bcc_all"), alldata)
  }
}

for (g in RCP){
  alldata<- NULL
  
  for (r in rep){
    
    for (l in LUC){
    #dataset <- read.table(paste0("Z:/ser2par11/CNRM_",r,l,"_",g,"/results_all_overall_indices.txt"), header=FALSE)
    #dataset$rep <- paste0(r)
    #dataset$RCP <- paste0(g)
    #dataset$LUC <- paste0(l)
    #rownames(dataset$V1) <- c("time","")
    alldata <- rbind(alldata, dataset)
    assign(paste0(r,g,l,"CNRM"), dataset)
  }
  assign(paste0(r,"CNRM_all"), alldata)
}
}

setwd("Z:/ser2par12/")

RCP <- c("RCP45","RCP85")
rep <- c("cluster","geo")
LUC <- c("NoLUC","LUC")

for (g in RCP){
  alldata<- NULL
  
  for (r in rep){
    
    for (l in LUC){
      dataset <- read.table(paste0("Z:/ser2par12/Had-GEM_",r,l,"_",g,"/results_all_overall_indices.txt"), header=FALSE)
      #dataset$rep <- paste0(r)
      #dataset$RCP <- paste0(g)
      #dataset$LUC <- paste0(l)
      #rownames(dataset$V1) <- c("time","")
      alldata <- rbind(alldata, dataset)
      assign(paste0(r,g,l,"Had-GEM"), dataset)
    }
    assign(paste0(r,"Had-GEM_all"), alldata)
  }
}


for (g in RCP){
  alldata<- NULL
  
  for (r in rep){
    
    for (l in LUC){
      dataset <- read.table(paste0("Z:/ser2par12/IPSL_",r,l,"_",g,"/results_all_overall_indices.txt"), header=FALSE)
      #dataset$rep <- paste0(r)
      #dataset$RCP <- paste0(g)
      #dataset$LUC <- paste0(l)
      #rownames(dataset$V1) <- c("time","")
      alldata <- rbind(alldata, dataset)
      assign(paste0(r,g,l,"IPSL"), dataset)
    }
    assign(paste0(r,"IPSL_all"), alldata)
  }
}

setwd("Z:/ser2par13/")

RCP <- c("RCP45","RCP85")
rep <- c("cluster","geo")
LUC <- c("NoLUC","LUC")

for (g in RCP){
  alldata<- NULL
  
  for (r in rep){
    
    for (l in LUC){
      dataset <- read.table(paste0("Z:/ser2par13/NorESM_",r,l,"_",g,"/results_all_overall_indices.txt"), header=FALSE)
      #dataset$rep <- paste0(r)
      #dataset$RCP <- paste0(g)
      #dataset$LUC <- paste0(l)
      #rownames(dataset$V1) <- c("time","")
      alldata <- rbind(alldata, dataset)
      assign(paste0(r,g,l,"NorESM"), dataset)
    }
    assign(paste0(r,"NorESM_all"), alldata)
  }
}


################### graphs ########################

###habitat patches change graphs###
setwd("Z:/CC_LUC_connectivity/")
RCP <- c("RCP45","RCP85")
rep <- c("clusterLUC","clusterNoLUC","geoLUC","geoNoLUC","LUC","NoLUC")
study_area <-readOGR("Z:/Study extent/sa_reproj.shp")

for (g in RCP){
  #g="RCP45"
  for (r in rep){
    #r="clusterLUC"
    files <- list.files(paste0(g,"/",r,"/"), pattern =paste0("s.tif$",sep=""))
    ManyRunsStack<-raster::stack(paste0(g,"/",r,"/",files))
    SumStack<-sum(ManyRunsStack)
    mask <- mask(SumStack, study_area)
    assign(paste0(g,r,"_nodes"), mask)
    
  }
}


###ECA graphs###
RCP45LUC_all$time <- c(0,0,0,0,0,10,10,10,10,10,20,20,20,20,20,30,30,30,30,30,40,40,40,40,40,50,50,50,50,50,60,60,60,60,60,70,70,70,70,70,80,80,80,80,80,
                      0,0,0,0,0,10,10,10,10,10,20,20,20,20,20,30,30,30,30,30,40,40,40,40,40,50,50,50,50,50,60,60,60,60,60,70,70,70,70,70,80,80,80,80,80,
                      0,0,0,0,0,10,10,10,10,10,20,20,20,20,20,30,30,30,30,30,40,40,40,40,40,50,50,50,50,50,60,60,60,60,60,70,70,70,70,70,80,80,80,80,80,
                      0,0,0,0,0,10,10,10,10,10,20,20,20,20,20,30,30,30,30,30,40,40,40,40,40,50,50,50,50,50,60,60,60,60,60,70,70,70,70,70,80,80,80,80,80,
                      0,0,0,0,0,10,10,10,10,10,20,20,20,20,20,30,30,30,30,30,40,40,40,40,40,50,50,50,50,50,60,60,60,60,60,70,70,70,70,70,80,80,80,80,80)
RCP85LUC_all$time <- c(0,0,0,0,0,10,10,10,10,10,20,20,20,20,20,30,30,30,30,30,40,40,40,40,40,50,50,50,50,50,60,60,60,60,60,70,70,70,70,70,80,80,80,80,80,
                  0,0,0,0,0,10,10,10,10,10,20,20,20,20,20,30,30,30,30,30,40,40,40,40,40,50,50,50,50,50,60,60,60,60,60,70,70,70,70,70,80,80,80,80,80,
                  0,0,0,0,0,10,10,10,10,10,20,20,20,20,20,30,30,30,30,30,40,40,40,40,40,50,50,50,50,50,60,60,60,60,60,70,70,70,70,70,80,80,80,80,80,
                  0,0,0,0,0,10,10,10,10,10,20,20,20,20,20,30,30,30,30,30,40,40,40,40,40,50,50,50,50,50,60,60,60,60,60,70,70,70,70,70,80,80,80,80,80,
                  0,0,0,0,0,10,10,10,10,10,20,20,20,20,20,30,30,30,30,30,40,40,40,40,40,50,50,50,50,50,60,60,60,60,60,70,70,70,70,70,80,80,80,80,80)
RCP45NoLUC_all$time <- c(0,0,0,0,0,10,10,10,10,10,20,20,20,20,20,30,30,30,30,30,40,40,40,40,40,50,50,50,50,50,60,60,60,60,60,70,70,70,70,70,80,80,80,80,80,
                    0,0,0,0,0,10,10,10,10,10,20,20,20,20,20,30,30,30,30,30,40,40,40,40,40,50,50,50,50,50,60,60,60,60,60,70,70,70,70,70,80,80,80,80,80,
                    0,0,0,0,0,10,10,10,10,10,20,20,20,20,20,30,30,30,30,30,40,40,40,40,40,50,50,50,50,50,60,60,60,60,60,70,70,70,70,70,80,80,80,80,80,
                    0,0,0,0,0,10,10,10,10,10,20,20,20,20,20,30,30,30,30,30,40,40,40,40,40,50,50,50,50,50,60,60,60,60,60,70,70,70,70,70,80,80,80,80,80,
                    0,0,0,0,0,10,10,10,10,10,20,20,20,20,20,30,30,30,30,30,40,40,40,40,40,50,50,50,50,50,60,60,60,60,60,70,70,70,70,70,80,80,80,80,80)
RCP85NoLUC_all$time <- c(0,0,0,0,0,10,10,10,10,10,20,20,20,20,20,30,30,30,30,30,40,40,40,40,40,50,50,50,50,50,60,60,60,60,60,70,70,70,70,70,80,80,80,80,80,
                    0,0,0,0,0,10,10,10,10,10,20,20,20,20,20,30,30,30,30,30,40,40,40,40,40,50,50,50,50,50,60,60,60,60,60,70,70,70,70,70,80,80,80,80,80,
                    0,0,0,0,0,10,10,10,10,10,20,20,20,20,20,30,30,30,30,30,40,40,40,40,40,50,50,50,50,50,60,60,60,60,60,70,70,70,70,70,80,80,80,80,80,
                    0,0,0,0,0,10,10,10,10,10,20,20,20,20,20,30,30,30,30,30,40,40,40,40,40,50,50,50,50,50,60,60,60,60,60,70,70,70,70,70,80,80,80,80,80,
                    0,0,0,0,0,10,10,10,10,10,20,20,20,20,20,30,30,30,30,30,40,40,40,40,40,50,50,50,50,50,60,60,60,60,60,70,70,70,70,70,80,80,80,80,80)

RCP45LUC_all$scenario = "LUC"
RCP45LUC_split<-split(RCP45LUC_all, RCP45LUC_all$V4)
RCP45LUC_EC <- RCP45LUC_split$`EC(PC)`
RCP45LUC_intra <- RCP45LUC_split$`PCintra(%)`
RCP45LUC_direct <- RCP45LUC_split$`PCdirect(%)`
RCP45LUC_step <- RCP45LUC_split$`PCstep(%)`

RCP85LUC_all$scenario = "LUC"
RCP85LUC_split<-split(RCP85LUC_all, RCP85LUC_all$V4)
RCP85LUC_EC <- RCP85LUC_split$`EC(PC)`
RCP85LUC_intra <- RCP85LUC_split$`PCintra(%)`
RCP85LUC_direct <- RCP85LUC_split$`PCdirect(%)`
RCP85LUC_step <- RCP85LUC_split$`PCstep(%)`

RCP45NoLUC_all$scenario = "NoLUC"
RCP45NoLUC_split<-split(RCP45NoLUC_all, RCP45NoLUC_all$V4)
RCP45NoLUC_EC <- RCP45NoLUC_split$`EC(PC)`
RCP45NoLUC_intra <- RCP45NoLUC_split$`PCintra(%)`
RCP45NoLUC_direct <- RCP45NoLUC_split$`PCdirect(%)`
RCP45NoLUC_step <- RCP45NoLUC_split$`PCstep(%)`

RCP85NoLUC_all$scenario = "NoLUC"
RCP85NoLUC_split<-split(RCP85NoLUC_all, RCP85NoLUC_all$V4)
RCP85NoLUC_EC <- RCP85NoLUC_split$`EC(PC)`
RCP85NoLUC_intra <- RCP85NoLUC_split$`PCintra(%)`
RCP85NoLUC_direct <- RCP85NoLUC_split$`PCdirect(%)`
RCP85NoLUC_step <- RCP85NoLUC_split$`PCstep(%)`



cluster_RCP45_LUC_all <- rbind(clusterRCP45LUCbcc,clusterRCP45LUCCNRM,`clusterRCP45LUCHad-GEM`,clusterRCP45LUCIPSL,clusterRCP45LUCNorESM)
cluster_RCP45_LUC_all$time <- c(0,0,0,0,0,10,10,10,10,10,20,20,20,20,20,30,30,30,30,30,40,40,40,40,40,50,50,50,50,50,60,60,60,60,60,70,70,70,70,70,80,80,80,80,80,
                               0,0,0,0,0,10,10,10,10,10,20,20,20,20,20,30,30,30,30,30,40,40,40,40,40,50,50,50,50,50,60,60,60,60,60,70,70,70,70,70,80,80,80,80,80,
                               0,0,0,0,0,10,10,10,10,10,20,20,20,20,20,30,30,30,30,30,40,40,40,40,40,50,50,50,50,50,60,60,60,60,60,70,70,70,70,70,80,80,80,80,80,
                               0,0,0,0,0,10,10,10,10,10,20,20,20,20,20,30,30,30,30,30,40,40,40,40,40,50,50,50,50,50,60,60,60,60,60,70,70,70,70,70,80,80,80,80,80,
                               0,0,0,0,0,10,10,10,10,10,20,20,20,20,20,30,30,30,30,30,40,40,40,40,40,50,50,50,50,50,60,60,60,60,60,70,70,70,70,70,80,80,80,80,80)
cluster_RCP45_NoLUC_all<- rbind(clusterRCP45NoLUCbcc,clusterRCP45NoLUCCNRM,`clusterRCP45NoLUCHad-GEM`,clusterRCP45NoLUCIPSL,clusterRCP45NoLUCNorESM)
cluster_RCP45_NoLUC_all$time <- c(0,0,0,0,0,10,10,10,10,10,20,20,20,20,20,30,30,30,30,30,40,40,40,40,40,50,50,50,50,50,60,60,60,60,60,70,70,70,70,70,80,80,80,80,80,
                                0,0,0,0,0,10,10,10,10,10,20,20,20,20,20,30,30,30,30,30,40,40,40,40,40,50,50,50,50,50,60,60,60,60,60,70,70,70,70,70,80,80,80,80,80,
                                0,0,0,0,0,10,10,10,10,10,20,20,20,20,20,30,30,30,30,30,40,40,40,40,40,50,50,50,50,50,60,60,60,60,60,70,70,70,70,70,80,80,80,80,80,
                                0,0,0,0,0,10,10,10,10,10,20,20,20,20,20,30,30,30,30,30,40,40,40,40,40,50,50,50,50,50,60,60,60,60,60,70,70,70,70,70,80,80,80,80,80,
                                0,0,0,0,0,10,10,10,10,10,20,20,20,20,20,30,30,30,30,30,40,40,40,40,40,50,50,50,50,50,60,60,60,60,60,70,70,70,70,70,80,80,80,80,80)
cluster_RCP85_LUC_all<- rbind(clusterRCP85LUCbcc,clusterRCP85LUCCNRM,`clusterRCP85LUCHad-GEM`,clusterRCP85LUCIPSL,clusterRCP85LUCNorESM)
cluster_RCP85_LUC_all$time <- c(0,0,0,0,0,10,10,10,10,10,20,20,20,20,20,30,30,30,30,30,40,40,40,40,40,50,50,50,50,50,60,60,60,60,60,70,70,70,70,70,80,80,80,80,80,
                                0,0,0,0,0,10,10,10,10,10,20,20,20,20,20,30,30,30,30,30,40,40,40,40,40,50,50,50,50,50,60,60,60,60,60,70,70,70,70,70,80,80,80,80,80,
                                0,0,0,0,0,10,10,10,10,10,20,20,20,20,20,30,30,30,30,30,40,40,40,40,40,50,50,50,50,50,60,60,60,60,60,70,70,70,70,70,80,80,80,80,80,
                                0,0,0,0,0,10,10,10,10,10,20,20,20,20,20,30,30,30,30,30,40,40,40,40,40,50,50,50,50,50,60,60,60,60,60,70,70,70,70,70,80,80,80,80,80,
                                0,0,0,0,0,10,10,10,10,10,20,20,20,20,20,30,30,30,30,30,40,40,40,40,40,50,50,50,50,50,60,60,60,60,60,70,70,70,70,70,80,80,80,80,80)
cluster_RCP85_NoLUC_all<- rbind(clusterRCP85NoLUCbcc,clusterRCP85NoLUCCNRM,`clusterRCP85NoLUCHad-GEM`,clusterRCP85NoLUCIPSL,clusterRCP85NoLUCNorESM)
cluster_RCP85_NoLUC_all$time <- c(0,0,0,0,0,10,10,10,10,10,20,20,20,20,20,30,30,30,30,30,40,40,40,40,40,50,50,50,50,50,60,60,60,60,60,70,70,70,70,70,80,80,80,80,80,
                                0,0,0,0,0,10,10,10,10,10,20,20,20,20,20,30,30,30,30,30,40,40,40,40,40,50,50,50,50,50,60,60,60,60,60,70,70,70,70,70,80,80,80,80,80,
                                0,0,0,0,0,10,10,10,10,10,20,20,20,20,20,30,30,30,30,30,40,40,40,40,40,50,50,50,50,50,60,60,60,60,60,70,70,70,70,70,80,80,80,80,80,
                                0,0,0,0,0,10,10,10,10,10,20,20,20,20,20,30,30,30,30,30,40,40,40,40,40,50,50,50,50,50,60,60,60,60,60,70,70,70,70,70,80,80,80,80,80,
                                0,0,0,0,0,10,10,10,10,10,20,20,20,20,20,30,30,30,30,30,40,40,40,40,40,50,50,50,50,50,60,60,60,60,60,70,70,70,70,70,80,80,80,80,80)
geo_RCP45_LUC_all <- rbind(geoRCP45LUCbcc,geoRCP45LUCCNRM,`geoRCP45LUCHad-GEM`,geoRCP45LUCIPSL,geoRCP45LUCNorESM)
geo_RCP45_LUC_all$time <- c(0,0,0,0,0,10,10,10,10,10,20,20,20,20,20,30,30,30,30,30,40,40,40,40,40,50,50,50,50,50,60,60,60,60,60,70,70,70,70,70,80,80,80,80,80,
                                0,0,0,0,0,10,10,10,10,10,20,20,20,20,20,30,30,30,30,30,40,40,40,40,40,50,50,50,50,50,60,60,60,60,60,70,70,70,70,70,80,80,80,80,80,
                                0,0,0,0,0,10,10,10,10,10,20,20,20,20,20,30,30,30,30,30,40,40,40,40,40,50,50,50,50,50,60,60,60,60,60,70,70,70,70,70,80,80,80,80,80,
                                0,0,0,0,0,10,10,10,10,10,20,20,20,20,20,30,30,30,30,30,40,40,40,40,40,50,50,50,50,50,60,60,60,60,60,70,70,70,70,70,80,80,80,80,80,
                                0,0,0,0,0,10,10,10,10,10,20,20,20,20,20,30,30,30,30,30,40,40,40,40,40,50,50,50,50,50,60,60,60,60,60,70,70,70,70,70,80,80,80,80,80)
geo_RCP45_NoLUC_all<- rbind(geoRCP45NoLUCbcc,geoRCP45NoLUCCNRM,`geoRCP45NoLUCHad-GEM`,geoRCP45NoLUCIPSL,geoRCP45NoLUCNorESM)
geo_RCP45_NoLUC_all$time <- c(0,0,0,0,0,10,10,10,10,10,20,20,20,20,20,30,30,30,30,30,40,40,40,40,40,50,50,50,50,50,60,60,60,60,60,70,70,70,70,70,80,80,80,80,80,
                                  0,0,0,0,0,10,10,10,10,10,20,20,20,20,20,30,30,30,30,30,40,40,40,40,40,50,50,50,50,50,60,60,60,60,60,70,70,70,70,70,80,80,80,80,80,
                                  0,0,0,0,0,10,10,10,10,10,20,20,20,20,20,30,30,30,30,30,40,40,40,40,40,50,50,50,50,50,60,60,60,60,60,70,70,70,70,70,80,80,80,80,80,
                                  0,0,0,0,0,10,10,10,10,10,20,20,20,20,20,30,30,30,30,30,40,40,40,40,40,50,50,50,50,50,60,60,60,60,60,70,70,70,70,70,80,80,80,80,80,
                                  0,0,0,0,0,10,10,10,10,10,20,20,20,20,20,30,30,30,30,30,40,40,40,40,40,50,50,50,50,50,60,60,60,60,60,70,70,70,70,70,80,80,80,80,80)
geo_RCP85_LUC_all<- rbind(geoRCP85LUCbcc,geoRCP85LUCCNRM,`geoRCP85LUCHad-GEM`,geoRCP85LUCIPSL,geoRCP85LUCNorESM)
geo_RCP85_LUC_all$time <- c(0,0,0,0,0,10,10,10,10,10,20,20,20,20,20,30,30,30,30,30,40,40,40,40,40,50,50,50,50,50,60,60,60,60,60,70,70,70,70,70,80,80,80,80,80,
                                0,0,0,0,0,10,10,10,10,10,20,20,20,20,20,30,30,30,30,30,40,40,40,40,40,50,50,50,50,50,60,60,60,60,60,70,70,70,70,70,80,80,80,80,80,
                                0,0,0,0,0,10,10,10,10,10,20,20,20,20,20,30,30,30,30,30,40,40,40,40,40,50,50,50,50,50,60,60,60,60,60,70,70,70,70,70,80,80,80,80,80,
                                0,0,0,0,0,10,10,10,10,10,20,20,20,20,20,30,30,30,30,30,40,40,40,40,40,50,50,50,50,50,60,60,60,60,60,70,70,70,70,70,80,80,80,80,80,
                                0,0,0,0,0,10,10,10,10,10,20,20,20,20,20,30,30,30,30,30,40,40,40,40,40,50,50,50,50,50,60,60,60,60,60,70,70,70,70,70,80,80,80,80,80)
geo_RCP85_NoLUC_all<- rbind(geoRCP85NoLUCbcc,geoRCP85NoLUCCNRM,`geoRCP85NoLUCHad-GEM`,geoRCP85NoLUCIPSL,geoRCP85NoLUCNorESM)
geo_RCP85_NoLUC_all$time <- c(0,0,0,0,0,10,10,10,10,10,20,20,20,20,20,30,30,30,30,30,40,40,40,40,40,50,50,50,50,50,60,60,60,60,60,70,70,70,70,70,80,80,80,80,80,
                                  0,0,0,0,0,10,10,10,10,10,20,20,20,20,20,30,30,30,30,30,40,40,40,40,40,50,50,50,50,50,60,60,60,60,60,70,70,70,70,70,80,80,80,80,80,
                                  0,0,0,0,0,10,10,10,10,10,20,20,20,20,20,30,30,30,30,30,40,40,40,40,40,50,50,50,50,50,60,60,60,60,60,70,70,70,70,70,80,80,80,80,80,
                                  0,0,0,0,0,10,10,10,10,10,20,20,20,20,20,30,30,30,30,30,40,40,40,40,40,50,50,50,50,50,60,60,60,60,60,70,70,70,70,70,80,80,80,80,80,
                                  0,0,0,0,0,10,10,10,10,10,20,20,20,20,20,30,30,30,30,30,40,40,40,40,40,50,50,50,50,50,60,60,60,60,60,70,70,70,70,70,80,80,80,80,80)

cluster_RCP45_LUC_all$scenario = "clusterLUC"
cluster_RCP45_LUC_split<-split(cluster_RCP45_LUC_all, cluster_RCP45_LUC_all$V4)
cluster_RCP45_LUC_EC <- cluster_RCP45_LUC_split$`EC(PC)`
cluster_RCP45_LUC_intra <- cluster_RCP45_LUC_split$`PCintra(%)`
cluster_RCP45_LUC_direct <- cluster_RCP45_LUC_split$`PCdirect(%)`
cluster_RCP45_LUC_step <- cluster_RCP45_LUC_split$`PCstep(%)`

cluster_RCP45_NoLUC_all$scenario = "clusterNoLUC"
cluster_RCP45_NoLUC_split<-split(cluster_RCP45_NoLUC_all, cluster_RCP45_NoLUC_all$V4)
cluster_RCP45_NoLUC_EC <- cluster_RCP45_NoLUC_split$`EC(PC)`
cluster_RCP45_NoLUC_intra <- cluster_RCP45_NoLUC_split$`PCintra(%)`
cluster_RCP45_NoLUC_direct <- cluster_RCP45_NoLUC_split$`PCdirect(%)`
cluster_RCP45_NoLUC_step <- cluster_RCP45_NoLUC_split$`PCstep(%)`

cluster_RCP85_LUC_all$scenario = "clusterLUC"
cluster_RCP85_LUC_split<-split(cluster_RCP85_LUC_all, cluster_RCP85_LUC_all$V4)
cluster_RCP85_LUC_EC <- cluster_RCP85_LUC_split$`EC(PC)`
cluster_RCP85_LUC_intra <- cluster_RCP85_LUC_split$`PCintra(%)`
cluster_RCP85_LUC_direct <- cluster_RCP85_LUC_split$`PCdirect(%)`
cluster_RCP85_LUC_step <- cluster_RCP85_LUC_split$`PCstep(%)`

cluster_RCP85_NoLUC_all$scenario = "clusterNoLUC"
cluster_RCP85_NoLUC_split<-split(cluster_RCP85_NoLUC_all, cluster_RCP85_NoLUC_all$V4)
cluster_RCP85_NoLUC_EC <- cluster_RCP85_NoLUC_split$`EC(PC)`
cluster_RCP85_NoLUC_intra <- cluster_RCP85_NoLUC_split$`PCintra(%)`
cluster_RCP85_NoLUC_direct <- cluster_RCP85_NoLUC_split$`PCdirect(%)`
cluster_RCP85_NoLUC_step <- cluster_RCP85_NoLUC_split$`PCstep(%)`

geo_RCP45_LUC_all$scenario = "geoLUC"
geo_RCP45_LUC_split<-split(geo_RCP45_LUC_all, geo_RCP45_LUC_all$V4)
geo_RCP45_LUC_EC <- geo_RCP45_LUC_split$`EC(PC)`
geo_RCP45_LUC_intra <- geo_RCP45_LUC_split$`PCintra(%)`
geo_RCP45_LUC_direct <- geo_RCP45_LUC_split$`PCdirect(%)`
geo_RCP45_LUC_step <- geo_RCP45_LUC_split$`PCstep(%)`

geo_RCP45_NoLUC_all$scenario = "geoNoLUC"
geo_RCP45_NoLUC_split<-split(geo_RCP45_NoLUC_all, geo_RCP45_NoLUC_all$V4)
geo_RCP45_NoLUC_EC <- geo_RCP45_NoLUC_split$`EC(PC)`
geo_RCP45_NoLUC_intra <- geo_RCP45_NoLUC_split$`PCintra(%)`
geo_RCP45_NoLUC_direct <- geo_RCP45_NoLUC_split$`PCdirect(%)`
geo_RCP45_NoLUC_step <- geo_RCP45_NoLUC_split$`PCstep(%)`

geo_RCP85_LUC_all$scenario = "geoLUC"
geo_RCP85_LUC_split<-split(geo_RCP85_LUC_all, geo_RCP85_LUC_all$V4)
geo_RCP85_LUC_EC <- geo_RCP85_LUC_split$`EC(PC)`
geo_RCP85_LUC_intra <- geo_RCP85_LUC_split$`PCintra(%)`
geo_RCP85_LUC_direct <- geo_RCP85_LUC_split$`PCdirect(%)`
geo_RCP85_LUC_step <- geo_RCP85_LUC_split$`PCstep(%)`

geo_RCP85_NoLUC_all$scenario = "geoNoLUC"
geo_RCP85_NoLUC_split<-split(geo_RCP85_NoLUC_all, geo_RCP85_NoLUC_all$V4)
geo_RCP85_NoLUC_EC <- geo_RCP85_NoLUC_split$`EC(PC)`
geo_RCP85_NoLUC_intra <- geo_RCP85_NoLUC_split$`PCintra(%)`
geo_RCP85_NoLUC_direct <- geo_RCP85_NoLUC_split$`PCdirect(%)`
geo_RCP85_NoLUC_step <- geo_RCP85_NoLUC_split$`PCstep(%)`

cols=c(5,9,10)
RCP45_EC<- rbind(RCP45NoLUC_EC,RCP45LUC_EC,cluster_RCP45_NoLUC_EC,cluster_RCP45_LUC_EC,geo_RCP45_NoLUC_EC,geo_RCP45_LUC_EC)
RCP45_EC<- RCP45_EC[cols]
RCP85_EC<- rbind(RCP85NoLUC_EC,RCP85LUC_EC,cluster_RCP85_NoLUC_EC,cluster_RCP85_LUC_EC,geo_RCP85_NoLUC_EC,geo_RCP85_LUC_EC)
RCP85_EC<- RCP85_EC[cols]

RCP45_intra<- rbind(RCP45NoLUC_intra,RCP45LUC_intra,cluster_RCP45_NoLUC_intra,cluster_RCP45_LUC_intra,geo_RCP45_NoLUC_intra,geo_RCP45_LUC_intra)
RCP85_intra<- rbind(RCP85NoLUC_intra,RCP85LUC_intra,cluster_RCP85_NoLUC_intra,cluster_RCP85_LUC_intra,geo_RCP85_NoLUC_intra,geo_RCP85_LUC_intra)

RCP45_direct<- rbind(RCP45NoLUC_direct,RCP45LUC_direct,cluster_RCP45_NoLUC_direct,cluster_RCP45_LUC_direct,geo_RCP45_NoLUC_direct,geo_RCP45_LUC_direct)
RCP85_direct<- rbind(RCP85NoLUC_direct,RCP85LUC_direct,cluster_RCP85_NoLUC_direct,cluster_RCP85_LUC_direct,geo_RCP85_NoLUC_direct,geo_RCP85_LUC_direct)

RCP45_step<- rbind(RCP45NoLUC_step,RCP45LUC_step,cluster_RCP45_NoLUC_step,cluster_RCP45_LUC_step,geo_RCP45_NoLUC_step,geo_RCP45_LUC_step)
RCP85_step<- rbind(RCP85NoLUC_step,RCP85LUC_step,cluster_RCP85_NoLUC_step,cluster_RCP85_LUC_step,geo_RCP85_NoLUC_step,geo_RCP85_LUC_step)

RCP45ec_plot <- ggplot(RCP45_EC) +
  theme(axis.text=element_text(size=14), axis.title=element_text(size=18), panel.border = element_rect(colour = "black", fill=NA, size=2)) +
  theme(plot.title = element_text(size = 22, face = "bold")) +
  #geom_point(aes(time, V5, group=scenario,color=scenario), size=2.0) +
  geom_smooth(method="loess", aes(x=time, y=V5,group=scenario,color=scenario), se=T) + 
  scale_color_manual(labels = c("cluster + land use change","cluster no land use change","geodiversity + land use change",
                               "geodiversity no land use change","no conservation + land use change","no conservation no land use change"),
                     values=c("cadetblue","darkslateblue","sienna1","sienna","slategray2","slategrey")) +
  scale_x_continuous(labels=c("2020", "2040", "2060","2080","2100")) +
  ggtitle("Equivalent Connected Area (ha): RCP45") +
  theme(legend.position="bottom") +
  theme(legend.title = element_blank()) +
  #theme(legend.position = "none") +
  #labs(x ="Hectares") +
  theme(axis.text.x = element_text(color="black", 
                                   size=14, angle=0),
        axis.text.y = element_text(color="black", 
                                   size=14, angle=0),
        axis.title.x = element_blank(),
        axis.title.y = element_blank()) +
  #annotate(geom="text", x=-2, y=57000, label="a",color="black",size=14) +
  ylim(10000,58000)
#RCP45ec_plot

RCP85ec_plot <- ggplot(RCP85_EC) +
  theme(axis.text=element_text(size=14), axis.title=element_text(size=18), panel.border = element_rect(colour = "black", fill=NA, size=2)) +
  theme(plot.title = element_text(size = 22, face = "bold")) +
  #geom_point(aes(time, V5, group=scenario,color=scenario), size=2.0) +
  geom_smooth(method="loess", aes(x=time, y=V5,group=scenario,color=scenario), se=T) + 
  scale_color_manual(labels = c("cluster LUC","cluster No LUC","geo LUC","geo No LUC","LUC","No LUC"),
                     values=c("cadetblue","darkslateblue","sienna1","sienna","slategray2","slategrey")) +
  scale_x_continuous(labels=c("2020", "2040", "2060","2080","2100")) +
  ggtitle("Equivalent Connected Area (ha): RCP85") +
  theme(legend.position = "none") +
  #labs(x ="Hectares") +
  theme(axis.text.x = element_text(color="black", 
                                   size=14, angle=0),
        axis.text.y = element_blank(),
        axis.title.x = element_blank(),
        axis.title.y = element_blank()) +
  #annotate(geom="text", x=-2, y=57000, label="b",color="black",size=14) +
  ylim(10000,58000)
#RCP85ec_plot

RCP45intra_plot <- ggplot(RCP45_intra) +
  theme(axis.text=element_text(size=14), axis.title=element_text(size=18), panel.border = element_rect(colour = "black", fill=NA, size=2)) +
  theme(plot.title = element_text(size = 22, face = "bold")) +
  geom_point(aes(time, V5, group=scenario,color=scenario), size=2.0) +
  geom_smooth(method="loess", aes(x=time, y=V5,group=scenario,color=scenario), se=T) + 
  scale_color_manual(labels = c("No LUC","LUC","cluster No LUC","cluster LUC","geodiversity No LUC","geodiversity LUC"),
                     values=c("cadetblue","darkslateblue","sienna1","sienna","slategray2","slategrey")) +
  ggtitle("ECA intra (% total ECA): RCP45") +
  theme(legend.position = "none") +
  theme(axis.text.x = element_blank(),
        axis.text.y = element_text(color="black", 
                                   size=14, angle=0),
        axis.title.x = element_blank(),
        axis.title.y = element_blank()) +
  annotate(geom="text", x=-2, y=83, label="c",color="black",size=14) +
  ylim(0,90)

RCP85intra_plot <- ggplot(RCP85_intra) +
  theme(axis.text=element_text(size=14), axis.title=element_text(size=18), panel.border = element_rect(colour = "black", fill=NA, size=2)) +
  theme(plot.title = element_text(size = 22, face = "bold")) +
  geom_point(aes(time, V5, group=scenario,color=scenario), size=2.0) +
  geom_smooth(method="loess", aes(x=time, y=V5,group=scenario,color=scenario), se=T) + 
  scale_color_manual(labels = c("No LUC","LUC","cluster No LUC","cluster LUC","geodiversity No LUC","geodiversity LUC"),
                     values=c("cadetblue","darkslateblue","sienna1","sienna","slategray2","slategrey")) +
  ggtitle("ECA intra (% total ECA): RCP85") +
  theme(legend.position = "none") +
  theme(axis.text.x = element_blank(),
        axis.text.y = element_blank(),
        axis.title.x = element_blank(),
        axis.title.y = element_blank()) +
  annotate(geom="text", x=-2, y=83, label="d",color="black",size=14) +
  ylim(0,90)

RCP45direct_plot <- ggplot(RCP45_direct) +
  theme(axis.text=element_text(size=14), axis.title=element_text(size=18), panel.border = element_rect(colour = "black", fill=NA, size=2)) +
  theme(plot.title = element_text(size = 22, face = "bold")) +
  geom_point(aes(time, V5, group=scenario,color=scenario), size=2.0) +
  geom_smooth(method="loess", aes(x=time, y=V5,group=scenario,color=scenario), se=T) + 
  scale_color_manual(labels = c("No LUC","LUC","cluster No LUC","cluster LUC","geodiversity No LUC","geodiversity LUC"),
                     values=c("cadetblue","darkslateblue","sienna1","sienna","slategray2","slategrey")) +
  ggtitle("ECA direct (% total ECA): RCP45") +
  theme(legend.position = "none") +
  theme(axis.text.x = element_blank(),
        axis.text.y = element_text(color="black", 
                                   size=14, angle=0),
        axis.title.x = element_blank(),
        axis.title.y = element_blank()) +
  annotate(geom="text", x=-2, y=27, label="e",color="black",size=14) +
  ylim(0,30)

RCP85direct_plot <- ggplot(RCP85_direct) +
  theme(axis.text=element_text(size=14), axis.title=element_text(size=18), panel.border = element_rect(colour = "black", fill=NA, size=2)) +
  theme(plot.title = element_text(size = 22, face = "bold")) +
  geom_point(aes(time, V5, group=scenario,color=scenario), size=2.0) +
  geom_smooth(method="loess", aes(x=time, y=V5,group=scenario,color=scenario), se=T) + 
  scale_color_manual(labels = c("No LUC","LUC","cluster No LUC","cluster LUC","geodiversity No LUC","geodiversity LUC"),
                     values=c("cadetblue","darkslateblue","sienna1","sienna","slategray2","slategrey")) +
  ggtitle("ECA direct (% total ECA): RCP85") +
  theme(legend.position = "none") +
  theme(axis.text.x = element_blank(),
        axis.text.y = element_blank(),
        axis.title.x = element_blank(),
        axis.title.y = element_blank()) +
  annotate(geom="text", x=-2, y=27, label="f",color="black",size=14) +
  ylim(0,30)

RCP45step_plot <- ggplot(RCP45_step) +
  theme(axis.text=element_text(size=14), axis.title=element_text(size=18), panel.border = element_rect(colour = "black", fill=NA, size=2)) +
  theme(plot.title = element_text(size = 22, face = "bold")) +
  geom_point(aes(time, V5, group=scenario,color=scenario), size=2.0) +
  geom_smooth(method="loess", aes(x=time, y=V5,group=scenario,color=scenario), se=T) + 
  scale_color_manual(labels = c("No LUC","LUC","cluster No LUC","cluster LUC","geodiversity No LUC","geodiversity LUC"),
                     values=c("cadetblue","darkslateblue","sienna1","sienna","slategray2","slategrey")) +
  scale_x_continuous(labels=c("2020", "2040", "2060","2080","2100")) +
  ggtitle("ECA step (% total ECA): RCP45") +
  theme(legend.position = "none") +
  theme(axis.text.x = element_text(color="black", 
                                   size=14, angle=0),
        axis.text.y = element_text(color="black", 
                                   size=14, angle=0),
        axis.title.x = element_blank(),
        axis.title.y = element_blank()) +
  annotate(geom="text", x=-2, y=83, label="g",color="black",size=14) +
  ylim(0,90)

RCP85step_plot <- ggplot(RCP85_step) +
  theme(axis.text=element_text(size=14), axis.title=element_text(size=18), panel.border = element_rect(colour = "black", fill=NA, size=2)) +
  theme(plot.title = element_text(size = 22, face = "bold")) +
  geom_point(aes(time, V5, group=scenario,color=scenario), size=2.0) +
  geom_smooth(method="loess", aes(x=time, y=V5,group=scenario,color=scenario), se=T) + 
  scale_color_manual(labels = c("No LUC","LUC","cluster No LUC","cluster LUC","geodiversity No LUC","geodiversity LUC"),
                     values=c("cadetblue","darkslateblue","sienna1","sienna","slategray2","slategrey")) +
  scale_x_continuous(labels=c("2020", "2040", "2060","2080","2100")) +
  ggtitle("ECA step (% total ECA): RCP85") +
  theme(legend.position = "none") +
  theme(axis.text.x = element_text(color="black", 
                                   size=14, angle=0),
        axis.text.y = element_blank(),
        axis.title.x = element_blank(),
        axis.title.y = element_blank()) +
  annotate(geom="text", x=-2, y=83, label="h",color="black",size=14) +
  ylim(0,90)

#ggarrange(RCP45ec_plot+theme(legend.position='hidden'),RCP85ec_plot,RCP45intra_plot,RCP85intra_plot,
          #RCP45direct_plot,RCP85direct_plot,RCP45step_plot,RCP85step_plot,nrow=4, bottom=bottom)

ggarrange(RCP45ec_plot+theme(legend.position='hidden'),RCP85ec_plot, nrow = 1,bottom=bottom)

#####################nodes and links graph############################
setwd("Z:/BAU_connectivity/CC_LUC_connectivity")

con<- c("Output_clusterLUC_RCP45","Output_clusterLUC_RCP85","Output_clusterNoLUC_RCP45","Output_clusterNoLUC_RCP85",
        "Output_geoLUC_RCP45","Output_geoLUC_RCP85","Output_geoNoLUC_RCP45","Output_geoNoLUC_RCP85",
        "Output_LUC_RCP45","Output_LUC_RCP85","Output_NoLUC_RCP45","Output_NoLUC_RCP85")

for (c in con){
  Drive<-paste0("Z:/CC_LUC_connectivity/",c)
  setwd(Drive)
  Metrics <- list.files(pattern=paste0("Metrics_"))
  dataset <- NULL
  for (d in Metrics){
    
    # if the merged dataset doesn't exist, create it
    if (!exists("dataset")){
      dataset <- read.table(d)
      dataset$con = paste0(c)
    }
    
    # if the merged dataset does exist, append to it
    if (exists("dataset")){
      temp_dataset <-read.table(d)
      temp_dataset$con = paste0(c)
      dataset<-rbind(dataset, temp_dataset)
      rm(temp_dataset)
    }
    assign(paste0(c,"_metrics"), dataset)
  }
}

Output_clusterLUC_RCP45_metrics$time <-c(0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,70,80)
Output_clusterLUC_RCP85_metrics$time <-c(0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,70,80)
Output_clusterNoLUC_RCP45_metrics$time <-c(0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,70,80)
Output_clusterNoLUC_RCP85_metrics$time <-c(0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,70,80)
Output_geoLUC_RCP45_metrics$time <-c(0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,70,80)
Output_geoLUC_RCP85_metrics$time <-c(0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,70,80)
Output_geoNoLUC_RCP45_metrics$time <-c(0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,70,80)
Output_geoNoLUC_RCP85_metrics$time <-c(0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,70,80)
Output_LUC_RCP45_metrics$time <-c(0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,70,80)
Output_LUC_RCP85_metrics$time <-c(0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,70,80)
Output_NoLUC_RCP45_metrics$time <-c(0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,70,80)
Output_NoLUC_RCP85_metrics$time <-c(0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,70,80)

RCP45_metrics <- rbind(Output_clusterLUC_RCP45_metrics,Output_clusterNoLUC_RCP45_metrics,Output_geoLUC_RCP45_metrics,Output_geoNoLUC_RCP45_metrics,
                       Output_LUC_RCP45_metrics,Output_NoLUC_RCP45_metrics)
RCP85_metrics <- rbind(Output_clusterLUC_RCP85_metrics,Output_clusterNoLUC_RCP85_metrics,Output_geoLUC_RCP85_metrics,Output_geoNoLUC_RCP85_metrics,
                       Output_LUC_RCP85_metrics,Output_NoLUC_RCP85_metrics)

RCP45nodes_plot <- ggplot(RCP45_metrics) +
  theme(axis.text=element_text(size=14), axis.title=element_text(size=18), panel.border = element_rect(colour = "black", fill=NA, size=2)) +
  theme(plot.title = element_text(size = 22, face = "bold")) +
  geom_point(aes(time, nodes, group=con,color=con), size=2.0) +
  #stat_summary(aes(x=time, y=nodes,group=spec,color=spec),fun=mean, geom="line") +
  geom_smooth(method="loess", aes(x=time, y=nodes,group=con,color=con), se=T) + 
  scale_color_manual(labels = c("No LUC","LUC","cluster No LUC","cluster LUC","geodiversity No LUC","geodiversity LUC"),
                     values=c("cadetblue","darkslateblue","sienna1","sienna","slategray2","slategrey")) +
  ggtitle("RCP45 nodes") +
  theme(legend.position = "none") +
  theme(axis.text.x = element_blank(),
        axis.text.y = element_text(color="black", 
                                   size=14, angle=0),
        axis.title.x = element_blank(),
        axis.title.y = element_blank()) +
  annotate(geom="text", x=3, y=28000, label="a",color="black",size=14) +
  ylim(0,30000)

#RCP45nodes_plot

RCP45links_plot <- ggplot(RCP45_metrics) +
  scale_y_log10(limits = c(90000,1e7)) +
  theme(axis.text=element_text(size=14), axis.title=element_text(size=18), panel.border = element_rect(colour = "black", fill=NA, size=2)) +
  theme(plot.title = element_text(size = 22, face = "bold")) +
  geom_point(aes(time, links, group=con, color=con), size=2.0) +
  #stat_summary(aes(x=time, y=links, group=spec, color=spec),fun=mean, geom="line") +
  geom_smooth(method="loess", aes(x=time, y=links,group=con,color=con), se=T) +
  scale_color_manual(labels = c("No LUC","LUC","cluster No LUC","cluster LUC","geodiversity No LUC","geodiversity LUC"),
                     values=c("cadetblue","darkslateblue","sienna1","sienna","slategray2","slategrey")) +
  scale_x_continuous(labels=c("2020", "2040", "2060","2080","2100")) +
  ggtitle("RCP45 links") +
  theme(legend.position = "none") +
  theme(axis.text.x = element_text(color="black", 
                                   size=14, angle=0),
        axis.text.y = element_text(color="black", 
                                   size=14, angle=0),
        axis.title.x = element_blank(),
        axis.title.y = element_blank()) +
  annotate(geom="text", x=3, y=7000000, label="b",color="black",size=14)

#RCP45links_plot

RCP85nodes_plot <- ggplot(RCP85_metrics) +
  theme(axis.text=element_text(size=14), axis.title=element_text(size=18), panel.border = element_rect(colour = "black", fill=NA, size=2)) +
  theme(plot.title = element_text(size = 22, face = "bold")) +
  geom_point(aes(time, nodes, group=con,color=con), size=2.0) +
  #stat_summary(aes(x=time, y=nodes,group=spec,color=spec),fun=mean, geom="line") +
  geom_smooth(method="loess", aes(x=time, y=nodes,group=con,color=con), se=T) + 
  scale_color_manual(labels = c("No LUC","LUC","cluster No LUC","cluster LUC","geodiversity No LUC","geodiversity LUC"),
                     values=c("cadetblue","darkslateblue","sienna1","sienna","slategray2","slategrey")) +
  ggtitle("RCP85 nodes") +
  theme(legend.position = "none") +
  theme(axis.text.x = element_blank(),
        axis.text.y = element_text(color="black", 
                                   size=14, angle=0),
        axis.title.x = element_blank(),
        axis.title.y = element_blank()) +
  annotate(geom="text", x=3, y=28000, label="c",color="black",size=14) +
  ylim(0,30000)

#RCP85nodes_plot

RCP85links_plot <- ggplot(RCP85_metrics) +
  scale_y_log10(limits = c(90000,1e7)) +
  theme(axis.text=element_text(size=14), axis.title=element_text(size=18), panel.border = element_rect(colour = "black", fill=NA, size=2)) +
  theme(plot.title = element_text(size = 22, face = "bold")) +
  geom_point(aes(time, links, group=con, color=con), size=2.0) +
  #stat_summary(aes(x=time, y=links, group=spec, color=spec),fun=mean, geom="line") +
  geom_smooth(method="loess", aes(x=time, y=links,group=con,color=con), se=T) +
  scale_color_manual(labels = c("No LUC","LUC","cluster No LUC","cluster LUC","geodiversity No LUC","geodiversity LUC"),
                     values=c("cadetblue","darkslateblue","sienna1","sienna","slategray2","slategrey")) +
  scale_x_continuous(labels=c("2020", "2040", "2060","2080","2100")) +
  ggtitle("RCP85 links") +
  theme(legend.position = "none") +
  theme(axis.text.x = element_text(color="black", 
                                   size=14, angle=0),
        axis.text.y = element_text(color="black", 
                                   size=14, angle=0),
        axis.title.x = element_blank(),
        axis.title.y = element_blank()) +
  annotate(geom="text", x=3, y=7000000, label="d",color="black",size=14)

#RCP85links_plot

ggarrange(RCP45nodes_plot,RCP85nodes_plot,RCP45links_plot,RCP85links_plot,nrow=2, bottom=bottom)

########box plots##########
RCP45_EC_test <- RCP45_EC
RCP45_EC_test <- RCP45_EC[apply(RCP45_EC, 1, function(row) all(row !=0 )), ] 

RCP45ec_test_plot <- ggplot(RCP45_EC_test, aes(x=scenario, y=V5, fill=scenario)) +
  theme(axis.text=element_text(size=14), axis.title=element_text(size=18), panel.border = element_rect(colour = "black", fill=NA, size=2)) +
  theme(plot.title = element_text(size = 22, face = "bold")) +
  geom_boxplot(outlier.colour="black", outlier.shape=16,outlier.size=2, notch=TRUE) +
  scale_fill_manual(values=c("cadetblue","darkslateblue","sienna1","sienna","slategray2","slategrey")) +
  ggtitle("Equivalent Connected Area (ha): RCP45") +
  theme(legend.position="bottom") +
  theme(legend.title = element_blank()) +
  theme(axis.text.x = element_blank(),
        axis.text.y = element_text(color="black", 
                                   size=14, angle=0),
        axis.title.x = element_blank(),
        axis.title.y = element_blank()) +
  ylim(10000,62000)
RCP45ec_plot

RCP45ec_plot <- ggplot(RCP45_EC, aes(x=scenario, y=V5)) +
  theme(axis.text=element_text(size=14), axis.title=element_text(size=18), panel.border = element_rect(colour = "black", fill=NA, size=2)) +
  theme(plot.title = element_text(size = 22, face = "bold")) +
  #geom_boxplot(outlier.colour="black", outlier.shape=16,outlier.size=2, notch=TRUE) +
  geom_violin(trim=FALSE) +
  #geom_jitter(shape=16, position=position_jitter(0.2)) +
  scale_fill_manual(labels = c("cluster + land use change","cluster no land use change","geodiversity + land use change",
                               "geodiversity no land use change","no conservation + land use change","no conservation no land use change"),
                    values=c("cadetblue","darkslateblue","sienna1","sienna","slategray2","slategrey")) +
  ggtitle("Equivalent Connected Area (ha): RCP85") +
  theme(legend.position="bottom") +
  theme(legend.title = element_blank()) +
  theme(axis.text.x = element_blank(),
        axis.text.y = element_text(color="black", 
                                   size=14, angle=0),
        axis.title.x = element_blank(),
        axis.title.y = element_blank()) +
  ylim(10000,62000)
RCP85ec_plot


############################
RCP45LUC_0<-RCP45LUC_EC$V5-RCP45NoLUC_EC$V5
RCP45LUC_0<- as.data.frame(RCP45LUC_0)
RCP45LUC_0$time = c(0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,70,80,
                    0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,70,80)
colnames(RCP45LUC_0) <- c("V5","time")
RCP45LUC_0$scenario = "LUC"
cluster_RCP45_NoLUC_0<-cluster_RCP45_NoLUC_EC$V5-RCP45NoLUC_EC$V5
cluster_RCP45_NoLUC_0<- as.data.frame(cluster_RCP45_NoLUC_0)
cluster_RCP45_NoLUC_0$time = c(0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,70,80,
                    0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,70,80)
colnames(cluster_RCP45_NoLUC_0) <- c("V5","time")
cluster_RCP45_NoLUC_0$scenario = "cluster NoLUC"
cluster_RCP45_LUC_0<-cluster_RCP45_LUC_EC$V5-RCP45NoLUC_EC$V5
cluster_RCP45_LUC_0<- as.data.frame(cluster_RCP45_LUC_0)
cluster_RCP45_LUC_0$time = c(0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,70,80,
                               0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,70,80)
colnames(cluster_RCP45_LUC_0) <- c("V5","time")
cluster_RCP45_LUC_0$scenario = "cluster LUC"
geo_RCP45_NoLUC_0<-geo_RCP45_NoLUC_EC$V5-RCP45NoLUC_EC$V5
geo_RCP45_NoLUC_0<- as.data.frame(geo_RCP45_NoLUC_0)
geo_RCP45_NoLUC_0$time = c(0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,70,80,
                               0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,70,80)
colnames(geo_RCP45_NoLUC_0) <- c("V5","time")
geo_RCP45_NoLUC_0$scenario = "geo NoLUC"
geo_RCP45_LUC_0<-geo_RCP45_LUC_EC$V5-RCP45NoLUC_EC$V5
geo_RCP45_LUC_0<- as.data.frame(geo_RCP45_LUC_0)
geo_RCP45_LUC_0$time = c(0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,70,80,
                               0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,70,80)
colnames(geo_RCP45_LUC_0) <- c("V5","time")
geo_RCP45_LUC_0$scenario = "geo LUC"

RCP45_0<- rbind(RCP45LUC_0,cluster_RCP45_NoLUC_0,cluster_RCP45_LUC_0,geo_RCP45_NoLUC_0,geo_RCP45_LUC_0)

RCP85LUC_0<-RCP85LUC_EC$V5-RCP85NoLUC_EC$V5
RCP85LUC_0<- as.data.frame(RCP85LUC_0)
RCP85LUC_0$time = c(0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,70,80,
                    0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,70,80)
colnames(RCP85LUC_0) <- c("V5","time")
RCP85LUC_0$scenario = "LUC"
cluster_RCP85_NoLUC_0<-cluster_RCP85_NoLUC_EC$V5-RCP85NoLUC_EC$V5
cluster_RCP85_NoLUC_0<- as.data.frame(cluster_RCP85_NoLUC_0)
cluster_RCP85_NoLUC_0$time = c(0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,70,80,
                               0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,70,80)
colnames(cluster_RCP85_NoLUC_0) <- c("V5","time")
cluster_RCP85_NoLUC_0$scenario = "cluster NoLUC"
cluster_RCP85_LUC_0<-cluster_RCP85_LUC_EC$V5-RCP85NoLUC_EC$V5
cluster_RCP85_LUC_0<- as.data.frame(cluster_RCP85_LUC_0)
cluster_RCP85_LUC_0$time = c(0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,70,80,
                             0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,70,80)
colnames(cluster_RCP85_LUC_0) <- c("V5","time")
cluster_RCP85_LUC_0$scenario = "cluster LUC"
geo_RCP85_NoLUC_0<-geo_RCP85_NoLUC_EC$V5-RCP85NoLUC_EC$V5
geo_RCP85_NoLUC_0<- as.data.frame(geo_RCP85_NoLUC_0)
geo_RCP85_NoLUC_0$time = c(0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,70,80,
                           0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,70,80)
colnames(geo_RCP85_NoLUC_0) <- c("V5","time")
geo_RCP85_NoLUC_0$scenario = "geo NoLUC"
geo_RCP85_LUC_0<-geo_RCP85_LUC_EC$V5-RCP85NoLUC_EC$V5
geo_RCP85_LUC_0<- as.data.frame(geo_RCP85_LUC_0)
geo_RCP85_LUC_0$time = c(0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,70,80,
                         0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,70,80)
colnames(geo_RCP85_LUC_0) <- c("V5","time")
geo_RCP85_LUC_0$scenario = "geo LUC"

RCP85_0<- rbind(RCP85LUC_0,cluster_RCP85_NoLUC_0,cluster_RCP85_LUC_0,geo_RCP85_NoLUC_0,geo_RCP85_LUC_0)



RCP45_0_plot <- ggplot(RCP45_0) +
  theme(axis.text=element_text(size=14), axis.title=element_text(size=18), panel.border = element_rect(colour = "black", fill=NA, size=2)) +
  theme(plot.title = element_text(size = 22, face = "bold")) +
  #geom_point(aes(time, V5, group=scenario,color=scenario), size=2.0) +
  geom_smooth(method="loess", aes(x=time, y=V5,group=scenario,color=scenario), se=F) + 
  scale_color_manual(labels = c("cluster + land use change","cluster no land use change","geodiversity + land use change",
                                "geodiversity no land use change","no conservation + land use change"),
                     values=c("cadetblue","darkslateblue","sienna1","sienna","slategray2")) +
  scale_x_continuous(labels=c("2020", "2040", "2060","2080","2100")) +
  ggtitle("Equivalent Connected Area (ha): RCP45") +
  theme(legend.position="bottom") +
  theme(legend.title = element_blank()) +
  #theme(legend.position = "none") +
  #labs(x ="Hectares") +
  theme(axis.text.x = element_text(color="black", 
                                   size=14, angle=0),
        axis.text.y = element_text(color="black", 
                                   size=14, angle=0),
        axis.title.x = element_blank(),
        axis.title.y = element_blank()) +
  #annotate(geom="text", x=-2, y=57000, label="a",color="black",size=14) +
  ylim(-15000,15000)
RCP45_0_plot

RCP85_0_plot <- ggplot(RCP85_0) +
  theme(axis.text=element_text(size=14), axis.title=element_text(size=18), panel.border = element_rect(colour = "black", fill=NA, size=2)) +
  theme(plot.title = element_text(size = 22, face = "bold")) +
  #geom_point(aes(time, V5, group=scenario,color=scenario), size=2.0) +
  geom_smooth(method="loess", aes(x=time, y=V5,group=scenario,color=scenario), se=F) + 
  scale_color_manual(labels = c("cluster LUC","cluster No LUC","geo LUC","geo No LUC","LUC"),
                     values=c("cadetblue","darkslateblue","sienna1","sienna","slategray2")) +
  scale_x_continuous(labels=c("2020", "2040", "2060","2080","2100")) +
  ggtitle("Equivalent Connected Area (ha): RCP85") +
  theme(legend.position = "none") +
  #labs(x ="Hectares") +
  theme(axis.text.x = element_text(color="black", 
                                   size=14, angle=0),
        axis.text.y = element_blank(),
        axis.title.x = element_blank(),
        axis.title.y = element_blank()) +
  #annotate(geom="text", x=-2, y=57000, label="b",color="black",size=14) +
  ylim(-15000,15000)
RCP85_0_plot

ggarrange(RCP45_0_plot+theme(legend.position='hidden'),RCP85_0_plot, nrow = 1,bottom=bottom)


##############################percentage table
RCP45LUC_EC <- RCP45LUC_EC[,5:6]
EC_45LUC<- ddply(RCP45LUC_EC,"time",colMeans)
RCP45NoLUC_EC <- RCP45NoLUC_EC[,5:6]
EC_45NoLUC<- ddply(RCP45NoLUC_EC,"time",colMeans)

RCP85LUC_EC <- RCP85LUC_EC[,5:6]
EC_85LUC<- ddply(RCP85LUC_EC,"time",colMeans)
RCP85NoLUC_EC <- RCP85NoLUC_EC[,5:6]
EC_85NoLUC<- ddply(RCP85NoLUC_EC,"time",colMeans)

cluster_RCP45_LUC_EC <- cluster_RCP45_LUC_EC[,5:6]
EC_C45LUC<- ddply(cluster_RCP45_LUC_EC,"time",colMeans)
cluster_RCP45_NoLUC_EC <- cluster_RCP45_NoLUC_EC[,5:6]
EC_C45NoLUC<- ddply(cluster_RCP45_NoLUC_EC,"time",colMeans)

cluster_RCP85_LUC_EC <- cluster_RCP85_LUC_EC[,5:6]
EC_C85LUC<- ddply(cluster_RCP85_LUC_EC,"time",colMeans)
cluster_RCP85_NoLUC_EC <- cluster_RCP85_NoLUC_EC[,5:6]
EC_C85NoLUC<- ddply(cluster_RCP85_NoLUC_EC,"time",colMeans)

geo_RCP45_LUC_EC <- geo_RCP45_LUC_EC[,5:6]
EC_G45LUC<- ddply(geo_RCP45_LUC_EC,"time",colMeans)
geo_RCP45_NoLUC_EC <- geo_RCP45_NoLUC_EC[,5:6]
EC_G45NoLUC<- ddply(geo_RCP45_NoLUC_EC,"time",colMeans)

geo_RCP85_LUC_EC <- geo_RCP85_LUC_EC[,5:6]
EC_G85LUC<- ddply(geo_RCP85_LUC_EC,"time",colMeans)
geo_RCP85_NoLUC_EC <- geo_RCP85_NoLUC_EC[,5:6]
EC_G85NoLUC<- ddply(geo_RCP85_NoLUC_EC,"time",colMeans)

all_EC45_LUC<- cbind(EC_45LUC, EC_C45LUC, EC_G45LUC)
all_EC45_NoLUC<- cbind(EC_45NoLUC, EC_C45NoLUC, EC_G45NoLUC)

all_EC85_LUC<- cbind(EC_85LUC, EC_C85LUC, EC_G85LUC)
all_EC85_NoLUC<- cbind(EC_85NoLUC, EC_C85NoLUC, EC_G85NoLUC)

EC_45LUC_diff <- EC_45LUC %>%
  #mutate(Precent_diff = 100 * (V5 - first(V5))/first(V5)) %>%
  mutate(pct_change = (V5/first(V5)) * 100) %>%
  mutate(Difference = V5 - first(V5))

EC_45NoLUC_diff <- EC_45NoLUC %>%
  #mutate(Precent_diff = 100 * (V5 - first(V5))/first(V5)) %>%
  mutate(pct_change = (V5/first(V5)) * 100) %>%
  mutate(Difference = V5 - first(V5))

EC_85LUC_diff <- EC_85LUC %>%
  #mutate(Precent_diff = 100 * (V5 - first(V5))/first(V5)) %>%
  mutate(pct_change = (V5/first(V5)) * 100) %>%
  mutate(Difference = V5 - first(V5))

EC_85NoLUC_diff <- EC_85NoLUC %>%
  #mutate(Precent_diff = 100 * (V5 - first(V5))/first(V5)) %>%
  mutate(pct_change = (V5/first(V5)) * 100) %>%
  mutate(Difference = V5 - first(V5))

EC_C45LUC_diff <- EC_C45LUC %>%
  #mutate(Precent_diff = 100 * (V5 - first(V5))/first(V5)) %>%
  mutate(pct_change = (V5/first(V5)) * 100) %>%
  mutate(Difference = V5 - first(V5))

EC_C45NoLUC_diff <- EC_C45NoLUC %>%
  #mutate(Percent_diff = 100 * (V5 - first(V5))/first(V5)) %>%
  mutate(pct_change = (V5/first(V5)) * 100) %>%
  mutate(Difference = V5 - first(V5))

EC_C85LUC_diff <- EC_C85LUC %>%
  #mutate(Precent_diff = 100 * (V5 - first(V5))/first(V5)) %>%
  mutate(pct_change = (V5/first(V5)) * 100) %>%
  mutate(Difference = V5 - first(V5))

EC_C85NoLUC_diff <- EC_C85NoLUC %>%
  #mutate(Percent_diff = 100 * (V5 - first(V5))/first(V5)) %>%
  mutate(pct_change = (V5/first(V5)) * 100) %>%
  mutate(Difference = V5 - first(V5))

EC_G45LUC_diff <- EC_G45LUC %>%
  #mutate(Precent_diff = 100 * (V5 - first(V5))/first(V5)) %>%
  mutate(pct_change = (V5/first(V5)) * 100) %>%
  mutate(Difference = V5 - first(V5))

EC_G45NoLUC_diff <- EC_G45NoLUC %>%
  #mutate(Percent_diff = 100 * (V5 - first(V5))/first(V5)) %>%
  mutate(pct_change = (V5/first(V5)) * 100) %>%
  mutate(Difference = V5 - first(V5))

EC_G85LUC_diff <- EC_G85LUC %>%
  #mutate(Precent_diff = 100 * (V5 - first(V5))/first(V5)) %>%
  mutate(pct_change = (V5/first(V5)) * 100) %>%
  mutate(Difference = V5 - first(V5))

EC_G85NoLUC_diff <- EC_G85NoLUC %>%
  #mutate(Percent_diff = 100 * (V5 - first(V5))/first(V5)) %>%
  mutate(pct_change = (V5/first(V5)) * 100) %>% 
  mutate(Difference = V5 - first(V5))




