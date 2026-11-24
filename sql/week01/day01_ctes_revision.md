/* =====================================================================
   CTE REVISION NOTES (Day 1, 23 Nov)
   =====================================================================

Q1. What is a CTE?
A.  A named, temporary result set defined with WITH, that exists only
    for the one statement that follows it.
    WITH t AS (SELECT ...) SELECT ... FROM t;

Q2. Why does a CTE disappear after one statement? What if I need it again?
A.  It is part of that single statement, not stored in the database.
    To reuse a result: a VIEW (saved query, permanent) or a TEMP TABLE
    (stores data for the session, can be indexed).

Q3. CTE vs subquery vs view vs temp table?
A.  Subquery   : inside one query, no storage    -> small, used once
    CTE        : one statement, no storage       -> readable steps, recursion
    View       : permanent until dropped, saved query, no data stored
                 -> same logic reused by many queries
    Temp table : session lifetime, stores data, can be indexed
                 -> expensive result reused many times

Q4. How do you chain several CTEs? Common mistakes?
A.  One WITH, CTEs separated by commas; a later CTE can read an earlier one.
    WITH a AS (...), b AS (SELECT ... FROM a) SELECT ... FROM b;
    Mistakes: writing WITH twice; a comma after the last CTE.

Q5. Three parts of a recursive CTE, and what makes it stop?
A.  1) Anchor: starting rows (e.g. employees with manager_id IS NULL)
    2) UNION ALL
    3) Recursive member: joins the table back to the CTE for the next level
    It stops when the recursive member returns no new rows.
    PostgreSQL/MySQL need WITH RECURSIVE; SQL Server uses plain WITH.

Q6. How do you protect a recursive CTE from looping forever?
A.  Cyclic data (A manages B, B manages A) never stops. Add a depth limit
    (WHERE level < 10). SQL Server: OPTION (MAXRECURSION n), default 100.
    PostgreSQL 14+ also has a CYCLE clause.

Q7. Is a CTE faster than a subquery?
A.  Not by itself; it mainly helps readability. In PostgreSQL 12+, a simple
    non-recursive CTE used once is usually inlined into the main query,
    so it performs like a subquery. You can force it with
    AS MATERIALIZED / AS NOT MATERIALIZED. Before PG 12, CTEs were always
    computed separately first (an "optimization fence").

Q8. When would you choose a temp table over a CTE?
A.  When the result is expensive and reused across several queries,
    or when it is large and needs an index.

Q9. Three ways to find rows with no match (anti-join)?
A.  LEFT JOIN ... WHERE right.key IS NULL
    NOT EXISTS (SELECT 1 FROM right WHERE right.key = left.key)
    NOT IN (SELECT key FROM right)
    Test a column that is never NULL when a match exists (the key),
    not a nullable column like amount.

Q10. Why can NOT IN return no rows at all?
A.  If the subquery returns even one NULL, "x NOT IN (..., NULL)" is never
    TRUE (it becomes UNKNOWN), so every row is filtered out.
    Prefer NOT EXISTS; or add WHERE key IS NOT NULL inside the subquery.

Q11. E2: why does customer 103 drop out?
A.  Its only order has amount NULL, so SUM gives NULL. AVG ignores NULLs
    (average of 950 and 900 = 925), and NULL > 925 is UNKNOWN, not TRUE,
    so 103 is excluded from both.

Q12. Can a CTE be used with INSERT, UPDATE or DELETE?
A.  Yes. WITH ... can precede them, and in PostgreSQL the CTE itself can
    modify data (WITH deleted AS (DELETE ... RETURNING *) ...).

===================================================================== */