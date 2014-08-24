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

## Reshaping
data <- transform(NEI, type = factor(type))
data.subset <- subset(NEI,fips == 24510)
splitYeart.sum <- aggregate(Emissions~year+type, data=data.subset,
                            FUN = (data.subset) c(nonpoint=sum(data.subset)))
splitYeart.sum$Emissions <- splitYeart.sum$Emissions /1000

## Plot 3
ggplot(data=splitYeart.sum,aes(year, Emissions, colour=type)) + geom_line() +
        scale_x_continuous(breaks = sort(unique(splitYeart.sum$year)))+ 
        ggtitle("Type of emission \nin for Baltimore City")+
        ylab("Emissions (Kilotons)")

dev.copy(png, file = "./data/plot3.png")
dev.off()