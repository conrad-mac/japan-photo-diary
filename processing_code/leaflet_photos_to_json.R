library(tidyverse)
library(jsonlite)
library(placement)
library(googlesheets)

getLong <- function(x){
    tmp <- geocode_url(x, auth="standard_api", privkey="",
                       clean=TRUE, add_date='today', verbose=TRUE)
    
    return(tmp[,2])
}

getLat <- function(x){
    tmp <- geocode_url(x, auth="standard_api", privkey="",
                       clean=TRUE, add_date='today', verbose=TRUE)
    
    return(tmp[,1])
}

getLocation <- function(x){
    tmp <- geocode_url(x, auth="standard_api", privkey="",
                      clean=TRUE, add_date='today', verbose=TRUE)
    
    tmp2 <- dplyr::select(tmp, locations, lat, lng)
    
    return(tmp2)
}

# x <- read_csv("leaflet_photos.csv") %>%
#     mutate(
#         url = ifelse(is.na(url), "", url)
#         ,video = ifelse(is.na(video), "", video)
#         ,caption = ifelse(is.na(caption), "", caption)
#     )

x <- gs_read(gs_title("leaflet_photos"))  %>%
        mutate(
            url = ifelse(is.na(url), "", url)
            ,video = ifelse(is.na(video), "", video)
            ,caption = ifelse(is.na(caption), "", caption)
        )

# lat_vector <- getLat(x$location_name)
# long_vector <- getLong(x$location_name)

long_lat <- geocode_url(paste0(unique(x$location_name)), privkey = "")

# y <- cbind(x, lat = lat_vector, lng = long_vector)

y <- left_join(x, long_lat, by = c("location_name" = "locations"))

z <- toJSON(y, pretty = TRUE)

writeLines(paste('var mapData = { rows:', z, '};'), "leaflet_photos.json")
