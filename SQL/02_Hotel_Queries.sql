-- ===============================
-- HOTEL MANAGEMENT SYSTEM QUERIES
-- ===============================

-- Q1: Last booked room for each user
SELECT 
    b.user_id,
    b.room_no
FROM bookings b
JOIN (
    SELECT 
        user_id, 
        MAX(booking_date) AS last_booking
    FROM bookings
    GROUP BY user_id
) t
ON b.user_id = t.user_id 
AND b.booking_date = t.last_booking;

-- Q2: Total billing for bookings in November 2021
SELECT 
    b.booking_id,
    SUM(i.item_rate * bc.item_quantity) AS total_bill
FROM bookings b
JOIN booking_commercials bc 
    ON b.booking_id = bc.booking_id
JOIN items i 
    ON bc.item_id = i.item_id
WHERE MONTH(b.booking_date) = 11 
  AND YEAR(b.booking_date) = 2021
GROUP BY b.booking_id;

-- Q3: Bills in October 2021 with amount > 1000
SELECT 
    bc.bill_id,
    SUM(i.item_rate * bc.item_quantity) AS bill_amount
FROM booking_commercials bc
JOIN items i 
    ON bc.item_id = i.item_id
WHERE MONTH(bc.bill_date) = 10 
  AND YEAR(bc.bill_date) = 2021
GROUP BY bc.bill_id
HAVING bill_amount > 1000;

-- Q4: Most and least ordered item per month in 2021

-- Total quantity per item per month
WITH item_summary AS (
    SELECT 
        MONTH(bc.bill_date) AS month,
        i.item_name,
        SUM(bc.item_quantity) AS total_qty
    FROM booking_commercials bc
    JOIN items i 
        ON bc.item_id = i.item_id
    WHERE YEAR(bc.bill_date) = 2021
    GROUP BY MONTH(bc.bill_date), i.item_name
)

-- Most ordered item
SELECT 
    month,
    item_name,
    total_qty,
    'Most Ordered' AS type
FROM item_summary
WHERE total_qty = (
    SELECT MAX(total_qty)
    FROM item_summary i2
    WHERE i2.month = item_summary.month
)

UNION ALL

-- Least ordered item
SELECT 
    month,
    item_name,
    total_qty,
    'Least Ordered' AS type
FROM item_summary
WHERE total_qty = (
    SELECT MIN(total_qty)
    FROM item_summary i2
    WHERE i2.month = item_summary.month
);

-- Q5: Customers with 2nd highest bill per month in 2021

SELECT *
FROM (
    SELECT 
        b.user_id,
        MONTH(bc.bill_date) AS month,
        SUM(i.item_rate * bc.item_quantity) AS total_bill
    FROM bookings b
    JOIN booking_commercials bc 
        ON b.booking_id = bc.booking_id
    JOIN items i 
        ON bc.item_id = i.item_id
    WHERE YEAR(bc.bill_date) = 2021
    GROUP BY b.user_id, MONTH(bc.bill_date)
) t
WHERE total_bill = (
    SELECT DISTINCT total_bill
    FROM (
        SELECT 
            SUM(i.item_rate * bc.item_quantity) AS total_bill
        FROM booking_commercials bc
        JOIN items i 
            ON bc.item_id = i.item_id
        WHERE YEAR(bc.bill_date) = 2021
        GROUP BY MONTH(bc.bill_date), bc.bill_id
        ORDER BY total_bill DESC
        LIMIT 1 OFFSET 1
    ) x
);
