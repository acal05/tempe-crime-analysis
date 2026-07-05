#load the necessary packages
library(tidyverse)
library(lubridate)
library(plotly)
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
top10_plot <- ggplot(top_charges, aes(x = reorder(charge, n), y = n)) +
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
top10_plot
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
  geom_line() +
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
