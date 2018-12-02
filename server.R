library(maptools)
data(wrld_simpl)
myCountries = wrld_simpl@data$NAME %in% c("Australia", "United Kingdom", "Germany", "United States", "Sweden", "Netherlands", "New Zealand")
plot(wrld_simpl, col = c(gray(.80), "red")[myCountries+1])
