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

-- Transform NULL text value in null value
UPDATE layoffs_staging
SET company = NULL
WHERE company = 'NULL' OR company = '';

UPDATE layoffs_staging
SET location = NULL
WHERE location = 'NULL' OR location = '';

UPDATE layoffs_staging
SET industry = NULL
WHERE industry = 'NULL' OR industry = '';

UPDATE layoffs_staging
SET total_laid_off = NULL
WHERE total_laid_off = 'NULL' OR total_laid_off = '';

UPDATE layoffs_staging
SET percentage_laid_off = NULL
WHERE percentage_laid_off = 'NULL' OR percentage_laid_off = '';

UPDATE layoffs_staging
SET date = NULL
WHERE date = 'NULL' OR date = '';

UPDATE layoffs_staging
SET stage = NULL
WHERE stage = 'NULL' OR stage = '';

UPDATE layoffs_staging
SET country = NULL
WHERE country = 'NULL' OR country = '';

UPDATE layoffs_staging
SET funds_raised_millions = NULL
WHERE funds_raised_millions = 'NULL' OR funds_raised_millions = '';


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

-- Group by Crypto category
SELECT DISTINCT industry 
FROM layoffs_staging
ORDER BY 1;

SELECT *
FROM layoffs_staging 
WHERE industry LIKE 'Crypto%'
ORDER BY 1;

UPDATE layoffs_staging
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

-- Unify "Düsseldorf" location
SELECT DISTINCT location 
FROM layoffs_staging
ORDER BY 1;
	
SELECT *
FROM layoffs_staging 
WHERE location LIKE 'Dusseldorf'
ORDER BY 1;

UPDATE layoffs_staging
SET location = 'Düsseldorf'
WHERE location LIKE 'Dusseldorf';

-- Remove "United States." country
SELECT DISTINCT country 
FROM layoffs_staging
ORDER BY 1;

SELECT DISTINCT country, TRIM(TRAILING '.' FROM country) 
FROM layoffs_staging
ORDER BY 1;

UPDATE layoffs_staging
SET country = TRIM(TRAILING '.' FROM country) 
WHERE country LIKE 'United States%';

-- Modify date type from text to date	
SELECT date
FROM layoffs_staging;

SELECT DISTINCT date, REGEXP_REPLACE(REGEXP_REPLACE(date, '^(\d{1})/', '0\1/'), '/(\d{1})/', '/0\1/') AS formattedData
FROM layoffs_staging
	ORDER BY 1
	
UPDATE layoffs_staging
SET date = TO_DATE(REGEXP_REPLACE(REGEXP_REPLACE(date, '^(\d{1})/', '0\1/'), '/(\d{1})/', '/0\1/'),'MM/DD/YYYY')
WHERE date ~ '^\d{1,2}/\d{1,2}/\d{4}$'; -- remove dates without valid format

ALTER TABLE layoffs_staging 
ALTER COLUMN date TYPE DATE USING date::DATE;


-- Null values or blank values
SELECT * 
FROM layoffs_staging
WHERE industry IS NULL
OR industry = '';

SELECT *
FROM layoffs_staging
WHERE company LIKE 'Bally%';

SELECT * 
FROM layoffs_staging tbl1
JOIN layoffs_staging tbl2
	ON tbl1.company = tbl2.company
	AND tbl1.location = tbl1.location
WHERE tbl1.industry IS NULL
AND tbl2.industry IS NOT NULL;

UPDATE layoffs_staging AS tbl1
SET industry = tbl2.industry
FROM layoffs_staging AS tbl2
WHERE tbl1.company = tbl2.company
	AND tbl1.location = tbl1.location
	AND tbl1.industry IS NULL
	AND tbl2.industry IS NOT NULL;


-- Remove unnecessary
SELECT *
FROM layoffs_staging
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

DELETE 
FROM layoffs_staging
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;