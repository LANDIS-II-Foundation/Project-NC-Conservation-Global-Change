#This code created with help from http://cc.oulu.fi/~jarioksa/opetus/metodi/sessio3.pdf

#First install the "vegan" package. You can do this using the install.packages command below or by going to the Packages tab on the right side of the screen,
#clicking install, and typing vegan in the packages line, and then clicking install again.
install.packages("vegan")

#load vegan package into R using the library command
library(vegan)

#Bring in phytolith data csv file. Before loading in the phytolith csv we need to do some data cleaning. Edit the data table so that each column is a phytolith type 
#(Arecaceae, bulliform, and hook cell) and each row is an entry for a radiocarbon dated year. Include the column headings but leave off the row headings. We'll add
#those next.
phytolith_data <- read.csv("R:/fer/rschell/Mozelewski/Paleo_dataR.csv")
#Add the radiocarbon dates as row names
row.names(phytolith_data) <- c("16", "27", "29", "670", "38427", "39064", "39251", "40827", "41475", "41905", "43562")

#This creates the dissimilarity indices needed for our clustering.
d <- vegdist(phytolith_data)

#TIme to cluster! The command for clustering is hclust and here we're using complete linkage clustering.
ccom <- hclust(d, method="complete")

#Plot the dendrogram
plot(ccom)
