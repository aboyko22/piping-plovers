# load packages ----
library(tidyverse)
library(rebird)
library(hms)
library(jsonlite)

# write out formatted citings ----
recent_citings <- ebirdregion(loc = "US-IL-031", species = "pipplo") %>%
  filter(!is.na(howMany)) %>%
  slice_head(n = 5) %>%
  
  mutate(locName = sub("[,(].*$", "", locName),
    
         obsDt = as.POSIXct(obsDt),
         nice_date = paste(month.name[month(obsDt)], day(obsDt), sep = " "),
         nice_time = format(obsDt, "%I:%M %p"),
         
         checklist = paste("ebird.org/checklist/", subId, sep = "")) %>%
  
  select(locName, howMany, nice_date, nice_time, checklist)

write_json(recent_citings, "data/cleaned_data/checklists.json", pretty = TRUE, auto_unbox = TRUE)
