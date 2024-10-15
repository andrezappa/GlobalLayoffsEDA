-- Exploratory Data Analysis

SELECT *
FROM layoffs_staging;

-- Companies with 100% laid off
SELECT *
FROM layoffs_staging
WHERE percentage_laid_off = 1
	AND funds_raised_millions IS NOT NULL
	ORDER BY funds_raised_millions DESC;

-- Total laid off per company with the timeframe (in months) and quantity of layoffs rounds
SELECT 
	company, 
	SUM(total_laid_off) AS total_laid_off_per_company,
	MIN(date) AS from, MAX(date) AS to, 
	EXTRACT(YEAR FROM AGE(MAX(date), MIN(date))) * 12 +
	EXTRACT(MONTH FROM AGE(MAX(date), MIN(date))) AS frame_of_laid_off, -- calculate time period of laid off (in months)
	COUNT(total_laid_off) AS qty_of_laid_off_round
FROM layoffs_staging
GROUP BY company
	HAVING SUM(total_laid_off) IS NOT NULL
	ORDER BY total_laid_off_per_company DESC;

-- Total laid off per Industry
SELECT 
	industry, 
	SUM(total_laid_off) AS total_laid_off_per_indutry
FROM layoffs_staging
GROUP BY industry
	HAVING SUM(total_laid_off) IS NOT NULL
	ORDER BY total_laid_off_per_indutry DESC;

-- Industry check
/* This query can be used to check the data for a specific company, such as 'Google'.
SELECT *
FROM layoffs_staging
WHERE company = 'Google';
*/

-- Total laid off per country
SELECT 
	country,
	SUM(total_laid_off) AS total_laid_off_per_country
FROM layoffs_staging
GROUP BY country
	HAVING SUM(total_laid_off) IS NOT NULL
	ORDER BY total_laid_off_per_country DESC;

-- Percentage of laid off by country
-- Calculate the total layoffs per country and express each country's total as a percentage of the global total layoffs.
WITH layoff_country AS (
	SELECT 
	country,
	SUM(total_laid_off) AS total_laid_off_per_country
	FROM layoffs_staging
	GROUP BY country
		HAVING SUM(total_laid_off) IS NOT NULL
) SELECT country, 
	total_laid_off_per_country, 
	total_laid_off_per_country / (SELECT SUM(total_laid_off_per_country) FROM layoff_country)*100 AS percentage   
	FROM layoff_country
	ORDER BY percentage DESC;

-- Total layoffs by year
SELECT 
	DATE_PART('year', date)  AS year,
	SUM(total_laid_off) AS laid_off_per_year
FROM layoffs_staging
GROUP BY year
	ORDER BY year ASC;

-- Laid off per month
SELECT 
	SUM(total_laid_off) AS laid_off_per_month,
	SUBSTRING(CAST(date AS text), 1, 7) AS month
FROM layoffs_staging
	GROUP BY month
	ORDER BY month;

-- Rolling sum total laid off by month
WITH rolling_total AS(
	SELECT 
	SUM(total_laid_off) AS laid_off_per_month,
	SUBSTRING(CAST(date AS text), 1, 7) AS month
	FROM layoffs_staging
		GROUP BY month
		ORDER BY 1 ASC
)
SELECT month, laid_off_per_month, SUM(laid_off_per_month) OVER(ORDER BY month) AS rolling_total -- month by month progression
FROM rolling_total;

-- Total laid off by stage
SELECT 
	stage,
	SUM(total_laid_off) AS laid_off_per_stage
FROM layoffs_staging
	WHERE stage != 'Unknown'
GROUP BY stage
	ORDER BY laid_off_per_stage DESC;

-- Total laid off by stage with average percentage
---- Calculate total layoffs and average layoff percentage for each stage
SELECT 
	stage,
	SUM(total_laid_off) AS laid_off_per_stage,
	AVG(percentage_laid_off) * 100 AS avg_percentage
FROM layoffs_staging
	WHERE stage != 'Unknown'
GROUP BY stage
	ORDER BY avg_percentage DESC;

-- Rank the companies
-- Company laid off per year
SELECT 
	company,
	DATE_PART('year', date)  AS years,
	SUM(total_laid_off) AS laid_off_per_year
FROM layoffs_staging
GROUP BY company, years
	HAVING SUM(total_laid_off) IS NOT NULL
	ORDER BY laid_off_per_year DESC;

-- Ranking. Filter for top 5 companies per year
-- Create a ranking of companies based on the total number of layoffs per year, returning the top 5 companies for each year.
WITH company_year AS (
	SELECT 
	company,
	DATE_PART('year', date)  AS years,
	SUM(total_laid_off) AS laid_off_per_year
	FROM layoffs_staging
	GROUP BY company, year
		HAVING SUM(total_laid_off) IS NOT NULL
), company_year_rank AS(
	SELECT *, 
		DENSE_RANK() OVER (PARTITION BY years ORDER BY laid_off_per_year DESC) AS ranking
	FROM company_year
)
SELECT *
FROM company_year_rank
	WHERE ranking < 6;

-- Rank the industry
-- Industry laid off per year
SELECT 
	industry,
	DATE_PART('year', date)  AS years,
	SUM(total_laid_off) AS laid_off_per_year
FROM layoffs_staging
GROUP BY industry, years
	HAVING SUM(total_laid_off) IS NOT NULL
	ORDER BY laid_off_per_year DESC;

-- Ranking. Filter for top 3 industries per year
-- Create a ranking of industries based on total layoffs per year, returning the top 3 industries for each year.WITH industry_year AS (
	SELECT 
	industry,
	DATE_PART('year', date)  AS years,
	SUM(total_laid_off) AS laid_off_per_year
	FROM layoffs_staging
	GROUP BY industry, years
		HAVING SUM(total_laid_off) IS NOT NULL
), industry_year_rank AS(
	SELECT *, 
		DENSE_RANK() OVER (PARTITION BY years ORDER BY laid_off_per_year DESC) AS ranking
	FROM industry_year
)
SELECT *
FROM industry_year_rank
	WHERE ranking < 4;

-- Total layoffs based on total funds raised
-- Calculate the total number of layoffs for each company, along with the amount of funds raised (in millions)
SELECT 
	company,
	funds_raised_millions,
	SUM(total_laid_off) AS laid_off
FROM layoffs_staging
	WHERE funds_raised_millions IS NOT NULL
	AND total_laid_off IS NOT NULL
GROUP BY company, funds_raised_millions
	ORDER BY laid_off DESC;
