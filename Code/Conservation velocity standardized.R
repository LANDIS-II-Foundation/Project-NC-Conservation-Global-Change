library(plyr)
library(dplyr)
library(ggplot2)
library(raster)
library(spatstat)
library(ggplot2)
library(plotrix)

#read in stand map and ecoregion map (spatial reference)
standmap <- raster(paste("Z:/NECN_Tina/NECN_Tina_test/Standmap100.tif"))
Ecoregion <- raster(paste0("Z:/NECN_Tina/NECN_Tina_test/Ecoregion100f.tif", sep=""))


##Change this for each strategy!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
Drive <- "E:/Conservation velocity/geo/RCP45"
#GCM<- list.files(Drive)

#GCMs
GCMlist <- c("bcc","CNRM","Had-GEM","IPSL","NorESM")
#harvest time steps
times <- as.character(c(0,5,10,20,25,35,40,50,55,65,70,75))

for (i in GCMlist) {
  #i="bcc"
  print(i)
  strat_files<-list.files(i)
  
  #bring in harvest event log of one conservation strategy/climate model combo
  strat_harv <- read.csv(paste0(Drive,"/",i,"/biomass-harvest-event-log.csv"))
  #keep only columns needed for analysis
  strat_harv <- strat_harv[,1:8]
  #subset by management areas of restoration sites
  strat_harv_rest <- subset(strat_harv, ManagementArea > 10)
  #further subset by restoration type
  strat_LLP <- strat_harv_rest[strat_harv_rest$Prescription == " LLRestoration",] 
  strat_Pmix <- strat_harv_rest[strat_harv_rest$Prescription == " PineRestoration",] 
  strat_Hmix <- strat_harv_rest[strat_harv_rest$Prescription == " HMixRestoration",]
  
  #isolate stand numbers for each restoration strategy
  strat_LLPstands <- strat_LLP[,4]
  strat_LLPstands_df <- as.data.frame(strat_LLPstands)
  strat_Pmixstands <- strat_Pmix[,4]
  strat_Pmixstands_df <- as.data.frame(strat_Pmixstands)
  strat_Hmixstands <- strat_Hmix[,4]
  strat_Hmixstands_df <- as.data.frame(strat_Hmixstands)

  
  for (t in times) {
    #t=5
    print(t)
    ############################ pre-restoration ###############################
    
    #bring in target restoration spp biomass maps
    
    strat_Acer_avgage_end <- raster(paste(Drive,"/",i,"/cohort-stats/AcerRubr-AVG-",t,".img", sep=""))
    crs(strat_Acer_avgage_end) <- "+proj=utm +zone=17 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs"
    extent(strat_Acer_avgage_end)<-raster::extent(Ecoregion)
    
    strat_QuerA_avgage_end <- raster(paste(Drive,"/",i,"/cohort-stats/QuerAlba-AVG-",t,".img", sep=""))
    crs(strat_QuerA_avgage_end) <- "+proj=utm +zone=17 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs"
    extent(strat_QuerA_avgage_end)<-raster::extent(Ecoregion)
    
    strat_SLP_avgage_end <- raster(paste(Drive,"/",i,"/cohort-stats/PinuEchi-AVG-",t,".img", sep=""))
    crs(strat_SLP_avgage_end) <- "+proj=utm +zone=17 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs"
    extent(strat_SLP_avgage_end)<-raster::extent(Ecoregion)
    
    strat_LLP_avgage_end <- raster(paste(Drive,"/",i,"/cohort-stats/PinuPalu-AVG-",t,".img", sep=""))
    crs(strat_LLP_avgage_end) <- "+proj=utm +zone=17 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs"
    extent(strat_LLP_avgage_end)<-raster::extent(Ecoregion)
    
    strat_Virg_avgage_end <- raster(paste(Drive,"/",i,"/cohort-stats/PinuVirg-AVG-",t,".img", sep=""))
    crs(strat_Virg_avgage_end) <- "+proj=utm +zone=17 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs"
    extent(strat_Virg_avgage_end)<-raster::extent(Ecoregion)
    
    #avg age by habitat restoration target spp
    #LLP
    avgage_standsLLP <- raster::stack(strat_LLP_avgage_end, standmap)
    avgage_standsLLPdf<- as.data.frame(avgage_standsLLP)
    avgage_standsLLPdf <- avgage_standsLLPdf %>% filter(Standmap100 != 99999)
    #Pmix
    avgage_Pmix <- (strat_SLP_avgage_end + strat_LLP_avgage_end + strat_Virg_avgage_end)/3
    avgage_standsPmix <- raster::stack(avgage_Pmix, standmap)
    avgage_standsPmixdf<- as.data.frame(avgage_standsPmix)
    avgage_standsPmixdf <- avgage_standsPmixdf %>% filter(Standmap100 != 99999)
    #Hmix
    avgage_Hmix <- (strat_Acer_avgage_end + strat_QuerA_avgage_end)/2
    avgage_standsHmix <- raster::stack(avgage_Hmix, standmap)
    avgage_standsHmixdf<- as.data.frame(avgage_standsHmix)
    avgage_standsHmixdf <- avgage_standsHmixdf %>% filter(Standmap100 != 99999)
    
    #find average stand age for each stand and restoration type
    standage_LLP <- subset(avgage_standsLLPdf, Standmap100 %in% strat_LLPstands_df$strat_LLPstands)
    avgstandage_LLP <- ddply(standage_LLP,"Standmap100",numcolwise(mean))
    #avgstandage_LLP$avgage <- (avgstandage_LLP[,2] - mean(avgstandage_LLP[,2])) / sd(avgstandage_LLP[,2])
    #avgstandage_LLP$avgage <-(avgstandage_LLP[,2])/100
    standage_Pmix <- subset(avgage_standsPmixdf, Standmap100 %in% strat_Pmixstands_df$strat_Pmixstands)
    avgstandage_Pmix <- ddply(standage_Pmix,"Standmap100",numcolwise(mean))
    #avgstandage_Pmix$avgage <- (avgstandage_Pmix$layer - mean(avgstandage_Pmix$layer)) / sd(avgstandage_Pmix$layer)
    #avgstandage_Pmix$avgage <-(avgstandage_Pmix[,2])/100
    standage_Hmix <- subset(avgage_standsHmixdf, Standmap100 %in% strat_Hmixstands_df$strat_Hmixstands)
    avgstandage_Hmix <- ddply(standage_Hmix,"Standmap100",numcolwise(mean))
    #avgstandage_Hmix$avgage <- (avgstandage_Hmix$layer - mean(avgstandage_Hmix$layer)) / sd(avgstandage_Hmix$layer)
    #avgstandage_Hmix$avgage <-(avgstandage_Hmix[,2])/100
    
    #read in biomass maps for site totals and restoration target species
    stratbiototal_end <- raster(paste(Drive,"/",i,"/biomass/bio-TotalBiomass-",t,".img", sep=""))
    stratbioLLP_end <- raster(paste(Drive,"/",i,"/biomass/bio-PinuPalu-",t,".img", sep=""))
    stratbioVirg_end <- raster(paste(Drive,"/",i,"/biomass/bio-PinuVirg-",t,".img", sep=""))
    stratbioSLP_end <- raster(paste(Drive,"/",i,"/biomass/bio-PinuEchi-",t,".img", sep=""))
    stratbioQuerA_end <- raster(paste(Drive,"/",i,"/biomass/bio-QuerAlba-",t,".img", sep=""))
    stratbioAcer_end <- raster(paste(Drive,"/",i,"/biomass/bio-AcerRubr-",t,".img", sep=""))
    
    #raster algebra to find ratio of target species biomass to total biomass
    LLPratio_end <- stratbioLLP_end/stratbiototal_end
    crs(LLPratio_end) <- "+proj=utm +zone=17 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs"
    extent(LLPratio_end)<-raster::extent(Ecoregion)
    Pmixratio_end <- (stratbioLLP_end + stratbioVirg_end + stratbioSLP_end)/stratbiototal_end
    crs(Pmixratio_end) <- "+proj=utm +zone=17 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs"
    extent(Pmixratio_end)<-raster::extent(Ecoregion)
    Hmixratio_end <- (stratbioQuerA_end + stratbioAcer_end)/stratbiototal_end
    crs(Hmixratio_end) <- "+proj=utm +zone=17 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs"
    extent(Hmixratio_end)<-raster::extent(Ecoregion)
    
    #find ratio for each stand/restoration type
    #LLP
    LLPratio_stands <- raster::stack(LLPratio_end, standmap)
    LLPratio_standsdf<- as.data.frame(LLPratio_stands)
    LLPratio_standsdf <- LLPratio_standsdf %>% filter(Standmap100 != 99999)
    standratio_LLP <- subset(LLPratio_standsdf, Standmap100 %in% strat_LLPstands_df$strat_LLPstands)
    standratio_LLP_xna <- standratio_LLP[complete.cases(standratio_LLP), ]
    avgstandratio_LLP <- ddply(standratio_LLP_xna,"Standmap100",numcolwise(mean))
    #avgstandratio_LLP$ratio <- (avgstandratio_LLP$layer - mean(avgstandratio_LLP$layer)) / sd(avgstandratio_LLP$layer)
    #avgstandratio_LLP$layer <- (avgstandratio_LLP$layer) * 100
    #Pmix
    Pmixratio_stands <- raster::stack(Pmixratio_end, standmap)
    Pmixratio_standsdf<- as.data.frame(Pmixratio_stands)
    Pmixratio_standsdf <- Pmixratio_standsdf %>% filter(Standmap100 != 99999)
    standratio_Pmix <- subset(Pmixratio_standsdf, Standmap100 %in% strat_Pmixstands_df$strat_Pmixstands)
    standratio_Pmix_xna <- standratio_Pmix[complete.cases(standratio_Pmix), ]
    avgstandratio_Pmix <- ddply(standratio_Pmix_xna,"Standmap100",numcolwise(mean))
    #avgstandratio_Pmix$ratio <- (avgstandratio_Pmix$layer - mean(avgstandratio_Pmix$layer)) / sd(avgstandratio_Pmix$layer)
    #avgstandratio_Pmix$layer <- (avgstandratio_Pmix$layer) * 100
    #Hmix
    Hmixratio_stands <- raster::stack(Hmixratio_end, standmap)
    Hmixratio_standsdf<- as.data.frame(Hmixratio_stands)
    Hmixratio_standsdf <- Hmixratio_standsdf %>% filter(Standmap100 != 99999)
    standratio_Hmix <- subset(Hmixratio_standsdf, Standmap100 %in% strat_Hmixstands_df$strat_Hmixstands)
    standratio_Hmix_xna <- standratio_Hmix[complete.cases(standratio_Hmix), ]
    avgstandratio_Hmix <- ddply(standratio_Hmix_xna,"Standmap100",numcolwise(mean))
    #avgstandratio_Hmix$ratio <- (avgstandratio_Hmix$layer - mean(avgstandratio_Hmix$layer)) / sd(avgstandratio_Hmix$layer)
    #avgstandratio_Hmix$layer <- (avgstandratio_Hmix$layer) * 100
    
    #habitat size- hectares of the stand that are greater than 50% target species
    #LLP
    LLP_hab <- standratio_LLP_xna[standratio_LLP_xna$layer > 0.5,]
    avghab_LLP <- LLP_hab %>% count(Standmap100)
    #avghab_LLP$hab <- (avghab_LLP$n - mean(avghab_LLP$n)) / sd(avghab_LLP$n)
    #Pmix
    Pmix_hab <- standratio_Pmix_xna[standratio_Pmix_xna$layer > 0.5,]
    avghab_Pmix <- Pmix_hab %>% count(Standmap100)
    #avghab_Pmix$hab <- (avghab_Pmix$n - mean(avghab_Pmix$n)) / sd(avghab_Pmix$n)
    #Hmix
    Hmix_hab <- standratio_Hmix_xna[standratio_Hmix_xna$layer > 0.5,]
    avghab_Hmix <- Hmix_hab %>% count(Standmap100)
    #avghab_Hmix$hab <- (avghab_Hmix$n - mean(avghab_Hmix$n)) / sd(avghab_Hmix$n)
    
    merge_oneLLP<-merge(avghab_LLP, avgstandage_LLP, by="Standmap100", all=T)
    merge_twoLLP <- merge(merge_oneLLP, avgstandratio_LLP, by="Standmap100")
    #col <- c(1,3,5,7)
    #merge_twoLLP <- merge_twoLLP[,col]
    colnames(merge_twoLLP) <- c("stand_no", "hab_size","avg_stand_age","biomass_ratio")
    yr0LLP_metrics<-merge_twoLLP
    yr0LLP_metrics$time <- t
    yr0LLP_metrics$mgmtarea <- strat_LLP$ManagementArea
    yr0LLP_metrics$hab_size[is.na(yr0LLP_metrics$hab_size)] <- 0
    
    #yr0LLP_metrics$all_avg <- (yr0LLP_metrics$hab_size + yr0LLP_metrics$avg_stand_age + yr0LLP_metrics$biomass_ratio)/3
    yr0LLP_metrics$all_avg <- yr0LLP_metrics$hab_size * yr0LLP_metrics$avg_stand_age * yr0LLP_metrics$biomass_ratio
    
    merge_onePmix<-merge(avghab_Pmix, avgstandage_Pmix, by="Standmap100", all=T)
    merge_twoPmix <- merge(merge_onePmix, avgstandratio_Pmix, by="Standmap100")
    #col <- c(1,3,5,7)
    #merge_twoPmix <- merge_twoPmix[,col]
    colnames(merge_twoPmix) <- c("stand_no", "hab_size", "avg_stand_age","biomass_ratio")
    yr0Pmix_metrics<-merge_twoPmix
    yr0Pmix_metrics$time <- t
    yr0Pmix_metrics$mgmtarea <- strat_Pmix$ManagementArea
    yr0Pmix_metrics$hab_size[is.na(yr0Pmix_metrics$hab_size)] <- 0
    
    #yr0Pmix_metrics$all_avg <- (yr0Pmix_metrics$hab_size + yr0Pmix_metrics$avg_stand_age + yr0Pmix_metrics$biomass_ratio)/3
    yr0Pmix_metrics$all_avg <- yr0Pmix_metrics$hab_size * yr0Pmix_metrics$avg_stand_age * yr0Pmix_metrics$biomass_ratio
    
    merge_oneHmix<-merge(avghab_Hmix, avgstandage_Hmix, by="Standmap100", all=T)
    merge_twoHmix <- merge(merge_oneHmix, avgstandratio_Hmix, by="Standmap100")
    #col <- c(1,3,5,7)
    #merge_twoHmix <- merge_twoHmix[,col]
    colnames(merge_twoHmix) <- c("stand_no", "hab_size", "avg_stand_age","biomass_ratio")
    yr0Hmix_metrics<-merge_twoHmix
    yr0Hmix_metrics$time <- t
    yr0Hmix_metrics$mgmtarea <- strat_Hmix$ManagementArea
    yr0Hmix_metrics$hab_size[is.na(yr0Hmix_metrics$hab_size)] <- 0
    
    #yr0Hmix_metrics$all_avg <- (yr0Hmix_metrics$hab_size + yr0Hmix_metrics$avg_stand_age + yr0Hmix_metrics$biomass_ratio)/3
    yr0Hmix_metrics$all_avg <- yr0Hmix_metrics$hab_size * yr0Hmix_metrics$avg_stand_age * yr0Hmix_metrics$biomass_ratio
    
    write.csv(yr0LLP_metrics, file=paste0(Drive,"/",i,t,"LLP_std.csv"), row.names=F)
    write.csv(yr0Pmix_metrics, file=paste0(Drive,"/",i,t,"Pmix_std.csv"), row.names=F)
    write.csv(yr0Hmix_metrics, file=paste0(Drive,"/",i,t,"Hmix_std.csv"), row.names=F)
    
  }
  
  ############################ year 80, post-restoration ###############################
  strat_Acer_avgage_end <- raster(paste(Drive,"/",i,"/cohort-stats/AcerRubr-AVG-80.img", sep=""))
  crs(strat_Acer_avgage_end) <- "+proj=utm +zone=17 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs"
  extent(strat_Acer_avgage_end)<-raster::extent(Ecoregion)
  
  strat_QuerA_avgage_end <- raster(paste(Drive,"/",i,"/cohort-stats/QuerAlba-AVG-80.img", sep=""))
  crs(strat_QuerA_avgage_end) <- "+proj=utm +zone=17 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs"
  extent(strat_QuerA_avgage_end)<-raster::extent(Ecoregion)
  
  strat_SLP_avgage_end <- raster(paste(Drive,"/",i,"/cohort-stats/PinuEchi-AVG-80.img", sep=""))
  crs(strat_SLP_avgage_end) <- "+proj=utm +zone=17 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs"
  extent(strat_SLP_avgage_end)<-raster::extent(Ecoregion)
  
  strat_LLP_avgage_end <- raster(paste(Drive,"/",i,"/cohort-stats/PinuPalu-AVG-80.img", sep=""))
  crs(strat_LLP_avgage_end) <- "+proj=utm +zone=17 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs"
  extent(strat_LLP_avgage_end)<-raster::extent(Ecoregion)
  
  strat_Virg_avgage_end <- raster(paste(Drive,"/",i,"/cohort-stats/PinuVirg-AVG-80.img", sep=""))
  crs(strat_Virg_avgage_end) <- "+proj=utm +zone=17 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs"
  extent(strat_Virg_avgage_end)<-raster::extent(Ecoregion)
  
  #avg age by habitat restoration target spp
  #LLP
  avgage_standsLLP <- raster::stack(strat_LLP_avgage_end, standmap)
  avgage_standsLLPdf<- as.data.frame(avgage_standsLLP)
  avgage_standsLLPdf <- avgage_standsLLPdf %>% filter(Standmap100 != 99999)
  #Pmix
  avgage_Pmix <- (strat_SLP_avgage_end + strat_LLP_avgage_end + strat_Virg_avgage_end)/3
  avgage_standsPmix <- raster::stack(avgage_Pmix, standmap)
  avgage_standsPmixdf<- as.data.frame(avgage_standsPmix)
  avgage_standsPmixdf <- avgage_standsPmixdf %>% filter(Standmap100 != 99999)
  #Hmix
  avgage_Hmix <- (strat_Acer_avgage_end + strat_QuerA_avgage_end)/2
  avgage_standsHmix <- raster::stack(avgage_Hmix, standmap)
  avgage_standsHmixdf<- as.data.frame(avgage_standsHmix)
  avgage_standsHmixdf <- avgage_standsHmixdf %>% filter(Standmap100 != 99999)
  
  #find average stand age for each stand and restoration type
  standage_LLP <- subset(avgage_standsLLPdf, Standmap100 %in% strat_LLPstands_df$strat_LLPstands)
  avgstandage_LLP <- ddply(standage_LLP,"Standmap100",numcolwise(mean))
  #avgstandage_LLP$avgage <- (avgstandage_LLP$PinuPalu.AVG.80 - mean(avgstandage_LLP$PinuPalu.AVG.80)) / sd(avgstandage_LLP$PinuPalu.AVG.80)
  #avgstandage_LLP$avgage <-(avgstandage_LLP[,2])/100
  standage_Pmix <- subset(avgage_standsPmixdf, Standmap100 %in% strat_Pmixstands_df$strat_Pmixstands)
  avgstandage_Pmix <- ddply(standage_Pmix,"Standmap100",numcolwise(mean))
  #avgstandage_Pmix$avgage <- (avgstandage_Pmix$layer - mean(avgstandage_Pmix$layer)) / sd(avgstandage_Pmix$layer)
  #avgstandage_Pmix$avgage <-(avgstandage_Pmix[,2])/100
  standage_Hmix <- subset(avgage_standsHmixdf, Standmap100 %in% strat_Hmixstands_df$strat_Hmixstands)
  avgstandage_Hmix <- ddply(standage_Hmix,"Standmap100",numcolwise(mean))
  #avgstandage_Hmix$avgage <- (avgstandage_Hmix$layer - mean(avgstandage_Hmix$layer)) / sd(avgstandage_Hmix$layer)
  #avgstandage_Hmix$avgage <-(avgstandage_Hmix[,2])/100
  
  #read in end model run biomass maps for site totals and restoration target species
  stratbiototal_end <- raster(paste(Drive,"/",i,"/biomass/bio-TotalBiomass-80.img", sep=""))
  stratbioLLP_end <- raster(paste(Drive,"/",i,"/biomass/bio-PinuPalu-80.img", sep=""))
  stratbioVirg_end <- raster(paste(Drive,"/",i,"/biomass/bio-PinuVirg-80.img", sep=""))
  stratbioSLP_end <- raster(paste(Drive,"/",i,"/biomass/bio-PinuEchi-80.img", sep=""))
  stratbioQuerA_end <- raster(paste(Drive,"/",i,"/biomass/bio-QuerAlba-80.img", sep=""))
  stratbioAcer_end <- raster(paste(Drive,"/",i,"/biomass/bio-AcerRubr-80.img", sep=""))
  
  #raster algebra to find ratio of target species biomass to total biomass
  LLPratio_end <- stratbioLLP_end/stratbiototal_end
  crs(LLPratio_end) <- "+proj=utm +zone=17 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs"
  extent(LLPratio_end)<-raster::extent(Ecoregion)
  Pmixratio_end <- (stratbioLLP_end + stratbioVirg_end + stratbioSLP_end)/stratbiototal_end
  crs(Pmixratio_end) <- "+proj=utm +zone=17 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs"
  extent(Pmixratio_end)<-raster::extent(Ecoregion)
  Hmixratio_end <- (stratbioQuerA_end + stratbioAcer_end)/stratbiototal_end
  crs(Hmixratio_end) <- "+proj=utm +zone=17 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs"
  extent(Hmixratio_end)<-raster::extent(Ecoregion)
  
  #find ratio for each stand/restoration type
  #LLP
  LLPratio_stands <- raster::stack(LLPratio_end, standmap)
  LLPratio_standsdf<- as.data.frame(LLPratio_stands)
  LLPratio_standsdf <- LLPratio_standsdf %>% filter(Standmap100 != 99999)
  standratio_LLP <- subset(LLPratio_standsdf, Standmap100 %in% strat_LLPstands_df$strat_LLPstands)
  standratio_LLP_xna <- standratio_LLP[complete.cases(standratio_LLP), ]
  avgstandratio_LLP <- ddply(standratio_LLP_xna,"Standmap100",numcolwise(mean))
  #avgstandratio_LLP$ratio <- (avgstandratio_LLP$layer - mean(avgstandratio_LLP$layer)) / sd(avgstandratio_LLP$layer)
  #avgstandratio_LLP$layer <- (avgstandratio_LLP$layer) * 100
  #Pmix
  Pmixratio_stands <- raster::stack(Pmixratio_end, standmap)
  Pmixratio_standsdf<- as.data.frame(Pmixratio_stands)
  Pmixratio_standsdf <- Pmixratio_standsdf %>% filter(Standmap100 != 99999)
  standratio_Pmix <- subset(Pmixratio_standsdf, Standmap100 %in% strat_Pmixstands_df$strat_Pmixstands)
  standratio_Pmix_xna <- standratio_Pmix[complete.cases(standratio_Pmix), ]
  avgstandratio_Pmix <- ddply(standratio_Pmix_xna,"Standmap100",numcolwise(mean))
  #avgstandratio_Pmix$ratio <- (avgstandratio_Pmix$layer - mean(avgstandratio_Pmix$layer)) / sd(avgstandratio_Pmix$layer)
  #avgstandratio_Pmix$layer <- (avgstandratio_Pmix$layer) * 100
  #Hmix
  Hmixratio_stands <- raster::stack(Hmixratio_end, standmap)
  Hmixratio_standsdf<- as.data.frame(Hmixratio_stands)
  Hmixratio_standsdf <- Hmixratio_standsdf %>% filter(Standmap100 != 99999)
  standratio_Hmix <- subset(Hmixratio_standsdf, Standmap100 %in% strat_Hmixstands_df$strat_Hmixstands)
  standratio_Hmix_xna <- standratio_Hmix[complete.cases(standratio_Hmix), ]
  avgstandratio_Hmix <- ddply(standratio_Hmix_xna,"Standmap100",numcolwise(mean))
  #avgstandratio_Hmix$ratio <- (avgstandratio_Hmix$layer - mean(avgstandratio_Hmix$layer)) / sd(avgstandratio_Hmix$layer)
  #avgstandratio_Hmix$layer <- (avgstandratio_Hmix$layer) * 100
  
  #habitat size- hectares of the stand that are greater than 50% target species
  #LLP
  LLP_hab <- standratio_LLP_xna[standratio_LLP_xna$layer > 0.5,]
  avghab_LLP <- LLP_hab %>% count(Standmap100)
  #avghab_LLP$hab <- (avghab_LLP$n - mean(avghab_LLP$n)) / sd(avghab_LLP$n)
  #Pmix
  Pmix_hab <- standratio_Pmix_xna[standratio_Pmix_xna$layer > 0.5,]
  avghab_Pmix <- Pmix_hab %>% count(Standmap100)
  #avghab_Pmix$hab <- (avghab_Pmix$n - mean(avghab_Pmix$n)) / sd(avghab_Pmix$n)
  #Hmix
  Hmix_hab <- standratio_Hmix_xna[standratio_Hmix_xna$layer > 0.5,]
  avghab_Hmix <- Hmix_hab %>% count(Standmap100)
  #avghab_Hmix$hab <- (avghab_Hmix$n - mean(avghab_Hmix$n)) / sd(avghab_Hmix$n)
  
  merge_oneLLP<-merge(avghab_LLP, avgstandage_LLP, by="Standmap100", all=T)
  merge_twoLLP <- merge(merge_oneLLP, avgstandratio_LLP, by="Standmap100")
  #col <- c(1,3,5,7)
  #merge_twoLLP <- merge_twoLLP[,col]
  colnames(merge_twoLLP) <- c("stand_no", "hab_size", "avg_stand_age","biomass_ratio")
  yr0LLP_metrics<-merge_twoLLP
  yr0LLP_metrics$time <- 80
  yr0LLP_metrics$hab_size[is.na(yr0LLP_metrics$hab_size)] <- 0
  
  #yr0LLP_metrics$all_avg <- (yr0LLP_metrics$hab_size + yr0LLP_metrics$avg_stand_age + yr0LLP_metrics$biomass_ratio)/3
  yr0LLP_metrics$all_avg <- yr0LLP_metrics$hab_size * yr0LLP_metrics$avg_stand_age * yr0LLP_metrics$biomass_ratio
  
  merge_onePmix<-merge(avghab_Pmix, avgstandage_Pmix, by="Standmap100", all=T)
  merge_twoPmix <- merge(merge_onePmix, avgstandratio_Pmix, by="Standmap100")
  #col <- c(1,3,5,7)
  #merge_twoPmix <- merge_twoPmix[,col]
  colnames(merge_twoPmix) <- c("stand_no", "hab_size", "avg_stand_age","biomass_ratio")
  yr0Pmix_metrics<-merge_twoPmix
  yr0Pmix_metrics$time <- 80
  yr0Pmix_metrics$hab_size[is.na(yr0Pmix_metrics$hab_size)] <- 0

  #yr0Pmix_metrics$all_avg <- (yr0Pmix_metrics$hab_size + yr0Pmix_metrics$avg_stand_age + yr0Pmix_metrics$biomass_ratio)/3
  yr0Pmix_metrics$all_avg <- yr0Pmix_metrics$hab_size * yr0Pmix_metrics$avg_stand_age * yr0Pmix_metrics$biomass_ratio
  
  merge_oneHmix<-merge(avghab_Hmix, avgstandage_Hmix, by="Standmap100", all=T)
  merge_twoHmix <- merge(merge_oneHmix, avgstandratio_Hmix, by="Standmap100")
  #col <- c(1,3,5,7)
  #merge_twoHmix <- merge_twoHmix[,col]
  colnames(merge_twoHmix) <- c("stand_no", "hab_size", "avg_stand_age","biomass_ratio")
  yr0Hmix_metrics<-merge_twoHmix
  yr0Hmix_metrics$time <- 80
  yr0Hmix_metrics$hab_size[is.na(yr0Hmix_metrics$hab_size)] <- 0

  #yr0Hmix_metrics$all_avg <- (yr0Hmix_metrics$hab_size + yr0Hmix_metrics$avg_stand_age + yr0Hmix_metrics$biomass_ratio)/3
  yr0Hmix_metrics$all_avg <- yr0Hmix_metrics$hab_size * yr0Hmix_metrics$avg_stand_age * yr0Hmix_metrics$biomass_ratio
  
  write.csv(yr0LLP_metrics, file=paste0(Drive,"/",i,"80LLP_std.csv"), row.names=F)
  write.csv(yr0Pmix_metrics, file=paste0(Drive,"/",i,"80Pmix_std.csv"), row.names=F)
  write.csv(yr0Hmix_metrics, file=paste0(Drive,"/",i,"80Hmix_std.csv"), row.names=F)
  
  
  LLP0 <- read.csv(paste0(Drive,"/",i,"0LLP_std.csv"))
  LLP0<- LLP0[LLP0$mgmtarea ==11,]
  LLP5 <- read.csv(paste0(Drive,"/",i,"5LLP_std.csv"))
  LLP5<- LLP5[LLP5$mgmtarea ==12,]
  LLP10 <- read.csv(paste0(Drive,"/",i,"10LLP_std.csv"))
  LLP10<- LLP10[LLP10$mgmtarea %in% c(13:14),]
  LLP20 <- read.csv(paste0(Drive,"/",i,"20LLP_std.csv"))
  LLP20<- LLP20[LLP20$mgmtarea ==15,]
  LLP25 <- read.csv(paste0(Drive,"/",i,"25LLP_std.csv"))
  LLP25<- LLP25[LLP25$mgmtarea %in% c(16:17),]
  LLP35 <- read.csv(paste0(Drive,"/",i,"35LLP_std.csv"))
  LLP35<- LLP35[LLP35$mgmtarea ==18,]
  LLP40 <- read.csv(paste0(Drive,"/",i,"40LLP_std.csv"))
  LLP40<- LLP40[LLP40$mgmtarea %in% c(19:20),]
  LLP50 <- read.csv(paste0(Drive,"/",i,"50LLP_std.csv"))
  LLP50<- LLP50[LLP50$mgmtarea ==21,]
  LLP55 <- read.csv(paste0(Drive,"/",i,"55LLP_std.csv"))
  LLP55<- LLP55[LLP55$mgmtarea %in% c(22:23),]
  LLP65 <- read.csv(paste0(Drive,"/",i,"65LLP_std.csv"))
  LLP65<- LLP65[LLP65$mgmtarea ==24,]
  LLP70 <- read.csv(paste0(Drive,"/",i,"70LLP_std.csv"))
  LLP70<- LLP70[LLP70$mgmtarea %in% c(25:26),]
  LLP75 <- read.csv(paste0(Drive,"/",i,"75LLP_std.csv"))
  LLP75<- LLP75[LLP75$mgmtarea ==27,]
  LLP80 <- read.csv(paste0(Drive,"/",i,"80LLP_std.csv"))
  LLP80$mgmtarea <- 100
  
  LLP0_80<- merge(LLP0, LLP80, by ="stand_no")
  LLP5_80<- merge(LLP5, LLP80, by ="stand_no")
  LLP10_80<- merge(LLP10, LLP80, by ="stand_no")
  LLP20_80<- merge(LLP20, LLP80, by ="stand_no")
  LLP25_80<- merge(LLP25, LLP80, by ="stand_no")
  LLP35_80<- merge(LLP35, LLP80, by ="stand_no")
  LLP40_80<- merge(LLP40, LLP80, by ="stand_no")
  LLP50_80<- merge(LLP50, LLP80, by ="stand_no")
  LLP55_80<- merge(LLP55, LLP80, by ="stand_no")
  LLP65_80<- merge(LLP65, LLP80, by ="stand_no")
  LLP70_80<- merge(LLP70, LLP80, by ="stand_no")
  LLP75_80<- merge(LLP75, LLP80, by ="stand_no")
  LLP_tbl<- rbind(LLP0_80,LLP5_80, LLP10_80,LLP20_80,LLP25_80,LLP35_80,LLP40_80,LLP50_80,LLP55_80,LLP65_80,LLP70_80,LLP75_80)
  LLP_all<- rbind(LLP0,LLP5,LLP10,LLP20,LLP25,LLP35,LLP40,LLP50,LLP55,LLP65,LLP70,LLP75,LLP80)
  write.csv(LLP_tbl, file=paste0("E:/Conservation velocity/",i,"geo_LLP_tbl_std.csv"), row.names=F)
  write.csv(LLP_all, file=paste0("E:/Conservation velocity/",i,"geo_LLP_all_std.csv"), row.names=F)
  
  Pmix0 <- read.csv(paste0(Drive,"/",i,"0Pmix_std.csv"))
  Pmix0<- Pmix0[Pmix0$mgmtarea ==11,]
  Pmix5 <- read.csv(paste0(Drive,"/",i,"5Pmix_std.csv"))
  Pmix5<- Pmix5[Pmix5$mgmtarea ==12,]
  Pmix10 <- read.csv(paste0(Drive,"/",i,"10Pmix_std.csv"))
  Pmix10<- Pmix10[Pmix10$mgmtarea %in% c(13:14),]
  Pmix20 <- read.csv(paste0(Drive,"/",i,"20Pmix_std.csv"))
  Pmix20<- Pmix20[Pmix20$mgmtarea ==15,]
  Pmix25 <- read.csv(paste0(Drive,"/",i,"25Pmix_std.csv"))
  Pmix25<- Pmix25[Pmix25$mgmtarea %in% c(16:17),]
  Pmix35 <- read.csv(paste0(Drive,"/",i,"35Pmix_std.csv"))
  Pmix35<- Pmix35[Pmix35$mgmtarea ==18,]
  Pmix40 <- read.csv(paste0(Drive,"/",i,"40Pmix_std.csv"))
  Pmix40<- Pmix40[Pmix40$mgmtarea %in% c(19:20),]
  Pmix50 <- read.csv(paste0(Drive,"/",i,"50Pmix_std.csv"))
  Pmix50<- Pmix50[Pmix50$mgmtarea ==21,]
  Pmix55 <- read.csv(paste0(Drive,"/",i,"55Pmix_std.csv"))
  Pmix55<- Pmix55[Pmix55$mgmtarea %in% c(22:23),]
  Pmix65 <- read.csv(paste0(Drive,"/",i,"65Pmix_std.csv"))
  Pmix65<- Pmix65[Pmix65$mgmtarea ==24,]
  Pmix70 <- read.csv(paste0(Drive,"/",i,"70Pmix_std.csv"))
  Pmix70<- Pmix70[Pmix70$mgmtarea %in% c(25:26),]
  Pmix75 <- read.csv(paste0(Drive,"/",i,"75Pmix_std.csv"))
  Pmix75<- Pmix75[Pmix75$mgmtarea ==27,]
  Pmix80 <- read.csv(paste0(Drive,"/",i,"80Pmix_std.csv"))
  Pmix80$mgmtarea <- 100
  
  Pmix0_80<- merge(Pmix0, Pmix80, by ="stand_no")
  Pmix5_80<- merge(Pmix5, Pmix80, by ="stand_no")
  Pmix10_80<- merge(Pmix10, Pmix80, by ="stand_no")
  Pmix20_80<- merge(Pmix20, Pmix80, by ="stand_no")
  Pmix25_80<- merge(Pmix25, Pmix80, by ="stand_no")
  Pmix35_80<- merge(Pmix35, Pmix80, by ="stand_no")
  Pmix40_80<- merge(Pmix40, Pmix80, by ="stand_no")
  Pmix50_80<- merge(Pmix50, Pmix80, by ="stand_no")
  Pmix55_80<- merge(Pmix55, Pmix80, by ="stand_no")
  Pmix65_80<- merge(Pmix65, Pmix80, by ="stand_no")
  Pmix70_80<- merge(Pmix70, Pmix80, by ="stand_no")
  Pmix75_80<- merge(Pmix75, Pmix80, by ="stand_no")
  Pmix_tbl<- rbind(Pmix0_80,Pmix5_80, Pmix10_80,Pmix20_80,Pmix25_80,Pmix35_80,Pmix40_80,Pmix50_80,Pmix55_80,Pmix65_80,Pmix70_80,Pmix75_80)
  Pmix_all<- rbind(Pmix0,Pmix5,Pmix10,Pmix20,Pmix25,Pmix35,Pmix40,Pmix50,Pmix55,Pmix65,Pmix70,Pmix75,Pmix80)
  write.csv(Pmix_tbl, file=paste0("E:/Conservation velocity/",i,"geo_Pmix_tbl_std.csv"), row.names=F)
  write.csv(Pmix_all, file=paste0("E:/Conservation velocity/",i,"geo_Pmix_all_std.csv"), row.names=F)
  
  Hmix0 <- read.csv(paste0(Drive,"/",i,"0Hmix_std.csv"))
  Hmix0<- Hmix0[Hmix0$mgmtarea ==11,]
  Hmix5 <- read.csv(paste0(Drive,"/",i,"5Hmix_std.csv"))
  Hmix5<- Hmix5[Hmix5$mgmtarea ==12,]
  Hmix10 <- read.csv(paste0(Drive,"/",i,"10Hmix_std.csv"))
  Hmix10<- Hmix10[Hmix10$mgmtarea %in% c(13:14),]
  Hmix20 <- read.csv(paste0(Drive,"/",i,"20Hmix_std.csv"))
  Hmix20<- Hmix20[Hmix20$mgmtarea ==15,]
  Hmix25 <- read.csv(paste0(Drive,"/",i,"25Hmix_std.csv"))
  Hmix25<- Hmix25[Hmix25$mgmtarea %in% c(16:17),]
  Hmix35 <- read.csv(paste0(Drive,"/",i,"35Hmix_std.csv"))
  Hmix35<- Hmix35[Hmix35$mgmtarea ==18,]
  Hmix40 <- read.csv(paste0(Drive,"/",i,"40Hmix_std.csv"))
  Hmix40<- Hmix40[Hmix40$mgmtarea %in% c(19:20),]
  Hmix50 <- read.csv(paste0(Drive,"/",i,"50Hmix_std.csv"))
  Hmix50<- Hmix50[Hmix50$mgmtarea ==21,]
  Hmix55 <- read.csv(paste0(Drive,"/",i,"55Hmix_std.csv"))
  Hmix55<- Hmix55[Hmix55$mgmtarea %in% c(22:23),]
  Hmix65 <- read.csv(paste0(Drive,"/",i,"65Hmix_std.csv"))
  Hmix65<- Hmix65[Hmix65$mgmtarea ==24,]
  Hmix70 <- read.csv(paste0(Drive,"/",i,"70Hmix_std.csv"))
  Hmix70<- Hmix70[Hmix70$mgmtarea %in% c(25:26),]
  Hmix75 <- read.csv(paste0(Drive,"/",i,"75Hmix_std.csv"))
  Hmix75<- Hmix75[Hmix75$mgmtarea ==27,]
  Hmix80 <- read.csv(paste0(Drive,"/",i,"80Hmix_std.csv"))
  Hmix80$mgmtarea <- 100
  
  Hmix0_80<- merge(Hmix0, Hmix80, by ="stand_no")
  Hmix5_80<- merge(Hmix5, Hmix80, by ="stand_no")
  Hmix10_80<- merge(Hmix10, Hmix80, by ="stand_no")
  Hmix20_80<- merge(Hmix20, Hmix80, by ="stand_no")
  Hmix25_80<- merge(Hmix25, Hmix80, by ="stand_no")
  Hmix35_80<- merge(Hmix35, Hmix80, by ="stand_no")
  Hmix40_80<- merge(Hmix40, Hmix80, by ="stand_no")
  Hmix50_80<- merge(Hmix50, Hmix80, by ="stand_no")
  Hmix55_80<- merge(Hmix55, Hmix80, by ="stand_no")
  Hmix65_80<- merge(Hmix65, Hmix80, by ="stand_no")
  Hmix70_80<- merge(Hmix70, Hmix80, by ="stand_no")
  Hmix75_80<- merge(Hmix75, Hmix80, by ="stand_no")
  Hmix_tbl<- rbind(Hmix0_80,Hmix5_80, Hmix10_80,Hmix20_80,Hmix25_80,Hmix35_80,Hmix40_80,Hmix50_80,Hmix55_80,Hmix65_80,Hmix70_80,Hmix75_80)
  Hmix_all<- rbind(Hmix0,Hmix5,Hmix10,Hmix20,Hmix25,Hmix35,Hmix40,Hmix50,Hmix55,Hmix65,Hmix70,Hmix75,Hmix80)
  write.csv(Hmix_tbl, file=paste0("E:/Conservation velocity/",i,"geo_Hmix_tbl_std.csv"), row.names=F)
  write.csv(Hmix_all, file=paste0("E:/Conservation velocity/",i,"geo_Hmix_all_std.csv"), row.names=F)
  
  
}

###################################### find con velocity ############

Drive <- "E:/Conservation velocity/"

#To standardize scores, must bring all outputs together for every time step and conservation strategy for each restoration type.

#Pmix
cluster_bcc45_Pmix <- read.csv(paste0(Drive,"bcccluster_Pmix_all_std.csv"))
cluster_bcc45_Pmix$strat <- "cluster"
cluster_bcc45_Pmix$rep <- "bcc"
cluster_CNRM45_Pmix <- read.csv(paste0(Drive,"CNRMcluster_Pmix_all_std.csv"))
cluster_CNRM45_Pmix$strat <- "cluster"
cluster_CNRM45_Pmix$rep <- "CNRM"
cluster_HadGEM45_Pmix <- read.csv(paste0(Drive,"Had-GEMcluster_Pmix_all_std.csv"))
cluster_HadGEM45_Pmix$strat <- "cluster"
cluster_HadGEM45_Pmix$rep <- "HadGEM"
cluster_IPSL45_Pmix <- read.csv(paste0(Drive,"IPSLcluster_Pmix_all_std.csv"))
cluster_IPSL45_Pmix$strat <- "cluster"
cluster_IPSL45_Pmix$rep <- "IPSL"
cluster_NorESM45_Pmix <- read.csv(paste0(Drive,"NorESMcluster_Pmix_all_std.csv"))
cluster_NorESM45_Pmix$strat <- "cluster"
cluster_NorESM45_Pmix$rep <- "NorESM"
econ_bcc45_Pmix <- read.csv(paste0(Drive,"bccecon_Pmix_all_std.csv"))
econ_bcc45_Pmix$strat <- "econ"
econ_bcc45_Pmix$rep <- "bcc"
econ_CNRM45_Pmix <- read.csv(paste0(Drive,"CNRMecon_Pmix_all_std.csv"))
econ_CNRM45_Pmix$strat <- "econ"
econ_CNRM45_Pmix$rep <- "CNRM"
econ_HadGEM45_Pmix <- read.csv(paste0(Drive,"Had-GEMecon_Pmix_all_std.csv"))
econ_HadGEM45_Pmix$strat <- "econ"
econ_HadGEM45_Pmix$rep <- "HadGEM"
econ_IPSL45_Pmix <- read.csv(paste0(Drive,"IPSLecon_Pmix_all_std.csv"))
econ_IPSL45_Pmix$strat <- "econ"
econ_IPSL45_Pmix$rep <- "IPSL"
econ_NorESM45_Pmix <- read.csv(paste0(Drive,"NorESMecon_Pmix_all_std.csv"))
econ_NorESM45_Pmix$strat <- "econ"
econ_NorESM45_Pmix$rep <- "NorESM"
geo_bcc45_Pmix <- read.csv(paste0(Drive,"bccgeo_Pmix_all_std.csv"))
geo_bcc45_Pmix$strat <- "geo"
geo_bcc45_Pmix$rep <- "bcc"
geo_CNRM45_Pmix <- read.csv(paste0(Drive,"CNRMgeo_Pmix_all_std.csv"))
geo_CNRM45_Pmix$strat <- "geo"
geo_CNRM45_Pmix$rep <- "CNRM"
geo_HadGEM45_Pmix <- read.csv(paste0(Drive,"Had-GEMgeo_Pmix_all_std.csv"))
geo_HadGEM45_Pmix$strat <- "geo"
geo_HadGEM45_Pmix$rep <- "HadGEM"
geo_IPSL45_Pmix <- read.csv(paste0(Drive,"IPSLgeo_Pmix_all_std.csv"))
geo_IPSL45_Pmix$strat <- "geo"
geo_IPSL45_Pmix$rep <- "IPSL"
geo_NorESM45_Pmix <- read.csv(paste0(Drive,"NorESMgeo_Pmix_all_std.csv"))
geo_NorESM45_Pmix$strat <- "geo"
geo_NorESM45_Pmix$rep <- "NorESM"
rand_bcc45_Pmix <- read.csv(paste0(Drive,"bccrand_Pmix_all_std.csv"))
rand_bcc45_Pmix$strat <- "rand"
rand_bcc45_Pmix$rep <- "bcc"
rand_CNRM45_Pmix <- read.csv(paste0(Drive,"CNRMrand_Pmix_all_std.csv"))
rand_CNRM45_Pmix$strat <- "rand"
rand_CNRM45_Pmix$rep <- "CNRM"
rand_HadGEM45_Pmix <- read.csv(paste0(Drive,"Had-GEMrand_Pmix_all_std.csv"))
rand_HadGEM45_Pmix$strat <- "rand"
rand_HadGEM45_Pmix$rep <- "HadGEM"
rand_IPSL45_Pmix <- read.csv(paste0(Drive,"IPSLrand_Pmix_all_std.csv"))
rand_IPSL45_Pmix$strat <- "rand"
rand_IPSL45_Pmix$rep <- "IPSL"
rand_NorESM45_Pmix <- read.csv(paste0(Drive,"NorESMrand_Pmix_all_std.csv"))
rand_NorESM45_Pmix$strat <- "rand"
rand_NorESM45_Pmix$rep <- "NorESM"


Pmix_all_std <- rbind(cluster_bcc45_Pmix,cluster_CNRM45_Pmix,cluster_HadGEM45_Pmix,cluster_IPSL45_Pmix,cluster_NorESM45_Pmix,econ_bcc45_Pmix,econ_CNRM45_Pmix,
                      econ_HadGEM45_Pmix,econ_IPSL45_Pmix,econ_NorESM45_Pmix,geo_bcc45_Pmix,geo_CNRM45_Pmix,geo_HadGEM45_Pmix,geo_IPSL45_Pmix,geo_NorESM45_Pmix,
                      rand_bcc45_Pmix,rand_CNRM45_Pmix,rand_HadGEM45_Pmix,rand_IPSL45_Pmix,rand_NorESM45_Pmix)
#standardize each habitat quality metric
Pmix_all_std$hab_size_std <- (Pmix_all_std$hab_size - mean(Pmix_all_std$hab_size)) / sd(Pmix_all_std$hab_size)
Pmix_all_std$avg_stand_age_std <- (Pmix_all_std$avg_stand_age - mean(Pmix_all_std$avg_stand_age)) / sd(Pmix_all_std$avg_stand_age)
Pmix_all_std$biomass_ratio_std <- (Pmix_all_std$biomass_ratio - mean(Pmix_all_std$biomass_ratio)) / sd(Pmix_all_std$biomass_ratio)
Pmix_all_std$hab_score <- Pmix_all_std$hab_size_std + Pmix_all_std$avg_stand_age_std + Pmix_all_std$biomass_ratio_std

#max and min
#par(mfrow=c(3,3))
#hist(Pmix_all_std$biomass_ratio_std, main="Pine mix restoration\nstandardized biomass ratio", xlab="Standardized biomass ratio", xlim=c(-3,5))
#hist(Pmix_all_std$avg_stand_age_std, main="Pine mix restoration\nstandardized mean age", xlab="Standardized mean age", xlim=c(-3,5))
#hist(Pmix_all_std$hab_size_std, main="Pine mix restoration\nstandardized habitat size", xlab="Standardized habitat size", xlim=c(-3,5))

#cluster
Pmix_all_std_cluster_pre <- Pmix_all_std[Pmix_all_std$strat == "cluster" & Pmix_all_std$time %in% c(0:75),]
Pmix_all_std_cluster_post <- Pmix_all_std[Pmix_all_std$strat == "cluster" & Pmix_all_std$time == 80,]
Pmix_all_std_cluster <- merge(Pmix_all_std_cluster_pre, Pmix_all_std_cluster_post, by=c("stand_no", "rep"))
Pmix_all_std_cluster$year_tot <- (Pmix_all_std_cluster$time.y - Pmix_all_std_cluster$time.x)/5
Pmix_all_std_cluster$delta <- Pmix_all_std_cluster$hab_score.y - Pmix_all_std_cluster$hab_score.x
Pmix_all_std_cluster$rate <- Pmix_all_std_cluster$delta/Pmix_all_std_cluster$year_tot
cv_cluster_Pmix_mean <- mean(Pmix_all_std_cluster$rate)
#write.csv(Pmix_all_std_cluster, file="E:/Conservation velocity/Pmix_all_std_cluster.csv")
pre_cluster_Pmix_mean <- mean(Pmix_all_std_cluster$hab_score.x)
post_cluster_Pmix_mean <- mean(Pmix_all_std_cluster$hab_score.y)
sd_cluster_Pmix <- sd(Pmix_all_std_cluster$rate)
se_cluster_Pmix <- std.error(Pmix_all_std_cluster[,27])

#econ
Pmix_all_std_econ_pre <- Pmix_all_std[Pmix_all_std$strat == "econ" & Pmix_all_std$time %in% c(0:75),]
Pmix_all_std_econ_post <- Pmix_all_std[Pmix_all_std$strat == "econ" & Pmix_all_std$time == 80,]
Pmix_all_std_econ <- merge(Pmix_all_std_econ_pre, Pmix_all_std_econ_post, by=c("stand_no", "rep"))
Pmix_all_std_econ$year_tot <- (Pmix_all_std_econ$time.y - Pmix_all_std_econ$time.x)/5
Pmix_all_std_econ$delta <- Pmix_all_std_econ$hab_score.y - Pmix_all_std_econ$hab_score.x
Pmix_all_std_econ$rate <- Pmix_all_std_econ$delta/Pmix_all_std_econ$year_tot
cv_econ_Pmix_mean <- mean(Pmix_all_std_econ$rate)
#write.csv(Pmix_all_std_econ, file="E:/Conservation velocity/Pmix_all_std_econ.csv")
pre_econ_Pmix_mean <- mean(Pmix_all_std_econ$hab_score.x)
post_econ_Pmix_mean <- mean(Pmix_all_std_econ$hab_score.y)
sd_econ_Pmix <- sd(Pmix_all_std_econ$rate)
se_econ_Pmix <- std.error(Pmix_all_std_econ$rate)

#geo
Pmix_all_std_geo_pre <- Pmix_all_std[Pmix_all_std$strat == "geo" & Pmix_all_std$time %in% c(0:75),]
Pmix_all_std_geo_post <- Pmix_all_std[Pmix_all_std$strat == "geo" & Pmix_all_std$time == 80,]
Pmix_all_std_geo <- merge(Pmix_all_std_geo_pre, Pmix_all_std_geo_post, by=c("stand_no", "rep"))
Pmix_all_std_geo$year_tot <- (Pmix_all_std_geo$time.y - Pmix_all_std_geo$time.x)/5
Pmix_all_std_geo$delta <- Pmix_all_std_geo$hab_score.y - Pmix_all_std_geo$hab_score.x
Pmix_all_std_geo$rate <- Pmix_all_std_geo$delta/Pmix_all_std_geo$year_tot
cv_geo_Pmix_mean <- mean(Pmix_all_std_geo$rate)
#write.csv(Pmix_all_std_geo, file="E:/Conservation velocity/Pmix_all_std_geo.csv")
pre_geo_Pmix_mean <- mean(Pmix_all_std_geo$hab_score.x)
post_geo_Pmix_mean <- mean(Pmix_all_std_geo$hab_score.y)
sd_geo_Pmix <- sd(Pmix_all_std_geo$rate)
se_geo_Pmix <- std.error(Pmix_all_std_geo$rate)

#rand
Pmix_all_std_rand_pre <- Pmix_all_std[Pmix_all_std$strat == "rand" & Pmix_all_std$time %in% c(0:75),]
Pmix_all_std_rand_post <- Pmix_all_std[Pmix_all_std$strat == "rand" & Pmix_all_std$time == 80,]
Pmix_all_std_rand <- merge(Pmix_all_std_rand_pre, Pmix_all_std_rand_post, by=c("stand_no", "rep"))
Pmix_all_std_rand$year_tot <- (Pmix_all_std_rand$time.y - Pmix_all_std_rand$time.x)/5
Pmix_all_std_rand$delta <- Pmix_all_std_rand$hab_score.y - Pmix_all_std_rand$hab_score.x
Pmix_all_std_rand$rate <- Pmix_all_std_rand$delta/Pmix_all_std_rand$year_tot
cv_rand_Pmix_mean <- mean(Pmix_all_std_rand$rate)
#write.csv(Pmix_all_std_rand, file="E:/Conservation velocity/Pmix_all_std_rand.csv")
pre_rand_Pmix_mean <- mean(Pmix_all_std_rand$hab_score.x)
post_rand_Pmix_mean <- mean(Pmix_all_std_rand$hab_score.y)
sd_rand_Pmix <- sd(Pmix_all_std_rand$rate)
se_rand_Pmix <- std.error(Pmix_all_std_rand$rate)

#Hmix
cluster_bcc45_Hmix <- read.csv(paste0(Drive,"bcccluster_Hmix_all_std.csv"))
cluster_bcc45_Hmix$strat <- "cluster"
cluster_bcc45_Hmix$rep <- "bcc"
cluster_CNRM45_Hmix <- read.csv(paste0(Drive,"CNRMcluster_Hmix_all_std.csv"))
cluster_CNRM45_Hmix$strat <- "cluster"
cluster_CNRM45_Hmix$rep <- "CNRM"
cluster_HadGEM45_Hmix <- read.csv(paste0(Drive,"Had-GEMcluster_Hmix_all_std.csv"))
cluster_HadGEM45_Hmix$strat <- "cluster"
cluster_HadGEM45_Hmix$rep <- "HadGEM"
cluster_IPSL45_Hmix <- read.csv(paste0(Drive,"IPSLcluster_Hmix_all_std.csv"))
cluster_IPSL45_Hmix$strat <- "cluster"
cluster_IPSL45_Hmix$rep <- "IPSL"
cluster_NorESM45_Hmix <- read.csv(paste0(Drive,"NorESMcluster_Hmix_all_std.csv"))
cluster_NorESM45_Hmix$strat <- "cluster"
cluster_NorESM45_Hmix$rep <- "NorESM"
econ_bcc45_Hmix <- read.csv(paste0(Drive,"bccecon_Hmix_all_std.csv"))
econ_bcc45_Hmix$strat <- "econ"
econ_bcc45_Hmix$rep <- "bcc"
econ_CNRM45_Hmix <- read.csv(paste0(Drive,"CNRMecon_Hmix_all_std.csv"))
econ_CNRM45_Hmix$strat <- "econ"
econ_CNRM45_Hmix$rep <- "CNRM"
econ_HadGEM45_Hmix <- read.csv(paste0(Drive,"Had-GEMecon_Hmix_all_std.csv"))
econ_HadGEM45_Hmix$strat <- "econ"
econ_HadGEM45_Hmix$rep <- "HadGEM"
econ_IPSL45_Hmix <- read.csv(paste0(Drive,"IPSLecon_Hmix_all_std.csv"))
econ_IPSL45_Hmix$strat <- "econ"
econ_IPSL45_Hmix$rep <- "IPSL"
econ_NorESM45_Hmix <- read.csv(paste0(Drive,"NorESMecon_Hmix_all_std.csv"))
econ_NorESM45_Hmix$strat <- "econ"
econ_NorESM45_Hmix$rep <- "NorESM"
geo_bcc45_Hmix <- read.csv(paste0(Drive,"bccgeo_Hmix_all_std.csv"))
geo_bcc45_Hmix$strat <- "geo"
geo_bcc45_Hmix$rep <- "bcc"
geo_CNRM45_Hmix <- read.csv(paste0(Drive,"CNRMgeo_Hmix_all_std.csv"))
geo_CNRM45_Hmix$strat <- "geo"
geo_CNRM45_Hmix$rep <- "CNRM"
geo_HadGEM45_Hmix <- read.csv(paste0(Drive,"Had-GEMgeo_Hmix_all_std.csv"))
geo_HadGEM45_Hmix$strat <- "geo"
geo_HadGEM45_Hmix$rep <- "HadGEM"
geo_IPSL45_Hmix <- read.csv(paste0(Drive,"IPSLgeo_Hmix_all_std.csv"))
geo_IPSL45_Hmix$strat <- "geo"
geo_IPSL45_Hmix$rep <- "IPSL"
geo_NorESM45_Hmix <- read.csv(paste0(Drive,"NorESMgeo_Hmix_all_std.csv"))
geo_NorESM45_Hmix$strat <- "geo"
geo_NorESM45_Hmix$rep <- "NorESM"
rand_bcc45_Hmix <- read.csv(paste0(Drive,"bccrand_Hmix_all_std.csv"))
rand_bcc45_Hmix$strat <- "rand"
rand_bcc45_Hmix$rep <- "bcc"
rand_CNRM45_Hmix <- read.csv(paste0(Drive,"CNRMrand_Hmix_all_std.csv"))
rand_CNRM45_Hmix$strat <- "rand"
rand_CNRM45_Hmix$rep <- "CNRM"
rand_HadGEM45_Hmix <- read.csv(paste0(Drive,"Had-GEMrand_Hmix_all_std.csv"))
rand_HadGEM45_Hmix$strat <- "rand"
rand_HadGEM45_Hmix$rep <- "HadGEM"
rand_IPSL45_Hmix <- read.csv(paste0(Drive,"IPSLrand_Hmix_all_std.csv"))
rand_IPSL45_Hmix$strat <- "rand"
rand_IPSL45_Hmix$rep <- "IPSL"
rand_NorESM45_Hmix <- read.csv(paste0(Drive,"NorESMrand_Hmix_all_std.csv"))
rand_NorESM45_Hmix$strat <- "rand"
rand_NorESM45_Hmix$rep <- "NorESM"


Hmix_all_std <- rbind(cluster_bcc45_Hmix,cluster_CNRM45_Hmix,cluster_HadGEM45_Hmix,cluster_IPSL45_Hmix,cluster_NorESM45_Hmix,econ_bcc45_Hmix,econ_CNRM45_Hmix,
                      econ_HadGEM45_Hmix,econ_IPSL45_Hmix,econ_NorESM45_Hmix,geo_bcc45_Hmix,geo_CNRM45_Hmix,geo_HadGEM45_Hmix,geo_IPSL45_Hmix,geo_NorESM45_Hmix,
                      rand_bcc45_Hmix,rand_CNRM45_Hmix,rand_HadGEM45_Hmix,rand_IPSL45_Hmix,rand_NorESM45_Hmix)
#standardize each habitat quality metric
Hmix_all_std$hab_size_std <- (Hmix_all_std$hab_size - mean(Hmix_all_std$hab_size)) / sd(Hmix_all_std$hab_size)
Hmix_all_std$avg_stand_age_std <- (Hmix_all_std$avg_stand_age - mean(Hmix_all_std$avg_stand_age)) / sd(Hmix_all_std$avg_stand_age)
Hmix_all_std$biomass_ratio_std <- (Hmix_all_std$biomass_ratio - mean(Hmix_all_std$biomass_ratio)) / sd(Hmix_all_std$biomass_ratio)
Hmix_all_std$hab_score <- Hmix_all_std$hab_size_std + Hmix_all_std$avg_stand_age_std + Hmix_all_std$biomass_ratio_std

#max and min
#par(mfrow=c(1,3))
#hist(Hmix_all_std$biomass_ratio_std, main="Hardwood mix restoration\nstandardized biomass ratio", xlab="Standardized biomass ratio", xlim=c(-3,5))
#hist(Hmix_all_std$avg_stand_age_std, main="Hardwood mix restoration\nstandardized mean age", xlab="Standardized mean age", xlim=c(-3,5))
#hist(Hmix_all_std$hab_size_std, main="Hardwood mix restoration\nstandardized habitat size", xlab="Standardized habitat size", xlim=c(-3,5))

#cluster
Hmix_all_std_cluster_pre <- Hmix_all_std[Hmix_all_std$strat == "cluster" & Hmix_all_std$time %in% c(0:75),]
Hmix_all_std_cluster_post <- Hmix_all_std[Hmix_all_std$strat == "cluster" & Hmix_all_std$time == 80,]
Hmix_all_std_cluster <- merge(Hmix_all_std_cluster_pre, Hmix_all_std_cluster_post, by=c("stand_no", "rep"))
Hmix_all_std_cluster$year_tot <- (Hmix_all_std_cluster$time.y - Hmix_all_std_cluster$time.x)/5
Hmix_all_std_cluster$delta <- Hmix_all_std_cluster$hab_score.y - Hmix_all_std_cluster$hab_score.x
Hmix_all_std_cluster$rate <- Hmix_all_std_cluster$delta/Hmix_all_std_cluster$year_tot
cv_cluster_Hmix_mean <- mean(Hmix_all_std_cluster$rate)
#write.csv(Hmix_all_std_cluster, file="E:/Conservation velocity/Hmix_all_std_cluster.csv")
pre_cluster_Hmix_mean <- mean(Hmix_all_std_cluster$hab_score.x)
post_cluster_Hmix_mean <- mean(Hmix_all_std_cluster$hab_score.y)
sd_cluster_Hmix <- sd(Hmix_all_std_cluster$rate)
se_cluster_Hmix <- std.error(Hmix_all_std_cluster$rate)

#econ
Hmix_all_std_econ_pre <- Hmix_all_std[Hmix_all_std$strat == "econ" & Hmix_all_std$time %in% c(0:75),]
Hmix_all_std_econ_post <- Hmix_all_std[Hmix_all_std$strat == "econ" & Hmix_all_std$time == 80,]
Hmix_all_std_econ <- merge(Hmix_all_std_econ_pre, Hmix_all_std_econ_post, by=c("stand_no", "rep"))
Hmix_all_std_econ$year_tot <- (Hmix_all_std_econ$time.y - Hmix_all_std_econ$time.x)/5
Hmix_all_std_econ$delta <- Hmix_all_std_econ$hab_score.y - Hmix_all_std_econ$hab_score.x
Hmix_all_std_econ$rate <- Hmix_all_std_econ$delta/Hmix_all_std_econ$year_tot
cv_econ_Hmix_mean <- mean(Hmix_all_std_econ$rate)
#write.csv(Hmix_all_std_econ, file="E:/Conservation velocity/Hmix_all_std_econ.csv")
pre_econ_Hmix_mean <- mean(Hmix_all_std_econ$hab_score.x)
post_econ_Hmix_mean <- mean(Hmix_all_std_econ$hab_score.y)
sd_econ_Hmix <- sd(Hmix_all_std_econ$rate)
se_econ_Hmix <- std.error(Hmix_all_std_econ$rate)

#geo
Hmix_all_std_geo_pre <- Hmix_all_std[Hmix_all_std$strat == "geo" & Hmix_all_std$time %in% c(0:75),]
Hmix_all_std_geo_post <- Hmix_all_std[Hmix_all_std$strat == "geo" & Hmix_all_std$time == 80,]
Hmix_all_std_geo <- merge(Hmix_all_std_geo_pre, Hmix_all_std_geo_post, by=c("stand_no", "rep"))
Hmix_all_std_geo$year_tot <- (Hmix_all_std_geo$time.y - Hmix_all_std_geo$time.x)/5
Hmix_all_std_geo$delta <- Hmix_all_std_geo$hab_score.y - Hmix_all_std_geo$hab_score.x
Hmix_all_std_geo$rate <- Hmix_all_std_geo$delta/Hmix_all_std_geo$year_tot
cv_geo_Hmix_mean <- mean(Hmix_all_std_geo$rate)
#write.csv(Hmix_all_std_geo, file="E:/Conservation velocity/Hmix_all_std_geo.csv")
pre_geo_Hmix_mean <- mean(Hmix_all_std_geo$hab_score.x)
post_geo_Hmix_mean <- mean(Hmix_all_std_geo$hab_score.y)
sd_geo_Hmix <- sd(Hmix_all_std_geo$rate)
se_geo_Hmix <- std.error(Hmix_all_std_geo$rate)

#rand
Hmix_all_std_rand_pre <- Hmix_all_std[Hmix_all_std$strat == "rand" & Hmix_all_std$time %in% c(0:75),]
Hmix_all_std_rand_post <- Hmix_all_std[Hmix_all_std$strat == "rand" & Hmix_all_std$time == 80,]
Hmix_all_std_rand <- merge(Hmix_all_std_rand_pre, Hmix_all_std_rand_post, by=c("stand_no", "rep"))
Hmix_all_std_rand$year_tot <- (Hmix_all_std_rand$time.y - Hmix_all_std_rand$time.x)/5
Hmix_all_std_rand$delta <- Hmix_all_std_rand$hab_score.y - Hmix_all_std_rand$hab_score.x
Hmix_all_std_rand$rate <- Hmix_all_std_rand$delta/Hmix_all_std_rand$year_tot
cv_rand_Hmix_mean <- mean(Hmix_all_std_rand$rate)
#write.csv(Hmix_all_std_rand, file="E:/Conservation velocity/Hmix_all_std_rand.csv")
pre_rand_Hmix_mean <- mean(Hmix_all_std_rand$hab_score.x)
post_rand_Hmix_mean <- mean(Hmix_all_std_rand$hab_score.y)
sd_rand_Hmix <- sd(Hmix_all_std_rand$rate)
se_rand_Hmix <- std.error(Hmix_all_std_rand$rate)

#LLP
cluster_bcc45_LLP <- read.csv(paste0(Drive,"bcccluster_LLP_all_std.csv"))
cluster_bcc45_LLP$strat <- "cluster"
cluster_bcc45_LLP$rep <- "bcc"
cluster_CNRM45_LLP <- read.csv(paste0(Drive,"CNRMcluster_LLP_all_std.csv"))
cluster_CNRM45_LLP$strat <- "cluster"
cluster_CNRM45_LLP$rep <- "CNRM"
cluster_HadGEM45_LLP <- read.csv(paste0(Drive,"Had-GEMcluster_LLP_all_std.csv"))
cluster_HadGEM45_LLP$strat <- "cluster"
cluster_HadGEM45_LLP$rep <- "HadGEM"
cluster_IPSL45_LLP <- read.csv(paste0(Drive,"IPSLcluster_LLP_all_std.csv"))
cluster_IPSL45_LLP$strat <- "cluster"
cluster_IPSL45_LLP$rep <- "IPSL"
cluster_NorESM45_LLP <- read.csv(paste0(Drive,"NorESMcluster_LLP_all_std.csv"))
cluster_NorESM45_LLP$strat <- "cluster"
cluster_NorESM45_LLP$rep <- "NorESM"
econ_bcc45_LLP <- read.csv(paste0(Drive,"bccecon_LLP_all_std.csv"))
econ_bcc45_LLP$strat <- "econ"
econ_bcc45_LLP$rep <- "bcc"
econ_CNRM45_LLP <- read.csv(paste0(Drive,"CNRMecon_LLP_all_std.csv"))
econ_CNRM45_LLP$strat <- "econ"
econ_CNRM45_LLP$rep <- "CNRM"
econ_HadGEM45_LLP <- read.csv(paste0(Drive,"Had-GEMecon_LLP_all_std.csv"))
econ_HadGEM45_LLP$strat <- "econ"
econ_HadGEM45_LLP$rep <- "HadGEM"
econ_IPSL45_LLP <- read.csv(paste0(Drive,"IPSLecon_LLP_all_std.csv"))
econ_IPSL45_LLP$strat <- "econ"
econ_IPSL45_LLP$rep <- "IPSL"
econ_NorESM45_LLP <- read.csv(paste0(Drive,"NorESMecon_LLP_all_std.csv"))
econ_NorESM45_LLP$strat <- "econ"
econ_NorESM45_LLP$rep <- "NorESM"
geo_bcc45_LLP <- read.csv(paste0(Drive,"bccgeo_LLP_all_std.csv"))
geo_bcc45_LLP$strat <- "geo"
geo_bcc45_LLP$rep <- "bcc"
geo_CNRM45_LLP <- read.csv(paste0(Drive,"CNRMgeo_LLP_all_std.csv"))
geo_CNRM45_LLP$strat <- "geo"
geo_CNRM45_LLP$rep <- "CNRM"
geo_HadGEM45_LLP <- read.csv(paste0(Drive,"Had-GEMgeo_LLP_all_std.csv"))
geo_HadGEM45_LLP$strat <- "geo"
geo_HadGEM45_LLP$rep <- "HadGEM"
geo_IPSL45_LLP <- read.csv(paste0(Drive,"IPSLgeo_LLP_all_std.csv"))
geo_IPSL45_LLP$strat <- "geo"
geo_IPSL45_LLP$rep <- "IPSL"
geo_NorESM45_LLP <- read.csv(paste0(Drive,"NorESMgeo_LLP_all_std.csv"))
geo_NorESM45_LLP$strat <- "geo"
geo_NorESM45_LLP$rep <- "NorESM"
rand_bcc45_LLP <- read.csv(paste0(Drive,"bccrand_LLP_all_std.csv"))
rand_bcc45_LLP$strat <- "rand"
rand_bcc45_LLP$rep <- "bcc"
rand_CNRM45_LLP <- read.csv(paste0(Drive,"CNRMrand_LLP_all_std.csv"))
rand_CNRM45_LLP$strat <- "rand"
rand_CNRM45_LLP$rep <- "CNRM"
rand_HadGEM45_LLP <- read.csv(paste0(Drive,"Had-GEMrand_LLP_all_std.csv"))
rand_HadGEM45_LLP$strat <- "rand"
rand_HadGEM45_LLP$rep <- "HadGEM"
rand_IPSL45_LLP <- read.csv(paste0(Drive,"IPSLrand_LLP_all_std.csv"))
rand_IPSL45_LLP$strat <- "rand"
rand_IPSL45_LLP$rep <- "IPSL"
rand_NorESM45_LLP <- read.csv(paste0(Drive,"NorESMrand_LLP_all_std.csv"))
rand_NorESM45_LLP$strat <- "rand"
rand_NorESM45_LLP$rep <- "NorESM"


LLP_all_std <- rbind(cluster_bcc45_LLP,cluster_CNRM45_LLP,cluster_HadGEM45_LLP,cluster_IPSL45_LLP,cluster_NorESM45_LLP,econ_bcc45_LLP,econ_CNRM45_LLP,
                      econ_HadGEM45_LLP,econ_IPSL45_LLP,econ_NorESM45_LLP,geo_bcc45_LLP,geo_CNRM45_LLP,geo_HadGEM45_LLP,geo_IPSL45_LLP,geo_NorESM45_LLP,
                      rand_bcc45_LLP,rand_CNRM45_LLP,rand_HadGEM45_LLP,rand_IPSL45_LLP,rand_NorESM45_LLP)
#standardize each habitat quality metric
LLP_all_std$hab_size_std <- (LLP_all_std$hab_size - mean(LLP_all_std$hab_size)) / sd(LLP_all_std$hab_size)
LLP_all_std$avg_stand_age_std <- (LLP_all_std$avg_stand_age - mean(LLP_all_std$avg_stand_age)) / sd(LLP_all_std$avg_stand_age)
LLP_all_std$biomass_ratio_std <- (LLP_all_std$biomass_ratio - mean(LLP_all_std$biomass_ratio)) / sd(LLP_all_std$biomass_ratio)
LLP_all_std$hab_score <- LLP_all_std$hab_size_std + LLP_all_std$avg_stand_age_std + LLP_all_std$biomass_ratio_std

#max and min
#par(mfrow=c(3,3))
#hist(LLP_all_std$biomass_ratio_std, main="Longleaf mix restoration\nstandardized biomass ratio", xlab="Standardized biomass ratio", xlim=c(-3,5))
#hist(LLP_all_std$avg_stand_age_std, main="Longleaf mix restoration\nstandardized mean age", xlab="Standardized mean age", xlim=c(-3,5))
#hist(LLP_all_std$hab_size_std, main="Longleaf mix restoration\nstandardized habitat size", xlab="Standardized habitat size", xlim=c(-3,5))

#cluster
LLP_all_std_cluster_pre <- LLP_all_std[LLP_all_std$strat == "cluster" & LLP_all_std$time %in% c(0:75),]
LLP_all_std_cluster_post <- LLP_all_std[LLP_all_std$strat == "cluster" & LLP_all_std$time == 80,]
LLP_all_std_cluster <- merge(LLP_all_std_cluster_pre, LLP_all_std_cluster_post, by=c("stand_no", "rep"))
LLP_all_std_cluster$year_tot <- (LLP_all_std_cluster$time.y - LLP_all_std_cluster$time.x)/5
LLP_all_std_cluster$delta <- LLP_all_std_cluster$hab_score.y - LLP_all_std_cluster$hab_score.x
LLP_all_std_cluster$rate <- LLP_all_std_cluster$delta/LLP_all_std_cluster$year_tot
cv_cluster_LLP_mean <- mean(LLP_all_std_cluster$rate)
#write.csv(LLP_all_std_cluster, file="E:/Conservation velocity/LLP_all_std_cluster.csv")
pre_cluster_LLP_mean <- mean(LLP_all_std_cluster$hab_score.x)
post_cluster_LLP_mean <- mean(LLP_all_std_cluster$hab_score.y)
sd_cluster_LLP <- sd(LLP_all_std_cluster$rate)
se_cluster_LLP <- std.error(LLP_all_std_cluster$rate)

#econ
LLP_all_std_econ_pre <- LLP_all_std[LLP_all_std$strat == "econ" & LLP_all_std$time %in% c(0:75),]
LLP_all_std_econ_post <- LLP_all_std[LLP_all_std$strat == "econ" & LLP_all_std$time == 80,]
LLP_all_std_econ <- merge(LLP_all_std_econ_pre, LLP_all_std_econ_post, by=c("stand_no", "rep"))
LLP_all_std_econ$year_tot <- (LLP_all_std_econ$time.y - LLP_all_std_econ$time.x)/5
LLP_all_std_econ$delta <- LLP_all_std_econ$hab_score.y - LLP_all_std_econ$hab_score.x
LLP_all_std_econ$rate <- LLP_all_std_econ$delta/LLP_all_std_econ$year_tot
cv_econ_LLP_mean <- mean(LLP_all_std_econ$rate)
#write.csv(LLP_all_std_econ, file="E:/Conservation velocity/LLP_all_std_econ.csv")
pre_econ_LLP_mean <- mean(LLP_all_std_econ$hab_score.x)
post_econ_LLP_mean <- mean(LLP_all_std_econ$hab_score.y)
sd_econ_LLP <- sd(LLP_all_std_econ$rate)
se_econ_LLP <- std.error(LLP_all_std_econ$rate)

#geo
LLP_all_std_geo_pre <- LLP_all_std[LLP_all_std$strat == "geo" & LLP_all_std$time %in% c(0:75),]
LLP_all_std_geo_post <- LLP_all_std[LLP_all_std$strat == "geo" & LLP_all_std$time == 80,]
LLP_all_std_geo <- merge(LLP_all_std_geo_pre, LLP_all_std_geo_post, by=c("stand_no", "rep"))
LLP_all_std_geo$year_tot <- (LLP_all_std_geo$time.y - LLP_all_std_geo$time.x)/5
LLP_all_std_geo$delta <- LLP_all_std_geo$hab_score.y - LLP_all_std_geo$hab_score.x
LLP_all_std_geo$rate <- LLP_all_std_geo$delta/LLP_all_std_geo$year_tot
cv_geo_LLP_mean <- mean(LLP_all_std_geo$rate)
#write.csv(LLP_all_std_geo, file="E:/Conservation velocity/LLP_all_std_geo.csv")
pre_geo_LLP_mean <- mean(LLP_all_std_geo$hab_score.x)
post_geo_LLP_mean <- mean(LLP_all_std_geo$hab_score.y)
sd_geo_LLP <- sd(LLP_all_std_geo$rate)
se_geo_LLP <- std.error(LLP_all_std_geo$rate)

#rand
LLP_all_std_rand_pre <- LLP_all_std[LLP_all_std$strat == "rand" & LLP_all_std$time %in% c(0:75),]
LLP_all_std_rand_post <- LLP_all_std[LLP_all_std$strat == "rand" & LLP_all_std$time == 80,]
LLP_all_std_rand <- merge(LLP_all_std_rand_pre, LLP_all_std_rand_post, by=c("stand_no", "rep"))
LLP_all_std_rand$year_tot <- (LLP_all_std_rand$time.y - LLP_all_std_rand$time.x)/5
LLP_all_std_rand$delta <- LLP_all_std_rand$hab_score.y - LLP_all_std_rand$hab_score.x
LLP_all_std_rand$rate <- LLP_all_std_rand$delta/LLP_all_std_rand$year_tot
cv_rand_LLP_mean <- mean(LLP_all_std_rand$rate)
#write.csv(LLP_all_std_rand, file="E:/Conservation velocity/LLP_all_std_rand.csv")
pre_rand_LLP_mean <- mean(LLP_all_std_rand$hab_score.x)
post_rand_LLP_mean <- mean(LLP_all_std_rand$hab_score.y)
sd_rand_LLP <- sd(LLP_all_std_rand$rate)
se_rand_LLP <- std.error(LLP_all_std_rand$rate)


#################### graphs #########################

#Pre/post habitat quality scores
par(mfrow=c(1,1))

#cluster
Pmix_all_std_cluster$type<-"PM"
Hmix_all_std_cluster$type<-"HM"
LLP_all_std_cluster$type<-"LL"
#econ
Pmix_all_std_econ$type<-"PM"
Hmix_all_std_econ$type<-"HM"
LLP_all_std_econ$type<-"LL"
#geo
Pmix_all_std_geo$type<-"PM"
Hmix_all_std_geo$type<-"HM"
LLP_all_std_geo$type<-"LL"
#rand
Pmix_all_std_rand$type<-"PM"
Hmix_all_std_rand$type<-"HM"
LLP_all_std_rand$type<-"LL"


##########################use this one it works!!!!!!!!!!!!!!!!!!!!!!!!!!!#############################

par(mfrow=c(4,3), tcl=-0.5)
#cluster
par(mai=c(0.25,0.6,0,0))
for (i in 1:length(LLP_all_std_cluster$stand_no)){
  print(i)
  ### Sort the data frame plotable. 
  df<-data.frame(x=c(LLP_all_std_cluster$time.x[i],LLP_all_std_cluster$time.y[i]),y=c(LLP_all_std_cluster$hab_score.x[i],LLP_all_std_cluster$hab_score.y[i]), 
                 name=c(LLP_all_std_cluster$type[i],LLP_all_std_cluster$type[i]))
  if(i==1){
  plot(df$x,df$y,type="l",col=alpha("gray40", 0.1), xlab='', ylab= expression(paste(Delta,"Hq cluster")), xlim=c(0,80), ylim=c(-5,25), xaxt="n")}else{
    lines(df$x,df$y,col=alpha("gray40", 0.1))}
  axis(1, labels=FALSE)
}

par(mai=c(0.25,0.4,0,0.2))
for (i in 1:length(Pmix_all_std_cluster$stand_no)){
  print(i)
  ### Sort the data frame plotable. 
  df<-data.frame(x=c(Pmix_all_std_cluster$time.x[i],Pmix_all_std_cluster$time.y[i]),y=c(Pmix_all_std_cluster$hab_score.x[i],Pmix_all_std_cluster$hab_score.y[i]), 
                 name=c(Pmix_all_std_cluster$type[i],Pmix_all_std_cluster$type[i]))
  if(i==1){
    plot(df$x,df$y,type="l",col=alpha("gray40", 0.1), xlab='', ylab='', xlim=c(0,80), ylim=c(-5,25), xaxt="n", yaxt="n")}else{
      lines(df$x,df$y,col=alpha("gray40", 0.1))}
  axis(1, labels=FALSE)
  axis(2, labels=FALSE)
}

par(mai=c(0.25,0.2,0,0.4))
for (i in 1:length(Hmix_all_std_cluster$stand_no)){
  print(i)
  ### Sort the data frame plotable. 
  df<-data.frame(x=c(Hmix_all_std_cluster$time.x[i],Hmix_all_std_cluster$time.y[i]),y=c(Hmix_all_std_cluster$hab_score.x[i],Hmix_all_std_cluster$hab_score.y[i]), 
                 name=c(Hmix_all_std_cluster$type[i],Hmix_all_std_cluster$type[i]))
  if(i==1){
    plot(df$x,df$y,type="l",col=alpha("gray40", 0.1), xlab='', ylab='', xlim=c(0,80), ylim=c(-5,25), xaxt="n", yaxt="n")}else{
      lines(df$x,df$y,col=alpha("gray40", 0.1))}
  axis(1, labels=FALSE)
  axis(2, labels=FALSE)
}


#econ
par(mai=c(0.25,0.6,0,0))
for (i in 1:length(LLP_all_std_econ$stand_no)){
  print(i)
  ### Sort the data frame plotable. 
  df<-data.frame(x=c(LLP_all_std_econ$time.x[i],LLP_all_std_econ$time.y[i]),y=c(LLP_all_std_econ$hab_score.x[i],LLP_all_std_econ$hab_score.y[i]), 
                 name=c(LLP_all_std_econ$type[i],LLP_all_std_econ$type[i]))
  if(i==1){
    plot(df$x,df$y,type="l",col=alpha("gray40", 0.1), xlab='', ylab= expression(paste(Delta,"Hq economic")), xlim=c(0,80), ylim=c(-5,25), xaxt="n")}else{
      lines(df$x,df$y,col=alpha("gray40", 0.1))}
  axis(1, labels=FALSE)
}
par(mai=c(0.25,0.4,0,0.2))
for (i in 1:length(Pmix_all_std_econ$stand_no)){
  print(i)
  ### Sort the data frame plotable. 
  df<-data.frame(x=c(Pmix_all_std_econ$time.x[i],Pmix_all_std_econ$time.y[i]),y=c(Pmix_all_std_econ$hab_score.x[i],Pmix_all_std_econ$hab_score.y[i]), 
                 name=c(Pmix_all_std_econ$type[i],Pmix_all_std_econ$type[i]))
  if(i==1){
    plot(df$x,df$y,type="l",col=alpha("gray40", 0.1), xlab='', ylab='', xlim=c(0,80), ylim=c(-5,25), xaxt="n", yaxt="n")}else{
      lines(df$x,df$y,col=alpha("gray40", 0.1))}
  axis(1, labels=FALSE)
  axis(2, labels=FALSE)
}
par(mai=c(0.25,0.2,0,0.4))
for (i in 1:length(Hmix_all_std_econ$stand_no)){
  print(i)
  ### Sort the data frame plotable. 
  df<-data.frame(x=c(Hmix_all_std_econ$time.x[i],Hmix_all_std_econ$time.y[i]),y=c(Hmix_all_std_econ$hab_score.x[i],Hmix_all_std_econ$hab_score.y[i]), 
                 name=c(Hmix_all_std_econ$type[i],Hmix_all_std_econ$type[i]))
  if(i==1){
    plot(df$x,df$y,type="l",col=alpha("gray40", 0.1), xlab='', ylab='', xlim=c(0,80), ylim=c(-5,25), xaxt="n", yaxt="n")}else{
      lines(df$x,df$y,col=alpha("gray40", 0.1))}
  axis(1, labels=FALSE)
  axis(2, labels=FALSE)
}

#geo
par(mai=c(0.25,0.6,0,0))
for (i in 1:length(LLP_all_std_geo$stand_no)){
  print(i)
  ### Sort the data frame plotable. 
  df<-data.frame(x=c(LLP_all_std_geo$time.x[i],LLP_all_std_geo$time.y[i]),y=c(LLP_all_std_geo$hab_score.x[i],LLP_all_std_geo$hab_score.y[i]), 
                 name=c(LLP_all_std_geo$type[i],LLP_all_std_geo$type[i]))
  if(i==1){
    plot(df$x,df$y,type="l",col=alpha("gray40", 0.1), xlab='', ylab= expression(paste(Delta,"Hq geodiversity")), xlim=c(0,80), ylim=c(-5,25), xaxt="n")}else{
      lines(df$x,df$y,col=alpha("gray40", 0.1))}
  axis(1, labels=FALSE)
}
par(mai=c(0.25,0.4,0,0.2))
for (i in 1:length(Pmix_all_std_geo$stand_no)){
  print(i)
  ### Sort the data frame plotable. 
  df<-data.frame(x=c(Pmix_all_std_geo$time.x[i],Pmix_all_std_geo$time.y[i]),y=c(Pmix_all_std_geo$hab_score.x[i],Pmix_all_std_geo$hab_score.y[i]), 
                 name=c(Pmix_all_std_geo$type[i],Pmix_all_std_geo$type[i]))
  if(i==1){
    plot(df$x,df$y,type="l",col=alpha("gray40", 0.1), xlab='', ylab='', xlim=c(0,80), ylim=c(-5,25), xaxt="n", yaxt="n")}else{
      lines(df$x,df$y,col=alpha("gray40", 0.1))}
  axis(1, labels=FALSE)
  axis(2, labels=FALSE)
}
par(mai=c(0.25,0.2,0,0.4))
for (i in 1:length(Hmix_all_std_geo$stand_no)){
  print(i)
  ### Sort the data frame plotable. 
  df<-data.frame(x=c(Hmix_all_std_geo$time.x[i],Hmix_all_std_geo$time.y[i]),y=c(Hmix_all_std_geo$hab_score.x[i],Hmix_all_std_geo$hab_score.y[i]), 
                 name=c(Hmix_all_std_geo$type[i],Hmix_all_std_geo$type[i]))
  if(i==1){
    plot(df$x,df$y,type="l",col=alpha("gray40", 0.1), xlab='', ylab='', xlim=c(0,80), ylim=c(-5,25), xaxt="n", yaxt="n")}else{
      lines(df$x,df$y,col=alpha("gray40", 0.1))}
  axis(1, labels=FALSE)
  axis(2, labels=FALSE)
}

#rand
par(mai=c(0.25,0.6,0,0))
for (i in 1:length(LLP_all_std_rand$stand_no)){
  print(i)
  ### Sort the data frame plotable. 
  df<-data.frame(x=c(LLP_all_std_rand$time.x[i],LLP_all_std_rand$time.y[i]),y=c(LLP_all_std_rand$hab_score.x[i],LLP_all_std_rand$hab_score.y[i]), 
                 name=c(LLP_all_std_rand$type[i],LLP_all_std_rand$type[i]))
  if(i==1){
    plot(df$x,df$y,type="l",col=alpha("gray40", 0.1), xlab='', ylab= expression(paste(Delta,"Hq opportunistic")), xlim=c(0,80), ylim=c(-5,25))}else{
      lines(df$x,df$y,col=alpha("gray40", 0.1))}
}
par(mai=c(0.25,0.4,0,0.2))
for (i in 1:length(Pmix_all_std_rand$stand_no)){
  print(i)
  ### Sort the data frame plotable. 
  df<-data.frame(x=c(Pmix_all_std_rand$time.x[i],Pmix_all_std_rand$time.y[i]),y=c(Pmix_all_std_rand$hab_score.x[i],Pmix_all_std_rand$hab_score.y[i]), 
                 name=c(Pmix_all_std_rand$type[i],Pmix_all_std_rand$type[i]))
  if(i==1){
    plot(df$x,df$y,type="l",col=alpha("gray40", 0.1), xlab='', ylab='', xlim=c(0,80), ylim=c(-5,25), yaxt="n")}else{
      lines(df$x,df$y,col=alpha("gray40", 0.1))}
  axis(2, labels=FALSE)
}
par(mai=c(0.25,0.2,0,0.4))
for (i in 1:length(Hmix_all_std_rand$stand_no)){
  print(i)
  ### Sort the data frame plotable. 
  df<-data.frame(x=c(Hmix_all_std_rand$time.x[i],Hmix_all_std_rand$time.y[i]),y=c(Hmix_all_std_rand$hab_score.x[i],Hmix_all_std_rand$hab_score.y[i]), 
                 name=c(Hmix_all_std_rand$type[i],Hmix_all_std_rand$type[i]))
  if(i==1){
    plot(df$x,df$y,type="l",col=alpha("gray40", 0.1), xlab='', ylab='', xlim=c(0,80), ylim=c(-5,25), yaxt="n")}else{
      lines(df$x,df$y,col=alpha("gray40", 0.1))}
  axis(2, labels=FALSE)
}

mtext("Time", side=1, outer=T, at=0.5)


############################################Pre/post graph####################################
prepost<- read.csv("E:/Conservation velocity/Prepost_scores.csv")

par(mfrow=c(1,1))
plot(1, type="n", xlab="Conservation strategy", ylab=expression(paste(Delta,"Habitat Quality")), xlim=c(0, 16), ylim=c(-2.5, 3.3), xaxt="n")
xtick<-seq(2, 14, by=4)
axis(1, at=xtick, labels=c("Cluster", "Economic", "Geodiversity", "Opportunistic"))
legend(0,3.3, legend=c("Longleaf", "Pine mix", "Hardwood mix"), col="black", lty=c(1,2,4), title="Restoration type", cex=0.75)

points(x=c(prepost$Cluster.X0[1], prepost$Cluster.X1[1]), y=c(prepost$Cluster.Y0[1], prepost$Cluster.Y1[1]), pch=16, col="black")
arrows(x0=prepost$Cluster.X0[1], y0=prepost$Cluster.Y0[1], x1=prepost$Cluster.X1[1], y1=prepost$Cluster.Y1[1], col="black", lty=1)
points(x=c(prepost$Cluster.X0[2], prepost$Cluster.X1[2]), y=c(prepost$Cluster.Y0[2], prepost$Cluster.Y1[2]), pch=16, col="black")
arrows(x0=prepost$Cluster.X0[2], y0=prepost$Cluster.Y0[2], x1=prepost$Cluster.X1[2], y1=prepost$Cluster.Y1[2], col="black", lty=2)
points(x=c(prepost$Cluster.X0[3], prepost$Cluster.X1[3]), y=c(prepost$Cluster.Y0[3], prepost$Cluster.Y1[3]), pch=16, col="black")
arrows(x0=prepost$Cluster.X0[3], y0=prepost$Cluster.Y0[3], x1=prepost$Cluster.X1[3], y1=prepost$Cluster.Y1[3], col="black", lty=4)

points(x=c(prepost$Economic.X0[1], prepost$Economic.X1[1]), y=c(prepost$Economic.Y0[1], prepost$Economic.Y1[1]), pch=16, col="black")
arrows(x0=prepost$Economic.X0[1], y0=prepost$Economic.Y0[1], x1=prepost$Economic.X1[1], y1=prepost$Economic.Y1[1], col="black", lty=1)
points(x=c(prepost$Economic.X0[2], prepost$Economic.X1[2]), y=c(prepost$Economic.Y0[2], prepost$Economic.Y1[2]), pch=16, col="black")
arrows(x0=prepost$Economic.X0[2], y0=prepost$Economic.Y0[2], x1=prepost$Economic.X1[2], y1=prepost$Economic.Y1[2], col="black", lty=2)
points(x=c(prepost$Economic.X0[3], prepost$Economic.X1[3]), y=c(prepost$Economic.Y0[3], prepost$Economic.Y1[3]), pch=16, col="black")
arrows(x0=prepost$Economic.X0[3], y0=prepost$Economic.Y0[3], x1=prepost$Economic.X1[3], y1=prepost$Economic.Y1[3], col="black", lty=4)

points(x=c(prepost$Geodiversity.X0[1], prepost$Geodiversity.X1[1]), y=c(prepost$Geodiversity.Y0[1], prepost$Geodiversity.Y1[1]), pch=16, col="black")
arrows(x0=prepost$Geodiversity.X0[1], y0=prepost$Geodiversity.Y0[1], x1=prepost$Geodiversity.X1[1], y1=prepost$Geodiversity.Y1[1], col="black", lty=1)
points(x=c(prepost$Geodiversity.X0[2], prepost$Geodiversity.X1[2]), y=c(prepost$Geodiversity.Y0[2], prepost$Geodiversity.Y1[2]), pch=16, col="black")
arrows(x0=prepost$Geodiversity.X0[2], y0=prepost$Geodiversity.Y0[2], x1=prepost$Geodiversity.X1[2], y1=prepost$Geodiversity.Y1[2], col="black", lty=2)
points(x=c(prepost$Geodiversity.X0[3], prepost$Geodiversity.X1[3]), y=c(prepost$Geodiversity.Y0[3], prepost$Geodiversity.Y1[3]), pch=16, col="black")
arrows(x0=prepost$Geodiversity.X0[3], y0=prepost$Geodiversity.Y0[3], x1=prepost$Geodiversity.X1[3], y1=prepost$Geodiversity.Y1[3], col="black", lty=4)

points(x=c(prepost$Opportunistic.X0[1], prepost$Opportunistic.X1[1]), y=c(prepost$Opportunistic.Y0[1], prepost$Opportunistic.Y1[1]), pch=16, col="black")
arrows(x0=prepost$Opportunistic.X0[1], y0=prepost$Opportunistic.Y0[1], x1=prepost$Opportunistic.X1[1], y1=prepost$Opportunistic.Y1[1], col="black", lty=1)
points(x=c(prepost$Opportunistic.X0[2], prepost$Opportunistic.X1[2]), y=c(prepost$Opportunistic.Y0[2], prepost$Opportunistic.Y1[2]), pch=16, col="black")
arrows(x0=prepost$Opportunistic.X0[2], y0=prepost$Opportunistic.Y0[2], x1=prepost$Opportunistic.X1[2], y1=prepost$Opportunistic.Y1[2], col="black", lty=2)
points(x=c(prepost$Opportunistic.X0[3], prepost$Opportunistic.X1[3]), y=c(prepost$Opportunistic.Y0[3], prepost$Opportunistic.Y1[3]), pch=16, col="black")
arrows(x0=prepost$Opportunistic.X0[3], y0=prepost$Opportunistic.Y0[3], x1=prepost$Opportunistic.X1[3], y1=prepost$Opportunistic.Y1[3], col="black", lty=4)

################################bar graph with error bars################################
install.packages("remotes")
remotes::install_github("coolbutuseless/ggpattern")

cvsd<- read.csv("E:/Conservation velocity/CV_SD.csv")
cvsd$Restoration_approach <- factor(cvsd$Restoration_approach,levels = c("Longleaf restoration", "Pine mix restoration", "Hwood mix restoration"))
ggplot(cvsd, aes(fill=Conservation_strategy, y=Vcons, x=Restoration_approach)) + 
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), panel.background = element_blank(), axis.text=element_text(size=12), axis.title=element_text(size=14)) +
  geom_bar(position="dodge", stat="identity", colour="black") +
  scale_fill_manual(values=c("black", "grey35", "grey65","white")) +
  xlab("Restoration approach") + ylab("Conservation velocity") +
  labs(fill = "Conservation strategy") +
  geom_errorbar(aes(ymin=Vcons-SE, ymax=Vcons+SE), width=.2,
                position=position_dodge(.9)) 

############################ graph CV of all conservation strategies per restoration type ###################################

#Conservation velocity
#par(mfrow=c(1,1))
par(mfrow=c(1,3))

#####longleaf pine conservation velocity
LLP_all<- rbind(LLP_all_std_cluster, LLP_all_std_econ, LLP_all_std_geo, LLP_all_std_rand)

par(mai=c(0.55,0.5,0,0))
plot(1, type="n", xlab="", ylab="Habitat Quality", xlim=c(0, 16), ylim=c(-2, 5), xaxt="n")
xtick<-seq(0, 16, by=16)
axis(1, at=xtick, labels=c("Ti", "Tf"))
#plot conservation velocity of each longleaf pine/cluster strategy rep
abline(a=mean(LLP_all$hab_score.x[LLP_all$rep=="bcc" & LLP_all$strat.x=="cluster"]), b=mean(LLP_all$rate[LLP_all$rep=="bcc" & LLP_all$strat.x=="cluster"]), col="black")
abline(a=mean(LLP_all$hab_score.x[LLP_all$rep=="CNRM" & LLP_all$strat.x=="cluster"]), b=mean(LLP_all$rate[LLP_all$rep=="CNRM" & LLP_all$strat.x=="cluster"]), col="black")
abline(a=mean(LLP_all$hab_score.x[LLP_all$rep=="HadGEM" & LLP_all$strat.x=="cluster"]), b=mean(LLP_all$rate[LLP_all$rep=="HadGEM" & LLP_all$strat.x=="cluster"]), col="black")
abline(a=mean(LLP_all$hab_score.x[LLP_all$rep=="IPSL" & LLP_all$strat.x=="cluster"]), b=mean(LLP_all$rate[LLP_all$rep=="IPSL" & LLP_all$strat.x=="cluster"]), col="black")
abline(a=mean(LLP_all$hab_score.x[LLP_all$rep=="NorESM" & LLP_all$strat.x=="cluster"]), b=mean(LLP_all$rate[LLP_all$rep=="NorESM" & LLP_all$strat.x=="cluster"]), col="black")
#plot average conservation velocity of all longleaf pine/cluster strategy reps
abline(a=mean(LLP_all$hab_score.x[LLP_all$strat.x=="cluster"]), b=mean(LLP_all$rate[LLP_all$strat.x=="cluster"]), col="black", lwd=2)

#plot conservation velocity of each longleaf pine/econ strategy rep
abline(a=mean(LLP_all$hab_score.x[LLP_all$rep=="bcc" & LLP_all$strat.x=="econ"]), b=mean(LLP_all$rate[LLP_all$rep=="bcc" & LLP_all$strat.x=="econ"]), col="deepskyblue3")
abline(a=mean(LLP_all$hab_score.x[LLP_all$rep=="CNRM" & LLP_all$strat.x=="econ"]), b=mean(LLP_all$rate[LLP_all$rep=="CNRM" & LLP_all$strat.x=="econ"]), col="deepskyblue3")
abline(a=mean(LLP_all$hab_score.x[LLP_all$rep=="HadGEM" & LLP_all$strat.x=="econ"]), b=mean(LLP_all$rate[LLP_all$rep=="HadGEM" & LLP_all$strat.x=="econ"]), col="deepskyblue3")
abline(a=mean(LLP_all$hab_score.x[LLP_all$rep=="IPSL" & LLP_all$strat.x=="econ"]), b=mean(LLP_all$rate[LLP_all$rep=="IPSL" & LLP_all$strat.x=="econ"]), col="deepskyblue3")
abline(a=mean(LLP_all$hab_score.x[LLP_all$rep=="NorESM" & LLP_all$strat.x=="econ"]), b=mean(LLP_all$rate[LLP_all$rep=="NorESM" & LLP_all$strat.x=="econ"]), col="deepskyblue3")
#plot average conservation velocity of all longleaf pine/econ strategy reps
abline(a=mean(LLP_all$hab_score.x[LLP_all$strat.x=="econ"]), b=mean(LLP_all$rate[LLP_all$strat.x=="econ"]), col="deepskyblue3", lwd=2)

#plot conservation velocity of each longleaf pine/geo strategy rep
abline(a=mean(LLP_all$hab_score.x[LLP_all$rep=="bcc" & LLP_all$strat.x=="geo"]), b=mean(LLP_all$rate[LLP_all$rep=="bcc" & LLP_all$strat.x=="geo"]), col="firebrick4")
abline(a=mean(LLP_all$hab_score.x[LLP_all$rep=="CNRM" & LLP_all$strat.x=="geo"]), b=mean(LLP_all$rate[LLP_all$rep=="CNRM" & LLP_all$strat.x=="geo"]), col="firebrick4")
abline(a=mean(LLP_all$hab_score.x[LLP_all$rep=="HadGEM" & LLP_all$strat.x=="geo"]), b=mean(LLP_all$rate[LLP_all$rep=="HadGEM" & LLP_all$strat.x=="geo"]), col="firebrick4")
abline(a=mean(LLP_all$hab_score.x[LLP_all$rep=="IPSL" & LLP_all$strat.x=="geo"]), b=mean(LLP_all$rate[LLP_all$rep=="IPSL" & LLP_all$strat.x=="geo"]), col="firebrick4")
abline(a=mean(LLP_all$hab_score.x[LLP_all$rep=="NorESM" & LLP_all$strat.x=="geo"]), b=mean(LLP_all$rate[LLP_all$rep=="NorESM" & LLP_all$strat.x=="geo"]), col="firebrick4")
#plot average conservation velocity of all longleaf pine/geo strategy reps
abline(a=mean(LLP_all$hab_score.x[LLP_all$strat.x=="geo"]), b=mean(LLP_all$rate[LLP_all$strat.x=="geo"]), col="firebrick4", lwd=2)

#plot conservation velocity of each longleaf pine/rand strategy rep
abline(a=mean(LLP_all$hab_score.x[LLP_all$rep=="bcc" & LLP_all$strat.x=="rand"]), b=mean(LLP_all$rate[LLP_all$rep=="bcc" & LLP_all$strat.x=="rand"]), col="orange3")
abline(a=mean(LLP_all$hab_score.x[LLP_all$rep=="CNRM" & LLP_all$strat.x=="rand"]), b=mean(LLP_all$rate[LLP_all$rep=="CNRM" & LLP_all$strat.x=="rand"]), col="orange3")
abline(a=mean(LLP_all$hab_score.x[LLP_all$rep=="HadGEM" & LLP_all$strat.x=="rand"]), b=mean(LLP_all$rate[LLP_all$rep=="HadGEM" & LLP_all$strat.x=="rand"]), col="orange3")
abline(a=mean(LLP_all$hab_score.x[LLP_all$rep=="IPSL" & LLP_all$strat.x=="rand"]), b=mean(LLP_all$rate[LLP_all$rep=="IPSL" & LLP_all$strat.x=="rand"]), col="orange3")
abline(a=mean(LLP_all$hab_score.x[LLP_all$rep=="NorESM" & LLP_all$strat.x=="rand"]), b=mean(LLP_all$rate[LLP_all$rep=="NorESM" & LLP_all$strat.x=="rand"]), col="orange3")
#plot average conservation velocity of all longleaf pine/rand strategy reps
abline(a=mean(LLP_all$hab_score.x[LLP_all$strat.x=="rand"]), b=mean(LLP_all$rate[LLP_all$strat.x=="rand"]), col="orange3", lwd=2)

#####pine mix conservation velocity
Pmix_all<- rbind(Pmix_all_std_cluster, Pmix_all_std_econ, Pmix_all_std_geo, Pmix_all_std_rand)

par(mai=c(0.55,0.25,0,0.25))
plot(1, type="n", xlab="Time", ylab="", xlim=c(0, 16), ylim=c(-2, 5), xaxt="n", yaxt="n")
xtick<-seq(0, 16, by=16)
axis(1, at=xtick, labels=c("Ti", "Tf"))
axis(2, labels=FALSE)
#plot conservation velocity of each pine mix/cluster strategy rep
abline(a=mean(Pmix_all$hab_score.x[Pmix_all$rep=="bcc" & Pmix_all$strat.x=="cluster"]), b=mean(Pmix_all$rate[Pmix_all$rep=="bcc" & Pmix_all$strat.x=="cluster"]), col="black")
abline(a=mean(Pmix_all$hab_score.x[Pmix_all$rep=="CNRM" & Pmix_all$strat.x=="cluster"]), b=mean(Pmix_all$rate[Pmix_all$rep=="CNRM" & Pmix_all$strat.x=="cluster"]), col="black")
abline(a=mean(Pmix_all$hab_score.x[Pmix_all$rep=="HadGEM" & Pmix_all$strat.x=="cluster"]), b=mean(Pmix_all$rate[Pmix_all$rep=="HadGEM" & Pmix_all$strat.x=="cluster"]), col="black")
abline(a=mean(Pmix_all$hab_score.x[Pmix_all$rep=="IPSL" & Pmix_all$strat.x=="cluster"]), b=mean(Pmix_all$rate[Pmix_all$rep=="IPSL" & Pmix_all$strat.x=="cluster"]), col="black")
abline(a=mean(Pmix_all$hab_score.x[Pmix_all$rep=="NorESM" & Pmix_all$strat.x=="cluster"]), b=mean(Pmix_all$rate[Pmix_all$rep=="NorESM" & Pmix_all$strat.x=="cluster"]), col="black")
#plot average conservation velocity of all pine mix/cluster strategy reps
abline(a=mean(Pmix_all$hab_score.x[Pmix_all$strat.x=="cluster"]), b=mean(Pmix_all$rate[Pmix_all$strat.x=="cluster"]), col="black", lwd=2)

#plot conservation velocity of each pine mix/econ strategy rep
abline(a=mean(Pmix_all$hab_score.x[Pmix_all$rep=="bcc" & Pmix_all$strat.x=="econ"]), b=mean(Pmix_all$rate[Pmix_all$rep=="bcc" & Pmix_all$strat.x=="econ"]), col="deepskyblue3")
abline(a=mean(Pmix_all$hab_score.x[Pmix_all$rep=="CNRM" & Pmix_all$strat.x=="econ"]), b=mean(Pmix_all$rate[Pmix_all$rep=="CNRM" & Pmix_all$strat.x=="econ"]), col="deepskyblue3")
abline(a=mean(Pmix_all$hab_score.x[Pmix_all$rep=="HadGEM" & Pmix_all$strat.x=="econ"]), b=mean(Pmix_all$rate[Pmix_all$rep=="HadGEM" & Pmix_all$strat.x=="econ"]), col="deepskyblue3")
abline(a=mean(Pmix_all$hab_score.x[Pmix_all$rep=="IPSL" & Pmix_all$strat.x=="econ"]), b=mean(Pmix_all$rate[Pmix_all$rep=="IPSL" & Pmix_all$strat.x=="econ"]), col="deepskyblue3")
abline(a=mean(Pmix_all$hab_score.x[Pmix_all$rep=="NorESM" & Pmix_all$strat.x=="econ"]), b=mean(Pmix_all$rate[Pmix_all$rep=="NorESM" & Pmix_all$strat.x=="econ"]), col="deepskyblue3")
#plot average conservation velocity of all pine mix/econ strategy reps
abline(a=mean(Pmix_all$hab_score.x[Pmix_all$strat.x=="econ"]), b=mean(Pmix_all$rate[Pmix_all$strat.x=="econ"]), col="deepskyblue3", lwd=2)

#plot conservation velocity of each pine mix/geo strategy rep
abline(a=mean(Pmix_all$hab_score.x[Pmix_all$rep=="bcc" & Pmix_all$strat.x=="geo"]), b=mean(Pmix_all$rate[Pmix_all$rep=="bcc" & Pmix_all$strat.x=="geo"]), col="firebrick4")
abline(a=mean(Pmix_all$hab_score.x[Pmix_all$rep=="CNRM" & Pmix_all$strat.x=="geo"]), b=mean(Pmix_all$rate[Pmix_all$rep=="CNRM" & Pmix_all$strat.x=="geo"]), col="firebrick4")
abline(a=mean(Pmix_all$hab_score.x[Pmix_all$rep=="HadGEM" & Pmix_all$strat.x=="geo"]), b=mean(Pmix_all$rate[Pmix_all$rep=="HadGEM" & Pmix_all$strat.x=="geo"]), col="firebrick4")
abline(a=mean(Pmix_all$hab_score.x[Pmix_all$rep=="IPSL" & Pmix_all$strat.x=="geo"]), b=mean(Pmix_all$rate[Pmix_all$rep=="IPSL" & Pmix_all$strat.x=="geo"]), col="firebrick4")
abline(a=mean(Pmix_all$hab_score.x[Pmix_all$rep=="NorESM" & Pmix_all$strat.x=="geo"]), b=mean(Pmix_all$rate[Pmix_all$rep=="NorESM" & Pmix_all$strat.x=="geo"]), col="firebrick4")
#plot average conservation velocity of all pine mix/geo strategy reps
abline(a=mean(Pmix_all$hab_score.x[Pmix_all$strat.x=="geo"]), b=mean(Pmix_all$rate[Pmix_all$strat.x=="geo"]), col="firebrick4", lwd=2)

#plot conservation velocity of each pine mix/rand strategy rep
abline(a=mean(Pmix_all$hab_score.x[Pmix_all$rep=="bcc" & Pmix_all$strat.x=="rand"]), b=mean(Pmix_all$rate[Pmix_all$rep=="bcc" & Pmix_all$strat.x=="rand"]), col="orange3")
abline(a=mean(Pmix_all$hab_score.x[Pmix_all$rep=="CNRM" & Pmix_all$strat.x=="rand"]), b=mean(Pmix_all$rate[Pmix_all$rep=="CNRM" & Pmix_all$strat.x=="rand"]), col="orange3")
abline(a=mean(Pmix_all$hab_score.x[Pmix_all$rep=="HadGEM" & Pmix_all$strat.x=="rand"]), b=mean(Pmix_all$rate[Pmix_all$rep=="HadGEM" & Pmix_all$strat.x=="rand"]), col="orange3")
abline(a=mean(Pmix_all$hab_score.x[Pmix_all$rep=="IPSL" & Pmix_all$strat.x=="rand"]), b=mean(Pmix_all$rate[Pmix_all$rep=="IPSL" & Pmix_all$strat.x=="rand"]), col="orange3")
abline(a=mean(Pmix_all$hab_score.x[Pmix_all$rep=="NorESM" & Pmix_all$strat.x=="rand"]), b=mean(Pmix_all$rate[Pmix_all$rep=="NorESM" & Pmix_all$strat.x=="rand"]), col="orange3")
#plot average conservation velocity of all pine mix/rand strategy reps
abline(a=mean(Pmix_all$hab_score.x[Pmix_all$strat.x=="rand"]), b=mean(Pmix_all$rate[Pmix_all$strat.x=="rand"]), col="orange3", lwd=2)

#####hardwood mix conservation velocity
Hmix_all<- rbind(Hmix_all_std_cluster, Hmix_all_std_econ, Hmix_all_std_geo, Hmix_all_std_rand)

par(mai=c(0.55,0,0,0.5))
plot(1, type="n", xlab="", ylab="", xlim=c(0, 16), ylim=c(-2, 5), xaxt="n", yaxt="n")
xtick<-seq(0, 16, by=16)
axis(1, at=xtick, labels=c("Ti", "Tf"))
axis(2, labels=FALSE)
legend("bottomright", legend=c("Cluster", "Economic", "Geodiversity", "Opportunistic"), col=c("black","deepskyblue3","firebrick4","orange3"), lty=1, title="Conservation Strategy")
#plot conservation velocity of each hardwood mix/cluster strategy rep
abline(a=mean(Hmix_all$hab_score.x[Hmix_all$rep=="bcc" & Hmix_all$strat.x=="cluster"]), b=mean(Hmix_all$rate[Hmix_all$rep=="bcc" & Hmix_all$strat.x=="cluster"]), col="black")
abline(a=mean(Hmix_all$hab_score.x[Hmix_all$rep=="CNRM" & Hmix_all$strat.x=="cluster"]), b=mean(Hmix_all$rate[Hmix_all$rep=="CNRM" & Hmix_all$strat.x=="cluster"]), col="black")
abline(a=mean(Hmix_all$hab_score.x[Hmix_all$rep=="HadGEM" & Hmix_all$strat.x=="cluster"]), b=mean(Hmix_all$rate[Hmix_all$rep=="HadGEM" & Hmix_all$strat.x=="cluster"]), col="black")
abline(a=mean(Hmix_all$hab_score.x[Hmix_all$rep=="IPSL" & Hmix_all$strat.x=="cluster"]), b=mean(Hmix_all$rate[Hmix_all$rep=="IPSL" & Hmix_all$strat.x=="cluster"]), col="black")
abline(a=mean(Hmix_all$hab_score.x[Hmix_all$rep=="NorESM" & Hmix_all$strat.x=="cluster"]), b=mean(Hmix_all$rate[Hmix_all$rep=="NorESM" & Hmix_all$strat.x=="cluster"]), col="black")
#plot average conservation velocity of all hardwood mix/cluster strategy reps
abline(a=mean(Hmix_all$hab_score.x[Hmix_all$strat.x=="cluster"]), b=mean(Hmix_all$rate[Hmix_all$strat.x=="cluster"]), col="black", lwd=2)

#plot conservation velocity of each hardwood mix/econ strategy rep
abline(a=mean(Hmix_all$hab_score.x[Hmix_all$rep=="bcc" & Hmix_all$strat.x=="econ"]), b=mean(Hmix_all$rate[Hmix_all$rep=="bcc" & Hmix_all$strat.x=="econ"]), col="deepskyblue3")
abline(a=mean(Hmix_all$hab_score.x[Hmix_all$rep=="CNRM" & Hmix_all$strat.x=="econ"]), b=mean(Hmix_all$rate[Hmix_all$rep=="CNRM" & Hmix_all$strat.x=="econ"]), col="deepskyblue3")
abline(a=mean(Hmix_all$hab_score.x[Hmix_all$rep=="HadGEM" & Hmix_all$strat.x=="econ"]), b=mean(Hmix_all$rate[Hmix_all$rep=="HadGEM" & Hmix_all$strat.x=="econ"]), col="deepskyblue3")
abline(a=mean(Hmix_all$hab_score.x[Hmix_all$rep=="IPSL" & Hmix_all$strat.x=="econ"]), b=mean(Hmix_all$rate[Hmix_all$rep=="IPSL" & Hmix_all$strat.x=="econ"]), col="deepskyblue3")
abline(a=mean(Hmix_all$hab_score.x[Hmix_all$rep=="NorESM" & Hmix_all$strat.x=="econ"]), b=mean(Hmix_all$rate[Hmix_all$rep=="NorESM" & Hmix_all$strat.x=="econ"]), col="deepskyblue3")
#plot average conservation velocity of all hardwood mix/econ strategy reps
abline(a=mean(Hmix_all$hab_score.x[Hmix_all$strat.x=="econ"]), b=mean(Hmix_all$rate[Hmix_all$strat.x=="econ"]), col="deepskyblue3", lwd=2)

#plot conservation velocity of each hardwood mix/geo strategy rep
abline(a=mean(Hmix_all$hab_score.x[Hmix_all$rep=="bcc" & Hmix_all$strat.x=="geo"]), b=mean(Hmix_all$rate[Hmix_all$rep=="bcc" & Hmix_all$strat.x=="geo"]), col="firebrick4")
abline(a=mean(Hmix_all$hab_score.x[Hmix_all$rep=="CNRM" & Hmix_all$strat.x=="geo"]), b=mean(Hmix_all$rate[Hmix_all$rep=="CNRM" & Hmix_all$strat.x=="geo"]), col="firebrick4")
abline(a=mean(Hmix_all$hab_score.x[Hmix_all$rep=="HadGEM" & Hmix_all$strat.x=="geo"]), b=mean(Hmix_all$rate[Hmix_all$rep=="HadGEM" & Hmix_all$strat.x=="geo"]), col="firebrick4")
abline(a=mean(Hmix_all$hab_score.x[Hmix_all$rep=="IPSL" & Hmix_all$strat.x=="geo"]), b=mean(Hmix_all$rate[Hmix_all$rep=="IPSL" & Hmix_all$strat.x=="geo"]), col="firebrick4")
abline(a=mean(Hmix_all$hab_score.x[Hmix_all$rep=="NorESM" & Hmix_all$strat.x=="geo"]), b=mean(Hmix_all$rate[Hmix_all$rep=="NorESM" & Hmix_all$strat.x=="geo"]), col="firebrick4")
#plot average conservation velocity of all hardwood mix/geo strategy reps
abline(a=mean(Hmix_all$hab_score.x[Hmix_all$strat.x=="geo"]), b=mean(Hmix_all$rate[Hmix_all$strat.x=="geo"]), col="firebrick4", lwd=2)

#plot conservation velocity of each hardwood mix/rand strategy rep
abline(a=mean(Hmix_all$hab_score.x[Hmix_all$rep=="bcc" & Hmix_all$strat.x=="rand"]), b=mean(Hmix_all$rate[Hmix_all$rep=="bcc" & Hmix_all$strat.x=="rand"]), col="orange3")
abline(a=mean(Hmix_all$hab_score.x[Hmix_all$rep=="CNRM" & Hmix_all$strat.x=="rand"]), b=mean(Hmix_all$rate[Hmix_all$rep=="CNRM" & Hmix_all$strat.x=="rand"]), col="orange3")
abline(a=mean(Hmix_all$hab_score.x[Hmix_all$rep=="HadGEM" & Hmix_all$strat.x=="rand"]), b=mean(Hmix_all$rate[Hmix_all$rep=="HadGEM" & Hmix_all$strat.x=="rand"]), col="orange3")
abline(a=mean(Hmix_all$hab_score.x[Hmix_all$rep=="IPSL" & Hmix_all$strat.x=="rand"]), b=mean(Hmix_all$rate[Hmix_all$rep=="IPSL" & Hmix_all$strat.x=="rand"]), col="orange3")
abline(a=mean(Hmix_all$hab_score.x[Hmix_all$rep=="NorESM" & Hmix_all$strat.x=="rand"]), b=mean(Hmix_all$rate[Hmix_all$rep=="NorESM" & Hmix_all$strat.x=="rand"]), col="orange3")
#plot average conservation velocity of all hardwood mix/rand strategy reps
abline(a=mean(Hmix_all$hab_score.x[Hmix_all$strat.x=="rand"]), b=mean(Hmix_all$rate[Hmix_all$strat.x=="rand"]), col="orange3", lwd=2)

##############################crazy multi-colored graph with conservation velocities from every single stand############## 
#LLP
plot(1, type="n", main="Conservation Velocity\nLongleaf Restoration", xlab="Time step no.", ylab="Habitat Quality", xlim=c(0, 16), ylim=c(-1, 2))
for (i in 1:length(LLP_all_std_cluster$stand_no)){
  abline(a=LLP_all_std_cluster$hab_score.x[i], b=LLP_all_std_cluster$rate[i], col=alpha("deepskyblue3",0.1))
}
for (i in 1:length(LLP_all_std_econ$stand_no)){
  abline(a=LLP_all_std_econ$hab_score.x[i], b=LLP_all_std_econ$rate[i], col=alpha("seagreen",0.1))
}
for (i in 1:length(LLP_all_std_geo$stand_no)){
  abline(a=LLP_all_std_geo$hab_score.x[i], b=LLP_all_std_geo$rate[i], col=alpha("firebrick1",0.1))
}
for (i in 1:length(LLP_all_std_rand$stand_no)){
  abline(a=LLP_all_std_rand$hab_score.x[i], b=LLP_all_std_rand$rate[i], col=alpha("darkorchid4",0.1))
}
abline(a=-0.86, b=0.151, col="deepskyblue3", lwd=2) #cluster
abline(a=-0.534, b=0.0674, col="seagreen", lwd=2) #econ
abline(a=-0.571, b=0.0809, col="firebrick1", lwd=2) #geo
abline(a=-0.546, b=0.0784, col="darkorchid4", lwd=2) #rand
legend(0,2, legend=c("Cluster", "Economic", "Geodiversity", "Opportunistic"), col=c("deepskyblue3","seagreen","firebrick1","darkorchid4"), lty=1)

#PMix
plot(1, type="n", main="Conservation Velocity\nPine Mix Restoration", xlab="Time step no.", ylab="Habitat Quality", xlim=c(0, 16), ylim=c(-1, 2))
for (i in 1:length(Pmix_all_std_cluster$stand_no)){
  abline(a=Pmix_all_std_cluster$hab_score.x[i], b=Pmix_all_std_cluster$rate[i], col=alpha("deepskyblue3",0.1))
}
for (i in 1:length(Pmix_all_std_econ$stand_no)){
  abline(a=Pmix_all_std_econ$hab_score.x[i], b=Pmix_all_std_econ$rate[i], col=alpha("seagreen",0.1))
}
for (i in 1:length(Pmix_all_std_geo$stand_no)){
  abline(a=Pmix_all_std_geo$hab_score.x[i], b=Pmix_all_std_geo$rate[i], col=alpha("firebrick1",0.1))
}
for (i in 1:length(Pmix_all_std_rand$stand_no)){
  abline(a=Pmix_all_std_rand$hab_score.x[i], b=Pmix_all_std_rand$rate[i], col=alpha("darkorchid4",0.1))
}
abline(a=0.015, b=0.0857, col="deepskyblue3", lwd=2) #cluster
abline(a=-0.288, b=0.0668, col="seagreen", lwd=2) #econ
abline(a=-0.304, b=0.0671, col="firebrick1", lwd=2) #geo
abline(a=-0.307, b=0.0816, col="darkorchid4", lwd=2) #rand
legend(0,2, legend=c("Cluster", "Economic", "Geodiversity", "Opportunistic"), col=c("deepskyblue3","seagreen","firebrick1","darkorchid4"), lty=1)

#Hmix
plot(1, type="n", main="Conservation Velocity\nHardwood Mix Restoration", xlab="Time step no.", ylab="Habitat Quality", xlim=c(0, 16), ylim=c(-1, 2))
for (i in 1:length(Hmix_all_std_cluster$stand_no)){
  abline(a=Hmix_all_std_cluster$hab_score.x[i], b=Hmix_all_std_cluster$rate[i], col=alpha("deepskyblue3",0.1))
}
for (i in 1:length(Hmix_all_std_econ$stand_no)){
  abline(a=Hmix_all_std_econ$hab_score.x[i], b=Hmix_all_std_econ$rate[i], col=alpha("seagreen",0.1))
}
for (i in 1:length(Hmix_all_std_geo$stand_no)){
  abline(a=Hmix_all_std_geo$hab_score.x[i], b=Hmix_all_std_geo$rate[i], col=alpha("firebrick1",0.1))
}
for (i in 1:length(Hmix_all_std_rand$stand_no)){
  abline(a=Hmix_all_std_rand$hab_score.x[i], b=Hmix_all_std_rand$rate[i], col=alpha("darkorchid4",0.1))
}
abline(a=-0.496, b=0.151, col="deepskyblue3", lwd=2) #cluster
abline(a=-0.456, b=0.0674, col="seagreen", lwd=2) #econ
abline(a=-0.465, b=0.0809, col="firebrick1", lwd=2) #geo
abline(a=-0.439, b=0.0784, col="darkorchid4", lwd=2) #rand
legend(0,2, legend=c("Cluster", "Economic", "Geodiversity", "Opportunistic"), col=c("deepskyblue3","seagreen","firebrick1","darkorchid4"), lty=1)

############################################envelope graphs!!!###########################################
library(gtable)
library(grid)
library(gridExtra)
library(patchwork)

LLP_all<- rbind(LLP_all_std_cluster, LLP_all_std_econ, LLP_all_std_geo, LLP_all_std_rand)
Pmix_all<- rbind(Pmix_all_std_cluster, Pmix_all_std_econ, Pmix_all_std_geo, Pmix_all_std_rand)
Hmix_all<- rbind(Hmix_all_std_cluster, Hmix_all_std_econ, Hmix_all_std_geo, Hmix_all_std_rand)

Process_Plot1<-function(LLP_all){
  set1<-seq(0,17)
  set2<-(mean(LLP_all$rate[ LLP_all$rep=="bcc" & LLP_all$strat.x=="cluster"])*seq(0,17))
  set3<-(mean(LLP_all$rate[ LLP_all$rep=="CNRM" & LLP_all$strat.x=="cluster"])*seq(0,17))
  set4<-(mean(LLP_all$rate[ LLP_all$rep=="HadGEM" & LLP_all$strat.x=="cluster"])*seq(0,17))
  set5<-(mean(LLP_all$rate[ LLP_all$rep=="IPSL"  & LLP_all$strat.x=="cluster"])*seq(0,17))
  set6<-(mean(LLP_all$rate[ LLP_all$rep=="NorESM"  & LLP_all$strat.x=="cluster"])*seq(0,17))
  ploty<-data.frame(set1=set1,set2=set2,set3=set3,set4=set4,set5=set5,set6=set6)
  
  rowmins<-apply(ploty[2:6], 1, FUN=min)
  rowmax<-apply(ploty[2:6], 1, FUN=max)
  rowmean<-apply(ploty[2:6],1,FUN=mean)
  plotter1<-data.frame(Time=ploty$set1,Cat="Cluster",Minimum=rowmins,Maximum=rowmax,Means=rowmean)
  
  set1<-seq(0,17)
  set2<-(mean(LLP_all$rate[ LLP_all$rep=="bcc" & LLP_all$strat.x=="geo"])*seq(0,17))
  set3<-(mean(LLP_all$rate[ LLP_all$rep=="CNRM" & LLP_all$strat.x=="geo"])*seq(0,17))
  set4<-(mean(LLP_all$rate[ LLP_all$rep=="HadGEM" & LLP_all$strat.x=="geo"])*seq(0,17))
  set5<-(mean(LLP_all$rate[ LLP_all$rep=="IPSL"  & LLP_all$strat.x=="geo"])*seq(0,17))
  set6<-(mean(LLP_all$rate[ LLP_all$rep=="NorESM"  & LLP_all$strat.x=="geo"])*seq(0,17))
  ploty<-data.frame(set1=set1,set2=set2,set3=set3,set4=set4,set5=set5,set6=set6)
  
  rowmins<-apply(ploty[2:6], 1, FUN=min)
  rowmax<-apply(ploty[2:6], 1, FUN=max)
  rowmean<-apply(ploty[2:6],1,FUN=mean)
  plotter2<-data.frame(Time=ploty$set1,Cat="Geodiversity",Minimum=rowmins,Maximum=rowmax,Means=rowmean)
  
  set1<-seq(0,17)
  set2<-(mean(LLP_all$rate[ LLP_all$rep=="bcc" & LLP_all$strat.x=="econ"])*seq(0,17))
  set3<-(mean(LLP_all$rate[ LLP_all$rep=="CNRM" & LLP_all$strat.x=="econ"])*seq(0,17))
  set4<-(mean(LLP_all$rate[ LLP_all$rep=="HadGEM" & LLP_all$strat.x=="econ"])*seq(0,17))
  set5<-(mean(LLP_all$rate[ LLP_all$rep=="IPSL"  & LLP_all$strat.x=="econ"])*seq(0,17))
  set6<-(mean(LLP_all$rate[ LLP_all$rep=="NorESM"  & LLP_all$strat.x=="econ"])*seq(0,17))
  ploty<-data.frame(set1=set1,set2=set2,set3=set3,set4=set4,set5=set5,set6=set6)
  
  rowmins<-apply(ploty[2:6], 1, FUN=min)
  rowmax<-apply(ploty[2:6], 1, FUN=max)
  rowmean<-apply(ploty[2:6],1,FUN=mean)
  plotter3<-data.frame(Time=ploty$set1,Cat="Economic",Minimum=rowmins,Maximum=rowmax,Means=rowmean)
  
  set1<-seq(0,17)
  set2<-(mean(LLP_all$rate[ LLP_all$rep=="bcc" & LLP_all$strat.x=="rand"])*seq(0,17))
  set3<-(mean(LLP_all$rate[ LLP_all$rep=="CNRM" & LLP_all$strat.x=="rand"])*seq(0,17))
  set4<-(mean(LLP_all$rate[ LLP_all$rep=="HadGEM" & LLP_all$strat.x=="rand"])*seq(0,17))
  set5<-(mean(LLP_all$rate[ LLP_all$rep=="IPSL"  & LLP_all$strat.x=="rand"])*seq(0,17))
  set6<-(mean(LLP_all$rate[ LLP_all$rep=="NorESM"  & LLP_all$strat.x=="rand"])*seq(0,17))
  ploty<-data.frame(set1=set1,set2=set2,set3=set3,set4=set4,set5=set5,set6=set6)
  
  rowmins<-apply(ploty[2:6], 1, FUN=min)
  rowmax<-apply(ploty[2:6], 1, FUN=max)
  rowmean<-apply(ploty[2:6],1,FUN=mean)
  plotter4<-data.frame(Time=ploty$set1,Cat="Opportunistic",Minimum=rowmins,Maximum=rowmax,Means=rowmean)
  
  plotter<-rbind(plotter1,plotter2,plotter3,plotter4)
  return(plotter)
}
plotter_LLP<-Process_Plot1(LLP_all)
plotter_Pmix<-Process_Plot1(Pmix_all)
plotter_Hmix<-Process_Plot1(Hmix_all)


par(mfrow=c(3,1))
p1<-ggplot(plotter_LLP) +
  theme(axis.text=element_text(size=12), axis.title=element_text(size=14), panel.border = element_rect(colour = "black", fill=NA, size=2)) +
  ylab("Change in Habitat Quality") +
  geom_line(aes(Time, Means, group =Cat,color=Cat),size=2.0) +
  geom_ribbon(aes(x=Time,ymin=Minimum,ymax=Maximum, group =Cat,color=Cat,fill=Cat), alpha = 0.1)+
  scale_fill_manual(values=c("grey48", "deepskyblue3", "firebrick4","orange3"))+
  scale_color_manual(values=c("grey48", "deepskyblue3", "firebrick4","orange3"))+
  scale_x_continuous(breaks=c(0,17),labels=c("Ti",  'Tf'))+
  theme(legend.position = "none")+
  theme(axis.text.x = element_text(color="black", 
                                   size=14, angle=0),
        axis.text.y = element_text(color="black", 
                                   size=14, angle=0),
        axis.title.x = element_blank()) +
  ylim(-.025,6.5)
p2<-ggplot(plotter_Pmix) +
  theme(axis.text=element_text(size=12), axis.title=element_text(size=14), panel.border = element_rect(colour = "black", fill=NA, size=2)) +
  xlab("Time") +
  geom_line(aes(Time, Means, group =Cat,color=Cat),size=2.0) +
  geom_ribbon(aes(x=Time,ymin=Minimum,ymax=Maximum, group =Cat,color=Cat,fill=Cat), alpha = 0.2)+
  scale_fill_manual(values=c("grey48", "deepskyblue3", "firebrick4","orange3"))+
  scale_color_manual(values=c("grey48", "deepskyblue3", "firebrick4","orange3"))+
  scale_x_continuous(breaks=c(0,17),labels=c("Ti",  'Tf'))+
  theme(legend.position = "none") +
  theme(axis.text.x = element_text(color="black", 
                                   size=14, angle=0),
        axis.text.y = element_text(color="black", 
                                   size=14, angle=0),
        axis.title.y = element_blank()) +
  ylim(-.025,6.5)
p3<-ggplot(plotter_Hmix) +
  theme(axis.text=element_text(size=12), axis.title=element_text(size=14), panel.border = element_rect(colour = "black", fill=NA, size=2)) +
  geom_line(aes(Time, Means, group =Cat,color=Cat),size=2.0) +
  geom_ribbon(aes(x=Time,ymin=Minimum,ymax=Maximum, group =Cat,color=Cat,fill=Cat), alpha = 0.2)+
  scale_fill_manual(values=c("grey48", "deepskyblue3", "firebrick4","orange3"))+
  scale_color_manual(values=c("grey48", "deepskyblue3", "firebrick4","orange3"))+
  scale_x_continuous(breaks=c(0,17),labels=c("Ti",  'Tf'))+
  theme(axis.text.x = element_text(color="black", 
                                   size=14, angle=0),
        axis.text.y = element_text(color="black", 
                                   size=14, angle=0),
        axis.title.y = element_blank(),
        axis.title.x = element_blank()) +
  ylim(-.025,6.5)


p1 + p2 + p3

#grid.arrange(p1, p2,p3,nrow =1 ,
             #left = textGrob("Change in Habitat Quality", rot = 90, vjust = .8, gp = gpar(fontface = "bold", cex = 1.5)))


#########################violin grahs##########################
library(Hmisc)
boxplot(LLP_all_std_cluster$rate, LLP_all_std_econ$rate, LLP_all_std_geo$rate, LLP_all_std_rand$rate)
boxplot(Pmix_all_std_cluster$rate, Pmix_all_std_econ$rate, Pmix_all_std_geo$rate, Pmix_all_std_rand$rate)
boxplot(Hmix_all_std_cluster$rate, Hmix_all_std_econ$rate, Hmix_all_std_geo$rate, Hmix_all_std_rand$rate)

#LLP_all$strat.x <- as.factor(LLP_all$strat.x)
v1 <- ggplot(LLP_all, aes(x=strat.x, y=rate, color=strat.x)) + 
  geom_violin(trim=FALSE) +
  stat_summary(fun.data="mean_sdl", mult=1, 
                 geom="crossbar", width=0.2 ) +
  scale_color_manual(values=c("grey48", "deepskyblue3", "firebrick4","orange3"))
v2 <- ggplot(Pmix_all, aes(x=strat.x, y=rate, color=strat.x)) + 
  geom_violin(trim=FALSE) +
  stat_summary(fun.data="mean_sdl", mult=1, 
               geom="crossbar", width=0.2 ) +
  scale_color_manual(values=c("grey48", "deepskyblue3", "firebrick4","orange3"))
v3 <- ggplot(Pmix_all, aes(x=strat.x, y=rate, color=strat.x)) + 
  geom_violin(trim=FALSE) +
  stat_summary(fun.data="mean_sdl", mult=1, 
               geom="crossbar", width=0.2 ) +
  scale_color_manual(values=c("grey48", "deepskyblue3", "firebrick4","orange3"))

v1 + v2 + v3




Pmix_hq_init_cluster <- Pmix_all_std_cluster_pre[,c(5,13)]
Pmix_hq_init_cluster <- ddply(Pmix_hq_init_cluster,"time",numcolwise(mean))
Pmix_hq_init_econ <- Pmix_all_std_econ_pre[,c(5,13)]
Pmix_hq_init_econ <- ddply(Pmix_hq_init_econ,"time",numcolwise(mean))
Pmix_hq_init_geo <- Pmix_all_std_geo_pre[,c(5,13)]
Pmix_hq_init_geo <- ddply(Pmix_hq_init_geo,"time",numcolwise(mean))
Pmix_hq_init_rand <- Pmix_all_std_rand_pre[,c(5,13)]
Pmix_hq_init_rand <- ddply(Pmix_hq_init_rand,"time",numcolwise(mean))

LLP_hq_init_cluster <- LLP_all_std_cluster_pre[,c(5,13)]
LLP_hq_init_cluster <- ddply(LLP_hq_init_cluster,"time",numcolwise(mean))
LLP_hq_init_econ <- LLP_all_std_econ_pre[,c(5,13)]
LLP_hq_init_econ <- ddply(LLP_hq_init_econ,"time",numcolwise(mean))
LLP_hq_init_geo <- LLP_all_std_geo_pre[,c(5,13)]
LLP_hq_init_geo <- ddply(LLP_hq_init_geo,"time",numcolwise(mean))
LLP_hq_init_rand <- LLP_all_std_rand_pre[,c(5,13)]
LLP_hq_init_rand <- ddply(LLP_hq_init_rand,"time",numcolwise(mean))

Hmix_hq_init_cluster <- Hmix_all_std_cluster_pre[,c(5,13)]
Hmix_hq_init_cluster <- ddply(Hmix_hq_init_cluster,"time",numcolwise(mean))
Hmix_hq_init_econ <- Hmix_all_std_econ_pre[,c(5,13)]
Hmix_hq_init_econ <- ddply(Hmix_hq_init_econ,"time",numcolwise(mean))
Hmix_hq_init_geo <- Hmix_all_std_geo_pre[,c(5,13)]
Hmix_hq_init_geo <- ddply(Hmix_hq_init_geo,"time",numcolwise(mean))
Hmix_hq_init_rand <- Hmix_all_std_rand_pre[,c(5,13)]
Hmix_hq_init_rand <- ddply(Hmix_hq_init_rand,"time",numcolwise(mean))
