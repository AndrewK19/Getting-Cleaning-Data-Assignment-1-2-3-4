#QUIZ 4
#Create file folder in directory for Quiz 4
if(!file.exists("./Quiz 4")){dir.create("./Quiz 4")}

#QUESTION 1
# The American Community Survey distributes downloadable data about United States communities. 
# Download the 2006 microdata survey about housing for the state of Idaho using download.file() from here:
#         
#         https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv


fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
download.file(fileUrl, destfile = "./Quiz 4/2006_microdata.csv", method = "curl")
downloadDate <- date()

# and load the data into R. The code book, describing the variable names is here:
#         
#         https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FPUMSDataDict06.pdf

data <- read.csv("./Quiz 4/2006_microdata.csv")

# Apply strsplit() to split all the names of the data frame on the characters "wgtp". 
# What is the value of the 123 element of the resulting list?

colnames <- names(data)
split <- strsplit(colnames, "^wgtp")[[123]]
split

# QUESTION 2
# Load the Gross Domestic Product data for the 190 ranked countries in this data set:
#         
#         https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv"
download.file(fileUrl, destfile = "./Quiz 4/gdp190.csv", method = "curl")
downloadDate <- date()
data <- read.csv("./Quiz 4/gdp190.csv", nrow=190, skip = 4)
data <- data[,c(1,2,4,5)]
colnames(data) <- c("CountryCode", "Rank", "Country", "Total")
View(data)

# Remove the commas from the GDP numbers in millions of dollars and average them. What is the average?

data$Total <- as.numeric(gsub(",","",data$Total))
mean(data$Total, na.rm = TRUE )

# QUESTION 3
# In the data set from Question 2 what is a regular expression that would allow you to count 
# the number of countries whose name begins with "United"? Assume that the variable with the 
# country names in it is named countryNames. 
# 
# How many countries begin with United?
data <- read.csv("./Quiz 4/gdp190.csv", nrow=190, skip = 4)
data <- data[,c(1,2,4,5)]
colnames(data) <- c("CountryCode", "Rank", "countryNames", "Total")
View(data)


#Answer 1
length(grep("^United",data$countryNames)) #- correct

#Answer 2
length(grep("United$",data$countryNames)) #- wrong

#Answer 3
length(grep("^United",data$countryNames)) #- wrong

#Answer 4
length(grep("*United",data$countryNames)) #- wrong as the answer in the quiz says 2 names appear when 3 do

# QUESTION 4

library(data.table)
# Load the Gross Domestic Product data for the 190 ranked countries in this data set:
#         
#         https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv

fileUrl1 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv"
download.file(fileUrl1, destfile = "./Quiz 4/gdp190.csv", method = "curl")
downloadDate <- date()
gdpdata <- read.csv("./Quiz 4/gdp190.csv", nrow=190, skip = 4)
gdpdata <- gdpdata[,c(1,2,4,5)]
colnames(gdpdata) <- c("CountryCode", "Rank", "Country", "Total")
View(gdpdata)
#
# OR

gdpdata <- fread(fileUrl1, 
                 skip = 4, 
                 nrows = 190, 
                 select = c(1, 2, 4, 5), 
                 col.names = c("CountryCode", "Rank", "Country", "Total"))
View(gdpdata)

# Load the educational data from this data set:
#         
#         https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv

fileUrl2 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv"
download.file(fileUrl2, destfile = "./Quiz 4/edu.csv", method = "curl")
downloadDate <- date()
edudata <- fread(fileUrl2)
View(edudata)

# Match the data based on the country shortcode. 
# Of the countries for which the end of the fiscal year is available, how many end in June?

mergeddata <- merge(gdpdata, edudata, by = 'CountryCode', all = FALSE)
View(mergeddata)
june <- grep("Fiscal year end: June", mergeddata$`Special Notes`) #find elements with the identified phrase
length(june) #count the number of elements in the vector
#or
NROW(june)

# QUESTION 5

library(quantmod)
amzn = getSymbols("AMZN",auto.assign=FALSE)
sampleTimes = index(amzn)
library(lubridate)

amzn2012 <- sampleTimes[grep("^2012", sampleTimes)] #pulling all elements that start with 2012 and creating a vector
length(amzn2012) #length of vector is # of elements or "values" that were recorded in 2012 for amzn

length(amzn2012[weekdays(amzn2012) == "Monday"]) #pull all the elements where the weekday is Monday,
                                                 #and count the length of that vector
