library(shiny)
library(recommenderlab)

rated_jokes <- read.csv("jesterfinal151cols.csv", header = FALSE)
jokes <- read.csv("jester_items.tsv", header = FALSE, sep = "\t", quote = "")
rated_jokes <- rated_jokes[, !names(rated_jokes) %in% c("V1", "V2", "V3", "V4", "V5", "V7", "V10", "V11", "V12", "V13", "V15", "V150")]
jokes <- jokes[-c(1, 2, 3, 4, 6, 9, 10, 11, 12, 14),]
colnames(rated_jokes) <- jokes$V1

jokes_matrix <- as(as.matrix( rated_jokes[sample(nrow(rated_jokes), 38000), ]),"realRatingMatrix")
recModel <- Recommender(jokes_matrix[1:nrow(jokes_matrix)], method="SVD")

jokeId1 <- ""
jokeId2 <- ""
jokeId3 <- ""
jokeId4 <- ""

rowWithPreds <- matrix(NaN, ncol = 139, nrow=1)

function(input, output, clientData, session) {
  
  observe({
    
    # We'll use these multiple times, so use short var names for
    # convenience.
    rnmdJokes <- sample(jokes$V1, 4)
    jokeId1 <<- rnmdJokes[1]
    jokeId2 <<- rnmdJokes[2]
    jokeId3 <<- rnmdJokes[3]
    jokeId4 <<- rnmdJokes[4]
    joke1 <- jokes[which(jokes$V1 == jokeId1),]$V2
    joke2 <- jokes[which(jokes$V1 == jokeId2),]$V2
    joke3 <- jokes[which(jokes$V1 == jokeId3),]$V2
    joke4 <- jokes[which(jokes$V1 == jokeId4),]$V2
    
    # Text =====================================================
    updateTextInput(session, "inText")
    
    # Number ===================================================
    # Change the value
    updateSliderInput(session, "inSlider1", 
                       label = joke1)
    
    updateSliderInput(session, "inSlider2",
                       label = joke2)
    
    updateSliderInput(session, "inSlider3",
                       label = joke3)
    
    updateSliderInput(session, "inSlider4",
                       label = joke4)
    
  })
  
  observeEvent(input$goButton, {
    # Make a recomendation if there is some input
    if(input$inSlider1 != 0 || input$inSlider2 != 0 || input$inSlider3 != 0 || input$inSlider4 != 0){
      rowWithPreds[1,as.integer(sub(':$', '', jokeId1))] <<- input$inSlider1
      rowWithPreds[1,as.integer(sub(':$', '', jokeId2))] <<- input$inSlider2
      rowWithPreds[1,as.integer(sub(':$', '', jokeId3))] <<- input$inSlider3
      rowWithPreds[1,as.integer(sub(':$', '', jokeId4))] <<- input$inSlider4
      
      preds <- as(predict(recModel, as(rowWithPreds,"realRatingMatrix"), n=4), "list")
      
      jokeId1 <<- preds[[1]][1]
      jokeId2 <<- preds[[1]][2]
      jokeId3 <<- preds[[1]][3]
      jokeId4 <<- preds[[1]][4]
      
      # Change the value
      updateSliderInput(session, "inSlider1", 
                        label = jokes[which(jokes$V1 == preds[[1]][1]),]$V2)
      
      updateSliderInput(session, "inSlider2",
                        label = jokes[which(jokes$V1 == preds[[1]][2]),]$V2)
      
      updateSliderInput(session, "inSlider3",
                        label = jokes[which(jokes$V1 == preds[[1]][3]),]$V2)
      
      updateSliderInput(session, "inSlider4",
                        label = jokes[which(jokes$V1 == preds[[1]][4]),]$V2)
    }
  })
}