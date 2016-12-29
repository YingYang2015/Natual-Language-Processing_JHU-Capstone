## This is to download the data
#' library used: tm, tidytext, wordcloud
# start date 11/19/2016

setwd("C:/Users/User/Dropbox/Data Science/Jonhs Hopkins Courses/10. Capstone")

############################ download the SwiftKey.zip ##########################################
fileDest <- "./Coursera-SwiftKey.zip" 
fileURL <- "https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip"
download.file(url = fileURL, destfile = fileDest)
unzip("Coursera-SwiftKey.zip")

########################### download the list of profanity words ############################

fileDest <- "./profanitywords.zip" 
fileURL <- "http://www.freewebheaders.com/wordpress/wp-content/uploads/full-list-of-bad-words-banned-by-google-txt-file.zip"
download.file(url = fileURL, destfile = fileDest)
unzip("profanitywords.zip")
file.rename(from = "full-list-of-bad-words-banned-by-google-txt-file_2013_11_26_04_53_31_867.txt", 
            to = "profanitywords.txt")