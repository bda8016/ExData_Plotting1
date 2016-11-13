

#-------------------------------------- DOWNLOAD AND FORMAT THE DATA --------------------------------#

#Download and unzip the file into my working directory: 
  url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
    temp <- tempfile()
      download.file(url, temp)
        unzip(temp, "household_power_consumption.txt")

#Import the data into R using read_csv2 from the readr package.  readr import functions allow specification of which rows to import.
  library(readr)
    power <- read_csv2("household_power_consumption.txt", col_names = TRUE, skip = 0, n_max = 70000)  #--> 70k rows captures the needed data; subset more precisely below
  
        
#Convert to a data frame:
  power <- data.frame(power)

#Convert the Date column to standard date format:
  power$Date <- strptime(power$Date, format = '%d/%m/%Y')   #--> strptime converts character vectors to POSIXlt; dd/mm/YYYY is the format the date was originally in
    power$Date <- as.POSIXct(power$Date)                    #--> POSIXct format is necessary to filter on date values in the next step
      head(power)
      str(power)
    
#Filter the rows to only pull Feb 1 - 2 then combine the two dates into one data frame:
  library(dplyr)
    power_one <- filter(power, Date == "2007-02-01")        #--> couldn't combine these two filter criteria into one call for some reason
    power_two <- filter(power, Date == "2007-02-02")
      power <- rbind(power_one, power_two)
        str(power)
        
#Coerce all power measurement columns to numeric then cbind with the Date/Time columns:
  power_measurements <- sapply(power[ ,3:9], as.numeric)
    power <- cbind(power[ ,1:2], power_measurements)
  
#View summary measures:
  summary(power)
  head(power)
  tail(power)
    
  
  
#---------------------------------------- CREATE THE PNG PLOT ---------------------------------------#
  
#Activate the png graphics device:
  png(file = "plot3.png", width = 480, height = 480)
    
#Create the basic plot without labeling on the x-axis.  type = "l" specifies a line with no points:
  plot(power$Sub_metering_1, type = "l", ylab = "Energy sub metering", xlab = "", xaxt = "n")
    
#Add Sub_metering_2 and Sub_metering_3:
  lines(power$Sub_metering_2, type = "l", col = "orange")
    lines(power$Sub_metering_3, type = "l", col = "blue")
  
#Legend
  legend("topright", legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), col = c("black", "orange", "blue"), lwd = 1)
    
#Create tick marks and customize the x axis:
  tick1 <- 1
    tick2 <- nrow(power)/2
      tick3 <- nrow(power)
        ticks <- c(tick1, tick2, tick3)
          axis(1, at = ticks, labels = c("Thurs", "Fri", "Sat"))
  
#Turn off the png graphics device:
  dev.off()
  
      

  
  
  