

datalocation <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

# Download the data if it doesn't already exist in  rawdata folder
if (file.exists("./rawData/household_power_consumption.zip") || file.exists("./rawData/household_power_consumption.txt")) {
  message("== Data file exists, skipping the download \r")
  
} else {
  if (! (file.exists("./rawData/"))) {
      message("== Create the data folder \r")
      dir.create("./rawData/")
    }
  download.file(url=datalocation,destfile="./rawData/household_power_consumption.zip",method="wget")
  
}

# unzip the data from file and assign into a variable for only the valaid date range
if (file.exists("./rawData/household_power_consumption.txt")) {
  message("== Data file exists, skipping extraction\r")
} else {
  message("== Extracting data \r")
  unzip(zipfile="./rawData/household_power_consumption.zip",exdir="./rawData/",)  
}


data <- read.table(file="./rawData/household_power_consumption.txt",sep=";",header=FALSE,na.strings="?",nrows=2880,skip=66637)
colnames(data) <- c("date","time","GlobalActivePower","GlobalReactivePower","Voltage","GlobalIntensity","SubMetering1","SubMetering2","SubMetering3")


data$datetime <- strptime(paste(data$date,data$time, sep = " "), format = "%d/%m/%Y %H:%M:%S")
data$date <- as.Date(data$date,format="%d/%m/%Y")

# Plot the data on screen and then copy the plot as plot1.png

hist(data$GlobalActivePower,col="red",main="Global Active Power",xlab="Global Active Power (kilowatts)")
dev.copy(png, file="./plot1.png", width = 480, height = 480)

dev.off()




