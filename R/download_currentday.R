# Function to download daily met data, format it and save it on the disk

#### AEMET
downloadAEMETcurrentday <- function(api, daily = TRUE, verbose=TRUE){
  # # Utilitary functions
  # nonUTF8 = "\u00D1\u00C0\u00C1\u00C8\u00C9\u00D2\u00D3\u00CC\u00CD\u00DC\u00CF"
  # cname.func <- function(x){
  #   regmatches(x,gregexpr('(?<=\\n\\s{2}\\")[[:print:]]+(?=\\"\\s\\:)', x, perl = T))[[1]]
  # }
  # value.func <- function(x){
  #   value <- regmatches(x,gregexpr(paste0("(?<=\\:\\s)([[:print:]]|[",nonUTF8,"])*(?=\\n)"), x, perl = T))[[1]]
  #   value <- gsub('\\",', "", value)
  #   value <- gsub('\\"', "", value)
  #   value <- gsub(',', "", value)
  # }
  # 
  # 
  # # set options
  # h = new_handle()
  # handle_setheaders(h, "Cache-Control" = "no-cache", api_key=api)
  # handle_setopt(h, ssl_verifypeer=FALSE)
  # handle_setopt(h, customrequest="GET")
  # 
  # url <- "https://opendata.aemet.es/opendata/api/observacion/convencional/todas"
  # # get data url
  # urldata_raw <- curl_fetch_memory(url, h)$content
  # urldata_string <- value.func(rawToChar(urldata_raw))
  # 
  # if(urldata_string[2]=="401"){
  #   stop("Invalid API key. (API keys are valid for 3 months.)")
  # }
  # 
  # urldata <- urldata_string[3]
  # 
  # if(verbose)cat("Downloading hourly data from all available stations")
  # data_raw <- curl_fetch_memory(urldata, h)$content
  # 
  # if(verbose)cat("\nFormating data")
  # data_string <- rawToChar(data_raw)
  # #Add local encoding information to data_string
  # # Encoding(data_string) <-"latin1"
  # enclocal <- l10n_info()
  # if(enclocal[[2]]) Encoding(data_string) <-"UTF-8"
  # else if(enclocal[[3]]) Encoding(data_string) <-"latin1"
  # data_string <- strsplit(data_string,"}\\,\\s{1}\\{")[[1]]
  # cname <- lapply(data_string,FUN = cname.func)
  # value <- lapply(data_string,FUN = value.func)
  # value <- mapply(FUN = function(x,y){names(x) <- y;return(x)}, x = value,y = cname)
  # unique_cname <- cname[[which.max(sapply(cname,FUN = length))]]
  # value <- mapply(FUN = function(x,y){x[y]}, x = value, y = list(unique_cname))
  # 
  # data_df <- data.frame(matrix(t(value), ncol = length(unique_cname), dimnames = list(NULL, unique_cname)),
  #                       stringsAsFactors = F)
  
  if(verbose)cat("Downloading hourly data from all available stations")
  apidest = "/api/observacion/convencional/todas"
  data_df = .get_data_aemet(apidest, api)
  
  if(verbose)cat("\nFormating data")
  varnames <-c("idema", "lon","lat", "ubi", "alt", "fint", "ta", "tamin", "tamax",  "prec", "hr", "dv", "vv")
  data_df <- data_df[,varnames]
  numvar <- c("lon","lat","alt","ta", "tamin", "tamax",  "prec", "hr", "dv", "vv")
  data_df[,numvar] <- sapply(data_df[,numvar],as.numeric)
  data_df$fint <- as.POSIXlt(sub("T", " ",data_df$fint), format = "%Y-%m-%d %H:%M:%S")
  
  if(daily){
    if(verbose)cat("\nAggregating hourly data to 24h-scale\n")
    options(warn=-1)
    data_agg <- aggregate(data_df[,numvar],list(idema = data_df$idema, ubi = data_df$ubi), 
                          function(x){mean<-mean(x,na.rm=T);min<-min(x,na.rm=T);max<-max(x,na.rm=T);sum<-sum(x,na.rm=T)
                          return(c(mean=mean,min=min,max=max,sum=sum))})
    # wind direction
    dv_agg <- aggregate(list(dv = data_df$dv),list(idema = data_df$idema, ubi = data_df$ubi),
                        function(dvvec){
                          y = sum(cos(dvvec*pi/180), na.rm=TRUE)/length(dvvec)
                          x = sum(sin(dvvec*pi/180), na.rm=TRUE)/length(dvvec)
                          dv = (180/pi)*atan(y/x)
                          dv[dv<0] <- dv[dv<0]+360
                          return(dv)
                        })
    options(warn=0)
    data_df <- data.frame(ID = as.character(data_agg$idema), name = data_agg$ubi, 
                          long = data_agg$lon[,"mean"],lat = data_agg$lat[,"mean"], elevation = data_agg$alt[,"mean"],
                          MeanTemperature = data_agg$ta[,"mean"], MinTemperature = data_agg$ta[,"min"], MaxTemperature = data_agg$ta[,"max"],
                          Precipitation = data_agg$prec[,"sum"], WindSpeed = data_agg$vv[,"mean"], WindDirection = dv_agg$dv,
                          MeanRelativeHumidity = data_agg$hr[,"mean"], MinRelativeHumidity = data_agg$hr[,"min"], MaxRelativeHumidity = data_agg$hr[,"max"])

    data_df <- as.data.frame(lapply(data_df,function(x){
      x. <- x
      if(is.numeric(x.))x.[is.nan(x.)|is.infinite(x.)] <- NA
      return(x.)
      }))
    
    data_sp <- SpatialPointsDataFrame(coords = data_df[,c("long", "lat")],
                                      data = data_df[,which(!colnames(data_df) %in% c("long", "lat", "name", "ID"))],
                                      proj4string = CRS("+proj=longlat"))
    row.names(data_sp) <- data_df$ID
    return(data_sp)
  }else{
    if(verbose)cat("\nHourly results are returned\n")
    colnames(data_df) <- c("ID", "long", "lat", "name", "elevation", "date", 
                           "MeanTemperature", "MinTemperature", "MaxTemperature",
                           "Precipitation", "MeanRelativeHumidity", "WindDirection", "WindSpeed")
    return(data_df)
  }
}



#### SMC
# download the variables metadata
downloadSMCvarmetadata <- function(api){
  apidest <- "/variables/mesurades/metadades"
  data <- .get_data_smc(apidest,api)
  rownames(data) <- data$codi
  return(data)
}

# SMCvarcode_df <- downloadSMCvarmetadata(api)
# save(SMCvarcode_df, file ="data/SMCvarcode_df.RData")
# SMCstation_sp <- downloadSMChistoricalstationlist(api)
# save(SMCstation_sp, file = "data/SMCstation_sp.RData")
# download the met data
downloadSMCcurrentday <- function(api, meteoland_output=TRUE, variable_code=NULL, station_ID=NULL, date = Sys.Date(), verbose=TRUE){

  load("data/SMCvarcode_df.RData")
  load("data/SMCstation_sp.RData")
    
  if(meteoland_output==T) variable_code <- c(30:33,35) else if(is.null(variable_code)) stop("variable_code must be specified")
  
  if(verbose)cat("Downloading hourly data from all available stations")
  date_split <- strsplit(as.character(date), split = "-")[[1]]
  
  # download variable per variable
  for(i in 1:length(variable_code)){
    apidest <- paste("/variables/mesurades", variable_code[i], date_split[1], date_split[2], date_split[3], sep = "/")
    if(!is.null(station_ID)){apidest<-paste0(apidest,"?codiEstacio=", station_ID)}
    data_list <- .get_data_smc(apidest, api)
    data_list$variables <- sapply(data_list$variables, FUN = function(x)x$lectures)
    
    data_i <- data.frame()
    for(j in 1:length(data_list$codi)){
      data_j <- data_list$variables[[j]][,c("data", "valor")]
      data_j$ID <- data_list$codi[[j]]
      data_i <- rbind(data_i,data_j)
    }
    
    colnames(data_i) <- c("date", as.character(variable_code[i]), "ID")
    if(i == 1) {data <- data_i}else{data <- merge(data, data_i, all=T)}
  }


  
  if(verbose)cat("\nFormating data")
  colsel <- !colnames(data) %in% c("date", "ID")
  colnames(data)[colsel] <- SMCvarcode_df[colnames(data)[colsel], "nom"]
  data$date <- sub("T", " ", data$date)
  data$date <- sub("Z", "", data$date)
  data$date <- as.POSIXlt(sub("T", " ",data$date), format = "%Y-%m-%d %H:%M")
  
  if(meteoland_output){
    if(verbose)cat("\nAggregating hourly data to 24h-scale\n")
    options(warn=-1)
    data$date <- as.Date(data$date)
    numvar <- !colnames(data) %in% c("date", "date", "ID")
    
    data_agg <- aggregate(data[,numvar],list(ID = data$ID), 
                          function(x){mean<-mean(x,na.rm=T);min<-min(x,na.rm=T);max<-max(x,na.rm=T);sum<-sum(x,na.rm=T)
                          return(c(mean=mean,min=min,max=max,sum=sum))})
    
    # wind direction
    dv_agg <- aggregate(list(dv = data$`Direcció de vent 10 m (m. 1) `),
                        list(ID = data$ID),
                        function(dvvec){
                          y = sum(cos(dvvec*pi/180), na.rm=TRUE)/length(dvvec)
                          x = sum(sin(dvvec*pi/180), na.rm=TRUE)/length(dvvec)
                          dv = (180/pi)*atan(y/x)
                          dv[dv<0] <- dv[dv<0]+360
                          return(dv)
                        })
    options(warn=0)
    data_df <- data.frame(ID = data_agg$ID, name = SMCstation_sp@data[data_agg$ID,"name"], 
                          long = SMCstation_sp@coords[data_agg$ID,"long"],lat = SMCstation_sp@coords[data_agg$ID,"lat"], elevation = SMCstation_sp@data[data_agg$ID,"elevation"],
                          MeanTemperature = data_agg$Temperatura[,"mean"], MinTemperature = data_agg$Temperatura[,"min"], MaxTemperature = data_agg$Temperatura[,"max"],
                          Precipitation = data_agg$Precipitació[,"sum"], WindSpeed = data_agg$`Velocitat del vent a 10 m (esc.)`[,"mean"], WindDirection = dv_agg$dv,
                          MeanRelativeHumidity = data_agg$`Humitat relativa`[,"mean"], MinRelativeHumidity = data_agg$`Humitat relativa`[,"min"], MaxRelativeHumidity = data_agg$`Humitat relativa`[,"max"])
    
    data_df <- as.data.frame(lapply(data_df,function(x){
      x. <- x
      if(is.numeric(x.))x.[is.nan(x.)|is.infinite(x.)] <- NA
      return(x.)
    }))
    
    data_sp <- SpatialPointsDataFrame(coords = data_df[,c("long", "lat")],
                                      data = data_df[,which(!colnames(data_df) %in% c("long", "lat", "name", "ID"))],
                                      proj4string = CRS("+proj=longlat"))
    row.names(data_sp) <- data_df$ID
    return(data_sp)
  }else{
    if(verbose)cat("\nHourly results are returned\n")
    colnames(data_df) <- c("ID", "long", "lat", "name", "elevation", "date", 
                           "MeanTemperature", "MinTemperature", "MaxTemperature",
                           "Precipitation", "MeanRelativeHumidity", "WindDirection", "WindSpeed")
    return(data_df)
  }
}