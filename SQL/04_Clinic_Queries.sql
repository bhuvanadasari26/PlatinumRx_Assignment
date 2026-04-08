-- ===============================
-- CLINIC MANAGEMENT SYSTEM QUERIES
-- ===============================

-- Q1: Revenue from each sales channel (year 2021)
SELECT 
    sales_channel,
    SUM(amount) AS total_revenue
FROM clinic_sales
WHERE YEAR(datetime) = 2021
GROUP BY sales_channel;


-- Q2: Top 10 most valuable customers (year 2021)
SELECT 
    cs.uid,
    c.name,
    SUM(cs.amount) AS total_spent
FROM clinic_sales cs
JOIN customer c 
    ON cs.uid = c.uid
WHERE YEAR(cs.datetime) = 2021
GROUP BY cs.uid, c.name
ORDER BY total_spent DESC
LIMIT 10;


-- Q3: Month-wise revenue, expense, profit, status (year 2021)
SELECT 
    month,
    revenue,
    expense,
    (revenue - expense) AS profit,
    CASE 
        WHEN (revenue - expense) > 0 THEN 'Profitable'
        ELSE 'Not Profitable'
    END AS status
FROM (
    SELECT 
        m.month,
        COALESCE(r.revenue, 0) AS revenue,
        COALESCE(e.expense, 0) AS expense
    FROM (
        SELECT DISTINCT MONTH(datetime) AS month FROM clinic_sales
    ) m
    LEFT JOIN (
        SELECT 
            MONTH(datetime) AS month,
            SUM(amount) AS revenue
        FROM clinic_sales
        WHERE YEAR(datetime) = 2021
        GROUP BY MONTH(datetime)
    ) r ON m.month = r.month
    LEFT JOIN (
        SELECT 
            MONTH(datetime) AS month,
            SUM(amount) AS expense
        FROM expenses
        WHERE YEAR(datetime) = 2021
        GROUP BY MONTH(datetime)
    ) e ON m.month = e.month
) t;


-- Q4: Most profitable clinic per city (given month example: Jan = 1)
SELECT *
FROM (
    SELECT 
        cl.city,
        cs.cid,
        cl.clinic_name,
        SUM(cs.amount) AS revenue,
        SUM(cs.amount) - COALESCE(SUM(e.amount),0) AS profit
    FROM clinic_sales cs
    JOIN clinics cl 
        ON cs.cid = cl.cid
    LEFT JOIN expenses e 
        ON cs.cid = e.cid 
        AND MONTH(e.datetime) = 1
    WHERE MONTH(cs.datetime) = 1
    GROUP BY cl.city, cs.cid, cl.clinic_name
) t
WHERE profit = (
    SELECT MAX(profit)
    FROM (
        SELECT 
            cl.city,
            cs.cid,
            SUM(cs.amount) - COALESCE(SUM(e.amount),0) AS profit
        FROM clinic_sales cs
        JOIN clinics cl 
            ON cs.cid = cl.cid
        LEFT JOIN expenses e 
            ON cs.cid = e.cid 
            AND MONTH(e.datetime) = 1
        WHERE MONTH(cs.datetime) = 1
        GROUP BY cl.city, cs.cid
    ) x
);


-- Q5: Second least profitable clinic per state (month = Jan example)
SELECT *
FROM (
    SELECT 
        cl.state,
        cs.cid,
        cl.clinic_name,
        SUM(cs.amount) - COALESCE(SUM(e.amount),0) AS profit
    FROM clinic_sales cs
    JOIN clinics cl 
        ON cs.cid = cl.cid
    LEFT JOIN expenses e 
        ON cs.cid = e.cid 
        AND MONTH(e.datetime) = 1
    WHERE MONTH(cs.datetime) = 1
    GROUP BY cl.state, cs.cid, cl.clinic_name
) t
ORDER BY profit ASC
LIMIT 1 OFFSET 1;
