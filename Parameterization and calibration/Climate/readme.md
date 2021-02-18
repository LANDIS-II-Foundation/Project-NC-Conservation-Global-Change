### Climate data

We decided on only one climate region after determining that the study area had minimial differences in temperature and precipitation along with low topographical variation 
(INSERT PRECIP AND TEMP GRAPHS HERE!!!!!).

Business as usual scenario climate data came from the USGS Geodata portal daily observed data from 1949 to 2010 and were downloaded as daily precipitation, maximum and minimum 
temperatures, and wind speed. 

Climate change projections from the Coupled Model Intercomparison Project Phase 5 downscaled using the Multivariate Adaptive Constructed Analogs (MACA) method were downloaded
as monthly precipitation, maximum and minimum temperature, and wind speedfrom the MACA data portal as netcdf files (https://climate.northwestknowledge.net/MACA/data_portal.php).
We chose five general circulation models (GCMs) for Representative Concentration Pathway (RCP) 4.5 and 8.5 that bracketed the temperature and precipitation projections for the 
study area to create my own ensemble model: bcc-csm1, CNRM-CM5, Had-GEM2, IPSL-CM5A-LR, and Nor-ESM1-M. My approach was to use the master’s thesis work from Geneva Grey to pick 5 
climate models (10 total- same 5 for both RCP 4.5 and 8.5) that range from driest climate model to wettest climate model (middle three are varying degrees of wet/dry/moderate) 
while also incorporating a substantial amount of diversity across the other metrics (tmin and tmax) as depicted in Geneva’s region 7 Atlantic Coastal Plain dendrogram.

The netcdf data for Tmin, Tmax, precip, and wind were downloaded for each of the 5 CMIP5 climate models and both RCPs and formatted into csv files in R thanks in large part 
to the code from this website (http://geog.uoregon.edu/bartlein/courses/geog490/week04-netCDF.html#reading-restructuring-and-writing-netcdf-files-in-r).
