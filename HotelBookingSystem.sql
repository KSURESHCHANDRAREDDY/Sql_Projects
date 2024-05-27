--Hotel Booking System Project By: 217Y1A3354,217Y1A3340,217Y1A3344

--Database
CREATE DATABASE HotelBookingSystem;
GO

USE HotelBookingSystem;
GO

--Tables

----Hotels Table
CREATE TABLE hotels (
    hotel_id INT PRIMARY KEY,
    name NVARCHAR(100),
    location NVARCHAR(100),
    rating DECIMAL(2, 1),
    total_rooms INT
);
GO

--Rooms Table
CREATE TABLE rooms (
    room_id INT PRIMARY KEY,
    hotel_id INT,
    room_type NVARCHAR(50),
    price_per_night DECIMAL(10, 2),
    available_rooms INT,
    FOREIGN KEY (hotel_id) REFERENCES hotels(hotel_id)
);
GO

--Customers Table
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    first_name NVARCHAR(50),
    last_name NVARCHAR(50),
    email NVARCHAR(100),
    phone NVARCHAR(15)
);
GO

--Booking Table
CREATE TABLE bookings (
    booking_id INT PRIMARY KEY,
    customer_id INT,
    room_id INT,
    check_in DATE,
    check_out DATE,
    status NVARCHAR(20),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (room_id) REFERENCES rooms(room_id)
);
GO

--Payment Table
CREATE TABLE payments (
    payment_id INT PRIMARY KEY,
    booking_id INT,
    amount DECIMAL(10, 2),
    payment_date DATE,
    payment_method NVARCHAR(50),
    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id)
);
GO

--Stored Procedures To Add Data Into Tables

--Stored Procedure for Customers
CREATE PROCEDURE InsertCustomer (
    @customer_id INT,
    @first_name NVARCHAR(50),
    @last_name NVARCHAR(50),
    @email NVARCHAR(100),
    @phone NVARCHAR(15)
)
AS
BEGIN
    INSERT INTO customers (customer_id ,first_name, last_name, email, phone) 
    VALUES (@customer_id ,@first_name, @last_name, @email, @phone);
END;
GO

--Stored Procedure for Booking
CREATE PROCEDURE MakeBooking (
    @booking_id INT,
    @customer_id INT,
    @room_id INT,
    @check_in DATE,
    @check_out DATE
)
AS
BEGIN
    BEGIN TRY
        DECLARE @available INT;
        
        -- Checking if the room is available
        SELECT @available = available_rooms FROM rooms WHERE room_id = @room_id;
        
        IF @available > 0
        BEGIN
            -- Inserting into the booking record
            INSERT INTO bookings (booking_id,customer_id, room_id, check_in, check_out, status) 
            VALUES (@booking_id,@customer_id, @room_id, @check_in, @check_out, 'Confirmed');
            
            -- Decreaseing the number of available rooms
            UPDATE rooms SET available_rooms = available_rooms - 1 WHERE room_id = @room_id;
        END
        ELSE
        BEGIN
            RAISERROR ('No available rooms', 20, 1);
        END
    END TRY
    BEGIN CATCH
        -- Handle the error
        DECLARE @ErrorMessage NVARCHAR(4000);
        DECLARE @ErrorSeverity INT;
        DECLARE @ErrorState INT;
        
        SELECT 
            @ErrorMessage = ERROR_MESSAGE(),
            @ErrorSeverity = ERROR_SEVERITY(),
            @ErrorState = ERROR_STATE();
        
        PRINT 'Error: ' + @ErrorMessage;
    END CATCH
END;
GO

--Stored Procedure for payments
CREATE PROCEDURE AddPayment (
    @payment_id INT,
    @booking_id INT,
    @amount DECIMAL(10, 2),
    @payment_date DATE,
    @payment_method NVARCHAR(50)
)
AS
BEGIN
    INSERT INTO payments (payment_id,booking_id, amount, payment_date, payment_method) 
    VALUES (@payment_id,@booking_id, @amount, @payment_date, @payment_method);
END;
GO

--Inserting Sample Data
--Hotels Data
INSERT INTO hotels (hotel_id, name, location, rating, total_rooms) VALUES
(1, 'Taj Mahal Palace', 'Mumbai, India', 4.7, 300),
(2, 'The Leela Palace', 'New Delhi, India', 4.8, 250),
(3, 'ITC Grand Chola', 'Chennai, India', 4.6, 400);
GO

--Rooms
INSERT INTO rooms (room_id, hotel_id, room_type, price_per_night, available_rooms) VALUES
(1, 1, 'Standard', 150.00, 100),
(2, 1, 'Deluxe', 200.00, 100),
(3, 2, 'Executive Suite', 400.00, 50),
(4, 3, 'Presidential Suite', 800.00, 200);
GO

--Customers Data
EXEC InsertCustomer 1,'Rahul', 'Sharma', 'rahul.sharma@example.com', '987-654-3210';
EXEC InsertCustomer 2,'Priya', 'Patel', 'priya.patel@example.com', '876-543-2109';
EXEC InsertCustomer 3,'Aarav', 'Singh', 'aarav.singh@example.com', '123-456-7890';
EXEC InsertCustomer 4,'Aaradhya', 'Kaur', 'aaradhya.kaur@example.com', '234-567-8901';
EXEC InsertCustomer 5,'Aarav', 'Patel', 'aarav.patel@example.com', '345-678-9012';
EXEC InsertCustomer 6,'Advait', 'Shah', 'advait.shah@example.com', '456-789-0123';
EXEC InsertCustomer 7,'Ishaan', 'Kumar', 'ishaan.kumar@example.com', '567-890-1234';
EXEC InsertCustomer 8,'Ananya', 'Gupta', 'ananya.gupta@example.com', '678-901-2345';
EXEC InsertCustomer 9,'Saanvi', 'Deshpande', 'saanvi.deshpande@example.com', '789-012-3456';
EXEC InsertCustomer 10,'Reyansh', 'Malhotra', 'reyansh.malhotra@example.com', '890-123-4567';
EXEC InsertCustomer 11,'Advika', 'Verma', 'advika.verma@example.com', '901-234-5678';
EXEC InsertCustomer 12,'Kabir', 'Srivastava', 'kabir.srivastava@example.com', '012-345-6789';
GO

-- Bookings
EXEC MakeBooking 1,1, 1, '2024-06-15', '2024-06-20';
EXEC MakeBooking 2,2, 2, '2024-07-10', '2024-07-15';
EXEC MakeBooking 3,3, 3, '2024-08-05', '2024-08-10';
EXEC MakeBooking 4,4, 4, '2024-09-01', '2024-09-05';
EXEC MakeBooking 5,5, 1, '2024-09-20', '2024-09-25';
EXEC MakeBooking 6,6, 2, '2024-10-15', '2024-10-20';
EXEC MakeBooking 7,7, 3, '2024-11-10', '2024-11-15';
EXEC MakeBooking 8,8, 4, '2024-12-05', '2024-12-10';
EXEC MakeBooking 9,9, 1, '2025-01-01', '2025-01-05';
EXEC MakeBooking 10,10, 2, '2025-02-01', '2025-02-05';

--Payments
EXEC AddPayment 1,1, 750.00, '2024-06-10', 'Credit Card';
EXEC AddPayment 2,2, 900.00, '2024-07-05', 'Debit Card';
EXEC AddPayment 3,3, 1100.00, '2024-07-30', 'Cash';
EXEC AddPayment 4,4, 850.00, '2024-09-05', 'Credit Card';
EXEC AddPayment 5,5, 1000.00, '2024-09-18', 'Debit Card';
EXEC AddPayment 6,6, 1200.00, '2024-10-10', 'Cash';
EXEC AddPayment 7,7, 950.00, '2024-11-05', 'Credit Card';
EXEC AddPayment 8,8, 1050.00, '2024-12-01', 'Debit Card';
EXEC AddPayment 9,9, 1150.00, '2025-01-10', 'Cash';
EXEC AddPayment 10,10, 1250.00, '2025-02-01', 'Credit Card';

-- Retrieve all hotels
SELECT * FROM hotels;
GO

-- Retrieve all rooms for a specific hotel
SELECT * FROM rooms WHERE hotel_id = 1;
GO

-- Retrieve all bookings for a specific customer
SELECT * FROM bookings WHERE customer_id = 1;
GO

-- Retrieve all payments made for a specific booking
SELECT * FROM payments WHERE booking_id = 1;
GO