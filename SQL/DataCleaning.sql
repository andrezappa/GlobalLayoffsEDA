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


-- Standardize the Data


-- Null values or blank values

-- Remove unnecessary