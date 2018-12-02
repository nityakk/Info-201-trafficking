## setwd("~/Nitya/Au18/INFO-201/info-201-trafficking")

source("keys.R")

library(httr)
library(jsonlite)
library(dplyr)

base_uri <- "https://data.dol.gov/get/SweatToilAllStatistics/limit/200"
sweat_toil_response <- GET(url = base_uri, add_headers("X-API-KEY"= dol.key))
sweat_toil_body <- content(sweat_toil_response, "text")
sweat_toil_data <- fromJSON(sweat_toil_body)
