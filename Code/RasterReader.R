library(sp)
library(raster); options(scipen=999) # scipen removes scientific notation from FIA data
library(rgdal)
library(plyr)
library(dplyr)
####Need to mesh with FIA files on DIA Plot Cn/Sp_Code,"DIA'

###Need to apply expansion fact to determine the biomass from the landscape<--These are Carbon_AG, TPA_Growth. 

###Set up
wdir<-c("C:/Users/zjrobbin/Desktop/DOD_FtBragg/")
setwd(wdir)
##Read in Data From I_C File
Plotdata<-read.csv(paste(wdir,"Ft_Bragg_df_matched.csv",sep=""))
L_plotsonmap<-Plotdata[,14]
####Unique Plots
ICcount<-unique(Plotdata$columnofsites)

print(ICcount)

###This has our raster number and our 
mapjoin<-as.data.frame(cbind(Plotdata$leni,Plotdata$columnofsites))
NC_TREE <- read.csv(paste(wdir,"/NC_TREE.csv",sep=""))[,c('PLT_CN','DIA','SPCD','CARBON_AG','TPAGROW_UNADJ','HT')] #load NC_Tree table
SC_TREE <- read.csv(paste(wdir,"/SC_TREE.csv",sep=""))[,c('PLT_CN','DIA','SPCD','CARBON_AG','TPAGROW_UNADJ','HT')]#load SC_Tree table
VA_TREE <- read.csv(paste(wdir,"/VA_TREE.csv",sep=""))[,c('PLT_CN','DIA','SPCD','CARBON_AG','TPAGROW_UNADJ','HT')]#load VA_Tree table


AllTrees<-rbind(NC_TREE,SC_TREE,VA_TREE)
tree_data <- AllTrees[AllTrees$PLT_CN %in% L_plotsonmap,]
print(length(unique(tree_data$PLT_CN)))
print(length(ICcount))






Hypo_IC<-





###Load Formatted Raster
ExampleRaster<-raster(paste(wdir,"/s110_Clip1.img",sep=""))
proj<-projection(ExampleRaster)
codes_out_unlist <- as.numeric(unlist(Plotdata$columnofsites)) #unlist the attribute table so that the next step will become a double matrix.
output_matrix<-matrix(codes_out_unlist,nrow=nrow(ExampleRaster),ncol=ncol(ExampleRaster),byrow=T) #fir

new_output_raster<-raster(output_matrix,xmn=xmin(ExampleRaster),ymn=ymin(ExampleRaster),xmx=xmax(ExampleRaster),ymx=ymax(ExampleRaster), crs=proj)#build new raster file with projection assigned
res(new_output_raster) <- 250.0  
plot(new_)

new_output_raster<-raster(x=Plots,crs=proj)#build new raster file with projection assigned
res(new_output_raster) <- 250.0  #assign cell resolution
new_output_file_name<-paste(wdir,"FtBragg_Plots.img",sep="")
plot(new_output_raster)
rast_IC_map<-writeRaster(new_output_raster, filename=new_output_file_name, datatype='FLT4S',overwrite=TRUE)#This will write a raster that should line up correctly with your input raster

print("done")

