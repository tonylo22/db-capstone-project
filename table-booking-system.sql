-- ---------------------------------
-- Week 2 - "Table Booking System"
-- ---------------------------------

-- USE littlelemondb;

-- ---------------------------------
-- Part 1 (CheckBooking, AddValidBooking)
-- ---------------------------------

-- ----------------------------------------------------------
-- task 1 (in initial-data.sql)
-- ----------------------------------------------------------

-- ----------------------------------------------------------
-- task 2
DROP PROCEDURE IF EXISTS CheckBooking;
DELIMITER //
CREATE PROCEDURE CheckBooking(IN bookingDate DATE, IN tableNumber INT)
BEGIN
SELECT COUNT(bookingID) INTO @bookingCount FROM bookings
WHERE DATE(date) = bookingDate AND table_no = tableNumber;
IF @bookingCount > 0 THEN
  SELECT CONCAT("Table ", tableNumber, " is already booked") AS "Booking Status";
ELSE
  SELECT CONCAT("Table ", tableNumber, " is open for booking") AS "Booking Status";
END IF;
END //
DELIMITER ;

call CheckBooking("2022-11-12", 3);  # test call
-- ----------------------------------------------------------

-- ----------------------------------------------------------
-- task 3
-- Note: the procedure contains more parameters than in the instructions 
-- because my table has different columns which are set to not null

DROP PROCEDURE IF EXISTS AddValidBooking;
DELIMITER //
CREATE PROCEDURE AddValidBooking(IN bookingDate DATE, IN tableNumber INT, IN numberOfPersons INT, IN customer_id INT)
avb: BEGIN
-- check if customer has been registered, if not than do not add booking
SELECT COUNT(customerID) INTO @customerCount FROM customers
WHERE customerID = customer_id;
IF @customerCount = 0 THEN
  SELECT CONCAT("No record for this customer, please register new customer first") AS "Booking Status";
  LEAVE avb;
END IF;
-- enable rollback for insert
SET autocommit = 0;
START TRANSACTION;
-- inert new boking record
INSERT INTO bookings(date, table_no, persons, customerID) VALUES 
(bookingDate, tableNumber, numberOfPersons,  customer_id);
-- check duplicate bookings, store finding in variable
SELECT COUNT(bookingID) INTO @bookingCount FROM bookings
WHERE DATE(date) = bookingDate AND table_no = tableNumber;
-- determine if booking is valid
IF @bookingCount > 1 THEN
  ROLLBACK;
  SELECT CONCAT("Table ", tableNumber, " is already booked, booking cancelled") AS "Booking Status";
ELSE
  COMMIT;
  SELECT CONCAT("Table ", tableNumber, " is booked successfully") AS "Booking Status";
END IF;
SET autocommit = 1;
END //
DELIMITER ;

# test calls
call AddValidBooking("2022-12-17", 6, 4, 1);
call AddValidBooking("2022-11-14", 3, 4, 1);
call AddValidBooking("2022-11-12", 1, 4, 20);
-- ----------------------------------------------------------

-- ---------------------------------
-- End of Part 1
-- ---------------------------------

-- ---------------------------------
-- Part 2 (AddBooking, UpdateBooking, CancelBooking)
-- ---------------------------------

-- ----------------------------------------------------------
-- task 1
-- Note: same as above, more parameters than instructed due to more columns

DROP PROCEDURE IF EXISTS AddBooking;
DELIMITER //
CREATE PROCEDURE AddBooking(IN booking_id INT, IN bookingDate DATE, IN tableNumber INT, IN numberOfPersons INT, IN customer_id INT)
BEGIN
-- check if customer has registered, store finding in variable
SELECT COUNT(customerID) INTO @customerCount FROM customers
WHERE customerID = customer_id;
-- check duplicate bookings, store finding in variable
SELECT COUNT(bookingID) INTO @bookingCount FROM bookings
WHERE DATE(date) = bookingDate AND table_no = tableNumber;
-- check duplicate booking_id, store finding in variable
SELECT COUNT(bookingID) INTO @bookingIdCount FROM bookings WHERE bookingID = booking_id;
-- determine if booking is valid
IF @customerCount = 0 THEN
  SELECT CONCAT("No record for this customer, please register new customer first") AS "Booking Status";
ELSEIF @bookingCount > 0 THEN
  SELECT CONCAT("Table ", tableNumber, " is already booked") AS "Booking Status";
ELSEIF @bookingIdCount > 0 THEN
  SELECT CONCAT("Booking ID already exists") AS "Booking Status";
ELSE
  INSERT INTO bookings(bookingID, date, table_no, persons, customerID) VALUES 
  (booking_id, bookingDate, tableNumber, numberOfPersons,  customer_id);
  SELECT CONCAT("New booking added") AS "Confirmation";
END IF;
END //
DELIMITER ;

# test calls
call AddBooking(6, "2022-12-17", 4, 4, 1);
call AddBooking(7, "2022-11-15", 3, 4, 1);
-- ----------------------------------------------------------

-- ----------------------------------------------------------
-- task 2
DROP PROCEDURE IF EXISTS UpdateBooking;
DELIMITER //
CREATE PROCEDURE UpdateBooking(IN booking_id INT, IN bookingDate DATE)
ub: BEGIN
-- exit if booking_id does not exist
SELECT COUNT(bookingID) INTO @bookingIdCount FROM bookings WHERE bookingID = booking_id;
IF @bookingIdCount = 0 THEN
  SELECT CONCAT("Booking ID does not exist") AS "Booking Status";
  LEAVE ub;
END IF;
-- store the table number of the given booking_id in variable
SELECT table_no INTO @tn FROM bookings WHERE bookingID = booking_id;
-- check duplicate bookings, store finding in variable
SELECT COUNT(bookingID) INTO @bookingCount FROM bookings
WHERE DATE(date) = bookingDate AND table_no = @tn;
-- determine if booking is valid
IF @bookingCount > 0 THEN
  SELECT CONCAT("Table ", @tn, " is already booked on the given date") AS "Booking Status";
ELSE
  Update bookings SET date = bookingDate WHERE bookingID = booking_id;
  SELECT CONCAT("Booking ", booking_id, " updated") AS "Confirmation";
END IF;
END //
DELIMITER ;

call UpdateBooking(3, "2022-10-11");  # test call
call UpdateBooking(3, "2022-10-17");  # test call
-- ----------------------------------------------------------

-- ----------------------------------------------------------
-- task 3
DROP PROCEDURE IF EXISTS CancelBooking;
DELIMITER //
CREATE PROCEDURE CancelBooking(IN booking_id INT)
BEGIN
SELECT COUNT(bookingID) INTO @bookingIdCount FROM bookings WHERE bookingID = booking_id;
IF @bookingIdCount > 0 THEN
  DELETE FROM bookings WHERE bookingID = booking_id;
  SELECT CONCAT("Booking ", booking_id, " cancelled") AS "Booking Status";
ELSE
  SELECT CONCAT("Booking ID does not exist") AS "Booking Status";
END IF;
END //
DELIMITER ;

call CancelBooking(1);  # test call
call CancelBooking(100);  # test call
-- INSERT INTO bookings VALUES(1, "2022-10-10", 5, 2, 1);  # restore the deleted row in test call
-- ----------------------------------------------------------

-- ---------------------------------
-- End of Part 2
-- ---------------------------------