/*Steps to convert Draw_Date(text) to Draw_Date date*/
-- View dataset
SELECT * FROM lottery.lottery_powerball;

-- Step1: Alter the Draw Date
ALTER TABLE `lottery`.`lottery_powerball`
ADD COLUMN `Draw_Date_clean` DATE;

-- Step2: Convert the Draw Date from text to date
UPDATE `lottery`.`lottery_powerball`
SET `Draw_Date_clean` = STR_TO_DATE(TRIM(`Draw_Date`), '%m/%d/%Y');

-- View again
SELECT * FROM lottery.lottery_powerball;

/* Steps to convert Winning Number (text) to integer*/
-- View the dataset
SELECT `Winning Numbers`
FROM `lottery`.`lottery_powerball`
LIMIT 10;

-- Step1
ALTER TABLE `lottery`.`lottery_powerball`
ADD COLUMN `num1` INT,
ADD COLUMN `num2` INT,
ADD COLUMN `num3` INT,
ADD COLUMN `num4` INT,
ADD COLUMN `num5` INT,
ADD COLUMN `powerball` INT;

-- Step2
UPDATE `lottery`.`lottery_powerball`
SET 
  `num1` = CAST(SUBSTRING_INDEX(`Winning Numbers`, ' ', 1) AS UNSIGNED),
  `num2` = CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(`Winning Numbers`, ' ', 2), ' ', -1) AS UNSIGNED),
  `num3` = CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(`Winning Numbers`, ' ', 3), ' ', -1) AS UNSIGNED),
  `num4` = CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(`Winning Numbers`, ' ', 4), ' ', -1) AS UNSIGNED),
  `num5` = CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(`Winning Numbers`, ' ', 5), ' ', -1) AS UNSIGNED),
  `powerball` = CAST(SUBSTRING_INDEX(`Winning Numbers`, ' ', -1) AS UNSIGNED);

-- View dataset
SELECT * FROM lottery.lottery_powerball;

/* Frequency of the Number */
Select num as number, count(*) as frequency
from (
		select num1 as num from lottery_powerball
        union all
        select num2 from lottery_powerball
        union all
		select num3 from lottery_powerball
		union all
        select num4 from lottery_powerball
	    union all
		select num5 from lottery_powerball
	)as ALL_NUMS
    group by num
	order by frequency desc;
        
 /* Fequency of powerball numbers*/
 select powerball, count(*) as frequency
 from lottery_powerball
 group by powerball
 order by frequency desc;
 
 /*Draw per year*/
 select Year(Draw_Date_clean) as year, count(*) as draw
 from lottery_powerball
 group by year
 order by year;
 
  /*Draw per month*/
 select MONTHNAME(Draw_Date_clean) as month, count(*) as draw
 from lottery_powerball
 group by month
 order by month;
 
 /*Sum / Average olf Multiplier*/
 Select avg(multiplier) as Avg_Multiplier
 from lottery_powerball;
 -- Maxinum multiplier
 select max(multiplier) as max_multiplier
 from lottery_powerball;
 
 /*Most freqent pairing*/
 Select num1,  num2,  count(*) as freq
 from lottery_powerball
 group by num1, num2
 order by freq desc;
 -- High sum draw: The year with the highest sum of draw
with high as (
 Select Draw_Date_clean, (num1+num2+num3+num4+num5) as sum_num
 from lottery_powerball d
 order by sum_num desc)
 
 SELECT max(sum_num) as Highest_sum
from high;

/* Rolling frequency*/
Select num as number, MAX(Draw_Date_clean) as last_draw_date
from (
		select num1 as num, Draw_Date_clean from lottery_powerball
        union all
        select num2, Draw_Date_clean from lottery_powerball
        union all
		select num3, Draw_Date_clean from lottery_powerball
		union all
        select num4, Draw_Date_clean from lottery_powerball
	    union all
		select num5, Draw_Date_clean from lottery_powerball
	)as ALL_NUMS
    group by num
	order by last_draw_date desc;
        