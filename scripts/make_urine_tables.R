# Load packages
if(!requireNamespace('pacman', quietly=TRUE)){
  install_version('pacman')
}
pacman::p_load("tidyverse")

# Load the formatted data 
load("output/data/main_df.Rdata")

urine_all_df <- main_df %>%
  filter(grepl("MU", SpecNo))

# Make the all urines table
each_urine_all <- urine_all_df %>%
  filter(OrgDescrip_new != "Coag Neg Staphylococcus" & OrgDescrip_new != "Anaerobes") %>% # these are lumped together in the group below so shouldn't appear twice
  select(OrgDescrip_new, Antibiotic, Sensitivity_discrep) %>%
  count(OrgDescrip_new, Antibiotic, Sensitivity_discrep) %>%
  group_by(Antibiotic, OrgDescrip_new) %>%
  mutate(total = sum(n)) %>%
  mutate(percentage = n / sum(n) * 100) %>%
  ungroup()

Enterobacteriaceae_urine_all <- urine_all_df %>%
  filter(Grouping == "Enterobacteriaceae") %>%
  select(Antibiotic, Sensitivity_discrep) %>%
  count(Antibiotic, Sensitivity_discrep) %>%
  group_by(Antibiotic) %>%
  mutate(total = sum(n)) %>%
  mutate(percentage = n / sum(n) * 100) %>%
  mutate(OrgDescrip_new = "Enterobacteriaceae") %>%
  ungroup()

CNS_urine_all <- urine_all_df %>%
  filter(Grouping == "Coagulase negative Staph") %>%
  select(Antibiotic, Sensitivity_discrep) %>%
  count(Antibiotic, Sensitivity_discrep) %>%
  group_by(Antibiotic) %>%
  mutate(total = sum(n)) %>%
  mutate(percentage = n / sum(n) * 100) %>%
  mutate(OrgDescrip_new = "Coagulase negative Staph") %>%
  ungroup()

Anaerobes_urine_all <- urine_all_df %>%
  filter(Grouping == "Anaerobes") %>%
  select(Antibiotic, Sensitivity_discrep) %>%
  count(Antibiotic, Sensitivity_discrep) %>%
  group_by(Antibiotic) %>%
  mutate(total = sum(n)) %>%
  mutate(percentage = n / sum(n) * 100) %>%
  mutate(OrgDescrip_new = "Anaerobes") %>%
  ungroup()

gram_pos_urine_all <- urine_all_df %>%
  filter(Gram == "Positive") %>%
  select(Antibiotic, Sensitivity_discrep) %>%
  count(Antibiotic, Sensitivity_discrep) %>%
  group_by(Antibiotic) %>%
  mutate(total = sum(n)) %>%
  mutate(percentage = n / sum(n) * 100) %>%
  mutate(OrgDescrip_new = "Gram Positives") %>%
  ungroup()

gram_neg_urine_all <- urine_all_df %>%
  filter(Gram == "Negative") %>%
  select(Antibiotic, Sensitivity_discrep) %>%
  count(Antibiotic, Sensitivity_discrep) %>%
  group_by(Antibiotic) %>%
  mutate(total = sum(n)) %>%
  mutate(percentage = n / sum(n) * 100) %>%
  mutate(OrgDescrip_new = "Gram Negatives") %>%
  ungroup()

fungi_urine_all <- urine_all_df %>%
  filter(Gram == "Fungi") %>%
  select(Antibiotic, Sensitivity_discrep) %>%
  count(Antibiotic, Sensitivity_discrep) %>%
  group_by(Antibiotic) %>%
  mutate(total = sum(n)) %>%
  mutate(percentage = n / sum(n) * 100) %>%
  mutate(OrgDescrip_new = "Fungi") %>%
  ungroup()

seperator = data.frame(Antibiotic = NA,               ## This make a visual separator for the final drop down menu
                       Sensitivity_discrep = NA,
                       n = 0,
                       total = 0,
                       percentage = 0,
                       OrgDescrip_new = "--------------------")

urine_all_table <- do.call(rbind, list(each_urine_all, 
                                       Enterobacteriaceae_urine_all, 
                                       CNS_urine_all, Anaerobes_urine_all, 
                                       gram_neg_urine_all, 
                                       gram_pos_urine_all, 
                                       fungi_urine_all, 
                                       seperator))


urine_all_table <- urine_all_table %>%
  mutate(Antibiotic_new = (paste0(Antibiotic, " (", total, ")")))

save(urine_all_table, file= "output/data/urine_all_table.Rdata")


################
#Just Inpatients 
################
urine_IP_df <- main_df %>%
  filter(grepl("MU", SpecNo) & 
           (Location_Code == "inpatient"))


each_urine_IP <- urine_IP_df %>%
  filter(OrgDescrip_new != "Coag Neg Staphylococcus" & OrgDescrip_new != "Anaerobes") %>% # these are lumped together in the group below so shouldn't appear twice
  select(OrgDescrip_new, Antibiotic, Sensitivity_discrep) %>%
  count(OrgDescrip_new, Antibiotic, Sensitivity_discrep) %>%
  group_by(Antibiotic, OrgDescrip_new) %>%
  mutate(total = sum(n)) %>%
  mutate(percentage = n / sum(n) * 100) %>%
  ungroup()

Enterobacteriaceae_urine_IP <- urine_IP_df %>%
  filter(Grouping == "Enterobacteriaceae") %>%
  select(Antibiotic, Sensitivity_discrep) %>%
  count(Antibiotic, Sensitivity_discrep) %>%
  group_by(Antibiotic) %>%
  mutate(total = sum(n)) %>%
  mutate(percentage = n / sum(n) * 100) %>%
  mutate(OrgDescrip_new = "Enterobacteriaceae") %>%
  ungroup()

CNS_urine_IP <- urine_IP_df %>%
  filter(Grouping == "Coagulase negative Staph") %>%
  select(Antibiotic, Sensitivity_discrep) %>%
  count(Antibiotic, Sensitivity_discrep) %>%
  group_by(Antibiotic) %>%
  mutate(total = sum(n)) %>%
  mutate(percentage = n / sum(n) * 100) %>%
  mutate(OrgDescrip_new = "Coagulase negative Staph") %>%
  ungroup()

Anaerobes_urine_IP <- urine_IP_df %>%
  filter(Grouping == "Anaerobes") %>%
  select(Antibiotic, Sensitivity_discrep) %>%
  count(Antibiotic, Sensitivity_discrep) %>%
  group_by(Antibiotic) %>%
  mutate(total = sum(n)) %>%
  mutate(percentage = n / sum(n) * 100) %>%
  mutate(OrgDescrip_new = "Anaerobes") %>%
  ungroup()

gram_pos_urine_IP <- urine_IP_df %>%
  filter(Gram == "Positive") %>%
  select(Antibiotic, Sensitivity_discrep) %>%
  count(Antibiotic, Sensitivity_discrep) %>%
  group_by(Antibiotic) %>%
  mutate(total = sum(n)) %>%
  mutate(percentage = n / sum(n) * 100) %>%
  mutate(OrgDescrip_new = "Gram Positives") %>%
  ungroup()

gram_neg_urine_IP <- urine_IP_df %>%
  filter(Gram == "Negative") %>%
  select(Antibiotic, Sensitivity_discrep) %>%
  count(Antibiotic, Sensitivity_discrep) %>%
  group_by(Antibiotic) %>%
  mutate(total = sum(n)) %>%
  mutate(percentage = n / sum(n) * 100) %>%
  mutate(OrgDescrip_new = "Gram Negatives") %>%
  ungroup()

fungi_urine_IP <- urine_IP_df %>%
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

urine_IP_table <- do.call(rbind, list(each_urine_IP, 
                                      Enterobacteriaceae_urine_IP, 
                                      CNS_urine_IP, Anaerobes_urine_IP, 
                                      gram_neg_urine_IP, 
                                      gram_pos_urine_IP, 
                                      fungi_urine_IP, 
                                      seperator))


urine_IP_table <- urine_IP_table %>%
  mutate(Antibiotic_new = (paste0(Antibiotic, " (", total, ")")))

save(urine_IP_table, file= "output/data/urine_IP_table.Rdata")


### Just GPs
################
urine_GP_df <- main_df %>%
  filter(grepl("MU", SpecNo) & 
           (Location_Code == "GP"))


each_urine_GP <- urine_GP_df %>%
  filter(OrgDescrip_new != "Coag Neg Staphylococcus" & OrgDescrip_new != "Anaerobes") %>% # these are lumped together in the group below so shouldn't appear twice
  select(OrgDescrip_new, Antibiotic, Sensitivity_discrep) %>%
  count(OrgDescrip_new, Antibiotic, Sensitivity_discrep) %>%
  group_by(Antibiotic, OrgDescrip_new) %>%
  mutate(total = sum(n)) %>%
  mutate(percentage = n / sum(n) * 100) %>%
  ungroup()

Enterobacteriaceae_urine_GP <- urine_GP_df %>%
  filter(Grouping == "Enterobacteriaceae") %>%
  select(Antibiotic, Sensitivity_discrep) %>%
  count(Antibiotic, Sensitivity_discrep) %>%
  group_by(Antibiotic) %>%
  mutate(total = sum(n)) %>%
  mutate(percentage = n / sum(n) * 100) %>%
  mutate(OrgDescrip_new = "Enterobacteriaceae") %>%
  ungroup()

CNS_urine_GP <- urine_GP_df %>%
  filter(Grouping == "Coagulase negative Staph") %>%
  select(Antibiotic, Sensitivity_discrep) %>%
  count(Antibiotic, Sensitivity_discrep) %>%
  group_by(Antibiotic) %>%
  mutate(total = sum(n)) %>%
  mutate(percentage = n / sum(n) * 100) %>%
  mutate(OrgDescrip_new = "Coagulase negative Staph") %>%
  ungroup()

Anaerobes_urine_GP <- urine_GP_df %>%
  filter(Grouping == "Anaerobes") %>%
  select(Antibiotic, Sensitivity_discrep) %>%
  count(Antibiotic, Sensitivity_discrep) %>%
  group_by(Antibiotic) %>%
  mutate(total = sum(n)) %>%
  mutate(percentage = n / sum(n) * 100) %>%
  mutate(OrgDescrip_new = "Anaerobes") %>%
  ungroup()

gram_pos_urine_GP <- urine_GP_df %>%
  filter(Gram == "Positive") %>%
  select(Antibiotic, Sensitivity_discrep) %>%
  count(Antibiotic, Sensitivity_discrep) %>%
  group_by(Antibiotic) %>%
  mutate(total = sum(n)) %>%
  mutate(percentage = n / sum(n) * 100) %>%
  mutate(OrgDescrip_new = "Gram Positives") %>%
  ungroup()

gram_neg_urine_GP <- urine_GP_df %>%
  filter(Gram == "Negative") %>%
  select(Antibiotic, Sensitivity_discrep) %>%
  count(Antibiotic, Sensitivity_discrep) %>%
  group_by(Antibiotic) %>%
  mutate(total = sum(n)) %>%
  mutate(percentage = n / sum(n) * 100) %>%
  mutate(OrgDescrip_new = "Gram Negatives") %>%
  ungroup()

fungi_urine_GP <- urine_GP_df %>%
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

urine_GP_table <- do.call(rbind, list(each_urine_GP, 
                                      Enterobacteriaceae_urine_GP, 
                                      CNS_urine_GP, Anaerobes_urine_GP, 
                                      gram_neg_urine_GP, 
                                      gram_pos_urine_GP, 
                                      fungi_urine_GP, 
                                      seperator))


urine_GP_table <- urine_GP_table %>%
  mutate(Antibiotic_new = (paste0(Antibiotic, " (", total, ")")))

save(urine_GP_table, file= "output/data/urine_GP_table.Rdata")


