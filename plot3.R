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

# Clean the data in correct date time repr and prepare data for plotting.
data$datetime <- strptime(paste(data$date,data$time, sep = " "), format = "%d/%m/%Y %H:%M:%S")
data$date <- as.Date(data$date,format="%d/%m/%Y")

## Plot the data to screen, copy it to png device and save the plot as plot3.png


with(data, plot(y=SubMetering1,x=datetime, type = "n",xlab ="", ylab="Energy sub metering"))
with(data, lines(y=SubMetering1,x=datetime,col="black"))
with(data, lines(y=SubMetering2,x=datetime,col="red"))
with(data, lines(y=SubMetering3,x=datetime,col="blue"))
legend("topright",lty="solid",col = c("black","red","blue"),legend=c("Sub_meter1","Sub_meter2","Sub_meter3"), text.width = strwidth("1,000,000,000,000,000"), xjust = 0, yjust = 1)
dev.copy(png, file="./plot3.png", width = 480, height = 480)

dev.off()

