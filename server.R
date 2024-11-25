library(shiny)

shinyServer(function(input, output, session) {
  # Load data
  data <- read.csv("index.csv", stringsAsFactors = FALSE)
  
  # Add "All" option and populate selectInput choices
  observe({
    updateSelectInput(session, "datasource", choices = c("All", unique(data$datasource)))
    updateSelectInput(session, "funding", choices = c("All", unique(data$funding)))
  })
  
  # Reactive filtering
  filteredData <- reactive({
    req(input$datasource, input$funding)
    filtered <- data
    if (input$datasource != "All") {
      filtered <- filtered[filtered$datasource == input$datasource, ]
    }
    if (input$funding != "All") {
      filtered <- filtered[filtered$funding == input$funding, ]
    }
    filtered <- filtered[order(filtered$title), ] # Sort alphabetically by title
    filtered
  })
  
  # Render table
  output$filteredTable <- renderTable({
    filtered <- filteredData()
    if (nrow(filtered) == 0) {
      return(data.frame(Message = "No results found"))
    }
    
    # Update the hyperlinks to be blank if DOI or Live App is missing
    filtered$gitlink <- sprintf('<a href="%s">GitHub</a>', filtered$gitlink)
    filtered$doi <- ifelse(filtered$doi == "", "", sprintf('<a href="%s">DOI</a>', filtered$doi))
    filtered$liveapp <- ifelse(filtered$liveapp == "", "", sprintf('<a href="%s">Live App</a>', filtered$liveapp))
    
    # Select columns and update column names
    filtered <- filtered[, c("title", "description", "gitlink", "doi", "liveapp")]
    colnames(filtered) <- c("Title", "Description", "GitHub", "DOI", "Live App")
    
    # Enable HTML rendering in the table
    knitr::kable(filtered, format = "html", escape = FALSE, row.names = FALSE)
  }, sanitize.text.function = function(x) x)
})
