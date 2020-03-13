NC_TREE <- read.csv("C:/Users/tgmozele/Desktop/FIA_data_package/FIA_data_package/NC/NC_TREE.csv") #load NC_Tree table
NC_SITETREE <- read.csv("C:/Users/tgmozele/Desktop/FIA_data_package/FIA_data_package/NC/NC_SITETREE.csv") #load NC_SiteTree table

library("tibble") #convert NC_TREE to a tibble?
NC_TREE <- as_data_frame(NC_TREE)

install.packages("dplyr") #install dplyr
library("dplyr") #load dplyr

PITA <- filter(NC_TREE, SPCD == 131) #filter for one specific species by FIA spp code
PITA_col <- PITA[c(1, 2, 20, 66, 111, 158)] #isolate columns of interest

PITA_ST <- filter(NC_SITETREE, SPCD == 131) #filter for one specific species by FIA spp code
PITA_STdf <- data.frame(PITA_ST)

#remove NA values

#plot age vs biomass
plot(x = PITA[,66], y = PITA[,158], main = "Age vs Biomass", xlab = "Age", 
        ylab = "Biomass")

par(mfrow = c(1,2)) #plot two plots next to each other to compare height and diameter

#plot age vs height
plot(x = PITA_STdf[,14], y = PITA_STdf[,13], main = "PITA Age vs Height", xlab = "Age", 
     ylab = "Height")

#plot age vs diameter
plot(x = PITA_STdf[,14], y = PITA_STdf[,12], main = "PITA Age vs Diameter", xlab = "Age", 
     ylab = "Diameter")