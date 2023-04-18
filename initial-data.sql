USE littlelemondb;
INSERT INTO menu values
(1, "Fish and Chips", "European", "starter", 60),
(2, "Caesar Salad", "Western", "starter", 70),
(3, "Shrimp Salad", "Western", "starter", 85),
(4, "Salmon Salad", "Western", "starter", 95),
(5, "Onion Soup", "French", "starter", 55),
(6, "Lobster Bisque", "French", "starter", 90),
(7, "Classic Chowdwe", "English", "starter", 65),
(8, "Spaghetti Carbonara", "Italian", "main", 120),
(9, "Spaghetti Bolognese", "Italian", "main", 120),
(10, "Squid Ink Risotto", "Italian", "main", 140),
(11, "Marseille-Style Shrimp Stew", "French", "main", 180),
(12, "Premium Angus Ribeye Steak", "American", "main", 280),
(13, "Grilled Salmon", "Western", "main", 160),
(14, "Lemon Tea", "English", "drink", 35),
(15, "Iced Lemon Tea", "English", "drink", 35),
(16, "Latte", "Italian", "drink", 55),
(17, "Iced Latte", "Italian", "drink", 55),
(18, "Mocha", "Italian", "drink", 55),
(19, "Iced Mocha", "Italian", "drink", 55);
INSERT INTO customers(customerID, first_name, surname, phone) VALUES
(1, "LeBron", "James", "91234567"),
(2, "Steph", "Curry", "99303030"),
(3, "Kevin", "Durant", "97353535"),
(4, "Nikola", "Jokic", "60151515"),
(5, "Joel", "Embiid", "60212121"),
(6, "Anthony", "Davis", "90330303");
INSERT INTO orders values
(1, 2, 1, 1, 1),
(2, 8, 1, 1, 1),
(3, 19, 1, 1, 1),
(4, 4, 1, 2, 3),
(5, 6, 1, 2, 3),
(6, 1, 1, 3, 6),
(7, 11, 1, 3, 6),
(8, 5, 4, 4, 2),
(9, 6, 2, 5, 4);
INSERT INTO order_status_types VALUES
(1, "delivered"),
(2, "cancelled");
INSERT INTO bookings VALUES
(1, "2022-10-10", 5, 2, 1),
(2, "2022-11-12", 3, 4, 3),
(3, "2022-10-11", 2, 2, 2),
(4, "2022-10-13", 2, 2, 1);