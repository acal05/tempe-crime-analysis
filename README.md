# Tempe Crime Analysis

## Project Overview

This project analyzes public arrest data from the City of Tempe, Arizona using R. 
The goal is to identify patterns in arrests and explore how different factors 
such as offense type, season, day of the week, and time of year may influence 
crime trends.

This project is being developed as part of my personal data science portfolio 
while studying Data Science at Arizona State University.

---

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
- Which months experience the most arrests?
- Do arrest patterns change by season?
- Are weekends different from weekdays?
- What times of day have the highest arrest activity?
- How have arrest patterns changed over time?

Additional questions will be added as new patterns emerge during the analysis.

---

## Sample Visualization

### Top 10 Arrest Charges

![Top 10 Arrest Charges](plots/top_10_arrest_charges.png)
### Top 10 Arrest Charges Analysis

The most common arrest charge in the dataset is **Fugitive from Justice FOJ Warrant**, with 7,807 arrests. This category appears much more frequently than the second most common charge, **Drug Paraphernalia-Possess/Use**, which has 3,310 arrests.

Several of the top charges are related to warrants, drug offenses, trespassing, and public order offenses. This suggests that many arrests in the dataset are connected to recurring legal, substance-related, and low-level property or conduct issues rather than one single type of violent offense.

This chart provides an initial overview of the most frequent arrest categories and helps guide later analysis into when and where these offenses occur.
---
## Tools Used

- R
- RStudio
- tidyverse
- ggplot2
- lubridate
- Git
- GitHub

---

## Current Progress

Completed:

- Imported and explored the dataset
- Checked for missing values
- Generated summary statistics
- Identified the Top 10 arrest charges
- Created the first visualization using ggplot2
- Converted date-time values for future time-based analysis

In Progress:

- Seasonal analysis
- Monthly crime trends
- Day-of-week analysis
- Additional visualizations

---

## Future Improvements

Planned additions include:

- Seasonal crime analysis
- Monthly arrest trends
- Day-of-week analysis
- Hour-of-day analysis
- Arrest type comparisons
- Geographic crime visualizations
- Interactive dashboard
- Statistical modeling of crime patterns
- Python implementation of the analysis

---

## Author

Abigail Calvert

Data Science Student  
Arizona State University