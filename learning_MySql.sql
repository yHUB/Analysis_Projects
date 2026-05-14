SELECT first_name,
LEFT(first_name, 4),
RIGHT(first_name, 4),
SUBSTRING(first_name,3,2),
birth_date,
SUBSTRING(birth_date,6,2) AS birth_moonth
FROM employee_demographics; 

SELECT first_name, REPLACE(first_name, 'a', 'z')
FROM employee_demographics;
 
SELECT locate('b', '');

SELECT first_name, locate('An',first_name)
FROM employee_demographics;

SELECT first_name, last_name,
concat(first_name,' ', last_name) as full_name
FROM employee_demographics;

-- WHERE Clause

SELECT * 
FROM employee_salary
WHERE first_name = 'Leslie';

SELECT * 
FROM employee_salary
WHERE salary <= 50000;

SELECT * 
FROM employee_demographics
WHERE birth_date > '1985-01-01' ; 

-- AND OR NOT --Logical Operators
 SELECT * 
FROM employee_demographics
WHERE birth_date > '1985-01-01'
OR NOT gender = 'male';

 SELECT * 
FROM employee_demographics
WHERE (first_name = 'Leslie' AND age= 44) OR age > 55;

-- LIKE
-- % and _
 SELECT * 
FROM employee_demographics
WHERE first_name LIKE '_ er%';

-- GROUP BY
SELECT gender, AVG(age)
FROM employee_demographics
GROUP BY gender;

SELECT *
FROM employee_demographics
GROUP BY gender ;   

-- ORDER BY
SELECT 
    *
FROM
    employee_demographics
ORDER BY gender DESC, age DESC; 

--  HAVING VS WHERE
SELECT  gender, AVG(age)
FROM employee_demographics
GROUP BY gender 
HAVING AVG(age ) > 40;

SELECT occupation, AVG(salary)
FROM employee_salary
WHERE occupation LIKE '%manager%'
GROUP BY occupation
HAVING AVG(salary) > 75000;

-- LIMIT & Aliasing
SELECT *
FROM employee_demographics
LIMIT 3, 1;

-- Joins
SELECT *
FROM employee_demographics dem 
INNER JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id
;

-- Outer Joins
SELECT *
FROM employee_demographics dem 
RIGHT JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id
;

-- Self Join
SELECT emp1.employee_id emp_santa,
	   emp1. first_name  first_name_santa,
        emp1. first_name  last_name_santa,
        emp2.employee_id emp_nmame,
	   emp2. first_name  first_name_santa_emp,
        emp2. first_name  last_name_santa_emp
FROM employee_salary emp1
 JOIN employee_salary emp2
	ON emp1.employee_id + 1 = emp2.employee_id;
    
    -- Joining Mulple TABLE
 SELECT *
FROM employee_demographics dem 
INNER JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id
	INNER JOIN parks_departments pd
		ON sal.dept_id = pd.department_id;

-- Union
SELECT first_name, last_name
FROM employee_demographics
UNION ALL
SELECT first_name, last_name
FROM employee_salary;

SELECT first_name, last_name, 'Old Man' Label
FROM employee_demographics
WHERE age > 45 and gender = 'Male'
UNION 
SELECT first_name, last_name, 'Old Lady' Label
FROM employee_demographics
WHERE age > 45  and gender = 'Female'
UNION
SELECT first_name, last_name, 'Highly paid Employee' 
FROM employee_salary
WHERE salary > 70000;

-- String FunctioNY
SELECT LENGTH('sky fall');

SELECT first_name, LENGTH(first_name) as len_name
FROM employee_demographics
HAVING len_name > 3
ORDER BY first_name ASC;

SELECT first_name, UPPER(first_name) 
FROM employee_demographics;
-- CASE
SELECT first_name,
last_name,
age,
case
	WHEN age <= 30 THEN 'Young'
    WHEN age < 10 THEN 'Infant'
    ELSE 'Human'
    END AS Age_Bracket
FROM employee_demographics;
    

--   Pay Increase and Bonuses
-- < 50000 = 5%
-- > 50000 = 7%
-- Finance = 10% 

SELECT first_name, last_name,salary,
CASE
	WHEN salary < 50000 THEN salary + (salary * 0.05)
    WHEN salary > 50000 THEN salary + (salary + 0.07)
    
  ELSE 'No bonus'
END AS New_salary,
CASE
	WHEN  dept_id = 6 THEN (salary * .1) 
END AS Bonus
FROM employee_salary;

-- Subqueries
		
SELECT *
FROM employee_demographics
WHERE employee_id IN
				(SELECT employee_id
					FROM employee_salary
                    WHERE dept_id = 1);
				
SELECT first_name, salary,
(SELECT AVG(salary)
FROM employee_salary) average_salary
FROM employee_salary;


SELECT  dem.*
FROM employee_demographics dem
JOIN employee_salary sal
ON dem.employee_id = sal.employee_id
-- JOIN parks_departments PD
-- ON sal.dept_id =pd.department_id ;
WHERE sal.dept_id  =1;
  
SELECT first_name, salary,
(SELECT AVG(salary)
FROM employee_salary)
FROM employee_salary;

SELECT gender, AVG(age), MAX(age), MIN(age),COUNT(age)
FROM employee_demographics
GROUP BY gender;

SELECT gender, AVG((max_age)) 
FROM 
(SELECT gender, AVG(age) avg_age, MAX(age) max_age, MIN(age) min_age,COUNT(age) count_age
FROM employee_demographics
GROUP BY gender) AS Agg_table
GROUP BY gender;

SELECT AVG((avg_sal)) 
FROM 
(SELECT gender, AVG(salary) avg_salary, MAX(salary) max_salary, MIN(salary) min_salary,COUNT(salary) count_salary
FROM employee_demographics dem
JOIN emplpyee_salary sal
	ON dem.employee_id = sal.employee_id
GROUP BY gender) AS example_subquery;


-- Window Functions
SELECT gender, AVG(salary)
FROM employee_demographics dem
JOIN employee_salary sal
ON dem.employee_id = sal.employee_id
GROUP BY gender;


SELECT dem.first_name, dem.last_name, gender, AVG(salary) avg_salary
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id
GROUP BY dem.first_name, dem.last_name, gender;
                     
SELECT dem.first_name, dem.last_name, gender, SUM(salary) OVER(PARTITION BY gender)
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id;
    
SELECT dem.first_name, dem.last_name, salary, SUM(salary) OVER(PARTITION BY 
gender ORDER BY dem.employee_id) AS Rolling_Total
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id;
    
SELECT dem.employee_id, dem.first_name, dem.last_name,gender, salary, 
ROW_NUMBER() OVER(PARTITION BY gender ORDER BY salary ASC) AS row_num,
RANK() OVER(PARTITION BY gender ORDER BY salary ASC) AS rank_num,
DENSE_RANK() OVER(PARTITION BY gender ORDER BY salary ASC) AS dense_rank_num
FROM employee_demographics dem
JOIN employee_salary sal 
	ON dem.employee_id = sal.employee_id;
    
    
   -- CTEs
   
WITH CTE_Example AS
(
SELECT gender, AVG(salary) avg_sal, MAX(salary) max_sal, MIN(salary) min_sal, COUNT(salary) count_sal
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id
GROUP BY  gender
)
SELECT AVG(avg_sal)
FROM CTE_Example;


SELECT AVG(avg_sal)
FROM
(
SELECT gender, AVG(salary) avg_sal, MAX(salary) max_sal, MIN(salary) min_sal, COUNT(salary) count_sal
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id
GROUP BY  gender) example_subquery ;


WITH CTE_Example AS
(
SELECT employee_id, gender, birth_date
FROM employee_demographics 
WHERE birth_date > '1985-01-01'
),
CTE_Example2 AS
(
SELECT employee_id, salary
FROM employee_salary
WHERE salary >50000
)
SELECT *
FROM CTE_Example
JOIN CTE_Example2
	ON CTE_Example.employee_id = CTE_Example2.employee_id;
    
    

WITH CTE_Example (Gender, AVG_Sal, MAX_Sal, MIN_Sal, Count_Sal)   AS
(
SELECT gender, AVG(salary) avg_sal, MAX(salary) max_sal, MIN(salary) min_sal, COUNT(salary) count_sal
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id
GROUP BY  gender
)
SELECT *
FROM CTE_Example;

-- Temporary Tables

CREATE TEMPORARY TABLE tempo_table(
first_name VARCHAR(50),
last_name VARCHAR (50),
movie VARCHAR(90),
age int); 

SELECT *
FROM tempo_table;

INSERT INTO tempo_table
VALUE('Alex', 'Bonns', 'Moana,', 65),
	('Ini', 'bot', 'nemo', 45),
    ('john', ' ',' ', 23);

SELECT *
FROM temp_table;

SELECT *
FROM employee_salary;

CREATE TEMPORARY TABLE salary0_over_50k
SELECT *
FROM employee_salary
WHERE salary >= 50000;

SELECT *
FROM salary0_over_50k;

-- Stored Procedures

-- CREATE  PROCEDURE large_salaries()
SELECT *
-- FROM employee_salary
WHERE salary >= 10000;
SELECT *
FROM employee_salary
WHERE salary >= 50000;

-- CALL large_salaries();
CALL large_salaries();

DELIMITER ££
CREATE  PROCEDURE large_salaries4()
BEGIN
	SELECT *
	FROM employee_salary
	WHERE salary >= 10000;
	SELECT *
	FROM employee_salary
	WHERE salary >= 60000;
END ££
DELIMITER ;
CALL large_salaries4();

-- PARAMETERS

DELIMITER ££
CREATE  PROCEDURE large_salaries4()
BEGIN
	SELECT salary
	FROM employee_salary
    WHERE gender = parameter ;

END ££
DELIMITER ;

CALL large_salaries4();

DELIMITER ££
CREATE  PROCEDURE NAME()
BEGIN
	
	SELECT *
	FROM employee_demographics;
    -- WHERE employee_id = parameter;
END ££

DELIMITER ;
CALL NAME();   

-- Triggers and Events

SELECT *
FROM employee_demographics;

SELECT *
FROM employee_salary;

 DELIMITER $$
 CREATE TRIGGER employee_insert0
	AFTER INSERT ON employee_salary
    FOR EACH ROW
BEGIN
	INSERT INTO employee_demographics (employee_id, first_name, last_name)
    VALUES (NEW.employee_id, NEW.first_name, NEW.last_name);
END $$
DELIMITER ;

INSERT INTO employee_salary (employee_id, first_name, last_name, occupation, salary,dept_id)
VALUES(13, 'Adeoasis',  'Uranium','Analysis-CEO', 10000000, NULL);
drop trigger employee_insert0;
DELIMITER $$

CREATE TRIGGER employee_insert6
AFTER INSERT ON employee_demographics
FOR EACH ROW
BEGIN
    INSERT INTO employee_salary (
        employee_id,
        first_name,
        last_name
    )
    VALUES (
        NEW.employee_id,
        NEW.first_name,
        NEW.last_name
    );
END $$
DELIMITER ;
 
 INSERT INTO employee_demographics (employee_id, first_name, last_name, age, gender,birth_date)
VALUES(14, 'Adeoasis',  'Uranium',54, 'M', '10-12-1990');

--	EVENTS

SELECT *
FROM employee_demographics;

DELIMITER $$
CREATE EVENT delete_retirees
ON SCHEDULE EVERY 20 SECOND
DO
BEGIN
	DELETE
    FROM employee_demographics
    WHERE age >= 60;
END $$
DELIMITER ;