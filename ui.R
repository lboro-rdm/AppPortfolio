library(DT)

shinyUI(fluidPage(
  includeCSS("www/styles.css"),  # Link your custom CSS
  titlePanel("Lboro University Library Shiny Apps"),
  
  fluidRow(
    column(6,
           p("These apps were created by Lara Skelly, for Loughborough University Library."),
           p("Some of these apps were created with funding from Arts Council England.")
    ),
    column(6,
           tags$div(style = "text-align: right;",
                    tags$img(src = "logo.png", width = "300px")
           )
    )
  ),
  
  p(),
  p(),
  
  sidebarLayout(
    sidebarPanel(
      selectInput("datasource", "Data source:", choices = NULL, selected = "All"),
      selectInput("funding", "Funding:", choices = NULL, selected = "All"),
      selectInput("status", "Status:", choices = NULL, selected = "All"),
      p(),
      p("The code for this app can be found at ", a("GitHub", href = "https://github.com/lboro-rdm/AppPortfolio.git"))
    ),
    mainPanel(
      DTOutput("filteredTable")
    )
  )
))
