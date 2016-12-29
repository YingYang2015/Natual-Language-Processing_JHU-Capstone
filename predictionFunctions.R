#' this provides functions to 
#' 1. split the terms in the term matrix into predictor and prediction
#' 2. build and store an N-gram model
#' 3. predict
#' 4. apply backoff method
#' library used: stringr
#' Author: Ying Yang
#' 12/3/2016

################################################################################
# setwd("C:/Users/User/Dropbox/Data Science/Data Science_Jonhs Hopkins Courses/10. Capstone")



library(stringr)

#### Function to split the phrase to be predictor and prediction phrase
predcitor_df <- function(df){
  # (.*) ([^ ]*): anything, then space, then anything but not a space
  # str_match("I like apple and pear", "(.*) (.*) ([^ ]*)")
  df <- subset(df, instance > 1)
  df[c('predictor', 'prediction')] <- subset(str_match(df$word, "(.*) ([^ ]*)"), select=c(2,3))
  df <- subset(df, select=c('predictor', 'prediction', 'instance'))
  df <- df[order(df$predictor,-df$instance),]
  row.names(df) <- NULL
  df
}

####### Function to efficiently build store an Ngram model
##########################################################################################
#' 2. How can you use the knowledge about word frequencies to make your model smaller and more efficient?
#' in 3 grams for example, only keep the highest frequency to reduce the number of parameters
#' for example: I like apple 50%, I like pear 30%, keep "I like apple"
#' Method is Harshing https://en.wikipedia.org/wiki/Hash_function
ngramModel <- function(df){
  print("start hashing now")
  # Hashing will take the last ouput when predictors are the same, 
  # therefore, we need to order the instance in decreasing order 
  hash <- new.env(hash=TRUE, parent=emptyenv())
  for (j in rev(seq(nrow(df)))) {
    if(j%%1000 == 0){print(j)}
    key <- df[j, 'predictor']
    value <- df[j, 'prediction']
    hash[[key]] <- value
  }
  hash
}

######### Function to predict #################
ngramPredict <- function(xclean, ngramModel, modelSelection){
  # find the last words
  if(modelSelection == "fourgram"){
    xs <- tail(strsplit(xclean, " ")[[1]], 3)   
  }else if(modelSelection == "trigram"){
    xs <- tail(strsplit(xclean, " ")[[1]], 2)
  }else if(modelSelection == "bigram"){
    xs <- tail(strsplit(xclean, " ")[[1]], 1)
  }
  xs <- paste(xs, collapse = ' ')
  pred <- ngramModel[[xs]] 
  pred
}

########## Function applies the backoff method #########################
source("cleanCorpus.R")

load("bigramModel.RData")
load("trigramModel.RData")
load("fourgramModel.RData")



backoffPrediction <- function(x){
  xclean <- cleanCorpus(x, profanityFilter)
  xclean <- as.character(xclean[[1]])
  if(xclean == ""){
    ""}
  else{
    pred_fourgram <- ngramPredict(xclean, fourgramModel, "fourgram") 
    if(!is.null(pred_fourgram)){
    pred_fourgram
  }else{
    pred_trigram <- ngramPredict(xclean, trigramModel, "trigram")
    if(!is.null(pred_trigram)){
      pred_trigram
    }else{
      pred_bigram <- ngramPredict(xclean, bigramModel, "bigram") 
      if(!is.null(pred_bigram)){
        pred_bigram
      }else{
        "the"
      }
    }
  }
  }
}
