library(plyr)
library(dplyr)
library(sp)
library(raster); options(scipen=999) # scipen removes scientific notation from FIA data
library(rgdal)
library(plyr) #This removes scientific notation in printing. Plot CNs are very long
###Set overall drive qirh folder
wdir<-"R:/fer/rschell/Mozelewski/Tinas_Growth_Curves/"
setwd(wdir)

###Read in state tree files
NC_TREE <- read.csv(paste(wdir,"Inputs/NC_TREE.csv",sep="")) [,c('PLT_CN','INVYR','DIA','SPCD','CARBON_AG','TPA_UNADJ','TPAGROW_UNADJ','HT',"PLOT","SUBP","TREE")]#load NC_Tree table
SC_TREE <- read.csv(paste(wdir,"Inputs/SC_TREE.csv",sep=""))[,c('PLT_CN','INVYR','DIA','SPCD','CARBON_AG','TPA_UNADJ','TPAGROW_UNADJ','HT',"PLOT","SUBP","TREE")] #load SC_Tree table
VA_TREE <- read.csv(paste(wdir,"Inputs/VA_TREE.csv",sep=""))[,c('PLT_CN','INVYR','DIA','SPCD','CARBON_AG','TPA_UNADJ','TPAGROW_UNADJ','HT',"PLOT","SUBP","TREE")]  #load VA_Tree table

##Combine
tree_data_all<- rbind(NC_TREE, SC_TREE, VA_TREE) 

length(unique(tree_data_all$PLT_CN))
###
tree_data_all<-tree_data_all[!is.na(tree_data_all),]

#Have to remove the trees that don't have height.  We need height to estimate age.
tree_data_HT<-subset(tree_data_all,tree_data_all[,'HT']>0)
###Clearspace
rm(NC_TREE,SC_TREE,VA_TREE,tree_data_all)
##Backup
write.csv(tree_data_HT,paste(wdir,"Tree_data_Ht.csv",sep=""))


#Only use the data from the years Ty used to create the map we are using.  Only use specific plots and years.
years<-seq(1998,2008,by=1)
tree_data_SelectYears <- tree_data_HT[tree_data_HT$INVYR %in% years,] 


###get unique plots
PLT_CN_unique_trees<-unique(tree_data_SelectYears[,"PLT_CN"])
print(length(PLT_CN_unique_trees))


###Read in species you want to look at
spp_file<-read.csv(paste(wdir,"Inputs/SpeciesLUT.csv",sep=""))
spp<-spp_file[,"Species"]
number_of_species<-length(spp)
###subset species
tree_data_SelectSpp <- tree_data_SelectYears[tree_data_SelectYears$SPCD %in% spp,]
PLT_CN_unique_spp_vector<-(unique(tree_data_SelectSpp$PLT_CN))
print(length(PLT_CN_unique_spp_vector))

#rm(tree_data_SelectPlots, tree_data_SelectYears)

#Read in all the COND table csv files from FIA.  You need these to get stand age and site index.
COND_NC<-read.csv(paste(wdir,"Inputs/NC_COND.csv",sep=""))
COND_SC<-read.csv(paste(wdir,"Inputs/SC_COND.csv",sep=""))
COND_VA<-read.csv(paste(wdir,"Inputs/VA_COND.csv",sep=""))
COND_all<-rbind(COND_NC, COND_SC,COND_VA)
COND_only_years <- COND_all[COND_all$INVYR %in% years,]
print(nrow(COND_only_years))

#Remove plots that are not forested.  COND class 1 is forested.
COND_only_forests <- subset(COND_only_years, COND_only_years$COND_STATUS_CD==1) 
print(nrow(COND_only_forests))

#Double-check to see how many PLT_CNs we lost in COND table.
unique_PLTCN_COND<-length(unique(COND_only_years$PLT_CN))
print(unique_PLTCN_COND)

check<-(tree_data_SelectSpp$PLT_CN %in%  unique_PLTCN_COND)

#########################
#Use this to fill in the missing data, i.e. avg site index for entire landscape.
ForestwithIndex<-COND_only_forests[!is.na(COND_only_forests$SICOND),]
average_Site_Condition<-round(mean(ForestwithIndex$SICOND), digits=)

###########################################
#Use this to calculate the average stand age and site index and fill in any missing data.

COND_matrix<-NULL
for (z in PLT_CN_unique_trees){#for each PLT_CN
  print(z)
  each_plot_subset <- subset(COND_only_forests, COND_only_forests[,"PLT_CN"] == z)
  number_plots<-nrow(each_plot_subset)
  stand_age_mean <- mean(each_plot_subset$STDAGE) #summing across cohort
  site_index_avg <- mean(each_plot_subset$SICOND) #summing across cohort
  if (number_plots==0){
    site_index_mean<-average_Site_Condition
  } else {
    site_index_mean<-site_index_avg
  }
  plot_matrix <- cbind(z, stand_age_mean, site_index_mean)
  colnames(plot_matrix)<-c("PLT_CN", "STDAGE_mean", "SICOND_mean")
  COND_matrix <- rbind(COND_matrix, plot_matrix)
}

COND_matrix<-as.data.frame(COND_matrix)
print(nrow(COND_matrix))
COND_matrix[,3][is.na(COND_matrix[,3])]<-average_Site_Condition


#Merge tree database and Condition Table database
Merged_Tree_Cond<-merge(tree_data_SelectSpp, COND_matrix, "PLT_CN", by.y="PLT_CN")
Merged_NAs_Trees<-Merged_Tree_Cond[!complete.cases(Merged_Tree_Cond),]

#Double-check to see how many PLT_CNs we lost.
unique_PLTCN_end_COND<-length(unique(COND_matrix$PLT_CN))
#print("unique PLT_CNs was originally 279,055")
print(unique_PLTCN_end_COND)
print(length(PLT_CN_unique_spp_vector))
#Clear out memory before proceeding
rm(COND_all, COND_only_years, COND_only_forests, COND_matrix, COND_NC, COND_SC, COND_VA) 


tree_data_final<-subset(Merged_Tree_Cond,Merged_Tree_Cond[,"CARBON_AG"]>0) #& dta_all_sp[,"DIA"] > 0 
#rm(TREEtbl_all,NC_TREE,SC_TREE,VA_TREE)


#Double-check to see how many PLT_CNs we lost in the merge.
No_Biomass<-tree_data_final[!complete.cases(tree_data_final),]
unique(No_Biomass$PLT_CN)
length(unique(tree_data_final$PLT_CN))



###########################
#This is the loop to calculate age of all the trees.
roundUp <- function(x) 10*ceiling(x/10)   #Need to round the age to a multiple of 10.

age_added_matrix<-NULL#This will become new matrix with age added to matrix
for (each_tree in 1:nrow(tree_data_final)){#For every tree in the forested FIA plots in the state (which one is dependent on input file
  print(each_tree)
  #print(dta_27_spp[each_tree,"each tree"])
  tree<-tree_data_final[each_tree,] #unique tree
  Plot<-tree["PLT_CN"]#Diameter (inches)
  H<-tree["HT"]#Height (ft)
  SIndex<-tree["SICOND_mean"]#Site index
  species<-tree["SPCD"]#species numeric code
  
  for (look in 1:nrow(spp_file)){
    #for every species in look up table
    sp_look<-spp_file[look,"Species"] #unique species number (from lookup table)
    if (sp_look==species){
      
      #age_matrix<-NULL
      #If lookup table species code is equal to tree species code, then...
      name<-(spp_file[look,"X"])#coefficient for b1
      final_spp_code<-(spp_file[look,"Species"])#coefficient for b1
      coef_b1<-(spp_file[look,"b1"])#coefficient for b1
      coef_b2<-(spp_file[look,"b2"])#coeffcient for b2
      coef_b3<-(spp_file[look,"b3"])#coeffcient for b3
      coef_b4<-(spp_file[look,"b4"])#coeffcient for b4
      coef_b5<-(spp_file[look,"b5"])#coeffcient for b5
      longevity<-(spp_file[look,"Longevity"])#longevity values
      if(H <= (coef_b1*SIndex^(coef_b2))) {
        age<-(log (1-(H/(coef_b1 * SIndex^(coef_b2)))^(1/(coef_b4*(SIndex^(coef_b5)))))/coef_b3)
      }
      else {age<-(log (1-(((coef_b1*SIndex^(coef_b2))-1)/(coef_b1 * SIndex^(coef_b2)))^(1/(coef_b4*(SIndex^(coef_b5)))))/coef_b3)
      }
      age<-as.matrix(age)
      colnames(age)<-c("age")
      
      age_rounded10_uncorrected <- roundUp(age)
      H
      (coef_b1*SIndex^(coef_b2))
      #age_rounded10<-round(age, digits=-1)
      
      if(age_rounded10_uncorrected > longevity) {
        age_rounded10<-longevity
      }
      else {age_rounded10<-age_rounded10_uncorrected
      }
      age_rounded10<-as.matrix(age_rounded10)
      colnames(age_rounded10)<-c("age_rounded10")
      
    } #closes loop around if statement for selected species.
    #colnames(age_matrix)<-c("calc_age", "calc_age_rounded")
  } #closes loop around lookup table
  age_added_to_tree<-cbind.data.frame(tree, name, final_spp_code, age, age_rounded10) 
  #colnames(age_added_to_tree)<-c("CommonName", "Final_spp_Code", "calc_age", "calc_age_rounded")
  age_added_matrix<-rbind(age_added_matrix,age_added_to_tree)#row bind tree with calc_age to next row.  This is final matrix
}

age_added_matrix[age_added_matrix$SPCD=="131",]


print("Done with Final age matrix")
length(unique(age_added_matrix$PLT_CN))
colnames(age_added_matrix)<-c(colnames(tree), "CommonName", "Final_spp_Code", "calc_age", "calc_age_rounded")

write.csv(age_added_matrix,(paste(wdir,"TM_StudyExtent_FIA_AGE_TREE_HT.csv",sep="")))



###The Output from IC 2 Get Age
AgeGraphs<-read.csv(paste(wdir,"TM_StudyExtent_FIA_AGE_TREE_HT.csv",sep=""))
unique(AgeGraphs$calc_age_rounded)
Plts<-unique(AgeGraphs$PLT_CN)

TPA.factor <- 6.018046 #trees/acre adjust (TPA in FIA)
conv.factor <- .112085 #Convert from lbs/acre to g/m-2



###make carbon unitts align with LANDIS-II
AgeGraphs$AdjCarbon<-AgeGraphs$CARBON_AG*AgeGraphs$TPA_UNADJ*conv.factor
output<-NULL


###This loop aggregates the carbon for each species and age at a plot 
for(i in 1:length(Plts)){
One<-as.data.frame(AgeGraphs[AgeGraphs$PLT_CN==Plts[i],])
plt<-Plts[i]
IC<-aggregate(round(One$AdjCarbon),by=list(SPCD=One$SPCD,AGE=as.numeric(One$calc_age_rounded)),FUN=sum)
IC$PLT_CN<-plt
colnames(IC)<-c("SPCD","AGE","AboveGround Carbon","PLT_CN")
output<-rbind(IC,output)
}

uni.sp<-unique(output$SPCD)
output<-output[output$`AboveGround Carbon`>0,]
###Save 
write.csv(output,"FIA_Height_Sorted.csv")

###reload
output<-read.csv(paste("FIA_Height_Sorted.csv",sep=""))
####Read in your lookuptable
SPLUT<-read.csv(paste("Inputs/SpeciesLUT.csv",sep=""))
uniquesp<-SPLUT[,2]
###Enter Species here
#i= 16
i = 711
print(i)

#my addition to remove na's from output
new_output <- na.omit(output)

Name=SPLUT$LANDIS_CODE[SPLUT$Species==i]
IC<-new_output[new_output$SPCD==i,]
print("Species")
print(i)
Speciesname<-as.character(SPLUT[,13][SPLUT[,2]==i])
out<-NULL

IC[!complete.cases(IC),]




###This gets rid of very high outliers, and sub samples the population to the top 25 per age based on carbon,
###This discounts smaller and plots facing greater competition.
if(length(IC$AGE)>100) {
  uniqueage<-unique(IC$AGE)
  IC<-IC[IC$AboveGround.Carbon< quantile(IC$AboveGround.Carbon,probs=.99),]
  for(t in uniqueage){
    agebreak<-IC[IC$AGE==t,]
    agebreak<-agebreak[agebreak$AboveGround.Carbon> quantile(agebreak$AboveGround.Carbon,probs=.75),]
    out<-rbind(agebreak,out) 
  }
}
if(!is.null(out)){
  IC<-out
}

###plot it to see loblolly
x<-as.single(IC$AGE)
y<-as.single(2*IC$AboveGround.Carbon)
ploty<-as.data.frame(cbind(x,y))
max_y<-max(y)
#boxplot(ploty[,2]~ploty[,1],main=(paste(Name,"n=",length(IC$AGE))),col=terrain.colors(1),xlab="Year",ylab="AGB g/m2",range=1.0,ylim=c(10,max_y),xlim=c(0,20),xlab="Age",ylab="Carbon g/m2",pch = 16,cex.main=2.0,cex.lab=1.5,cex.axis=1.2,font=2)
boxplot(ploty[,2]~ploty[,1],main=(paste(Name,"n=",length(IC$AGE))),col=terrain.colors(1),xlab="Year",ylab="AGB g/m2",range=1.0,ylim=c(10,2000),xlim=c(0,20),xlab="Age",ylab="Carbon g/m2",pch = 16,cex.main=2.0,cex.lab=1.5,cex.axis=1.2,font=2)
NECN_succession_log_loblolly<-read.csv("NECN_succession_log_loblolly.csv") 
#NECN_succession_log_vpine<-read.csv("NECN_succession_log_vpine.csv") GOOD TO GO
#NECN_succession_log_redmaple<-read.csv("NECN_succession_log_redmaple.csv") Good TO GO
#NECN_succession_log_toak<-read.csv("NECN_succession_log_toak.csv") GOOD TO GO
#NECN_succession_log_wtoak<-read.csv("NECN_succession_log_wtoak.csv") GOOD TO GO
#NECN_succession_log_longleaf<-read.csv("NECN_succession_log_longleaf.csv")
lines(NECN_succession_log_loblolly$AGB,x=as.numeric(ordered(round(NECN_succession_log_loblolly$Time))),col="red",lwd=3.0) 



#legend(11,max_y+100,legend=c("Clay 10% Sand 90%","Clay 20% Sand 40%","Clay20% Sand10%"),col=c("red","blue","green"),lty=c(1,1,1),lwd=3.0)


###Plot it for record
filename<-paste(FileWrite,"/GrowthCurves.jpeg",sep="")
jpeg(file = filename, bg = "transparent")
#boxplot(ploty[,2]~ploty[,1],main=(paste(Name,"n=",length(IC$AGE))),col=terrain.colors(1),xlab="Year",ylab="AGB g/m2",range=1.0,ylim=c(10,max_y),xlim=c(0,20),xlab="Age",ylab="Carbon g/m2",pch = 16,cex.main=2.0,cex.lab=1.5,cex.axis=1.2,font=2)
boxplot(ploty[,2]~ploty[,1],main=(paste(Name,"n=",length(IC$AGE))),col=terrain.colors(1),xlab="Year",ylab="AGB g/m2",range=1.0,ylim=c(10,max_y),xlim=c(0,20),xlab="Age",ylab="Carbon g/m2",pch = 16,cex.main=2.0,cex.lab=1.5,cex.axis=1.2,font=2)
lines(NECNxyShort1$AGB,x=as.numeric(ordered(round(NECNxyShort1$Time))),col="red",lwd=3.0) 


#lines(NECNxyShort2$AGB,x=as.numeric(ordered(round(NECNxyShort2$Time))),col="blue",lwd=3.0) 
#lines(NECNxyShort3$AGB,x=as.numeric(ordered(round(NECNxyShort3$Time))),col="green",lwd=3.0)
#legend(11,max_y+100,legend=c("Clay 10% Sand 90%","Clay 20% Sand 40%","Clay20% Sand10%"),col=c("red","blue","green"),lty=c(1,1,1),lwd=3.0,bg="white")
#dev.off()         
