################################################################################
# To build you need to enter the dates required below.
# You should then be able to generate an html into the 'output' folder running
# this file (clicking 'Source')
################################################################################

Start <- as.Date("01/06/2023", format = "%d/%m/%Y") ## Enter this as dd/mm/YYYY

End <- as.Date("01/06/2024", format = "%d/%m/%Y") ## Enter this as dd/mm/YYYY


html_output_name <- paste("STH Resistance Dashboard", format(Sys.Date(), "%d-%m-%Y"))
code_output_name <- "Example Dashboard - R source code"

pacman::p_load(tidyverse, flexdashboard, here)

# Create output directories if they don't exist
if(!dir.exists("output/data")) {
  dir.create("output/data", recursive = TRUE)
}
if(!dir.exists("output/results")) {
  dir.create("output/results", recursive = TRUE)
}

### Delete the files from data (i.e. a clean start).  This ensures that if anything fails, you don't just get shown old data. 
# Define the path to the 'output' directory
output_dir <- here("output/data")

# List all files and directories in the 'output' directory
all_items <- list.files(output_dir, full.names = TRUE)

# Filter out directories and only keep files
files_only <- all_items[!file.info(all_items)$isdir]

# Delete all files
file.remove(files_only)


### Save the date vectors
save(Start, End, file = "output/data/Dates.Rdata")

################### ## This could be either running e.g. a SQL query in a script (see README) or importing an excel/csv
### IMPORT THE DATA ## For the sake of a reproducible example I've used csv import here but I would strongly 
################### ## recommend a database search function if you can. 
df <- read_csv("dummy_data.csv", 
               col_types = cols(DTC = col_datetime(format = "%d/%m/%Y %H:%M")))
save(df, file = "output/data/df.Rdata")

### Main formatting 
source("scripts/format_main_data.R", local=new.env())

### Make the tables 

# make main tables
source("scripts/make_main_tables.R", local=new.env())

# make urine tables
source("scripts/make_urine_tables.R", local=new.env())


# Render the dashboard to HTML
rmarkdown::render(
  here::here("resistance_dashboard.Rmd"),
  output_dir = "output/results",
  output_file = glue::glue("{html_output_name}.html"),
  envir = new.env()
)

# Render the dashboard to index HTML (this isn't needed for local projects - I'm just using it to host a live page on GitHub)
rmarkdown::render(
  here::here("resistance_dashboard.Rmd"),
  output_file = glue::glue("index.html"),
  envir = new.env()
)