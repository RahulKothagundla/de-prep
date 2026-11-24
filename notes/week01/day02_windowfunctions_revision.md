# Day 2 Revision: Window Functions (part 1) + LC SQL + DSA
_Tue 24 Nov 2026 · files: day02_windowfunctions.sql, lc0242, lc0125_

## 1. Core concepts

**Q1. What is a window function?**
A function that computes a value across a set of rows related to the current
row, **without collapsing rows**. Every input row stays in the output.

**Q2. GROUP BY vs window function, in row counts?**
- `GROUP BY dept` → one row per group (8 employees → 3 rows).
- `AVG(salary) OVER (PARTITION BY dept)` → all 8 rows stay, each gets its dept average.
- Proof: W6a returned 8 rows, W6b returned 3.

**Q3. The parts of OVER()?**
```sql
func() OVER (PARTITION BY <group> ORDER BY <order> <frame>)
```
- `PARTITION BY` splits rows into groups; numbering restarts in each group. Optional.
- `ORDER BY` sets the order inside each group. Ranking functions need it.
- Frame (`ROWS BETWEEN ...`): which rows around the current row are used (Wednesday).
- Empty `OVER ()` = the whole table is one window.

## 2. Ranking functions

**Q4. ROW_NUMBER vs RANK vs DENSE_RANK on 90, 80, 80, 75?**

| Function | Result | Ties |
|---|---|---|
| ROW_NUMBER() | 1, 2, 3, 4 | always unique; ties broken arbitrarily |
| RANK() | 1, 2, 2, 4 | tied rows share a rank, then a gap |
| DENSE_RANK() | 1, 2, 2, 3 | tied rows share a rank, no gap |

**Q5. Which one to use?**
- Dedupe / latest row per key / exactly N rows → **ROW_NUMBER**
- Nth highest value / top N including ties → **DENSE_RANK**
- Competition ranking (1, 2, 2, 4) → **RANK**

**Q6. Why always add a tie-breaker to ROW_NUMBER?**
With ties, the order between tied rows is not guaranteed and can change
between runs. My W2 showed Meena RN 1, Karthik RN 2 until I added `emp_id`:
```sql
ROW_NUMBER() OVER (PARTITION BY dept ORDER BY salary DESC, emp_id)
```
Rule: the ORDER BY inside OVER must make each row unique.

**Q7. Why can't a window function go in WHERE?**
Logical order of a query:
FROM → WHERE → GROUP BY → HAVING → **window functions** → SELECT → DISTINCT → ORDER BY → LIMIT.
WHERE runs before window values exist. Fix: compute in a subquery or CTE,
then filter outside:
```sql
WITH r AS (
  SELECT *, ROW_NUMBER() OVER (PARTITION BY customer_id
                               ORDER BY order_date DESC, order_id DESC) AS rn
  FROM orders
)
SELECT * FROM r WHERE rn = 1;
```
(Snowflake, BigQuery and Databricks SQL have `QUALIFY rn = 1` for this;
PostgreSQL does not.)

**Q8. Does ORDER BY inside OVER sort the output?**
No. It only orders rows for the calculation. Add a final ORDER BY to sort
the result (LC 178 asks for score DESC; my answer passed without it, but
that is luck).

## 3. Patterns from today

**Q9. Latest row per key (W3 / A4)**
ROW_NUMBER partitioned by the key, ordered newest first, keep rn = 1.
Customer 102 has two orders on the same date → `order_id DESC` breaks the tie,
so the result is always order 4.

**Q10. Nth highest per group (W4 / A3)**
DENSE_RANK partitioned by group, keep dr = N, `SELECT DISTINCT dept, salary`
so ties don't repeat the value.

**Q11. Top N per group: DENSE_RANK vs ROW_NUMBER (W5)**
- `DENSE_RANK <= 2` → 7 rows: everyone earning one of the top 2 salaries
  (Priya and Arjun both kept at 75000).
- `ROW_NUMBER <= 2` → 5 rows: exactly 2 people per dept; Arjun dropped
  although he earns the same as Priya.
- "Top 2 **salaries**" → DENSE_RANK. "Top 2 **people**" → ROW_NUMBER.

**Q12. The ROUND bug I made (W6a)**
Wrong: `ROUND(AVG(salary) OVER(PARTITION BY dept, 2))` → the 2 went inside
OVER (partition by a constant) and ROUND got no decimals.
Right: `ROUND(AVG(salary) OVER (PARTITION BY dept), 2)`.

## 4. LeetCode SQL (all solved alone)

| # | Key idea | Trap |
|---|---|---|
| 176 Second Highest Salary | `MAX(salary)` over rows where DENSE_RANK = 2 | No 2nd salary → must return one row with NULL. MAX over zero rows returns NULL. |
| 178 Rank Scores | DENSE_RANK() OVER (ORDER BY score DESC) | `rank` is reserved in some DBs → quote it; add final ORDER BY. |
| 184 Department Highest Salary | RANK() per dept, keep = 1, join Department | Ties at the top: return all of them. Partition by dept id, not name. |
| 185 Department Top Three Salaries | DENSE_RANK() per dept, keep <= 3 | "Top three salaries" = distinct values, so more than 3 people can appear. ROW_NUMBER is wrong. |

Note: subqueries without an alias only work in PostgreSQL 16+. Always alias.

## 5. DSA

| # | Approach | Time | Space |
|---|---|---|---|
| 242 Valid Anagram | `Counter(s) == Counter(t)` | O(n) | O(1) for 26 letters, O(n) for Unicode |
| 242 alt | `sorted(s) == sorted(t)` | O(n log n) | O(n) |
| 125 Valid Palindrome | two pointers, skip non-alphanumeric in place, compare lowercase | O(n) | O(1) |
| 125 alt | filter to a new string, compare with reverse | O(n) | O(n) |

Why 125 is O(1): no new string is built; only two index variables.

## 6. Self-check (answer out loud, no notes)
1. GROUP BY vs window function, in row counts?
2. ROW_NUMBER, RANK, DENSE_RANK on 90, 80, 80, 75?
3. Why does W3 need `order_id DESC`?
4. Which function answers "top 3 salaries per department", and why not ROW_NUMBER?
5. Why can't a window function go in WHERE, and what's the fix?
6. Why is the two-pointer palindrome O(1) space?
