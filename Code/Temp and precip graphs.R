w_dir <- "R:/fer/rschell/Mozelewski/"
setwd(w_dir)

df <- read.csv("Precip_test.csv", header = TRUE)
plot(df)

temp_max <- read.csv("TempMax_test.csv", header = TRUE)
plot(temp_max)

temp_min <- read.csv("TempMin_test.csv", header = TRUE)
plot(temp_min)
