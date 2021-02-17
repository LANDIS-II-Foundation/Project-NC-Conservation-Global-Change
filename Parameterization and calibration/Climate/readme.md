### Climate data

Business as usual scenario climate data came from the USGS Geodata portal. However, after a meeting with my committee member Adam who works for USGS, he suggested download climate 
data from the MACA data portal as netcdf files (https://climate.northwestknowledge.net/MACA/data_portal.php) to create my own model ensemble. Adam suggested that since LANDIS has 
“memory”, i.e. the model can tell the difference between drought that has occurred for months vs. a drought occurring in a single month where an extension is acting, already 
averaged and downloadable ensembles would not work. Adam suggested running each of the 20 climate models for each RCP (4.5 and 8.5) through LANDIS individually, then averaging the 
outputs. He suggested that if this is too time or computationally expensive, to take a 4 corners approach by plotting temp (on the x axis) and precip (on the y axis) for each 
model then selecting the four models with data points at each of the four corners of the map. 
My approach was to use the master’s thesis work from Geneva Grey to pick 5 climate models (10 total- same 5 for both RCP 4.5 and 8.5) that range from driest climate model to 
wettest climate model (middle three are varying degrees of wet/dry/moderate) while also incorporating a substantial amount of diversity across the other metrics (tmin and tmax) 
as depicted in Geneva’s region 7 Atlantic Coastal Plain dendrogram.
The netcdf data for Tmin, Tmax, precip, and wind were downloaded for each of the 20 climate models and both RCPs and formatted into csv files in R thanks in large part to the code 
from this website (http://geog.uoregon.edu/bartlein/courses/geog490/week04-netCDF.html#reading-restructuring-and-writing-netcdf-files-in-r).
