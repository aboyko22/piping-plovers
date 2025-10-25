# load packages ----
library(tidyverse)
library(rebird)
library(hms)
library(jsonlite)

# write out formatted citings ----
recent_citings <- ebirdregion(loc = "US-IL-031", species = "pipplo", back = 30)

if (nrow(recent_citings) == 0) {

  empty_state <- list(
    status = "empty",
    message_title = "No Recent Plover Sightings",
    message_body = paste0(
      "Unfortunately, no piping plovers have been spotted in Cook County over the past 30 days. ",
      "To find out why, or learn more about them, take a look at these resources:"
    ),
    resources = list(
      list(name = "Piping plover range maps on eBird", url = "https://science.ebird.org/en/status-and-trends/species/pipplo/range-map?season=breeding,nonbreeding,prebreeding_migration,postbreeding_migration"),
      list(name = "BirdCast's migration dashboard for Cook County", url = "https://dashboard.birdcast.info/region/US-IL-031"),
      list(name = "The Chicago Piping Plovers Instagram page", url = "https://www.instagram.com/chicagopipingplovers")
    ),
    last_checked = Sys.time()
  )
  
  write_json(empty_state, "docs/media/checklists.json", pretty = TRUE, auto_unbox = TRUE)
  
} else {

  recent_citings <- recent_citings %>%
    filter(!is.na(howMany)) %>%
    slice_head(n = 6) %>%
    
    mutate(locName = sub("[,(].*$", "", locName),
      
           obsDt = as.POSIXct(obsDt),
           nice_date = paste(month.name[month(obsDt)], day(obsDt), sep = " "),
           nice_time = format(obsDt, "%I:%M %p"),
           
           checklist = paste("ebird.org/checklist/", subId, sep = "")) %>%
    
    select(locName, howMany, nice_date, nice_time, checklist)
  
  write_json(recent_citings, "docs/media/checklists.json", pretty = TRUE, auto_unbox = TRUE)

}

# updated relative frequency chart ----
load("docs/media/plot_framework.rda")

frequency_plot <- frequency_plot +
  geom_vline(color = "red", xintercept = week(Sys.Date()))

ggsave(filename = "frequency_plot.jpg", plot = frequency_plot, path = "docs/media/", width = 6, height = 2)
