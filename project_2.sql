-- select * 
-- from employees
-- whea left join customers t2
-- on t1.employeeNumber = t2.salesRepEmployeeNumber

-- select customerName, contactLastName,  amount, paymentDate
-- from customers t1
-- left join payments t2 
-- on t1.customerNumber = t2.customerNumber

/* Question 1*/
select t1.contactfirstname, t1.contactlastname, t2.orderdate, t2.status
from customers t1
 join orders t2
on t1.customerNumber = t2.customerNumber;

/*Question 2*/
select contactfirstname, contactlastname, ordernumber, orderdate
from customers t1
left join orders t2
on t1.customerNumber = t2.customerNumber
