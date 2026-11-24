-- Day 2 (Tue 24 Nov): Window functions

\echo '--- W1: company-wide ROW_NUMBER / RANK / DENSE_RANK by salary ---'

SELECT name, 
    ROW_NUMBER() OVER(ORDER BY salary DESC, emp_id) as RN,
    RANK() OVER(ORDER BY salary DESC) as Rank,
    DENSE_RANK() OVER(ORDER BY salary DESC) as Dense_Rank
FROM employees;


\echo '--- W2: same, PARTITION BY dept ---'

SELECT name, 
    ROW_NUMBER() OVER(PARTITION BY dept ORDER BY salary DESC, emp_id) as RN,
    RANK() OVER(PARTITION BY dept ORDER BY salary DESC) as Rank,
    DENSE_RANK() OVER(PARTITION BY dept ORDER BY salary DESC) as Dense_Rank
FROM employees;


\echo '--- W3 (A4 rewrite): latest order per customer ---'

--- order_id DESC is needed to rectify the tie reak for customer_id 102 as it has the order on same date

SELECT *
FROM (
    SELECT *,
    ROW_NUMBER() OVER(PARTITION BY customer_id ORDER BY order_date DESC, order_id DESC) as RN
    FROM orders
) temp
WHERE RN = 1;


\echo '--- W4 (A3 redo): second-highest distinct salary per dept, DENSE_RANK ---'

SELECT DISTINCT dept, salary
FROM (
    SELECT *,
    DENSE_RANK() OVER(PARTITION BY dept ORDER BY salary DESC) as dr
    FROM employees
) temp
WHERE dr = 2;


\echo '--- W5a: top 2 per dept, DENSE_RANK <= 2 ---'
--- keeps ties at the same rank for dense rank

SELECT *
FROM (
    SELECT *,
    DENSE_RANK() OVER(PARTITION BY dept ORDER BY salary DESC) as RN
    FROM employees
) temp
WHERE RN <= 2;


\echo '--- W5b: top 2 per dept, ROW_NUMBER <= 2 ---'
--- assigns unique row numbers for row number
--- DENSE_RANK answers 'top 2 salaries', 
--- because tied people share a rank, so everyone earning one of the 
--- two highest salaries is kept. ROW_NUMBER keeps exactly 2 people 
--- and drops ties arbitrarily (Arjun is cut although he earns the same as Priya).

SELECT *
FROM (
    SELECT *,
    ROW_NUMBER() OVER(PARTITION BY dept ORDER BY salary DESC, emp_id) as RN
    FROM employees
) temp
WHERE RN <= 2;


\echo '--- W6a: dept average beside each employee (AVG OVER) ---'

SELECT *,
    ROUND(AVG(salary) OVER(PARTITION BY dept), 2) as dept_average
FROM employees;


\echo '--- W6b: GROUP BY version, compare row counts ---'

SELECT
    dept,
    ROUND(AVG(salary), 2) AS dept_average
FROM employees
GROUP BY dept;












