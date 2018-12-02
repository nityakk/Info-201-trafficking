## setwd("~/Nitya/Au18/INFO-201/info-201-trafficking")

source("~/Nitya/Au18/INFO-201/keys.R")
library(httr)
library(jsonlite)
library(dplyr)

base_uri <- "https://data.dol.gov/get/SweatToilAllLegalStandards/format/json"
sweat_toil_response <- GET(base_uri,
                add_headers("X-API-KEY" = dol.key))
sweat_toil_body <- content(sweat_toil_response, "text")
sweat_toil_data <- fromJSON(sweat_toil_body)

