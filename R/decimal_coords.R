## calculate decimal coords


decimal_from_deg_min <- function(degrees, minutes, point){
  
  # if(point == "[sS]"|point == "[wW]")
  
  decimal <- degrees + minutes / 60
  
  
  
  return(decimal)
  
}

decimal_from_en <- function(easting, northing){
  require(jsonlite)
  #uses https://webapps.bgs.ac.uk/data/webservices/convertForm.cfm
  e <- easting
  e <- ifelse(nchar(e) == 5, as.numeric(paste0(e, 0)), e)
  e <- ifelse(nchar(e) == 4, as.numeric(paste0(e, 00)), e)
  
  n <- northing
  n <- ifelse(nchar(n) == 5, as.numeric(paste0(n, 0)), n)
  n <- ifelse(nchar(n) == 4, as.numeric(paste0(n, 00)), n)
  
  uri <-"https://webapps.bgs.ac.uk/data/webservices/CoordConvert_LL_BNG.cfc?method=BNGtoLatLng"
  
  url <- paste0(uri, "&easting=", e, "&northing=", n)
  
  out <- fromJSON(url)
  lat <- out$LATITUDE[1]
  long <- out$LONGITUDE[1]
  result <- data.frame(lat = lat, long = long)
  
}

