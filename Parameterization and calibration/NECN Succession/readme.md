### NECN Succession extension

#### Species parameterization
Species values were taken from the original linkages manual which can be found at https://daac.ornl.gov/daacdata/model_archive/LINKAGES/comp/ORNL_TM-9519.pdf, various entries in 
the TRY database, and existing LANDIS-II papers. Data sources can be found in this subfolder in the NECN data sources.xlsx shreadsheet.

#### Functional groups
After consulting with Rob, I decided on 4 functional groups. A pines group (loblolly, shortleaf, and longleaf), a group solely for Virginia pine (because Virginia pine has a 
range that extends further north than the other pines and can tolerate much colder temperatures), a hardwoods group (white oak, sweet gum, red maple, yellow poplar, flowering 
dogwood, and sourwood), and a group solely for turkey oak (while white oak is a generalist, turkey oak only exists in the southern portion of white oak’s range and has temperature 
and precipitation limit differences). Of the hardwoods functional group, sourwood has a more narrow range but it is still well within the range of the other 
species in this functional group and it has similar temperature and precipitation limitations.

#### Calibration
To calibrate the NECN extension, we began with single-cell simulations (one cell, monoculture). Single cell soils values used for NECN were taken from Natural Resource 
Conservation Service soils data from North Carolina and can be viewed in the Single cell soils values list.xlsx spreadsheet in this subfolder. We did this first for three dominant 
species on the landscape: loblolly pine, red maple, and white oak. Once those individual species were calibrated, we moved on to other single cell, single species calibrations for 
the rest of our 11 species. After these calibrations, we moved on to single cell, single species, multiple cohort calibrations for loblolly, red maple, and white oak. We then calibrated a single cell with all 11 species before moving on calibrating the entire landscape.

* Initial mineral N was an estimate similar to the value found in other LANDIS-II projects (Lake Tahoe, Melissa Lucash’s VIFF project) and based on Rob’s suggestions was set to 4
* Atmospheric N slope/intercept was attained by looking up NADP N deposition data for the past 20 years and plotting it as a function of yearly total precipitation in excel and 
finding the slope and intercept of the trend line. (Ndep values from NADP were multiplied by 0.1 to get correct units). This calculation can be found in the NECN nitrodep xl.xlsx 
file
* Denitrification rate and all of the SOM decay rates were originally taken from the Lake Tahoe LANDIS-II project single cell calibration text file and then calibrated for NC. For 
an example of the calibration process using loblolly pine to refine denitrification and decay rates, reference loblolly runs graphed.xlsx in this subfolder.
* Calibration efforts were cleared by Rob.
