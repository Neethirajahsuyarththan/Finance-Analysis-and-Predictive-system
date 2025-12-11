CREATE DATABASE therapy_center;



CREATE TABLE customers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    unique_id VARCHAR(20) UNIQUE NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(20),
    address TEXT,
    registration_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    status ENUM('active', 'inactive') DEFAULT 'active'
);

CREATE TABLE payments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    payment_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    payment_method ENUM('cash', 'card', 'bank_transfer'),
    notes TEXT,
    FOREIGN KEY (customer_id) REFERENCES customers(id)
);

CREATE TABLE employees (
    id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(20),
    position VARCHAR(50),
    hire_date DATE,
    status ENUM('active', 'inactive') DEFAULT 'active'
);

CREATE TABLE admin (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    last_login DATETIME
);

CREATE TABLE employee_salaries (
    id INT AUTO_INCREMENT PRIMARY KEY,
    employee_id INT NOT NULL,
    basic_salary DECIMAL(10,2) NOT NULL,
    allowances DECIMAL(10,2) DEFAULT 0,
    deductions DECIMAL(10,2) DEFAULT 0,
    payment_date DATE NOT NULL,
    payment_method ENUM('cash', 'bank_transfer', 'check') NOT NULL,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (employee_id) REFERENCES employees(id)
);

CREATE TABLE expenses (
    id INT AUTO_INCREMENT PRIMARY KEY,
    expense_date DATE NOT NULL,
    category VARCHAR(50) NOT NULL,
    description TEXT,
    amount DECIMAL(10,2) NOT NULL,
    payment_method ENUM('cash', 'bank_transfer', 'check', 'credit_card') NOT NULL,
    receipt_number VARCHAR(50),
    recorded_by VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);









































































































INSERT INTO customers (unique_id, first_name, last_name, email, phone, address, status) VALUES
('CUST001', 'John', 'Smith', 'john.smith@example.com', '555-0101', '123 Main St, Anytown, USA', 'active'),
('CUST002', 'Emily', 'Johnson', 'emily.johnson@example.com', '555-0102', '456 Oak Ave, Somewhere, USA', 'active'),
('CUST003', 'Michael', 'Williams', 'michael.williams@example.com', '555-0103', '789 Pine Rd, Nowhere, USA', 'active'),
('CUST004', 'Sarah', 'Brown', 'sarah.brown@example.com', '555-0104', '321 Elm St, Anywhere, USA', 'active'),
('CUST005', 'David', 'Jones', 'david.jones@example.com', '555-0105', '654 Maple Dr, Everywhere, USA', 'active'),
('CUST006', 'Jennifer', 'Garcia', 'jennifer.garcia@example.com', '555-0106', '987 Cedar Ln, Somewhere, USA', 'active'),
('CUST007', 'Robert', 'Miller', 'robert.miller@example.com', '555-0107', '135 Birch Blvd, Nowhere, USA', 'active'),
('CUST008', 'Lisa', 'Davis', 'lisa.davis@example.com', '555-0108', '246 Walnut Ct, Anywhere, USA', 'active'),
('CUST009', 'Thomas', 'Rodriguez', 'thomas.rodriguez@example.com', '555-0109', '369 Spruce Way, Everywhere, USA', 'active'),
('CUST010', 'Jessica', 'Martinez', 'jessica.martinez@example.com', '555-0110', '482 Cherry St, Somewhere, USA', 'active'),
('CUST011', 'Daniel', 'Hernandez', 'daniel.hernandez@example.com', '555-0111', '591 Aspen Ave, Nowhere, USA', 'active'),
('CUST012', 'Karen', 'Lopez', 'karen.lopez@example.com', '555-0112', '624 Poplar Rd, Anywhere, USA', 'active'),
('CUST013', 'William', 'Gonzalez', 'william.gonzalez@example.com', '555-0113', '753 Redwood Dr, Everywhere, USA', 'active'),
('CUST014', 'Nancy', 'Wilson', 'nancy.wilson@example.com', '555-0114', '864 Sycamore Ln, Somewhere, USA', 'active'),
('CUST015', 'James', 'Anderson', 'james.anderson@example.com', '555-0115', '975 Magnolia Blvd, Nowhere, USA', 'active'),
('CUST016', 'Margaret', 'Thomas', 'margaret.thomas@example.com', '555-0116', '108 Palm Ct, Anywhere, USA', 'active'),
('CUST017', 'Joseph', 'Taylor', 'joseph.taylor@example.com', '555-0117', '219 Dogwood Way, Everywhere, USA', 'active'),
('CUST018', 'Betty', 'Moore', 'betty.moore@example.com', '555-0118', '320 Willow St, Somewhere, USA', 'active'),
('CUST019', 'Charles', 'Jackson', 'charles.jackson@example.com', '555-0119', '431 Juniper Ave, Nowhere, USA', 'active'),
('CUST020', 'Dorothy', 'Martin', 'dorothy.martin@example.com', '555-0120', '542 Sequoia Rd, Anywhere, USA', 'active'),
('CUST021', 'Christopher', 'Lee', 'christopher.lee@example.com', '555-0121', '653 Cypress Dr, Everywhere, USA', 'active'),
('CUST022', 'Sandra', 'Perez', 'sandra.perez@example.com', '555-0122', '764 Hemlock Ln, Somewhere, USA', 'active'),
('CUST023', 'Matthew', 'Thompson', 'matthew.thompson@example.com', '555-0123', '875 Fir Blvd, Nowhere, USA', 'active'),
('CUST024', 'Ashley', 'White', 'ashley.white@example.com', '555-0124', '986 Spruce Ct, Anywhere, USA', 'active'),
('CUST025', 'Donald', 'Harris', 'donald.harris@example.com', '555-0125', '197 Pine Way, Everywhere, USA', 'active'),
('CUST026', 'Kimberly', 'Sanchez', 'kimberly.sanchez@example.com', '555-0126', '208 Oak St, Somewhere, USA', 'active'),
('CUST027', 'Paul', 'Clark', 'paul.clark@example.com', '555-0127', '319 Maple Ave, Nowhere, USA', 'active'),
('CUST028', 'Donna', 'Ramirez', 'donna.ramirez@example.com', '555-0128', '420 Elm Rd, Anywhere, USA', 'active'),
('CUST029', 'Mark', 'Lewis', 'mark.lewis@example.com', '555-0129', '531 Cedar Dr, Everywhere, USA', 'active'),
('CUST030', 'Michelle', 'Robinson', 'michelle.robinson@example.com', '555-0130', '642 Birch Ln, Somewhere, USA', 'active'),
('CUST031', 'Steven', 'Walker', 'steven.walker@example.com', '555-0131', '753 Walnut Blvd, Nowhere, USA', 'active'),
('CUST032', 'Carol', 'Young', 'carol.young@example.com', '555-0132', '864 Cherry Ct, Anywhere, USA', 'active'),
('CUST033', 'Andrew', 'Allen', 'andrew.allen@example.com', '555-0133', '975 Aspen Way, Everywhere, USA', 'active'),
('CUST034', 'Amanda', 'King', 'amanda.king@example.com', '555-0134', '086 Poplar St, Somewhere, USA', 'active'),
('CUST035', 'Kenneth', 'Wright', 'kenneth.wright@example.com', '555-0135', '197 Redwood Ave, Nowhere, USA', 'active'),
('CUST036', 'Melissa', 'Scott', 'melissa.scott@example.com', '555-0136', '208 Sycamore Rd, Anywhere, USA', 'active'),
('CUST037', 'Joshua', 'Torres', 'joshua.torres@example.com', '555-0137', '319 Magnolia Dr, Everywhere, USA', 'active'),
('CUST038', 'Deborah', 'Nguyen', 'deborah.nguyen@example.com', '555-0138', '420 Palm Ln, Somewhere, USA', 'active'),
('CUST039', 'Kevin', 'Hill', 'kevin.hill@example.com', '555-0139', '531 Dogwood Blvd, Nowhere, USA', 'active'),
('CUST040', 'Stephanie', 'Flores', 'stephanie.flores@example.com', '555-0140', '642 Willow Ct, Anywhere, USA', 'active'),
('CUST041', 'Brian', 'Green', 'brian.green@example.com', '555-0141', '753 Juniper Way, Everywhere, USA', 'active'),
('CUST042', 'Rebecca', 'Adams', 'rebecca.adams@example.com', '555-0142', '864 Sequoia St, Somewhere, USA', 'active'),
('CUST043', 'George', 'Nelson', 'george.nelson@example.com', '555-0143', '975 Cypress Ave, Nowhere, USA', 'active'),
('CUST044', 'Laura', 'Baker', 'laura.baker@example.com', '555-0144', '086 Hemlock Rd, Anywhere, USA', 'active'),
('CUST045', 'Edward', 'Hall', 'edward.hall@example.com', '555-0145', '197 Fir Dr, Everywhere, USA', 'active'),
('CUST046', 'Sharon', 'Rivera', 'sharon.rivera@example.com', '555-0146', '208 Spruce Ln, Somewhere, USA', 'active'),
('CUST047', 'Ronald', 'Campbell', 'ronald.campbell@example.com', '555-0147', '319 Pine Blvd, Nowhere, USA', 'active'),
('CUST048', 'Cynthia', 'Mitchell', 'cynthia.mitchell@example.com', '555-0148', '420 Oak Ct, Anywhere, USA', 'active'),
('CUST049', 'Timothy', 'Carter', 'timothy.carter@example.com', '555-0149', '531 Maple Way, Everywhere, USA', 'active'),
('CUST050', 'Kathleen', 'Roberts', 'kathleen.roberts@example.com', '555-0150', '642 Elm St, Somewhere, USA', 'active'),
('CUST051', 'Jason', 'Gomez', 'jason.gomez@example.com', '555-0151', '753 Cedar Ave, Nowhere, USA', 'active'),
('CUST052', 'Angela', 'Phillips', 'angela.phillips@example.com', '555-0152', '864 Birch Rd, Anywhere, USA', 'active'),
('CUST053', 'Jeffrey', 'Evans', 'jeffrey.evans@example.com', '555-0153', '975 Walnut Dr, Everywhere, USA', 'active'),
('CUST054', 'Helen', 'Turner', 'helen.turner@example.com', '555-0154', '086 Cherry Ln, Somewhere, USA', 'active'),
('CUST055', 'Ryan', 'Diaz', 'ryan.diaz@example.com', '555-0155', '197 Aspen Blvd, Nowhere, USA', 'active'),
('CUST056', 'Anna', 'Parker', 'anna.parker@example.com', '555-0156', '208 Poplar Ct, Anywhere, USA', 'active'),
('CUST057', 'Jacob', 'Cruz', 'jacob.cruz@example.com', '555-0157', '319 Redwood Way, Everywhere, USA', 'active'),
('CUST058', 'Brenda', 'Edwards', 'brenda.edwards@example.com', '555-0158', '420 Sycamore St, Somewhere, USA', 'active'),
('CUST059', 'Gary', 'Collins', 'gary.collins@example.com', '555-0159', '531 Magnolia Ave, Nowhere, USA', 'active'),
('CUST060', 'Pamela', 'Reyes', 'pamela.reyes@example.com', '555-0160', '642 Palm Rd, Anywhere, USA', 'active'),
('CUST061', 'Nicholas', 'Stewart', 'nicholas.stewart@example.com', '555-0161', '753 Dogwood Dr, Everywhere, USA', 'active'),
('CUST062', 'Nicole', 'Morris', 'nicole.morris@example.com', '555-0162', '864 Willow Ln, Somewhere, USA', 'active'),
('CUST063', 'Eric', 'Morales', 'eric.morales@example.com', '555-0163', '975 Juniper Blvd, Nowhere, USA', 'active'),
('CUST064', 'Emma', 'Murphy', 'emma.murphy@example.com', '555-0164', '086 Sequoia Ct, Anywhere, USA', 'active'),
('CUST065', 'Stephen', 'Cook', 'stephen.cook@example.com', '555-0165', '197 Cypress Way, Everywhere, USA', 'active'),
('CUST066', 'Andrea', 'Rogers', 'andrea.rogers@example.com', '555-0166', '208 Hemlock St, Somewhere, USA', 'active'),
('CUST067', 'Jonathan', 'Gutierrez', 'jonathan.gutierrez@example.com', '555-0167', '319 Fir Ave, Nowhere, USA', 'active'),
('CUST068', 'Martha', 'Ortiz', 'martha.ortiz@example.com', '555-0168', '420 Spruce Rd, Anywhere, USA', 'active'),
('CUST069', 'Larry', 'Morgan', 'larry.morgan@example.com', '555-0169', '531 Pine Dr, Everywhere, USA', 'active'),
('CUST070', 'Rachel', 'Cooper', 'rachel.cooper@example.com', '555-0170', '642 Oak Ln, Somewhere, USA', 'active'),
('CUST071', 'Frank', 'Peterson', 'frank.peterson@example.com', '555-0171', '753 Maple Blvd, Nowhere, USA', 'active'),
('CUST072', 'Denise', 'Bailey', 'denise.bailey@example.com', '555-0172', '864 Elm Ct, Anywhere, USA', 'active'),
('CUST073', 'Scott', 'Reed', 'scott.reed@example.com', '555-0173', '975 Cedar Way, Everywhere, USA', 'active'),
('CUST074', 'Carolyn', 'Kelly', 'carolyn.kelly@example.com', '555-0174', '086 Birch St, Somewhere, USA', 'active'),
('CUST075', 'Benjamin', 'Howard', 'benjamin.howard@example.com', '555-0175', '197 Walnut Ave, Nowhere, USA', 'active'),
('CUST076', 'Janet', 'Ramos', 'janet.ramos@example.com', '555-0176', '208 Cherry Rd, Anywhere, USA', 'active'),
('CUST077', 'Patrick', 'Kim', 'patrick.kim@example.com', '555-0177', '319 Aspen Dr, Everywhere, USA', 'active'),
('CUST078', 'Ruth', 'Cox', 'ruth.cox@example.com', '555-0178', '420 Poplar Ln, Somewhere, USA', 'active'),
('CUST079', 'Jack', 'Ward', 'jack.ward@example.com', '555-0179', '531 Redwood Blvd, Nowhere, USA', 'active'),
('CUST080', 'Virginia', 'Richardson', 'virginia.richardson@example.com', '555-0180', '642 Sycamore Ct, Anywhere, USA', 'active'),
('CUST081', 'Dennis', 'Watson', 'dennis.watson@example.com', '555-0181', '753 Magnolia Way, Everywhere, USA', 'active'),
('CUST082', 'Heather', 'Brooks', 'heather.brooks@example.com', '555-0182', '864 Palm St, Somewhere, USA', 'active'),
('CUST083', 'Jerry', 'Chavez', 'jerry.chavez@example.com', '555-0183', '975 Dogwood Ave, Nowhere, USA', 'active'),
('CUST084', 'Cheryl', 'Wood', 'cheryl.wood@example.com', '555-0184', '086 Willow Rd, Anywhere, USA', 'active'),
('CUST085', 'Alexander', 'James', 'alexander.james@example.com', '555-0185', '197 Juniper Dr, Everywhere, USA', 'active'),
('CUST086', 'Frances', 'Bennett', 'frances.bennett@example.com', '555-0186', '208 Sequoia Ln, Somewhere, USA', 'active'),
('CUST087', 'Raymond', 'Gray', 'raymond.gray@example.com', '555-0187', '319 Cypress Blvd, Nowhere, USA', 'active'),
('CUST088', 'Joyce', 'Mendoza', 'joyce.mendoza@example.com', '555-0188', '420 Hemlock Ct, Anywhere, USA', 'active'),
('CUST089', 'Peter', 'Ruiz', 'peter.ruiz@example.com', '555-0189', '531 Fir Way, Everywhere, USA', 'active'),
('CUST090', 'Evelyn', 'Hughes', 'evelyn.hughes@example.com', '555-0190', '642 Spruce St, Somewhere, USA', 'active'),
('CUST091', 'Walter', 'Price', 'walter.price@example.com', '555-0191', '753 Pine Ave, Nowhere, USA', 'active'),
('CUST092', 'Judith', 'Alvarez', 'judith.alvarez@example.com', '555-0192', '864 Oak Rd, Anywhere, USA', 'active'),
('CUST093', 'Alan', 'Castillo', 'alan.castillo@example.com', '555-0193', '975 Maple Dr, Everywhere, USA', 'active'),
('CUST094', 'Megan', 'Sanders', 'megan.sanders@example.com', '555-0194', '086 Elm Ln, Somewhere, USA', 'active'),
('CUST095', 'Harry', 'Patel', 'harry.patel@example.com', '555-0195', '197 Cedar Blvd, Nowhere, USA', 'active'),
('CUST096', 'Amber', 'Myers', 'amber.myers@example.com', '555-0196', '208 Birch Ct, Anywhere, USA', 'active'),
('CUST097', 'Wayne', 'Long', 'wayne.long@example.com', '555-0197', '319 Walnut Way, Everywhere, USA', 'active'),
('CUST098', 'Danielle', 'Ross', 'danielle.ross@example.com', '555-0198', '420 Cherry St, Somewhere, USA', 'active'),
('CUST099', 'Philip', 'Foster', 'philip.foster@example.com', '555-0199', '531 Aspen Ave, Nowhere, USA', 'active'),
('CUST100', 'Beverly', 'Jimenez', 'beverly.jimenez@example.com', '555-0200', '642 Poplar Rd, Anywhere, USA', 'inactive');








INSERT INTO payments (customer_id, amount, payment_date, payment_method, notes) VALUES
(1, 125.50, '2024-01-05 09:15:22', 'card', 'Monthly subscription payment'),
(2, 89.99, '2024-01-06 14:30:45', 'bank_transfer', 'Product purchase'),
(3, 220.00, '2024-01-07 11:45:10', 'cash', 'In-store payment'),
(4, 75.25, '2024-01-08 16:20:33', 'card', 'Service fee'),
(5, 150.00, '2024-01-09 10:10:10', 'bank_transfer', 'Annual membership'),
(6, 45.75, '2024-01-10 13:25:47', 'card', 'Online order'),
(7, 199.99, '2024-01-11 15:35:22', 'card', 'Premium upgrade'),
(8, 60.00, '2024-01-12 12:40:18', 'cash', 'Renewal fee'),
(9, 85.50, '2024-01-13 09:55:29', 'bank_transfer', 'Product purchase'),
(10, 120.00, '2024-01-14 14:15:36', 'card', 'Subscription payment'),
(11, 65.25, '2024-01-15 11:30:42', 'card', 'Service charge'),
(12, 180.00, '2024-01-16 16:45:55', 'bank_transfer', 'Annual fee'),
(13, 95.99, '2024-01-17 10:20:13', 'card', 'Online purchase'),
(14, 42.50, '2024-01-18 13:35:27', 'cash', 'In-store payment'),
(15, 135.75, '2024-01-19 15:50:39', 'card', 'Membership renewal'),
(16, 70.00, '2024-01-20 12:05:48', 'bank_transfer', 'Product order'),
(17, 210.25, '2024-01-21 09:25:57', 'card', 'Premium service'),
(18, 55.50, '2024-01-22 14:40:06', 'cash', 'Renewal payment'),
(19, 99.99, '2024-01-23 11:55:15', 'bank_transfer', 'Subscription fee'),
(20, 80.00, '2024-01-24 17:10:24', 'card', 'Service payment'),
(21, 145.25, '2024-02-05 09:15:22', 'card', 'Monthly subscription payment'),
(22, 79.99, '2024-02-06 14:30:45', 'bank_transfer', 'Product purchase'),
(23, 230.00, '2024-02-07 11:45:10', 'cash', 'In-store payment'),
(24, 65.25, '2024-02-08 16:20:33', 'card', 'Service fee'),
(25, 140.00, '2024-02-09 10:10:10', 'bank_transfer', 'Annual membership'),
(26, 35.75, '2024-02-10 13:25:47', 'card', 'Online order'),
(27, 189.99, '2024-02-11 15:35:22', 'card', 'Premium upgrade'),
(28, 50.00, '2024-02-12 12:40:18', 'cash', 'Renewal fee'),
(29, 75.50, '2024-02-13 09:55:29', 'bank_transfer', 'Product purchase'),
(30, 110.00, '2024-02-14 14:15:36', 'card', 'Subscription payment'),
(31, 55.25, '2024-02-15 11:30:42', 'card', 'Service charge'),
(32, 170.00, '2024-02-16 16:45:55', 'bank_transfer', 'Annual fee'),
(33, 85.99, '2024-02-17 10:20:13', 'card', 'Online purchase'),
(34, 32.50, '2024-02-18 13:35:27', 'cash', 'In-store payment'),
(35, 125.75, '2024-02-19 15:50:39', 'card', 'Membership renewal'),
(36, 60.00, '2024-02-20 12:05:48', 'bank_transfer', 'Product order'),
(37, 200.25, '2024-02-21 09:25:57', 'card', 'Premium service'),
(38, 45.50, '2024-02-22 14:40:06', 'cash', 'Renewal payment'),
(39, 89.99, '2024-02-23 11:55:15', 'bank_transfer', 'Subscription fee'),
(40, 70.00, '2024-02-24 17:10:24', 'card', 'Service payment'),
(41, 135.50, '2024-03-05 09:15:22', 'card', 'Monthly subscription payment'),
(42, 99.99, '2024-03-06 14:30:45', 'bank_transfer', 'Product purchase'),
(43, 240.00, '2024-03-07 11:45:10', 'cash', 'In-store payment'),
(44, 85.25, '2024-03-08 16:20:33', 'card', 'Service fee'),
(45, 160.00, '2024-03-09 10:10:10', 'bank_transfer', 'Annual membership'),
(46, 55.75, '2024-03-10 13:25:47', 'card', 'Online order'),
(47, 209.99, '2024-03-11 15:35:22', 'card', 'Premium upgrade'),
(48, 70.00, '2024-03-12 12:40:18', 'cash', 'Renewal fee'),
(49, 95.50, '2024-03-13 09:55:29', 'bank_transfer', 'Product purchase'),
(50, 130.00, '2024-03-14 14:15:36', 'card', 'Subscription payment'),
(51, 75.25, '2024-03-15 11:30:42', 'card', 'Service charge'),
(52, 190.00, '2024-03-16 16:45:55', 'bank_transfer', 'Annual fee'),
(53, 105.99, '2024-03-17 10:20:13', 'card', 'Online purchase'),
(54, 52.50, '2024-03-18 13:35:27', 'cash', 'In-store payment'),
(55, 145.75, '2024-03-19 15:50:39', 'card', 'Membership renewal'),
(56, 80.00, '2024-03-20 12:05:48', 'bank_transfer', 'Product order'),
(57, 220.25, '2024-03-21 09:25:57', 'card', 'Premium service'),
(58, 65.50, '2024-03-22 14:40:06', 'cash', 'Renewal payment'),
(59, 109.99, '2024-03-23 11:55:15', 'bank_transfer', 'Subscription fee'),
(60, 90.00, '2024-03-24 17:10:24', 'card', 'Service payment'),
(61, 115.50, '2024-04-05 09:15:22', 'card', 'Monthly subscription payment'),
(62, 69.99, '2024-04-06 14:30:45', 'bank_transfer', 'Product purchase'),
(63, 210.00, '2024-04-07 11:45:10', 'cash', 'In-store payment'),
(64, 55.25, '2024-04-08 16:20:33', 'card', 'Service fee'),
(65, 130.00, '2024-04-09 10:10:10', 'bank_transfer', 'Annual membership'),
(66, 25.75, '2024-04-10 13:25:47', 'card', 'Online order'),
(67, 179.99, '2024-04-11 15:35:22', 'card', 'Premium upgrade'),
(68, 40.00, '2024-04-12 12:40:18', 'cash', 'Renewal fee'),
(69, 65.50, '2024-04-13 09:55:29', 'bank_transfer', 'Product purchase'),
(70, 100.00, '2024-04-14 14:15:36', 'card', 'Subscription payment'),
(71, 45.25, '2024-04-15 11:30:42', 'card', 'Service charge'),
(72, 160.00, '2024-04-16 16:45:55', 'bank_transfer', 'Annual fee'),
(73, 75.99, '2024-04-17 10:20:13', 'card', 'Online purchase'),
(74, 22.50, '2024-04-18 13:35:27', 'cash', 'In-store payment'),
(75, 115.75, '2024-04-19 15:50:39', 'card', 'Membership renewal'),
(76, 50.00, '2024-04-20 12:05:48', 'bank_transfer', 'Product order'),
(77, 190.25, '2024-04-21 09:25:57', 'card', 'Premium service'),
(78, 35.50, '2024-04-22 14:40:06', 'cash', 'Renewal payment'),
(79, 79.99, '2024-04-23 11:55:15', 'bank_transfer', 'Subscription fee'),
(80, 60.00, '2024-04-24 17:10:24', 'card', 'Service payment'),
(81, 145.50, '2024-05-05 09:15:22', 'card', 'Monthly subscription payment'),
(82, 109.99, '2024-05-06 14:30:45', 'bank_transfer', 'Product purchase'),
(83, 250.00, '2024-05-07 11:45:10', 'cash', 'In-store payment'),
(84, 95.25, '2024-05-08 16:20:33', 'card', 'Service fee'),
(85, 170.00, '2024-05-09 10:10:10', 'bank_transfer', 'Annual membership'),
(86, 65.75, '2024-05-10 13:25:47', 'card', 'Online order'),
(87, 219.99, '2024-05-11 15:35:22', 'card', 'Premium upgrade'),
(88, 80.00, '2024-05-12 12:40:18', 'cash', 'Renewal fee'),
(89, 105.50, '2024-05-13 09:55:29', 'bank_transfer', 'Product purchase'),
(90, 140.00, '2024-05-14 14:15:36', 'card', 'Subscription payment'),
(91, 85.25, '2024-05-15 11:30:42', 'card', 'Service charge'),
(92, 200.00, '2024-05-16 16:45:55', 'bank_transfer', 'Annual fee'),
(93, 115.99, '2024-05-17 10:20:13', 'card', 'Online purchase'),
(94, 62.50, '2024-05-18 13:35:27', 'cash', 'In-store payment'),
(95, 155.75, '2024-05-19 15:50:39', 'card', 'Membership renewal'),
(96, 90.00, '2024-05-20 12:05:48', 'bank_transfer', 'Product order'),
(97, 230.25, '2024-05-21 09:25:57', 'card', 'Premium service'),
(98, 75.50, '2024-05-22 14:40:06', 'cash', 'Renewal payment'),
(99, 119.99, '2024-05-23 11:55:15', 'bank_transfer', 'Subscription fee'),
(100, 100.00, '2024-05-24 17:10:24', 'card', 'Service payment'),
(1, 105.50, '2024-06-05 09:15:22', 'card', 'Monthly subscription payment'),
(2, 79.99, '2024-06-06 14:30:45', 'bank_transfer', 'Product purchase'),
(3, 200.00, '2024-06-07 11:45:10', 'cash', 'In-store payment'),
(4, 65.25, '2024-06-08 16:20:33', 'card', 'Service fee'),
(5, 150.00, '2024-06-09 10:10:10', 'bank_transfer', 'Annual membership'),
(6, 45.75, '2024-06-10 13:25:47', 'card', 'Online order'),
(7, 199.99, '2024-06-11 15:35:22', 'card', 'Premium upgrade'),
(8, 60.00, '2024-06-12 12:40:18', 'cash', 'Renewal fee'),
(9, 85.50, '2024-06-13 09:55:29', 'bank_transfer', 'Product purchase'),
(10, 120.00, '2024-06-14 14:15:36', 'card', 'Subscription payment'),
(11, 65.25, '2024-06-15 11:30:42', 'card', 'Service charge'),
(12, 180.00, '2024-06-16 16:45:55', 'bank_transfer', 'Annual fee'),
(13, 95.99, '2024-06-17 10:20:13', 'card', 'Online purchase'),
(14, 42.50, '2024-06-18 13:35:27', 'cash', 'In-store payment'),
(15, 135.75, '2024-06-19 15:50:39', 'card', 'Membership renewal'),
(16, 70.00, '2024-06-20 12:05:48', 'bank_transfer', 'Product order'),
(17, 210.25, '2024-06-21 09:25:57', 'card', 'Premium service'),
(18, 55.50, '2024-06-22 14:40:06', 'cash', 'Renewal payment'),
(19, 99.99, '2024-06-23 11:55:15', 'bank_transfer', 'Subscription fee'),
(20, 80.00, '2024-06-24 17:10:24', 'card', 'Service payment'),
(21, 125.50, '2024-07-05 09:15:22', 'card', 'Monthly subscription payment'),
(22, 89.99, '2024-07-06 14:30:45', 'bank_transfer', 'Product purchase'),
(23, 220.00, '2024-07-07 11:45:10', 'cash', 'In-store payment'),
(24, 75.25, '2024-07-08 16:20:33', 'card', 'Service fee'),
(25, 140.00, '2024-07-09 10:10:10', 'bank_transfer', 'Annual membership'),
(26, 35.75, '2024-07-10 13:25:47', 'card', 'Online order'),
(27, 189.99, '2024-07-11 15:35:22', 'card', 'Premium upgrade'),
(28, 50.00, '2024-07-12 12:40:18', 'cash', 'Renewal fee'),
(29, 75.50, '2024-07-13 09:55:29', 'bank_transfer', 'Product purchase'),
(30, 110.00, '2024-07-14 14:15:36', 'card', 'Subscription payment'),
(31, 55.25, '2024-07-15 11:30:42', 'card', 'Service charge'),
(32, 170.00, '2024-07-16 16:45:55', 'bank_transfer', 'Annual fee'),
(33, 85.99, '2024-07-17 10:20:13', 'card', 'Online purchase'),
(34, 32.50, '2024-07-18 13:35:27', 'cash', 'In-store payment'),
(35, 125.75, '2024-07-19 15:50:39', 'card', 'Membership renewal'),
(36, 60.00, '2024-07-20 12:05:48', 'bank_transfer', 'Product order'),
(37, 200.25, '2024-07-21 09:25:57', 'card', 'Premium service'),
(38, 45.50, '2024-07-22 14:40:06', 'cash', 'Renewal payment'),
(39, 89.99, '2024-07-23 11:55:15', 'bank_transfer', 'Subscription fee'),
(40, 70.00, '2024-07-24 17:10:24', 'card', 'Service payment'),
(41, 135.50, '2024-08-05 09:15:22', 'card', 'Monthly subscription payment'),
(42, 99.99, '2024-08-06 14:30:45', 'bank_transfer', 'Product purchase'),
(43, 240.00, '2024-08-07 11:45:10', 'cash', 'In-store payment'),
(44, 85.25, '2024-08-08 16:20:33', 'card', 'Service fee'),
(45, 160.00, '2024-08-09 10:10:10', 'bank_transfer', 'Annual membership'),
(46, 55.75, '2024-08-10 13:25:47', 'card', 'Online order'),
(47, 209.99, '2024-08-11 15:35:22', 'card', 'Premium upgrade'),
(48, 70.00, '2024-08-12 12:40:18', 'cash', 'Renewal fee'),
(49, 95.50, '2024-08-13 09:55:29', 'bank_transfer', 'Product purchase'),
(50, 130.00, '2024-08-14 14:15:36', 'card', 'Subscription payment'),
(51, 75.25, '2024-08-15 11:30:42', 'card', 'Service charge'),
(52, 190.00, '2024-08-16 16:45:55', 'bank_transfer', 'Annual fee'),
(53, 105.99, '2024-08-17 10:20:13', 'card', 'Online purchase'),
(54, 52.50, '2024-08-18 13:35:27', 'cash', 'In-store payment'),
(55, 145.75, '2024-08-19 15:50:39', 'card', 'Membership renewal'),
(56, 80.00, '2024-08-20 12:05:48', 'bank_transfer', 'Product order'),
(57, 220.25, '2024-08-21 09:25:57', 'card', 'Premium service'),
(58, 65.50, '2024-08-22 14:40:06', 'cash', 'Renewal payment'),
(59, 109.99, '2024-08-23 11:55:15', 'bank_transfer', 'Subscription fee'),
(60, 90.00, '2024-08-24 17:10:24', 'card', 'Service payment'),
(61, 115.50, '2024-09-05 09:15:22', 'card', 'Monthly subscription payment'),
(62, 69.99, '2024-09-06 14:30:45', 'bank_transfer', 'Product purchase'),
(63, 210.00, '2024-09-07 11:45:10', 'cash', 'In-store payment'),
(64, 55.25, '2024-09-08 16:20:33', 'card', 'Service fee'),
(65, 130.00, '2024-09-09 10:10:10', 'bank_transfer', 'Annual membership'),
(66, 25.75, '2024-09-10 13:25:47', 'card', 'Online order'),
(67, 179.99, '2024-09-11 15:35:22', 'card', 'Premium upgrade'),
(68, 40.00, '2024-09-12 12:40:18', 'cash', 'Renewal fee'),
(69, 65.50, '2024-09-13 09:55:29', 'bank_transfer', 'Product purchase'),
(70, 100.00, '2024-09-14 14:15:36', 'card', 'Subscription payment'),
(71, 45.25, '2024-09-15 11:30:42', 'card', 'Service charge'),
(72, 160.00, '2024-09-16 16:45:55', 'bank_transfer', 'Annual fee'),
(73, 75.99, '2024-09-17 10:20:13', 'card', 'Online purchase'),
(74, 22.50, '2024-09-18 13:35:27', 'cash', 'In-store payment'),
(75, 115.75, '2024-09-19 15:50:39', 'card', 'Membership renewal'),
(76, 50.00, '2024-09-20 12:05:48', 'bank_transfer', 'Product order'),
(77, 190.25, '2024-09-21 09:25:57', 'card', 'Premium service'),
(78, 35.50, '2024-09-22 14:40:06', 'cash', 'Renewal payment'),
(79, 79.99, '2024-09-23 11:55:15', 'bank_transfer', 'Subscription fee'),
(80, 60.00, '2024-09-24 17:10:24', 'card', 'Service payment'),
(81, 145.50, '2024-10-05 09:15:22', 'card', 'Monthly subscription payment'),
(82, 109.99, '2024-10-06 14:30:45', 'bank_transfer', 'Product purchase'),
(83, 250.00, '2024-10-07 11:45:10', 'cash', 'In-store payment'),
(84, 95.25, '2024-10-08 16:20:33', 'card', 'Service fee'),
(85, 170.00, '2024-10-09 10:10:10', 'bank_transfer', 'Annual membership'),
(86, 65.75, '2024-10-10 13:25:47', 'card', 'Online order'),
(87, 219.99, '2024-10-11 15:35:22', 'card', 'Premium upgrade'),
(88, 80.00, '2024-10-12 12:40:18', 'cash', 'Renewal fee'),
(89, 105.50, '2024-10-13 09:55:29', 'bank_transfer', 'Product purchase'),
(90, 140.00, '2024-10-14 14:15:36', 'card', 'Subscription payment'),
(91, 85.25, '2024-10-15 11:30:42', 'card', 'Service charge'),
(92, 200.00, '2024-10-16 16:45:55', 'bank_transfer', 'Annual fee'),
(93, 115.99, '2024-10-17 10:20:13', 'card', 'Online purchase'),
(94, 62.50, '2024-10-18 13:35:27', 'cash', 'In-store payment'),
(95, 155.75, '2024-10-19 15:50:39', 'card', 'Membership renewal'),
(96, 90.00, '2024-10-20 12:05:48', 'bank_transfer', 'Product order'),
(97, 230.25, '2024-10-21 09:25:57', 'card', 'Premium service'),
(98, 75.50, '2024-10-22 14:40:06', 'cash', 'Renewal payment'),
(99, 119.99, '2024-10-23 11:55:15', 'bank_transfer', 'Subscription fee'),
(100, 100.00, '2024-10-24 17:10:24', 'card', 'Service payment');


INSERT INTO payments (customer_id, amount, payment_date, payment_method, notes) VALUES
(1, 125.50, '2024-10-25 09:15:22', 'card', 'Monthly subscription payment'),
(2, 89.99, '2024-10-26 14:30:45', 'bank_transfer', 'Product purchase'),
(3, 220.00, '2024-10-27 11:45:10', 'cash', 'In-store payment'),
(4, 75.25, '2024-10-28 16:20:33', 'card', 'Service fee'),
(5, 150.00, '2024-10-29 10:10:10', 'bank_transfer', 'Annual membership'),
(6, 45.75, '2024-10-30 13:25:47', 'card', 'Online order'),
(7, 199.99, '2024-10-31 15:35:22', 'card', 'Premium upgrade'),
(8, 60.00, '2024-11-01 12:40:18', 'cash', 'Renewal fee'),
(9, 85.50, '2024-11-02 09:55:29', 'bank_transfer', 'Product purchase'),
(10, 120.00, '2024-11-03 14:15:36', 'card', 'Subscription payment'),
(11, 65.25, '2024-11-04 11:30:42', 'card', 'Service charge'),
(12, 180.00, '2024-11-05 16:45:55', 'bank_transfer', 'Annual fee'),
(13, 95.99, '2024-11-06 10:20:13', 'card', 'Online purchase'),
(14, 42.50, '2024-11-07 13:35:27', 'cash', 'In-store payment'),
(15, 135.75, '2024-11-08 15:50:39', 'card', 'Membership renewal'),
(16, 70.00, '2024-11-09 12:05:48', 'bank_transfer', 'Product order'),
(17, 210.25, '2024-11-10 09:25:57', 'card', 'Premium service'),
(18, 55.50, '2024-11-11 14:40:06', 'cash', 'Renewal payment'),
(19, 99.99, '2024-11-12 11:55:15', 'bank_transfer', 'Subscription fee'),
(20, 80.00, '2024-11-13 17:10:24', 'card', 'Service payment'),
(21, 145.25, '2024-11-14 09:15:22', 'card', 'Monthly subscription payment'),
(22, 79.99, '2024-11-15 14:30:45', 'bank_transfer', 'Product purchase'),
(23, 230.00, '2024-11-16 11:45:10', 'cash', 'In-store payment'),
(24, 65.25, '2024-11-17 16:20:33', 'card', 'Service fee'),
(25, 140.00, '2024-11-18 10:10:10', 'bank_transfer', 'Annual membership'),
(26, 35.75, '2024-11-19 13:25:47', 'card', 'Online order'),
(27, 189.99, '2024-11-20 15:35:22', 'card', 'Premium upgrade'),
(28, 50.00, '2024-11-21 12:40:18', 'cash', 'Renewal fee'),
(29, 75.50, '2024-11-22 09:55:29', 'bank_transfer', 'Product purchase'),
(30, 110.00, '2024-11-23 14:15:36', 'card', 'Subscription payment'),
(31, 55.25, '2024-11-24 11:30:42', 'card', 'Service charge'),
(32, 170.00, '2024-11-25 16:45:55', 'bank_transfer', 'Annual fee'),
(33, 85.99, '2024-11-26 10:20:13', 'card', 'Online purchase'),
(34, 32.50, '2024-11-27 13:35:27', 'cash', 'In-store payment'),
(35, 125.75, '2024-11-28 15:50:39', 'card', 'Membership renewal'),
(36, 60.00, '2024-11-29 12:05:48', 'bank_transfer', 'Product order'),
(37, 200.25, '2024-11-30 09:25:57', 'card', 'Premium service'),
(38, 45.50, '2024-12-01 14:40:06', 'cash', 'Renewal payment'),
(39, 89.99, '2024-12-02 11:55:15', 'bank_transfer', 'Subscription fee'),
(40, 70.00, '2024-12-03 17:10:24', 'card', 'Service payment'),
(41, 135.50, '2024-12-04 09:15:22', 'card', 'Monthly subscription payment'),
(42, 99.99, '2024-12-05 14:30:45', 'bank_transfer', 'Product purchase'),
(43, 240.00, '2024-12-06 11:45:10', 'cash', 'In-store payment'),
(44, 85.25, '2024-12-07 16:20:33', 'card', 'Service fee'),
(45, 160.00, '2024-12-08 10:10:10', 'bank_transfer', 'Annual membership'),
(46, 55.75, '2024-12-09 13:25:47', 'card', 'Online order'),
(47, 209.99, '2024-12-10 15:35:22', 'card', 'Premium upgrade'),
(48, 70.00, '2024-12-11 12:40:18', 'cash', 'Renewal fee'),
(49, 95.50, '2024-12-12 09:55:29', 'bank_transfer', 'Product purchase'),
(50, 130.00, '2024-12-13 14:15:36', 'card', 'Subscription payment'),
(51, 75.25, '2024-12-14 11:30:42', 'card', 'Service charge'),
(52, 190.00, '2024-12-15 16:45:55', 'bank_transfer', 'Annual fee'),
(53, 105.99, '2024-12-16 10:20:13', 'card', 'Online purchase'),
(54, 52.50, '2024-12-17 13:35:27', 'cash', 'In-store payment'),
(55, 145.75, '2024-12-18 15:50:39', 'card', 'Membership renewal'),
(56, 80.00, '2024-12-19 12:05:48', 'bank_transfer', 'Product order'),
(57, 220.25, '2024-12-20 09:25:57', 'card', 'Premium service'),
(58, 65.50, '2024-12-21 14:40:06', 'cash', 'Renewal payment'),
(59, 109.99, '2024-12-22 11:55:15', 'bank_transfer', 'Subscription fee'),
(60, 90.00, '2024-12-23 17:10:24', 'card', 'Service payment'),
(61, 115.50, '2024-12-24 09:15:22', 'card', 'Monthly subscription payment'),
(62, 69.99, '2024-12-25 14:30:45', 'bank_transfer', 'Product purchase'),
(63, 210.00, '2024-12-26 11:45:10', 'cash', 'In-store payment'),
(64, 55.25, '2024-12-27 16:20:33', 'card', 'Service fee'),
(65, 130.00, '2024-12-28 10:10:10', 'bank_transfer', 'Annual membership'),
(66, 25.75, '2024-12-29 13:25:47', 'card', 'Online order'),
(67, 179.99, '2024-12-30 15:35:22', 'card', 'Premium upgrade'),
(68, 40.00, '2024-12-31 12:40:18', 'cash', 'Renewal fee'),
(69, 65.50, '2025-01-01 09:55:29', 'bank_transfer', 'Product purchase'),
(70, 100.00, '2025-01-02 14:15:36', 'card', 'Subscription payment'),
(71, 45.25, '2025-01-03 11:30:42', 'card', 'Service charge'),
(72, 160.00, '2025-01-04 16:45:55', 'bank_transfer', 'Annual fee'),
(73, 75.99, '2025-01-05 10:20:13', 'card', 'Online purchase'),
(74, 22.50, '2025-01-06 13:35:27', 'cash', 'In-store payment'),
(75, 115.75, '2025-01-07 15:50:39', 'card', 'Membership renewal'),
(76, 50.00, '2025-01-08 12:05:48', 'bank_transfer', 'Product order'),
(77, 190.25, '2025-01-09 09:25:57', 'card', 'Premium service'),
(78, 35.50, '2025-01-10 14:40:06', 'cash', 'Renewal payment'),
(79, 79.99, '2025-01-11 11:55:15', 'bank_transfer', 'Subscription fee'),
(80, 60.00, '2025-01-12 17:10:24', 'card', 'Service payment'),
(81, 145.50, '2025-01-13 09:15:22', 'card', 'Monthly subscription payment'),
(82, 109.99, '2025-01-14 14:30:45', 'bank_transfer', 'Product purchase'),
(83, 250.00, '2025-01-15 11:45:10', 'cash', 'In-store payment'),
(84, 95.25, '2025-01-16 16:20:33', 'card', 'Service fee'),
(85, 170.00, '2025-01-17 10:10:10', 'bank_transfer', 'Annual membership'),
(86, 65.75, '2025-01-18 13:25:47', 'card', 'Online order'),
(87, 219.99, '2025-01-19 15:35:22', 'card', 'Premium upgrade'),
(88, 80.00, '2025-01-20 12:40:18', 'cash', 'Renewal fee'),
(89, 105.50, '2025-01-21 09:55:29', 'bank_transfer', 'Product purchase'),
(90, 140.00, '2025-01-22 14:15:36', 'card', 'Subscription payment'),
(91, 85.25, '2025-01-23 11:30:42', 'card', 'Service charge'),
(92, 200.00, '2025-01-24 16:45:55', 'bank_transfer', 'Annual fee'),
(93, 115.99, '2025-01-25 10:20:13', 'card', 'Online purchase'),
(94, 62.50, '2025-01-26 13:35:27', 'cash', 'In-store payment'),
(95, 155.75, '2025-01-27 15:50:39', 'card', 'Membership renewal'),
(96, 90.00, '2025-01-28 12:05:48', 'bank_transfer', 'Product order'),
(97, 230.25, '2025-01-29 09:25:57', 'card', 'Premium service'),
(98, 75.50, '2025-01-30 14:40:06', 'cash', 'Renewal payment'),
(99, 119.99, '2025-01-31 11:55:15', 'bank_transfer', 'Subscription fee'),
(100, 100.00, '2025-02-01 17:10:24', 'card', 'Service payment'),
(1, 105.50, '2025-02-02 09:15:22', 'card', 'Monthly subscription payment'),
(2, 79.99, '2025-02-03 14:30:45', 'bank_transfer', 'Product purchase'),
(3, 200.00, '2025-02-04 11:45:10', 'cash', 'In-store payment'),
(4, 65.25, '2025-02-05 16:20:33', 'card', 'Service fee'),
(5, 150.00, '2025-02-06 10:10:10', 'bank_transfer', 'Annual membership'),
(6, 45.75, '2025-02-07 13:25:47', 'card', 'Online order'),
(7, 199.99, '2025-02-08 15:35:22', 'card', 'Premium upgrade'),
(8, 60.00, '2025-02-09 12:40:18', 'cash', 'Renewal fee'),
(9, 85.50, '2025-02-10 09:55:29', 'bank_transfer', 'Product purchase'),
(10, 120.00, '2025-02-11 14:15:36', 'card', 'Subscription payment'),
(11, 65.25, '2025-02-12 11:30:42', 'card', 'Service charge'),
(12, 180.00, '2025-02-13 16:45:55', 'bank_transfer', 'Annual fee'),
(13, 95.99, '2025-02-14 10:20:13', 'card', 'Online purchase'),
(14, 42.50, '2025-02-15 13:35:27', 'cash', 'In-store payment'),
(15, 135.75, '2025-02-16 15:50:39', 'card', 'Membership renewal'),
(16, 70.00, '2025-02-17 12:05:48', 'bank_transfer', 'Product order'),
(17, 210.25, '2025-02-18 09:25:57', 'card', 'Premium service'),
(18, 55.50, '2025-02-19 14:40:06', 'cash', 'Renewal payment'),
(19, 99.99, '2025-02-20 11:55:15', 'bank_transfer', 'Subscription fee'),
(20, 80.00, '2025-02-21 17:10:24', 'card', 'Service payment'),
(21, 125.50, '2025-02-22 09:15:22', 'card', 'Monthly subscription payment'),
(22, 89.99, '2025-02-23 14:30:45', 'bank_transfer', 'Product purchase'),
(23, 220.00, '2025-02-24 11:45:10', 'cash', 'In-store payment'),
(24, 75.25, '2025-02-25 16:20:33', 'card', 'Service fee'),
(25, 140.00, '2025-02-26 10:10:10', 'bank_transfer', 'Annual membership'),
(26, 35.75, '2025-02-27 13:25:47', 'card', 'Online order'),
(27, 189.99, '2025-02-28 15:35:22', 'card', 'Premium upgrade'),
(28, 50.00, '2025-03-01 12:40:18', 'cash', 'Renewal fee'),
(29, 75.50, '2025-03-02 09:55:29', 'bank_transfer', 'Product purchase'),
(30, 110.00, '2025-03-03 14:15:36', 'card', 'Subscription payment'),
(31, 55.25, '2025-03-04 11:30:42', 'card', 'Service charge'),
(32, 170.00, '2025-03-05 16:45:55', 'bank_transfer', 'Annual fee'),
(33, 85.99, '2025-03-06 10:20:13', 'card', 'Online purchase'),
(34, 32.50, '2025-03-07 13:35:27', 'cash', 'In-store payment'),
(35, 125.75, '2025-03-08 15:50:39', 'card', 'Membership renewal'),
(36, 60.00, '2025-03-09 12:05:48', 'bank_transfer', 'Product order'),
(37, 200.25, '2025-03-10 09:25:57', 'card', 'Premium service'),
(38, 45.50, '2025-03-11 14:40:06', 'cash', 'Renewal payment'),
(39, 89.99, '2025-03-12 11:55:15', 'bank_transfer', 'Subscription fee'),
(40, 70.00, '2025-03-13 17:10:24', 'card', 'Service payment'),
(41, 135.50, '2025-03-14 09:15:22', 'card', 'Monthly subscription payment'),
(42, 99.99, '2025-03-15 14:30:45', 'bank_transfer', 'Product purchase'),
(43, 240.00, '2025-03-16 11:45:10', 'cash', 'In-store payment'),
(44, 85.25, '2025-03-17 16:20:33', 'card', 'Service fee'),
(45, 160.00, '2025-03-18 10:10:10', 'bank_transfer', 'Annual membership'),
(46, 55.75, '2025-03-19 13:25:47', 'card', 'Online order'),
(47, 209.99, '2025-03-20 15:35:22', 'card', 'Premium upgrade'),
(48, 70.00, '2025-03-21 12:40:18', 'cash', 'Renewal fee'),
(49, 95.50, '2025-03-22 09:55:29', 'bank_transfer', 'Product purchase'),
(50, 130.00, '2025-03-23 14:15:36', 'card', 'Subscription payment'),
(51, 75.25, '2025-03-24 11:30:42', 'card', 'Service charge'),
(52, 190.00, '2025-03-25 16:45:55', 'bank_transfer', 'Annual fee'),
(53, 105.99, '2025-03-26 10:20:13', 'card', 'Online purchase'),
(54, 52.50, '2025-03-27 13:35:27', 'cash', 'In-store payment'),
(55, 145.75, '2025-03-28 15:50:39', 'card', 'Membership renewal'),
(56, 80.00, '2025-03-29 12:05:48', 'bank_transfer', 'Product order'),
(57, 220.25, '2025-03-30 09:25:57', 'card', 'Premium service'),
(58, 65.50, '2025-03-31 14:40:06', 'cash', 'Renewal payment'),
(59, 109.99, '2025-04-01 11:55:15', 'bank_transfer', 'Subscription fee'),
(60, 90.00, '2025-04-02 17:10:24', 'card', 'Service payment'),
(61, 115.50, '2025-04-03 09:15:22', 'card', 'Monthly subscription payment'),
(62, 69.99, '2025-04-04 14:30:45', 'bank_transfer', 'Product purchase'),
(63, 210.00, '2025-04-05 11:45:10', 'cash', 'In-store payment'),
(64, 55.25, '2025-04-06 16:20:33', 'card', 'Service fee'),
(65, 130.00, '2025-04-07 10:10:10', 'bank_transfer', 'Annual membership'),
(66, 25.75, '2025-04-08 13:25:47', 'card', 'Online order'),
(67, 179.99, '2025-04-09 15:35:22', 'card', 'Premium upgrade'),
(68, 40.00, '2025-04-10 12:40:18', 'cash', 'Renewal fee'),
(69, 65.50, '2025-04-11 09:55:29', 'bank_transfer', 'Product purchase'),
(70, 100.00, '2025-04-12 14:15:36', 'card', 'Subscription payment'),
(71, 45.25, '2025-04-13 11:30:42', 'card', 'Service charge'),
(72, 160.00, '2025-04-14 16:45:55', 'bank_transfer', 'Annual fee'),
(73, 75.99, '2025-04-15 10:20:13', 'card', 'Online purchase'),
(74, 22.50, '2025-04-16 13:35:27', 'cash', 'In-store payment'),
(75, 115.75, '2025-04-17 15:50:39', 'card', 'Membership renewal'),
(76, 50.00, '2025-04-18 12:05:48', 'bank_transfer', 'Product order'),
(77, 190.25, '2025-04-19 09:25:57', 'card', 'Premium service'),
(78, 35.50, '2025-04-20 14:40:06', 'cash', 'Renewal payment'),
(79, 79.99, '2025-04-21 11:55:15', 'bank_transfer', 'Subscription fee'),
(80, 60.00, '2025-04-22 17:10:24', 'card', 'Service payment'),
(81, 145.50, '2025-04-23 09:15:22', 'card', 'Monthly subscription payment'),
(82, 109.99, '2025-04-24 14:30:45', 'bank_transfer', 'Product purchase'),
(83, 250.00, '2025-04-25 11:45:10', 'cash', 'In-store payment'),
(84, 95.25, '2025-04-26 16:20:33', 'card', 'Service fee'),
(85, 170.00, '2025-04-27 10:10:10', 'bank_transfer', 'Annual membership'),
(86, 65.75, '2025-04-28 13:25:47', 'card', 'Online order'),
(87, 219.99, '2025-04-29 15:35:22', 'card', 'Premium upgrade'),
(88, 80.00, '2025-04-30 12:40:18', 'cash', 'Renewal fee'),
(89, 105.50, '2025-05-01 09:55:29', 'bank_transfer', 'Product purchase'),
(90, 140.00, '2025-05-02 14:15:36', 'card', 'Subscription payment'),
(91, 85.25, '2025-05-03 11:30:42', 'card', 'Service charge'),
(92, 200.00, '2025-05-04 16:45:55', 'bank_transfer', 'Annual fee'),
(93, 115.99, '2025-05-05 10:20:13', 'card', 'Online purchase'),
(94, 62.50, '2025-05-06 13:35:27', 'cash', 'In-store payment'),
(95, 155.75, '2025-05-07 15:50:39', 'card', 'Membership renewal'),
(96, 90.00, '2025-05-08 12:05:48', 'bank_transfer', 'Product order'),
(97, 230.25, '2025-05-09 09:25:57', 'card', 'Premium service'),
(98, 75.50, '2025-05-10 14:40:06', 'cash', 'Renewal payment'),
(99, 119.99, '2025-05-11 11:55:15', 'bank_transfer', 'Subscription fee'),
(100, 100.00, '2025-05-12 17:10:24', 'card', 'Service payment'),
(1, 105.50, '2025-05-13 09:15:22', 'card', 'Monthly subscription payment'),
(2, 79.99, '2025-05-14 14:30:45', 'bank_transfer', 'Product purchase'),
(3, 200.00, '2025-05-15 11:45:10', 'cash', 'In-store payment'),
(4, 65.25, '2025-05-16 16:20:33', 'card', 'Service fee'),
(5, 150.00, '2025-05-17 10:10:10', 'bank_transfer', 'Annual membership'),
(6, 45.75, '2025-05-18 13:25:47', 'card', 'Online order'),
(7, 199.99, '2025-05-19 15:35:22', 'card', 'Premium upgrade'),
(8, 60.00, '2025-05-20 12:40:18', 'cash', 'Renewal fee'),
(9, 85.50, '2025-05-21 09:55:29', 'bank_transfer', 'Product purchase'),
(10, 120.00, '2025-05-22 14:15:36', 'card', 'Subscription payment'),
(11, 65.25, '2025-05-23 11:30:42', 'card', 'Service charge'),
(12, 180.00, '2025-05-24 16:45:55', 'bank_transfer', 'Annual fee'),
(13, 95.99, '2025-05-25 10:20:13', 'card', 'Online purchase'),
(14, 42.50, '2025-05-26 13:35:27', 'cash', 'In-store payment'),
(15, 135.75, '2025-05-27 15:50:39', 'card', 'Membership renewal'),
(16, 70.00, '2025-05-28 12:05:48', 'bank_transfer', 'Product order'),
(17, 210.25, '2025-05-29 09:25:57', 'card', 'Premium service'),
(18, 55.50, '2025-05-30 14:40:06', 'cash', 'Renewal payment'),
(19, 99.99, '2025-05-31 11:55:15', 'bank_transfer', 'Subscription fee'),
(20, 80.00, '2025-06-01 17:10:24', 'card', 'Service payment'),
(21, 125.50, '2025-06-02 09:15:22', 'card', 'Monthly subscription payment'),
(22, 89.99, '2025-06-03 14:30:45', 'bank_transfer', 'Product purchase'),
(23, 220.00, '2025-06-04 11:45:10', 'cash', 'In-store payment'),
(24, 75.25, '2025-06-05 16:20:33', 'card', 'Service fee'),
(25, 140.00, '2025-06-06 10:10:10', 'bank_transfer', 'Annual membership'),
(26, 35.75, '2025-06-07 13:25:47', 'card', 'Online order'),
(27, 189.99, '2025-06-08 15:35:22', 'card', 'Premium upgrade'),
(28, 50.00, '2025-06-09 12:40:18', 'cash', 'Renewal fee');



















































































INSERT INTO expenses (expense_date, category, description, amount, payment_method, receipt_number, recorded_by)
VALUES
    -- Q1: January-March 2024
    ('2024-01-05', 'Office Supplies', 'HP 63XL Ink Cartridges (4-pack)', 129.99, 'credit_card', 'RC-240101', 'John D.'),
    ('2024-01-10', 'Technology', 'Dell UltraSharp 27" Monitor', 429.99, 'bank_transfer', 'RC-240102', 'Sarah K.'),
    ('2024-01-15', 'Travel', 'Flight SFO-JFK for Tech Conference', 587.50, 'credit_card', 'RC-240103', 'Michael T.'),
    ('2024-01-18', 'Meals & Entertainment', 'Team Dinner at Chez Panisse', 345.60, 'credit_card', 'RC-240104', 'Lisa M.'),
    ('2024-01-22', 'Software', 'Annual Slack Enterprise License', 4800.00, 'check', 'RC-240105', 'David W.'),
    ('2024-01-25', 'Marketing', 'Google Ads Q1 Campaign', 2500.00, 'bank_transfer', 'RC-240106', 'Emily R.'),
    ('2024-01-28', 'Office Maintenance', 'Emergency HVAC Repair', 875.00, 'credit_card', 'RC-240107', 'Robert B.'),

    ('2024-02-03', 'Office Supplies', 'Reams of Paper (20 Case)', 189.75, 'bank_transfer', 'RC-240208', 'John D.'),
    ('2024-02-07', 'Professional Development', 'AWS Certification Course', 299.00, 'credit_card', 'RC-240209', 'Michael T.'),
    ('2024-02-10', 'Travel', 'Hotel Stay - Tech Conference NYC', 1245.00, 'credit_card', 'RC-240210', 'Sarah K.'),
    ('2024-02-14', 'Client Gifts', 'Valentine\'s Day Client Gifts', 420.00, 'bank_transfer', 'RC-240211', 'Lisa M.'),
    ('2024-02-18', 'Equipment', 'MacBook Pro 16", M2 Max', 3499.00, 'check', 'RC-240212', 'David W.'),
    ('2024-02-22', 'Marketing', 'LinkedIn Sponsored Content', 1800.00, 'credit_card', 'RC-240213', 'Emily R.'),
    ('2024-02-25', 'Utilities', 'February Office Electricity', 325.40, 'bank_transfer', 'RC-240214', 'Robert B.'),

    ('2024-03-05', 'Office Furniture', 'Ergonomic Office Chairs (x5)', 2475.00, 'check', 'RC-240315', 'John D.'),
    ('2024-03-09', 'Software', 'Zoom Annual Subscription', 1499.00, 'credit_card', 'RC-240316', 'Sarah K.'),
    ('2024-03-12', 'Travel', 'Rental Car - Client Meetings', 287.50, 'credit_card', 'RC-240317', 'Michael T.'),
    ('2024-03-16', 'Team Building', 'Escape Room Team Event', 320.00, 'bank_transfer', 'RC-240318', 'Lisa M.'),
    ('2024-03-20', 'Equipment', 'iPad Pro for Sales Team', 1099.00, 'credit_card', 'RC-240319', 'David W.'),
    ('2024-03-24', 'Marketing', 'Trade Show Booth Design', 4200.00, 'check', 'RC-240320', 'Emily R.'),
    ('2024-03-28', 'Utilities', 'March Internet & Phone', 245.75, 'bank_transfer', 'RC-240321', 'Robert B.'),

    -- Q2: April-June 2024
    ('2024-04-03', 'Office Supplies', 'Spring Office Refresh Supplies', 215.25, 'credit_card', 'RC-240422', 'John D.'),
    ('2024-04-07', 'Professional Development', 'Data Science Conference Tickets', 899.00, 'bank_transfer', 'RC-240423', 'Sarah K.'),
    ('2024-04-11', 'Travel', 'Flight DEN-SEA for Client Pitch', 412.00, 'credit_card', 'RC-240424', 'Michael T.'),
    ('2024-04-15', 'Client Entertainment', 'Golf Outing with Key Client', 680.50, 'credit_card', 'RC-240425', 'Lisa M.'),
    ('2024-04-19', 'Software', 'QuickBooks Enterprise Renewal', 1200.00, 'check', 'RC-240426', 'David W.'),
    ('2024-04-23', 'Marketing', 'Spring Email Campaign', 3150.00, 'bank_transfer', 'RC-240427', 'Emily R.'),
    ('2024-04-27', 'Office Maintenance', 'Quarterly Deep Cleaning', 550.00, 'credit_card', 'RC-240428', 'Robert B.'),

    ('2024-05-02', 'Office Supplies', 'Mother\'s Day Office Flowers', 165.00, 'bank_transfer', 'RC-240529', 'John D.'),
    ('2024-05-06', 'Technology', 'NAS Storage System Upgrade', 3200.00, 'credit_card', 'RC-240530', 'Sarah K.'),
    ('2024-05-10', 'Travel', 'Uber/Lyft Business Travel', 187.35, 'credit_card', 'RC-240531', 'Michael T.'),
    ('2024-05-14', 'Team Meals', 'Admin Appreciation Lunch', 275.80, 'bank_transfer', 'RC-240532', 'Lisa M.'),
    ('2024-05-18', 'Equipment', 'Conference Room AV System', 5875.00, 'check', 'RC-240533', 'David W.'),
    ('2024-05-22', 'Marketing', 'Google Analytics Consulting', 2500.00, 'credit_card', 'RC-240534', 'Emily R.'),
    ('2024-05-26', 'Utilities', 'May Water & Electricity', 410.25, 'bank_transfer', 'RC-240535', 'Robert B.'),

    ('2024-06-01', 'Office Furniture', 'Standing Desks (x3)', 1125.00, 'check', 'RC-240636', 'John D.'),
    ('2024-06-05', 'Software', '1Password Teams License', 299.00, 'credit_card', 'RC-240637', 'Sarah K.'),
    ('2024-06-09', 'Travel', 'Summer Retreat Airfare', 2230.00, 'credit_card', 'RC-240638', 'Michael T.'),
    ('2024-06-13', 'Client Gifts', 'Summer Gift Baskets', 725.00, 'bank_transfer', 'RC-240639', 'Lisa M.'),
    ('2024-06-17', 'Equipment', 'Noise-Canceling Headphones (x8)', 1592.00, 'credit_card', 'RC-240640', 'David W.'),
    ('2024-06-21', 'Marketing', 'Mid-Year Brand Refresh', 8750.00, 'check', 'RC-240641', 'Emily R.'),
    ('2024-06-25', 'Utilities', 'June AC & Utilities', 595.00, 'bank_transfer', 'RC-240642', 'Robert B.'),

    -- Q3: July-September 2024
    ('2024-07-03', 'Office Supplies', 'Quarterly Printer Maintenance', 320.00, 'credit_card', 'RC-240743', 'John D.'),
    ('2024-07-07', 'Professional Development', 'Leadership Training Program', 4500.00, 'bank_transfer', 'RC-240744', 'Sarah K.'),
    ('2024-07-11', 'Travel', 'Client Site Visits - Rental Car', 412.50, 'credit_card', 'RC-240745', 'Michael T.'),
    ('2024-07-15', 'Team Building', 'Summer Picnic Event', 1200.00, 'check', 'RC-240746', 'Lisa M.'),
    ('2024-07-19', 'Software', 'Adobe Creative Cloud (10 seats)', 599.00, 'credit_card', 'RC-240747', 'David W.'),
    ('2024-07-23', 'Marketing', 'Back-to-School Campaign', 4200.00, 'bank_transfer', 'RC-240748', 'Emily R.'),
    ('2024-07-27', 'Office Maintenance', 'Parking Lot Repaving', 3500.00, 'check', 'RC-240749', 'Robert B.'),

    ('2024-08-02', 'Office Supplies', 'Fall Planning Materials', 185.75, 'credit_card', 'RC-240850', 'John D.'),
    ('2024-08-06', 'Technology', 'Server Backup Solution', 2400.00, 'bank_transfer', 'RC-240851', 'Sarah K.'),
    ('2024-08-10', 'Travel', 'Industry Conference Registration', 1750.00, 'credit_card', 'RC-240852', 'Michael T.'),
    ('2024-08-14', 'Client Entertainment', 'Baseball Game Tickets', 850.00, 'check', 'RC-240853', 'Lisa M.'),
    ('2024-08-18', 'Equipment', 'Document Scanner', 475.00, 'credit_card', 'RC-240854', 'David W.'),
    ('2024-08-22', 'Marketing', 'Q3 Social Media Management', 3800.00, 'bank_transfer', 'RC-240855', 'Emily R.'),
    ('2024-08-26', 'Utilities', 'August Office Utilities', 425.50, 'credit_card', 'RC-240856', 'Robert B.'),

    ('2024-09-01', 'Office Furniture', 'Reception Area Sofa', 1299.00, 'check', 'RC-240957', 'John D.'),
    ('2024-09-05', 'Software', 'CRM System Upgrade', 3200.00, 'bank_transfer', 'RC-240958', 'Sarah K.'),
    ('2024-09-09', 'Travel', 'Last-Minute Client Meeting Flight', 725.00, 'credit_card', 'RC-240959', 'Michael T.'),
    ('2024-09-13', 'Team Meals', 'End-of-Quarter Celebration', 480.00, 'credit_card', 'RC-240960', 'Lisa M.'),
    ('2024-09-17', 'Equipment', 'Security Camera System', 2100.00, 'check', 'RC-240961', 'David W.'),
    ('2024-09-21', 'Marketing', 'Holiday Season Planning', 5500.00, 'bank_transfer', 'RC-240962', 'Emily R.'),
    ('2024-09-25', 'Utilities', 'September Internet & Phones', 265.00, 'credit_card', 'RC-240963', 'Robert B.'),

    -- Q4: October-December 2024
    ('2024-10-03', 'Office Supplies', 'Halloween Decorations', 120.00, 'bank_transfer', 'RC-241064', 'John D.'),
    ('2024-10-07', 'Professional Development', 'Sales Training Workshop', 2200.00, 'credit_card', 'RC-241065', 'Sarah K.'),
    ('2024-10-11', 'Travel', 'Client Onsite Support Travel', 980.00, 'check', 'RC-241066', 'Michael T.'),
    ('2024-10-15', 'Client Gifts', 'Diwali Corporate Gifts', 650.00, 'bank_transfer', 'RC-241067', 'Lisa M.'),
    ('2024-10-19', 'Software', 'Cybersecurity Software', 1500.00, 'credit_card', 'RC-241068', 'David W.'),
    ('2024-10-23', 'Marketing', 'Q4 Digital Advertising', 7200.00, 'check', 'RC-241069', 'Emily R.'),
    ('2024-10-27', 'Office Maintenance', 'Winter HVAC Checkup', 350.00, 'bank_transfer', 'RC-241070', 'Robert B.'),

    ('2024-11-02', 'Office Supplies', 'Thanksgiving Decor', 95.00, 'credit_card', 'RC-241171', 'John D.'),
    ('2024-11-06', 'Technology', 'IT Infrastructure Upgrade', 8750.00, 'check', 'RC-241172', 'Sarah K.'),
    ('2024-11-10', 'Travel', 'Year-End Planning Retreat', 4200.00, 'bank_transfer', 'RC-241173', 'Michael T.'),
    ('2024-11-14', 'Team Events', 'Holiday Party Deposit', 2500.00, 'credit_card', 'RC-241174', 'Lisa M.'),
    ('2024-11-18', 'Equipment', 'Portable Projectors (x2)', 850.00, 'check', 'RC-241175', 'David W.'),
    ('2024-11-22', 'Marketing', 'Black Friday Promotions', 6200.00, 'bank_transfer', 'RC-241176', 'Emily R.'),
    ('2024-11-26', 'Utilities', 'November Office Expenses', 380.75, 'credit_card', 'RC-241177', 'Robert B.'),

    ('2024-12-01', 'Office Furniture', 'Executive Desk', 950.00, 'check', 'RC-241278', 'John D.'),
    ('2024-12-05', 'Software', 'Annual Microsoft 365 Renewal', 2400.00, 'bank_transfer', 'RC-241279', 'Sarah K.'),
    ('2024-12-09', 'Travel', 'Client Appreciation Dinner', 1200.00, 'credit_card', 'RC-241280', 'Michael T.'),
    ('2024-12-13', 'Client Gifts', 'Holiday Gift Baskets', 1500.00, 'check', 'RC-241281', 'Lisa M.'),
    ('2024-12-17', 'Equipment', 'Year-End Tech Refresh', 12500.00, 'bank_transfer', 'RC-241282', 'David W.'),
    ('2024-12-21', 'Marketing', 'New Year Campaign Launch', 9800.00, 'credit_card', 'RC-241283', 'Emily R.'),
    ('2024-12-27', 'Utilities', 'December Utility Bundle', 510.00, 'bank_transfer', 'RC-241284', 'Robert B.'),
    ('2024-12-29', 'Year-End', 'Annual Accounting Services', 7500.00, 'check', 'RC-241285', 'John D.');