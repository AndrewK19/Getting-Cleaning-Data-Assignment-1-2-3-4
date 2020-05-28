# QUESTION 1
# The American Community Survey distributes downloadable data about United States communities. 
# Download the 2006 microdata survey about housing for the state of Idaho using download.file() from here:
#         
#         https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
download.file(fileUrl, destfile = "./Quiz 3/2006_Microdata_Survey.csv")
dateDownloaded <- date()

# and load the data into R. The code book, describing the variable names is here:
#         
#         https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FPUMSDataDict06.pdf

#read the file in RStudio
data <- read.csv("./Quiz 3/2006_Microdata_Survey.csv")

# Create a logical vector that identifies the households on greater than 10 acres who sold more than 
# $10,000 worth of agriculture products. Assign that logical vector to the variable agricultureLogical. 
agricultureLogical <- data$ACR == 3 & data$AGS == 6

# Apply the which() function like this to identify the rows of the data frame where the logical vector is TRUE.
# which(agricultureLogical)
# What are the first 3 values that result?

# What are the first 3 values that result?
which(agricultureLogical)

# Answer #1        
# 125, 238,262


# QUESTION 2
# Using the jpeg package read in the following picture of your instructor into R
# 
# https://d396qusza40orc.cloudfront.net/getdata%2Fjeff.jpg
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fjeff.jpg"
download.file(fileUrl, destfile = "./Quiz 3/Jeff.jpeg", mode = "wb")
dateDownloaded <- date()

library(jpeg)
jpegdata <- readJPEG("./Quiz 3/Jeff.jpeg", native = TRUE)
quantile(jpegdata, probs = c(0.30,0.80))
#Answer #4
# 30%       80% 
# -15258512 -10575416 

#QUESTION 3
# Load the Gross Domestic Product data for the 190 ranked countries in this data set:
#         
#         https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv
# 
# Load the educational data from this data set:
#         
#         https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv

library(dplyr)
library(data.table)
fileUrl1 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv"
filePath1 <- "./Quiz 3/gdp_190countries.csv"
download.file(fileUrl1, destfile = "./Quiz 3/gdp_190countries.csv", method = "curl")
dateDownloaded <- date()


fileUrl2 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv"
filePath2 <- "./Quiz 3/education.csv"
download.file(fileUrl2, destfile = "./Quiz 3/education.csv", method = "curl")
dateDownloaded <- date()

gdpdata <- fread(filePath1, 
                skip = 5, 
                nrows = 191, 
                select = c(1,2,4,5), 
                col.names = c("CountryCode", "Rank", "Economy", "Total"))

edudata <- fread(filePath2)

# Match the data based on the country shortcode. How many of the IDs match? 
# Sort the data frame in descending order by GDP rank (so United States is last). 
# What is the 13th country in the resulting data frame?

mergeddata <- merge(gdpdata, edudata, by = 'CountryCode', all = FALSE)
sorteddata <- mergeddata %>% arrange(desc(Rank))

#Find the # of matches & the 13th ranked country
ans <- c(nrow(sorteddata), "matches, 13th country is ", sorteddata$Economy[13])
print(ans)

#or
paste(nrow(sorteddata), "matches, 13th country is ", sorteddata$Economy[13])

# # QUESTION 4
# What is the average GDP ranking for the "High income: OECD" and "High income: nonOECD" group?
mergeddata <- merge(gdpdata, edudata, by = 'CountryCode', all = FALSE)
mergeddata %>% group_by(`Income Group`) %>%
        filter("High income: OECD" %in% `Income Group` | "High income: nonOECD" %in% `Income Group`) %>%
        summarize(Average = mean(Rank, na.rm = T)) %>%
        arrange(desc(`Income Group`))

#or a faster way
tapply(mergeddata$Rank, mergeddata$`Income Group`, mean)

# QUESTION 5
# Cut the GDP ranking into 5 separate quantile groups. Make a table versus Income.Group.
mergeddata$RankedGroups <- cut(mergeddata$Rank, breaks = 5)
table <- table(mergeddata$RankedGroups, mergeddata$"Income Group")
table
#answer
table[1, "Lower middle income"]
