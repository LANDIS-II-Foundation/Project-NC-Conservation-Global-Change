### Soils maps

The NECN succession extension requires input maps of landscape abiotic conditions. Maps for soil depth, drainage, flood frequency, sand and clay percentage, field capacity,
and wilting point were derived from the USGS gssurgo dataset and cropped to the study extent. These maps were aggregated from their original resolution (10m) to the study 
resolution of 100m. Total carbon was calculated using the CONUS level carbon maps scale to the resolution of the study area (West 2014). The guidelines in the Century 
manual were used to divide the SOM into the fast, slow, and passive pools and then calculate the total N in each pool (Parton 2013). Deadwood and roots were calculated by 
interpolating between FIA sites for dead wood and assuming dead roots made up 1/3 of dead wood values.

The methods for creating soils maps come from Melissa Lucash. Zachary Robbins was hugely helpful in the creation of these maps for the central North Carolina landscape.
I sincerely thank them both for their contributions.


NECN requires the following maps:

* Soil Depth 1
* Soil Drain 1
Field Capacity 1
Wilting Point 1
Percent Sand 1
Percent Clay 1
Soil Maps of carbon pools 2
Soil Maps of nitrogen pools 2
Dead Wood on the Surface 3
Dead Wood of Coarse Roots 3
Base Flow to Streams 4
Storm Flow to Streams 4

Map 1s are derived from the USGS ggsurgo database. Map 2s are derived from total soil carbon maps (West 2014). Map 3s are interpolated from FIA data. 
BaseFlow and Storm Flow (Map 4s) are treated as stationary variables in this simulation.



I began by getting the carbon and nitrogen Maps. I started with a total soil carbon map (West 2014), reprojected it, cut to the extent and then used estimated ratios of carbon in each pool (surface, fast, medium and slow) as well as C: N ratios and Dr. Lucash’s work to create the soil maps.

As a fraction of total carbon each carbon pool is:

SOM1surfC=.01
SOM1soilC=.02
SOM2C=.59
SOM3C=.38
Each nitrogen map is then created by multiplying the carbon in that pool by:

SOM1surfN=.1
SOM1soilN=.1
SOM2N=.04
SOM3N=.118
A minimum value of 2.0 was set for the nitrogen value to avoid complete lack of N in some stands with low soil carbon.

Sources: 
Parton, W. 2013. CENTURY Soil Organic Matter Model Environment. Technical Documentation. Agroecosystem Version 3.0. USDA-ARS, Forest Collins, CO.
West, T.O. 2014. Soil Carbon Estimates in 20-cm Layers to 1-m Depth for the Conterminous US, 1970-1993. Data set. Available on-line [http://daac.ornl.gov] from Oak Ridge National Laboratory Distributed Active Archive Center, Oak Ridge, Tennessee, USA. http://dx.doi.org/10.3334/ORNLDAAC/1238
Soil Survey Staff, Natural Resources Conservation Service, United States Department of Agriculture. Soil Survey Geographic (SSURGO) Database for NC. Available online. Accessed [10/17/2019].
