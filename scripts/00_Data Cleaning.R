# load packages ----
library(tidyverse)

# load local data ----
local_data <- read_delim("data/ebd_US-IL-031_202101_202501_smp_relDec-2024.txt") %>%
  janitor::clean_names()

nh_data <- read_delim("data/ebd_US-NH_202101_202505_relMar-2025.txt") %>%
  janitor::clean_names()

# from the ebd, saved locally only
# observations from 2021 to 2024 in cook county, il and nh

# load plover specific data ----
cook_plovers <- read_delim("data/ebd_US-IL-031_pipplo_relMar-2025.txt") %>%
  janitor::clean_names()

nh_plovers <- read_delim("data/ebd_US-NH_pipplo_relMar-2025.txt") %>%
  janitor::clean_names()

# from the ebd, saved locally only
# all documented observations of pipl in cook county, il and nh

## 2024 country wide plover data ----
plovers_2024 <- read_delim("data/ebd_US_pipplo_202401_202501_smp_relMar-2025.txt") %>%
  janitor::clean_names() %>%
  filter(year(observation_date) == 2024)

# from the ebd, saved locally only
# all pipl observations from 2024 in united states

# data cleaning function ----
ebd_cleaning <- function(df) {
  
  df %>%
    mutate(effort_distance_mi = round(effort_distance_km / 1.60934, digits = 2)) %>%
    
    # select previously chosen variables
    select(common_name, observation_count, breeding_code, behavior_code,
           age_sex, country, state, county, usfws_code, locality, locality_type,
           latitude, longitude, observation_date, time_observations_started, observer_id,
           sampling_event_identifier, duration_minutes, number_observers, all_species_reported,
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
             .default = number_observers),
           
           # add derived date columns
           dotw = wday(observation_date),
           week = week(observation_date),
           month = month(observation_date),
           year = year(observation_date)) 
  
}

# apply to data sets ----
local_data <- ebd_cleaning(local_data)
nh_data <- ebd_cleaning(nh_data)

cook_plovers <- ebd_cleaning(cook_plovers)
nh_plovers <- ebd_cleaning(nh_plovers)

plovers_2024 <- ebd_cleaning(plovers_2024)

# save out cleaned files ----
write_csv(local_data, file = "data/cleaned_data/cook_county_data.csv")
write_csv(cook_plovers, file = "data/cleaned_data/cook_county_plovers.csv")

write_csv(nh_data, file = "data/cleaned_data/nh_data.csv")
write_csv(nh_plovers, file = "data/cleaned_data/nh_plovers.csv")

write_csv(plovers_2024, file = "data/cleaned_data/plovers_2024.csv")

# included in .gitignore for disclosure reasons
# csv over rda objects for fact checking cross platform
