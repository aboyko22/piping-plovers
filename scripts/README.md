# Scripts

Below is a description of all of the scripts used to clean the data and conduct the analysis used in this project.

- `00_Data_Cleaning.R`: Raw data was read in, and a function was developed to clean the data and select the variables necessary to complete an exploratory data analysis. This cleaned data was then written out.
- `01_EDA.R`: An exploratory data analysis was conducted to determine the direction of the project and decide which visualizations should be made, so that they could potentially be included in the story.
- `02_Past_Week.R`: Data from the `rebird` API is read in and saved to be used in a JavaScript visualization. Additionally, the relative frequency graph is updated with an up-to-date week marker.
- `03_Image_Scraping.py`: The links for images from [All About Birds](allaboutbirds.org) were scraped for the most common species in Cook County, to be used in an interactive visualization.
- `03_Visualization.R`: Code was written to explore the validity of multiple visualizations, some of which were used and others which served as a blueprint for Flourish visualizations.