cluster_e <- reord_stands_cluster_ha[1:1573,]
econ_e <- reord_stands_econ_ha[1:2128,]
geo_e <- reord_stands_geo_ha[1:1539,]
rand_e <- reord_stands_base_ha[1:1582,]


cost <- reord_stands_econ_ha[,c(2,12)]

colnames(cluster_e) <- c("X", "gridcode", "prob_vec", "area_vec", "area_ha", "cum_area_ha")
cluster_cost <- merge(cluster_e, cost, by.x = "gridcode", all.x =FALSE)

colnames(geo_e) <- c("X", "gridcode", "diversity_vec", "area_vec", "Prob", "area_ha", "cum_area_ha")
geo_cost <- merge(geo_e, cost, by.x = "gridcode", all.x =FALSE)

rand_e<- rand_e[,c(2,13,14)]
colnames(rand_e) <- c("gridcode", "area_ha", "cum_area_ha")
rand_cost <- merge(rand_e, cost, by.x = "gridcode", all.x =FALSE)

#rows<- sample(nrow(econ_e), replace=FALSE)
#econ_e <- econ_e[rows,]
#econ_e <- econ_e[1:2085,]

econ_e <- econ_e[1:1760,]

mean(cluster_cost$cost_ha)
mean(geo_cost$cost_ha)
mean(rand_cost$cost_ha)
mean(econ_e$cost_ha)

