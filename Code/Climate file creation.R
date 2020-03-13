### Make climate files for my landscape
### MACA climate data 2006_2099_CONUS_monthly_aggregated.nc
### Rectangular subset of my study extent (NE corner 36.7209N, -78.1416E; SW corner 34.5674N, -80.8008E)
### CMIP 5 models
### MACAv2-LivNEH
### https://climate.northwestknowledge.net/MACA/data_portal.php


install.packages("ncdf4")
install.packages("reshape2")
install.packages("dplyr")
install.packages("chron")

library(ncdf4)
library(reshape2)
library(dplyr)
library(chron)

##options(chron.year.expand = 
          #function (y, cut.off = 99, century = c(2000, 2100), ...) {
            #chron:::year.expand(y, cut.off = cut.off, century = century, ...)
          #}
#)

setwd("R:/fer/rschell/Mozelewski/zClimate_files/RCP_8.5/")

ncpath <- "R:/fer/rschell/Mozelewski/zClimate_files/RCP_8.5/Precip/"
#ncname <- "cru10min30_tmp"  
#ncfname <- paste(ncpath, ncname, ".nc", sep="")
dname <- "precipitation"  # note: tmp means temperature (not temporary)
#dname <- "air_temperature"
#dname <- "wind_speed"

flist <- list.files(path = "precip/", pattern = "^.*\\.(nc|NC|Nc|Nc)$")
#allmodels <- NULL

  # iterate through the nc
  for (i in 1:length(flist)) {
    # open a conneciton to the ith nc file
    print(flist[i])
    
    name <- flist[i]
    
    # Open a connection to the first file in our list
    ncin <- nc_open(paste0("precip/", flist[i]))
    #get lattitude and longitude
    lon <- ncvar_get(ncin,"lon")
    nlon <- dim(lon)
    lat <- ncvar_get(ncin,"lat")
    nlat <- dim(lat)
    # get time
    time <- ncvar_get(ncin,"time")
    print(time)
    tunits <- ncatt_get(ncin,"time","units")
    nt <- dim(time)
    # get variable
    variable_array <- ncvar_get(ncin,dname)
    dlname <- ncatt_get(ncin,dname,"long_name")
    dunits <- ncatt_get(ncin,dname,"units")
    fillvalue <- ncatt_get(ncin,dname,"_FillValue")
    
    # convert time -- split the time units string into fields
    tustr <- strsplit(tunits$value, " ")
    tdstr <- strsplit(unlist(tustr)[3], "-")
    tmonth <- as.integer(unlist(tdstr)[2])
    tday <- as.integer(unlist(tdstr)[3])
    tyear <- as.integer(unlist(tdstr)[1])
    #chron(time,origin=c(tmonth, tday, tyear))
    chron(time,origin=c(tmonth, tday, tyear))
    
    # replace netCDF fill values with NA's
    variable_array[variable_array==fillvalue$value] <- NA
    
    #slice
    onemodeldf <- NULL
    for (m in 2:972) {
      print(m)
      variable_slice <- variable_array[,,m]
      #print(tmp_slice)
    
      # reshape the array into vector
      vec_long <- as.vector(variable_slice)
      mean <- mean(vec_long)
      stdev <- sd(vec_long)
      var <- var(vec_long)
    
      time_m <- chron(time[m],origin=c(tmonth, tday, tyear))
      timechar<-as.character(time_m)
      timechar
      Year<-substring(timechar,first=7)
      Monthday<-substring(timechar,first=1,last=6)
      BetterYear<-paste0("20",Year)
      Timeout<-paste0(Monthday,BetterYear)
      #row <- cbind(as.character(time_m), flist[i], mean, stdev, var)
      #colnames(row)[c(1,2)] <- c("date", "model")
      row <- (cbind(Timeout, mean, stdev, var))
      onemodeldf <- rbind(row, onemodeldf)
      
      #onemodeldf$mean<-as.numeric(onemodeldf$mean)
      #onemodeldf$stdev<-as.numeric(onemodeldf$stdev)
      #onemodeldf$var<-as.numeric(onemodeldf$var)
      #onemodeldf$var<-as.numeric(as.character(onemodeldf$var))
      
      colnames(onemodeldf)[c(1,2,3,4)] <- c("TIMESTEP", "MEAN(mm/m)", "STD_DEV(mm/m)", "VARIANCE(mm/m^2)")
      
    }
    
    #allmodels <- rbind(onemodeldf, allmodels)
    
    file<-gsub("i1p1_rcp45.nc","",name)
    file<-gsub("i1p1_rcp85.nc","",name)
    write.csv(onemodeldf, paste0("R:/fer/rschell/Mozelewski/zClimate_files/RCP_8.5/Precip/",file,".csv"), row.names = FALSE)
    
  }

#allmodelsdf <- as.data.frame(allmodels)

read.csv("R:/fer/rschell/Mozelewski/zClimate_files/RCP_4.5/Precip/pr_bcc-csm1-1_r1.csv")

##########################################################################################

setwd("R:/fer/rschell/Mozelewski/zClimate_files/RCP_4.5/")

ncpath <- "R:/fer/rschell/Mozelewski/zClimate_files/RCP_4.5/Tmin/"
#ncname <- "cru10min30_tmp"  
#ncfname <- paste(ncpath, ncname, ".nc", sep="")
dname <- "air_temperature"  # note: tmp means temperature (not temporary)
#dname <- "air_temperature"
#dname <- "wind_speed"

flist <- list.files(path = "Tmin/", pattern = "^.*\\.(nc|NC|Nc|Nc)$")
#allmodels <- NULL

# iterate through the nc
for (i in 1:length(flist)) {
  # open a conneciton to the ith nc file
  print(flist[i])
  
  name <- flist[i]
  
  # Open a connection to the first file in our list
  ncin <- nc_open(paste0("Tmin/", flist[i]))
  #get lattitude and longitude
  lon <- ncvar_get(ncin,"lon")
  nlon <- dim(lon)
  lat <- ncvar_get(ncin,"lat")
  nlat <- dim(lat)
  # get time
  time <- ncvar_get(ncin,"time")
  print(time)
  tunits <- ncatt_get(ncin,"time","units")
  nt <- dim(time)
  # get variable
  variable_array <- ncvar_get(ncin,dname)
  dlname <- ncatt_get(ncin,dname,"long_name")
  dunits <- ncatt_get(ncin,dname,"units")
  fillvalue <- ncatt_get(ncin,dname,"_FillValue")
  
  # convert time -- split the time units string into fields
  tustr <- strsplit(tunits$value, " ")
  tdstr <- strsplit(unlist(tustr)[3], "-")
  tmonth <- as.integer(unlist(tdstr)[2])
  tday <- as.integer(unlist(tdstr)[3])
  tyear <- as.integer(unlist(tdstr)[1])
  #chron(time,origin=c(tmonth, tday, tyear))
  chron(time,origin=c(tmonth, tday, tyear))
  
  # replace netCDF fill values with NA's
  variable_array[variable_array==fillvalue$value] <- NA
  
  #slice
  onemodeldf <- NULL
  for (m in 2:972) {
    print(m)
    variable_slice <- variable_array[,,m]
    #print(tmp_slice)
    
    # reshape the array into vector
    vec_long <- as.vector(variable_slice)
    mean <- mean(vec_long)
    stdev <- sd(vec_long)
    var <- var(vec_long)
    
    time_m <- chron(time[m],origin=c(tmonth, tday, tyear))
    timechar<-as.character(time_m)
    timechar
    Year<-substring(timechar,first=7)
    Monthday<-substring(timechar,first=1,last=6)
    BetterYear<-paste0("20",Year)
    Timeout<-paste0(Monthday,BetterYear)
    #row <- cbind(as.character(time_m), flist[i], mean, stdev, var)
    #colnames(row)[c(1,2)] <- c("date", "model")
    row <- (cbind(Timeout, mean, stdev, var))
    onemodeldf <- rbind(row, onemodeldf)
    
    #onemodeldf$mean<-as.numeric(onemodeldf$mean)
    #onemodeldf$stdev<-as.numeric(onemodeldf$stdev)
    #onemodeldf$var<-as.numeric(onemodeldf$var)
    #onemodeldf$var<-as.numeric(as.character(onemodeldf$var))
    
    colnames(onemodeldf)[c(1,2,3,4)] <- c("TIMESTEP", "MEAN(mm/m)", "STD_DEV(mm/m)", "VARIANCE(mm/m^2)")
    
  }
  
  #allmodels <- rbind(onemodeldf, allmodels)
  
  file<-gsub("i1p1_rcp45.nc","",name)
  file<-gsub("i1p1_rcp85.nc","",name)
  write.csv(onemodeldf, paste0("R:/fer/rschell/Mozelewski/zClimate_files/RCP_4.5/Tmin/",file,".csv"), row.names = FALSE)
  
}

#allmodelsdf <- as.data.frame(allmodels)

read.csv("R:/fer/rschell/Mozelewski/zClimate_files/RCP_4.5/Precip/pr_bcc-csm1-1_r1.csv")
#########################################################################################


setwd("R:/fer/rschell/Mozelewski/zClimate_files/RCP_8.5/")

ncpath <- "R:/fer/rschell/Mozelewski/zClimate_files/RCP_8.5/Wind/"
#ncname <- "cru10min30_tmp"  
#ncfname <- paste(ncpath, ncname, ".nc", sep="")
dname <- "wind_speed"  # note: tmp means temperature (not temporary)


flist <- list.files(path = "Wind/", pattern = "^.*\\.(nc|NC|Nc|Nc)$")
#allmodels <- NULL

# iterate through the nc
for (i in 1:length(flist)) {
  # open a conneciton to the ith nc file
  print(flist[i])
  
  name <- flist[i]
  
  # Open a connection to the first file in our list
  ncin <- nc_open(paste0("Wind/", flist[i]))
  #get lattitude and longitude
  lon <- ncvar_get(ncin,"lon")
  nlon <- dim(lon)
  lat <- ncvar_get(ncin,"lat")
  nlat <- dim(lat)
  # get time
  time <- ncvar_get(ncin,"time")
  print(time)
  tunits <- ncatt_get(ncin,"time","units")
  nt <- dim(time)
  # get variable
  variable_array <- ncvar_get(ncin,dname)
  dlname <- ncatt_get(ncin,dname,"long_name")
  dunits <- ncatt_get(ncin,dname,"units")
  fillvalue <- ncatt_get(ncin,dname,"_FillValue")
  
  # convert time -- split the time units string into fields
  tustr <- strsplit(tunits$value, " ")
  tdstr <- strsplit(unlist(tustr)[3], "-")
  tmonth <- as.integer(unlist(tdstr)[2])
  tday <- as.integer(unlist(tdstr)[3])
  tyear <- as.integer(unlist(tdstr)[1])
  #chron(time,origin=c(tmonth, tday, tyear))
  chron(time,origin=c(tmonth, tday, tyear))
  
  # replace netCDF fill values with NA's
  variable_array[variable_array==fillvalue$value] <- NA
  
  #slice
  onemodeldf <- NULL
  for (m in 2:972) {
    print(m)
    variable_slice <- variable_array[,,m]
    #print(tmp_slice)
    
    # reshape the array into vector
    vec_long <- as.vector(variable_slice)
    #vec_long <- vec_long - 273.15 ###convert temp from Kelvin to Celsius
    mean <- mean(vec_long)
    stdev <- sd(vec_long)
    var <- var(vec_long)
    
    time_m <- chron(time[m],origin=c(tmonth, tday, tyear))
    timechar<-as.character(time_m)
    timechar
    Year<-substring(timechar,first=7)
    Monthday<-substring(timechar,first=1,last=6)
    BetterYear<-paste0("20",Year)
    Timeout<-paste0(Monthday,BetterYear)
    #row <- cbind(as.character(time_m), flist[i], mean, stdev, var)
    #colnames(row)[c(1,2)] <- c("date", "model")
    row <- (cbind(Timeout, mean, stdev, var))
    onemodeldf <- rbind(row, onemodeldf)
    
    #onemodeldf$mean<-as.numeric(onemodeldf$mean)
    #onemodeldf$stdev<-as.numeric(onemodeldf$stdev)
    #onemodeldf$var<-as.numeric(onemodeldf$var)
    #onemodeldf$var<-as.numeric(as.character(onemodeldf$var))
    
    colnames(onemodeldf)[c(1,2,3,4)] <- c("TIMESTEP", "MEAN(m/s)", "STD_DEV(m/s)", "VARIANCE(m/s^2)")
    
  }
  
  #allmodels <- rbind(onemodeldf, allmodels)
  
  file<-gsub("i1p1_rcp45.nc","",name)
  file<-gsub("i1p1_rcp85.nc","",name)
  write.csv(onemodeldf, paste0("R:/fer/rschell/Mozelewski/zClimate_files/RCP_8.5/Wind/",file,".csv"), row.names = FALSE)
  
}
 print(vec_long)
 
#############################################################################################################
 cc <- NULL
 for (m in 2:972) {
 
#allmodelsdf$mean<-as.numeric(as.character(allmodelsdf$mean))
#allmodelsdf$stdev<-as.numeric(as.character(allmodelsdf$stdev))
#allmodelsdf$var<-as.numeric(as.character(allmodelsdf$var))

#allmodelsdf_mean<- aggregate(allmodelsdf$mean, by = list(time = allmodelsdf$date), FUN= mean)
#allmodelsdf_sd <- aggregate(allmodelsdf$stdev, by = list(time = allmodelsdf$date), FUN= mean)
#allmodelsdf_var <- aggregate(allmodelsdf$var, by = list(time = allmodelsdf$date), FUN= mean)

#ALL <- cbind(allmodelsdf_mean, allmodelsdf_var[2], allmodelsdf_sd[2])
#colnames(ALL)[c(2,3,4)] <- c("MEAN", "VARIANCE", "STD_DEV")


#file<-gsub("i1p1_rcp45.nc","",name)


    
#write.csv(ALL, paste0("R:/fer/rschell/Mozelewski/zClimate_files/RCP_4.5/precip/",file,".csv"), row.names = FALSE)



#############################################################
###############DIDN'T USE THIS STUFF########################
############################################################


    # create a dataframe
    lonlat <- as.matrix(expand.grid(lon,lat))
    tmp_df02 <- data.frame(cbind(lonlat,tmp_mat))
    names(tmp_df02) <- c("lon","lat","tmpJan","tmpFeb","tmpMar","tmpApr","tmpMay","tmpJun",
                         "tmpJul","tmpAug","tmpSep","tmpOct","tmpNov","tmpDec")
    # options(width=96)
    head(na.omit(tmp_df02, 20))
    
    #get column (monthly) means
    unique()
    colMeans(tmp_df02[3:14], na.rm = TRUE)
    
    # write out the dataframe as a .csv file
    csvpath <- "R:/fer/rschell/Mozelewski/zClimate_files/RCP_4.5/precip/"
    csvname <- "cru_tmp_2.csv"
    csvfile <- paste(csvpath, csvname, sep="")
    write.table(na.omit(tmp_df02),csvfile, row.names=FALSE, sep=",")
    
    
    # reshape the vector into a matrix ---- not using
    tmp_mat <- matrix(tmp_vec_long, nrow=nlon*nlat, ncol=nt)
    head(na.omit(tmp_mat))
    
    # get global attributes
    title <- ncatt_get(ncin,0,"title")
    institution <- ncatt_get(ncin,0,"institution")
    datasource <- ncatt_get(ncin,0,"source")
    references <- ncatt_get(ncin,0,"references")
    history <- ncatt_get(ncin,0,"history")
    Conventions <- ncatt_get(ncin,0,"Conventions")
    # close the connection sice were finished
    nc_close(nc_in)
    
 ################################################################
read.csv("R:/fer/rschell/Mozelewski/NECN_Tina/NECN_Tina_landscape_basic_Sor/bcc-csm1-1_r1_climate.csv")
    
        