### NECN Succession extension

#### Species parameterization
Species values including C:N ratios and lignin parameters were derived from existing LANDIS-II papers and supplemented with values from the TRY database. Try data was queried by 
species and by trait and in the event of multiple returns, values were averaged. GGDmin, GDDmax, frost, leaf longevity, and max drought, were taken from the original linkages 
manual which can be found at https://daac.ornl.gov/daacdata/model_archive/LINKAGES/comp/ORNL_TM-9519.pdf and existing LANDIS-II papers. Species that could not be found using the 
above approches were adapted from a qualitative assessment of range in comparison to known values for other species. Data sources can be found in this subfolder in the NECN data 
sources.xlsx shreadsheet.

#### Functional groups
After consulting with Rob, I decided on 4 functional groups. A pines group (loblolly, shortleaf, and longleaf), a group solely for Virginia pine (because Virginia pine has a 
range that extends further north than the other pines and can tolerate much colder temperatures), a hardwoods group (white oak, sweet gum, red maple, yellow poplar, flowering 
dogwood, and sourwood), and a group solely for turkey oak (while white oak is a generalist, turkey oak only exists in the southern portion of white oak’s range and has 
temperature and precipitation limit differences). Of the hardwoods functional group, sourwood has a more narrow range but it is still well within the range of the other 
species in this functional group and it has similar temperature and precipitation limitations.

#### Calibration
To calibrate the NECN extension, we began with single-cell simulations (one cell, monoculture). Single cell soils values used for NECN were taken from Natural Resource 
Conservation Service soils data from North Carolina and can be viewed in the Single cell soils values list.xlsx spreadsheet in this subfolder. We did this first for three 
dominant species on the landscape: loblolly pine, red maple, and white oak. Once those individual species were calibrated, we moved on to other single cell, single species 
calibrations for the rest of our 11 species. After these calibrations, we moved on to single cell, single species, multiple cohort calibrations for loblolly, red maple, and 
white oak. We then calibrated a single cell with all 11 species before moving on calibrating the entire landscape. All calibration efforts were cleared by Rob before moving on 
to the next phase.

These general rules were applied to most, if not every, level of calibration:
* Mineral nitrogen should generally stay less than 10
* Soil organic matter total carbon (SOMTC) should be fairly stable or gently increase over time
* Gentle increases in soil organic matter (SOM) values; SurfC and SOM1C will be the most volatile while SOM3 will be the most stable.
* Detrital C/N > tree C/N > soil C/N
* Leaf area index (LAI) should increase before plateauing. Make sure that the inflection point matches the literature. (Can only use for single cell calibration.)
* Above ground biomass(AGB) should be validated with FIA data.

For this project, initial mineral N was an estimate similar to the values found in other LANDIS-II projects (Lake Tahoe, Melissa Lucash’s VIFF project) and based on Rob’s 
suggestions was set to 4. Atmospheric N slope/intercept was attained by looking up National Atmospheric Deposition Program nitrogen deposition data for the past 20 years and 
plotting it as a function of yearly total precipitation in excel and finding the slope and intercept of the trend line (https://www.usgs.gov/water-resources/national-water-
quality-program/national-atmospheric-deposition-program-nadp). (Ndep values from NADP were multiplied by 0.1 to get correct units). This calculation can be found in the NECN 
nitrodep xl.xlsx file. 

<img src="./Ndep.PNG" width="70%" />

Denitrification rate and all of the SOM decay rates were originally taken from the Lake Tahoe LANDIS-II project single cell calibration text 
file and then calibrated for NC. For an example of the calibration process using loblolly pine to refine denitrification and decay rates, reference loblolly runs graphed.xlsx in 
this subfolder. Photo here:

<img src="./loblolly parms test.PNG" width="90%" />

The next step in calibration and validation was to validate above ground biomass and LAI for several of the modeled species across our functional groups. To calibrate above 
ground biomass, we isolated the top 25% of FIA plots by above ground carbon per age, assuming this to represent plots with ideal growing conditions for each species. These were 
then plotted as box plots and compared against simulated above ground biomass of each species. All comparisons to FIA data reference FIA plots from North Carolina, South 
Carolina, and Virginia. LAI was validated against established values for forests from He et al. (2012).

<img src="./Loblolly calibration graphics.PNG" width="80%" />
_______________________________________________________________________________________________________________________________________________________
<img src="./Virginia pine calibration graphics.PNG" width="80%" />
_______________________________________________________________________________________________________________________________________________________
<img src="./Hardwoods calibration graphics.PNG" width="100%" />


Landscape-level above ground biomass was validated against forest data collected in and around Ft. Bragg in central North Carolina that was used for the LANDIS-II Ft. Bragg 
project.

Citations:
He, L., Chen, J.M., Pan, Y., Birdsey, R., & Kattge, J. (2012). Relationships between net primary productivity and forest stand age in US forests. Global Biogeochemical Cycles, 26(3).
