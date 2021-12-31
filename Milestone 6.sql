/* DISPLAY ALL THE name of CUSTOMERS TO WHOM YOU CAN SEND TEXT EMAIL*/
SELECT concat(concat(firstname, ' '), lastname) as Customer_Name, email FROM customer WHERE email IS NOT NULL ;

/* Display all the name of customers whose order is more than $75*/
SELECT concat(concat(c.firstname, ' '), c.lastname) as Customer_Name, p.orderamount
FROM payment p
INNER JOIN orders o ON p.orderid = o.id AND p.orderamount > 75
INNER JOIN customer c on o.customerid = c.id;

/* Display the orderid, name of customers, and count of items where the cusomter orders more than 2 items*/
SELECT co.orderid, concat(concat(c.firstname, ' '), c.lastname) as Customer_Name, COUNT(co.menuid) as Count_of_Items
FROM orders o
INNER JOIN containedin co ON o.id = co.orderid
INNER JOIN customer c ON c.id = o.customerid
GROUP BY co.orderid, c.firstname, c.lastname
HAVING COUNT(co.menuid) > 2;

/* Display the names of staff whose first name ends with 'L' and has received gratituity greater than $100*/
SELECT DISTINCT concat(concat(s.firstname, ' '), s.lastname) as Staff_Name, SUM(p.amountpaid - p.orderamount) as gratituity
FROM payment p
INNER JOIN staff s ON s.id = p.staffid
WHERE s.firstname LIKE '%l' AND (p.amountpaid - p.orderamount) > 50
GROUP BY s.firstname, s.lastname;

/*Display the names and age of staff who took alcohol orders (age should be greater than 21)*/
SELECT DISTINCT concat(concat(s.firstname, ' '), s.lastname) as Staff_Name, TRUNC((SYSDATE - TO_DATE(s.dateofbirth, 'DD-MON-YYYY'))/ 365) AS AGE
FROM orders o
LEFT JOIN take t on t.orderid = o.id
LEFT JOIN staff s on s.id = t.staffid
INNER JOIN containedin co on co.orderid = o.id
INNER JOIN menu m on m.id = co.menuid AND m.categories = 'alcoholic beverages';

/*Display the names of the customer who got center tables*/
SELECT concat(concat(c.firstname, ' '), c.lastname) as Customer_Name
FROM reservation r
INNER JOIN customer c ON c.id = r.customerid
WHERE  r.status = 'success' AND r.tableid IN  (SELECT  t.id FROM  tble t WHERE  t.layout = 'center');

/*Display the customer name whose order is in progess*/
SELECT (SELECT  concat(concat(c.firstname, ' '), c.lastname) FROM customer c WHERE customerid = id) as Customer_Name, o.status
FROM orders o WHERE o.status = 'in progress';

/*Labelling name and id of staff based on the number of orders taken*/
SELECT s.id, concat(concat(s.firstname, ' '), s.lastname) as Staff_Name, CASE WHEN count(*) > 3 THEN 'HARD-WORKING' WHEN count(*) BETWEEN 1 AND 2 THEN 'AVERAGE' ELSE 'LAZY' END as Staff_Label
FROM take t
INNER JOIN staff s on s.id = t.staffid
GROUP BY s.id,s.firstname, s.lastname;

/* Display the names of the staff who took have pending orders and verfied the card payments done by visa cards*/
SELECT DISTINCT concat(concat(s.firstname, ' '), s.lastname) as Staff_Name, s.dateofbirth
FROM staff s, payment p, orders o, carddetail cd
WHERE s.id=p.staffid AND o.id=p.orderid AND cd.cardtype = 'visa'

UNION

SELECT DISTINCT concat(concat(s.firstname, ' '), s.lastname) as Staff_Name, s.dateofbirth
FROM staff s, payment p, orders o
WHERE s.id=p.staffid AND o.id=p.orderid AND o.status = 'in progress';

