#connectivity data visualization
library(ggplot2)
library(plyr)
library(dplyr)
library(gtable)
library(grid)
library(gridExtra)
library(patchwork)
library(igraph)
library(cowplot)
library(egg)

######### Metrics 1000spec ############
setwd("D:/BAU_connectivity/Output_specialist1000")

con<- c("cluster","economic","geodiversity","random")
TimestepList <- as.character(seq(from=0, to=80, by=10))

for (c in con){
  
  Metrics <- list.files(pattern=paste0("Metrics_",c))
  dataset <- NULL
  for (d in Metrics){
    
    # if the merged dataset doesn't exist, create it
    if (!exists("dataset")){
      dataset <- read.table(d)
      dataset$spec ="s1"
      #dataset$con = paste0(c)
    }
    
    # if the merged dataset does exist, append to it
    if (exists("dataset")){
      temp_dataset <-read.table(d)
      temp_dataset$spec ="s1"
      #temp_dataset$con = paste0(c)
      dataset<-rbind(dataset, temp_dataset)
      rm(temp_dataset)
    }
    assign(paste0(c,"_metrics_s1"), dataset)
  }
}

cluster_metrics_s1$time<- c(0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,70,80)
economic_metrics_s1$time <- c(0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,70,80)
geodiversity_metrics_s1$time <- c(0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,70,80)
random_metrics_s1$time <- c(0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,70,80)
metrics_s1 <- rbind(cluster_metrics_s1,economic_metrics_s1,geodiversity_metrics_s1,random_metrics_s1)

cluster_metrics_s1_all <- ddply(cluster_metrics_s1,"time",colMeans)
economic_metrics_s1_all <- ddply(economic_metrics_s1,"time",colMeans)
geodiversity_metrics_s1_all <- ddply(geodiversity_metrics_s1,"time",colMeans)
random_metrics_s1_all <- ddply(random_metrics_s1,"time",colMeans)

clusters1_time<-split(cluster_metrics_s1, cluster_metrics_s1$time)
clusters1_80 <- clusters1_time$`80`

######### Metrics 5000spec ############
setwd("D:/BAU_connectivity/Output_specialist5000")

con<- c("cluster","economic","geodiversity","random")
TimestepList <- as.character(seq(from=0, to=80, by=10))

for (c in con){
  
  Metrics <- list.files(pattern=paste0("Metrics_",c))
  dataset <- NULL
  for (d in Metrics){
    
    # if the merged dataset doesn't exist, create it
    if (!exists("dataset")){
      dataset <- read.table(d)
      dataset$spec ="s5"
      #dataset$con = paste0(c)
    }
    
    # if the merged dataset does exist, append to it
    if (exists("dataset")){
      temp_dataset <-read.table(d)
      temp_dataset$spec ="s5"
      #temp_dataset$con = paste0(c)
      dataset<-rbind(dataset, temp_dataset)
      rm(temp_dataset)
    }
    assign(paste0(c,"_metrics_s5"), dataset)
  }
}

cluster_metrics_s5$time<- c(0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,70,80)
economic_metrics_s5$time <- c(0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,70,80)
geodiversity_metrics_s5$time <- c(0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,70,80)
random_metrics_s5$time <- c(0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,70,80)
metrics_s5 <- rbind(cluster_metrics_s5,economic_metrics_s5,geodiversity_metrics_s5,random_metrics_s5)

cluster_metrics_s5_all <- ddply(cluster_metrics_s5,"time",colMeans)
economic_metrics_s5_all <- ddply(economic_metrics_s5,"time",colMeans)
geodiversity_metrics_s5_all <- ddply(geodiversity_metrics_s5,"time",colMeans)
random_metrics_s5_all <- ddply(random_metrics_s5,"time",colMeans)

######### Metrics 1000gen ############
setwd("D:/BAU_connectivity/Output_generalist1000")

con<- c("cluster","economic","geodiversity","random")
TimestepList <- as.character(seq(from=0, to=80, by=10))

for (c in con){
  
  Metrics <- list.files(pattern=paste0("Metrics_",c))
  dataset <- NULL
  for (d in Metrics){
    
    # if the merged dataset doesn't exist, create it
    if (!exists("dataset")){
      dataset <- read.table(d)
      dataset$spec ="g1"
      #dataset$con = paste0(c)
    }
    
    # if the merged dataset does exist, append to it
    if (exists("dataset")){
      temp_dataset <-read.table(d)
      temp_dataset$spec ="g1"
      #temp_dataset$con = paste0(c)
      dataset<-rbind(dataset, temp_dataset)
      rm(temp_dataset)
    }
    assign(paste0(c,"_metrics_g1"), dataset)
  }
}

cluster_metrics_g1$time<- c(0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,70,80)
economic_metrics_g1$time <- c(0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,70,80)
geodiversity_metrics_g1$time <- c(0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,70,80)
random_metrics_g1$time <- c(0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,70,80)
metrics_g1 <- rbind(cluster_metrics_g1,economic_metrics_g1,geodiversity_metrics_g1,random_metrics_g1)

cluster_metrics_g1_all <- ddply(cluster_metrics_g1,"time",colMeans)
economic_metrics_g1_all <- ddply(economic_metrics_g1,"time",colMeans)
geodiversity_metrics_g1_all <- ddply(geodiversity_metrics_g1,"time",colMeans)
random_metrics_g1_all <- ddply(random_metrics_g1,"time",colMeans)


######### Metrics 5000gen ############
setwd("D:/BAU_connectivity/Output_generalist5000")

con<- c("cluster","economic","geodiversity","random")
TimestepList <- as.character(seq(from=0, to=80, by=10))

for (c in con){
  
  Metrics <- list.files(pattern=paste0("Metrics_",c))
  dataset <- NULL
  for (d in Metrics){
    
    # if the merged dataset doesn't exist, create it
    if (!exists("dataset")){
      dataset <- read.table(d)
      dataset$spec ="g5"
      #dataset$con = paste0(c)
    }
    
    # if the merged dataset does exist, append to it
    if (exists("dataset")){
      temp_dataset <-read.table(d)
      temp_dataset$spec ="g5"
      #temp_dataset$con = paste0(c)
      dataset<-rbind(dataset, temp_dataset)
      rm(temp_dataset)
    }
    assign(paste0(c,"_metrics_g5"), dataset)
  }
}

cluster_metrics_g5$time<- c(0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,70,80)
economic_metrics_g5$time <- c(0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,70,80)
geodiversity_metrics_g5$time <- c(0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,70,80)
random_metrics_g5$time <- c(0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,70,80)
metrics_g5 <- rbind(cluster_metrics_g5,economic_metrics_g5,geodiversity_metrics_g5,random_metrics_g5)

cluster_metrics_g5_all <- ddply(cluster_metrics_g5,"time",colMeans)
economic_metrics_g5_all <- ddply(economic_metrics_g5,"time",colMeans)
geodiversity_metrics_g5_all <- ddply(geodiversity_metrics_g5,"time",colMeans)
random_metrics_g5_all <- ddply(random_metrics_g5,"time",colMeans)

m5000<- rbind(cluster_metrics_g5,cluster_metrics_s5,economic_metrics_g5,economic_metrics_s5,geodiversity_metrics_g5,geodiversity_metrics_s5,random_metrics_g5, random_metrics_s5)
m1000<- rbind(cluster_metrics_g1,cluster_metrics_s1,economic_metrics_g1,economic_metrics_s1,geodiversity_metrics_g1,geodiversity_metrics_s1,random_metrics_g1, random_metrics_s1)
cg<- rbind(cluster_metrics_g1,cluster_metrics_g5)
eg<- rbind(economic_metrics_g1,economic_metrics_g5)
gg<- rbind(geodiversity_metrics_g1,geodiversity_metrics_g5)
rg<- rbind(random_metrics_g1, random_metrics_g5)

################################nodes and links graphs########################################################
cluster_nodes <-rbind(cluster_metrics_g1,cluster_metrics_s1)
economic_nodes <-rbind(economic_metrics_g1,economic_metrics_s1)
geodiversity_nodes <-rbind(geodiversity_metrics_g1,geodiversity_metrics_s1)
random_nodes <-rbind(random_metrics_g1,random_metrics_s1)

cnodes_plot <- ggplot(cluster_nodes) +
  theme(axis.text=element_text(size=14), axis.title=element_text(size=20), panel.border = element_rect(colour = "black", fill=NA, size=2)) +
  theme(plot.title = element_text(size = 22, face = "bold", hjust = 0.5)) +
  geom_point(aes(time, nodes, group=spec,color=spec), size=2.0) +
  #stat_summary(aes(x=time, y=nodes,group=spec,color=spec),fun=mean, geom="line") +
  geom_smooth(method="loess", aes(x=time, y=nodes,group=spec,color=spec), se=T) + 
  scale_color_manual(values=c("orange", "dodgerblue4")) +
  ggtitle("Cluster nodes") +
  ylab("Number of nodes") +
  theme(legend.position = "none") +
  theme(axis.text.x = element_blank(),
        axis.text.y = element_text(color="black", 
                                   size=14, angle=0),
        axis.title.x = element_blank()) +
  annotate(geom="text", x=3, y=38000, label="a",color="black",size=14) +
  ylim(0,40000)
cnodes_plot

enodes_plot <- ggplot(economic_nodes) +
  theme(axis.text=element_text(size=14), axis.title=element_text(size=18), panel.border = element_rect(colour = "black", fill=NA, size=2)) +
  theme(plot.title = element_text(size = 22, face = "bold", hjust = 0.5)) +
  geom_point(aes(time, nodes, group=spec,color=spec), size=2.0) +
  #stat_summary(aes(x=time, y=nodes,group=spec,color=spec),fun=mean, geom="line") +
  geom_smooth(method="loess", aes(x=time, y=nodes,group=spec,color=spec), se=T) + 
  scale_color_manual(values=c("orange", "dodgerblue4")) +
  ggtitle("Economic nodes") +
  theme(legend.position = "none") +
  theme(axis.text.x = element_blank(),
        axis.text.y = element_blank(),
        axis.title.x = element_blank(),
        axis.title.y = element_blank()) +
  annotate(geom="text", x=3, y=38000, label="b",color="black",size=14) +
  ylim(0,40000)

gnodes_plot <- ggplot(geodiversity_nodes) +
  theme(axis.text=element_text(size=14), axis.title=element_text(size=18), panel.border = element_rect(colour = "black", fill=NA, size=2)) +
  theme(plot.title = element_text(size = 22, face = "bold", hjust = 0.5)) +
  geom_point(aes(time, nodes, group=spec,color=spec), size=2.0) +
  #stat_summary(aes(x=time, y=nodes,group=spec,color=spec),fun=mean, geom="line") +
  geom_smooth(method="loess", aes(x=time, y=nodes,group=spec,color=spec), se=T) + 
  scale_color_manual(values=c("orange", "dodgerblue4")) +
  ggtitle("Geodiversity nodes") +
  theme(legend.position = "none") +
  theme(axis.text.x = element_blank(),
        axis.text.y = element_blank(),
        axis.title.x = element_blank(),
        axis.title.y = element_blank()) +
  annotate(geom="text", x=3, y=38000, label="c",color="black",size=14) +
  ylim(0,40000)

rnodes_plot <- ggplot(random_nodes) +
  theme(axis.text=element_text(size=14), axis.title=element_text(size=18), panel.border = element_rect(colour = "black", fill=NA, size=2)) +
  theme(plot.title = element_text(size = 22, face = "bold", hjust = 0.5)) +
  geom_point(aes(time, nodes, group=spec,color=spec), size=2.0) +
  #stat_summary(aes(x=time, y=nodes,group=spec,color=spec),fun=mean, geom="line") +
  geom_smooth(method="loess", aes(x=time, y=nodes,group=spec,color=spec), se=T) + 
  scale_color_manual(labels = c("Generalist", "Specialist"),values=c("orange", "dodgerblue4")) +
  ggtitle("Opportunistic nodes") +
  theme(legend.position=c(0.8,0.11)) +
  theme(legend.title = element_blank()) +
  theme(legend.text = element_text(color="black", 
                                   size=14)) +
  theme(axis.text.x = element_blank(),
        axis.text.y = element_blank(),
        axis.title.x = element_blank(),
        axis.title.y = element_blank()) +
  annotate(geom="text", x=3, y=38000, label="d",color="black",size=14) +
  ylim(0,40000)

cluster_links <-rbind(cluster_metrics_g1,cluster_metrics_g5,cluster_metrics_s1, cluster_metrics_s5)
economic_links <-rbind(economic_metrics_g1,economic_metrics_g5,economic_metrics_s1, economic_metrics_s5)
geodiversity_links <-rbind(geodiversity_metrics_g1,geodiversity_metrics_g5,geodiversity_metrics_s1, geodiversity_metrics_s5)
random_links <-rbind(random_metrics_g1,random_metrics_g5,random_metrics_s1, random_metrics_s5)


clinks_plot <- ggplot(cluster_links) +
  scale_y_log10(limits = c(8000,1e7)) +
  theme(axis.text=element_text(size=14), axis.title=element_text(size=20), panel.border = element_rect(colour = "black", fill=NA, size=2)) +
  theme(plot.title = element_text(size = 22, face = "bold", hjust = 0.5)) +
  geom_point(aes(time, links, group=spec, color=spec), size=2.0) +
  #stat_summary(aes(x=time, y=links, group=spec, color=spec),fun=mean, geom="line") +
  geom_smooth(method="loess", aes(x=time, y=links,group=spec,color=spec), se=T) +
  scale_color_manual(labels = c("Generalist_1000m", "Generalist_5000m","Specialist_1000m", "Specialist_5000m"),
                     values=c("darkorange3", "orange", "dodgerblue4", "lightsteelblue3")) +
  scale_x_continuous(labels=c("2020", "2040", "2060","2080","2100")) +
  ggtitle("Cluster links") +
  ylab("Number of links") +
  theme(legend.position = "none") +
  theme(axis.text.x = element_text(color="black", 
                                   size=14, angle=0),
        axis.text.y = element_text(color="black", 
                                   size=14, angle=0),
        axis.title.x = element_blank()) +
  annotate(geom="text", x=3, y=7000000, label="e",color="black",size=14)

#clinks_plot

elinks_plot <- ggplot(economic_links) +
  scale_y_log10(limits = c(8000,1e7)) +
  theme(axis.text=element_text(size=14), axis.title=element_text(size=18), panel.border = element_rect(colour = "black", fill=NA, size=2)) +
  theme(plot.title = element_text(size = 22, face = "bold", hjust = 0.5)) +
  geom_point(aes(time, links, group=spec, color=spec), size=2.0) +
  #stat_summary(aes(x=time, y=links, group=spec, color=spec),fun=mean, geom="line") +
  geom_smooth(method="loess", aes(x=time, y=links,group=spec,color=spec), se=T) +
  scale_color_manual(labels = c("Generalist_1000m", "Generalist_5000m","Specialist_1000m", "Specialist_5000m"),
                     values=c("darkorange3", "orange", "dodgerblue4", "lightsteelblue3")) +
  scale_x_continuous(labels=c("2020", "2040", "2060","2080","2100")) +
  ggtitle("Economic links") +
  theme(legend.position = "none") +
  theme(axis.text.x = element_text(color="black", 
                                   size=14, angle=0),
        axis.text.y = element_blank(),
        axis.title.x = element_blank(),
        axis.title.y = element_blank()) +
  annotate(geom="text", x=3, y=7000000, label="f",color="black",size=14)

glinks_plot <- ggplot(geodiversity_links) +
  scale_y_log10(limits = c(8000,1e7)) +
  theme(axis.text=element_text(size=14), axis.title=element_text(size=18), panel.border = element_rect(colour = "black", fill=NA, size=2)) +
  theme(plot.title = element_text(size = 22, face = "bold", hjust = 0.5)) +
  geom_point(aes(time, links, group=spec, color=spec), size=2.0) +
  #stat_summary(aes(x=time, y=links, group=spec, color=spec),fun=mean, geom="line") +
  geom_smooth(method="loess", aes(x=time, y=links,group=spec,color=spec), se=T) +
  scale_color_manual(labels = c("Generalist_1000m", "Generalist_5000m","Specialist_1000m", "Specialist_5000m"),
                     values=c("darkorange3", "orange", "dodgerblue4", "lightsteelblue3")) +
  scale_x_continuous(labels=c("2020", "2040", "2060","2080","2100")) +
  ggtitle("Geodiversity links") +
  theme(legend.position = "none") +
  theme(axis.text.x = element_text(color="black", 
                                   size=14, angle=0),
        axis.text.y = element_blank(),
        axis.title.x = element_blank(),
        axis.title.y = element_blank()) +
  annotate(geom="text", x=3, y=7000000, label="g",color="black",size=14)

rlinks_plot <- ggplot(random_links) +
  scale_y_log10(limits = c(8000,1e7)) +
  theme(axis.text=element_text(size=14), axis.title=element_text(size=18), panel.border = element_rect(colour = "black", fill=NA, size=2)) +
  theme(plot.title = element_text(size = 22, face = "bold", hjust = 0.5)) +
  geom_point(aes(time, links, group=spec, color=spec), size=2.0) +
  geom_smooth(method="loess", aes(x=time, y=links,group=spec,color=spec), se=T) +
  #stat_summary(aes(x=time, y=links, group=spec, color=spec),fun=mean, geom="line") +
  scale_color_manual(labels = c("Generalist_1000m", "Generalist_5000m","Specialist_1000m", "Specialist_5000m"),
                     values=c("darkorange3", "orange", "dodgerblue4", "lightsteelblue3")) +
  scale_x_continuous(labels=c("2020", "2040", "2060","2080","2100")) +
  ggtitle("Opportunistic links") +
  theme(legend.position=c(0.73,0.16)) +
  theme(legend.title = element_blank()) +
  theme(legend.text = element_text(color="black", 
                                   size=14)) +
  theme(axis.text.x = element_text(color="black", 
                                   size=14, angle=0),
        axis.text.y = element_blank(),
        axis.title.x = element_blank(),
        axis.title.y = element_blank()) +
  annotate(geom="text", x=3, y=7000000, label="h",color="black",size=14)
rlinks_plot

bottom <- textGrob("Time (years)", gp = gpar(fontsize = 18))
ggarrange(cnodes_plot,enodes_plot,gnodes_plot,rnodes_plot,clinks_plot,elinks_plot,glinks_plot,rlinks_plot, nrow=2, bottom=bottom)

################################################################################
############################# specialist 1000m #################################
################################################################################
setwd("D:/ser2par/ser2par2/")

con <- c("cluster","econ","geo","rand")
rep <- c("1","2","3","4","5")

for (c in con){
  alldata<- NULL
  
  for (r in rep){
    #c="cluster"
    #r="2"
  dataset <- read.table(paste0("D:/ser2par/ser2par2/",c,r,"/results_all_overall_indices.txt"), header=FALSE)
  #dataset$rep <- paste0(r)
  #dataset$con = paste0(c)
  #rownames(dataset$V1) <- c("time","")
  alldata <- rbind(alldata, dataset)
  assign(paste0(c,r,"_s1"), dataset)
}
  assign(paste0(c,"s1_all"), alldata)
}

clusters1_all$time <-c(0,0,0,0,0,10,10,10,10,10,20,20,20,20,20,30,30,30,30,30,40,40,40,40,40,50,50,50,50,50,60,60,60,60,60,70,70,70,70,70,80,80,80,80,80,
                       0,0,0,0,0,10,10,10,10,10,20,20,20,20,20,30,30,30,30,30,40,40,40,40,40,50,50,50,50,50,60,60,60,60,60,70,70,70,70,70,80,80,80,80,80,
                       0,0,0,0,0,10,10,10,10,10,20,20,20,20,20,30,30,30,30,30,40,40,40,40,40,50,50,50,50,50,60,60,60,60,60,70,70,70,70,70,80,80,80,80,80,
                       0,0,0,0,0,10,10,10,10,10,20,20,20,20,20,30,30,30,30,30,40,40,40,40,40,50,50,50,50,50,60,60,60,60,60,70,70,70,70,70,80,80,80,80,80,
                       0,0,0,0,0,10,10,10,10,10,20,20,20,20,20,30,30,30,30,30,40,40,40,40,40,50,50,50,50,50,60,60,60,60,60,70,70,70,70,70,80,80,80,80,80)
econs1_all$time <-c(0,0,0,0,0,10,10,10,10,10,20,20,20,20,20,30,30,30,30,30,40,40,40,40,40,50,50,50,50,50,60,60,60,60,60,70,70,70,70,70,80,80,80,80,80,
                       0,0,0,0,0,10,10,10,10,10,20,20,20,20,20,30,30,30,30,30,40,40,40,40,40,50,50,50,50,50,60,60,60,60,60,70,70,70,70,70,80,80,80,80,80,
                       0,0,0,0,0,10,10,10,10,10,20,20,20,20,20,30,30,30,30,30,40,40,40,40,40,50,50,50,50,50,60,60,60,60,60,70,70,70,70,70,80,80,80,80,80,
                       0,0,0,0,0,10,10,10,10,10,20,20,20,20,20,30,30,30,30,30,40,40,40,40,40,50,50,50,50,50,60,60,60,60,60,70,70,70,70,70,80,80,80,80,80,
                       0,0,0,0,0,10,10,10,10,10,20,20,20,20,20,30,30,30,30,30,40,40,40,40,40,50,50,50,50,50,60,60,60,60,60,70,70,70,70,70,80,80,80,80,80)
geos1_all$time <-c(0,0,0,0,0,10,10,10,10,10,20,20,20,20,20,30,30,30,30,30,40,40,40,40,40,50,50,50,50,50,60,60,60,60,60,70,70,70,70,70,80,80,80,80,80,
                       0,0,0,0,0,10,10,10,10,10,20,20,20,20,20,30,30,30,30,30,40,40,40,40,40,50,50,50,50,50,60,60,60,60,60,70,70,70,70,70,80,80,80,80,80,
                       0,0,0,0,0,10,10,10,10,10,20,20,20,20,20,30,30,30,30,30,40,40,40,40,40,50,50,50,50,50,60,60,60,60,60,70,70,70,70,70,80,80,80,80,80,
                       0,0,0,0,0,10,10,10,10,10,20,20,20,20,20,30,30,30,30,30,40,40,40,40,40,50,50,50,50,50,60,60,60,60,60,70,70,70,70,70,80,80,80,80,80,
                       0,0,0,0,0,10,10,10,10,10,20,20,20,20,20,30,30,30,30,30,40,40,40,40,40,50,50,50,50,50,60,60,60,60,60,70,70,70,70,70,80,80,80,80,80)
rands1_all$time <-c(0,0,0,0,0,10,10,10,10,10,20,20,20,20,20,30,30,30,30,30,40,40,40,40,40,50,50,50,50,50,60,60,60,60,60,70,70,70,70,70,80,80,80,80,80,
                       0,0,0,0,0,10,10,10,10,10,20,20,20,20,20,30,30,30,30,30,40,40,40,40,40,50,50,50,50,50,60,60,60,60,60,70,70,70,70,70,80,80,80,80,80,
                       0,0,0,0,0,10,10,10,10,10,20,20,20,20,20,30,30,30,30,30,40,40,40,40,40,50,50,50,50,50,60,60,60,60,60,70,70,70,70,70,80,80,80,80,80,
                       0,0,0,0,0,10,10,10,10,10,20,20,20,20,20,30,30,30,30,30,40,40,40,40,40,50,50,50,50,50,60,60,60,60,60,70,70,70,70,70,80,80,80,80,80,
                       0,0,0,0,0,10,10,10,10,10,20,20,20,20,20,30,30,30,30,30,40,40,40,40,40,50,50,50,50,50,60,60,60,60,60,70,70,70,70,70,80,80,80,80,80)

clusters1_all$spec<-"s1"
econs1_all$spec<-"s1"
geos1_all$spec<-"s1"
rands1_all$spec<-"s1"


################################################################################
############################# specialist 5000m #################################
################################################################################
setwd("D:/ser2par/ser2par4/")

con <- c("cluster","econ","geo","rand")
rep <- c("1","2","3","4","5")

for (c in con){
  alldata<- NULL
  
  for (r in rep){
    #f="cluster1"
    #distances <- list.files(paste0(f),pattern=("results_all_EC*"))
    dataset <- read.table(paste0("D:/ser2par/ser2par4/",c,r,"/results_all_overall_indices.txt"), header=FALSE)
    #dataset$rep <- paste0(r)
    #rownames(dataset$V1) <- c("time","")
    alldata <- rbind(alldata, dataset)
    assign(paste0(c,r,"_all"), dataset)
  }
  assign(paste0(c,"_all"), alldata)
}

setwd("D:/ser2par/ser2par3/")

con <- c("cluster","econ","geo","rand")
rep <- c("1","2","3","4","5")

for (c in con){
  alldata<- NULL
  
  for (r in rep){
    #f="cluster1"
    #distances <- list.files(paste0(f),pattern=("results_all_EC*"))
    dataset <- read.table(paste0("D:/ser2par/ser2par3/",c,r,"/results_all_overall_indices.txt"), header=FALSE)
    #dataset$rep <- paste0(r)
    #rownames(dataset$V1) <- c("time","")
    alldata <- rbind(alldata, dataset)
    assign(paste0(c,r,"_all2"), dataset)
  }
  assign(paste0(c,"_all2"), alldata)
}
c5s <-rbind(cluster_all, cluster_all2)
e5s <-rbind(econ_all, econ_all2)
g5s <-rbind(geo_all, geo_all2)
r5s <-rbind(rand_all, rand_all2)

c5s <-rbind(cluster_all, cluster_all2)
c5s1 <-rbind(cluster1_all, cluster1_all2)
c5s2 <-rbind(cluster2_all, cluster2_all2)
c5s3 <-rbind(cluster3_all, cluster3_all2)
c5s4 <-rbind(cluster4_all, cluster4_all2)
c5s5 <-rbind(cluster5_all, cluster5_all2)

c5s$time <-c(0,0,0,0,0,10,10,10,10,10,20,20,20,20,20,30,30,30,30,30,40,40,40,40,40,0,0,0,0,0,10,10,10,10,10,20,20,20,20,20,30,30,30,30,30,40,40,40,40,40,
             0,0,0,0,0,10,10,10,10,10,20,20,20,20,20,30,30,30,30,30,40,40,40,40,40,0,0,0,0,0,10,10,10,10,10,20,20,20,20,20,30,30,30,30,30,40,40,40,40,40,
             0,0,0,0,0,10,10,10,10,10,20,20,20,20,20,30,30,30,30,30,40,40,40,40,40,50,50,50,50,50,60,60,60,60,60,70,70,70,70,70,80,80,80,80,80,
                       50,50,50,50,50,60,60,60,60,60,70,70,70,70,70,80,80,80,80,80,50,50,50,50,50,60,60,60,60,60,70,70,70,70,70,80,80,80,80,80,
                       50,50,50,50,50,60,60,60,60,60,70,70,70,70,70,80,80,80,80,80,50,50,50,50,50,60,60,60,60,60,70,70,70,70,70,80,80,80,80,80)
e5s$time <-c(0,0,0,0,0,10,10,10,10,10,20,20,20,20,20,30,30,30,30,30,40,40,40,40,40,0,0,0,0,0,10,10,10,10,10,20,20,20,20,20,30,30,30,30,30,40,40,40,40,40,
        0,0,0,0,0,10,10,10,10,10,20,20,20,20,20,30,30,30,30,30,40,40,40,40,40,0,0,0,0,0,10,10,10,10,10,20,20,20,20,20,30,30,30,30,30,40,40,40,40,40,
        0,0,0,0,0,10,10,10,10,10,20,20,20,20,20,30,30,30,30,30,40,40,40,40,40,50,50,50,50,50,60,60,60,60,60,70,70,70,70,70,80,80,80,80,80,
        50,50,50,50,50,60,60,60,60,60,70,70,70,70,70,80,80,80,80,80,50,50,50,50,50,60,60,60,60,60,70,70,70,70,70,80,80,80,80,80,
        50,50,50,50,50,60,60,60,60,60,70,70,70,70,70,80,80,80,80,80,50,50,50,50,50,60,60,60,60,60,70,70,70,70,70,80,80,80,80,80)
g5s$time <-c(0,0,0,0,0,10,10,10,10,10,20,20,20,20,20,30,30,30,30,30,40,40,40,40,40,0,0,0,0,0,10,10,10,10,10,20,20,20,20,20,30,30,30,30,30,40,40,40,40,40,
             0,0,0,0,0,10,10,10,10,10,20,20,20,20,20,30,30,30,30,30,40,40,40,40,40,0,0,0,0,0,10,10,10,10,10,20,20,20,20,20,30,30,30,30,30,40,40,40,40,40,
             0,0,0,0,0,10,10,10,10,10,20,20,20,20,20,30,30,30,30,30,40,40,40,40,40,50,50,50,50,50,60,60,60,60,60,70,70,70,70,70,80,80,80,80,80,
             50,50,50,50,50,60,60,60,60,60,70,70,70,70,70,80,80,80,80,80,50,50,50,50,50,60,60,60,60,60,70,70,70,70,70,80,80,80,80,80,
             50,50,50,50,50,60,60,60,60,60,70,70,70,70,70,80,80,80,80,80,50,50,50,50,50,60,60,60,60,60,70,70,70,70,70,80,80,80,80,80)
r5s$time <-c(0,0,0,0,0,10,10,10,10,10,20,20,20,20,20,30,30,30,30,30,40,40,40,40,40,0,0,0,0,0,10,10,10,10,10,20,20,20,20,20,30,30,30,30,30,40,40,40,40,40,
  0,0,0,0,0,10,10,10,10,10,20,20,20,20,20,30,30,30,30,30,40,40,40,40,40,0,0,0,0,0,10,10,10,10,10,20,20,20,20,20,30,30,30,30,30,40,40,40,40,40,
  0,0,0,0,0,10,10,10,10,10,20,20,20,20,20,30,30,30,30,30,40,40,40,40,40,50,50,50,50,50,60,60,60,60,60,70,70,70,70,70,80,80,80,80,80,
  50,50,50,50,50,60,60,60,60,60,70,70,70,70,70,80,80,80,80,80,50,50,50,50,50,60,60,60,60,60,70,70,70,70,70,80,80,80,80,80,
  50,50,50,50,50,60,60,60,60,60,70,70,70,70,70,80,80,80,80,80,50,50,50,50,50,60,60,60,60,60,70,70,70,70,70,80,80,80,80,80)

c5s$spec<-"s5"
e5s$spec<-"s5"
g5s$spec<-"s5"
r5s$spec<-"s5"

################################################################################
############################# generalist 1000m #################################
################################################################################
setwd("D:/ser2par/ser2parg1/")

con <- c("cluster","econ","geo","rand")
rep <- c("1","2","3","4","5")

for (c in con){
  alldata<- NULL
  
  for (r in rep){
    #c="cluster"
    #r="2"
    dataset <- read.table(paste0("D:/ser2par/ser2parg1/",c,r,"/results_all_overall_indices.txt"), header=FALSE)
    #dataset$rep <- paste0(r)
    #dataset$con = paste0(c)
    #rownames(dataset$V1) <- c("time","")
    alldata <- rbind(alldata, dataset)
    assign(paste0(c,r,"_g1"), dataset)
  }
  assign(paste0(c,"g1_all"), alldata)
}

clusterg1_all$time <-c(0,0,0,0,0,10,10,10,10,10,20,20,20,20,20,30,30,30,30,30,40,40,40,40,40,50,50,50,50,50,60,60,60,60,60,70,70,70,70,70,80,80,80,80,80,
                       0,0,0,0,0,10,10,10,10,10,20,20,20,20,20,30,30,30,30,30,40,40,40,40,40,50,50,50,50,50,60,60,60,60,60,70,70,70,70,70,80,80,80,80,80,
                       0,0,0,0,0,10,10,10,10,10,20,20,20,20,20,30,30,30,30,30,40,40,40,40,40,50,50,50,50,50,60,60,60,60,60,70,70,70,70,70,80,80,80,80,80,
                       0,0,0,0,0,10,10,10,10,10,20,20,20,20,20,30,30,30,30,30,40,40,40,40,40,50,50,50,50,50,60,60,60,60,60,70,70,70,70,70,80,80,80,80,80,
                       0,0,0,0,0,10,10,10,10,10,20,20,20,20,20,30,30,30,30,30,40,40,40,40,40,50,50,50,50,50,60,60,60,60,60,70,70,70,70,70,80,80,80,80,80)
econg1_all$time <-c(0,0,0,0,0,10,10,10,10,10,20,20,20,20,20,30,30,30,30,30,40,40,40,40,40,50,50,50,50,50,60,60,60,60,60,70,70,70,70,70,80,80,80,80,80,
                    0,0,0,0,0,10,10,10,10,10,20,20,20,20,20,30,30,30,30,30,40,40,40,40,40,50,50,50,50,50,60,60,60,60,60,70,70,70,70,70,80,80,80,80,80,
                    0,0,0,0,0,10,10,10,10,10,20,20,20,20,20,30,30,30,30,30,40,40,40,40,40,50,50,50,50,50,60,60,60,60,60,70,70,70,70,70,80,80,80,80,80,
                    0,0,0,0,0,10,10,10,10,10,20,20,20,20,20,30,30,30,30,30,40,40,40,40,40,50,50,50,50,50,60,60,60,60,60,70,70,70,70,70,80,80,80,80,80,
                    0,0,0,0,0,10,10,10,10,10,20,20,20,20,20,30,30,30,30,30,40,40,40,40,40,50,50,50,50,50,60,60,60,60,60,70,70,70,70,70,80,80,80,80,80)
geog1_all$time <-c(0,0,0,0,0,10,10,10,10,10,20,20,20,20,20,30,30,30,30,30,40,40,40,40,40,50,50,50,50,50,60,60,60,60,60,70,70,70,70,70,80,80,80,80,80,
                   0,0,0,0,0,10,10,10,10,10,20,20,20,20,20,30,30,30,30,30,40,40,40,40,40,50,50,50,50,50,60,60,60,60,60,70,70,70,70,70,80,80,80,80,80,
                   0,0,0,0,0,10,10,10,10,10,20,20,20,20,20,30,30,30,30,30,40,40,40,40,40,50,50,50,50,50,60,60,60,60,60,70,70,70,70,70,80,80,80,80,80,
                   0,0,0,0,0,10,10,10,10,10,20,20,20,20,20,30,30,30,30,30,40,40,40,40,40,50,50,50,50,50,60,60,60,60,60,70,70,70,70,70,80,80,80,80,80,
                   0,0,0,0,0,10,10,10,10,10,20,20,20,20,20,30,30,30,30,30,40,40,40,40,40,50,50,50,50,50,60,60,60,60,60,70,70,70,70,70,80,80,80,80,80)
randg1_all$time <-c(0,0,0,0,0,10,10,10,10,10,20,20,20,20,20,30,30,30,30,30,40,40,40,40,40,50,50,50,50,50,60,60,60,60,60,70,70,70,70,70,80,80,80,80,80,
                    0,0,0,0,0,10,10,10,10,10,20,20,20,20,20,30,30,30,30,30,40,40,40,40,40,50,50,50,50,50,60,60,60,60,60,70,70,70,70,70,80,80,80,80,80,
                    0,0,0,0,0,10,10,10,10,10,20,20,20,20,20,30,30,30,30,30,40,40,40,40,40,50,50,50,50,50,60,60,60,60,60,70,70,70,70,70,80,80,80,80,80,
                    0,0,0,0,0,10,10,10,10,10,20,20,20,20,20,30,30,30,30,30,40,40,40,40,40,50,50,50,50,50,60,60,60,60,60,70,70,70,70,70,80,80,80,80,80,
                    0,0,0,0,0,10,10,10,10,10,20,20,20,20,20,30,30,30,30,30,40,40,40,40,40,50,50,50,50,50,60,60,60,60,60,70,70,70,70,70,80,80,80,80,80)

clusterg1_all$spec<-"g1"
econg1_all$spec<-"g1"
geog1_all$spec<-"g1"
randg1_all$spec<-"g1"

################################################################################
############################# generalist 5000m #################################
################################################################################
setwd("D:/ser2par/ser2parg5/")

con <- c("cluster","econ","geo","rand")
rep <- c("1","2","3","4","5")

for (c in con){
  alldata<- NULL
  
  for (r in rep){
    #f="cluster1"
    #distances <- list.files(paste0(f),pattern=("results_all_EC*"))
    dataset <- read.table(paste0("D:/ser2par/ser2parg5/",c,r,"/results_all_overall_indices.txt"), header=FALSE)
    #dataset$rep <- paste0(r)
    #rownames(dataset$V1) <- c("time","")
    alldata <- rbind(alldata, dataset)
    assign(paste0(c,r,"_g5"), dataset)
  }
  assign(paste0(c,"g5_all"), alldata)
}



clusterg5_all$time <-c(0,0,0,0,0,10,10,10,10,10,20,20,20,20,20,30,30,30,30,30,40,40,40,40,40,0,0,0,0,0,10,10,10,10,10,20,20,20,20,20,30,30,30,30,30,40,40,40,40,40,
             0,0,0,0,0,10,10,10,10,10,20,20,20,20,20,30,30,30,30,30,40,40,40,40,40,0,0,0,0,0,10,10,10,10,10,20,20,20,20,20,30,30,30,30,30,40,40,40,40,40,
             0,0,0,0,0,10,10,10,10,10,20,20,20,20,20,30,30,30,30,30,40,40,40,40,40,50,50,50,50,50,60,60,60,60,60,70,70,70,70,70,80,80,80,80,80,
             50,50,50,50,50,60,60,60,60,60,70,70,70,70,70,80,80,80,80,80,50,50,50,50,50,60,60,60,60,60,70,70,70,70,70,80,80,80,80,80,
             50,50,50,50,50,60,60,60,60,60,70,70,70,70,70,80,80,80,80,80,50,50,50,50,50,60,60,60,60,60,70,70,70,70,70,80,80,80,80,80)
econg5_all$time <-c(0,0,0,0,0,10,10,10,10,10,20,20,20,20,20,30,30,30,30,30,40,40,40,40,40,0,0,0,0,0,10,10,10,10,10,20,20,20,20,20,30,30,30,30,30,40,40,40,40,40,
             0,0,0,0,0,10,10,10,10,10,20,20,20,20,20,30,30,30,30,30,40,40,40,40,40,0,0,0,0,0,10,10,10,10,10,20,20,20,20,20,30,30,30,30,30,40,40,40,40,40,
             0,0,0,0,0,10,10,10,10,10,20,20,20,20,20,30,30,30,30,30,40,40,40,40,40,50,50,50,50,50,60,60,60,60,60,70,70,70,70,70,80,80,80,80,80,
             50,50,50,50,50,60,60,60,60,60,70,70,70,70,70,80,80,80,80,80,50,50,50,50,50,60,60,60,60,60,70,70,70,70,70,80,80,80,80,80,
             50,50,50,50,50,60,60,60,60,60,70,70,70,70,70,80,80,80,80,80,50,50,50,50,50,60,60,60,60,60,70,70,70,70,70,80,80,80,80,80)
geog5_all$time <-c(0,0,0,0,0,10,10,10,10,10,20,20,20,20,20,30,30,30,30,30,40,40,40,40,40,0,0,0,0,0,10,10,10,10,10,20,20,20,20,20,30,30,30,30,30,40,40,40,40,40,
             0,0,0,0,0,10,10,10,10,10,20,20,20,20,20,30,30,30,30,30,40,40,40,40,40,0,0,0,0,0,10,10,10,10,10,20,20,20,20,20,30,30,30,30,30,40,40,40,40,40,
             0,0,0,0,0,10,10,10,10,10,20,20,20,20,20,30,30,30,30,30,40,40,40,40,40,50,50,50,50,50,60,60,60,60,60,70,70,70,70,70,80,80,80,80,80,
             50,50,50,50,50,60,60,60,60,60,70,70,70,70,70,80,80,80,80,80,50,50,50,50,50,60,60,60,60,60,70,70,70,70,70,80,80,80,80,80,
             50,50,50,50,50,60,60,60,60,60,70,70,70,70,70,80,80,80,80,80,50,50,50,50,50,60,60,60,60,60,70,70,70,70,70,80,80,80,80,80)
randg5_all$time <-c(0,0,0,0,0,10,10,10,10,10,20,20,20,20,20,30,30,30,30,30,40,40,40,40,40,0,0,0,0,0,10,10,10,10,10,20,20,20,20,20,30,30,30,30,30,40,40,40,40,40,
             0,0,0,0,0,10,10,10,10,10,20,20,20,20,20,30,30,30,30,30,40,40,40,40,40,0,0,0,0,0,10,10,10,10,10,20,20,20,20,20,30,30,30,30,30,40,40,40,40,40,
             0,0,0,0,0,10,10,10,10,10,20,20,20,20,20,30,30,30,30,30,40,40,40,40,40,50,50,50,50,50,60,60,60,60,60,70,70,70,70,70,80,80,80,80,80,
             50,50,50,50,50,60,60,60,60,60,70,70,70,70,70,80,80,80,80,80,50,50,50,50,50,60,60,60,60,60,70,70,70,70,70,80,80,80,80,80,
             50,50,50,50,50,60,60,60,60,60,70,70,70,70,70,80,80,80,80,80,50,50,50,50,50,60,60,60,60,60,70,70,70,70,70,80,80,80,80,80)

clusterg5_all$spec<-"g5"
econg5_all$spec<-"g5"
geog5_all$spec<-"g5"
randg5_all$spec<-"g5"


##################################################################################################################
################################################ EC graphs #######################################################
#################################################################################################################

clusters1_split<-split(clusters1_all, clusters1_all$V4)
clusters1_EC <- clusters1_split$`EC(PC)`
clusters1_intra <- clusters1_split$`PCintra(%)`
clusters1_direct <- clusters1_split$`PCdirect(%)`
clusters1_step <- clusters1_split$`PCstep(%)`

econs1_split<-split(econs1_all, econs1_all$V4)
econs1_EC <- econs1_split$`EC(PC)`
econs1_intra <- econs1_split$`PCintra(%)`
econs1_direct <- econs1_split$`PCdirect(%)`
econs1_step <- econs1_split$`PCstep(%)`

geos1_split<-split(geos1_all, geos1_all$V4)
geos1_EC <- geos1_split$`EC(PC)`
geos1_intra <- geos1_split$`PCintra(%)`
geos1_direct <- geos1_split$`PCdirect(%)`
geos1_step <- geos1_split$`PCstep(%)`

rands1_split<-split(rands1_all, rands1_all$V4)
rands1_EC <- rands1_split$`EC(PC)`
rands1_intra <- rands1_split$`PCintra(%)`
rands1_direct <- rands1_split$`PCdirect(%)`
rands1_step <- rands1_split$`PCstep(%)`

c5s_split<-split(c5s, c5s$V4)
c5s_EC <- c5s_split$`EC(PC)`
c5s_intra <- c5s_split$`PCintra(%)`
c5s_direct <- c5s_split$`PCdirect(%)`
c5s_step <- c5s_split$`PCstep(%)`

e5s_split<-split(e5s, e5s$V4)
e5s_EC <- e5s_split$`EC(PC)`
e5s_intra <- e5s_split$`PCintra(%)`
e5s_direct <- e5s_split$`PCdirect(%)`
e5s_step <- e5s_split$`PCstep(%)`

g5s_split<-split(g5s, g5s$V4)
g5s_EC <- g5s_split$`EC(PC)`
g5s_intra <- g5s_split$`PCintra(%)`
g5s_direct <- g5s_split$`PCdirect(%)`
g5s_step <- g5s_split$`PCstep(%)`

r5s_split<-split(r5s, r5s$V4)
r5s_EC <- r5s_split$`EC(PC)`
r5s_intra <- r5s_split$`PCintra(%)`
r5s_direct <- r5s_split$`PCdirect(%)`
r5s_step <- r5s_split$`PCstep(%)`

clusterg1_split<-split(clusterg1_all, clusterg1_all$V4)
clusterg1_EC <- clusterg1_split$`EC(PC)`
clusterg1_intra <- clusterg1_split$`PCintra(%)`
clusterg1_direct <- clusterg1_split$`PCdirect(%)`
clusterg1_step <- clusterg1_split$`PCstep(%)`

econg1_split<-split(econg1_all, econg1_all$V4)
econg1_EC <- econg1_split$`EC(PC)`
econg1_intra <- econg1_split$`PCintra(%)`
econg1_direct <- econg1_split$`PCdirect(%)`
econg1_step <- econg1_split$`PCstep(%)`

geog1_split<-split(geog1_all, geog1_all$V4)
geog1_EC <- geog1_split$`EC(PC)`
geog1_intra <- geog1_split$`PCintra(%)`
geog1_direct <- geog1_split$`PCdirect(%)`
geog1_step <- geog1_split$`PCstep(%)`

randg1_split<-split(randg1_all, randg1_all$V4)
randg1_EC <- randg1_split$`EC(PC)`
randg1_intra <- randg1_split$`PCintra(%)`
randg1_direct <- randg1_split$`PCdirect(%)`
randg1_step <- randg1_split$`PCstep(%)`

clusterg5_split<-split(clusterg5_all, clusterg5_all$V4)
clusterg5_EC <- clusterg5_split$`EC(PC)`
clusterg5_intra <- clusterg5_split$`PCintra(%)`
clusterg5_direct <- clusterg5_split$`PCdirect(%)`
clusterg5_step <- clusterg5_split$`PCstep(%)`

econg5_split<-split(econg5_all, econg5_all$V4)
econg5_EC <- econg5_split$`EC(PC)`
econg5_intra <- econg5_split$`PCintra(%)`
econg5_direct <- econg5_split$`PCdirect(%)`
econg5_step <- econg5_split$`PCstep(%)`

geog5_split<-split(geog5_all, geog5_all$V4)
geog5_EC <- geog5_split$`EC(PC)`
geog5_intra <- geog5_split$`PCintra(%)`
geog5_direct <- geog5_split$`PCdirect(%)`
geog5_step <- geog5_split$`PCstep(%)`

randg5_split<-split(randg5_all, randg5_all$V4)
randg5_EC <- randg5_split$`EC(PC)`
randg5_intra <- randg5_split$`PCintra(%)`
randg5_direct <- randg5_split$`PCdirect(%)`
randg5_step <- randg5_split$`PCstep(%)`


spec_cluster_EC<-rbind(clusters1_EC,c5s_EC,clusterg1_EC,clusterg5_EC)
spec_cluster_intra<-rbind(clusters1_intra,c5s_intra,clusterg1_intra,clusterg5_intra)
spec_cluster_direct<-rbind(clusters1_direct,c5s_direct,clusterg1_direct,clusterg5_direct)
spec_cluster_step<-rbind(clusters1_step,c5s_step,clusterg1_step,clusterg5_step)
 
spec_econ_EC<-rbind(econs1_EC,e5s_EC,econg1_EC,econg5_EC)
spec_econ_intra<-rbind(econs1_intra,e5s_intra,econg1_intra,econg5_intra)
spec_econ_direct<-rbind(econs1_direct,e5s_direct,econg1_direct,econg5_direct)
spec_econ_step<-rbind(econs1_step,e5s_step,econg1_step,econg5_step)

spec_geo_EC<-rbind(geos1_EC,g5s_EC,geog1_EC,geog5_EC)
spec_geo_intra<-rbind(geos1_intra,g5s_intra,geog1_intra,geog5_intra)
spec_geo_direct<-rbind(geos1_direct,g5s_direct,geog1_direct,geog5_direct)
spec_geo_step<-rbind(geos1_step,g5s_step,geog1_step,geog5_step)

spec_rand_EC<-rbind(rands1_EC,r5s_EC,randg1_EC,randg5_EC)
spec_rand_intra<-rbind(rands1_intra,r5s_intra,randg1_intra,randg5_intra)
spec_rand_direct<-rbind(rands1_direct,r5s_direct,randg1_direct,randg5_direct)
spec_rand_step<-rbind(rands1_step,r5s_step,randg1_step,randg5_step)

Cec_plot <- ggplot(spec_cluster_EC) +
  theme(axis.text=element_text(size=14), axis.title=element_text(size=18), panel.border = element_rect(colour = "black", fill=NA, size=2)) +
  theme(plot.title = element_text(size = 22, face = "bold", hjust = 0.5)) +
  geom_point(aes(time, V5, group=spec,color=spec), size=2.0) +
  geom_smooth(method="loess", aes(x=time, y=V5,group=spec,color=spec), se=T) + 
  scale_color_manual(labels = c("Generalist_1000m","Generalist_5000m","Specialist_1000m", "Specialist_5000m"),
                     values=c("darkorange3", "orange","dodgerblue4","lightsteelblue3"), guide=guide_legend(nrow=2)) +
  ggtitle("Equivalent Connected Area (ha)") +
  #theme(legend.position=c(0.65,0.18)) +
  theme(legend.position=c(0.8,0.11)) +
  theme(legend.title = element_blank()) +
  theme(legend.text = element_text(color="black", 
                                   size=14)) +
  ylab("ECA (ha)") +
  theme(axis.text.x = element_blank(),
        axis.text.y = element_text(color="black", 
                                   size=14, angle=0),
        axis.title.x = element_blank()) +
  #annotate(geom="text", x=4, y=47000, label="a",color="black",size=14) +
  annotate(geom="text", x=4, y=49000, label="Cluster",color="black",size=10) +
  ylim(0,50000)
#Cec_plot

Cintra_plot <- ggplot(spec_cluster_intra) +
  theme(axis.text=element_text(size=14), axis.title=element_text(size=18), panel.border = element_rect(colour = "black", fill=NA, size=2)) +
  theme(plot.title = element_text(size = 22, face = "bold", hjust = 0.5)) +
  geom_point(aes(time, V5, group=spec,color=spec), size=2.0) +
  geom_smooth(method="loess", aes(x=time, y=V5,group=spec,color=spec), se=T) + 
  scale_color_manual(values=c("darkorange3", "orange","dodgerblue4","lightsteelblue3")) +
  ggtitle("ECA intra (% total ECA)") +
  theme(legend.position = "none") +
  theme(axis.text.x = element_blank(),
        axis.text.y = element_text(color="black", 
                                   size=14, angle=0),
        axis.title.x = element_blank(),
        axis.title.y = element_blank()) +
  annotate(geom="text", x=4, y=93, label="b",color="black",size=14) +
  ylim(0,100)

Cdirect_plot <- ggplot(spec_cluster_direct) +
  theme(axis.text=element_text(size=14), axis.title=element_text(size=18), panel.border = element_rect(colour = "black", fill=NA, size=2)) +
  theme(plot.title = element_text(size = 22, face = "bold", hjust = 0.5)) +
  geom_point(aes(time, V5, group=spec,color=spec), size=2.0) +
  geom_smooth(method="loess", aes(x=time, y=V5,group=spec,color=spec), se=T) + 
  scale_color_manual(values=c("darkorange3", "orange","dodgerblue4","lightsteelblue3")) +
  ggtitle("ECA direct (% total ECA)") +
  theme(legend.position = "none") +
  theme(axis.text.x = element_blank(),
        axis.text.y = element_text(color="black", 
                                   size=14, angle=0),
        axis.title.x = element_blank(),
        axis.title.y = element_blank()) +
  annotate(geom="text", x=4, y=28, label="c",color="black",size=14) +
  ylim(0,30)

Cstep_plot <- ggplot(spec_cluster_step) +
  theme(axis.text=element_text(size=14), axis.title=element_text(size=18), panel.border = element_rect(colour = "black", fill=NA, size=2)) +
  theme(plot.title = element_text(size = 22, face = "bold", hjust = 0.5)) +
  geom_point(aes(time, V5, group=spec,color=spec), size=2.0) +
  geom_smooth(method="loess", aes(x=time, y=V5,group=spec,color=spec), se=T) + 
  scale_color_manual(values=c("darkorange3", "orange","dodgerblue4","lightsteelblue3")) +
  ggtitle("ECA step (% total ECA)") +
  theme(legend.position = "none") +
  theme(axis.text.x = element_blank(),
        axis.text.y = element_text(color="black", 
                                   size=14, angle=0),
        axis.title.x = element_blank(),
        axis.title.y = element_blank()) +
  annotate(geom="text", x=4, y=93, label="d",color="black",size=14) +
  #sec.axis = sec_axis(name="Cluster") +
  ylim(0,100)

Eec_plot <- ggplot(spec_econ_EC) +
  theme(axis.text=element_text(size=14), axis.title=element_text(size=18), panel.border = element_rect(colour = "black", fill=NA, size=2)) +
  theme(plot.title = element_text(size = 22, face = "bold")) +
  geom_point(aes(time, V5, group=spec,color=spec), size=2.0) +
  geom_smooth(method="loess", aes(x=time, y=V5,group=spec,color=spec), se=T) + 
  scale_color_manual(labels = c("Specialist_1000m", "Specialist_5000m", "Generalist_1000m", "Generalist_5000m"),
                     values=c("darkorange3", "orange","dodgerblue4","lightsteelblue3")) +
  #ggtitle("Equivalent Connected Area") +
  #theme(legend.position=c(0.83,0.13)) +
  theme(legend.position = "none") +
  ylab("ECA (ha)") +
  theme(axis.text.x = element_blank(),
        axis.text.y = element_text(color="black", 
                                   size=14, angle=0),
        axis.title.x = element_blank()) +
  #annotate(geom="text", x=4, y=47000, label="e",color="black",size=14) +
  annotate(geom="text", x=7, y=49000, label="Economic",color="black",size=10) +
  ylim(0,50000)

Eintra_plot <- ggplot(spec_econ_intra) +
  theme(axis.text=element_text(size=14), axis.title=element_text(size=18), panel.border = element_rect(colour = "black", fill=NA, size=2)) +
  theme(plot.title = element_text(size = 22, face = "bold")) +
  geom_point(aes(time, V5, group=spec,color=spec), size=2.0) +
  geom_smooth(method="loess", aes(x=time, y=V5,group=spec,color=spec), se=T) + 
  scale_color_manual(values=c("darkorange3", "orange","dodgerblue4","lightsteelblue3")) +
  #ggtitle("ECA intra") +
  theme(legend.position = "none") +
  theme(axis.text.x = element_blank(),
        axis.text.y = element_text(color="black", 
                                   size=14, angle=0),
        axis.title.x = element_blank(),
        axis.title.y = element_blank()) +
  annotate(geom="text", x=4, y=93, label="f",color="black",size=14) +
  ylim(0,100)

Edirect_plot <- ggplot(spec_econ_direct) +
  theme(axis.text=element_text(size=14), axis.title=element_text(size=18), panel.border = element_rect(colour = "black", fill=NA, size=2)) +
  theme(plot.title = element_text(size = 22, face = "bold")) +
  geom_point(aes(time, V5, group=spec,color=spec), size=2.0) +
  geom_smooth(method="loess", aes(x=time, y=V5,group=spec,color=spec), se=T) + 
  scale_color_manual(values=c("darkorange3", "orange","dodgerblue4","lightsteelblue3")) +
  #ggtitle("ECA direct") +
  theme(legend.position = "none") +
  theme(axis.text.x = element_blank(),
        axis.text.y = element_text(color="black", 
                                   size=14, angle=0),
        axis.title.x = element_blank(),
        axis.title.y = element_blank()) +
  annotate(geom="text", x=4, y=28, label="g",color="black",size=14) +
  ylim(0,30)

Estep_plot <- ggplot(spec_econ_step) +
  theme(axis.text=element_text(size=14), axis.title=element_text(size=18), panel.border = element_rect(colour = "black", fill=NA, size=2)) +
  theme(plot.title = element_text(size = 22, face = "bold")) +
  geom_point(aes(time, V5, group=spec,color=spec), size=2.0) +
  geom_smooth(method="loess", aes(x=time, y=V5,group=spec,color=spec), se=T) + 
  scale_color_manual(values=c("darkorange3", "orange","dodgerblue4","lightsteelblue3")) +
  #ggtitle("ECA step") +
  theme(legend.position = "none") +
  theme(axis.text.x = element_blank(),
        axis.text.y = element_text(color="black", 
                                   size=14, angle=0),
        axis.title.x = element_blank(),
        axis.title.y = element_blank()) +
  #sec.axis = sec_axis(name="Cluster") +
  annotate(geom="text", x=4, y=93, label="h",color="black",size=14) +
  ylim(0,100)

Gec_plot <- ggplot(spec_geo_EC) +
  theme(axis.text=element_text(size=14), axis.title=element_text(size=18), panel.border = element_rect(colour = "black", fill=NA, size=2)) +
  theme(plot.title = element_text(size = 22, face = "bold")) +
  geom_point(aes(time, V5, group=spec,color=spec), size=2.0) +
  geom_smooth(method="loess", aes(x=time, y=V5,group=spec,color=spec), se=T) + 
  scale_color_manual(labels = c("Specialist_1000m", "Specialist_5000m","Generalist_1000m","Generalist_5000m"),
                     values=c("darkorange3", "orange","dodgerblue4","lightsteelblue3")) +
  scale_x_continuous(labels=c("2020", "2040", "2060","2080","2100")) +
  #ggtitle("Equivalent Connected Area") +
  #theme(legend.position=c(0.83,0.13)) +
  theme(legend.position = "none") +
  ylab("ECA (ha)") +
  theme(axis.text.x = element_blank(),
        axis.text.y = element_text(color="black", 
                                   size=14, angle=0),
        axis.title.x = element_blank()) +
  #annotate(geom="text", x=4, y=47000, label="i",color="black",size=14) +
  annotate(geom="text", x=9, y=49000, label="Geodiversity",color="black",size=10) +
  ylim(0,50000)

Gintra_plot <- ggplot(spec_geo_intra) +
  theme(axis.text=element_text(size=14), axis.title=element_text(size=18), panel.border = element_rect(colour = "black", fill=NA, size=2)) +
  theme(plot.title = element_text(size = 22, face = "bold")) +
  geom_point(aes(time, V5, group=spec,color=spec), size=2.0) +
  geom_smooth(method="loess", aes(x=time, y=V5,group=spec,color=spec), se=T) + 
  scale_color_manual(values=c("darkorange3", "orange","dodgerblue4","lightsteelblue3")) +
  #ggtitle("ECA intra") +
  theme(legend.position = "none") +
  theme(axis.text.x = element_blank(),
        axis.text.y = element_text(color="black", 
                                   size=14, angle=0),
        axis.title.x = element_blank(),
        axis.title.y = element_blank()) +
  annotate(geom="text", x=4, y=93, label="j",color="black",size=14) +
  ylim(0,100)

Gdirect_plot <- ggplot(spec_geo_direct) +
  theme(axis.text=element_text(size=14), axis.title=element_text(size=18), panel.border = element_rect(colour = "black", fill=NA, size=2)) +
  theme(plot.title = element_text(size = 22, face = "bold")) +
  geom_point(aes(time, V5, group=spec,color=spec), size=2.0) +
  geom_smooth(method="loess", aes(x=time, y=V5,group=spec,color=spec), se=T) + 
  scale_color_manual(values=c("darkorange3", "orange","dodgerblue4","lightsteelblue3")) +
  #ggtitle("ECA direct") +
  theme(legend.position = "none") +
  theme(axis.text.x = element_blank(),
        axis.text.y = element_text(color="black", 
                                   size=14, angle=0),
        axis.title.x = element_blank(),
        axis.title.y = element_blank()) +
  annotate(geom="text", x=4, y=28, label="k",color="black",size=14) +
  ylim(0,30)

Gstep_plot <- ggplot(spec_geo_step) +
  theme(axis.text=element_text(size=14), axis.title=element_text(size=18), panel.border = element_rect(colour = "black", fill=NA, size=2)) +
  theme(plot.title = element_text(size = 22, face = "bold")) +
  geom_point(aes(time, V5, group=spec,color=spec), size=2.0) +
  geom_smooth(method="loess", aes(x=time, y=V5,group=spec,color=spec), se=T) + 
  scale_color_manual(values=c("darkorange3", "orange","dodgerblue4","lightsteelblue3")) +
  #ggtitle("ECA step") +
  theme(legend.position = "none") +
  theme(axis.text.x = element_blank(),
        axis.text.y = element_text(color="black", 
                                   size=14, angle=0),
        axis.title.x = element_blank(),
        axis.title.y = element_blank()) +
  #sec.axis = sec_axis(name="Cluster") +
  annotate(geom="text", x=4, y=93, label="l",color="black",size=14) +
  ylim(0,100)

Rec_plot <- ggplot(spec_rand_EC) +
  theme(axis.text=element_text(size=14), axis.title=element_text(size=18), panel.border = element_rect(colour = "black", fill=NA, size=2)) +
  theme(plot.title = element_text(size = 22, face = "bold")) +
  geom_point(aes(time, V5, group=spec,color=spec), size=2.0) +
  geom_smooth(method="loess", aes(x=time, y=V5,group=spec,color=spec), se=T) + 
  scale_color_manual(labels = c("Specialist_1000m", "Specialist_5000m","Generalist_1000m","Generalist_5000m"),
                     values=c("darkorange3", "orange","dodgerblue4","lightsteelblue3")) +
  scale_x_continuous(labels=c("2020", "2040", "2060","2080","2100")) +
  #ggtitle("Equivalent Connected Area") +
  #theme(legend.position=c(0.83,0.13)) +
  theme(legend.position = "none") +
  ylab("ECA (ha)") +
  theme(axis.text.x = element_blank(),
        axis.text.y = element_text(color="black", 
                                   size=14, angle=0),
        axis.title.x = element_blank()) +
  #annotate(geom="text", x=4, y=47000, label="m",color="black",size=14) +
  annotate(geom="text", x=10, y=49000, label="Opportunistic",color="black",size=10) +
  ylim(0,50000)

Rintra_plot <- ggplot(spec_rand_intra) +
  theme(axis.text=element_text(size=14), axis.title=element_text(size=18), panel.border = element_rect(colour = "black", fill=NA, size=2)) +
  theme(plot.title = element_text(size = 22, face = "bold")) +
  geom_point(aes(time, V5, group=spec,color=spec), size=2.0) +
  geom_smooth(method="loess", aes(x=time, y=V5,group=spec,color=spec), se=T) + 
  scale_color_manual(values=c("darkorange3", "orange","dodgerblue4","lightsteelblue3")) +
  scale_x_continuous(labels=c("2020", "2040", "2060","2080","2100")) +
  #ggtitle("ECA intra") +
  theme(legend.position = "none") +
  theme(axis.text.x = element_text(color="black", 
                                    size=14, angle=0),
        axis.text.y = element_text(color="black", 
                                   size=14, angle=0),
        axis.title.x = element_blank(),
        axis.title.y = element_blank()) +
  annotate(geom="text", x=4, y=93, label="n",color="black",size=14) +
  ylim(0,100)

Rdirect_plot <- ggplot(spec_rand_direct) +
  theme(axis.text=element_text(size=14), axis.title=element_text(size=18), panel.border = element_rect(colour = "black", fill=NA, size=2)) +
  theme(plot.title = element_text(size = 22, face = "bold")) +
  geom_point(aes(time, V5, group=spec,color=spec), size=2.0) +
  geom_smooth(method="loess", aes(x=time, y=V5,group=spec,color=spec), se=T) + 
  scale_color_manual(values=c("darkorange3", "orange","dodgerblue4","lightsteelblue3")) +
  scale_x_continuous(labels=c("2020", "2040", "2060","2080","2100")) +
  #ggtitle("ECA direct") +
  theme(legend.position = "none") +
  theme(axis.text.x = element_text(color="black", 
                                    size=14, angle=0),
        axis.text.y = element_text(color="black", 
                                   size=14, angle=0),
        axis.title.x = element_blank(),
        axis.title.y = element_blank()) +
  annotate(geom="text", x=4, y=28, label="o",color="black",size=14) +
  ylim(0,30)

Rstep_plot <- ggplot(spec_rand_step) +
  theme(axis.text=element_text(size=14), axis.title=element_text(size=18), panel.border = element_rect(colour = "black", fill=NA, size=2)) +
  theme(plot.title = element_text(size = 22, face = "bold")) +
  geom_point(aes(time, V5, group=spec,color=spec), size=2.0) +
  geom_smooth(method="loess", aes(x=time, y=V5,group=spec,color=spec), se=T) + 
  scale_color_manual(values=c("darkorange3", "orange","dodgerblue4","lightsteelblue3")) +
  scale_x_continuous(labels=c("2020", "2040", "2060","2080","2100")) +
  #ggtitle("ECA step") +
  theme(legend.position = "none") +
  theme(axis.text.x = element_text(color="black", 
                                    size=14, angle=0),
        axis.text.y = element_text(color="black", 
                                   size=14, angle=0),
        axis.title.x = element_blank(),
        axis.title.y = element_blank()) +
  #sec.axis = sec_axis(name="Cluster") +
  annotate(geom="text", x=4, y=93, label="p",color="black",size=14) +
  ylim(0,100)


bottom <- textGrob("Time (years)", gp = gpar(fontsize = 18))

ggarrange(Cec_plot,Eec_plot,Gec_plot,Rec_plot,nrow=2, bottom=bottom)
ggarrange(Cec_plot,Cintra_plot,Cdirect_plot,Cstep_plot,Eec_plot,Eintra_plot,Edirect_plot,Estep_plot, 
          Gec_plot,Gintra_plot,Gdirect_plot,Gstep_plot,Rec_plot,Rintra_plot,Rdirect_plot,Rstep_plot,nrow=4, bottom=bottom)
####################################igraph#############################################

setwd("D:/BAU_connectivity/Output_specialist5000")
nodes_s5 <- read.table("nodes_cluster1yr80.txt", header=F, as.is=T)
nodes_s5$V2[nodes_s5$V2 < 51]=2
nodes_s5$V2[51 <= nodes_s5$V2 & nodes_s5$V2 <= 300]=5
nodes_s5$V2[nodes_s5$V2 >300]=10
links_s5 <- read.table("distance_cluster1yr80.txt", header=F, as.is=T)
net_s5 <- graph_from_data_frame(d=links_s5, vertices=nodes_s5, directed=F)
V(net_s5)$size<-V(net_s5)$V2
plot(net_s5, edge.color="cadetblue",vertex.color=alpha("grey",0.5), vertex.label=NA)

setwd("D:/BAU_connectivity/Output_generalist5000")
nodes_g5 <- read.table("nodes_cluster1yr80.txt", header=F, as.is=T)
nodes_g5$V2[nodes_g5$V2 < 51]=1
nodes_g5$V2[51 <= nodes_g5$V2 & nodes_g5$V2 <= 300]=5
nodes_g5$V2[nodes_g5$V2 >300]=10
links_g5 <- read.table("distance_cluster1yr80.txt", header=F, as.is=T)
net_g5 <- graph_from_data_frame(d=links_g5, vertices=nodes_g5, directed=F)
V(net_g5)$size<-V(net_g5)$V2
plot(net_g5, vertex.label=NA)
#########################################data display habitat nodes###########################################
study_area <- readOGR("D:/Study extent/sa_reproj.shp")

setwd("D:/BAU_connectivity/cluster")

nodes <- list.files(pattern="s.tif$")
cluster_s <-raster::stack(nodes)
SumStack<-sum(cluster_s)
cluster_s_hab<-mask(SumStack, study_area)
plot(cluster_s_hab)

setwd("D:/BAU_connectivity/economic")
nodes <- list.files(pattern="s.tif$")
economic_s <-raster::stack(nodes)
SumStack<-sum(economic_s)
economic_s_hab<-mask(SumStack, study_area)
plot(economic_s_hab)

setwd("D:/BAU_connectivity/geodiversity")
nodes <- list.files(pattern="s.tif$")
geodiversity_s <-raster::stack(nodes)
SumStack<-sum(geodiversity_s)
geodiversity_s_hab<-mask(SumStack, study_area)
plot(geodiversity_s_hab)

setwd("D:/BAU_connectivity/random")
nodes <- list.files(pattern="s.tif$")
random_s <-raster::stack(nodes)
SumStack<-sum(random_s)
random_s_hab<-mask(SumStack, study_area)
plot(random_s_hab)


#########################################Old graph stuff#####################################
c1s1 <- subset(cluster1_all, V1!=("Prefix"))
c1s1$time <- c(0,10,20,30,40,50,60,70,80)
c1s2 <- subset(cluster2_all, V1!=("Prefix"))
c1s2$time <- c(0,10,20,30,40,50,60,70,80)
c1s3 <- subset(cluster3_all, V1!=("Prefix"))
c1s3$time <- c(0,10,20,30,40,50,60,70,80)
c1s4 <- subset(cluster4_all, V1!=("Prefix"))
c1s4$time <- c(0,10,20,30,40,50,60,70,80)
c1s5 <- subset(cluster5_all, V1!=("Prefix"))
c1s5$time <- c(0,10,20,30,40,50,60,70,80)

plot(x=c1s1$time, y=c1s1$V4, type = "b", col = "red", ylim=c(0,42000))
lines(x=c1s2$time, y=c1s2$V4, type = "b", col = "blue")
lines(x=c1s3$time, y=c1s3$V4, type = "b", col = "green")
lines(x=c1s4$time, y=c1s4$V4, type = "b", col = "orange")
lines(x=c1s5$time, y=c1s5$V4, type = "b", col = "purple")

plot(x=c1s$time, y=c1s$V4, type = "p", col = "red")
abline(lm(c1s$V4 ~ c1s$time))

c_avg <- c1s[,4:5]
c_avg[,1]<- as.numeric(c_avg[,1])
c_avg <- ddply(c_avg, ~ time, summarize, mean_con = mean(V4))


e1s <- subset(econ_all, V1!=("Prefix"))
e1s$time <- c(0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,70)
e1s1 <- subset(econ1_all, V1!=("Prefix"))
e1s1$time <- c(0,10,20,30,40,50,60,70,80)
e1s2 <- subset(econ2_all, V1!=("Prefix"))
e1s2$time <- c(0,10,20,30,40,50,60,70,80)
e1s3 <- subset(econ3_all, V1!=("Prefix"))
e1s3$time <- c(0,10,20,30,40,50,60,70,80)
e1s4 <- subset(econ4_all, V1!=("Prefix"))
e1s4$time <- c(0,10,20,30,40,50,60,70,80)
e1s5 <- subset(econ5_all, V1!=("Prefix"))
e1s5$time <- c(0,10,20,30,40,50,60,70)

plot(x=e1s1$time, y=e1s1$V4, type = "b", col = "blue", ylim=c(0,42000))
lines(x=e1s2$time, y=e1s2$V4, type = "b", col = "blue")
lines(x=e1s3$time, y=e1s3$V4, type = "b", col = "blue")
lines(x=e1s4$time, y=e1s4$V4, type = "b", col = "blue")
lines(x=e1s5$time, y=e1s5$V4, type = "b", col = "blue")

plot(x=e1s$time, y=e1s$V4, type = "p", col = "blue")
abline(lm(e1s$V4 ~ e1s$time))

e_avg <- e1s[,4:5]
e_avg[,1]<- as.numeric(e_avg[,1])
e_avg <- ddply(e_avg, ~ time, summarize, mean_con = mean(V4))


g1s <- subset(geo_all, V1!=("Prefix"))
g1s$time <- c(0,10,20,30,40,50,60,70,0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,0,10,20,30,40,50,60,0,10,20,30,40,50,60,70,80)
g1s1 <- subset(geo1_all, V1!=("Prefix"))
g1s1$time <- c(0,10,20,30,40,50,60,70)
g1s2 <- subset(geo2_all, V1!=("Prefix"))
g1s2$time <- c(0,10,20,30,40,50,60,70,80)
g1s3 <- subset(geo3_all, V1!=("Prefix"))
g1s3$time <- c(0,10,20,30,40,50,60)
g1s4 <- subset(geo4_all, V1!=("Prefix"))
g1s4$time <- c(0,10,20,30,40,50,60)
g1s5 <- subset(geo5_all, V1!=("Prefix"))
g1s5$time <- c(0,10,20,30,40,50,60,70,80)

plot(x=g1s1$time, y=g1s1$V4, type = "b", col = "green", ylim=c(0,42000))
lines(x=g1s2$time, y=g1s2$V4, type = "b", col = "green")
lines(x=g1s3$time, y=g1s3$V4, type = "b", col = "green")
lines(x=g1s4$time, y=g1s4$V4, type = "b", col = "green")
lines(x=g1s5$time, y=g1s5$V4, type = "b", col = "green")

plot(x=g1s$time, y=g1s$V4, type = "p", col = "green")
abline(lm(g1s$V4 ~ g1s$time))

g_avg <- g1s[,4:5]
g_avg[,1]<- as.numeric(g_avg[,1])
g_avg <- ddply(g_avg, ~ time, summarize, mean_con = mean(V4))


r1s <- subset(rand_all, V1!=("Prefix"))
r1s$time <- c(0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,70,80,0,10,20,30,40,50,60,0,10,20,30,40,50,60,70)
r1s1 <- subset(rand1_all, V1!=("Prefix"))
r1s1$time <- c(0,10,20,30,40,50,60,70,80)
r1s2 <- subset(rand2_all, V1!=("Prefix"))
r1s2$time <- c(0,10,20,30,40,50,60,70,80)
r1s3 <- subset(rand3_all, V1!=("Prefix"))
r1s3$time <- c(0,10,20,30,40,50,60,70,80)
r1s4 <- subset(rand4_all, V1!=("Prefix"))
r1s4$time <- c(0,10,20,30,40,50,60,70)
r1s5 <- subset(rand5_all, V1!=("Prefix"))
r1s5$time <- c(0,10,20,30,40,50,60,70)

plot(x=r1s1$time, y=r1s1$V4, type = "b", col = "purple", ylim=c(0,42000))
lines(x=r1s2$time, y=r1s2$V4, type = "b", col = "purple")
lines(x=r1s3$time, y=r1s3$V4, type = "b", col = "purple")
lines(x=r1s4$time, y=r1s4$V4, type = "b", col = "purple")
lines(x=r1s5$time, y=r1s5$V4, type = "b", col = "purple")

plot(x=r1s$time, y=r1s$V4, type = "p", col = "purple")
abline(lm(r1s$V4 ~ r1s$time))

r_avg <- r1s[,4:5]
r_avg[,1]<- as.numeric(r_avg[,1])
r_avg <- ddply(r_avg, ~ time, summarize, mean_con = mean(V4))


plot(c_avg, type="l", col="red")
lines(e_avg, type="l",col="blue")
lines(g_avg, type="l",col="green")
lines(r_avg, type="l",col="purple")
legend(52, 13000, legend=c("cluster", "econ","geo","rand"),
       col=c("red","blue","green","purple"),lty=1)

s1_all <- rbind(c1s, e1s, g1s, r1s)
s1_all[,4]<- as.numeric(s1_all[,4])

Process_Plot1<-function(s1_all)
  set1<-seq(0,80, by=10)
set2<-(s1_all$V4[ s1_all$rep=="1" & s1_all$strat=="cluster"])
set3<-(s1_all$V4[ s1_all$rep=="2" & s1_all$strat=="cluster"])
set4<-(s1_all$V4[ s1_all$rep=="3" & s1_all$strat=="cluster"])
set5<-(s1_all$V4[ s1_all$rep=="4" & s1_all$strat=="cluster"])
set6<-(s1_all$V4[ s1_all$rep=="5" & s1_all$strat=="cluster"])
ploty<-data.frame(set1=set1,set2=set2,set3=set3,set4=set4,set5=set5,set6=set6)

rowmins<-apply(ploty[2:6], 1, FUN=min, na.rm = TRUE)
rowmax<-apply(ploty[2:6], 1, FUN=max, na.rm = TRUE)
rowmean<-apply(ploty[2:6], 1,FUN=mean, na.rm = TRUE)
plotter1<-data.frame(Time=ploty$set1,Cat="Cluster",Minimum=rowmins,Maximum=rowmax,Means=rowmean)

set1<-seq(0,80, by=10)
set2<-(s1_all$V4[ s1_all$rep=="1" & s1_all$strat=="econ"])
set3<-(s1_all$V4[ s1_all$rep=="2" & s1_all$strat=="econ"])
set4<-(s1_all$V4[ s1_all$rep=="3" & s1_all$strat=="econ"])
set5<-(s1_all$V4[ s1_all$rep=="4" & s1_all$strat=="econ"])
set6<-(s1_all$V4[ s1_all$rep=="5" & s1_all$strat=="econ"])
ploty<-data.frame(set1=set1,set2=set2,set3=set3,set4=set4,set5=set5,set6=set6)

rowmins<-apply(ploty[2:6], 1, FUN=min, na.rm = TRUE)
rowmax<-apply(ploty[2:6], 1, FUN=max, na.rm = TRUE)
rowmean<-apply(ploty[2:6], 1,FUN=mean, na.rm = TRUE)
plotter2<-data.frame(Time=ploty$set1,Cat="Economic",Minimum=rowmins,Maximum=rowmax,Means=rowmean)

set1<-seq(0,80, by=10)
set2<-(s1_all$V4[ s1_all$rep=="1" & s1_all$strat=="geo"])
set3<-(s1_all$V4[ s1_all$rep=="2" & s1_all$strat=="geo"])
set4<-(s1_all$V4[ s1_all$rep=="3" & s1_all$strat=="geo"])
set5<-(s1_all$V4[ s1_all$rep=="4" & s1_all$strat=="geo"])
set6<-(s1_all$V4[ s1_all$rep=="5" & s1_all$strat=="geo"])
length(set4)<-9
ploty<-data.frame(set1=set1,set2=set2,set3=set3,set4=set4,set5=set5,set6=set6)

rowmins<-apply(ploty[2:6], 1, FUN=min, na.rm = TRUE)
rowmax<-apply(ploty[2:6], 1, FUN=max, na.rm = TRUE)
rowmean<-apply(ploty[2:6], 1,FUN=mean, na.rm = TRUE)
plotter3<-data.frame(Time=ploty$set1,Cat="Geodiversity",Minimum=rowmins,Maximum=rowmax,Means=rowmean)

set1<-seq(0,80, by=10)
set2<-(s1_all$V4[ s1_all$rep=="1" & s1_all$strat=="rand"])
set3<-(s1_all$V4[ s1_all$rep=="2" & s1_all$strat=="rand"])
set4<-(s1_all$V4[ s1_all$rep=="3" & s1_all$strat=="rand"])
set5<-(s1_all$V4[ s1_all$rep=="4" & s1_all$strat=="rand"])
set6<-(s1_all$V4[ s1_all$rep=="5" & s1_all$strat=="rand"])
ploty<-data.frame(set1=set1,set2=set2,set3=set3,set4=set4,set5=set5,set6=set6)

rowmins<-apply(ploty[2:6], 1, FUN=min, na.rm = TRUE)
rowmax<-apply(ploty[2:6], 1, FUN=max, na.rm = TRUE)
rowmean<-apply(ploty[2:6], 1,FUN=mean, na.rm = TRUE)
plotter4<-data.frame(Time=ploty$set1,Cat="Opportunistic",Minimum=rowmins,Maximum=rowmax,Means=rowmean)

plotter<-rbind(plotter1,plotter2,plotter3,plotter4)
#return(plotter)


c1s_plot <- ggplot(plotter1) +
  theme(axis.text=element_text(size=14), axis.title=element_text(size=18), panel.border = element_rect(colour = "black", fill=NA, size=2)) +
  theme(plot.title = element_text(size = 22, face = "bold")) +
  geom_line(aes(Time, Means, group=Cat,color=Cat), size=2.0) +
  geom_ribbon(aes(x=Time,ymin=Minimum,ymax=Maximum, group=Cat,color=Cat, fill=Cat), alpha = 0.2) +
  scale_fill_manual(values="deeppink4") +
  scale_color_manual(values="deeppink4") +
  ggtitle("Cluster- 1000m specialist") +
  theme(legend.position = "none") +
  theme(axis.text.x = element_blank(),
        axis.text.y = element_text(color="black", 
                                   size=14, angle=0),
        axis.title.x = element_blank(),
        axis.title.y = element_blank()) +
  ylim(0,50000)


##############################percentage table
clusters1_EC <- clusters1_EC[,5:6]
clusters1_EC_n<- ddply(clusters1_EC,"time",colMeans)
econs1_EC <- econs1_EC[,5:6]
econs1_EC_n<- ddply(econs1_EC,"time",colMeans)
geos1_EC <- geos1_EC[,5:6]
geos1_EC_n<- ddply(geos1_EC,"time",colMeans)
rands1_EC <- rands1_EC[,5:6]
rands1_EC_n<- ddply(rands1_EC,"time",colMeans)

c5s_EC <- c5s_EC[,5:6]
c5s_EC_n<- ddply(c5s_EC,"time",colMeans)
e5s_EC <- e5s_EC[,5:6]
e5s_EC_n<- ddply(e5s_EC,"time",colMeans)
g5s_EC <- g5s_EC[,5:6]
g5s_EC_n<- ddply(g5s_EC,"time",colMeans)
r5s_EC <- r5s_EC[,5:6]
r5s_EC_n<- ddply(r5s_EC,"time",colMeans)

clusterg1_EC <- clusterg1_EC[,5:6]
clusterg1_EC_n<- ddply(clusterg1_EC,"time",colMeans)
econg1_EC <- econg1_EC[,5:6]
econg1_EC_n<- ddply(econg1_EC,"time",colMeans)
geog1_EC <- geog1_EC[,5:6]
geog1_EC_n<- ddply(geog1_EC,"time",colMeans)
randg1_EC <- randg1_EC[,5:6]
randg1_EC_n<- ddply(randg1_EC,"time",colMeans)

clusterg5_EC <- clusterg5_EC[,5:6]
clusterg5_EC_n<- ddply(clusterg5_EC,"time",colMeans)
econg5_EC <- econg5_EC[,5:6]
econg5_EC_n<- ddply(econg5_EC,"time",colMeans)
geog5_EC <- geog5_EC[,5:6]
geog5_EC_n<- ddply(geog5_EC,"time",colMeans)
randg5_EC <- randg5_EC[,5:6]
randg5_EC_n<- ddply(randg5_EC,"time",colMeans)


clusters1_diff <- clusters1_EC_n %>%
  #mutate(Precent_diff = 100 * (V5 - first(V5))/first(V5)) %>%
  mutate(pct_change = (V5/first(V5)) * 100) %>%
  mutate(Difference = V5 - first(V5))

clusters5_diff <- c5s_EC_n %>%
  #mutate(Precent_diff = 100 * (V5 - first(V5))/first(V5)) %>%
  mutate(pct_change = (V5/first(V5)) * 100) %>%
  mutate(Difference = V5 - first(V5))

clusterg1_diff <- clusterg1_EC_n %>%
  #mutate(Precent_diff = 100 * (V5 - first(V5))/first(V5)) %>%
  mutate(pct_change = (V5/first(V5)) * 100) %>%
  mutate(Difference = V5 - first(V5))

clusterg5_diff <- clusterg5_EC_n %>%
  #mutate(Precent_diff = 100 * (V5 - first(V5))/first(V5)) %>%
  mutate(pct_change = (V5/first(V5)) * 100) %>%
  mutate(Difference = V5 - first(V5))

econs1_diff <- econs1_EC_n %>%
  #mutate(Precent_diff = 100 * (V5 - first(V5))/first(V5)) %>%
  mutate(pct_change = (V5/first(V5)) * 100) %>%
  mutate(Difference = V5 - first(V5))

econs5_diff <- e5s_EC_n %>%
  #mutate(Precent_diff = 100 * (V5 - first(V5))/first(V5)) %>%
  mutate(pct_change = (V5/first(V5)) * 100) %>%
  mutate(Difference = V5 - first(V5))

econg1_diff <- econg1_EC_n %>%
  #mutate(Precent_diff = 100 * (V5 - first(V5))/first(V5)) %>%
  mutate(pct_change = (V5/first(V5)) * 100) %>%
  mutate(Difference = V5 - first(V5))

econg5_diff <- econg5_EC_n %>%
  #mutate(Precent_diff = 100 * (V5 - first(V5))/first(V5)) %>%
  mutate(pct_change = (V5/first(V5)) * 100) %>%
  mutate(Difference = V5 - first(V5))

geos1_diff <- geos1_EC_n %>%
  #mutate(Precent_diff = 100 * (V5 - first(V5))/first(V5)) %>%
  mutate(pct_change = (V5/first(V5)) * 100) %>%
  mutate(Difference = V5 - first(V5))

geos5_diff <- g5s_EC_n %>%
  #mutate(Precent_diff = 100 * (V5 - first(V5))/first(V5)) %>%
  mutate(pct_change = (V5/first(V5)) * 100) %>%
  mutate(Difference = V5 - first(V5))

geog1_diff <- geog1_EC_n %>%
  #mutate(Precent_diff = 100 * (V5 - first(V5))/first(V5)) %>%
  mutate(pct_change = (V5/first(V5)) * 100) %>%
  mutate(Difference = V5 - first(V5))

geog5_diff <- geog5_EC_n %>%
  #mutate(Precent_diff = 100 * (V5 - first(V5))/first(V5)) %>%
  mutate(pct_change = (V5/first(V5)) * 100) %>%
  mutate(Difference = V5 - first(V5))

rands1_diff <- rands1_EC_n %>%
  #mutate(Precent_diff = 100 * (V5 - first(V5))/first(V5)) %>%
  mutate(pct_change = (V5/first(V5)) * 100) %>%
  mutate(Difference = V5 - first(V5))

rands5_diff <- r5s_EC_n %>%
  #mutate(Precent_diff = 100 * (V5 - first(V5))/first(V5)) %>%
  mutate(pct_change = (V5/first(V5)) * 100) %>%
  mutate(Difference = V5 - first(V5))

randg1_diff <- randg1_EC_n %>%
  #mutate(Precent_diff = 100 * (V5 - first(V5))/first(V5)) %>%
  mutate(pct_change = (V5/first(V5)) * 100) %>%
  mutate(Difference = V5 - first(V5))

randg5_diff <- randg5_EC_n %>%
  #mutate(Precent_diff = 100 * (V5 - first(V5))/first(V5)) %>%
  mutate(pct_change = (V5/first(V5)) * 100) %>%
  mutate(Difference = V5 - first(V5))

cluster_diff <- cbind(clusters1_diff, clusters5_diff, clusterg1_diff, clusterg5_diff)
econ_diff <- cbind(econs1_diff, econs5_diff, econg1_diff, econg5_diff)
geo_diff <- cbind(geos1_diff, geos5_diff, geog1_diff, geog5_diff)
rand_diff <- cbind(rands1_diff, rands5_diff, randg1_diff, randg5_diff)
