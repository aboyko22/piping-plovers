# load packages ----
library(tidyverse)
library(rebird)
library(hms)
library(jsonlite)

# write out formatted citings ----
recent_citings <- ebirdregion(loc = "US-IL-031", species = "pipplo", back = 30) %>%
  filter(!is.na(howMany)) %>%
  slice_head(n = 6) %>%
  
  mutate(locName = sub("[,(].*$", "", locName),
    
         obsDt = as.POSIXct(obsDt),
         nice_date = paste(month.name[month(obsDt)], day(obsDt), sep = " "),
         nice_time = format(obsDt, "%I:%M %p"),
         
         checklist = paste("ebird.org/checklist/", subId, sep = "")) %>%
  
  select(locName, howMany, nice_date, nice_time, checklist)

write_json(recent_citings, "data/cleaned_data/checklists.json", pretty = TRUE, auto_unbox = TRUE)

# updated relative frequency chart ----
load("docs/media/plot_framework.rda")

frequency_plot <- frequency_plot +
  geom_vline(color = "red", xintercept = week(Sys.Date()))

ggsave(filename = "frequency_plot.jpg", plot = frequency_plot, path = "docs/media/", width = 6, height = 2)
