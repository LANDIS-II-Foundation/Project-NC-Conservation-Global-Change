### NECN Succession extension

#### Functional groups
After consulting with Rob, we decided on 4 functional groups. A pines group (loblolly, shortleaf, and longleaf), a group solely for Virginia pine (because Virginia pine has a 
range that extends further north than the other pines and can tolerate much colder temperatures), a hardwoods group (white oak, sweet gum, red maple, yellow poplar, flowering 
dogwood, and sourwood), and a group solely for turkey oak (while white oak is a generalist, turkey oak only exists in the southern portion of white oak’s range and has temperature 
and precipitation limit differences). Of the hardwoods functional group, sourwood has a more narrow range but it is still well within the range of the other 
species in this functional group and it has similar temperature and precipitation limitations.

#### Calibration
* Used loblolly pine for single cell/single species calibration because it is the most prevalent species on my study extent.
* I got single cell soil values from the NRCS soil maps that Zachary Robbins sent along
* Species values come from Katie Martin’s 2015 Carbon Tradeoffs paper in Ecosystems, LINKAGES manual, TRY database, LANDIS New Jersey Pine Barrens paper, etc. See NECN data 
* sources excel sheet for exact sources of each data field.
* Initial mineral N was an estimate similar to the value found in other LANDIS-II projects (Lake Tahoe, Melissa Lucash’s VIFF project) and based on Rob’s suggestions; set to 4
* Atmospheric N slope/intercept was attained by looking up NADP N deposition data for the past 20 years and plotting it as a function of yearly total precipitation in excel and 
finding the slope and intercept of the trend line. (Ndep values from NADP were multiplied by 0.1 to get correct units). This calculation can be found in 
* Denitrification rate and all of the SOM decay rates were originally taken from the Lake Tahoe LANDIS-II project single cell calibration text file and then calibrated for NC.
* After calibrating loblolly, I calibrated red oak and white maple individually, then those three in a single cell collectively, then began landscape level calibration. 
* Calibration efforts were cleared by Rob.
