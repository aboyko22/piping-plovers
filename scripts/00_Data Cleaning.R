# load packages ----
library(tidyverse)
library(rebird)

# load local data ----
local_data <- read_delim("data/ebd_US-IL-031_202101_202501_smp_relDec-2024.txt") %>%
  janitor::clean_names()

# from the ebd, saved locally only
# observations from 2021 to 2024 in cook county, il

# plus plover specific
cook_plovers <- read_delim("data/ebd_US-IL-031_pipplo_relMar-2025.txt") %>%
  janitor::clean_names()

# from the ebd, saved locally only
# all documented observations of pipl in cook county, il

# data cleaning ----
local_data <- local_data %>%
  mutate(effort_distance_mi = round(effort_distance_km / 1.60934, digits = 2)) %>%
  
  # select previously chosen variables
  select(category, common_name, scientific_name, subspecies_common_name,
         exotic_code, observation_count, breeding_code, behavior_code,
         age_sex, country, state, county, iba_code, bcr_code, usfws_code,
         locality, locality_type, latitude, longitude, observation_date,
         time_observations_started, observer_id, sampling_event_identifier,
         duration_minutes, number_observers, all_species_reported,
         group_identifier, has_media, species_comments, effort_distance_mi) %>%
  
  # convert variable types
  mutate(observation_count = as.double(observation_count),
         locality_type = factor(locality_type),
         all_species_reported = as.logical(all_species_reported),
         has_media = as.logical(has_media),
         
  # remove extreme outliers
         observation_count = case_when(
           observation_count > 1000 ~ 1000, # few really big numbers
           .default = observation_count),
         duration_minutes = case_when(
           duration_minutes > 1440 ~ NA, # longer than a day
           .default = duration_minutes),
         number_observers = case_when(
           number_observers > 100 ~ NA, # Obvious weirdness
           .default = number_observers)) 

# same process for plover data
cook_plovers <- cook_plovers %>%
  mutate(effort_distance_mi = round(effort_distance_km / 1.60934, digits = 2)) %>%
  
  # select previously chosen variables
  select(category, common_name, scientific_name, subspecies_common_name,
         exotic_code, observation_count, breeding_code, behavior_code,
         age_sex, country, state, county, iba_code, bcr_code, usfws_code,
         locality, locality_type, latitude, longitude, observation_date,
         time_observations_started, observer_id, sampling_event_identifier,
         duration_minutes, number_observers, all_species_reported,
         group_identifier, has_media, species_comments, effort_distance_mi) %>%
  
  # convert variable types
  mutate(observation_count = as.double(observation_count),
         locality_type = factor(locality_type),
         all_species_reported = as.logical(all_species_reported),
         has_media = as.logical(has_media),
         
         # remove extreme outliers
         observation_count = case_when(
           observation_count > 1000 ~ 1000, # Few really big numbers
           .default = observation_count),
         duration_minutes = case_when(
           duration_minutes > 1440 ~ NA, # Longer than a day
           .default = duration_minutes),
         number_observers = case_when(
           number_observers > 100 ~ NA, # Obvious weirdness
           .default = number_observers)) 

# save out cleaned files ----
write_csv(local_data, file = "data/cleaned_data/cook_county_data.csv")
write_csv(cook_plovers, file = "data/cleaned_data/cook_county_plovers.csv")

# included in .gitignore for disclosure reasons
# csv over rda objects for fact checking cross platform
