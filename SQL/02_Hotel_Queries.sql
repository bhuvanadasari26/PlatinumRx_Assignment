-- ===============================
-- HOTEL MANAGEMENT SYSTEM QUERIES
-- ===============================

-- Q1: Find the latest booking
SELECT *
FROM bookings
ORDER BY booking_date DESC
LIMIT 1;


-- Q2: Calculate total billing per booking
SELECT 
    b.booking_id,
    SUM(i.rate * bc.quantity) AS total_bill
FROM bookings b
JOIN booking_commercials bc 
    ON b.booking_id = bc.booking_id
JOIN items i 
    ON bc.item_id = i.item_id
GROUP BY b.booking_id;


-- Q3: Find bookings with total bill > 1000
SELECT 
    b.booking_id,
    SUM(i.rate * bc.quantity) AS total_bill
FROM bookings b
JOIN booking_commercials bc 
    ON b.booking_id = bc.booking_id
JOIN items i 
    ON bc.item_id = i.item_id
GROUP BY b.booking_id
HAVING total_bill > 1000;


-- Q4: Find the 2nd highest bill
SELECT booking_id, total_bill
FROM (
    SELECT 
        b.booking_id,
        SUM(i.rate * bc.quantity) AS total_bill
    FROM bookings b
    JOIN booking_commercials bc 
        ON b.booking_id = bc.booking_id
    JOIN items i 
        ON bc.item_id = i.item_id
    GROUP BY b.booking_id
) t
ORDER BY total_bill DESC
LIMIT 1 OFFSET 1;
