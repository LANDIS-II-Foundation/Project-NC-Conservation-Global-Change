library(raster); options(scipen=999)
library(dplyr)

NC_TREE <- read.csv("C:/Users/tgmozele/Desktop/TREE_tbls/NC_TREE.csv") #load NC_Tree table
SC_TREE <- read.csv("C:/Users/tgmozele/Desktop/TREE_tbls/SC_TREE.csv") #load SC_Tree table
VA_TREE <- read.csv("C:/Users/tgmozele/Desktop/TREE_tbls/VA_TREE.csv") #load VA_Tree table

TREEtbl_all <- rbind(NC_TREE, SC_TREE, VA_TREE) # combine all three tree tables
# Bring in species excel file for my species of interest
spp_file <- read.csv("C:/Users/tgmozele/Desktop/TREE_tbls/spp_code.csv")
spp <- spp_file[,"FIA.code"] # isolate FIA spp codes for my focal species

#This loop selects just the 11 species of interest from all the species in the FIA plots. Ignores other species.
tree_data <- TREEtbl_all[TREEtbl_all$SPCD %in% spp,]

tree.df <- as.data.frame(tree_data)

BIOMASS <- (tree.df[,121] * tree.df[,111])
tree.df <- cbind(BIOMASS, tree.df)

#bin by plot, spp, and age cohort (5yr)
#tree.df <- tree.df[order('PLT_CN'),]
# sort by PLT_CN, species code
#tree.df_plt <- arrange(tree.df, PLT_CN, SPCD)
#write forloop that, for each plot, returns biomass for each unqiue species... get unique list of plots them forloop

