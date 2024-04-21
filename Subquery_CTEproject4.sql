select count(orderdate)
from

(select orderdate, count(orderdate) ord 
from orders
group by orderdate) t1 