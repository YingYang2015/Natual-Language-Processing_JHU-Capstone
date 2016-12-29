library(shiny)

setwd("C:/Users/User/Dropbox/Data Science/Data Science_Jonhs Hopkins Courses/10. Capstone")
# setwd("C:/Users/wangjia/Dropbox/YY/Capstone")

source("PredictionFunctions.R")


shinyServer(function(input, output) {
        output$pred <- renderText({
                backoffPrediction(input$textInput)
        })
        
        
        withProgress(message = 'Loading Data ...', value = NULL, {
                Sys.sleep(0.25)
                dat <- data.frame(x = numeric(0), y = numeric(0))
                withProgress(message = 'App Initializing', detail = "part 0", value = 0, {
                        for (i in 1:10) {
                                dat <- rbind(dat, data.frame(x = rnorm(1), y = rnorm(1)))
                                incProgress(0.1, detail = paste(":", i*10,"%"))
                                Sys.sleep(0.5)
                        }
                })
                
                # Increment the top-level progress indicator
                incProgress(0.5)
        })
        
        # plot cloudwords
        output$CloudWordsPlot <- renderImage({
                # set the directory where the image is
                chooseFilename <- paste('./Wordcloud/Sample',input$wordcloud,'Cloud.png', sep = "")        
                filename <- normalizePath(file.path(chooseFilename))                
        
                  list(src = filename, width = 800, height = 550)
        }, deleteFile = FALSE)
        
        
        print("you can use your app now!")
})        
