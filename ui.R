
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyUI(fluidPage(

  # Application title
  titlePanel("H-INDEX PREDICTOR"),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      sliderInput("h_target",
                  "Target h-index:",
                  min = 1,
                  max = 50,
                  value = 10),

      numericInput("year_start",
                  "Starting year:",
                  value = 2011),
      
      sliderInput("n_sim",
                  "Number of simulation:",
                  min = 1,
                  max = 50,
                  value = 10),
      
      checkboxInput("autocite", label = "I love my paper. AUTOCITE MANIA!", value = F),
      
      tags$hr(),
      
      sliderInput("avg_paper_per_year",
                  "Average number of papers per year:",
                  min = 1,
                  max = 10,
                  value = 3),
      
      sliderInput("sd_paper_per_year",
                  "Deviation number of papers per year:",
                  min = 0,
                  max = 10,
                  value = 1),
      
      sliderInput("avg_IF",
                  "Average Impact Factor:",
                  min = 1,
                  max = 40,
                  value = 7),
      
      sliderInput("sd_IF",
                  "Deviation Impact Factor:",
                  min = 1,
                  max = 40,
                  value = 2)
      
    ),

    # Show a plot of the generated distribution
    mainPanel(
      titlePanel("Predictions"),
      
      plotOutput("distPlot")
    )
  )
))

#current <- c(9.3,3.1,6.8,6.8,3.9,2.3,2.9,6.8,3.1,3.1,6.8,5.5,9,3.1,22)
#mean(current)
#sd(current)

