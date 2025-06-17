library(shiny)
library(shinythemes)
library(markdown)
library(DT)
library(bslib)
library(rmarkdown)
library(plotly)
library(shinyWidgets)
library(shinycssloaders)
library(shinyjs)

# Helper function to dynamically list and load project files
list_projects <- function() {
  project_files <- list.files("projects", pattern = "\\.Rmd$", full.names = FALSE)
  project_names <- gsub("\\.Rmd$", "", project_files)
  return(list(files = project_files, names = project_names))
}

# Function to extract markdown content from Rmd
extract_markdown <- function(rmd_file) {
  lines <- readLines(rmd_file, warn = FALSE)
  # Remove YAML header
  if (length(lines) > 0 && grepl("^---", lines[1])) {
    end_yaml <- which(grepl("^---", lines))[2]
    if (!is.na(end_yaml)) {
      lines <- lines[(end_yaml+1):length(lines)]
    }
  }
  
  # Replace R code chunks with code block indicators
  in_chunk <- FALSE
  for (i in 1:length(lines)) {
    if (grepl("^```\\{r", lines[i])) {
      in_chunk <- TRUE
      lines[i] <- "```r"
    } else if (in_chunk && grepl("^```", lines[i])) {
      in_chunk <- FALSE
    }
  }
  
  return(paste(lines, collapse = "\n"))
}

# UI
ui <- navbarPage(
  id = "mainNavbar",
  title = span(icon("chart-line"), "Project Portfolio"),
  theme = bs_theme(
    bootswatch = "minty",
    primary = "#2C3E50",
    "navbar-bg" = "#2C3E50",
    base_font = font_google("Roboto"),
    heading_font = font_google("Montserrat"),
    font_scale = 1.05
  ),
  header = tagList(
    useShinyjs(),
    tags$style(HTML("
      body {
        font-family: 'Roboto', sans-serif;
        line-height: 1.6;
        color: #333;
      }
      h1, h2, h3, h4, h5, h6 {
        font-family: 'Montserrat', sans-serif;
        font-weight: 600;
        margin-bottom: 20px;
        color: #2C3E50;
      }
      .container {
        max-width: 1200px;
        padding: 40px 15px;
      }
      .jumbotron {
        background-color: #ecf0f1;
        border-radius: 10px;
        box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        padding: 40px 30px;
        margin-bottom: 30px;
        transition: all 0.3s ease;
      }
      .jumbotron:hover {
        box-shadow: 0 8px 16px rgba(0,0,0,0.2);
      }
      .well {
        border-radius: 8px;
        box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        padding: 25px;
        margin-bottom: 30px;
        transition: all 0.3s ease;
        background-color: #fff;
        border: 1px solid #e9ecef;
      }
      .well:hover {
        box-shadow: 0 5px 15px rgba(0,0,0,0.1);
      }
      .profile-img {
        border-radius: 50%;
        border: 5px solid white;
        box-shadow: 0 4px 8px rgba(0,0,0,0.2);
        transition: transform 0.3s ease;
        margin-bottom: 20px;
      }
      .profile-img:hover {
        transform: scale(1.05);
      }
      .nav-tabs {
        margin-bottom: 30px;
      }
      .section-title {
        border-left: 5px solid #2C3E50;
        padding-left: 15px;
        margin-bottom: 25px;
      }
      .contact-icon {
        font-size: 28px;
        margin-right: 10px;
        color: #2C3E50;
        transition: color 0.3s ease;
      }
      .contact-icon:hover {
        color: #3498db;
      }
      .skill-badge {
        background-color: #3498db;
        color: white;
        padding: 8px 15px;
        border-radius: 20px;
        margin: 8px;
        display: inline-block;
        font-size: 14px;
        font-weight: 500;
        letter-spacing: 0.5px;
      }
      .btn {
        border-radius: 30px;
        padding: 10px 20px;
        font-weight: 500;
        letter-spacing: 0.5px;
        transition: all 0.3s ease;
      }
      .btn-primary {
        background-color: #3498db;
        border-color: #3498db;
      }
      .btn-primary:hover {
        background-color: #2980b9;
        border-color: #2980b9;
        transform: translateY(-2px);
        box-shadow: 0 4px 8px rgba(0,0,0,0.1);
      }
      p {
        font-size: 16px;
        margin-bottom: 20px;
        color: #555;
      }
      .form-control {
        border-radius: 8px;
        padding: 10px 15px;
        border: 1px solid #ddd;
      }
      .form-control:focus {
        border-color: #3498db;
        box-shadow: 0 0 0 0.2rem rgba(52, 152, 219, 0.25);
      }
      .navbar {
        padding: 10px 20px;
        box-shadow: 0 2px 10px rgba(0,0,0,0.1);
      }
      .navbar-brand {
        font-family: 'Montserrat', sans-serif;
        font-weight: 600;
        font-size: 22px;
      }
      .nav-link {
        font-weight: 500;
        padding: 10px 15px !important;
        margin: 0 5px;
      }
      .dataTables_wrapper {
        padding: 20px 0;
      }
      .shiny-input-container {
        margin-bottom: 20px;
      }
      /* Fix for project content */
      #project_content {
        padding: 20px;
        background: white;
        border-radius: 8px;
        overflow-x: auto;
      }
      #project_content img {
        max-width: 100%;
        height: auto;
      }
      #project_content pre {
        overflow-x: auto;
      }
    "))
  ),
  
  # Home Tab
  tabPanel(
    "Home",
    icon = icon("home"),
    div(
      class = "container",
      style = "margin-top: 30px;",
      fluidRow(
        column(
          width = 8, offset = 2,
          div(
            class = "jumbotron text-center",
            h1("Welcome to My Portfolio", class = "animated fadeIn"),
            img(src = "https://img.icons8.com/bubbles/200/user.png", height = "auto", width = 200, class = "profile-img"),
            h3("Sanath R"),
            p("I am passionate about data analysis, visualization, and building interactive web applications using R and Shiny."),
            div(
              style = "margin-top: 30px;",
              actionButton("view_projects_btn", "View My Projects", 
                          icon = icon("folder-open"), 
                          class = "btn-primary btn-lg")
            )
          )
        )
      ),
      
      fluidRow(
        column(
          width = 8, offset = 2,
          div(
            class = "well",
            h2("About Me", class = "section-title"),
            p("I specialize in data analysis, statistical modeling, and creating interactive dashboards. 
              With expertise in R, Shiny, and data visualization, I transform complex data into actionable insights."),
            p("My background includes experience in various industries including finance, healthcare, and e-commerce, 
              where I've applied my analytical skills to solve real-world problems.")
          )
        )
      ),
      
      fluidRow(
        column(
          width = 8, offset = 2,
          div(
            class = "well",
            h2("Skills & Expertise", class = "section-title"),
            div(
              style = "text-align: center; padding: 10px 0;",
              tags$span("R Programming", class = "skill-badge"),
              tags$span("Data Visualization", class = "skill-badge"),
              tags$span("Statistical Analysis", class = "skill-badge"),
              tags$span("Machine Learning", class = "skill-badge"),
              tags$span("Shiny Apps", class = "skill-badge"),
              tags$span("Dashboard Development", class = "skill-badge"),
              tags$span("SQL", class = "skill-badge"),
              tags$span("Python", class = "skill-badge")
            )
          )
        )
      )
    )
  ),
  
  # Projects Tab
  tabPanel(
    "Projects",
    icon = icon("folder-open"),
    div(
      class = "container",
      style = "margin-top: 30px;",
      fluidRow(
        column(
          width = 3,
          div(
            class = "well",
            h3("My Projects", class = "section-title"),
            uiOutput("project_selector"),
            hr(),
            h4("Project Categories"),
            checkboxGroupInput("project_filter", "Filter by:",
                              choices = c("Data Analysis", "Visualization", "Machine Learning", "Dashboard"),
                              selected = c("Data Analysis", "Visualization", "Machine Learning", "Dashboard"))
          )
        ),
        column(
          width = 9,
          div(
            class = "well",
            withSpinner(uiOutput("project_content"), type = 4, color = "#2C3E50")
          )
        )
      )
    )
  ),
  
  # Resume Tab
  tabPanel(
    "Resume",
    icon = icon("file-alt"),
    div(
      class = "container",
      style = "margin-top: 30px;",
      fluidRow(
        column(
          width = 10, offset = 1,
          div(
            class = "well",
            h2("Professional Experience", class = "section-title"),
            withSpinner(DTOutput("resume_table"), type = 4, color = "#2C3E50")
          )
        )
      ),
      fluidRow(
        column(
          width = 10, offset = 1,
          div(
            class = "well",
            h2("Education", class = "section-title"),
            tags$ul(
              style = "padding-left: 20px; list-style-type: none;",
              tags$li(
                style = "margin-bottom: 25px;",
                h4("Master of Science in Data Science"),
                p(icon("university", style = "margin-right: 10px;"), "University of Data Science, 2016-2020"),
                p(icon("file-alt", style = "margin-right: 10px;"), "Thesis: Advanced Predictive Modeling for Customer Behavior Analysis")
              ),
              tags$li(
                style = "margin-bottom: 25px;",
                h4("Bachelor of Science in Statistics"),
                p(icon("university", style = "margin-right: 10px;"), "State University, 2012-2016"),
                p(icon("award", style = "margin-right: 10px;"), "Graduated with Honors, GPA: 3.8/4.0")
              )
            )
          )
        )
      ),
      fluidRow(
        column(
          width = 10, offset = 1,
          div(
            class = "well",
            h2("Certifications", class = "section-title"),
            tags$ul(
              style = "padding-left: 20px; list-style-type: none;",
              tags$li(
                style = "margin-bottom: 15px;",
                h4(icon("certificate", style = "margin-right: 10px; color: #f39c12;"), "Certified Data Scientist, Data Science Association, 2019")
              ),
              tags$li(
                style = "margin-bottom: 15px;",
                h4(icon("certificate", style = "margin-right: 10px; color: #f39c12;"), "Advanced R Programming, R Studio, 2018")
              ),
              tags$li(
                style = "margin-bottom: 15px;",
                h4(icon("certificate", style = "margin-right: 10px; color: #f39c12;"), "Machine Learning Specialist, ML Institute, 2017")
              )
            )
          )
        )
      )
    )
  ),
  
  # Contact Tab
  tabPanel(
    "Contact",
    icon = icon("envelope"),
    div(
      class = "container",
      style = "margin-top: 30px;",
      fluidRow(
        column(
          width = 6, offset = 3,
          div(
            class = "well",
            h2("Get in Touch", class = "section-title"),
            div(
              class = "text-center", style = "margin: 30px 0;",
              tags$a(href = "mailto:your.email@example.com", icon("envelope", class = "contact-icon"), "Email Me", style = "display: block; margin-bottom: 20px; font-size: 18px; text-decoration: none;"),
              tags$a(href = "https://github.com/yourusername", icon("github", class = "contact-icon"), "GitHub", style = "display: block; margin-bottom: 20px; font-size: 18px; text-decoration: none;"),
              tags$a(href = "https://linkedin.com/in/yourprofile", icon("linkedin", class = "contact-icon"), "LinkedIn", style = "display: block; margin-bottom: 20px; font-size: 18px; text-decoration: none;"),
              tags$a(href = "https://twitter.com/yourhandle", icon("twitter", class = "contact-icon"), "Twitter", style = "display: block; margin-bottom: 20px; font-size: 18px; text-decoration: none;")
            )
          )
        )
      ),
      fluidRow(
        column(
          width = 6, offset = 3,
          div(
            class = "well",
            h2("Contact Form", class = "section-title"),
            textInput("contact_name", "Name", "", placeholder = "Your Name"),
            textInput("contact_email", "Email", "", placeholder = "your.email@example.com"),
            textAreaInput("contact_message", "Message", "", height = 150, placeholder = "Type your message here..."),
            div(
              style = "text-align: center; margin-top: 30px;",
              actionButton("send_message", "Send Message", icon = icon("paper-plane"), class = "btn-primary btn-lg")
            )
          )
        )
      )
    )
  )
)

# Server
server <- function(input, output, session) {
  
  # Navigate to projects when button clicked
  observeEvent(input$view_projects_btn, {
    updateTabsetPanel(session, "mainNavbar", selected = "Projects")
  })
  
  # Dynamically generate project selector
  output$project_selector <- renderUI({
    projects <- list_projects()
    selectInput("selected_project", "Select Project:", choices = setNames(projects$files, projects$names))
  })
  
  # Render selected project content
  output$project_content <- renderUI({
    req(input$selected_project)
    project_path <- file.path("projects", input$selected_project)
    
    # Check if file exists
    if (file.exists(project_path)) {
      tryCatch({
        # Create a temporary HTML file from the Rmd
        temp_html <- tempfile(fileext = ".html")
        rmarkdown::render(project_path, output_file = temp_html, quiet = TRUE)
        
        # Include the HTML content
        includeHTML(temp_html)
      }, error = function(e) {
        # Fallback if rendering fails
        project_content <- readLines(project_path, warn = FALSE)
        HTML(paste0("<div class='alert alert-warning'>", 
                    "Note: Simple preview mode shown. Install required packages for full rendering.", 
                    "</div>",
                    "<pre>", paste(project_content, collapse = "\n"), "</pre>"))
      })
    } else {
      h3("Project file not found")
    }
  })
  
  # Load and display resume data
  output$resume_table <- renderDT({
    resume_data <- read.csv("data/resume.csv")
    datatable(
      resume_data,
      options = list(
        pageLength = 10,
        autoWidth = TRUE,
        dom = 'Bfrtip',
        buttons = c('copy', 'csv', 'excel', 'pdf')
      ),
      rownames = FALSE,
      filter = 'top',
      class = 'cell-border stripe'
    )
  })
  
  # Contact form submission
  observeEvent(input$send_message, {
    if (input$contact_name != "" && input$contact_email != "" && input$contact_message != "") {
      showModal(modalDialog(
        title = "Thank You!",
        "Your message has been received. I'll get back to you soon.",
        easyClose = TRUE,
        footer = modalButton("Close")
      ))
      
      # Reset form
      updateTextInput(session, "contact_name", value = "")
      updateTextInput(session, "contact_email", value = "")
      updateTextAreaInput(session, "contact_message", value = "")
    } else {
      showModal(modalDialog(
        title = "Incomplete Form",
        "Please fill out all fields.",
        easyClose = TRUE,
        footer = modalButton("Close")
      ))
    }
  })
}

# Run the application
shinyApp(ui = ui, server = server) 