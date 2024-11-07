# Load packages
if(!requireNamespace('pacman', quietly=TRUE)){
  install_version('pacman')
}
pacman::p_load("tidyverse")

# Load the formatted data 
load("output/data/main_df.Rdata")

# Make ESBL

each_main <- main_df %>%
  filter(OrgDescrip_new != "Coag Neg Staphylococcus" & OrgDescrip_new != "Anaerobes") %>% # these are lumped together in the group below so shouldn't appear twice
  select(OrgDescrip_new, Antibiotic, Sensitivity_discrep) %>%
  count(OrgDescrip_new, Antibiotic, Sensitivity_discrep) %>%
  group_by(Antibiotic, OrgDescrip_new) %>%
  mutate(total = sum(n)) %>%
  mutate(percentage = n / sum(n) * 100) %>%
  ungroup()

Enterobacteriaceae_main <- main_df %>%
  filter(Grouping == "Enterobacteriaceae") %>%
  select(Antibiotic, Sensitivity_discrep) %>%
  count(Antibiotic, Sensitivity_discrep) %>%
  group_by(Antibiotic) %>%
  mutate(total = sum(n)) %>%
  mutate(percentage = n / sum(n) * 100) %>%
  mutate(OrgDescrip_new = "Enterobacteriaceae") %>%
  ungroup()

CNS_main <- main_df %>%
  filter(Grouping == "Coagulase negative Staph") %>%
  select(Antibiotic, Sensitivity_discrep) %>%
  count(Antibiotic, Sensitivity_discrep) %>%
  group_by(Antibiotic) %>%
  mutate(total = sum(n)) %>%
  mutate(percentage = n / sum(n) * 100) %>%
  mutate(OrgDescrip_new = "Coagulase negative Staph") %>%
  ungroup()

Anaerobes_main <- main_df %>%
  filter(Grouping == "Anaerobes") %>%
  select(Antibiotic, Sensitivity_discrep) %>%
  count(Antibiotic, Sensitivity_discrep) %>%
  group_by(Antibiotic) %>%
  mutate(total = sum(n)) %>%
  mutate(percentage = n / sum(n) * 100) %>%
  mutate(OrgDescrip_new = "Anaerobess") %>%
  ungroup()

gram_pos_main <- main_df %>%
  filter(Gram == "Positive") %>%
  select(Antibiotic, Sensitivity_discrep) %>%
  count(Antibiotic, Sensitivity_discrep) %>%
  group_by(Antibiotic) %>%
  mutate(total = sum(n)) %>%
  mutate(percentage = n / sum(n) * 100) %>%
  mutate(OrgDescrip_new = "Gram Positives") %>%
  ungroup()

gram_neg_main <- main_df %>%
  filter(Gram == "Negative") %>%
  select(Antibiotic, Sensitivity_discrep) %>%
  count(Antibiotic, Sensitivity_discrep) %>%
  group_by(Antibiotic) %>%
  mutate(total = sum(n)) %>%
  mutate(percentage = n / sum(n) * 100) %>%
  mutate(OrgDescrip_new = "Gram Negatives") %>%
  ungroup()

fungi_main <- main_df %>%
  filter(Gram == "Fungi") %>%
  select(Antibiotic, Sensitivity_discrep) %>%
  count(Antibiotic, Sensitivity_discrep) %>%
  group_by(Antibiotic) %>%
  mutate(total = sum(n)) %>%
  mutate(percentage = n / sum(n) * 100) %>%
  mutate(OrgDescrip_new = "Fungi") %>%
  ungroup()

seperator = data.frame(Antibiotic = NA,
                       Sensitivity_discrep = NA,
                       n = 0,
                       total = 0,
                       percentage = 0,
                       OrgDescrip_new = "--------------------")

main_table <- do.call(rbind, list(each_main, 
                                  Enterobacteriaceae_main, 
                                  CNS_main, Anaerobes_main, 
                                  gram_neg_main, 
                                  gram_pos_main, 
                                  fungi_main, 
                                  seperator))


main_table <- main_table %>%
  mutate(Antibiotic_new = (paste0(Antibiotic, " (", total, ")")))

save(main_table, file= "output/data/main_table.Rdata")
