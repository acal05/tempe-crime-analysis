#load the necessary packages
library(tidyverse)
#load package to make the arrest_dt easier to read
library(lubridate)
#getting column and row numbers, as well as chr and dlbs
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
#Converting the columns to make it easier to go through
crime_data_clean <- crime_data
crime_data_clean$arrest_datetime <- ymd_hms(crime_data_clean$arrest_dt)
class(crime_data_clean$arrest_datetime)
head(crime_data_clean$arrest_datetime)
