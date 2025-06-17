# Project Portfolio

An interactive portfolio web application built with R Shiny and R Markdown, designed for data scientists, analysts, and researchers to showcase their projects, skills, and professional experience.

## 🌟 Features

- **Responsive Design**: Mobile-friendly interface with modern styling
- **Dynamic Project Showcase**: Interactive R Markdown project rendering with code and visualizations
- **Interactive Resume**: Filterable and searchable resume using DataTables
- **Professional Styling**: Customized Bootstrap theme with enhanced UI components
- **Contact Form**: Built-in contact section with social media integration
- **Skill Visualization**: Visual representation of technical skills and proficiencies
- **Easy Customization**: Simple structure for personalizing content

## 📁 Project Structure

```
project-portfolio/
├── app.R                 # Main Shiny application with UI and server logic
├── install_packages.R    # Script to install required dependencies
├── documentation.Rmd     # Comprehensive documentation with examples
├── /projects             # R Markdown project files
│   ├── Sales Analysis.Rmd
│   └── Customer Segmentation.Rmd
├── /data                 # Data files
│   └── resume.csv        # Resume data in CSV format
├── /www                  # Static assets
│   └── profile.jpg       # Profile picture
```

## 🔧 Requirements

### R and RStudio
This application requires R (>= 4.0.0) and preferably RStudio for the best development experience.

### Required Packages
The application depends on the following R packages:

```r
packages <- c(
  "shiny",
  "shinythemes",
  "bslib",
  "shinyjs", 
  "DT",
  "rmarkdown",
  "knitr",
  "readr",
  "dplyr",
  "ggplot2",
  "plotly",
  "viridis",
  "fontawesome"
)
```

### Pandoc
R Markdown rendering requires Pandoc. If you don't have it installed, use the provided installer:

```
pandoc-installer.msi  # For Windows users
```

## Installation and Setup

### Quick Setup

1. Clone this repository:
```bash
git clone https://github.com/Sanath0106/Project_Portfolio_DatawareHouse.git
```

2. Install required packages:
```r
source("project-portfolio/install_packages.R")
```

3. Verify Pandoc installation:
```r
rmarkdown::pandoc_available()
```

### Running Locally

To run the application locally:

```r
# From R console
setwd("path/to/project-portfolio")
shiny::runApp()

# Or from command line
R -e "shiny::runApp('path/to/project-portfolio')"
```

The app will be available at http://localhost:xxxx (where xxxx is the port assigned by Shiny).

## Customizing Your Portfolio

### Personal Information
Edit the app.R file to update personal information in the Home tab:

```r
# Locate the Home tab section and update:
tabPanel("Home",
  fluidRow(
    column(4,
      div(class = "well",
        img(src = "profile.jpg", width = "100%", class = "profile-img"),
        h2("Your Name"),  # Change this
        p("Data Scientist"), # Change this
        ...
```

### Adding Projects
Create new R Markdown files in the `projects/` directory following the existing templates.

### Updating Resume
Edit the `data/resume.csv` file with your experience, education, and skills.

### Changing Styling
Modify the CSS styles in the `app.R` file's `tags$style(HTML("..."))` section.

## Deployment

### Deploying to shinyapps.io

1. Install the `rsconnect` package:
```r
install.packages("rsconnect")
```

2. Set up your shinyapps.io account credentials:
```r
rsconnect::setAccountInfo(
  name = "your-account-name",
  token = "YOUR_TOKEN",
  secret = "YOUR_SECRET"
)
```

3. Deploy the application:
```r
rsconnect::deployApp(
  appDir = "path/to/project-portfolio",
  appName = "data-science-portfolio",
  appTitle = "My Data Science Portfolio"
)
```

### Alternative Deployment Options

- **Shiny Server**: For self-hosting on your own server
- **RStudio Connect**: For enterprise deployment with authentication
- **Docker**: Containerized deployment using the rocker/shiny image

## Documentation

Comprehensive documentation is available in the `documentation.Rmd` file, which includes:

- Detailed component explanations
- Customization options
- Advanced usage examples
- Troubleshooting tips

## Known Issues and Troubleshooting

- If R Markdown projects fail to render, ensure Pandoc is correctly installed
- For image display issues, check file paths and permissions
- If the app crashes with memory errors when rendering large projects, adjust memory allocation in R

## Acknowledgments

- Built with [R Shiny](https://shiny.rstudio.com/)
- Styling enhanced with [bslib](https://rstudio.github.io/bslib/)
- Table rendering with [DT](https://rstudio.github.io/DT/)
- Documentation powered by R Markdown 