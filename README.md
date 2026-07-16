# Tempe Crime Exploratory Data Analysis

## Project Overview

This project analyzes public arrest data from the City of Tempe, Arizona using R. 
The goal is to identify patterns in arrests and explore how different factors 
such as offense type, season, day of the week, and time of year may influence 
crime trends.

This project is being developed as part of my personal data science portfolio 
while studying Data Science at Arizona State University.

---
## 🌐 Interactive Dashboard

Explore the interactive visualizations created during this analysis.

| Visualization | Launch |
|:---|:---:|
| 🏠 Project Homepage | [Open](https://acal05.github.io/tempe-crime-analysis/) |
| 📊 Top 10 Arrest Charges | [Open](https://acal05.github.io/tempe-crime-analysis/top_charges.html) |
| 📅 Monthly Arrest Trends | [Open](https://acal05.github.io/tempe-crime-analysis/monthly_arrests.html) |
| 🕒 Hourly Arrest Trends | [Open](https://acal05.github.io/tempe-crime-analysis/hourly_arrests_line.html) |
| 📈 Hourly Arrest Bar Chart | [Open](https://acal05.github.io/tempe-crime-analysis/hourly_arrests_bar.html) |
| 📍 Top Arrest Locations | [Open](https://acal05.github.io/tempe-crime-analysis/top_locations.html) |
| 🔥 Geographic Arrest Heat Map | [Open](https://acal05.github.io/tempe-crime-analysis/arrest_heat_map.html) |

> Hover over points, bars, and map regions to explore the underlying data interactively.
## Table of Contents

- Project Overview
- Dataset
- Research Questions
- Analysis
  - Tempe Crime Heat Map
  - Top 10 Arrest Charges
  - Monthly Arrest Patterns
  - Seasonal Arrest Patterns
  - Hourly Arrest Patterns
- Tools Used
- Current Progress
- Future Improvements
## Dataset

Source:
City of Tempe Open Data

The dataset contains over 43,000 arrest records with information including:

- Arrest date and time
- Arrest charge
- Arrest type
- Location information
- Other offense-related variables

---

## Research Questions (Living List)

Current questions include:

- What are the most common arrest charges?
- Do arrest patterns change by season?
- Which months experience the most arrests?
- Are weekends different from weekdays?
- What times of day have the highest arrest activity?
- How have arrest patterns changed over time?
- What are the geographical patterns?

Additional questions will be added as new patterns emerge during the analysis.

---
# Analysis

## 1. Geographic Arrest Density Heat Map

### Interactive Visualization

[View the interactive arrest density heat map](https://acal05.github.io/tempe-crime-analysis/)

### Key Insights

* Arrest activity is concentrated in several distinct geographic hotspots rather
  than being distributed evenly throughout the dataset.
* Higher-density areas appear along major commercial and transportation corridors.
* The heat map reveals localized spatial patterns that are difficult to identify 
from street-level arrest totals alone.
* The interactive version allows users to zoom and explore arrest-density patterns
at different geographic scales.

### Methodology

The original dataset was stored at the charge level, meaning a single arrest could appear in multiple rows when multiple charges were recorded. The mapping dataset was reduced to one row per unique arrest incident using the `rin` identifier.

The original projected coordinates were assigned the EPSG:2223 coordinate reference system and transformed to WGS 84 latitude and longitude coordinates using the `sf` package. The interactive heat map was then created with `leaflet` and `leaflet.extras`.

### Dataset Note

The map represents the complete arrest dataset as provided. Some coordinates appear outside Tempe’s municipal boundaries. These records were retained to maintain consistency with the other analyses in the project.

## 2. Top 10 Arrest Charges (Bar Chart)
### Figure
![Top 10 Arrest Charges](plots/top_10_arrest_charges.png)
* Fugitive from Justice (FOJ) Warrant is by far the most common arrest charge, 
accounting for 7,807 arrests, more than double the second most common offense.
* Several of the most common charges involve warrants, drug offenses, and 
property-related crimes rather than violent offenses.
* The large difference between the first and second ranked charges suggests 
warrant enforcement contributes substantially to overall arrest activity.

## 3. Monthly Arrest Patterns (Line Graph)
### Figure
![Monthly Arrests Bar Chart](plots/monthly_arrests_line_graph.png)
* Arrest activity gradually increases from spring through early fall before
declining toward the end of the year.
* September records the highest number of arrests (3,999), while November 
records the lowest (3,155).
* The variation across months is moderate, suggesting arrests occur consistently 
throughout the year rather than being concentrated in one season.

## 4.a. Seasonal Arrest Patterns (Bar Chart)
### Figure
![Seasonal Arrests Bar Chart](plots/seasonal_arrests_bar_chart.png)
### Seasonal Arrest Patterns Bar Chart Analysis
* Arrest totals remain relatively consistent across all four seasons.
* Summer records the highest arrest total (11,412), while Winter records the 
lowest (10,525).
* Seasonal differences are relatively small, indicating that season alone is not 
a major driver of arrest frequency.

## 4.b. Seasonal Arrest Patterns (Line Graph)
### Figure
![Seasonal Arrests Line Graph](plots/seasonal_arrests_line_graph.png)
### Seasonal Arrest Line Graph Analysis
* The line graph highlights the gradual increase in arrests from Winter to Summer
before a slight decline in Fall.
* Compared with the bar chart, the line graph makes the overall seasonal trend 
easier to recognize.
* Both visualizations support the conclusion that seasonal variation exists but 
remains relatively modest.

## 5. Hourly Arrest Patterns (Bar Chart)
###Figure
![Hourly Arrests Line Graph](plots/hourly_arrests_bar_chart.png)
### Hourly Arrest Analysis
* Arrest activity peaks during the overnight hours, with the highest number of 
arrests occurring around **1:00 AM**.
* Arrests decline sharply during the early morning hours before gradually 
increasing throughout the day.
* A secondary period of elevated arrest activity occurs during the afternoon 
and late evening, suggesting multiple periods of increased law enforcement activity.
* An interactive Plotly version of this visualization is available in the 
project's interactive visualizations (coming soon), allowing users to hover over
each hour to view the exact arrest totals.

## 5.b. Hourly Arrest Patterns (Line Graph)
### Figure
![Hourly Arrests Line Graph](plots/hourly_arrests_line_graph.png)
### Hourly Arrest Analysis
* Arrest activity is highest during the early morning hours around 1 AM, 
indicating increased enforcement or criminal activity overnight.
* Arrest counts decline sharply during the early morning before gradually 
increasing throughout the afternoon and evening.
* A secondary increase during the late evening suggests arrest activity remains
elevated after typical business hours.
* The interactive Plotly visualization allows users to inspect the exact arrest 
count for every hour of the day.

## 6. Top Locations Bar Chart
![Top Locations Bar Chart](plots/top_locations_plot.png)

### Top Locations Analysis
* S Mill Avenue recorded substantially more arrests than any other roadway in 
the dataset.
* Several major transportation corridors—including Baseline Road, Apache Blvd, 
Scottsdale Road, and Rural Road—appear among the highest arrest locations.
* The concentration of arrests along major arterial roads suggests enforcement 
activity and traffic-related incidents contribute heavily to overall arrest volume.
*This visualization identifies geographic corridors that may warrant additional 
public safety analysis or resource allocation.

## Tools Used
##
- R
- RStudio
- tidyverse
- ggplot2
- lubridate
- Git
- GitHub

## Interactive Visualizations

Several charts in this project have also been developed as interactive Plotly 
visualizations. Interactive versions will be published using GitHub Pages as the
project continues to expand, allowing users to hover over data points and explore 
exact values.
---

## Current Progress

Completed:

- Imported and explored the dataset
- Checked for missing values
- Generated summary statistics
- Identified the Top 10 arrest charges
- Created the first visualization using ggplot2
- Converted date-time values for future time-based analysis
- Seasonal analysis
- Monthly arrest trends
- Hour-of-day analysis


In Progress:
- Geographical analysis
- Additional visualizations


---

## Future Improvements

Planned additions include:
- Geographic crime visualizations
- Interactive dashboard
- Statistical modeling of crime patterns
- Python implementation of the analysis

---

## Author

Abigail Calvert

Data Science Student  
Arizona State University