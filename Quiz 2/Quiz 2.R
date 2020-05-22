#Quiz 2
# Question 1
# Register an application with the Github API here https://github.com/settings/applications.
# # Access the API to get information on your instructors repositories (hint: this is the url you want “https://api.github.com/users/jtleek/repos”).
# # Use this data to find the time that the datasharing repo was created. What time was it created?
#         
#         This tutorial may be useful (https://github.com/hadley/httr/blob/master/demo/oauth2-github.r).
# 
# You may also need to run the code in the base R package and not R studio.
# # Answer
# 
# Loading packages..

library(httr)

# Find OAuth settings for github: http://developer.github.com/v3/oauth/
        
oauth_endpoints("github")
# <oauth_endpoint>
# authorize: https://github.com/login/oauth/authorize
# access:    https://github.com/login/oauth/access_token
# 
# Register an application at https://github.com/settings/applications

myapp <- oauth_app("github",
                   key = "75ffc4989df8001de43a",
                   secret = "389877827ca7031f4586a37206816ec5152088dc")

# Get OAuth credentials

github_token <- oauth2.0_token(oauth_endpoints("github"), myapp)

# Use API

req <- GET("https://api.github.com/users/jtleek/repos", config(token = github_token))
stop_for_status(req)
output <- content(req)

# Find “datasharing”

datashare <- which(sapply(output, FUN=function(X) "datasharing" %in% X))
datashare
# [1] 15

# Find the time that the datasharing repo was created.

list(output[[15]]$name, output[[15]]$created_at)
# [[1]]
# [1] "datasharing"
# 
# [[2]]
# [1] "2013-11-07T13:25:07Z"

#Question 2:
# The sqldf package allows for execution of SQL commands on R data frames. 
# We will use the sqldf package to practice the queries we might send with the dbSendQuery command in RMySQL.
# 
# Download the American Community Survey data and load it into an R object called acs
# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv
# 
# Which of the following commands will select only the data for the probability weights 
# pwgtp1 with ages less than 50?

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv"
download.file(fileUrl, destfile = "./acs.csv")
dateDownloaded <- date()
acs <- read.csv("./acs.csv")
head(acs)

library(sqldf)

#answer 1:
sqldf("select pwgtp1 from acs") #wrong answer
#answer 2:
sqldf("select pwgtp1 from acs where AGEP < 50") #correct answer
#answer 3: 
sqldf("select * from acs where AGEP < 50 and pwgtp1") #wrong answer
#answer 4:
sqldf("select * from acs")

# Question 3:
# Using the same data frame you created in the previous problem, 
# what is the equivalent function to unique(acs$AGEP)

#Answer 1:
sqldf("select AGEP where unique from acs") #wrong answer

#Answer 2:
sqldf("select unique * from acs") #wrong answer

#Answer 3:
x <- sqldf("select distinct AGEP from acs") #correct answer
identical(unique(acs$AGEP), x$AGEP)
#answer 4:
x <- sqldf("select distinct pwgtp1 from acs") #wrong answer
identical(unique(acs$AGEP), x$AGEP)

#Question 4:
# How many characters are in the 10th, 20th, 30th and 100th lines of HTML from this page:
#       http://biostat.jhsph.edu/~jleek/contact.html
# (Hint: the nchar() function in R may be helpful)

htmlUrl <- url("http://biostat.jhsph.edu/~jleek/contact.html")
htmlCode <- readLines(htmlUrl)
close(htmlUrl)
head(htmlCode)
answer <- c(nchar(htmlCode[10]), nchar(htmlCode[20]), nchar(htmlCode[30]), nchar(htmlCode[100]))
answer

#Question 5:
# Read this data set into R and report the sum of the numbers in the fourth of the nine columns.
# https://d396qusza40orc.cloudfront.net/getdata%2Fwksst8110.for
# Original source of the data: http://www.cpc.ncep.noaa.gov/data/indices/wksst8110.for
# (Hint this is a fixed width file format)

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fwksst8110.for"
sst <- read.fwf(fileUrl, skip=4 ,widths = c(12, 7, 4, 9, 4, 9, 4, 9, 4)) 
#widths are column widths to print all values
head(sst)
sum(sst$V4) 
#or
sum(sst[,4])
