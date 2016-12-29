## This is for the capstone
#' library used: tm, tidytext, wordcloud
#' In this script, I 
#' 1. created the summary statistics of the dataset
#' 2. randomly generated the 20% of the dataset as a sample
#' 3. cleaned the corpus
#' 4. created term frequency matrix
#' 5. created unigram, bigram, trigram, and fourgram models
#' 6. visualized the term frequency from different ngram models
#' 7. created wordclouds
#' 8. checked the word distribution
#' 
# start date 11/3/2016

setwd("C:/Users/User/Dropbox/Data Science/Data Science_Jonhs Hopkins Courses/10. Capstone")

############################# Load the data #######################

library(tm)

twitteData <- file("./final/en_US/en_US.twitter.txt", "r") 
twitter <- readLines(twitteData, encoding = "UTF-8", skipNul=TRUE) 
close(twitteData) # close the connection

blogsData <- file("./final/en_US/en_US.blogs.txt", "r") 
blogs <- readLines(blogsData, encoding = "UTF-8", skipNul=TRUE) 
close(blogsData) 

newsData <- file("./final/en_US/en_US.news.txt", "r") 
news <- readLines(newsData, encoding = "UTF-8", skipNul=TRUE) 
close(newsData) 

########################### Summary Statistics ############################
library(R.utils)
# this is to use the linux command, wc -L filename
# wc -L <filename> prints the length of longest line (GNU extension)
dataSummary <- data.frame()
dataSummary[1,1] <- "twitter"
dataSummary[2,1] <- "blogs"
dataSummary[3,1] <- "news"

# find out the size of each file
dataSummary[1,2] <- file.info("./final/en_US/en_US.twitter.txt")$size / (1024*1024)
dataSummary[2,2] <- file.info("./final/en_US/en_US.blogs.txt")$size / (1024*1024)
dataSummary[3,2] <- file.info("./final/en_US/en_US.news.txt")$size / (1024*1024)

# find out the number of lines in each file
dataSummary[1,3] <- length(twitter)
dataSummary[2,3] <- length(blogs)
dataSummary[3,3] <- length(news)

# count the longest line in characters 
dataSummary[1,4] <- as.numeric(gsub("[^0-9]", "", system2("wc", 
                                                          args = "-L ./final/en_US/en_US.twitter.txt", 
                                                          stdout=TRUE)))
dataSummary[2,4] <- as.numeric(gsub("[^0-9]", "", system2("wc", 
                                                          args = "-L ./final/en_US/en_US.blogs.txt", 
                                                          stdout=TRUE)))
dataSummary[3,4] <- as.numeric(gsub("[^0-9]", "", system2("wc", 
                                                          args = "-L ./final/en_US/en_US.news.txt", 
                                                          stdout=TRUE)))
# count the words
dataSummary[1,5] <- as.numeric(gsub("[^0-9]", "", system2("wc", 
                                                          args = "-w ./final/en_US/en_US.twitter.txt", 
                                                          stdout=TRUE)))
dataSummary[2,5] <- as.numeric(gsub("[^0-9]", "", system2("wc", 
                                                          args = "-w ./final/en_US/en_US.blogs.txt", 
                                                          stdout=TRUE)))
dataSummary[3,5] <- as.numeric(gsub("[^0-9]", "", system2("wc", 
                                                          args = "-w ./final/en_US/en_US.news.txt", 
                                                          stdout=TRUE)))

names(dataSummary) <- c("name","fileSize", "lineLength", "longestLine", "wordsCount")

dataSummary
kable(dataSummary) 

################################## Preprocess the data ################################


# # or if there is a file 
# cname <- file.path(".")
# docs <- Corpus(DirSource(cname))

# # the way to see the text in the corpus is
# inspect(proData)
# as.character(proData[[2]])
# #or
# lapply(proData[1:2], as.character)


source("PreprocessFunctions.R")

### clean the corpus of the original data
cleanTwitter <- cleanCorpus(twitter, profanityFilter)
save(cleanTwitter, file = "finalTwitterCorpus.RData")
cleanBlogs <- cleanCorpus(blogs, profanityFilter)
save(cleanBlogs, file = "finalBlogsCorpus.RData")
cleanNews <- cleanCorpus(news, profanityFilter)
save(cleanNews, file = "finalNewsCorpus.RData")

## save the final corpus
save(cleanTwitter, cleanBlogs, cleanNews, file = "finalCorpus.RData")

# create n-grams for the whole sample        
cleanData <- c(cleanTwitter, cleanBlogs, cleanNews)
unigram  <- tokenizedNgrams(cleanData, 1)
bigram   <- tokenizedNgrams(cleanData, 2)
trigram  <- tokenizedNgrams(cleanData, 3)
quadgram <- tokenizedNgrams(cleanData, 4)

# Create term matrix 
unigram <- termFreq(unigram)
bigram  <- termFreq(bigram)
trigram <- termFreq(trigram)
quadgram<- termFreq(quadgram)
save(unigram, bigram, trigram, quadgram, file = "ngrams.RData")

################################## Generate sample files #############################
## Generating a random sapmle of all sources
set.seed(123456)
prop = 0.2
sampleTwitter <- twitter[sample(1:length(twitter),prop*length(twitter))]
sampleBlogs <- blogs[sample(1:length(blogs),prop*length(blogs))]
sampleNews <- news[sample(1:length(news),prop*length(news))]

sampleD <- c(sampleTwitter,sampleNews,sampleBlogs)
save(sampleD, file = "SampleData.RData")

# clean the sample data and save it
sampleData <- cleanCorpus(sampleD, profanityFilter)
save(sampleData, file = "finalSampleCorpus.RData")
# create n-grams for 20% of the sample   
unigramS  <- tokenizedNgrams(sampleData, 1)
bigramS   <- tokenizedNgrams(sampleData, 2)
trigramS  <- tokenizedNgrams(sampleData, 3)
fourgramS <- tokenizedNgrams(sampleData, 4)

# create a frequency table, and save the data
unigramS  <- termFreq(unigramS)
bigramS   <- termFreq(bigramS)
trigramS  <- termFreq(trigramS)
fourgramS <- termFreq(fourgramS)
save(unigramS, bigramS, trigramS, fourgramS, file = "sampleNgrams.RData")

load("sampleNgrams.RData")



# plot bar graph for the word frequency
library(ggplot2)
frequencyGraph <- function(data, n, ngramName, color){
  a <- data[1:n,]
  a$word1 <-factor(a$word, levels=a[order(a$instance, decreasing = TRUE), "word"])
  ggplot(a, aes(y=instance, x=word1)) + 
    geom_bar(stat="identity", fill= color) + 
    ggtitle(paste("Top", n, "frequent words in", ngramName))+ 
    theme(axis.text.x = element_text(angle=30, hjust=1))
  
}
frequencyGraph(unigramS, 30, "Unigram", "red")
frequencyGraph(bigramS, 30, "Bigram", "purple")
frequencyGraph(trigramS, 30, "Trigram", "blue")
#frequencyGraph(fourgramS, 30, "Four-gram", "blue")
################################### Expoloratory analysis_2 Generate word clouds #########################
# word cloud
library(wordcloud, quietly = TRUE)
# save the image in png format
png("Sample1Cloud.png", width=12, height=8, units="in", res=300)
wordcloud(unigramS$word, unigramS$instance, max.words = 100, colors=brewer.pal(8, "Dark2"))
dev.off()

png("Sample2Cloud.png", width=12, height=8, units="in", res=300)
wordcloud(bigramS$word,  bigramS$instance,  max.words = 80, colors=brewer.pal(8, "Dark2"))
dev.off()

png("Sample3Cloud.png", width=12, height=8, units="in", res=300)
wordcloud(trigramS$word, trigramS$instance, max.words = 80, colors=brewer.pal(8, "Dark2"))
dev.off()

# png("Sample4Cloud.png", width=12, height=8, units="in", res=300)
# wordcloud(quadgramS$word,quadgramS$instance,max.words = 50,  colors=brewer.pal(8, "Dark2"))
# dev.off()
 
# # create document term matrix
# dtm <- DocumentTermMatrix(cleanSample[1:10])
# 
# dtm10 <- DocumentTermMatrix(cleanSample[1:10])

####################### some interesting findings #########################
#' How many unique words do you need in a frequency sorted dicionary over 
#' 50% of all word instances in the language
tbl <- data.frame("Ngram" = c("Unigram", "Bigram", "Trigram", "Four-gram"),
                  "sampleLength" = c(dim(unigramS)[1], dim(bigramS)[1], dim(trigramS)[1], dim(fourgramS)[1]))
tbl$'50Coverage' <- c((min(unigramS$id[which(unigramS$cumFrequency > 50)])),
                      (min(bigramS$id[which(bigramS$cumFrequency > 50)])),
                      (min(trigramS$id[which(trigramS$cumFrequency > 50)])),
                      (min(fourgramS$id[which(fourgramS$cumFrequency > 50)])))
tbl$'50CovRate' <- tbl$'50Coverage'/tbl$sampleLength*100
tbl$'90Coverage' <- c((min(unigramS$id[which(unigramS$cumFrequency > 90)])),
                      (min(bigramS$id[which(bigramS$cumFrequency > 90)])),
                      (min(trigramS$id[which(trigramS$cumFrequency > 90)])),
                      (min(fourgramS$id[which(fourgramS$cumFrequency > 90)])))
tbl$'90CovRate' <- tbl$'90Coverage'/tbl$sampleLength*100
tbl$'90CovRate' <- round(tbl$'90CovRate', 2)
tbl$'50CovRate' <- round(tbl$'50CovRate', 2)
tbl
