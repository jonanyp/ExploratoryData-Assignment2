require("downloader")
require("reshape2")

## Download and unzip dataset

# Verification of the directory to datas
if(!file.exist("data")) dir.create("./data")

fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
download(fileURL, destfile = "./data/datapack.zip", mode = "wb")
unzip("./data/datapack.zip", exdir = "./data/")

## Load dataset
NEI <- readRDS("./data/summarySCC_PM25.rds")

## Reshaping
splitYear.sum <- aggregate(Emissions ~ year, data = NEI,sum)

# Reduce the range of the emissions
splitYear.sum$Emissions <- sumByYears$Emissions /1000
#View(splitYear.sum)

## Plot 1
with(splitYear.sum, plot(year,Emissions, ylab="Emissions (Kilotons)", xaxt="n", type='l', 
                         main = "Emissions from PM(2.5)"))

axis(1, at = splitYear.sum$year, labels = splitYear.sum$year)
dev.copy(png, file = "./data/plot2.png")
dev.off()