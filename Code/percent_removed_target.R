##This script graphs percent of area harvested by prescription compared to target harvest rotation. 
##Matthew Duveneck 8/17/2012 

library(raster)
dta_all<-read.csv("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_landscape_basic_Sor_1/harvest/biomass-harvest-summary-log.csv")
dta<-dta_all[1:4]#just the number of cells harvested per timestep, managmenet area, and prescription
prsc<-dta["Prescription"]#prescription data
Uprsc<-unique(prsc)#matrix of unique prescriptions.
time<-dta["Time"]#time step data
u_time<-unique(time)#unique time steps
management_area<-dta["ManagementArea"]#management area data.
u_MA<-unique(management_area)#unique management areas
ma_name<-c("Family", "Corporate", "Fed", "Other")#management area names.
m_cols<-rainbow(nrow(u_MA))#colors for managemeent areas

ra<-raster("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_landscape_basic_Sor_1/MgmtMap11.tif")#raster file of management areas
plot(ra)
mg_num<-freq(ra)#attribute table of management areas.
targets<-read.csv("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_landscape_basic_Sor_1/Harvest_targets.csv")#target rotation periods that feed into biomass-harvest implementaton table

### I need to subset by management area, and then compare harvested cells (each a hectare) to expected hectares harvested!!!!!!!!!!

par(mfrow = c(3,3))
for (i in 1:nrow(Uprsc)){#for each prescription
  par(new=F)#new plot
  prescription_name<-as.vector(Uprsc[i,])#specific prescription name
  prescrip_data<-subset(dta,dta["Prescription"]==prescription_name)#all the harvested data for specific prescription.
  subset_target_rx<-subset(targets,targets["presc"]==prescription_name)#all the target data for specific prescriptions.
  
  for (j in 1:nrow(u_MA)){#for each management areas within unique prescription.
    man_area_cells<-subset(mg_num,mg_num[,1]==j)#subset management area attibute table by specific managmeent area.
    owner_count<-man_area_cells[,2]#number of cells within specific management area.
    harvested<-subset(prescrip_data,prescrip_data["ManagementArea"]==j)#subset harvested data for specific MA within specific RX.
    sites_harv_time_row<-NULL#clear old data  
    proportion_matrix<-NULL#clear old data
    
    for (k in 1:nrow(u_time)){#for each time steps
      time_step<-u_time[k,]#time step (e.g. 5:150)
      sites_harv_time_row<-subset(harvested,harvested$Time==time_step)#harvested data for specific time step.  Can be length=0.
      sites_harv_time<-sites_harv_time_row$HarvestedSites#sites harvested for specific time step.  Can be length=0.
      if(length(sites_harv_time)==0){sites_harv_time<-0}#if length("sites_harv_time")=0, then make 0.
      proportion_harvested<-sites_harv_time/owner_count*100#percent of ma cells harvested. 
      time_proportion<-cbind(time_step,proportion_harvested)#bind time step with percent harvested.
      proportion_matrix<-rbind(proportion_matrix,time_proportion)#make matrix of all time steps, 
    }
    
    subset_target_own<-subset(subset_target_rx,subset_target_rx$ma==j)#subset of target by MA and rx.
    adjusted_target<-rep(subset_target_own[1,"adj_target_percent"],nrow(u_time))# repeat target percent by number of time steps.
    time_proportion_harv<-cbind(proportion_matrix,adjusted_target)#bind target and harvested columns with timestep
    #year<-time_proportion_harv[,1]+2000#make timesteps = simulation year.
    #hrv_pl<-time_proportion_harv[,2]#column to use for plotting harvested percent.
    #tr_pl<-time_proportion_harv[,3]#column to use for target percent.
    #target_ylim<-max(subset_target_rx$adj_target_percent)#maximum value for y axis.
    #plot(hrv_pl~year, ylim=c(0,max(target_ylim)), main=c(prescription_name), col=m_cols[j], pch=16)#plot harvested cells.
    #lines(year,tr_pl, col=m_cols[j])#plot target rotation
    #par(new=T)#keep points/lines in same plot.
  }
}

par(new=F)#start new plot.
plot(1, type="n", axes=F, xlab="", ylab="")#empty plot for legend.
legend("bottomleft",legend=ma_name,col=m_cols,cex=2., lwd=1, inset=(0.001), bty="n",pch = 16)