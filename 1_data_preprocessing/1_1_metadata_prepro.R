
# LIBRARY LOADING
library(tibble)
library(dplyr)
library(tidymodels)
library(tidydr)
library(ggplot2)


# LOAD METADATA 
parkinson_data <- readRDS("~/Documents/Servicio_Social/PARKINSON_PROJECT/input_data/parkinson_clean_2025-12-01.RDS")


# LOAD LABELS FOR UNDERSTANDING METADATA 
parkinson_labels <- readRDS("~/Documents/Servicio_Social/PARKINSON_PROJECT/input_data/parkinson_labels_dict_2025-12-01.RDS")

# View data characteristics 
dim(parkinson_data)
colnames(parkinson_data)
sum(duplicated(parkinson_data$identificador)) # No duplicates


# Create metadata obejct

metadata <- parkinson_data

# Remove personal information

metadata <- metadata %>%
  dplyr::select(-nombre)

# Identify and remove empty variables

empty_variables <- names(metadata)[colMeans(is.na(metadata)) == 1]

metadata <- metadata %>% 
  dplyr::select(-all_of(empty_variables))


# Remove unused factor levels

metadata <- droplevels(metadata)

# Missing values by variable

metadata_missing <- data.frame(
  variable = names(metadata),
  n_missing = colSums(is.na(metadata)),
  pct_missing = colMeans(is.na(metadata)) * 100
) %>% 
  arrange(desc(pct_missing))

# Check metadata dimensions

dim(metadata)


# Check variable types

str(metadata)

# Identify numerical variables

numerical_variables <- names(metadata)[sapply(metadata, is.numeric)]


# Identify categorical variables

categorical_variables <- names(metadata)[sapply(metadata, is.factor)]

# Check levels of categorical variables

lapply(metadata[categorical_variables], levels)


# Create binary variables (0 = No, 1 = Yes)

# Depende que decidamos usar....


# Create necessary output and results directories if they don't exist

if(dir.exists("./output_data/")) {
  "Output_data directory already exists"
} else{
  dir.create("./output_data/")
}

if(dir.exists("./results/")){
  "results directory already exists"
}else{
  dir.create("./results/")
} 


# Save clean metadata

saveRDS(metadata, "./output_data/metadata.RDS")




rm(list = ls())
gc()