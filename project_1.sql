-- SELECT *
-- FROM  customers
-- where contactLastName != 'Young'

-- select customername, contactfirstname, contactlastname, phone, city, country
-- from customers
-- where country ='usa' and contactFirstName = 'julie'

-- Select contactfirstname, contactlastname, city, country
-- from customers
-- where  country = 'norway' or country ='sweden'

select *
from  customers
where (country = 'usa' or country = 'uk') and contactLastName = 'brown';


Select email
from employees
where jobTitle = 'sales rep'

