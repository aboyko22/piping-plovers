# load packages ----
library(tidyverse)

# load cleaned data ----
local_data <- read_csv("data/cleaned_data/cook_county_data.csv")
cook_plovers <- read_csv("data/cleaned_data/cook_county_plovers.csv")
nh_data <- read_csv("data/cleaned_data/nh_data.csv")

# functions for eda ----
create_histogram <- function(df, var) {
  label <- rlang::englue("A histogram of {var}")
  
  df %>%
    ggplot(aes(x = !!rlang::sym(var))) +
    geom_histogram(fill = "#0073C2FF", color = "black", alpha = 0.7) +
    labs(title = label, y = "Count") +
    theme_minimal()
  
}

create_bar_chart <- function(df, var) {
  label <- rlang::englue("A barplot of {var}")
  
  df %>%
    ggplot(aes(x = !!rlang::sym(var))) +
    geom_bar(fill = "#0073C2FF", color = "black", alpha = 0.7) +
    labs(title = label, y = "Count") +
    theme_minimal()
}

create_density_plot <- function(df, var) {
  label <- rlang::englue("Density plot of {var}")
  
  df %>%
    ggplot(aes(x = !!rlang::sym(var))) +
    geom_density(fill = "#0073C2FF", color = "black", alpha = 0.7) +
    labs(title = label, y = "Density") +
    theme_minimal()
  
}

hist_list <- c("observation_count", "latitude", "longitude", "time_observations_started",
               "duration_minutes", "number_observers", "effort_distance_mi")
dens_list <- c("observation_count", "observation_date", "time_observations_started")
bar_list <- c("category", "common_name", "exotic_code", "breeding_code",
              "age_sex", "county", "iba_code", "bcr_code", "usfws_code",
              "locality", "locality_type", "all_species_reported",
              "has_media")

plotting_list <- union(union(hist_list, dens_list), bar_list)

for (var in plotting_list) {
  if (var %in% hist_list) {
    print(create_histogram(cook_plovers, var))
  } 
  
  if (var %in% dens_list) {
    print(create_density_plot(cook_plovers, var))
  } 
  
  if (var %in% bar_list) {
    print(create_bar_chart(cook_plovers, var))
  }
}

# data messing around ----
# frequency bar plot (see ebird)
total_props <- local_data %>%
  filter(common_name == "Piping Plover") %>%
  mutate(month = month(observation_date), week = week(observation_date)) %>%
  summarize(count = n_distinct(group_identifier), .by = c(week, month)) %>%
  mutate(count = count / max(count))

total_props %>%
  ggplot(aes(x = week, y = count)) +
  geom_col(fill = "lightblue") +
  geom_col(aes(y = -count), fill = "lightblue") +
  geom_vline(xintercept = 19, color = "red") +
  coord_fixed(xlim = c(1, 52), ylim = c(-1, 1)) +
  theme_void() +
  theme(panel.border = element_rect(color = "black", fill = NA))
