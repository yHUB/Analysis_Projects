select 

case when creditlimit < 75000 then 'a: less than 75 :improve your credit limit'
when creditlimit between 75000 and 100000 then 'b: £75k - £100k : improved credit limit'
when creditlimit between 10000 and 150000 then 'c: £75k - £150 : over improved credit limit '
when creditlimit > 150000 then 'd: over 150k'
else 'other' end as credit_limit_grp,

count(distinct c.customernumber) as customers  
from customers c
group by 1;

SELECT
    CASE
        WHEN quantityordered < 10 THEN 'W: Small customer'
        WHEN quantityordered BETWEEN 10 AND 20 THEN 'X: Small Medium customer'
        WHEN quantityordered BETWEEN 20 AND 30 THEN 'Y: Medium customer'
        WHEN quantityordered BETWEEN 30 AND 40 THEN 'Z: Large customer'
        ELSE 'Large customer'
    END AS type_of_customer,
    COUNT(distinct quantityOrdered) AS count_order
FROM
    orderdetails
GROUP BY
    CASE
        WHEN quantityordered < 10 THEN 'W: Small customer'
        WHEN quantityordered BETWEEN 10 AND 20 THEN 'X: Small Medium customer'
        WHEN quantityordered BETWEEN 20 AND 30 THEN 'Y: Medium customer'
        WHEN quantityordered BETWEEN 30 AND 40 THEN 'Z: Large customer'
        ELSE 'Large customer'
    END
    order by count_order
    ;

select
case when amount < 10000 then 'A: Cheapest Motor'
when amount between 10000 and 30000 then 'B: Cheaper Motor'
when amount between 30000 and 50000 then 'C: Cheap Motor'
when amount between 50000 and 70000 then 'D: Expensive Motor'
when amount  > 70000 then 'E:Very Expensive Motor'
else 'Damn motor'end as Type_of_Cars,

count(distinct customerNumber) Numbers_of_customers,
count(distinct amount) Number_of_cars
from payments
group by case when amount < 10000 then 'A: Cheapest Motor'
when amount between 10000 and 30000 then 'B: Cheaper Motor'
when amount between 30000 and 50000 then 'C: Cheap Motor'
when amount between 50000 and 70000 then 'D: Expensive Motor'
when amount  > 70000 then 'E:Very Expensive Motor'
else 'Damn motor'end;


with brands as

(select pl.productLine
from products ps
join productlines pl
on ps.productLine = pl.productLine)

select
case when productline = 'classic cars' then 'Classic cars'
when productline = 'motorcycles' then 'Motorcycles'
when productline = 'planes' then 'Planes'
when productline = 'ships' then 'Ships'
when productline = 'Train' then 'Train'
when productline = 'Trucks and buses' then 'Truck and Buses'
when productline = 'vintage cars'then 'Vintage Cars'
else 'no brand'
end Category_id,

count( productline) Number_of_brands


from brands
group by productline
order by productline asc
