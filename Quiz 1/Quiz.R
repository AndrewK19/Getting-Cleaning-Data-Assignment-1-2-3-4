#Quiz Questions:

#copy directory location from WINDOWS
setwd(readClipboard())
getwd()

#load data.table package
library(data.table)

#Question 1: 
#The American Community Survey distributes downloadable data about United States communities. Download the 2006 microdata survey about housing for the state of Idaho using download.file() from here:
    #https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv
#and load the data into R. The code book, describing the variable names is here:
        #https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FPUMSDataDict06.pdf

#How many properties are worth $1,000,000 or more?

#download file from internet file link
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
download.file(fileUrl, destfile = "./Idaho_Housing.csv")
dateDownloaded <- date()

#Create a function to find How many properties are worth $1,000,000 or more?
propvalue <- function (value) {
        #read data file into function
        data <- read.csv("./Idaho_Housing.csv")
        
        DT <- data.table(data) #create data table of data
        numprop <- DT[, .N, by=VAL==value] #use built in function to find row counts for 24 == prop > $1MM 
        
        numprop #TRUE sum values are the # of properties for the given value code
}

#Question 2: Use the data you loaded from Question 1. Consider the variable FES in the code book. 
#Which of the "tidy data" principles does this variable violate?

# Answer: Tidy data has one variable per column.

#Question 3: 
#Download the Excel spreadsheet on Natural Gas Aquisition Program here:
#        https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FDATA.gov_NGAP.xlsx

#Read rows 18-23 and columns 7-15 into R and assign the result to a variable called:
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FDATA.gov_NGAP.xlsx"
download.file(fileUrl, destfile = "./NGAP.xlsx")
dateDownloaded <- date()
library(xlsx)

#create a function to read in specificed rows and columns under a variable called dat
ngap <- function (row, col) {
    
    #read in the excel file
        rowIndex <- row
        colIndex <- col
        dat <- read.xlsx("./NGAP.xlsx", sheetIndex = 1, rowIndex = rowIndex, colIndex = colIndex)
        
        #quiz question code
        sum(dat$Zip*dat$Ext,na.rm=T)
}

#Question 4: Read the XML data on Baltimore restaurants from here:

#https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml

#How many restaurants have zipcode 21231?
library(XML)
fileUrl <- "http://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml"
doc <- xmlTreeParse(fileUrl, useInternal=TRUE)
rootNode <- xmlRoot(doc)
names(rootNode)
zipcode <- xpathSApply(rootNode, "//zipcode", xmlValue)
sum(zipcode == "21231")

#Question 5: The American Community Survey distributes downloadable data about United States communities. 
#Download the 2006 microdata survey about housing for the state of Idaho using download.file() from here:

#https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv"
download.file(fileUrl, destfile = "./US_Communities.csv")
dateDownloaded <- date()

#using the fread() command load the data into an R object
DT <- fread("./US_Communities.csv")
file.info("./US_Communities.csv")$size

#two ways to complete this answer
# #1 way - microbenchmark package allows you to run multiple versions of query "n" amount of times
# the example below runs 100 times
#install.packages("microbenchmark")
library("microbenchmark")

mbm = microbenchmark(
    v3 = sapply(split(DT$pwgtp15,DT$SEX),mean),
    v6 = DT[,mean(pwgtp15),by=SEX],
    v7 = tapply(DT$pwgtp15,DT$SEX,mean),
    v8 = mean(DT$pwgtp15,by=DT$SEX),
    times=100
)
mbm

#Answer:
#Unit: microseconds
#expr    min      lq     mean  median      uq    max neval
#v3  302.0  318.75  411.015  349.90  470.00  747.3   100
#v6 1242.6 1477.60 2104.371 1626.75 2352.95 8030.1   100
#v7  458.2  499.65  669.427  651.10  806.20 1186.1   100
#v8   20.8   23.70   31.632   25.85   36.90   72.8   100

# #2 Way is to use R function system.time()
system.time(DT[,mean(pwgtp15),by=SEX])
system.time(mean(DT[DT$SEX==1,]$pwgtp15))+system.time(mean(DT[DT$SEX==2,]$pwgtp15))
system.time(sapply(split(DT$pwgtp15,DT$SEX),mean))
system.time(mean(DT$pwgtp15,by=DT$SEX))
system.time(tapply(DT$pwgtp15,DT$SEX,mean))
system.time(rowMeans(DT)[DT$SEX==1])+system.time(rowMeans(DT)[DT$SEX==2])
