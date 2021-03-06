#author: Divyansh 

#Loading packages
library(readr)
#install.packages("sp")
library(sp)
require(data.table)

## Extracting data 
location <- read_csv("~/Desktop/location.csv")
stations <- read_csv("~/Desktop/stations.csv")

#Removing rows with invalid na values from station data
location <- na.omit(location)
location$ID <- seq.int(nrow(location))

latL <- location$Lat
lngL <- location$Lng
latS <- stations$Lat
lngS <- stations$Lng
rowsL <- nrow(location)
rowsS <- nrow(stations)

locationCoord <- cbind(lngL,latL)
locationPoint <- SpatialPoints(locationCoord)

stationCoord <- cbind(lngS,latS)
stationPoint <- SpatialPoints(stationCoord)

#Getting vector between location and stations
proc <- spDistsN1(locationPoint[1,], stationPoint[1,], longlat = FALSE)

pairedData <- data.frame(Lng=numeric(), 
                         Lat=numeric(),
                         Station=character(),
                         City=character(),
                         State=character(),
                         Metro=character(),
                         Country=character(),
                         stringsAsFactors = FALSE)

#Location data is smaller than stations so need only stations for some locations
for (l in 1:rowsL){
  Dists <- spDistsN1(pts = stationPoint, locationPoint[l,] )
  #Nearest Distance index
  Nearest <- which(Dists == min(Dists))
  #Filling data frame for locations with station codes
  pairedData[l,] <- c(location[l,]$Lat, location[l,]$Lng, stations[Nearest,]$Station, location[l,]$City, location[l,]$State, location[l,]$Metro,location[l,]$Country)  
  
}
#writing CSV
write.csv(pairedData, file = "LocationwithStationCode.csv",row.names=FALSE)
