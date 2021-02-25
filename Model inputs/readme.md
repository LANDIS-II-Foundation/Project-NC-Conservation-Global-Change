These are the inputs used for all modeling work presented in manuscripts and reports. For parameter units in each file in this subfolder please reference the respective 
extension's user guide, which can be found at this website by clicking the extension of interest and selecting the user guide: http://www.landis-ii.org/extensions

General model inputs:
* BatchFile.bat to run the model
* Ecoregion100f.tif
* ecoregions_1.txt
* scenario_landscape.txt
* species_TM.txt

Soils inputs:
* clay100.tif
* DeadRoot100.tif
* DeadWood100.tif
* depth100.tif
* drain100.tif
* field100.tif
* sand100.tif
* wilt100.tif

Soil carbon and nitrogen inputs:
* SoilC100.tif
* SoilN100.tif
* SOM2C100.tif
* SOM2N100.tif
* SOM3C100.tif
* SOM3N100.tif
* SurfC100.tif
* SurfN100.tif

NECN inputs (in addition to soils maps):
* IC100.tif
* NECN_input_TM.txt
* Tinas_IC_Sorrensons5_6.txt

Biomass harvest inputs:
* BiomassHarvest.txt
* MgmtMap100.tif for BAU management
* MgmtMap_cluster15.tif for cluster conservation strategy
* MgmtMap_econ125_5.tif for economic conservation strategy
* MgmtMap_geo15.tif for geodiversity conservation strategy
* MgmtMap_rand15.tif for opportunistic/random conservation strategy

Hurricane inputs:
* BaseHurricane.txt for BAU hurricanes
* BaseHurricane_CC.txt for climate change hurricanes

Climate inputs:
* climate_gen_baselineTM.txt for BAU climate
* climate_TM.csv for BAU climate
* climate_gen_baselineTM_CC.txt for climate change scenarios
* bcc-csm1-1_r1.csv,  CNRM-CM5_r1.csv, HadGEM2-CC365.csv, IPSL-CM5A-LR_r1.csv, and NorESM1-M_r1.csv for RCP 4.5 scenarios
* bcc-csm1-1_r1_85.csv,  CNRM-CM5_r1_85.csv, HadGEM2-CC_85.csv, IPSL-CM5A-LR_r1_85.csv, and NorESM1-M_r1_85.csv for RCP 8.5 scenarios

Land use change inputs:
* LandUse_Change.txt
* land-use-0-45.tif, land-use-10-45.tif, land-use-20-45.tif, land-use-30-45.tif, land-use-40.tif-45, land-use-50.tif-45, land-use-60-45.tif, land-use-70-45.tif, and
land-use-80-45.tif are the land use change maps for RCP4.5/SSP2 (land-use-0.tif = map for model time step zero)
* land-use-0-85.tif, land-use-10-85.tif, land-use-20-85.tif, land-use-30-85.tif, land-use-40.tif-85, land-use-50.tif-85, land-use-60-85.tif, land-use-70-85.tif, and
land-use-80-85.tif are the land use change maps for RCP8.5/SSP5

Output extension inputs:
* output_biomass.txt
* output_cohort_stats.txt
