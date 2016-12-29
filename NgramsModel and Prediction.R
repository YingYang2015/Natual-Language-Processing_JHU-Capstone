## This is for the capstone, NLP
#' Build the N-gram model and predict based on it
#' library used: caret, stringr, dplyr, Rweka
# start date 12/1/2016

setwd("C:/Users/User/Dropbox/Data Science/Data Science_Jonhs Hopkins Courses/10. Capstone")

library(RWeka)
library(tm)

options(java.parameters = "-Xmx4000m")
############## load the sample corpus 20%, and cut it into training, validation, and testing
load("./Produced Data/finalSampleCorpus.RData")
sampleData$order <- 1:dim(sampleData)[1]

library(caret)
inTrain <- createDataPartition(y = sampleData$order, p = 0.7, list = FALSE)
training <- sampleData[inTrain,]
testingVT <- sampleData[-inTrain,]

# create validation set and testing set
inTrainVT <- createDataPartition(y = testingVT$order, p = 0.5, list = FALSE)
validation <- sampleData[inTrainVT,]
testing <- sampleData[-inTrainVT,]

###################################################
#' 1. How can you efficiently store an n-gram model (think Markov Chains)?
#' we only consider four-grams here. 
#' Imgaine that we want to use markov chain and predict the next word 
#' based on the previous two words. When considering about the four-grams and above, 
#' we can recalculate the frequency of the last three words as a phrase
#' That means to calculate the conditional probability
#' 
#' 
########################## Tokenization ################################
corpus <- Corpus(VectorSource(training$text))

# create n-grams
unigramTr  <- NGramTokenizer(x, Weka_control(min = 1, max = 1))
bigramTr   <- NGramTokenizer(x, Weka_control(min = 2, max = 2))
trigramTr  <- NGramTokenizer(x, Weka_control(min = 3, max = 3))
fourgramTr <- NGramTokenizer(x, Weka_control(min = 4, max = 4))

unigramTr <- as.data.frame(unigramTr)
names(unigramTr) <- "word"
bigramTr <- as.data.frame(bigramTr)
names(bigramTr) <- "word"
trigramTr <- as.data.frame(trigramTr)
names(trigramTr) <- "word"
fourgramTr <- as.data.frame(fourgramTr)
names(fourgramTr) <- "word"

# create a frequency table, and save the data
source("PreprocessFunctions.R")
unigramTr  <- termFreq(unigramTr)
bigramTr   <- termFreq(bigramTr)
trigramTr  <- termFreq(trigramTr)
fourgramTr <- termFreq(fourgramTr)

# save the data
save(unigramTr, bigramTr, trigramTr, fourgramTr, file = "trainingNgrams.RData")
load("trainingNgrams.RData")

source("predictionFunctions.R")
# Prepare the data frame for prediction
biPredictor_df  <- predcitor_df(bigramTr)
triPredictor_df <- predcitor_df(trigramTr)
fourPredictor_df<- predcitor_df(fourgramTr)

save(biPredictor_df, triPredictor_df, fourPredictor_df, file = "predictor_df.RData")

## Estimate the N-grams model
# save the Ngram models
load("predictor_df.RData")

bigramModel  <- ngramModel(biPredictor_df)
save(bigramModel, file = "bigramModel.RData")

trigramModel <- ngramModel(triPredictor_df)
save(trigramModel, file = "trigramModel.RData")

fourgramModel<- ngramModel(fourPredictor_df)
save(fourgramModel, file = "fourgramModel.RData")

##### You can start predicting your next word
load("bigramModel.RData")
load("trigramModel.RData")
load("fourgramModel.RData")
source("predictionFunctions.R")

newPhrase <- "Nice to meet you"
backoffPrediction(newPhrase)

        