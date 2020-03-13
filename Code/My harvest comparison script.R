library(raster)
dta_all<-read.csv("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_landscape_basic_Sor_1/harvest/biomass-harvest-summary-log.csv")
dta<-dta_all[1:4]#just the number of cells harvested per timestep, management area, and prescription
prsc<-dta["Prescription"]#prescription data
Uprsc<-unique(prsc)#matrix of unique prescriptions.
time<-dta["Time"]#time step data
u_time<-unique(time)#unique time steps
management_area<-dta["ManagementArea"]#management area data.
u_MA<-unique(management_area)#unique management areas
ma_name<-c("Family", "Corporate", "Fed", "Other")#management area names.
m_cols<-rainbow(nrow(u_MA))#colors for managemeent areas

ra<-raster("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_landscape_basic_Sor_1/MgmtMap11.tif")#raster file of management areas
#plot(ra)
mg_num<-freq(ra)#attribute table of management areas.
targets<-read.csv("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_landscape_basic_Sor_1/Harvest_targets.csv")#target rotation periods that feed into biomass-harvest implementaton table

par(mfrow = c(3,3))
par(new=F)#new plot

#prescription_name<-as.vector(Uprsc[,1])#specific prescription name
mgma_2<-subset(dta, ManagementArea == "2")#all the harvested data for Mgmt Area 2.
mgma_7<-subset(dta, ManagementArea == "7")#all the harvested data for Mgmt Area 7
mgma_6<-subset(dta, ManagementArea == "6")#all the harvested data for Mgmt Area 6
mgma_5<-subset(dta, ManagementArea == "5")#all the harvested data for Mgmt Area 5

mgma_5L<-dta[dta$ManagementArea=="5"& dta$Prescription == " LoblollyClearcut",]
mgma_5f<-dta[dta$ManagementArea=="5"& dta$Prescription == " FamilyMixedForest",]

targets_2<-subset(targets, ma == "2")#all the harvested data for Mgmt Area 2.
targets_7<-subset(targets, ma == "7")#all the harvested data for Mgmt Area 7

 
par(new=F)#start new plot.
plot(1, type="n", axes=F, xlab="", ylab="")#empty plot for legend.
legend("bottomleft",legend=ma_name,col=m_cols,cex=2., lwd=1, inset=(0.001), bty="n",pch = 16)