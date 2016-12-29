
#' this provides functions to 
#' 1. clean the corpus
#' 2. Build the N-grams for the tokenized data
#' 3. Calculate the term frequency


####################### 1. provide clean corpus ##############################
# load function cleanCorpus
source("cleanCorpus.R")  

############################## 2. Build the N-grams for the tokenized data #######################
#' N-grams models are created to explore word frequencies. 
#' Using the tidytext package, create unigrams, bigrams and trigrams are created.
library(stringr)
library(tidytext)
library(dplyr)  # count

tokenizedNgrams <- function(corpusData, n){
        # Build N-grams
        ngram <- corpusData %>%
                unnest_tokens(word, text, token = "ngrams", n=n)
        ngram <- as.data.frame(ngram)
}

######################## 3. create term frequency #######################
termFreq <- function(ngram, maxWords){
        ngram <- ngram %>% count(word)
        m <- (dim(ngram))[1]
        names(ngram) <- c("word", "instance")
        ngram <- as.data.frame(ngram)
        # sort by word (ascending) and instance (descending)
        ngram <- ngram[order(-ngram$instance, ngram$word),]
        # cumulative instance of the words
        ngram$cumInstance  <- cumsum(ngram$instance)
        # frequency of the words
        ngram$frequency    <- ngram$instance/ngram$cumInstance[m]*100
        # cumulartive frequency of the word
        ngram$cumFrequency <- ngram$cumInstance/ngram$cumInstance[m]*100
        ngram$id <- 1:m
        #row.names(ngram)
        return(ngram)
}



