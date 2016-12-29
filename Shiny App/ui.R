library(shiny)
require(markdown)

shinyUI(
        navbarPage("Next Word Prediction, SwiftKey NLP", inverse = FALSE, collapsable = FALSE, 
                tabPanel("Word Prediction",
                        fluidRow(
                                sidebarPanel(width = 3,
                                             helpText(h4("Instruction")),
                                             hr(),
                                             h4("Type your phrase, and the app will predict the next word you want to type"),
                                            
                                             helpText(h4("1. First type your sentence in the text box"), style="color:#428ee8"),
                                             helpText(h4("2. The app will pass your input to the prediction algorithm"), style="color:#428ee8"),
                                             helpText(h4("3. Obtain the prediction below"), style="color:#428ee8"),
                                             br(),
                                             hr(),
                                             helpText(h4("Note:")),
                                             helpText(h4("Please wait until the App is loaded initially")),
                                             br(),
                                             hr(),
                                             helpText(h5("This app is built for")),
                                             a("Data Science Capstone, JHU (SwiftKey)", href="https://www.coursera.org/course/dsscapstone"),
                                             br(),
                                             hr(),
                                             helpText(h5("Visit github for more information")),
                                             a(img(src = "GitHub-Mark-120px-plus.png", height = 30, width = 30),href="https://www.linkedin.com/in/yang-ying"),
                                             br(),
                                             hr(),
                                             helpText(h4("Ying Yang")),
                                             a(img(src = "Linkedin.png", height = 30, width = 30),href="https://www.linkedin.com/in/yang-ying"),
                                             a(img(src = "https://upload.wikimedia.org/wikipedia/commons/4/45/New_Logo_Gmail.svg", height = 30, width = 30),href="mailto: yangyingtina@gmail.com")
                                             ),
                                mainPanel(width = 8,
                                          column(5,
                                          h3("Word Prediction"),hr(),
                                          h4(textInput(inputId="textInput", 
                                                    label = "Please type here", "")),
                                          h4('The next predicted word is:'),
                                          wellPanel(span(h3(textOutput("pred")),style = "color:#428ee8")),
                                          br(),
                                          plotOutput("CloudWordsPlot", width = "100%")
                                          ),
                                          column(5,
                                                 h3("Display the Word Cloud of"),hr(),
                                                 selectInput("wordcloud", "",
                                                             c("Unigram" = "1",
                                                               "Bi-gram" = "2",
                                                               "Tri-gram" = "3",
                                                               "Four-gram" = "4")),
                                                 helpText(a("1. A word cloud is a graphical representation of word frequency", href="https://en.wikipedia.org/wiki/Tag_cloud")),
                                                 helpText(a("2. See here for more information about N-grams", href="https://www.coursera.org/course/dsscapstone")))
                                          )
                               
                                )
                        ),
                tabPanel("Document",
                         fluidRow(
                                 sidebarPanel(width = 4,
                                              helpText(h4("This document provides you the information about")),
                                              hr(),
                                              helpText(h4("1. Data"), style="color:#428ee8"),
                                              helpText(h4("2. Ngram model"), style="color:#428ee8"),
                                              helpText(h4("3. Prediction algorithm"), style="color:#428ee8"),
                                              br(),
                                              hr(),
                                              helpText(h4("Note:")),
                                              helpText(h4("Please wait until the App is loaded initially")),
                                              br(),
                                              hr(),
                                              helpText(h5("This app is built for")),
                                              a("Data Science Capstone, JHU (SwiftKey)", href="https://www.coursera.org/course/dsscapstone"),
                                              br(),
                                              hr(),
                                              helpText(h5("Visit github for more information")),
                                              a(img(src = "GitHub-Mark-120px-plus.png", height = 30, width = 30),href="https://www.linkedin.com/in/yang-ying"),
                                              br(),
                                              hr(),
                                              helpText(h4("Ying Yang")),
                                              a(img(src = "Linkedin.png", height = 30, width = 30),href="https://www.linkedin.com/in/yang-ying"),
                                              a(img(src = "https://upload.wikimedia.org/wikipedia/commons/4/45/New_Logo_Gmail.svg", height = 30, width = 30),href="mailto: yangyingtina@gmail.com")
                                                 ),
                                 
                                 
                                 mainPanel(
                                 includeMarkdown("NgramsModel_and_Prediction.Rmd")
                                        )
                                 )
                         )
                   )
                
)