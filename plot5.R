## Loading packages:

# Tidyverse for dplyr, which is used for tibbles
# Upon retrospect, I didn't rely on dplyr-specific functions in this script, so you can do without.
# ggplot2 for plots

install.packages("tidyverse")
library(tidyverse)
install.packages("ggplot2")
library(ggplot2)



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

# Selecting entries from SCC source file pertain to vehicles. NOTE: opted to only select highway vehicles. 
# A generic vehicle selection would have included things like lawnmowers etc which I believe were outside
# the scope of the assignment.

vehicleSCC <- grepl("Highway Veh", SCC$Short.Name, ignore.case=TRUE)
vehicle_subsetSCC <- SCC[vehicleSCC, ]

# Merging with NEI dataset
vehicle_mergeSCCNEI <- merge(NEI, vehicle_subsetSCC, by="SCC")

#Subsetting Baltimore data.
vehicle_emission_balt <- vehicle_mergeSCCNEI[ which(vehicle_mergeSCCNEI$fips=="24510"), ]

# Summing totals by year
vehicle_emission_balt_sum <- aggregate(Emissions ~ year, vehicle_emission_balt, sum)


#Opting for qplot, which is part of the ggplot2 plotting system (as per the assignment)
png("plot5.png")
qplot(data=vehicle_emission_balt_sum, year, Emissions, geom="line", ylim=c(0,600), main="Total PM2.5 coal combustion emissions by year by motor (highway) vehicles in Baltimore")
dev.off()
