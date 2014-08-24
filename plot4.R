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
data.mCT <- merge(SCC[grep("Comb", SCC$Short.Name),],
                    SCC[grep("Coal", SCC$Short.Name),])
data.mCO <- merge(data,data.mCT,by = "SCC")
splitYear.sum <- aggregate(Emissions ~ year, data = data.mCO, sum)
splitYear.sum$Emissions <- splitYear.sum$Emissions /1000

## Plot 4
ggplot(data=splitYear.sum,aes(year, Emissions)) + geom_line() +
        scale_x_continuous(breaks = sort(unique(splitYear.sum$year)))+
        ggtitle("Emissions from \ncoal combustion-related sources \nin United States") +
        ylab("Emissions (Kilotons)")
dev.copy(png, file = "./data/plot4.png")
dev.off()
