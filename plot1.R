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

## Plot 1: Global Active Power (GAP by Frequency)
png(filename = "plot1.png")
hist(data$Global_active_power, 
     col = "red", 
     xlab = "Global Active Power (kilowatts)",
     main = "Global Active Power")
dev.off()
