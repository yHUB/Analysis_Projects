

select * from (
select distinct t3.customername,
t1.customernumber,
t1.ordernumber, 
orderdate, 
productcode,

row_number() over(partition by t3.customernumber, t1.orderNumber order by orderdate) as purchase_number

from orders t1
join orderdetails t2 
on t1.orderNumber = t2.ordernumber
join customers t3 on t1.customerNumber = t3.customernumber
) sales
where purchase_number =5
order by sales.customerName; 


select distinct productCode,
productName,
t1.productvendor,
t1.productLine,
row_number () over(partition by t1.productvendor order by t2.productline) as Numbers
from products t1
join productlines t2
on t1.productLine = t2.productline;


select checknumber,
c.customerName,
amount,
c.customernumber,

row_number () over (partition by c.customernumber order by p.amount) Rownummber
from payments p
join customers c on p.customernumber = c.customernumber;


with cte_check as(
select distinct e.officeCode,
employeenumber,
firstName,
lastName, 

row_number () over (partition by e.employeenumber order by e.jobtitle) row_num
from employees e
join offices o on e.officeCode = o.officeCode)

select *
from cte_check
where officecode = 1

