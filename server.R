#Need to set all file extensions back to just basic path and enable a setwd() at the beginning

library(shiny)
library(rmarkdown)


shinyServer(function(input, output, session) {
  #Paragraph 1
  P1.0 <- "I am seeking employment at"
  #Then the company()
  P1.1 <- read_file("www/P1.1.txt")
  #Then company() again
  P1.2 <- read_file("www/P1.2.txt")
  
  
  #Paragraph 2
  P2.1 <- read_file("www/P2.1.txt")
  #Then Position()
  P2.2 <- read_file("www/P2.2.txt")
  
  #Paragraph 3
  P3 <- read_file("www/P3.txt")
  
  #Paragraph 4
  P4.1 <- read_file("www/P4.1.txt")
  #Then company()
  P4.2 <- read_file("www/P4.2.txt")
  
  output$Sidebar <- renderUI({
    if (input$Tabs == "Cover Letter"){
    tagList(
    #Address Line 1 [Company]
    textInput("Add1",
              "Address Line 1",
              value = "The Barry Bluestone Paper Company"),
    #Address Line 2 [Street and Number]
    textInput("Add2",
              "Address Line 2",
              value = "1135 Tremont St"),
    #Address Line 3 [optional, suite number, apt, etc.]
    textInput("Add3",
              "Address Line 3 (Optional)",
              value = "Suite 310"),
    #Address Line 4 [Town and Zip with "," separator]
    textInput("Add4",
              "Address Line 4",
              value = "Boston, MA 02115"),
    
    #Date input [could just be a function of "sys.date" or something]
    
    #Company/Division 1 [usually the General name of the company]
    textInput("CompName",
              "Company Name",
              value = "The Barry Bluestone Paper Company"),
    
    #Position Title
    textInput("Position",
              "Position Title",
              value = "Barry's Boy"),
    
    #Division/Location [Division if it's a specific school, location if it's a main branch of a company, blank otherwise, I guess]
    textInput("DivLoc",
              "Division/Location",
              value = "School of Public Policy"),
    
    textAreaInput("Para1.1",
                  "Paragraph 1.1 Input",
                  value = paste(P1.0),
                  resize = "vertical"),
    textAreaInput("Para1.2",
                  "Paragraph 1.2 Input",
                  value = paste(P1.1),
                  resize = "vertical"),
    textAreaInput("Para1.3",
                  "Paragraph 1.3 Input",
                  value = paste(P1.2),
                  resize = "vertical"),
    textAreaInput("Para2.1",
                  "Paragraph 2.1 Input",
                  value = paste(P2.1),
                  resize = "vertical"),
    textAreaInput("Para2.2",
                  "Paragraph 2.2 Input",
                  value = paste(P2.2),
                  resize = "vertical"),
    textAreaInput("Para3",
                  "Paragraph 3 Input",
                  value = paste(P3),
                  resize = "vertical"),
    textAreaInput("Para4.1",
                  "Paragraph 4.1 Input",
                  value = paste(P4.1),
                  resize = "vertical"),
    textAreaInput("Para4.2",
                  "Paragraph 4.2 Input",
                  value = paste(P4.2),
                  resize = "vertical")
    )
    } else if (input$Tabs == "Resume"){
      tagList(
        #Address Line 1 [Company]
        textInput("Add1",
                  "Address Line 1",
                  value = "The Barry Bluestone Paper Company")
      )
    }
  })

  
ad1 <- reactive({
  input$Add1
})
ad2 <- reactive({
  input$Add2
})
ad3 <- reactive({
  input$Add3
})
ad4 <- reactive({
  input$Add4
})

#evaluate if a vector has anything written in it, paste it with "\n" after it.
#This will cause there to be empty breaks because of how paste works
adeval <- reactive({
  paste(
  if (nchar(ad1()) > 0){
    ad1()
  } else{
    NULL
  },
  if (nchar(ad2()) > 0){
    ad2()
  } else{
    NULL
  },
  if (nchar(ad3()) > 0){
    ad3()
  } else{
    NULL
  },
  if (nchar(ad4()) > 0){
    ad4()
  } else{
    NULL
  },
  sep = "\n"
)
})

#This takes the output code from adeval and removes any blank breaks, or lines that have two "\n"s, which out optional ad line 3 would if it is left blank
adedit <- reactive({
  gsub("\n\n", "\n", adeval())
})

company <- reactive({
  input$CompName
})
Position <- reactive({
  input$Position
})
DiviLoc <- reactive({
  input$DivLoc
})



PR1.1 <- reactive({
  input$Para1.1
})

PR1.2 <- reactive({
  input$Para1.2
})

PR1.3 <- reactive({
  input$Para1.3
})

PR2.1 <- reactive({
  input$Para2.1
})

PR2.2 <- reactive({
  input$Para2.2
})

PR3 <- reactive({
  input$Para3
})

PR4.1 <- reactive({
  input$Para4.1
})

PR4.2 <- reactive({
  input$Para4.2
})


Par1 <- reactive({
  paste(PR1.1(), company(), PR1.2(), company(), PR1.3(), sep = " ")
})


Par2 <- reactive({
  paste(PR2.1(), Position(), PR2.2(), sep = " ")
})

Par3 <- reactive({
  paste(PR3())
})

Par4 <- reactive({
  paste(PR4.1(), company(), PR4.2(), sep = " ")
})


output$CoverText1 <- renderText({
  paste(Par1())
})
output$CoverText2 <- renderText({
  paste(Par2())
})
output$CoverText3 <- renderText({
  paste(Par3())
})
output$CoverText4 <- renderText({
  paste(Par4())
})

fname <- reactive({
  paste("Cover Letter--", Position(), "-", company(), ".pdf", sep = "")
})
observeEvent(input$knit, {
  #save all inputs
  write(adedit(), file = "www/Cover Letters/Markdown/InputsDrop/AddressFull.txt")
  write(ad1(), file = "www/Cover Letters/Markdown/InputsDrop/Add1.txt")
  write(ad2(), file = "www/Cover Letters/Markdown/InputsDrop/Add2.txt")
  write(ad3(), file = "www/Cover Letters/Markdown/InputsDrop/Add3.txt")
  write(ad4(), file = "www/Cover Letters/Markdown/InputsDrop/Add4.txt")
  write(company(), file = "www/Cover Letters/Markdown/InputsDrop/CompName.txt")
  write(Position(), file = "www/Cover Letters/Markdown/InputsDrop/PosName.txt")
  write(DiviLoc(), file = "www/Cover Letters/Markdown/InputsDrop/DivisionLocation.txt")
  write(Par1(), file = "www/Cover Letters/Markdown/InputsDrop/Par1.txt")
  write(Par2(), file = "www/Cover Letters/Markdown/InputsDrop/Par2.txt")
  write(Par3(), file = "www/Cover Letters/Markdown/InputsDrop/Par3.txt")
  write(Par4(), file = "www/Cover Letters/Markdown/InputsDrop/Par4.txt")
  
  
  #Knit Markdown from saved inputs to the desired local Spot
  render(input = "www/CLBLANKFILL.Rmd", 
         output_format = "pdf_document",
         #The location that you ultimately want the PDF to be saved to
         output_dir = "www/Cover Letters/Sent/AutoOutputs",
         output_file = fname(),
         quiet = TRUE)
  
  #Save a version that is just the most recent so that it can be easily viewed in the App
  render(input = "www/CLBLANKFILL.Rmd", 
         output_format = "pdf_document",
         #you need to make sure that you have a "www" folder in the folder that this app is located in. Put the pdf you want to view there
         output_dir = "www",
         output_file = "Last.pdf",
         quiet = TRUE)
  #Generate the in-page view from the "Last" letter generated
  output$CoverLetterView <- renderUI({
    my_test <- tags$iframe(height = 600, width = "100%", src="Last.pdf")
    return({my_test})
    #print(my_test)
    #my_test
    
  })
  updateTabsetPanel(session, "TabDeep1",
                    selected = "PDF View")
  })
})