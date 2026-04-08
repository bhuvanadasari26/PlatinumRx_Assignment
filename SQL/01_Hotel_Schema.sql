-- Create bookings table
CREATE TABLE bookings (
    booking_id INT,
    booking_date DATE
);

INSERT INTO bookings VALUES
(1, '2021-11-10'),
(2, '2021-11-15'),
(3, '2021-11-20');

-- Create items table
CREATE TABLE items (
    item_id INT,
    item_name VARCHAR(50),
    rate INT
);

INSERT INTO items VALUES
(1, 'Room', 500),
(2, 'Food', 200);

-- Create booking_commercials table
CREATE TABLE booking_commercials (
    booking_id INT,
    item_id INT,
    quantity INT
);

INSERT INTO booking_commercials VALUES
(1, 1, 2),
(1, 2, 3),
(2, 1, 1),
(3, 2, 5);
