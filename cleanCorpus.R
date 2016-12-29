#' this provides the function of clean the corpus

####################### 1. provide clean corpus ##############################
library(tm)
profanity <- file("profanitywords.txt", "r") 
profanityFilter <- readLines(profanity, encoding = "UTF-8", skipNul=TRUE) 
profanityFilter <- iconv(profanityFilter,"latin1","ASCII",sub = "")
close(profanity)


cleanCorpus <- function(data, profanityFilter){
  #' remove words with non-ASCII characters        
  data <- iconv(data,"latin1","ASCII",sub = " ")
  # Convert it to Corpus
  proData <- Corpus(VectorSource(data))
  #' Convert it to lower cases
  proData <- tm_map(proData, content_transformer(tolower))
  #' #' Remove stop words  ### This might be optional
  #' proData <- tm_map(proData, removeWords, stopwords("english"))  
  #' Remove punctuation
  proData <- tm_map(proData, removePunctuation)  
  # remove repeated expression
  repeatedExp <- '\\b(\\S+?)\\1\\S*\\b'
  removeRepeat <- function(x) gsub(repeatedExp, "", x, perl = TRUE) 
  proData <- tm_map(proData, content_transformer(removeRepeat))
  #' Remove extra white spaces
  proData <- tm_map(proData, stripWhitespace)  
  #' Remove number
  proData <- tm_map(proData, removeNumbers) 
  # Remove URL
  urlExp <- "(f|ht)tp\\S+\\s*"  # \\S mataches anything but a white space. \\s matches white space
  removeUrl <- function(x) gsub(urlExp, "", x) 
  proData <- tm_map(proData, content_transformer(removeUrl))
  # Remove websites
  webExp <- "www\\S+\\s*"
  removeWeb <- function(x) gsub(webExp, "", x) 
  proData <- tm_map(proData, content_transformer(removeWeb))
  #' remove email
  emailExp <- "[a-z]+@[a-z]+[.][a-z.]+"        
  removeEmail <- function(x) gsub(emailExp, "", x) 
  proData <- tm_map(proData, content_transformer(removeEmail))
  #' Remove profanity words
  proData <- tm_map(proData, removeWords, profanityFilter) 
  #' #' initiate steming   (e.g. doing ->  do)  ### This might be optional
  #' proData <- tm_map(proData, stemDocument) 
  # convert it to data frame
  corpus_df <- as.data.frame(unlist(
    lapply(proData[1:length(content(proData))], as.character)))
  names(corpus_df) <- "text"
  corpus_df
}