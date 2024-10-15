# Global Layoffs Data Analysis Project

## Project Overview
This project aims to provide a comprehensive analysis of global layoffs trends using a dataset from [Kaggle](https://www.kaggle.com/datasets/theakhilb/layoffs-data-2022/data). The primary goal of this analysis is to gain insights into layoff patterns across various industries, countries, and timeframes.

The analysis was conducted with a multi-step process:
1. **Data Cleaning**: Ensuring data accuracy and consistency by removing irrelevant information, handling missing values, and standardizing data entries.
2. **Exploratory Data Analysis (EDA)**: Applying SQL queries to reveal patterns and trends within the data, thus allowing for in-depth insights into global layoff trends.

## Objectives
The key objectives of this project are:
- To analyze layoffs by industry, country, and stage of business development.
- To uncover patterns over time, identifying which months, quarters, or years experienced significant layoffs.
- To highlight the relationship between layoffs and variables like the amount of funding raised, industry sector, and geographic location.
- To create an analytical foundation for potential data visualization, facilitating easier interpretation of layoff trends for stakeholders.

## Tools Used
- **pgAdmin4** for executing SQL queries and managing the database.
- **Excel** for initial data exploration and quick visual insights.
- **Git** for version control, allowing for seamless project updates and tracking.
- **Kaggle** for sourcing the dataset and researching additional industry-specific information.

## Dataset
The dataset used for this analysis was sourced from [Kaggle](https://www.kaggle.com/datasets/theakhilb/layoffs-data-2022/data). It contains information about global layoffs, with the following columns:
- `Company`: Name of the company
- `Location_HQ`: Headquarters location of the company
- `Industry`: The sector in which the company operates
- `Laid_Off_Count`: Number of employees laid off in each event
- `Date`: Date of the layoff event
- `Source`: The source from which the layoff data was reported
- `Funds_Raised`: Total funds raised by the company
- `Stage`: Business development stage of the company at the time of layoff
- `Date_Added`: Date when the record was added to the dataset
- `Country`: Country of the company
- `Percentage`: Percentage of the workforce laid off
- `List_of_Employees_Laid_Off`: Names of employees (where available)

## Analysis Process

### 1. Data Cleaning
The data cleaning process involved:
- **Identifying** and **removing null values** or irrelevant data entries.
- **Standardizing columns** for easier querying, such as ensuring dates were in a uniform format.
- **Updating unknown or inconsistent entries** based on research findings, enhancing the reliability of the dataset.

### 2. Exploratory Data Analysis (EDA)
The EDA phase involved detailed SQL querying to derive insights, including:
- **Identifying companies with a full 100% layoff rate** to understand which companies entirely shut down operations.
- **Summing total layoffs by company and timeframe**, allowing us to understand the frequency and impact of layoffs per company over specific periods.
- **Analyzing layoffs per industry**, giving insight into which sectors are most vulnerable to downsizing.
- **Calculating total layoffs per country** to identify which regions are most affected.
- **Understanding the proportion of layoffs per country** as part of a global total, for a relative perspective.
- **Mapping layoffs over time** (both monthly and yearly) to reveal trends and pinpoint peak layoff periods.
- **Ranking companies and industries** based on yearly layoffs, helping to identify the most and least affected entities.

Each query was designed to facilitate in-depth insights into the layoff dataset. The results obtained are primed for graphical visualization, allowing HR professionals, data analysts, and industry leaders to interpret trends more effectively and make data-driven decisions.

## Potential Use Cases
The analysis performed in this project has practical applications in various fields:
- **HR & Recruitment**: By identifying which industries are most susceptible to layoffs, HR professionals can better plan their hiring strategies and prepare for potential impacts in their own sectors.
- **Financial Planning & Risk Management**: Businesses can use these insights to predict potential downturns in their industries and plan accordingly.
- **Economic Forecasting**: Government and private-sector economists can leverage the trends revealed in this analysis to forecast economic health and potentially preempt economic challenges within certain industries.

## Next Steps
- **Data Visualization**: Creating graphs and charts in tools like Tableau to illustrate the trends discovered in this analysis.
- **Predictive Modeling**: Building machine learning models to predict future layoff events based on current data trends.

## Contributing
Contributions are welcome. Please open an issue or submit a pull request for any changes you believe could enhance this analysis.
