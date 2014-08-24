require("downloader")
require("reshape2")
require("ggplot2")
## Download and unzip dataset

# Verification of the directory to datas
if(!file.exist("data")) dir.create("./data")

fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
download(fileURL, destfile = "./data/datapack.zip", mode = "wb")
unzip("./data/datapack.zip", exdir = "./data/")

## Load dataset
NEI <- readRDS("./data/summarySCC_PM25.rds")
SCC <- readRDS("./data/Source_Classification_Code.rds")

## Reshaping
data <- transform(NEI, type = factor(type))
data.subset <- subset(NEI, fips == 24510)

data.motorVehTy <- SCC[grep("Vehicles", SCC$SCC.Level.Two),]
data.motorVehTy.merge <- merge(data.subset,data.motorVehTy,by="SCC")
splitYear.sum <- aggregate(Emissions ~ year, data = data.motorVehTy.merge, sum)

## Plot 5
ggplot(data = splitYear.sum, aes(year, Emissions)) + geom_line() +
        scale_x_continuous(breaks = sort(unique(splitYear.sum$year)))+
        ggtitle("Emissions from motor vehicle sources \nIn Baltimore") +
        ylab("Emissions (Kilotons)")
dev.copy(png, file = "./data/plot5.png")
dev.off()