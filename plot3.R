#download then unzip
download.file(url='https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip',destfile='fnei.zip')
unzip('fnei.zip')
#Read
NEI <- readRDS("summarySCC_PM25.rds")
#SCC <- readRDS("Source_Classification_Code.rds")
#Merge
#merged<-merge(NEI,SCC,by.x='SCC',by.y='SCC',all=FALSE)

#Aggregate and name columns
balem <-aggregate(NEI$Emissions,by=list(NEI$year, NEI$fips=='24510',NEI$type),sum)
names(balem) <-c('year','Bal','type','Emissions')
balem<-balem[balem$Bal==TRUE,]

#Plot
library(ggplot2)
qplot(year,Emissions,data=balem, geom=c('line','point'), color=type, 
      main='Emissions from 1999–2008 for Baltimore City by Type', ylab='Emissions (tons)')

#Save
ggsave(file="plot3.png", dpi=72)