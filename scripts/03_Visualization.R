# load packages ----
library(tidyverse)

# load cleaned data ----
local_data <- read_csv("data/cleaned_data/cook_county_data.csv")
cook_plovers <- read_csv("data/cleaned_data/cook_county_plovers.csv")

scraped_images <- read_csv('data/cleaned_data/scraped_images.csv')

plovers_2024 <- read_csv("data/cleaned_data/plovers_2024.csv")

nh_plovers <- read_csv("data/cleaned_data/nh_plovers.csv")
nh_data <- read_csv("data/cleaned_data/nh_data.csv")

# not included since no processing was done here
# 2024 plover data used in flourish for animated map

# top 150 data for scatter plot ----
comment_frequencies <- local_data %>%
  filter(!str_detect(common_name, "sp.")) %>%
  mutate(has_comment = if_else(!is.na(species_comments), 1, 0)) %>%
  summarize(percent = mean(has_comment) * 100, count = n(), .by = common_name) %>%
  slice_max(n = 150, order_by = count) %>%
  left_join(scraped_images, by = join_by(common_name == `Common Name`)) %>%
  rename(url = `Image URL`)

write_csv(comment_frequencies, file = "data/cleaned_data/comment_frequencies.csv")

# differences in observation ----
# to note, this is 2021 - 2024
local_data %>%
  mutate(is_plover = if_else(common_name == "Piping Plover", 1, 0),
         has_comment = if_else(!is.na(species_comments), 1, 0),
         has_exclam = if_else(str_detect(species_comments, "!"), 1, 0)) %>%
  summarize(amount = mean(observation_count, na.rm = TRUE),
            duration = mean(duration_minutes, na.rm = TRUE),
            observers = mean(number_observers, na.rm = TRUE),
            media = mean(has_media),
            comment = mean(has_comment),
            exclamation = mean(has_exclam, na.rm = TRUE),
            count = n(),
            .by = c(is_plover))

# key differences: amount of birds seen, comments with exclamations
# data to be used in external flourish visualizations

## and the same comparison with another location ----
nh_data %>% 
  mutate(is_plover = if_else(common_name == "Piping Plover", 1, 0),
        cook_county = if_else(county == "Cook" & state == "Illinois", "yes", "no"),
         has_comment = if_else(!is.na(species_comments), 1, 0),
         has_exclam = if_else(str_detect(species_comments, "!"), 1, 0)) %>%
  summarize(amount = mean(observation_count, na.rm = TRUE),
            duration = mean(duration_minutes, na.rm = TRUE),
            observers = mean(number_observers, na.rm = TRUE),
            media = mean(has_media),
            comment = mean(has_comment),
            exclamation = mean(has_exclam, na.rm = TRUE),
            count = n(),
            .by = is_plover)

# differences from above: amounts are similar, duration flipped
# even more frequent media, less exclamations

# observations by population ----
rbind(cook_plovers, nh_plovers) %>%
  filter(year >= 2015 & year < 2025) %>%
  summarize(total = n_distinct(sampling_event_identifier),
            n_birds = max(observation_count, na.rm = TRUE), .by = c(year, county)) %>%
  mutate(ratio = total / n_birds) %>%
  ggplot(aes(x = factor(year), y = ratio, group = county, color = county)) +
  geom_point() +
  geom_line()

# ratio is only a valid metric since these are only plovers in respective states
# max in this case is an estimate for total number in each location

# frequency plot for bio ----
frequency_plot <- local_data %>%
  filter(common_name == "Piping Plover") %>%
  mutate(month = month(observation_date), week = week(observation_date)) %>%
  summarize(count = n_distinct(sampling_event_identifier), .by = c(week, month)) %>%
  mutate(count = count / max(count)) %>%
  ggplot(aes(x = week, y = count)) +
  geom_col(fill = "lightblue") +
  geom_col(aes(y = -count), fill = "lightblue") +
    scale_x_continuous(
      limits = c(1, 53),
      breaks = c(2, 6, 10, 14, 19, 23, 27, 32, 36, 41, 45, 49),
      labels = month.abb) +
  labs(title = "Relative Frequency by Week",
       caption = "\nSource: eBird Basic Dataset • Graphic by Alex Boyko") +
  theme_minimal() +
  theme(axis.title = element_blank(),
        axis.text.y = element_blank(),
        panel.grid = element_blank(),
        plot.title = element_text(hjust = 0.5, face = "bold", size = 18),
        plot.caption = element_text(hjust = 0)) +
  coord_fixed(ratio = 5)

# write out plot framework (not image)
save(frequency_plot, file = "docs/media/plot_framework.rda")
