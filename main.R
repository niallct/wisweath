raw <- read.csv("https://www.cl.cam.ac.uk/research/dtg/weather/weather-raw.csv", header = FALSE, col.names= c("date", "temp10", "humid", "dewp10", "press", "meanwind","winddir", "sun", "rain", "maxwind"))
raw$jdate <- as.Date(raw$date)

# rain in in mm * 1000 (micrometres)
# sun is hours * 100 (centihours)
# temps are C * 10 (decicelcius) 

# CONFIGURATION
currentyear = 2022
numyears = 5
drythreshold = 100 # micrometres of rain which counts as a 'dry' day

# GENERATE DAILY TOTALS
foo <- tapply(raw$rain , raw$jdate, sum) # rain is expressed by mcm in each half hour block, need to sum
rain <- data.frame(totalrain=foo, date = names(foo))

foo <- tapply(raw$sun , raw$jdate, sum)  # sun in expressed in ch in each half hour block, need to sum
sun <- data.frame(totalsun=foo, date = names(foo))

foo <- tapply(raw$temp10 , raw$jdate, max) # temp is the instantaneous temp in decicelcius, need daily max
maxt <- data.frame(maxtemp=foo, date = names(foo))

all <- merge(merge(sun,rain), maxt) # mash into one df

all$isdry <- all$totalrain<=drythreshold # check whether it is a dry day
all$actualDate <- as.Date(all$date) # date mashing

# APPLY FORMULA
# I = 20 (T_x - 12) + (S - 400)/3 + 2Rd + (250 - R) / 3
# 1 May to 30 Aug

indices <- data.frame()
yearrange = seq(currentyear,currentyear-numyears)
for (yoi in yearrange){

  startdate = as.Date(paste(yoi,"-05-01", sep=""))
  enddate = as.Date(paste(yoi,"-08-31", sep=""))
  thisyear = subset(all, actualDate <= enddate &
                      actualDate >= startdate)
  
  yearavgtemp <- mean(thisyear$maxtemp) / 10 # mean temp and convert to whole degrees
  yearsuntotal <- sum(thisyear$totalsun) / 100 # sum sun time and convert to hours
  yeardrydays <- sum(thisyear$isdry) # sum dry days
  yearraintotal <- sum(thisyear$totalrain) / 1000 # sum rain amount and convert to mm
  
  index = 20 * (yearavgtemp -12) +
    (yearsuntotal - 400) / 3 +
    2 * yeardrydays +
    (250 - yearraintotal) / 3
  
  indices <- rbind(indices, data.frame(year=yoi,index=round(index)))
  #print(index)
  }

print(indices)
