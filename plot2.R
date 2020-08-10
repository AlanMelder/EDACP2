## Loading packages:

# Tidyverse for dplyr, which is used for tibbles
# Upon retrospect, I didn't rely on dplyr-specific functions in this script, so you can do without.

install.packages("tidyverse")
library(tidyverse)



## Check if file has already been downloaded and unzipped, if not -> do so
if (!file.exists("SCC.zip")) {
  download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip", "SCC.zip")
}

if (!file.exists("\color{red}{\verb|summarySCC_PM25.rds|}summarySCC_PM25.rds") & !file.exists("Source_Classification_Code.rds")) { 
  unzip("SCC.zip") 
}

#Reading dataset

NEI <- as_tibble(readRDS("summarySCC_PM25.rds"))
SCC <- as_tibble(readRDS("Source_Classification_Code.rds"))


#Subsetting Baltimore data.
emission_baltimore <- NEI[ which(NEI$fips=="24510"), ]

# Summing Baltimore emission totals by year
emission_baltimore_agg <- tapply(emission_baltimore$Emissions, emission_baltimore$year, FUN=sum)

#Creating a bar plot
png("plot1.png")
barplot(emission_baltimore_agg, ylab="Total PM2.5 emissions", xlab="Years", main="Total PM2.5 emissions by year in Baltimore, MD")
dev.off()
