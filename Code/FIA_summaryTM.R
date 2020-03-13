## This script pulls in FIA from NC for data exploration
## Alec Kretchun, 2018

##Need to plot lat/long of plots in Arc and then export plot numbers
##Then we can cross reference to the tree table and get percentage distributions
## PROCESS
## Crosswalk New ID (ME) TO CN (PLOT) to PLOT_CN (TREE)
## EXTRACT ALL SPP CODES
## PLOT COMPOSITION AND DISTRIBUTION

#Read things
library(foreign)
library(pdftools)
library(tidyr)
library(dplyr)
library(stringi)
library(stringr)
options(scipen=999) #changing scientific notation

#Data import
FIA_TREE <- read.csv("C:/Users/tgmozele/Desktop/FIA_data_package/FIA_data_package/NC/NC_TREE.csv")
FIA_PLOT <- read.csv("C:/Users/tgmozele/Desktop/FIA_data_package/FIA_data_package/NC/NC_PLOT.csv")
FIA100km <- read.dbf("C:/Users/tgmozele/Desktop/FortBragg_GISData.gdb/FortBragg_GISData.gdb/FIA100km.dbf")


##Connect from CN to PLOT_CN as foreign key between tables
## I had to do a crosswalk with a sequential ID column as a foreign key cause ArcGIS cuts off plot cn numbers (too many digits)

#Isolate CN and insert seq ID 
PLOT.short <- cbind.data.frame(1:nrow(FIA_PLOT), FIA_PLOT$CN)
colnames(PLOT.short) <- c("seqID", "CN")
# Select CNs based on geographically clipped seqID
PLOT.clip <- PLOT.short[PLOT.short$seqID %in% FIA100km$ID,]
# crosswalking to PLOT_CN in TREE table
TREE.clip <- FIA_TREE[FIA_TREE$PLT_CN %in% PLOT.clip$CN,]
# cleaning up the new TREE data
# This will have to be expanded for other uses (e.g. expanding to plot level data)
TREE.clip <- TREE.clip[,c("CN", "PLT_CN", "SPCD", "DIA", "DRYBIO_AG")]

###write.table(PLOT.clip, "C:/Users/tgmozele/Desktop/FIA_data_package/FIA_data_package/PlotCN", sep="\t") #produce table of clipped plot CN

# Attempting to crawl through a pdf and get species codes and names
FIA.spp.codes <- pdf_text("C:/Users/tgmozele/Desktop/FIA_data_package/FIA_data_package/Appendix 3 spp codes.pdf") #reading in pdf of FIA manual
text2 <- strsplit(FIA.spp.codes, "\n") #splitting it a page breaks
head(text2[[1]])

#Using regex to extract species codes
spcds <- NULL
for(i in 1:length(text2)){
  spcd <- stri_match_last_regex(text2[[i]], "\\d{4}\\s+\\w+") #extracting 4 digit code followed by 1+ spaces fopllowed by 1+ letters
  spcds <- rbind.data.frame(spcds, spcd)
}

spcds.noNA <- as.data.frame(spcds[!is.na(spcds),]) #removing NAs
spcds.noNA <- as.data.frame(spcds.noNA[3:nrow(spcds.noNA),]) #removing junk at top
colnames(spcds.noNA) <- "ALL"
spps.split <- as.data.frame(str_split_fixed(spcds$V1, " ", 2)) #splitting into spcies code and species name

spps.split <- spps.split[!apply(spps.split == "", 1, all),] #removing empty rows
spps.split <- spps.split[-3,] #removing junk at top

spps.numeric <- cbind.data.frame(as.numeric(levels(spps.split$V1))[spps.split$V1], as.character(spps.split$V2)) #turning spps codes into numeric
colnames(spps.numeric) <- c("SPCD", "SPNM")

##Join species codes from TREE table to species codes in spps.numeric from manual
TREE.clip.full <- full_join(TREE.clip, spps.numeric, by="SPCD")
TREE.clip.full <- cbind(TREE.clip.full, 1) ##adding a counter column
sp.counts <- tapply(TREE.clip.full$`1`, TREE.clip.full$SPNM, sum) #counting occurences of species
sp.counts <- sort(sp.counts, decreasing=TRUE)
sp.counts.perc <- sp.counts/sum(sp.counts) * 100

#list(sp.counts.perc)

barplot(sp.counts.perc[1:30], main = "FIA species occurence", ylab="Percentage of total trees", xlab="Species code")


  