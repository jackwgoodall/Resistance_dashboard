################################################################################
# To build you need the right source file (which can be extracted by C&P the SQL 
# command) and placed into the input folder.
# You should then be able to generate an html into the 'output' folder running
# this file.
# I've hashed out some stuff at the bottom which should make an archive... 
# Future problem... 
################################################################################

html_output_name <- "Test Data Dashboard"
code_output_name <- "Example Dashboard - R source code"

# Create output directories if they don't exist
if(!dir.exists("output/data")) {
  dir.create("output/data", recursive = TRUE)
}
if(!dir.exists("output/results")) {
  dir.create("output/results", recursive = TRUE)
}

# Import and clean the raw data
source("scripts/make_test_data.R", local=new.env())

# Render the dashboard to HTML
rmarkdown::render(
  here::here("test_dashboard.Rmd"),
  output_dir = "output",
  output_file = glue::glue("{html_output_name}.html"),
  envir = new.env()
)
# Create a ZIP archive with the HTML dashboard
#zip::zipr(
#  zipfile = glue::glue("output/{html_output_name}.zip"),
 # files = glue::glue("output/{html_output_name}.html")
#)

# Create a ZIP archive with the source code
#files <- list.files()
#files <- files[!grepl("^output$", files)] # Don't include output folder
#zip::zipr(
#  zipfile = glue::glue("output/{code_output_name}.zip"),
#  files = files
#)