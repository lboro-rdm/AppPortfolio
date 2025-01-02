library(shiny)
library(DT)
library(httr)
library(readr)
library(jsonlite)
library(tidyverse)

shinyServer(function(input, output, session) {
  
  files_url <- "https://api.figshare.com/v2/articles/28123439/files"
  files_response <- GET(files_url)
  
  files_info <- fromJSON(content(files_response, "text", encoding = "UTF-8"))
  file_url <- files_info$download_url 
  file_response <- GET(file_url)
  
  writeBin(content(file_response, "raw"), "index.csv")
  data <- read.csv("index.csv", stringsAsFactors = FALSE)  # Use FALSE to avoid factors
  
  # Transform the funding column into a list of funders
  data <- data %>%
    mutate(funding = str_split(funding, ",\\s*"))  # Split funding into a list
  
  observe({
    req(data)  # Ensure data is available
    
    # Update select inputs based on the data
    updateSelectInput(session, "datasource", choices = c("All", sort(unique(data$datasource))))
    
    # Create a vector of unique funders from the funding column
    unique_funders <- data %>%
      unnest(funding) %>%  # Expand the list of funders into separate rows
      distinct(funding) %>%  # Get unique funders
      pull(funding)  # Extract the funding column as a vector
    
    updateSelectInput(session, "funding", choices = c("All", sort(unique(unique_funders))))
    updateSelectInput(session, "status", choices = c("All", sort(unique(data$status))))
  })
  
  # Reactive filtering
  filteredData <- reactive({
    req(data)  # Ensure data is available
    filtered <- data
    
    req(input$datasource, input$funding, input$status)  # Ensure inputs are available
    
    # Filter by other inputs
    if (input$datasource != "All") {
      filtered <- filtered[filtered$datasource == input$datasource, ]
    }
    if (input$funding != "All") {
      filtered <- filtered %>%
        filter(sapply(funding, function(funder_list) input$funding %in% funder_list))
    }
    if (input$status != "All") {
      filtered <- filtered[filtered$status == input$status, ]
    }
    filtered <- filtered[order(filtered$title), ]  # Sort alphabetically by title
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
    datatable(filtered, escape = FALSE, rownames = FALSE, options = list(paging = FALSE))
  })
})
