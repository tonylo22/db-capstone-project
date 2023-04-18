-- ----------------------------------
-- Week 2 - "Adding Sales Reports"
-- ----------------------------------

-- USE littlelemondb;

-- ----------------------------------------
-- Part 1 (create view and read queries)
-- ----------------------------------------

-- ----------------------------------------------------------
-- task 1
CREATE VIEW OrdersView AS
SELECT o.orderID as "order_id", o.quantity as "quantity", 
o.quantity * m.price as "total_cost"
FROM orders as o JOIN menu as m
WHERE o.itemID = m.itemID;

SELECT * FROM OrdersView;  # test call
-- ----------------------------------------------------------

-- ----------------------------------------------------------
-- task 2
SELECT c.customerID as CustomerID,
CONCAT(c.first_name, " ", c.surname) as FullName,
o.orderID as OrderID,
o.quantity * m.price as TotalCost,
m.name as CourseName
FROM customers as c JOIN orders as o JOIN menu as m
WHERE o.customerID = c.customerID AND o.itemID = m.itemID AND o.quantity * m.price > 150
ORDER BY TotalCost;
-- ----------------------------------------------------------

-- ----------------------------------------------------------
-- task 3
SELECT m.name as "name"
FROM menu as m
WHERE m.itemID = ANY
(SELECT itemID FROM orders GROUP BY itemID HAVING sum(quantity) > 2);
-- ----------------------------------------------------------

-- ---------------------------------
-- End of Part 1
-- ---------------------------------

-- ----------------------------------------------------------
-- Part 2 (Create stored procedures and prepred statement)
-- ----------------------------------------------------------

-- ----------------------------------------------------------
-- task 1
DROP PROCEDURE IF EXISTS GetMaxQuantity;
CREATE PROCEDURE GetMaxQuantity()
SELECT max(quantity) as "Max Quantity in Order"  FROM orders;

Call GetMaxQuantity();  # test call
-- ----------------------------------------------------------

-- ----------------------------------------------------------
-- task 2
PREPARE GetOrderDetail FROM
'SELECT o.orderID as "Order ID", o.quantity as "Quantity", o.quantity * m.price as "Total Cost"
FROM orders as o JOIN menu as m WHERE o.itemID = m.itemID AND o.customerID = ?;';

SET @id = 1;  # test call
EXECUTE GetOrderDetail USING @id;
-- ----------------------------------------------------------

-- ----------------------------------------------------------
-- task 3
DROP PROCEDURE IF EXISTS CancelOrder;
DELIMITER //
CREATE PROCEDURE CancelOrder(IN id INT) 
BEGIN
set @hasRow = (SELECT COUNT(orderID) FROM orders WHERE orderID = id);
if @hasRow > 0 THEN
  INSERT INTO order_status(orderID, statusType, date) VALUES (id, 2, NOW());
  DELETE FROM orders WHERE orderID = id;
  SELECT CONCAT('Order ', id, ' is cancelled') as "Confirmation";
ELSE
  SELECT CONCAT('The requested order id does not exist') as "Message";
END IF;
END
//
DELIMITER ;

# test calls
call CancelOrder(9);
SELECT * FROM orders;
SELECT * FROM order_status;
-- ----------------------------------------------------------

-- ---------------------------------
-- End of Part 2
-- ---------------------------------
