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
data.sub <- rbind(data[data$fips == '24510',], 
                      data[data$fips == '06037',])

data.motorVehTy <- SCC[grep("Vehicles",SCC$SCC.Level.Two),]
data.motorVehTy.merge <- merge(data.sub,data.motorVehTy,by="SCC")
splitYeart.sum <- aggregate(Emissions ~ year+fips,data = data.motorVehTy.merge,
                            FUN = function(data.motorVehTy.merge)
                                    c(nonpoint=sum(data.motorVehTy.merge)))
splitYeart.sum$Emissions <- splitYeart.sum$Emissions /1000

splitYeart.sum$fips[splitYeart.sum$fips=='06037']<-"Los Angeles County"
splitYeart.sum$fips[splitYeart.sum$fips=='24510']<-"Baltimore City"
names(splitYeart.sum) <- gsub("fips", "Locations", names(splitYeart.sum))

## Plot 6
ggplot(data=splitYeart.sum,aes(year, Emissions, colour = Locations)) + geom_line() + 
        scale_x_continuous(breaks=sort(unique(splitYeart.sum$year)))+
        ggtitle("Emissions from motor vehicle sources \nin Baltimore City and Los Angeles County") +
        ylab("Emissions (Kilotons)")

dev.copy(png, file = "./data/plot6.png")
dev.off()
