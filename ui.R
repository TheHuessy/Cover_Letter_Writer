
library(shiny)
library(markdown)
library(readr)



# Define UI for application that draws a histogram
shinyUI(
  fluidPage(
  
  # Application title
  titlePanel("Cover Letter App"),
  sidebarLayout(
    sidebarPanel(
      style = "overflow-y:scroll;height:600px",
      uiOutput("Sidebar")
      
      ),
      
      #Company Division again, take from the first input
      
    mainPanel(
      tabsetPanel(id = "Tabs",
                  tabPanel("Cover Letter",
                           tabsetPanel(id = "TabDeep1",
                                       tabPanel("Main",
                                                tags$div(
                                                  tags$br(),
                                                  textOutput("CoverText1"),
                                                  tags$br(),
                                                  textOutput("CoverText2"),
                                                  tags$br(),
                                                  textOutput("CoverText3"),
                                                  tags$br(),
                                                  textOutput("CoverText4")
                                                  ),
                                                actionButton("knit", "Create Cover Letter")                 
                                                ),
                                       tabPanel("PDF View",
                                                htmlOutput("CoverLetterView")
                                                )
                                       )
                           ),
                  tabPanel("Resume",
                           tabsetPanel(id = "TabDeep2",
                                       tabPanel("Resume 1"),
                                       tabPanel("Resume 2")
                                       )
                           )
                  )
      )
    )
  )
  )


