#download then unzip
download.file(url='https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip',destfile='fnei.zip')
unzip('fnei.zip')
#Read
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")
#Merge
#merged<-merge(NEI,SCC,by.x='SCC',by.y='SCC',all=FALSE)

#Aggregate and name columns
#ON-ROAD = from motor vehicles according to EPA
#"NEI onroad sources include emissions from onroad vehicles that use gasoline, diesel, 
#and other fuels. These sources include light duty and heavy duty vehicle emissions 
#from operation on roads, highway ramps, and during idling."
#http://www.epa.gov/air-emissions-inventories/national-emissions-inventory

#Motor vehicles are a self-propelled road vehicle, commonly wheeled, that does not operate on 
#rails, such as trains or trams. The vehicle propulsion is provided by an engine or motor, 
#usually by an internal combustion engine, or an electric motor, or some combination of the two, 
#such as hybrid electric vehicles and plug-in hybrids.
#https://en.wikipedia.org/wiki/Motor_vehicle

motorem <-aggregate(NEI$Emissions,
                    by=list(NEI$year, NEI$type=='ON-ROAD',NEI$fips),sum)
names(motorem) <-c('year','type','fips','Emissions')
motorem<-motorem[motorem$type==TRUE & 
                       (motorem$fips=='24510'|motorem$fips=='06037'),]
motorem$city <-ifelse(motorem$fips=='24510','Baltimore City','LA County')

#Create changes variable with the baseline being Emissions in 1999 for both cities
baseline<-motorem[motorem$year==1999,]
motorem$baseline<-ifelse(motorem$fips=='24510',baseline[baseline$fips=='24510',4],
                         baseline[baseline$fips=='06037',4])
motorem$changes<-motorem$Emissions/motorem$baseline

#Plot
library(ggplot2)
qplot(year,changes,data=motorem, geom=c('line','point'), 
      main='Changes in Emission from Motor-related Sources 1999-2008 
      Baltimore City vs LA County',
      color=city, ylab='Changes in Emissions (Emissions in 1999 =1)')

#Save
ggsave(file="plot6.png", dpi=72)