### Connectivity

We chose to evaluate landscape connectivity using a guild approach for four theoretical, trait-based species guilds instead of one or two specific species because we felt this 
offered broader conservation insight and greater generalization of findings (Blaum et al. 2011, Lechner et al. 2017). Assessing potential landscape connectivity over time on a 
dynamic landscape for these trait-based species types allowed us to represent a suite of species and inform efficient conservation planning, a valuable insight for land managers 
with multi-species centered conservation goals (Koen et al. 2014, Beier et al. 2008). In this way, we focused on facilitating connectedness and managing ecosystems for 
functional capacity rather than focusing on particular species as recommended by Barnosky et al. (2017). We focused on two species traits known to influence the accessibility of 
landscape elements: degree of habitat specialization and dispersal ability. These two traits were combined to produce four simulated species: habitat specialist/high dispersal 
ability, habitat generalist/high dispersal ability, habitat specialist/low dispersal ability, and habitat generalist/low dispersal ability. Habitat specialists were designated 
as those that preferred mature (> 21 year median stand age) longleaf pine forests while habitat generalists were designated as having an affinity for any mature non-plantation 
pine forest habitat type. High and low dispersal distances of 1,000m and 5,000m were selected to represent the maximum dispersal abilities of a range of common reptiles and 
small mammals from southeastern US similar to methods described in Bishop-Taylor et al. (2017) and Saura et al. (2011) (Sutherland et al. 2000, Smith and Green 2005).

We used structural and functional graph theoretic metrics to quantify potential connectivity across the landscape over time. Graph theory network analysis efficiently assesses 
landscape connectivity across large study areas, incorporating both landscape structure and organism movement information to provide indices of connectivity well-suited for 
assessing landscape-level trends over time (Galpern et al. 2011, Tulbure et al. 2014, Saura et al. 2011, Minor and Urban 2008). In this approach, the landscape is represented as 
a set of discrete habitat patches, or nodes, connected by links that represent the ability of an organism to disperse between nodes (Urban and Keitt, 2001; Calabrese and Fagan 
2004). Multiple links coalesce to form dispersal paths (McIntyre et al. 2018). 

While links can be defined by the Euclidean distance between habitat nodes, where nodes are considered connected if they fall within an organism’s plausible dispersal distance, 
we defined links using least-cost paths as a measure of effective distance between nodes (Bishop-Taylor et al. 2015). Studies of potential and functional connectivity have 
commonly used least-cost paths to represent the influence of a heterogeneous landscape matrix on species dispersal ability and to more realistically reflect landscape 
permeability than Euclidean distance measures (Dilts et al. 2016). Least-cost paths use cost-distance surfaces to account for landscape resistance to movement (Bunn et al. 
2000). These cost-distance surfaces reflect the difficulty for an organism to move through each cell on the landscape and the mortality risk associated with land cover type in 
relative terms (Adriaensen et al. 2003, Theobald et al. 2006, Zeller et al. 2012). We defined resistance values based on the assumption that forest species, especially speci
alist species, will face greater dispersal difficulty as they move through land cover types with characteristics increasingly disparate from those of the forested areas where
they reside, similar to Saura et al. (2011). Our definition accounted for potential barriers to dispersal including major roads, urban infrastructure, and water bodies. A rating 
scale of 1-100 was used for resistance values, consistent with the magnitude of possible resistances found in previous studies (e.g. Stevenson-Holt et al. 2014, Shirk et al. 
2015, Blazquez-Cabrera et al. 2016, Greenwald et al. 2009). As gDistance calculates least-cost paths using conductance instead of resistance surfaces, every cell on the 
landscape was assigned a conductance value (1/resistance) based on whether the species was a habitat specialist or generalist. 

Least-cost distances were calculated between the centroids of habitat patches similar to Theobald et al. (2012) and Dickson et al. (2017) and reflect the minimum cost 
accumulated along the shortest path between two habitat nodes (van Etten 2017, Bishop-Taylor et al. 2015). Using habitat patch centroids reduced computation time and allowed us 
to simulate species movement between and within habitat patches as a continuous process rather than assuming within-patch homogenization or an abrupt end to species movement at 
a patch edge (Dickson et al. 2017). For habitat specialists, a cell on the landscape was considered habitat if at least 25% of total biomass was longleaf pine and the median 
stand age was at least 21. Habitat cells for generalist species were defined as any cell with at least 25% of biomass from longleaf pine OR at least 65% of biomass from any mix 
of pine species AND with the same median stand age requirements. Cells with 90% or more of their total biomass from loblolly pine were considered to be loblolly plantations and 
not considered habitat. 

In our study area, especially for habitat specialist species, habitat is currently clumped in the southeastern portion of the landscape, on and around Ft. Bragg. Such clumping 
can result in the ‘mega-patch’ problem as documented in Cavanaugh et al. (2014).  Mega-patches mask the relevant ecological processes and connectivity dynamics taking place on 
the landscape. For example, a simple contiguity approach to group habitat pixels into habitat patches at every time step creates several mega-patches of tens of thousands of 
hectares and inflates the connectivity of the starting landscape. Because habitat for specialist species was originally confined to a small subset of the landscape, grouping 
contiguous habitat cells into patches creates a network graph in the earliest time step(s) that appears highly connected. With no habitat currently existing outside of this 
small area, effective distances between habitat patches are very low and average patch size is fairly large, primarily due to habitat on Ft. Bragg. This approach results in an 
apparent decline in connectivity over time even after land is restored and habitat is added, because the effective distance between habitat patches increases as the habitat 
network expands geographically across the landscape and the number of habitat patches remains fairly static as individual patches began to coalesce as habitat is added. (See
habitat clustering approach explanation.docx for more detail).

To increase graph modularity based on habitat asynchrony, we then grouped habitat pixels we separately grouped contiguous habitat that co-occurred in both time steps t and t-1 
and those that only occurred in time step t for each time step and replicate using an eight-neighbor approach for each species guild to accommodate changes to connectivity
across time and space (see Supplemental Material). Doing so allowed us to treat habitat added over time as discrete habitat patches, which more realistically reflects how an 
animal would perceive spatiotemporal habitat fluctuations and better represented intra- and inter-patch movement dynamics (Hanski 1999; Wimberly 2006). Links were restricted to 
pairs of nodes with a pair-wise Euclidean distance that fell within each species group’s maximum dispersal distance. The probability of movement between patches decayed 
exponentially as inter-patch least cost path value increased. Nodes were weighted by area. 

We assessed landscape connectivity by comparing the relative change of graph theoretic metrics over time. We compared metrics of structural connectivity including the number of 
nodes, number of links, average node size, the average least cost path, and nearest neighbor Euclidean distance, graph density, along with four graph 
theoretical metrics computed in Conefor: equivalent connected area index (ECA), and three ECA subcomponents: (i) intra-patch connectivity, the connectivity contributed solely by 
the area within habitat nodes (ECAintra); (ii) the connectivity contributed by connections between neighboring nodes (ECAdirect); and (iii) connectivity contributions from 
intermediate stepping-stones that enabled longer distance dispersal (ECAstep) . Average node size and average least cost path distance were identified by finding the mean 
habitat patch size and the mean least cost path value, respectively, across replicates for each conservation strategy/time step combination. Nearest neighbor Euclidean distance 
was calculated using the spatstat package (v1.63-3) to find the distance from each habitat patch centroid to its nearest neighbor, then averaged for each conservation 
strategy/time step.

ECA measures the size of a single patch of habitat, or node, that would provide the same value of the probability of connectivity as the observed habitat network (Saura et al. 
2011). Even on a landscape with zero probability of movement between habitat patches, ECA will be never be less than the size of the largest habitat patch. The area units 
associated with ECA enable the direct comparison between changes in total habitat area to network spatial configuration to assess how the addition or loss of habitat, whether 
from land acquisition or landscape dynamics, affects connectivity (McIntyre et al. 2018). We calculated the probabilistic PC formulation of ECA (Saura and Torné 2009). ECA:Area 
is the ratio of ECA to the total habitat area of the landscape (McIntyre et al. 2018). The more optimally connected a network, the closer the ECA:Area ratio gets to 1. Together, 
these two metrics provide both an assessment of the changes in habitat connectivity relative to the changes in habitat amount on the landscape and a scaled assessment of how 
connectivity may be altered by habitat area as a proxy for habitat fragmentation (McIntyre et al. 2018, Bishop-Taylor et al. 2017). Each metric was averaged across replicates 
for each conservation strategy/species type combination.

Habitat node clustering figure:

<img src="./nodes cluster.PNG" width="80%" />


To reduce processing time and memory requirements:

Follow these steps to dissolve polygons into larger habitat patches based on 8-neighbor approach: (https://community.esri.com/thread/111641)
* Create a BUFFER of small distance (name of the new shapefile: data_buffer.shp)
* DISSOLVE the new shapefile (uncheck create multipart features) (name of the new shapefile: data_buffer_dissolve.shp)
* Use the INTERSECT tool: intersect data.shp + data_buffer_dissolve.shp (name of the new shapefile: data_buffer_dissolve_intersect.shp)
* DISSOLVE data_buffer_dissolve_intersect.shp. The dissolve field is the FID of data_buffer_dissolve.shp and this time you do check create multipart features. Name of the final shapefile (data_def.shp)


8-neighbor connection of contiguous habitat cells to form nodes
Least Cost Path with single spp, single strat, single time step resistance distance validation
