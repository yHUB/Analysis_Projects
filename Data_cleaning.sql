-- Data Cleaning

select *
FROM layoffs;

-- 1. Remove duplicate
-- 2. Standardize the data
-- 3. Null values

-- How create another table(changing the original table)
create table layoffs_staging
like layoffs;

select * 
from layoffs_staging;

insert layoffs_staging
select * 
from layoffs;

select *,
ROW_NUMBER () over( 
partition by company, industry, total_laid_off, percentage_laid_off, `date`) as row_num 
from layoffs_staging;

-- Check for duplicate

with duplicate_cte as
(
select *,
ROW_NUMBER () over ( partition by company, location ,industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num 
from layoffs_staging
)
select *
from duplicate_cte
where row_num > 1;

select *
from layoffs_staging
WHERE company ='Casper';


-- Remove duplicate
with duplicate_cte as
(
select *,
ROW_NUMBER () over ( partition by company, location ,industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num 
from layoffs_staging
)
delete
from duplicate_cte
where row_num > 1;



CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


select *
from layoffs_staging2;

insert layoffs_staging2
select *,
ROW_NUMBER () over ( partition by company, location ,industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num 
from layoffs_staging;

SET SQL_SAFE_UPDATES = 0;

-- Delete duplicates
delete
from layoffs_staging2
WHERE row_num > 1;

 
select *
from layoffs_staging2;

-- 2. Standardizing the data

select distinct(company), trim(company)
FROM layoffs_staging2;
-- Update
update layoffs_staging2
set company =  trim(company);

select distinct(industry)
FROM layoffs_staging2
ORDER BY 1;

select *
FROM layoffs_staging2
where industry like 'Crypto%';

update layoffs_staging2
set industry = 'Crypto'
where industry like 'Crypto%';

select *
FROM layoffs_staging2
where industry like 'Crypto%';

select DISTINCT country, trim(trailing '.' from country)
FROM layoffs_staging2
ORDER BY 1;

UPDATE layoffs_staging2
SET country = trim(trailing '.' from country)
where country like 'United States%';

select `date`,
str_to_date(`date`, '%m/%d/%Y')
FROM layoffs_staging2 ;

UPDATE layoffs_staging2
set `date` = str_to_date(`date`, '%m/%d/%Y');

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;

SELECT * 
from layoffs_staging2
where total_laid_off IS NULL
AND percentage_laid_off IS NULL;

UPDATE  layoffs_staging2
SET industry = NULL
WHERE  industry ='';

SELECT *
from layoffs_staging2
WHERE industry IS NULL
OR industry = '';

SELECT *
FROM layoffs_staging2
WHERE company = 'Bally';

SELECT t1.industry, t2.industry
FROM layoffs_staging2  t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
WHERE ( t1.industry IS NULL OR t1.industry ='')
AND t2.industry IS NOT NULL;

UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE ( t1.industry IS NULL OR t1.industry ='')
AND t2.industry IS NOT NULL;

SELECT  *
FROM layoffs_staging2;

ALTER TABLE layoffs_staging2
DROP row_num;



























