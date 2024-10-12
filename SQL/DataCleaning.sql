-- Data Cleaning

SELECT * 
FROM layoffs;

-- Duplicate the table to have raw data always available
CREATE TABLE layoffs_staging AS
SELECT *
FROM layoffs;


-- Rename column
ALTER TABLE layoffs_staging
RENAME COLUMN total_laid_offtotal_laid_off TO total_laid_off;

-- Dataset Update. Newer data found
-- 1. Rename Old Tables
ALTER TABLE layoffs
	RENAME TO old_layoffs;

ALTER TABLE layoffs_staging
	RENAME TO old_layoffs_staging;

-- 2. Drop old tables

-- 3. Create the table for the new data
CREATE TABLE layoffs (
    Company VARCHAR(255),
    Location_HQ VARCHAR(255),
    Industry VARCHAR(100),
    Laid_Off_Count INTEGER,
    Date DATE,
    Source TEXT,
    Funds_Raised NUMERIC,
    Stage VARCHAR(50),
    Date_Added DATE,
    Country VARCHAR(100),
    Percentage DECIMAL(5, 2),
    List_of_Employees_Laid_Off TEXT
);

-- 4. Duplicate the layoffs table with new data to have raw data always available
CREATE TABLE layoffs_staging AS
SELECT *
FROM layoffs;

SELECT * 
FROM layoffs_staging;

-- 5. Rename the new columns
ALTER TABLE layoffs_staging
RENAME COLUMN location_hq TO location; 

ALTER TABLE layoffs_staging
RENAME COLUMN laid_off_count TO total_laid_off;

ALTER TABLE layoffs_staging
RENAME COLUMN funds_raised TO funds_raised_millions;

ALTER TABLE layoffs_staging
RENAME COLUMN percentage TO percentage_laid_off;

-- Remove unnecessary columns
ALTER TABLE layoffs_staging
DROP COLUMN source;

ALTER TABLE layoffs_staging
DROP COLUMN list_of_employees_laid_off;

-- Remove Duplicate
SELECT *
FROM layoffs_staging;

WITH duplicates AS (
    SELECT ctid, 
           ROW_NUMBER() OVER (
               PARTITION BY company, industry, total_laid_off, percentage_laid_off, date, stage, country, funds_raised_millions 
           ) AS row_num
    FROM layoffs_staging
)
DELETE FROM layoffs_staging
WHERE ctid IN (
    SELECT ctid
    FROM duplicates
    WHERE row_num > 1
);


-- Standardize the Data:

-- Remove blank spaces
SELECT company, TRIM(company) AS trimmedCompany
FROM layoffs_staging;

UPDATE layoffs_staging
SET company = TRIM(company);

-- Check for industry type
SELECT DISTINCT industry 
FROM layoffs_staging
ORDER BY 1;

-- Check for location location
SELECT DISTINCT location 
FROM layoffs_staging
ORDER BY 1;

-- Unify "Düsseldorf" location
SELECT *
FROM layoffs_staging 
WHERE location LIKE 'Dusseldorf'
ORDER BY 1;

UPDATE layoffs_staging
SET location = 'Düsseldorf'
WHERE location LIKE 'Dusseldorf';

-- Check for country
SELECT DISTINCT country 
FROM layoffs_staging
ORDER BY 1;

-- Check for blank or null value in industry
SELECT * 
FROM layoffs_staging
WHERE industry IS NULL
OR industry = '';

-- Remove unnecessary
SELECT *
FROM layoffs_staging
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

DELETE 
FROM layoffs_staging
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;