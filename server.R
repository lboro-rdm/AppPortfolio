library(shiny)
library(DT)

shinyServer(function(input, output, session) {
  # Load data
  data <- read.csv("index.csv", stringsAsFactors = FALSE)
  
  # Add "All" option and populate selectInput choices
  observe({
    updateSelectInput(session, "datasource", choices = c("All", unique(data$datasource)))
    updateSelectInput(session, "funding", choices = c("All", unique(data$funding)))
    updateSelectInput(session, "status", choices = c("All", unique(data$status)))
  })
  
  # Reactive filtering
  filteredData <- reactive({
    req(input$datasource, input$funding, input$status)
    filtered <- data
    if (input$datasource != "All") {
      filtered <- filtered[filtered$datasource == input$datasource, ]
    }
    if (input$funding != "All") {
      filtered <- filtered[filtered$funding == input$funding, ]
    }
    if (input$status != "All") {
      filtered <- filtered[filtered$status == input$status, ]
    }
    filtered <- filtered[order(filtered$title), ] # Sort alphabetically by title
    filtered
  })
  
  # Render table
  output$filteredTable <- renderDT({
    filtered <- filteredData()
    if (nrow(filtered) == 0) {
      return(data.frame(Message = "No results found"))
    }
    
    # Update hyperlinks
    filtered$gitlink <- sprintf('<a href="%s">GitHub</a>', filtered$gitlink)
    filtered$doi <- ifelse(filtered$doi == "", "", sprintf('<a href="%s">DOI</a>', filtered$doi))
    filtered$liveapp <- ifelse(filtered$liveapp == "", "", sprintf('<a href="%s">Live App</a>', filtered$liveapp))
    
    # Select columns and rename
    filtered <- filtered[, c("title", "description", "status", "gitlink", "doi", "liveapp")]
    colnames(filtered) <- c("Title", "Description", "Status", "GitHub", "DOI", "Live App")
    
    # Return interactive table
    datatable(filtered, escape = FALSE, rownames = FALSE, options = list(pageLength = 10))
  })
  
})