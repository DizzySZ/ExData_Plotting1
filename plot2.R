if (!file.exists("household_power_consumption.txt")){
  temp <- tempfile()
  dataURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
  download.file(dataURL, temp)
  data <- unzip(temp,exdir = ".")
  unlink(temp) 
}

library(sqldf)
library(ggplot2)
#reading in only data that's required using SQL arguments
data <- read.csv.sql("household_power_consumption.txt", 
                     sql = "select * from file where Date = '1/2/2007' or Date = '2/2/2007'",
                     sep = ";")

#create new variable combining date + time columns and converts it to date class.
data$datetime <- strptime(paste(data$Date, data$Time), format = "%d/%m/%Y %H:%M:%S")


## Plot 2: Time by GAP (line graph)
png(filename = "plot2.png")
with(data, plot(datetime, Global_active_power, 
                type = "l",
                ylab = "Global Active Power (kilowatts)"))
dev.off()