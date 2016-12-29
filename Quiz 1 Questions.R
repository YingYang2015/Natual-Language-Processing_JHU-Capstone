#' This script is to provide summary of the data
#' and answer the questions in Quiz 1
#' packages used are: tm, R.utils
#' 
#' Author: Ying Yang
#' Data: 11/16



############################# Load the data #######################

library(tm)
setwd("C:/Users/User/Dropbox/Data Science/Jonhs Hopkins Courses/10. Capstone/final/en_US")

twitteData <- file("en_US.twitter.txt", "r") 
twitter <- readLines(twitteData, encoding = "UTF-8", skipNul=TRUE) 

blogsData <- file("en_US.blogs.txt", "r") 
blogs <- readLines(blogsData, encoding = "UTF-8", skipNul=TRUE) 

newsData <- file("en_US.news.txt", "r") 
news <- readLines(newsData, encoding = "UTF-8", skipNul=TRUE) 

# close the connection
close(twitteData) 
close(blogsData) 
close(newsData) 

########################### Summary Statistics ############################
########################### Quiz 1 Questions 1-3 ############################

## Questions 1 - 3
library(R.utils)

dataSummary <- data.frame()
dataSummary[1,1] <- "twitter"
dataSummary[2,1] <- "blogs"
dataSummary[3,1] <- "news"

dataSummary[1,2] <- file.info("en_US.twitter.txt")$size / (1024*1024)
dataSummary[2,2] <- file.info("en_US.blogs.txt")$size / (1024*1024)
dataSummary[3,2] <- file.info("en_US.news.txt")$size / (1024*1024)

dataSummary[1,3] <- length(twitter)
dataSummary[2,3] <- length(blogs)
dataSummary[3,3] <- length(news)

# this uses the linux command, wc -L filename
# wc -L <filename> prints the length of longest line (GNU extension), charactors
dataSummary[1,4] <- as.numeric(gsub("[^0-9]", "", system2("wc", args = "-L en_US.twitter.txt", stdout=TRUE)))
dataSummary[2,4] <- as.numeric(gsub("[^0-9]", "", system2("wc", args = "-L en_US.blogs.txt", stdout=TRUE)))
dataSummary[3,4] <- as.numeric(gsub("[^0-9]", "", system2("wc", args = "-L en_US.news.txt", stdout=TRUE)))

names(dataSummary) <- c("name","fileSize", "lineLength", "longestLine")

dataSummary

################################# Quiz 2 Questions 4 - 6 ###################################

## Question 4
#' In the en_US twitter data set, if you divide the number of lines 
#' where the word "love" (all lowercase) occurs by the number of 
#' lines the word "hate" (all lowercase) occurs, about what do you get?
ratio <- length(grep("love", twitter))/length(grep("hate", twitter))


## Question 5
#' The one tweet in the en_US twitter data set that 
#' matches the word "biostats" says what?
toMatch <- "biostats"
sentences<-unlist(strsplit(twitter,split="\\."))
sentences[grep(paste(toMatch, collapse="|"),sentences)]
# or
twitter[grep(toMatch, twitter)]
## Question 6
#' How many tweets have the exact characters 
#' "A computer once beat me at chess, but it was no match for me at kickboxing". 
#' (I.e. the line matches those characters exactly.)
length(grep("A computer once beat me at chess, but it was no match 
            for me at kickboxing", twitter))



