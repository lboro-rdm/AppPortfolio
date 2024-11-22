library(shiny)

# Function to create a card
create_card <- function(title, url) {
  div(
    style = "display: flex; justify-content: center; align-items: center; height: 100%;",
    div(
      class = "card",
      style = "width: 18rem; border: 1px solid #6a0dad; border-radius: 10px; 
               padding: 15px; background-color: #e6ccff; text-align: center;",
      tags$a(
        title,
        href = url,
        target = "_blank",
        style = "text-decoration: none; color: #4b0082; font-weight: bold; font-size: 18px;"
      )
    )
  )
}

ui <- navbarPage(
  title = "R/Apps Index",
  includeCSS("www/styles.css"), # Link your custom CSS
  
# Home ----
tabPanel("Home", 
        h1("Welcome"),
         
        tags$ul(
           tags$li(tags$a("Talis Aspire Link Checker", href = "#"))
        ),
        p(strong("Apps made with Arts Council England Funding:")),
        tags$li(tags$a("WordCloud My Repo", href = "#")),
        p(),
        p(strong("Apps made with data from Figshare:")),
        tags$li(tags$a("WordCloud My Repo", href = "#"))
),

  
# Talis Aspire Link Checker ----
  
  tabPanel("Talis Aspire Link Checker", 
           p("The ", strong("Talis Aspire Link Checker"), " runs through a spreadsheet export of all the links from the Talis Aspire reading list system and checks for broken links."),
           p("This app was coded specifically for the reading list migration at Loughborough University Library in 2023.",
             style = "margin-bottom: 50px;"),

           column(6,
                  create_card("Get the code", "https://github.com/lboro-rdm/TalisAspireLinkChecker.git")),
           column(6,
                  create_card("Cite this item", "https://doi.org/10.17028/rd.lboro.27889197")),
),
           
# WordCloud My Repo ----
           
tabPanel("WordCloud My Repo", 
         
         p(
           "A shiny app that creates word clouds from a list of titles chosen in the ", 
           tags$a("Loughborough University Research Repository", href = "https://repository.lboro.ac.uk"), style = "margin-bottom: 50px;"
         ),
         
         fluidRow(  # Added fluidRow to layout the columns
           column(4, 
                  create_card("View live app", "https://research-data-lboro.shinyapps.io/WordCloudMyRepo/")
           ),
           column(4, 
                  create_card("Get the code", "https://github.com/lboro-rdm/WordCloudMyRepo.git")
           ),
           column(4, 
                  create_card("Cite this item", "https://doi.org/10.17028/rd.lboro.27380634")
           )
         ),
         p(
           "This app was funded by the ", 
           a("Arts Council England Develop Your Creative Practice Grant", href = "https://www.artscouncil.org.uk/dycp"),
           style = "margin-top: 50px;"),
         p(tags$img(src = "logo.png", width = "300px")),
),


tabPanel("Contact", h1("Get in Touch"))
)

# Server code ----

server <- function(input, output, session) {}

shinyApp(ui, server)
