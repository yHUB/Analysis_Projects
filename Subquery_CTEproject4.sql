/*SUBQURY*/

select avg(orders)
 from 

(select orderdate, count(ordernumber) orders
from orders
group by orderdate) t1 
where orderDate > '2005-05-30payments'; 



/*Commmon Table of Expression (CTE)*/

/*CTE1*/
WITH cte_orders AS (
    SELECT orderdate
    FROM orders
),

/*CTE2*/
cte_payments AS (
    SELECT amount, paymentdate
    FROM payments
)

/*Main query for the 2 CTEs*/
SELECT *
FROM cte_orders ;

SELECT *
FROM cte_payments;

/* Subquery*/

select *
from
(select customernumber, count(checknumber) Checknumber, avg(round(amount,0)) total
from payments
group by customerNumber) t1 
where customerNumber between 103 and 119;

select *
from 
(select productCode , min(priceeach) Price, orderLineNumber,max( quantityOrdered) Quantity_order
from orderdetails
group by productCode, orderLineNumber, quantityOrdered) w1;

select *
from
(SELECT orderNumber, productCode, SUM(quantityOrdered) AS totalQuantity, MAX(orderLineNumber) AS maxOrderLineNumber
FROM orderdetails
GROUP BY orderNumber, productCode) y3;

SELECT orderNumber,count (quantityOrdered) AS totalQuantity
FROM orderdetails
GROUP BY orderNumber;

/*CTE*/

with cte_house as
(select orderdate, count(ordernumber) orders
from orders
group by orderDate)

select avg(orders)
from cte_house
where orderdate > '200 5-05-01'