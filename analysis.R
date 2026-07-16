#load the necessary packages
library(ggrepel)
library(tidyverse)
library(lubridate)
library(plotly)
library(stringr)
library(sf)
library(leaflet)
library(leaflet.extras)
library(htmlwidgets)
#import data
crime_data <- read_csv("data/Temp_Agol_Arrests_Con_TypeA_OpenData.csv")
#looking at the columns
glimpse(crime_data)
#looking at the first six rows
head(crime_data)
#Getting the names of the columns
names(crime_data)
#Check for missing values in columns
colSums(is.na(crime_data))
#Summary Statistics
summary(crime_data)

#Count the top ten number of arrests for each charge
top_charges <- crime_data %>%
  count(charge, sort = TRUE) %>%
  slice_head(n = 10)
top_charges

#Make a plot for top ten charges
top10_plot <- 
  ggplot(top_charges, 
         aes(
           x = reorder(charge, n), 
           y = n,
           text = paste(
             "<br>Arrests:", scales::comma(n)
             ))) +
  geom_col(
    fill = "steelblue",
    color = "black") +
  coord_flip() + 
  labs(
    title = "Top 10 Arrest Charges in Tempe",
    x = "Charge",
    y = "Number of Arrests"
  ) + 
  theme_bw() +
  theme(
    plot.title = element_text(
      size = 24,
      face = "bold",
      hjust = 0.5
   
    )
  )
ggplotly(top10_plot, tooltip = "text")

#Saving the top 10 charges plot
ggsave(
  filename = "plots/top_10_arrest_charges.png",
  plot = top10_plot,
  width = 10,
  height = 6,
  dpi = 300,
)
#Seeing what is in the arrest_dt column
class(crime_data$arrest_dt)
#Getting the exact format of the arrest_dt column
head(crime_data$arrest_dt)
#Converting the arrest date columns to analyze
crime_data_clean <- crime_data
crime_data_clean$arrest_datetime <- ymd_hms(crime_data_clean$arrest_dt)
class(crime_data_clean$arrest_datetime)
head(crime_data_clean$arrest_datetime)
# Feature Engineering
# Create new variables from the arrest date and time to make 
# future analysis easier.
crime_data_clean <- crime_data_clean %>%
  mutate(
    arrest_year = year(arrest_datetime),
    arrest_month = month(arrest_datetime),
    arrest_month_name = month(arrest_datetime, label = TRUE, abbr = FALSE),
    arrest_day = day(arrest_datetime),
    arrest_weekday = wday(arrest_datetime, label = TRUE, abbr = FALSE),
    arrest_hour = hour(arrest_datetime),
    arrest_season = case_when(
      arrest_month %in% c(12, 1, 2) ~ "Winter",
      arrest_month %in% c(3,4,5) ~ "Spring",
      arrest_month %in% c(6,7,8) ~ "Summer",
      TRUE ~ "Fall"
    )
  )
crime_data_clean
glimpse(crime_data_clean)

#Count arrests by seasons
season_counts <- crime_data_clean %>%
  count(arrest_season) %>%
  mutate(
    arrest_season = factor(
      arrest_season,
      levels = c("Winter", "Spring", "Summer", "Fall")
    )
  )
season_counts
#Creating a bar chart for seasonal arrests
ggplot(season_counts, aes(x = arrest_season, y = n)) +
  geom_col(
    aes(fill = arrest_season),
    color = "black") +
  labs(
    title = "Tempe's Arrests by Season Bar Chart",
    x = "Season",
    y = "Number of Arrests"
  ) +
  scale_fill_manual(
    values = c(
      "Winter" = "steelblue",
      "Spring" = "forestgreen",
      "Summer" = "gold",
      "Fall" = "darkorange"
    ) 
  ) +
  scale_y_continuous(
    labels = scales::comma
  )+
  geom_text(
    aes(label = scales::comma(n)),
    vjust = -0.3
    )+
  theme_bw() +
  theme (
    plot.title = element_text(
    hjust = 0.5,
    size = 18,
    face = "bold"
    ),
    legend.position = "none"
  )
#Saving seasonal arrests bar chart to plots
ggsave(
  filename = "plots/seasonal_arrests_bar_chart.png",
  width = 10,
  height = 6,
  dpi = 300,
)
#Creating line graph for seasonal arrests
ggplot(season_counts,
       aes(
         x = arrest_season,
         y = n,
         group = 1
      )
    ) +
  geom_line(
    size = 1
  ) +
  geom_point(
    aes(color = arrest_season),
    size = 3.5
  ) +
  geom_text(
    aes(label = scales::comma(n)),
    hjust = 1.25
  ) +
  labs(
    title = "Tempe's Seasonal Arrests Line Graph",
    x = "Season",
    y = "Number of Arrests"
  ) +
  scale_color_manual(
    values = c(
      "Winter" = "steelblue",
      "Spring" = "forestgreen",
      "Summer" = "gold",
      "Fall" = "darkorange"
    )
  ) +
  scale_y_continuous(
    labels = scales::comma
  ) +
  theme_bw() +
  theme (
    plot.title = element_text(
      hjust = 0.5,
      size = 18,
      face = "bold"
    ),
    axis.text.x = element_text(size = 9),
    legend.position = "none"
  )      
#Saving Seasonal Line Graph to plots
ggsave(
  filename = "plots/seasonal_arrests_line_graph.png",
  width = 10,
  height = 6,
  dpi = 300,
)
#Getting the range of this data set
#Dataset spans May 28, 2023 through May 26, 2026
#May has slightly few observations
range(crime_data_clean$arrest_dt)
#Getting the count of each month
monthly_counts <- crime_data_clean %>%
  count(arrest_month_name)
monthly_counts
#Creating Monthly arrests line graph
monthly_arrests_plot <- ggplot(monthly_counts,
       aes(
         x = arrest_month_name,
         y = n,
         group = 1,
         text=paste(
          "Month:", arrest_month_name,
         "<br>Arrests:", scales::comma(n)
         )
       )
      )+
  geom_line(
    size = 1
  )+
  geom_point(
    size = 2
  )+
  labs(
    title = "Tempe's Monthly Arrests Line Graph",
    x = "Month",
    y = "Number of Arrests"
  ) +
  scale_y_continuous(
    labels = scales::comma
  )+
  theme_bw() +
  theme (
    plot.title = element_text(
      hjust = 0.5,
      size = 18,
      face = 'bold'
    )
  )
ggplotly(monthly_arrests_plot, tooltip = "text")
#Saving Monthly Line Graph to plots
ggsave(
  filename = "plots/monthly_arrests_line_graph.png",
  width = 10,
  height = 6,
  dpi = 300,
)
#Getting the count of arrests by hour and converting hours into AM/PM
hourly_counts <- crime_data_clean %>%
  count(arrest_hour) %>%
  mutate(
    arrest_hour_label = trimws(
      format(
      strptime(arrest_hour, format = "%H"),
      format = "%l %p"
    )
  ),
  arrest_hour_label = factor(
    arrest_hour_label,
    levels = arrest_hour_label
  )
)
View(hourly_counts)
#Creating line graph for arrests by hour
hourly_arrests_plot <- ggplot(
  hourly_counts,
      aes(
        x = arrest_hour_label,
        y = n,
        group = 1,
        text = paste(
          "Hour:", arrest_hour_label,
          "<br>Arrests:", scales::comma(n)
        )
      )
)+
  geom_line(
    color = "skyblue3",
    size = 1)+
  labs(
    title = "Tempe's Hourly Arrests Line Graph",
    x = "Hour",
    y = "Number of Arrests"
  ) +
  scale_y_continuous(
    labels = scales::comma
  )+
  theme_bw()+
  theme(
    plot.title = element_text(
      hjust = 0.5,
      size = 18,
      face = 'bold'
    ),
    axis.text.x = element_text(
      angle = 45,
      hjust = 1
    )
  )
ggplotly(hourly_arrests_plot, tooltip = "text")
#Saving Hourly Line Graph to plots
ggsave(
  filename = "plots/hourly_arrests_line_graph.png",
  width = 10,
  height = 6,
  dpi = 300,
)
#Creating Tempe's Hourly Arrests Bar Chart
hourly_arrests_bar_graph <-
  ggplot(hourly_counts, aes(
  x = arrest_hour_label, y = n,
  text = paste(
    "Hour:", arrest_hour_label,
    "<br>Arrests:", scales::comma(n)
                          ))) +
  geom_col(
    fill = "steelblue1",
    color = "black"
  ) +
  labs(
    title = "Tempe's Hourly Arrests Bar Chart",
    x = "Hour",
    y = "Number of Arrests"
  )+
  scale_y_continuous(
    labels = scales::comma,
  ) +
  theme_bw()+
  theme(
    plot.title = element_text(
      hjust = 0.5,
      size = 18,
      face = "bold"
    )
  )
  ggplotly(hourly_arrests_bar_graph, tooltip = "text")
#save hourly bar chart
ggsave(
    filename = "plots/hourly_arrests_bar_chart.png",
    width = 10,
    height = 6,
    dpi = 300,
  )
#Getting the informational to make geographic visualizations
names(crime_data_clean)
summary(crime_data_clean$X)
summary(crime_data_clean$Y)
head(crime_data_clean[, c("X", "Y")])
head(crime_data_clean$location, 20)
crime_data_clean %>%
  count(location, sort = TRUE) %>%
  head(20)
#Cutting out the numbers from the streets
crime_data_clean <- crime_data_clean %>%
  mutate(
    street_name = str_remove(location, "^[0-9X]+\\s+")
  )
crime_data_clean %>%
  select(location, street_name) %>%
  slice_head(n = 20)
#Creating top arrests locations dataset
top_locations <-
  crime_data_clean %>% 
  count(street_name, sort = TRUE) %>%
  slice_head(n = 15)
top_locations
#Creating the top arrests locations plot
top_locations_plot <- 
  ggplot(top_locations,
         aes(
           x = reorder(street_name, n),
           y = n,
           text = paste(
             "Location:", street_name,
             "<br>Arrests:", scales::comma(n)
           )
         )
        )+
  geom_col(
    fill = "steelblue",
    color = "black") +
    coord_flip() +
    labs(
      title = "Tempe's Top Locations of Arrests",
      x = "Location",
      y = "Number of Arrests"
    )+
  theme_bw()+
  theme(
    plot.title = element_text(
      size = 24,
      face = "bold",
      hjust = 0.5
    )
  )
ggplotly(top_locations_plot, tooltip = "text")

#Saving top locations bar chart graph
ggsave(
  filename = "plots/top_locations_plot.png",
  width = 10,
  height = 6,
  dpi = 300,
)

#Prepping data for the geographic arrest heat map
# Creating one row for each unique arrest incident before mapping
arrest_map_data <-
  crime_data_clean %>%
  distinct(
    rin,
    .keep_all = TRUE
  ) %>%
  filter(
    !is.na(X),
    !is.na(Y)
  )
#View the new mapping dataset
arrest_map_data

#Compare row counts before and after removing duplicates
nrow(crime_data_clean)
nrow(arrest_map_data)
#Convert the arrest data into a spacial object using the X and Y coordinates
arrest_map_sf <- st_as_sf(
  arrest_map_data,
  coords = c("X", "Y"),
  crs = 2223
)
#Transform the spacial coordinates into latitude and longitdue for leaflet
arrest_map_latlon <-
    arrest_map_sf %>%
    st_transform(
      crs = 4326
  )
#View the transformed spatial object
arrest_map_latlon

#Display the first few longitude and latitude coordinates
head(st_coordinates(arrest_map_latlon))

#Create a basic interaction leaflet map with arrest locations
arrest_heat_map <- arrest_map_latlon %>%
  leaflet() %>%
  addTiles() %>%
  addHeatmap(
  blur = 12,
  radius = 9,
  max = 1
  )%>%
  setView(
    lng = -111.925,
    lat = 33.385,
    zoom = 12
  )
#Display the interactive map
arrest_heat_map
#Save the interactive heat map as an HTMl file
saveWidget(
  widget = arrest_heat_map,
  file = "docs/index.html",
  selfcontained = TRUE,
  title = "Tempe Arrest Density Heat Map"
)


