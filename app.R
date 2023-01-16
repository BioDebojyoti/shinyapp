library(shiny)
library(ggplot2)

# Define UI for miles per gallon app ----
ui <- pageWithSidebar(
  
  # App title ----
  headerPanel("Iris data"),
  
  # Sidebar panel for inputs ----
  sidebarPanel(
    
    # Input: Selector for variable to plot against mpg ----
    selectInput("variable", "Variable:", 
                c("Sepal Length" = "Sepal.Length",
                  "Sepal Width" = "Sepal.Width",
                  "Petal Length" = "Petal.Length",
                  "Petal Width" = "Petal.Width")),
    
    # Input: Checkbox for whether outliers should be included ----
    checkboxInput("outliers", "Show outliers", TRUE)
    
  ),
  
  # Main panel for displaying outputs ----
  mainPanel(
    
    # Output: Formatted text for caption ----
    h3(textOutput("caption")),
    
    # Output: Plot of the requested variable against mpg ----
    plotOutput("irisPlot")
  )
)


# Define server logic to plot various variables against mpg ----
server <- function(input, output) {
  
  # Compute the formula text ----
  # This is in a reactive expression since it is shared by the
  # output$caption and output$mpgPlot functions
  formulaText <- reactive({
    paste(input$variable, " ~ Species")
  })
  
  dependentVariable <- reactive({
    input$variable
  })
  # Return the formula text for printing as a caption ----
  output$caption <- renderText({
    formulaText()
  })
  
  # Generate a plot of the requested variable ----
  
  output$irisPlot <- renderPlot({
    
    #create boxplot
    boxplot(as.formula(formulaText()),
            data=iris,
            # main='Sepal Length by Species',
            xlab='Species',
            ylab=dependentVariable(),
            col='steelblue',
            border='black')
  
  })

}

shinyApp(ui, server)
