#download then unzip
download.file(url='https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip',destfile='fnei.zip')
unzip('fnei.zip')
#Read
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")
#Merge
#merged<-merge(NEI,SCC,by.x='SCC',by.y='SCC',all=FALSE)

#Get SCC for coal-related combustions
i<-grep('Coal',SCC$EI.Sector,ignore.case = TRUE)
index <-SCC[i,]$SCC

#Aggregate and name columns
coalem <-aggregate(NEI$Emissions,by=list(NEI$year, NEI$SCC %in% index),sum)
names(coalem) <-c('year','Coal','Emissions')
coalem<-coalem[coalem$Coal==TRUE,]

#Plot
library(ggplot2)
qplot(year,Emissions,data=coalem, geom=c('line','point'), 
      main='Emission from Coal Combustion-related Sources 1999-2008', ylab='Emissions (tons)')

#Save
ggsave(file="plot4.png", dpi=72)