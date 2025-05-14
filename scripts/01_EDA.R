# load packages ----
library(tidyverse)

# load cleaned data ----
local_data <- read_csv("data/cleaned_data/cook_county_data.csv")
cook_plovers <- read_csv("data/cleaned_data/cook_county_plovers.csv")
nh_data <- read_csv("data/cleaned_data/nh_data.csv")
nh_plovers <- read_csv("data/cleaned_data/nh_plovers.csv")
plovers_2024 <- read_csv("data/cleaned_data/plovers_2024.csv")

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
  summarize(count = n_distinct(sampling_event_identifier), .by = c(week, month)) %>%
  mutate(count = count / max(count))

total_props %>%
  ggplot(aes(x = week, y = count)) +
  geom_col(fill = "lightblue") +
  geom_col(aes(y = -count), fill = "lightblue") +
  geom_vline(xintercept = 19, color = "red") +
  coord_fixed(xlim = c(1, 52), ylim = c(-1, 1)) +
  theme_void() +
  theme(panel.border = element_rect(color = "black", fill = NA))

# relative distributions
nh_data %>%
  filter(county == "Rockingham") %>%
  mutate(year = year(observation_date),
         is_plover = if_else(common_name == "Piping Plover", "yes", "no")) %>%
  summarize(count = n_distinct(sampling_event_identifier), .by = c(year, is_plover)) %>%
  pivot_wider(names_from = is_plover, values_from = count) %>%
  mutate(prop = yes / (yes + no), id = "nh") %>%
  
  rbind(local_data %>%
  mutate(year = year(observation_date),
         is_plover = if_else(common_name == "Piping Plover", "yes", "no")) %>%
  summarize(count = n_distinct(sampling_event_identifier), .by = c(year, is_plover)) %>%
  pivot_wider(names_from = is_plover, values_from = count) %>%
  mutate(prop = yes / (yes + no), id = "chi")) %>%
  ggplot(aes(x = year, y = prop, group = id, color = id)) +
  geom_point() +
  geom_line()

# total observation growth
local_data %>%
  mutate(year = year(observation_date), is_plover = if_else(common_name == "Piping Plover", "yes", "no")) %>%
  summarize(n = n_distinct(sampling_event_identifier), .by = c(year, is_plover)) %>%
  pivot_wider(names_from = is_plover, values_from = n) %>%
  mutate(perc = yes / (yes + no) * 100)

# where they are (chi)
local_data %>%
  filter(common_name == "Piping Plover") %>%
  mutate(montrose = if_else(str_detect(locality, pattern = "Montrose"), "yes", "no"), week = week(observation_date)) %>%
  summarize(count = n_distinct(sampling_event_identifier), .by = c(montrose, locality)) %>% slice_max(n = 10, order_by = count) %>%
  ggplot(aes(x = reorder(locality, -count), y = count, fill = montrose)) +
  geom_col()


# migration in 2024
us_map <- map_data(map = "state") %>%
  mutate(state = state.abb[match(region, tolower(state.name))]) %>%
  select(long, lat, group, state)

plovers_2024 %>%
  mutate(month = month(observation_date)) %>%
  ggplot(aes(x = longitude, y = latitude)) +
  geom_polygon(data = us_map, aes(x = long, y = lat, group = group), color = "black", fill = "grey90") +
  geom_point(alpha = 0.1, color = "violet", aes(size = observation_count)) +
  facet_wrap(~month)
