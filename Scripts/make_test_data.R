# Load packages
install.packages("pacman")
pacman::p_load("tidyverse", "readxl")

#Import data
Pseudo_res_data <- read_excel("input/Pseudo_res_data.xlsx")


# Remove ESBL (later problem...)
clean_pseudo_res_data <- Pseudo_res_data %>%
  filter(Antibiotic != "AMPC+" & Antibiotic != "ESBL+" & Antibiotic != "FOS")

shared_data <- clean_pseudo_res_data %>%
  count(Organism, Antibiotic, Sensitivity) 

shared_data %>%
  group_by(Antibiotic, Organism) %>%
  mutate(total = sum(n)) %>%
  mutate(percentage = n / sum(n) * 100) %>%
  saveRDS(file = "output/results/test_data.rds")

