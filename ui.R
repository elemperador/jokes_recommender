#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

fluidPage(
  titlePanel("Jokes Recomender"),
  fluidRow(
    column(12, wellPanel(
      br(),
      br(),
      p("A recommender algorithm is used to learn your ratings and recommend jokes accordingly.
        The ratings are anonymous ratings from http://eigentaste.berkeley.edu/dataset/.
        You just need to rate the jokes below and hit recommend for (hopefully) better jokes!"),
      br(),
      p("Reference"),
      p("Eigentaste: A Constant Time Collaborative Filtering Algorithm. Ken Goldberg, Theresa Roeder, 
        Dhruv Gupta, and Chris Perkins. Information Retrieval, 4(2), 133-151. July 2001."),
      br(),
      sliderInput("inSlider1", "Loading jokes (takes a bit in the server), please wait...",
                  min = -10, max = 10, value = 0),
      sliderInput("inSlider2", "Loading jokes (takes a bit in the server), please wait",
                  min = -10, max = 10, value = 0),
      sliderInput("inSlider3", "Loading jokes (takes a bit in the server), please wait",
                  min = -10, max = 10, value = 0),
      sliderInput("inSlider4", "Loading jokes (takes a bit in the server), please wait",
                  min = -10, max = 10, value = 0), 
      actionButton("goButton", "Recommend!"))
    )
  )
)