AgeGraphs<-read.csv("C:/Users/tgmozele/Desktop/TREE_tbls/Sorenson's_FIA_AGE_TREE_HT_5_6.csv")
AgeGraphs$BA <- AgeGraphs$DIA^2 * 0.005454
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

###This is the outpput of the sorrensons association
Crosswalk<-read.csv("C:/Users/tgmozele/Desktop/TREE_tbls/NSS_6_3.csv")[,c("cell","Closestplot")]
colnames(Crosswalk)<-c("cell","PLT_CN")
CrosswalkDF <- as.data.frame(Crosswalk)

CellswithValues<-join(CrosswalkDF, outputDF, by ="PLT_CN")

#CellswithValues[is.na(CellswithValues)]<-0
LANDIS_BA <- na.omit(CellswithValues)
Print<-LANDIS_BA[order(LANDIS_BA$Cell),]
