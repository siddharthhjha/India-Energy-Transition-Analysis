# India Energy Transition Analysis

SQL + Power BI analysis of India's 55-year energy transition (1965-2019), 
examining growth, renewable scaling, and grid concentration trends.

## Key Findings
- 15.36x growth in primary energy consumption since 1965
- Solar generation scaled 409x since 2010, yet grid CO2 intensity 
  rose alongside coal expansion
- Grid concentration (HHI) increased from 4,696 (1985) to 5,443 (2019), 
  with notable volatility — peaking near 6,000 around 2015

## Data Source
[Energy Consumption Dataset by Our World in Data](https://www.kaggle.com/datasets/shubamsumbria/complete-energy-profile-of-india-1965-2019?resource=download), filtered to India.

## Pipeline
1. Loaded raw CSV into MySQL staging table
2. Identified and logged ~29 data anomalies (see `data_quality_log`), 
   including a mislabeled unit column (8 fields tagged "EJ" were 
   actually already in TWh — confirmed via cross-validation against 
   the reported primary energy total)
3. Built clean fact table `energy_india_clean`
4. Calculated HHI, growth multiples, CO2 intensity trends in SQL/DAX
5. Built interactive Power BI dashboard

## Dashboard Preview
![dashboard](https://github.com/siddharthhjha/India-Energy-Transition-Analysis/blob/main/Dashboard_Preview.png)

## Tools
MySQL, Python (data loading), Power BI, DAX
