# Load packages
install.packages("pacman")
pacman::p_load("tidyverse", "readxl")

#Import data
Pseudo_res_data <- read_excel("input/Pseudo_res_data.xlsx")


# Remove AmpC and FOS (later problem...)
clean_pseudo_res_data <- Pseudo_res_data %>%
  filter(Antibiotic != "AMPC+" & Antibiotic != "FOS")

clean_pseudo_res_data <- clean_pseudo_res_data %>%
  group_by(SpecNo) %>%
  mutate(ESBL = if_else(any(Antibiotic == "ESBL+"), "ESBL", "No")) %>%
  mutate(Sensitivity_ESBL = case_when((Antibiotic == "AMX" | Antibiotic == "AMC") & 
                                        ESBL == "ESBL" & 
                                        Sensitivity == "S" ~ "E",
                                      TRUE ~ Sensitivity)) %>%
  filter(Antibiotic != "ESBL+")
  

test_data <- clean_pseudo_res_data %>%
  count(Organism, Antibiotic, Sensitivity) 


test_data %>%
  group_by(Antibiotic, Organism) %>%
  mutate(total = sum(n)) %>%
  mutate(percentage = n / sum(n) * 100) %>%
  saveRDS(file = "output/results/test_data.rds")

test_data_ESBL <- clean_pseudo_res_data %>%
  count(Organism, Antibiotic, Sensitivity_ESBL) 

test_data_ESBL %>%
  group_by(Antibiotic, Organism) %>%
  mutate(total = sum(n)) %>%
  mutate(percentage = n / sum(n) * 100) %>%
  saveRDS(file = "output/results/test_data_ESBL.rds")

