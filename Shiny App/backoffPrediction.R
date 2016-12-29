load("bigramModel.RData")
load("trigramModel.RData")
load("fourgramModel.RData")

####### Hashing
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

######## Backoff Model
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
