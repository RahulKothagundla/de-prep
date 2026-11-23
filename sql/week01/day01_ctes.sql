-- Day 1 (Mon 23 Nov): CTEs

\echo '--- A1: departments with avg salary > 50000 ---'
SELECT dept, COUNT(*) as employee_count, AVG(salary) AS avg_salary
FROM employees
GROUP BY dept
HAVING AVG(salary) > 50000;


\echo '--- A1 (CTE version) ---'
WITH SalaryCTE AS (
    SELECT dept,COUNT(*) as employee_count, AVG(salary) AS avg_salary
    FROM employees
    GROUP BY dept
)
SELECT * 
FROM SalaryCTE
WHERE avg_salary > 50000;


\echo '--- A2: customers who never ordered ---'

WITH distinct_customers AS(
    SELECT DISTINCT(customer_id) as unique_customer_id
    FROM orders
)
SELECT * 
FROM customers c
WHERE NOT EXISTS(
    SELECT 1
    FROM distinct_customers d
    WHERE d.unique_customer_id = c.customer_id
);


\echo '--- A3: second-highest distinct salary per dept (CTE with MAX) ---'


WITH maximum_salaries_per_dept AS (
    SELECT dept, MAX(salary) as max_salary
    FROM employees
    GROUP BY dept
)
SELECT e.dept, MAX(e.salary)
FROM employees e
JOIN maximum_salaries_per_dept m
ON e.dept = m.dept
WHERE e.salary < m.max_salary
GROUP BY e.dept;


\echo '--- E1: employees above their dept average ---'

WITH average_salary_per_dept AS (
    SELECT dept, AVG(salary) as avg_salary
    FROM employees
    GROUP BY dept
)
SELECT e.name, e.dept
FROM employees e
JOIN average_salary_per_dept a
ON e.dept = a.dept
WHERE e.salary > a.avg_salary;


\echo '--- E2: customers above the average customer total ---'

WITH total_order_amount_per_customer AS(
    SELECT customer_id, SUM(amount) as total
    FROM orders
    GROUP BY customer_id
),
average_totals AS(
    SELECT AVG(total) as avg_total
    FROM total_order_amount_per_customer
)
SELECT t.customer_id
FROM total_order_amount_per_customer t
CROSS JOIN average_totals a
WHERE t.total > a.avg_total;


\echo '--- E3: recursive hierarchy: level + top manager ---'


WITH RECURSIVE manager_levels AS(
    SELECT emp_id, name, manager_id, 1 as level, name AS top_manager
    FROM employees
    WHERE manager_id IS NULL

    UNION ALL

    SELECT e.emp_id, e.name, e.manager_id, m.level + 1, m.top_manager
    FROM employees e
    JOIN manager_levels m
    ON e.manager_id = m.emp_id
)
SELECT emp_id, name, top_manager, level
FROM manager_levels;



\echo '--- E4: recursive date series, 1-9 Nov, daily sales with 0s ---'

WITH RECURSIVE sale_per_day AS(
    SELECT DATE '2026-11-01' as dt

    UNION ALL

    SELECT dt + 1
    FROM sale_per_day
    WHERE dt < DATE '2026-11-09'
)
SELECT s.dt as order_date, COALESCE(SUM(o.amount), 0) as daily_sales
FROM sale_per_day s
LEFT JOIN  orders o
ON o.order_date = s.dt
GROUP BY s.dt
ORDER BY s.dt;
















