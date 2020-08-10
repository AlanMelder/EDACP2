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

# Selecting entries from SCC source file that contain coal & combustion
coalcombSCC <- grepl("comb", SCC$Short.Name, ignore.case=TRUE) & grepl("coal", SCC$Short.Name, ignore.case=TRUE)
subsetSCC <- SCC[coalcombSCC, ]

# Merging with NEI dataset
mergeSCCNEI <- merge(NEI, subsetSCC, by="SCC")

# Summing totals by year
coalcombsum <- aggregate(Emissions ~ year, mergeSCCNEI, sum)


#Opting for qplot, which is part of the ggplot2 plotting system (as per the assignment)
png("plot4.png")
qplot(data=coalcombsum, year, Emissions, geom="line", ylim=c(0,600000), main="Total PM2.5 coal combustion emissions by year")
dev.off()
