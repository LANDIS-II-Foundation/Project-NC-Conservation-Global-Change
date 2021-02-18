### Biomass Harvest

The Biomass Harvest extension simulates forest management by selecting and removing tree species biomass based on specific management prescriptions that specify the timing of harvest, the species harvested, the amount of biomass removed, and the species planted (Gustafson et al. 2000). 

#### Management and stand maps
Maps of management areas and forest stands determine where harvesting occurs on the landscape. 

To create the management map, we divided the study area into management units based on the land ownership types described in Forest Service Forest Ownership Types in the 
Conterminous US map (https://www.fs.fed.us/nrs/pubs/rmap/rmap_nrs6.pdf). This map was reprojected to the extent of my study area.

Management map for my study area

<img src="./Mgmtareas.jpg" width="80%" />

We then further subdivided the landscape into forest stands for the forest stand map using an extensive map of roads and streams. I originally only subdivide by major roads and 
streams layers but this yielded stands that were far too large. I had to redo the subdivision, this time by all roads and all streams on my landscape to create smaller stands. 
This was done in ArcGIS and then had to be reprojected in R similar to the management area map. Stand size was validated with data from Rajan Parajuli- NC-wide land and forest 
holdings data from 2017-2018 from NWOS survey.

Comparison of Rajan's stand data and my simulated stand sizes

<img src="./Stands.PNG" width="90%" />

