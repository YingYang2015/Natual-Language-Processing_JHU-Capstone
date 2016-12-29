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
