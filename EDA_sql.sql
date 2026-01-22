-- Explanatory Data Analysis


SELECT *
FROM layoffs_staging2;

SELECT max(total_laid_off), max(percentage_laid_off)
FROM layoffs_staging2;

SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off =1
ORDER BY total_laid_off DESC;

SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

SELECT MIN(`date`), MIN(`date`)
FROM layoffs_staging2;

SELECT country, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY country 
ORDER BY 2 DESC;

SELECT *
FROM layoffs_staging2;

SELECT year(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY year(`date`)
ORDER BY 1 DESC;

SELECT stage, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY stage
ORDER BY 2 DESC;

SELECT company, SUM(percentage_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

SELECT substring(`date`, 1, 7) as `MONTH`, SUM(total_laid_off)
FROM layoffs_staging2
WHERE substring(`date`, 1, 7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1;

 WITH Rolling_Total AS
 (
 SELECT substring(`date`, 1, 7) as `MONTH`, SUM(total_laid_off) AS total_off
FROM layoffs_staging2
WHERE substring(`date`, 1, 7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC
)

SELECT  `MONTH`, total_off,
SUM(total_off) OVER(ORDER BY `MONTH`) AS rolling_total
FROM Rolling_Total;
 
 SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

 SELECT company,year(`date`) ,SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company,year(`date`)
ORDER BY 3 DESC;


WITH Company_Year (industry, company, years, total_laid_off) AS
(
 SELECT industry,company, year(`date`) ,SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY industry,company,year(`date`)
), Company_Year_Rank AS
(
SELECT *, DENSE_RANK() OVER( PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking
FROM Company_Year
WHERE years IS NOT NULL
ORDER BY  Ranking ASC
)
SELECT * 
FROM Company_Year_Rank
WHERE Ranking <=5;

