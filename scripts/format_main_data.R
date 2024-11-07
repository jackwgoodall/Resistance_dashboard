# Load packages
if(!requireNamespace('pacman', quietly=TRUE)){
  install_version('pacman')
}
pacman::p_load("tidyverse", "readxl")

#Import data from SQL query 
load("output/data/df.Rdata")

# Add a new column to allow for mixed cultures
df <- df %>%
  mutate(SpecNo_ID = paste(SpecNo, Organism, Hospital_No, ID, sep = "_"))

# Make a list of all organisms found
a <- df %>%
  select(Organism, OrgDescrip)
a <- unique(a)

# Remove all those that were sent out whilst still being worked up
clean_df <- df %>%
  filter(Organism != "QCOL" &
           Organism != "MCNS" &
           Organism != "COLI" &
           Organism != "GPCCL" &
           Organism != "QCNS" &
           Organism != "QSTAU" &
           Organism != "NEGB" &
           Organism != "GPCCH" &
           Organism != "GNBAC" &
           Organism != "MBG" &
           Organism != "MCOL" &
           Organism != "NPNE" &
           Organism != "MIXCOL" &
           Organism != "NAPS" &
           Organism != "NHST" &
           Organism != "STAPH" &
           Organism != "GPC" &
           Organism != "NMRSA" &
           Organism != "NAPS",
         !grepl("^\\(Not\\)|^\\(\\?\\)", OrgDescrip)) # anything that matches (?) or (not)


# Remove SCH & others
#clean_df <- clean_df %>%                   ### This could be used to filter out areas you don't want to include e.g. other
#  filter(Dept_Code != "SCH" &              ### hosptials you process samples for
#           Dept_Code != "DON1F") 

# Remove screening 
clean_df <- clean_df %>%                               ### This is used to remove screening samples (e.g MRSA/CPE screening plates)
  filter(!grepl("MI", SpecNo, ignore.case = TRUE))    ### How this is coded will of course vary 


# Make a new column for those which should be together
clean_df <- clean_df %>%
  mutate(OrgDescrip_new = case_when(OrgDescrip == "Mucoid Pseudomonas" ~ "Pseudomonas aeruginosa",
                                    OrgDescrip == "MRSA" ~ "Staphylococcus aureus",
                                    OrgDescrip == "VRE" ~ "Enterococcus sp.",
                                    TRUE ~ OrgDescrip))

#### Make a new column for the common groups
# List of Enterobacteriaceae (this is taken from the SMI)
Enterobacteriaceae_list <- c("Arsenophonus", "Biostraticola", "Brenneria", "Buchnera", "Budvicia", "Buttiauxella", "Calymmatobacterium", 
                             "Cedecea", "Citrobacter", "Cosenzaea", "Cronobacter", "Dickeya", "Edwardsiella", "Enterobacter", 
                             "Erwinia", "Escherichia", "Ewingella", "Gibbsiella", "Hafnia", "Klebsiella", "Kluyvera", "Leclercia", 
                             "Leminorella", "Levinea", "Lonsdalea", "Mangrovibacter", "Moellerella", "Morganella", "Obesumbacterium", 
                             "Pantoea", "Pectobacterium", "Phaseolibacter", "Photorhabdus", "Plesiomonas", "Pragia", "Proteus", 
                             "Providencia", "Rahnella", "Raoultella", "Saccharobacter", "Salmonella", "Samsonia", "Serratia", 
                             "Shigella", "Shimwellia", "Sodalis", "Tatumella", "Thorsellia", "Trabulsiella", "Wigglesworthia", 
                             "Xenorhabdus", "Yersinia", "Yokenella")

Enterobacteriaceae_list <- paste(Enterobacteriaceae_list, collapse = "|")

clean_df <- clean_df %>%
  group_by(SpecNo_ID) %>%
  mutate(Grouping = case_when(
    grepl(Enterobacteriaceae_list, OrgDescrip_new, ignore.case = TRUE) ~ "Enterobacteriaceae", 
    grepl("Staph|Staphylococcus", OrgDescrip_new, ignore.case = TRUE) & 
      !grepl("Staphylococcus aureus", OrgDescrip_new, ignore.case = TRUE) ~ "Coagulase negative Staph",
    TRUE ~ NA_character_
  )) %>%
  mutate(Grouping = case_when(
    any(Antibiotic == "Metronidazole") ~ "Anaerobes",
    TRUE ~ Grouping
  )) %>%
  ungroup()


# Gram post/neg/fungi.  ### This is logic used to figure out which of our testing sets the organsims have been through as
                          ### gram negs/pos aren't directly coded in our database. This will need localising
clean_df <- clean_df %>%
  group_by(SpecNo_ID) %>%
  mutate(Gram = case_when(
    (any(Antibiotic == "Vancomycin") | any(Antibiotic == "Vancomycin disc") | Organism == "STSA") ~ "Positive",
    grepl("Strep|Staph|Enterococcus|Neisseria", OrgDescrip, ignore.case = TRUE) ~ "Positive",
    (any(Antibiotic == "Colistin/polymyxn") | any(Antibiotic == "Temocillin") & Organism != "STSA") ~ "Negative", #STSA = Staph saphrophyticus which is the only one that seesm to go trhough the 'wrong' multipoint
    grepl("Acinetobacter|Achromobacter|Campylobacter|Citrobacter|Clostridium|Haemophilus|Salmonella|Stenotrophomonas|Moraxella", OrgDescrip, ignore.case = TRUE) ~ "Negative",
    any(Antibiotic == "Fluconazole") ~ "Fungi",
    grepl("Aspergillus", OrgDescrip, ignore.case = TRUE) ~ "Fungi",
    TRUE ~ NA_character_  
  )) %>%
  ungroup()


# remove discs and interims.  ### These are the direct disks we use to get initial sensitivities prior to formal testing
                              ### along with the disk sets used for ESBL/CPE screening. 
                              ### None are true sensitivities so are removed.
abx_remove <- c("Amoxycillin disc", "Amoxy/clavulanic acid", "Ampi/amoxicillin", "Carbapenemase scn", "Cefepime", 
                "Cefepime/clav", "Cefoxitin", "Cefpodoxime", "Cefpodoxime disc", "Cefpodoxime/clav", 
                "Cefuroxime disc", "Ciprofloxacin disc", "Ciprofloxacin hi", "Ciprofloxacin low", "Doxy/Tetracycline disc",                  
                "Erythromycin disc", "Flucloxacillin disc", "Gentamicin (high level)", "Gentamicin (High)", "Gentamicin (Low)",
                "Gentamicin disc", "High-level gentamicin", "High level Gentamicin", "Meropenem boronic",  "Meropenem clox",
                "Meropenem dipicol", "Meropenem disc", "Meropenem tablet", "MultipointControl", "Optochin", "Oxacillin", "Oxacillin (High)",
                "Oxacillin (Low)", "Pip/tazo high", "Pip/tazo low", "Piperacillin/Tazobactam disc", "Sensitivity flag", "Teicoplanin (High)",
                "Teicoplanin (Low)", "Teicoplanin disc", "Temocillin disc", "Temocillin tablet", "Vancomycin (High)", "Vancomycin (Low)", "Vancomycin disc")


clean_df <- clean_df %>%
  filter(!Antibiotic %in% abx_remove)

#### Make a new column for the discrepant phenotypes - ESBL/AMPC and CPE - and then remove all with P
# CPEs
CPE_options <- c("Efflux", "Imipenemase", "Intrinsic MBL", "K. pneumoniae carbapenemase", "KPC detected",
                 "New Delhi metallo-B-lactamase", "NG-Test CARBA 5 IMP+", "NG-Test CARBA 5 KPC+", 
                 "NG-Test CARBA 5 NDM+", "NG-Test CARBA 5 OXA+", "NG-Test CARBA 5 VIM+", "Oxacillinase 48",
                 "Porin loss", "Verona integron metallo B-lact")

ESBL_susceptible <- c("Amp/amoxicillin", "Aztreonam", "Cefepime", "Cefuroxime", "Co-amoxiclav", "Piperacillin/Tazo",  
                      "Flucloxacillin", "Penicillin", "Ceftazidime", "Cefotaxime", "Ceftriaxone", "Cephalexin")

carbapenems <- c("Ertapenem", "Meropenem", "Imipenem")

# Putting it all together (and changing the remaining Is to Hs)
# (We have both I - true intermeddiate and H (EUCAST increased exposure) for simplicity I have chosen to combine these)
# You could of course keep them seperate if that is how you wish to show them
clean_df <- clean_df %>%
  group_by(SpecNo_ID) %>%
  mutate(ESBL_ampC = if_else(any(Antibiotic == "ESBL detected" | 
                                   Antibiotic == "AmpC detected" | 
                                   Antibiotic == "Inducible AmpC detected"), "Res", "No")) %>%
  mutate(CPE = if_else(any(Antibiotic %in% CPE_options), "Res", "No")) %>%
  ungroup() %>%
  mutate(Sensitivity_discrep = case_when((Antibiotic %in% ESBL_susceptible) & 
                                           ESBL_ampC == "Res" & 
                                           Sensitivity %in% c("S", "H", "I") ~ "E",
                                         (Antibiotic %in% carbapenems) & 
                                           CPE == "Res" & 
                                           Sensitivity %in% c("S", "H", "I") ~ "E",
                                         TRUE ~ Sensitivity)) %>%
  filter(Sensitivity != "P") %>%
  # Step to change "I" to "H" only when it hasn't been changed already
  mutate(Sensitivity_discrep = case_when(Sensitivity_discrep == "I" ~ "H", TRUE ~ Sensitivity_discrep)) %>%
  filter(Sensitivity != "P") 

# Rename the categories
clean_df <- clean_df %>%
  mutate(Sensitivity_discrep = case_when(Sensitivity_discrep == "R" ~ "Resistant",
                                         Sensitivity_discrep == "S" ~ "Sensitive",
                                         Sensitivity_discrep == "H" ~ "Increased exposure",
                                         Sensitivity_discrep == "E" ~ "Discrepant phenotype*"))



# Remove the (very rare) entries where the abx were redone and corrected 
main_df <- clean_df %>%
  arrange(SpecNo_ID, Antibiotic, desc(DTC)) %>%  # Arrange by SpecNo_ID, Antibiotic, and descending date
  distinct(SpecNo_ID, Antibiotic, .keep_all = TRUE) %>%  # Keep only the first (latest) entry for each group
  ungroup()

# Calculate the sample numbers
isolate_numbers <- n_distinct(main_df$SpecNo_ID)
specimen_numbers <- n_distinct(main_df$SpecNo)
patient_numbers <- n_distinct(main_df$Hospital_No)

save(main_df, file = "output/data/main_df.Rdata")
save(isolate_numbers, specimen_numbers, patient_numbers, file = "output/data/isolate_numbers.Rdata")



