#download then unzip
download.file(url='https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip',destfile='fnei.zip')
unzip('fnei.zip')

#Read
NEI <- readRDS("summarySCC_PM25.rds")
#SCC <- readRDS("Source_Classification_Code.rds")
#Merge
#merged<-merge(NEI,SCC,by.x='SCC',by.y='SCC',all=FALSE)

#Aggregate and name columns
yearem <-aggregate(NEI$Emissions,by=list(NEI$year),sum)
names(yearem)<-c('year','Emissions')

#Plot
plot(yearem$year,yearem$Emissions,type='l', xlab='year',
     ylab='', main='Emissions (tons) from All Sources 1999-2008', 
     lwd=3, col='lightblue', axes=FALSE,cex.lab=0.7, cex.main=0.8)

#Annotate
text(yearem$year,yearem$Emissions,yearem$year,cex=0.5)

#Axis
axis(1, at = seq(1999, 2008, by = 1), las=1, cex.axis=0.5, col='grey')
axis(2, at = seq(3000000,7500000,by=500000), las=1, cex.axis=0.5, col='grey')

#Save
dev.copy(png, file='plot1.png',width=475,height=361)
dev.off()