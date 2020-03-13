Climate file creation
================
Tina Mozelewski

R Markdown
----------

This is an R Markdown document. Markdown is a simple formatting syntax for authoring HTML, PDF, and MS Word documents. For more details on using R Markdown see <http://rmarkdown.rstudio.com>.

I downloaded data for 2019-2099 from MACA to create climate files for my 80-year LANDIS-II runs.These data were downloaded from all 20 climate models offered by MACA for both RCP 4.5 and RCP 8.5 emissions scenarios. The data were downloaded as netcdf files then formatted for LANDIS-II climate files using the below code, plus some minor post-processing in excel.

``` r
setwd("R:/fer/rschell/Mozelewski/zClimate_files/RCP_4.5/")
ncpath <- "R:/fer/rschell/Mozelewski/zClimate_files/RCP_4.5/Precip/"
dname <- "precipitation"  # note: tmp means temperature (not temporary)

flist <- list.files(path = "precip/", pattern = "^.*\\.(nc|NC|Nc|Nc)$")

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
    chron(time,origin=c(tmonth, tday, tyear))
    
    # replace netCDF fill values with NA's
    variable_array[variable_array==fillvalue$value] <- NA
    
    #slice
    onemodeldf <- NULL
    for (m in 1:972) {
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
      row <- (cbind(Timeout, mean, stdev, var))
      onemodeldf <- rbind(row, onemodeldf)
      
      
      colnames(onemodeldf)[c(2,3,4)] <- c("MEAN(mm/m)", "STD_DEV(mm/m)", "VARIANCE(mm/m^2)")
      
    }
    
    file<-gsub("i1p1_rcp45.nc","",name)
    file<-gsub("i1p1_rcp85.nc","",name)
    
    write.csv(onemodeldf, paste0("R:/fer/rschell/Mozelewski/zClimate_files/RCP_4.5/Precip/",file,".csv"), row.names = FALSE)
    
  }
```
