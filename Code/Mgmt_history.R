## This script summarizes forest management actions performed in the Lake Tahoe Basin Management Unit
## Alec Kretchun, 2018

##Read things
library(foreign)

##Import data
FACTS.dat <- read.dbf("I:/SNPLMA3/Data/Management/LTB_FACTS_04_14.dbf")
SPF.dat <- read.dbf("I:/SNPLMA3/Data/Management/SPF_04_14.dbf")
years <- c(2004:2014)

##Data cleaning

FACTS.short <- FACTS.dat[,c("ACTIVITY", "NBR_UNITS1", "DATE_ACCOM", "FISCAL_Y_2")] #extracting columns by name
FACTS.short.clean <- FACTS.short[complete.cases(FACTS.short),] #removing NAs - about 450 rows
FACTS.04.14 <- FACTS.short.clean[FACTS.short.clean$FISCAL_Y_2 > 2003, ]

SPF.short <- SPF.dat[, c("OWN_FULL", "ACRES", "ACT_1", "YEAR_1")]
SPF.short.clean <- SPF.short[complete.cases(SPF.short),]
SPF.04.14 <- SPF.short.clean[(SPF.short.clean$YEAR_1 > 2003),]


##Summary stats of FACTS data
FACTS.acre.total <- tapply(FACTS.04.14$NBR_UNITS1, FACTS.04.14$ACTIVITY, sum) #total acres treated by treatment type
FACTS.acre.total.order <- sort.list(FACTS.acre.total, decreasing = TRUE) #sorting based on acreage totals

# 
# cols <- terrain.colors(10)
# barplot(FACTS.acre.total[FACTS.acre.total.order[1:10]], xlab="Treatment type", ylab="Total acres treated 2004-2014",
#          names.arg="", col=cols)
# legend("topright", legend=rownames(FACTS.acre.total[FACTS.acre.total.order[1:10]]), fill=cols)

## Classifying into mech, hand, and rx treatments
## Refer to Trello card 'Crunch mgmt data to find targets for BAU'
rx.types <- unique(FACTS.04.14$ACTIVITY) #list of all possible treatment types. There are 65 :(

mechanical.rx <- c("Commercial Thin", "Wildlife Habitat Mechanical treatment")   # mechanical treatment types (per Forest Schaefer) Includes
hand.rx <- c("Wildlife Habitat Precommercial thinning", "Precommercial Thin",
            "Improvement Cut", "Sanitation Cut", "Thinning for Hazardous Fuels Reduction", 
            "Salvage Cut (intermediate treatment, not regeneration)",
            "Wildlife Habitat Intermediate cut", "Prune") #hand treatment types (per Forest)
#fire.rx <- # all prescribed fire types. not sure if we're going to use these yet

## Summarize hand vs mechanical thinning in FED data
mech.treatments <- FACTS.04.14[FACTS.04.14$ACTIVITY %in% mechanical.rx,]#extracting completed acres
mech.annual <- tapply(mech.treatments$NBR_UNITS1, mech.treatments$FISCAL_Y_2, sum) #summing by year
barplot(mech.annual)

hand.treatments <- FACTS.04.14[FACTS.04.14$ACTIVITY %in% hand.rx,]
hand.annual <- tapply(hand.treatments$NBR_UNITS1, hand.treatments$FISCAL_Y_2, sum)
barplot(hand.annual)

#Summarize acres treated in state/local data
spf.rx.types <- unique(SPF.04.14$ACT_1)
spf.hand.treatments <- SPF.04.14[(SPF.04.14$ACT_1== "Hand Thin"),]
spf.mech.treatments <- SPF.04.14[(SPF.04.14$ACT_1 %in% c("Mechanical", "Mechanical Thin")), ]

spf.hand.annual <- tapply(spf.hand.treatments$ACRES, spf.hand.treatments$YEAR_1, sum)
spf.mech.annual <- tapply(spf.mech.treatments$ACRES, spf.mech.treatments$YEAR_1, sum)

##Join state/private and USFS
all.hand.annual <- hand.annual + spf.hand.annual
## have to infill 0s where there were no mech txs 
missing <- setdiff(names(mech.annual), names(spf.mech.annual)) #finding missing years
spf.mech.annual[missing] <- 0 # add missing years
spf.mech.annual <- spf.mech.annual[order(names(spf.mech.annual))] #re-ordering
all.mech.annual <- mech.annual + spf.mech.annual #adding state/local/fed

#Quick check against multi-juris plan
sum(all.hand.annual[5:10])
sum(all.mech.annual[5:10])

#Plotting results
cols <- c("darkolivegreen3", "orange")
annual.acres <- rbind(all.hand.annual, all.mech.annual)
rownames(annual.acres) <- c("Hand", "Mechanical")
barplot(annual.acres, col=cols, ylim=c(0,6000), xlab="Year", ylab="Acres treated", 
        main = "Accomplishment report - acres treated (all lands)")
legend("topleft", legend=rownames(annual.acres), fill=cols)



