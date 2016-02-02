#download then unzip
download.file(url='https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip',destfile='fnei.zip')
unzip('fnei.zip')
#Read
NEI <- readRDS("summarySCC_PM25.rds")
#SCC <- readRDS("Source_Classification_Code.rds")
#Merge
#merged<-merge(NEI,SCC,by.x='SCC',by.y='SCC',all=FALSE)

#Aggregate and name columns
balem <-aggregate(NEI$Emissions,by=list(NEI$year, NEI$fips=='24510'),sum)
names(balem) <-c('year','Bal','Emissions')
balem<-balem[balem$Bal==TRUE,]

#Plot
plot(balem$year,balem$Emissions,type='l', xlab='year',
     ylab='', main='Emissions (tons) from All Sources 1999-2008 in Baltimore City', 
     lwd=3, col='lightblue', axes=FALSE,cex.lab=0.7, cex.main=0.8)

#Annotate
text(balem$year,balem$Emissions,balem$year,cex=0.5)

#Axis
axis(1, at = seq(1999, 2008, by = 1), las=1, cex.axis=0.5, col='grey')
axis(2, at = seq(1500,3500,by=100), las=1, cex.axis=0.5, col='grey')

#Save
dev.copy(png, file='plot2.png',width=475,height=361)
dev.off()