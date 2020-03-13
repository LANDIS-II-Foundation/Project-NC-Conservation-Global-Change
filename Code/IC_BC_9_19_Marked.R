
####ZR and TM Bray Curtis analysis of Ft. Bragg for initial communities in LANDIS-II
####Sept 2018

####Set up main work drives
w_dir<-"C:/Users/zacha/Desktop/DOD_FtBragg/"
setwd(w_dir)


###
###This section converts and structures the FIA data for comparison with the Ty wilson maps####
###

####Load in FIA tree data tables
NC_TREE <- read.csv(paste(w_dir,"/Inputs/NC_TREE.csv",sep="")) #load NC_Tree table
SC_TREE <- read.csv(paste(w_dir,"/Inputs/SC_TREE.csv",sep="")) #load SC_Tree table
VA_TREE <- read.csv(paste(w_dir,"/Inputs/VA_TREE.csv",sep=""))  #load VA_Tree table
#Years of intrest, must be selected because we will auto filter to one round of plots#
years<-c(2007:2017)
###Bind All datasets together
TREEtbl_all<-NULL
TREEtbl_all <- rbind(NC_TREE, SC_TREE, VA_TREE) 
##Filter data sets to only years of intrest
TREEtbl_all<-TREEtbl_all[(TREEtbl_all$INVYR %in% years),] #####NEVER FORGET########
####Remove sites without TPA_UNADJ
TREEtbl_all<-(TREEtbl_all[!is.na(TREEtbl_all$TPA_UNADJ),])
###Get the name of the plot numbers
plot_numbers<-TREEtbl_all$CN
###aggregate plots
cn_cnt<-aggregate(TREEtbl_all$CN, by=list(CN=TREEtbl_all$CN),length)
###Remove raw data 

rm(NC_TREE)
rm(SC_TREE)
rm(VA_TREE)





# Bring in species excel file for my species of interest
###This is a LUT table that should have the FIA codes for each speies
spp_file <- read.csv(paste(w_dir,"Inputs/spp_code.csv",sep=""))
spp <- spp_file[,"FIA.code"] # isolate FIA spp codes for my focal species

#Filter data by species of interest
#Ignores other species.
tree_data <- TREEtbl_all[TREEtbl_all$SPCD %in% spp,]


####If tree size is name set to zero
tree_data[is.na(tree_data$DIA),]<-0.0
####Order data in desending DIA size
tree_data<-tree_data[order(-tree_data$DIA),]

###Veiw raw data(deprecated)
#needcolumns<-c(2,14,16)
#tree_data2<-tree_data[,needcolumns]


####Get each unqiue plt_cn
uniquepltcn<-unique(tree_data$PLT_CN)

#### Set a Null output
  Plt_DF<-NULL
  ##This loop turns the DIA data to basal area data (m2/ha) as is presented in Ty wilson's maps 
  for( i in 1:length(uniquepltcn)){
    two<-NULL
    end<-NULL
    ###Pull in one plot
    Plot<-uniquepltcn[i]
    print(i)
    Thisguy<-tree_data[tree_data$PLT_CN==uniquepltcn[i],]
    ####Store each tree by sum of sp on the site and do the conversion using foresters constant, unit conversion
    ## and mulitply it by the TPA_Unadj to account for the area it would cover in a full census
    PIEC2<-sum(((Thisguy$DIA[Thisguy$SPCD==110]^2)*.005454)*Thisguy$TPA_UNADJ[Thisguy$SPCD==110])*.229568
    ####so the Diam is turned to Basal Area, Mutliplied by the expansion as a matrix, these are summed. then
    ###Turned from FT/ACRE to M per hectare#### I checked this for order of operation concerns.
    PIPA2<-sum((((Thisguy$DIA[Thisguy$SPCD==121])^2)*.005454)*Thisguy$TPA_UNADJ[Thisguy$SPCD==121])*.229568
    PITA<-sum((((Thisguy$DIA[Thisguy$SPCD==131])^2)*.005454)*Thisguy$TPA_UNADJ[Thisguy$SPCD==131])*.229568
    PIVI2<-sum((((Thisguy$DIA[Thisguy$SPCD==132])^2)*.005454)*Thisguy$TPA_UNADJ[Thisguy$SPCD==132])*.229568
    ACRU<-sum((((Thisguy$DIA[Thisguy$SPCD==316])^2)*.005454)*Thisguy$TPA_UNADJ[Thisguy$SPCD==316])*.229568
    COLF2<-sum((((Thisguy$DIA[Thisguy$SPCD==491])^2)*.005454)*Thisguy$TPA_UNADJ[Thisguy$SPCD==491])*.229568
    LIST2<-sum((((Thisguy$DIA[Thisguy$SPCD==611])^2)*.005454)*Thisguy$TPA_UNADJ[Thisguy$SPCD==611])*.229568
    LITU<-sum((((Thisguy$DIA[Thisguy$SPCD==621])^2)*.005454)*Thisguy$TPA_UNADJ[Thisguy$SPCD==621])*.229568
    OXAR<-sum((((Thisguy$DIA[Thisguy$SPCD==711])^2)*.005454)*Thisguy$TPA_UNADJ[Thisguy$SPCD==711])*.229568
    QUAL<-sum((((Thisguy$DIA[Thisguy$SPCD==802])^2)*.005454)*Thisguy$TPA_UNADJ[Thisguy$SPCD==802])*.229568
    QULA2<-sum((((Thisguy$DIA[Thisguy$SPCD==819])^2)*.005454)*Thisguy$TPA_UNADJ[Thisguy$SPCD==819])*.229568
    
    
    ###Build output dataframe
    row<-cbind(Plot,PIEC2,PIPA2,PITA,PIVI2,ACRU,COLF2,LIST2,LITU,OXAR,QUAL,QULA2)
    ##row3<-cbind(Plot,Tree1,Dia1,Tree2,Dia2,Tree3,Dia3,Tree4,Dia4,Tree5,Dia5,Tree6,Dia6,Tree7,Dia7,Tree8,Dia8,Tree9,Dia9,Tree10,Dia10,Tree11,Dia11)

    Plt_DF<-rbind(Plt_DF,row)
  }

###Create a column that is the sum BA for each plot, this is needed for Bray-Curtis
Plt_DF_Sums<-rowSums(Plt_DF[,-1])
##Bind it to the dataframe
Plt_DF_2<-as.data.frame(cbind(Plt_DF,Plt_DF_Sums))
##Reorganizing dataframe
Plt_DF_2[,14]<-Plt_DF_2[,1]
Plt_DF_2<-Plt_DF_2[,-1]



#### Now we structure the Ty Wilson maps
####
#### 

####Load in each raster clipped to the area of intrest


clip_110 <- raster(paste(w_dir,"/Inputs/s110_Clip1.img",sep=""))
clip_121 <- raster(paste(w_dir,"/Inputs/s121_Clip1.img",sep=""))
clip_131 <- raster(paste(w_dir,"/Inputs/s131_Clip1.img",sep=""))
clip_132 <- raster(paste(w_dir,"/Inputs/s132_Clip1.img",sep=""))
clip_316 <- raster(paste(w_dir,"/Inputs/s316_Clip1.img",sep=""))
clip_491 <- raster(paste(w_dir,"/Inputs/s491_Clip1.img",sep=""))
clip_611 <- raster(paste(w_dir,"/Inputs/s611_Clip1.img",sep=""))
clip_621 <- raster(paste(w_dir,"/Inputs/s621_Clip1.img",sep=""))
clip_711 <- raster(paste(w_dir,"/Inputs/s711_Clip1.img",sep=""))
clip_802 <- raster(paste(w_dir,"/Inputs/s802_Clip1.img",sep=""))
clip_819 <- raster(paste(w_dir,"/Inputs/s819_Clip1.img",sep=""))




# Stack the rasters
clip_stack <- stack(c(clip_110, clip_121, clip_131, clip_132, clip_316, clip_491, clip_611, 
                      clip_621, clip_711, clip_802, clip_819))

has.data = which(!is.na(getValues(max(clip_stack, na.rm=TRUE))))
###Check the Data
N_hasdata<-length(has.data)
plot(clip_stack)
##Make it a df
clip_stack_df <- as.data.frame(clip_stack)
###Check how many cells are zeros
count1=as.data.frame(rowSums(clip_stack_df[,1:11]))
N_zeros_indataframe<-sum(is.na(count1))
N_zero_and_hasdata<-sum(N_zeros_indataframe,N_hasdata)


####How many rasters did we start with
NumberofRaster<-nrow(clip_stack_df)
print(NumberofRaster)

####Some tests
#plot(clip_110)
#plot(clip_stack)
#test1 <- unique(clip_stack_df)
#head(test1)

# Extract data for each cell of raster stack
cr <- extract(clip_stack, c(1: ncell(clip_stack)))
clip_ras_df <- as.data.frame(cr)

##I think this is all previous attempts (deprecated)
# Turn raster data binary: replace NA with zero, separate into 0 and 1 for presence/absence
##cr[is.na(cr[])] <- 0 # replace NA with zero
#test2 <-as.data.frame(unique(cr)) # test to make sure didn't turn everything to zero
#head(test2)

####The marker works to maintain the position of each cell in case it is moved during transformation
Marker<-as.data.frame(1:nrow(cr))

#cutoff<-(mean(nozero$`new[new != 0]`))/100
#min(nozero)

########Create a threshold for which to remove low proportion trees in this instance we
#####remove anything under 1% landscape representation
cr_bi <- cr
Sum<-rowSums(cr_bi)
cr_bi<-cbind(cr_bi,Sum)
Threshold=.01 ###the threshold of sum basal area for removal
Sumper=Sum*Threshold
cr_bi<-cbind(cr_bi,Sumper)
test1<-cr_bi[224444,]
cr_bi[cr_bi<Sumper]<-0 ###remove less than the proporiton of BA
test2<-cr_bi[224444,]
cr_bi<-as.data.frame(cr_bi[,(-13)])## restructure 
cr_bi<-cbind(cr_bi,Marker)   ##
####Rename columns to species
colnames(cr_bi)<-c("PIEC2","PIPA2","PITA","PIVI2","ACRU","COFL2","LIST2","LITU","OXAR","QUAL","QULA2","Sum","Cell")
####Check that our number of cells still matches
print(nrow(cr_bi))
print(NumberofRaster)
###Isolate all the zero BA cells to increase processing effiecncy
zeros=cr_bi[(cr_bi[,1]==0 &cr_bi[,2]==0&
                   cr_bi[,3]==0&
                   cr_bi[,4]==0&
                   cr_bi[,5]==0&
                   cr_bi[,6]==0&
                   cr_bi[,7]==0&
                   cr_bi[,8]==0&
                   cr_bi[,9]==0&
                   cr_bi[,10]==0&
                   cr_bi[,11]==0),]
###Isolate all the non-zero cells to preform Bray-Curtis on
cr_bi_spp=cr_bi[!(cr_bi[,1]==0 &cr_bi[,2]==0&
                   cr_bi[,3]==0&
                   cr_bi[,4]==0&
                   cr_bi[,5]==0&
                   cr_bi[,6]==0&
                   cr_bi[,7]==0&
                   cr_bi[,8]==0&
                   cr_bi[,9]==0&
                   cr_bi[,10]==0&
                   cr_bi[,11]==0),]
####Check that these two groups add up to the total
print(nrow(zeros)+nrow(cr_bi_spp))
print(NumberofRaster)

#####
#####Preforming Bray-Curtis analysis based on basal area
#####

###Set up null outputs. Here we have the real output and a log file to explore the characteristics of sites that 
###match the characteristics of FIA plots
Log<-NULL
Output<-NULL
row3<-NULL


####preform Bray-Curtis analysis
for(j in 1:nrow(cr_bi_spp)){
  ###loop through each cell
  print(j)
  #####Take one cell
  Isolate_cell<-cr_bi_spp[j,]
  ###Get its marker number
  cell<-Isolate_cell$Cell
  ###remove the totals and marker
  finder1<-Isolate_cell[,c(-12,-13)]
  ###this is the FIA DF
  Sample1<-Plt_DF_2
  ###This is our one cell
  Sample2<-finder1
  DeltaSamples<-NULL
  if(!is.null(nrow(Sample2))){
    ###in the event the cell is not null
    for(i in 1:length(Sample2)){
      ##For each column (species) calculate the abs differnce between the species
      Diff=abs(Sample1[,i]-Sample2[,i])###Sample one is a string, sample 2 a number
      ###Create a data frame where x is each species differnce and y is the plots
      DeltaSamples<-cbind(DeltaSamples,Diff)
    }
    #####This is a list of the sum sample of each site. This is the top half of a Bray-curtis index
    Topside<-rowSums(DeltaSamples)
    ####if for somereason you get a sample with no data(shouldn't be needed now)
  }else if(is.null(nrow(Sample2))){
    Topside<-Sample1-Sample2
  }
  
  #####This is the bottom half of Bary curtis index: the sum of both sites basal area
  Bottomside<-Plt_DF_2$Plt_DF_Sums+Isolate_cell$Sum
  ###the index is the ratio between the two
  index<-Topside/Bottomside
  ####Add the index score to the FIA database
  Plt_indexed<-cbind(Plt_DF_2,index)
  ####Find the plot with the lowest index score(Most similar plot)
  Closestplot<-Plt_indexed$V14[Plt_indexed$index==min(index)]
  ###Calculate the similarity 1-dissimilariy
  indexscore<-max(1.00-(Plt_indexed$index[Plt_indexed$index==min(index)]))
  ####Creat a row with the Cell, its most similar plot and the index score
  row<-cbind(cell,Closestplot,indexscore)    
  ###Create the post loop output
  Output<-rbind(row,Output)
  
  
  ###Now create a log of each species in both those plots for comparison
  ###This is a row for the cell and a row for the plot
  row2<-cbind(j,indexscore,finder1)
  row3<-cbind(j,indexscore,Plt_DF_2[Plt_DF_2$V14==Closestplot[1],])
  ###Make the two rows format the same
  row3<-row3[,c(-14,-15)]
  colnames(row3)<-c("iteration","index","PIEC2","PIPA2","PITA","PIVI2","ACRU","COFL2","LIST2","LITU","OXAR","QUAL","QULA2")
  colnames(row2)<-c("iteration","index","PIEC2","PIPA2","PITA","PIVI2","ACRU","COFL2","LIST2","LITU","OXAR","QUAL","QULA2")
  ###Bind them all together to export the log
  Log<-rbind(Log,row2,row3)
  
}

###Write the initail output to CSV ((Saving measure))
write.csv(Output,"outputs/Bray_Curtis_Output.csv")

####Read it back in
Output<-read.csv(paste(wdir,"outputs/Bray_Curtis_Output.csv",sep=""))

###Some cells may duplicate due to equal index scores. Remove them
NewOutput<-Output[!duplicated(Output$cell),]
###Remove addedd csv index
NewOutput<-NewOutput[,-1]

####Add back in the zero cells
##Format zero cells to look like our new DF
zeroscells<-as.data.frame(zeros$Cell)
zeroscellsPLT_CN=0
zeroscellsx<-0
zeroscellsindex<-0
#Create a data frame of this
zerobind<-cbind(zeroscells,zeroscellsPLT_CN,zeroscellsindex)
#Correct colnames
colnames(zerobind)<-c("cell","Closestplot","indexscore")
####Create final dataframe
Output2<-rbind(zerobind,NewOutput)
Output2<-Output2[order(Output2$cell,decreasing=FALSE),]
####Print final output
write.csv(Output2,"outputs/IC_BC_Cleaned.csv")
####Print log for evaluating
write.csv(Log,"Bray_Curtslog.csv")


