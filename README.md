# Executive Summary

Metro Bike Share is a Bike sharing company spread across LA. In this project, we analyze the bike data available at its website. The dataset includes two tables LABikeData and StationTable. The first table has 13 attributes which includes the unique trip id, start and end station, its location, bike id, start and end time of trip just to name a few. The dataset is from July 7, 2016, to December 31st, 2018. The second table has 4 attributes which includes station name, ID, status, region and Go Live Date. There are 4 regions viz, Downton LA, Port of LA, Venice, Pasadena across which the stations of Metro Bike share are located.

Descriptive statistics is used to examine the dataset. Dataset is converted into time series data by converting Start time attribute to datettime type and used to pivot as index values. The outliers are identified by creating a trip duration column using start time and end time columns. Additionally, outliers such as discontinued station are identified with go live data column and removed.  Missing values are imputed as discussed under Data Cleaning section.

Bike IDs are used as a feature to forecast the bike staging part of the problem. Start station is an important feature as that forms the basis of forecast number of trips. Forecast model is built using Facebook’s open source package- Prophet. The model predicts the number of trips for Q3 of 2018 to Q1 of 2019, thereby predicting the number of bikes at a region level. Additionally, based on the analysis and model results, pricing recommendations and network management and expansion suggestions are mentioned. The recommendations are visually shown using Tableau.

## Details can be found in the final report. 

## Repository include SQL, Python, Tableau files as well.
