-- 1. Remove Duplicates
-- 2. Standardize the Data
-- 3. Null Values or blank Values
-- 4. Remove Columns

CREATE TABLE layoffs_staging
LIKE layoffs;

INSERT layoffs_staging
SELECT * FROM layoffs;

SELECT * FROM layoffs_staging;

WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`,stage, country,funds_raised) AS row_num
FROM layoffs_staging
)
SELECT * 
FROM duplicate_cte
WHERE row_num > 1;

CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` text,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised` text,
  `row_num` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`,stage, country,funds_raised) AS row_num
FROM layoffs_staging;

SELECT * FROM layoffs_staging2
WHERE row_num > 1;

DELETE
FROM layoffs_staging2
WHERE row_num > 1;

-- Standardizing data
SELECT company, TRIM(company)
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET company = TRIM(company);

SELECT DISTINCT(industry)
FROM layoffs_staging2
ORDER BY 1;

SELECT DISTINCT(country)
FROM layoffs_staging2
ORDER BY 1;

UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';

SELECT `date`, 
STR_TO_DATE(`date`, '%Y-%m-%d')
FROM layoffs_staging2;

UPDATE layoffs_staging2
set `date` = STR_TO_DATE(`date`, '%Y-%m-%d');

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;

SELECT * 
FROM layoffs_staging2
WHERE total_laid_off IS NUll; 

SELECT DISTINCT industry
FROM layoffs_staging2;

SELECT * 
FROM layoffs_staging2
WHERE industry = '' OR industry IS NULL;

SELECT * 
FROM layoffs_staging2
WHERE company = 'Appsmith';

UPDATE layoffs_staging2
SET industry = NULL
WHERE industry = '';

SELECT * 
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company 
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;

SELECT * 
FROM layoffs_staging2
WHERE total_laid_off = '';

SELECT * 
FROM layoffs_staging2
WHERE percentage_laid_off = '';

UPDATE layoffs_staging2
SET total_laid_off = NULL
WHERE total_laid_off = '';

UPDATE layoffs_staging2
SET percentage_laid_off = NULL
WHERE percentage_laid_off = '';

UPDATE layoffs_staging2
SET funds_raised = NULL
WHERE funds_raised = '';

SELECT * 
FROM layoffs_staging2
WHERE percentage_laid_off IS NULL 
AND total_laid_off IS NULL;

DELETE
FROM layoffs_staging2
WHERE percentage_laid_off IS NULL 
AND total_laid_off IS NULL;

ALTER TABLE layoffs_staging2
DROP COLUMN row_num;

SELECT *
FROM layoffs_staging2;


-- Exploratory Data Analysis

ALTER TABLE layoffs_staging2
MODIFY COLUMN total_laid_off INT;

ALTER TABLE layoffs_staging2
MODIFY COLUMN percentage_laid_off INT;

ALTER TABLE layoffs_staging2
MODIFY COLUMN funds_raised INT;

SELECT MAX(total_laid_off),MAX(percentage_laid_off)
FROM layoffs_staging2;

-- Massive layoffs from Intel
SELECT * 
FROM layoffs_staging2
ORDER BY total_laid_off DESC;

-- 152 companies wiped out
SELECT COUNT(*)
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY total_laid_off DESC;

-- Biggest of which is Redbox, laying off 1000 employees
SELECT * 
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY total_laid_off DESC;

-- Among wiped out, Fisker had the most amount of funds raised $1,700,000,000
SELECT * 
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised DESC;

-- Intel, Tesla, Cisco Layed off the most
SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

-- Nov 2023 - Nov 2024 Date Range
SELECT MIN(`date`), MAX(`date`)
FROM layoffs_staging2;

-- Hardware and Transportation Industry Laid off the Most
SELECT industry, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;

-- United State Layed off the most, almost 10x the next on the list which is india
SELECT country, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;

-- Layoffs are coming from more mature companies already post ipo
SELECT stage, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY stage
ORDER BY 2 DESC;

-- Rolling SUM
SELECT * 
FROM layoffs_staging2;


WITH rolling_total AS
(
SELECT SUBSTRING(`date`,1,7) AS `MONTH`, SUM(total_laid_off) AS total_off
FROM layoffs_staging2
GROUP BY `MONTH`
ORDER BY `MONTH`
)
SELECT `MONTH`, total_off, SUM(total_off) OVER(ORDER BY `MONTH`) as rolling_total
FROM rolling_total;


-- different companies in the top 5 yearly
WITH company_year (company, years, total_laid_off) AS
(
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
), company_year_rank AS
(
SELECT *, DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS ranking
FROM company_year
)
SELECT * 
FROM company_year_rank
WHERE ranking < 6;















