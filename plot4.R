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

## Plot 4: 4 sub-plots (Time x GAP, datetime x Voltage, 
## Time x Energy by submetering, datetime x Global Reactive power)
png(filename = "plot4.png")
par(mfrow = c(2,2))
with(data, {
  plot(datetime, Global_active_power, 
       type = "l",
       ylab = "Global Active Power (kilowatts)")
  
  plot(datetime, Voltage, type = "l",
       ylab = "Voltage")
  
  plot(datetime, Sub_metering_1,
       type = "l",
       ylab = "Energy submetering")
  lines(datetime, Sub_metering_2, type = "l", col = "red")
  lines(datetime, Sub_metering_3, type = "l", col = "blue")
  legend("topright", 
         cex = 0.7,
         bty = "n",
         lty = rep(1,3),
         col = c("black", "red", "blue"),
         legend = c("Submeter 1", "Submeter 2","Submeter 3"))
  
  plot(datetime, Global_reactive_power,
       type = "l",
       ylab = "Energy submetering")
  
})
dev.off()



