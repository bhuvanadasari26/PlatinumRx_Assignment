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
