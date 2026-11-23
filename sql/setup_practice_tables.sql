DROP TABLE IF EXISTS orders, customers, employees;

CREATE TABLE employees (emp_id INT PRIMARY KEY, name TEXT, dept TEXT, salary INT, manager_id INT);
INSERT INTO employees VALUES
 (1,'Rahul','Data',90000,NULL),(2,'Priya','Data',75000,1),(3,'Arjun','Data',75000,1),
 (4,'Sneha','Data',60000,1),(5,'Karthik','Sales',80000,NULL),(6,'Meena','Sales',80000,5),
 (7,'Vikram','Sales',50000,5),(8,'Divya','HR',45000,NULL);

CREATE TABLE customers (customer_id INT PRIMARY KEY, name TEXT, city TEXT);
INSERT INTO customers VALUES
 (101,'Asha','Hyderabad'),(102,'Ravi','Chennai'),(103,'Neha','Bangalore'),(104,'Kiran','Hyderabad');

CREATE TABLE orders (order_id INT PRIMARY KEY, customer_id INT, order_date DATE, amount NUMERIC);
INSERT INTO orders VALUES
 (1,101,'2026-11-01',500),(2,101,'2026-11-05',300),(3,102,'2026-11-02',700),
 (4,102,'2026-11-02',200),(5,103,'2026-11-07',NULL),(6,101,'2026-11-09',150);
 