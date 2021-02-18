To reduce processing time and memory requirements:

Follow these steps to dissolve polygons into larger habitat patches based on 8-neighbor approach: (https://community.esri.com/thread/111641)
* Create a BUFFER of small distance (name of the new shapefile: data_buffer.shp)
* DISSOLVE the new shapefile (uncheck create multipart features) (name of the new shapefile: data_buffer_dissolve.shp)
* Use the INTERSECT tool: intersect data.shp + data_buffer_dissolve.shp (name of the new shapefile: data_buffer_dissolve_intersect.shp)
* DISSOLVE data_buffer_dissolve_intersect.shp. The dissolve field is the FID of data_buffer_dissolve.shp and this time you do check create multipart features. Name of the final shapefile (data_def.shp)
Minimum habitat threshold of 2 hectares 
8-neighbor connection of contiguous habitat cells to form nodes
Least Cost Path with single spp, single strat, single time step resistance distance validation
