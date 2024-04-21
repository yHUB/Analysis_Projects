select t1.customername, max(t2.amount)  Highestamount
from customers  t1
left join payments t2
on t1.customerNumber = t2.customernumber
group by t1.customerName;

/* Question 1 */

select t2.customername, count(t1.ordernumber) Maxorder
from orders t1
 join customers t2 
on t1.customerNumber = t2.customerNumber
group by t2.customerName
order by Maxorder desc;

/* Qestion 2 */

select t2.customername, min(orderDate) Firstorderdate, max(orderDate) Lastorderdate
from orders t1
inner join customers t2 
on t1.customerNumber = t2.customerNumber
group by t2.customerName;
