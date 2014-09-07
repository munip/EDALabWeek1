

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

## Plot the data on screen, copy to png and save the plot as plot4.png

with(data, plot(y=Voltage,x=datetime, type="n"))
par(mfrow=c(2,2))

#subplot 1,1
with(data, plot(y=GlobalActivePower,x=datetime, type = "n",xlab ="", ylab="Global Active Power (kilowatts)"))
with(data, lines(y=GlobalActivePower,x=datetime))

#subplot 1,2

with(data,plot(y=Voltage,x=datetime, type = "n" ))
with(data, lines(y=Voltage,x=datetime,col="black"))


#subplot 2,1

with(data, plot(y=SubMetering1,x=datetime, type = "n",xlab ="", ylab="Energy sub metering"))
with(data, lines(y=SubMetering1,x=datetime,col="black"))
with(data, lines(y=SubMetering2,x=datetime,col="red"))
with(data, lines(y=SubMetering3,x=datetime,col="blue"))
legend("topright",lty="solid",col = c("black","red","blue"),legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3"), text.width = strwidth("1,000,000,000,000"), xjust = 0, yjust = 1)

#subplot 2,2

with(data,plot(y=GlobalReactivePower,x=datetime, type = "n" ,ylab = "Globle_reactive_power"))
with(data, lines(y=GlobalReactivePower,x=datetime,col="black"))
dev.copy(png, file="./plot4.png")
dev.off()


