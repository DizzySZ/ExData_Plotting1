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

## Plot 3: Time by Energy sub metering (sorted by 3 submeters)
png(filename = "plot3.png")
with(data, plot(datetime, Sub_metering_1,
                type = "l",
                ylab = "Energy submetering"))
lines(data$datetime, data$Sub_metering_2, type = "l", col = "red")
lines(data$datetime, data$Sub_metering_3, type = "l", col = "blue")
legend("topright", 
       pch = "-",
       col = c("black", "red", "blue"),
       legend = c("Submeter 1", "Submeter 2","Submeter 3"))
dev.off()