library(data.table)

#########################################################
## Read data
#########################################################
zipFile <- "exdata_data_household_power_consumption.zip"
dataFile <- "household_power_consumption.txt"

# if the data file is not present, download and extract it
if(!file.exists(dataFile)) {
  download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",
                zipFile)
  unzip(zipFile)
}

# read the data file, subset the 1st and 2nd of february.
# Create a unique DateTime column from Date and Time.
householdPwC <- fread(input=dataFile, na.strings="?")[grep("^[12]/2/2007",Date),
                                                      .(Datetime=as.POSIXct(strptime(paste(Date,Time),"%d/%m/%Y %H:%M:%S")),
                                                        Global_active_power,Global_reactive_power,
                                                        Voltage,Global_intensity,
                                                        Sub_metering_1,Sub_metering_2,Sub_metering_3)]


#########################################################
## construct and write plot
#########################################################

# change locale to print dates in English 
Sys.setlocale("LC_TIME",locale="English")

png(file="plot2.png")

with(householdPwC,plot(x=Datetime,y=Global_active_power,
                       type="l",
                       xlab="", ylab="Global Active Power (kilowatts)"))

dev.off()

# Back to default locale
Sys.setlocale("LC_TIME",locale="")
