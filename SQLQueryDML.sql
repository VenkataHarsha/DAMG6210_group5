INSERT INTO Person (person_id, first_name, last_name, mobile_no, email, date_of_birth, street_name, zipcode, city, state, type) VALUES
(1, 'John', 'Doe', 1234567890, 'john.doe@example.com', '1980-01-01', 'Maple Street', 10001, 'New York', 'NY', 'T'),
(2, 'Jane', 'Smith', 2345678901, 'jane.smith@example.com', '1985-02-02', 'Oak Avenue', 20005, 'Washington', 'DC', 'E'),
(3, 'Alice', 'Johnson', 3456789012, 'alice.johnson@example.com', '1990-03-03', 'Pine Lane', 90005, 'Los Angeles', 'CA', 'T'),
(4, 'Bob', 'Williams', 4567890123, 'bob.williams@example.com', '1975-04-04', 'Elm Road', 77002, 'Houston', 'TX', 'E'),
(5, 'Carol', 'Brown', 5678901234, 'carol.brown@example.com', '1988-05-05', 'Cedar Blvd', 33101, 'Miami', 'FL', 'T'),
(6, 'David', 'Jones', 6789012345, 'david.jones@example.com', '1970-06-06', 'Birch Path', 60603, 'Chicago', 'IL', 'E'),
(7, 'Eve', 'Miller', 7890123456, 'eve.miller@example.com', '1992-07-07', 'Spruce Way', 80202, 'Denver', 'CO', 'T'),
(8, 'Frank', 'Davis', 8901234567, 'frank.davis@example.com', '1983-08-08', 'Oak Knoll', 98101, 'Seattle', 'WA', 'E'),
(9, 'Grace', 'Lopez', 9012345678, 'grace.lopez@example.com', '1995-09-09', 'Pine Ridge', 02108, 'Boston', 'MA', 'T'),
(10, 'Henry', 'Wilson', 1234567890, 'henry.wilson@example.com', '1978-10-10', 'Cedar Grove', 15213, 'Pittsburgh', 'PA', 'E'),
(11, 'Isabel', 'Martinez', 2345678901, 'isabel.martinez@example.com', '1981-11-11', 'Elm Street', 30303, 'Atlanta', 'GA', 'T'),
(12, 'Jack', 'Anderson', 3456789012, 'jack.anderson@example.com', '1984-12-12', 'Maple Avenue', 94102, 'San Francisco', 'CA', 'E'),
(13, 'Kathy', 'Thomas', 4567890123, 'kathy.thomas@example.com', '1991-01-13', 'Oak Drive', 37203, 'Nashville', 'TN', 'T'),
(14, 'Leo', 'Harris', 5678901234, 'leo.harris@example.com', '1977-02-14', 'Birch Road', 85281, 'Tempe', 'AZ', 'E'),
(15, 'Mia', 'Clark', 6789012345, 'mia.clark@example.com', '1986-03-15', 'Cedar Street', 55111, 'Saint Paul', 'MN', 'T'),
(16, 'Noah', 'Rodriguez', 7890123456, 'noah.rodriguez@example.com', '1979-04-16', 'Pine Court', 46204, 'Indianapolis', 'IN', 'E'),
(17, 'Olivia', 'Lewis', 8901234567, 'olivia.lewis@example.com', '1993-05-17', 'Elm Circle', 97209, 'Portland', 'OR', 'T'),
(18, 'Paul', 'Lee', 9012345678, 'paul.lee@example.com', '1982-06-18', 'Birch Lane', 89101, 'Las Vegas', 'NV', 'E'),
(19, 'Quinn', 'Walker', 1234567890, 'quinn.walker@example.com', '1994-07-19', 'Cedar Place', 80202, 'Denver', 'CO', 'T'),
(20, 'Rachel', 'Hall', 2345678901, 'rachel.hall@example.com', '1976-08-20', 'Pine Road', 19104, 'Philadelphia', 'PA', 'E');




OPEN SYMMETRIC KEY TraderSymmetricKey
   DECRYPTION BY CERTIFICATE TraderCert;


INSERT INTO Trader (trader_id, license_number)
VALUES
(1, EncryptByKey(Key_GUID('TraderSymmetricKey'), CONVERT(VARBINARY, 'Lic001'))),
(3, EncryptByKey(Key_GUID('TraderSymmetricKey'), CONVERT(VARBINARY, 'Lic002'))),
(5, EncryptByKey(Key_GUID('TraderSymmetricKey'), CONVERT(VARBINARY, 'Lic003'))),
(7, EncryptByKey(Key_GUID('TraderSymmetricKey'), CONVERT(VARBINARY, 'Lic004'))),
(9, EncryptByKey(Key_GUID('TraderSymmetricKey'), CONVERT(VARBINARY, 'Lic005'))),
(11, EncryptByKey(Key_GUID('TraderSymmetricKey'), CONVERT(VARBINARY, 'Lic006'))),
(13, EncryptByKey(Key_GUID('TraderSymmetricKey'), CONVERT(VARBINARY, 'Lic007'))),
(15, EncryptByKey(Key_GUID('TraderSymmetricKey'), CONVERT(VARBINARY, 'Lic008'))),
(17, EncryptByKey(Key_GUID('TraderSymmetricKey'), CONVERT(VARBINARY, 'Lic009'))),
(19, EncryptByKey(Key_GUID('TraderSymmetricKey'), CONVERT(VARBINARY, 'Lic010')));

CLOSE SYMMETRIC KEY TraderSymmetricKey;

-- Employee
INSERT INTO Employee (employee_id, date_of_joining)
VALUES
(2, '2010-05-01'),
(4, '2011-06-02'),
(6, '2012-07-03'),
(8, '2013-08-04'),
(10, '2014-09-05'),
(12, '2015-10-06'),
(14, '2016-11-07'),
(16, '2017-12-08'),
(18, '2018-01-09'),
(20, '2019-02-10');

OPEN SYMMETRIC KEY TraderSymmetricKey
   DECRYPTION BY CERTIFICATE TraderCert;

INSERT INTO Login (login_id, username, [password], [login_type]) VALUES
(1, 'trader_john', ENCRYPTBYKEY(KEY_GUID('TraderSymmetricKey'), CONVERT(VARBINARY, 'pwd123')), 'T'),
(3, 'trader_alice', ENCRYPTBYKEY(KEY_GUID('TraderSymmetricKey'), CONVERT(VARBINARY, 'pwd234')), 'T'),
(5, 'trader_carol', ENCRYPTBYKEY(KEY_GUID('TraderSymmetricKey'), CONVERT(VARBINARY, 'pwd345')), 'T'),
(7, 'trader_eve', ENCRYPTBYKEY(KEY_GUID('TraderSymmetricKey'), CONVERT(VARBINARY, 'pwd456')), 'T'),
(9, 'trader_grace', ENCRYPTBYKEY(KEY_GUID('TraderSymmetricKey'), CONVERT(VARBINARY, 'pwd567')), 'T'),
(11, 'trader_isabel', ENCRYPTBYKEY(KEY_GUID('TraderSymmetricKey'), CONVERT(VARBINARY, 'pwd678')), 'T'),
(13, 'trader_cathy', ENCRYPTBYKEY(KEY_GUID('TraderSymmetricKey'), CONVERT(VARBINARY, 'pwd789')), 'T'),
(15, 'trader_mia', ENCRYPTBYKEY(KEY_GUID('TraderSymmetricKey'), CONVERT(VARBINARY, 'pwd890')), 'T'),
(17, 'trader_olivia', ENCRYPTBYKEY(KEY_GUID('TraderSymmetricKey'), CONVERT(VARBINARY, 'pwd901')), 'T'),
(19, 'trader_quinn', ENCRYPTBYKEY(KEY_GUID('TraderSymmetricKey'), CONVERT(VARBINARY, 'pwd012')), 'T'),
(2, 'employee_jane', ENCRYPTBYKEY(KEY_GUID('TraderSymmetricKey'), CONVERT(VARBINARY, 'pwd123')), 'E'),
(4, 'employee_bob', ENCRYPTBYKEY(KEY_GUID('TraderSymmetricKey'), CONVERT(VARBINARY, 'pwd234')), 'E'),
(6, 'employee_david', ENCRYPTBYKEY(KEY_GUID('TraderSymmetricKey'), CONVERT(VARBINARY, 'pwd345')), 'E'),
(8, 'employee_frank', ENCRYPTBYKEY(KEY_GUID('TraderSymmetricKey'), CONVERT(VARBINARY, 'pwd456')), 'E'),
(10, 'employee_henry', ENCRYPTBYKEY(KEY_GUID('TraderSymmetricKey'), CONVERT(VARBINARY, 'pwd567')), 'E'),
(12, 'employee_jack', ENCRYPTBYKEY(KEY_GUID('TraderSymmetricKey'), CONVERT(VARBINARY, 'pwd678')), 'E'),
(14, 'employee_leo', ENCRYPTBYKEY(KEY_GUID('TraderSymmetricKey'), CONVERT(VARBINARY, 'pwd789')), 'E'),
(16, 'employee_noah', ENCRYPTBYKEY(KEY_GUID('TraderSymmetricKey'), CONVERT(VARBINARY, 'pwd890')), 'E'),
(18, 'employee_paul', ENCRYPTBYKEY(KEY_GUID('TraderSymmetricKey'), CONVERT(VARBINARY, 'pwd901')), 'E'),
(20, 'employee_rachel', ENCRYPTBYKEY(KEY_GUID('TraderSymmetricKey'), CONVERT(VARBINARY, 'pwd012')), 'E');

CLOSE SYMMETRIC KEY TraderSymmetricKey;




OPEN SYMMETRIC KEY TraderSymmetricKey
   DECRYPTION BY CERTIFICATE TraderCert;

INSERT INTO Trader_Login (trader_login_id, social_security_number) VALUES
(1, ENCRYPTBYKEY(KEY_GUID('TraderSymmetricKey'), CONVERT(VARBINARY, CONVERT(INT, '123456')))),
(3, ENCRYPTBYKEY(KEY_GUID('TraderSymmetricKey'), CONVERT(VARBINARY, CONVERT(INT, '234567')))),
(5, ENCRYPTBYKEY(KEY_GUID('TraderSymmetricKey'), CONVERT(VARBINARY, CONVERT(INT, '345678')))),
(7, ENCRYPTBYKEY(KEY_GUID('TraderSymmetricKey'), CONVERT(VARBINARY, CONVERT(INT, '456789')))),
(9, ENCRYPTBYKEY(KEY_GUID('TraderSymmetricKey'), CONVERT(VARBINARY, CONVERT(INT, '567890')))),
(11, ENCRYPTBYKEY(KEY_GUID('TraderSymmetricKey'), CONVERT(VARBINARY, CONVERT(INT, '678901')))),
(13, ENCRYPTBYKEY(KEY_GUID('TraderSymmetricKey'), CONVERT(VARBINARY, CONVERT(INT, '789012')))),
(15, ENCRYPTBYKEY(KEY_GUID('TraderSymmetricKey'), CONVERT(VARBINARY, CONVERT(INT, '890123')))),
(17, ENCRYPTBYKEY(KEY_GUID('TraderSymmetricKey'), CONVERT(VARBINARY, CONVERT(INT, '901234')))),
(19, ENCRYPTBYKEY(KEY_GUID('TraderSymmetricKey'), CONVERT(VARBINARY, CONVERT(INT, '101010'))));

CLOSE SYMMETRIC KEY TraderSymmetricKey;




INSERT INTO Employee_Login (employee_login_id, department) VALUES
(2, 'HR'),
(4, 'Finance'),
(6, 'Marketing'),
(8, 'Sales'),
(10, 'IT'),
(12, 'Support'),
(14, 'HR'),
(16, 'Finance'),
(18, 'Marketing'),
(20, 'Finance');

INSERT INTO Company (company_ID, Company_name, date_of_registration) VALUES
(1, 'Tech Innovations', '2001-01-10'),
(2, 'Green Energy Solutions', '2002-02-20'),
(3, 'Advanced Robotics', '2003-03-30'),
(4, 'BioHealth Pharma', '2004-04-15'),
(5, 'Global Finances Inc', '2005-05-25'),
(6, 'NextGen Telecom', '2006-06-05'),
(7, 'EcoFriendly Materials', '2007-07-15'),
(8, 'Smart Home Systems', '2008-08-08'),
(9, 'Renewable Resources Ltd', '2009-09-09'),
(10, 'AI and Machine Learning Corp', '2010-10-10');

INSERT INTO Stock (stock_id, stock_name, price_on_listing, date_of_listing, quantity, stock_category_id, company_id) VALUES
(1, 'TechInnovate', 120.50, '2021-01-15', 10000, 1, 1),
(2, 'GreenEnSol', 98.75, '2021-02-17', 15000, 2, 2),
(3, 'AdvRobot', 110.20, '2021-03-20', 12000, 1, 3),
(4, 'BioHealth', 150.00, '2021-04-25', 8000, 3, 4),
(5, 'GloFinance', 135.65, '2021-05-30', 5000, 2, 5),
(6, 'NextTelecom', 85.75, '2021-06-10', 20000, 1, 6),
(7, 'EcoMat', 60.80, '2021-07-15', 10000, 3, 7),
(8, 'SmartHome', 110.40, '2021-08-21', 15000, 2, 8),
(9, 'RenewRes', 95.20, '2021-09-25', 12000, 1, 9),
(10, 'AIMachine', 125.55, '2021-10-30', 8000, 3, 10);

INSERT INTO Portfolio (portfolio_id, trader_id, number_of_stocks, current_amount, invested_amount) VALUES
(1, 1, 50, 6000.00, 5000.00),
(2, 3, 30, 3000.00, 2500.00),
(3, 5, 20, 2000.00, 1800.00),
(4, 7, 100, 10000.00, 9500.00),
(5, 9, 75, 7500.00, 7000.00),
(6, 11, 60, 6000.00, 5500.00),
(7, 13, 45, 4500.00, 4000.00),
(8, 15, 25, 2500.00, 2000.00),
(9, 17, 35, 3500.00, 3000.00),
(10, 19, 80, 8000.00, 7500.00);

INSERT INTO [Order] (order_id, date_of_order, [status], total_amount, total_stocks_count, pending_stocks_count, trader_id) VALUES
(1, '2021-11-01', 'Completed', 1200.00, 10, 0, 1),
(2, '2021-11-05', 'Pending', 3000.00, 25, 5, 3),
(3, '2021-11-10', 'Completed', 2500.00, 20, 0, 5),
(4, '2021-11-15', 'Processing', 5000.00, 40, 10, 7),
(5, '2021-11-20', 'Completed', 7500.00, 60, 0, 9),
(6, '2021-11-25', 'Pending', 6000.00, 50, 20, 11),
(7, '2021-11-30', 'Processing', 4500.00, 35, 15, 13),
(8, '2021-12-05', 'Completed', 2500.00, 25, 0, 15),
(9, '2021-12-10', 'Pending', 3500.00, 30, 10, 17),
(10, '2021-12-15', 'Completed', 8000.00, 70, 0, 19);

INSERT INTO Order_Stock (order_stock_id, order_id, stock_id, quantity, price_asked, margin, price_placed, [status], order_of_market_price, order_of_buy_price) VALUES
(1, 1, 1, 5, 240.00, 10.00, 250.00, 'Completed', 1, 1),
(2, 2, 2, 10, 980.00, 20.00, 1000.00, 'Pending', 1, 0),
(3, 3, 3, 15, 1650.00, 30.00, 1680.00, 'Completed', 0, 1),
(4, 4, 4, 20, 3000.00, 40.00, 3040.00, 'Processing', 1, 0),
(5, 5, 5, 25, 3390.00, 50.00, 3440.00, 'Completed', 0, 1),
(6, 6, 6, 30, 2570.00, 60.00, 2630.00, 'Pending', 1, 1),
(7, 7, 7, 35, 2130.00, 70.00, 2200.00, 'Processing', 0, 0),
(8, 8, 8, 40, 4410.00, 80.00, 4490.00, 'Completed', 1, 0),
(9, 9, 9, 45, 4280.00, 90.00, 4370.00, 'Pending', 0, 1),
(10, 10, 10, 50, 6270.00, 100.00, 6370.00, 'Completed', 1, 1);

INSERT INTO Portfolio_Stock (portfolio_stock_id, portfolio_id, stock_id, quantity, purchase_price, current_price) VALUES
(1, 1, 1, 5, 600.00, 620.00),
(2, 2, 2, 10, 980.00, 1000.00),
(3, 3, 3, 15, 1650.00, 1680.00),
(4, 4, 4, 20, 3000.00, 3040.00),
(5, 5, 5, 25, 3390.00, 3440.00),
(6, 6, 6, 30, 2570.00, 2630.00),
(7, 7, 7, 35, 2130.00, 2200.00),
(8, 8, 8, 40, 4410.00, 4490.00),
(9, 9, 9, 45, 4280.00, 4370.00),
(10, 10, 10, 50, 6270.00, 6370.00);


INSERT INTO Wishlist (wishlist_id, trader_id, [description]) VALUES
(1, 1, 'Tech and green energy stocks'),
(2, 3, 'Healthcare and biotech focus'),
(3, 5, 'Interested in emerging tech'),
(4, 7, 'Diverse portfolio interests'),
(5, 9, 'Looking for stable, long-term investments'),
(6, 11, 'Interested in high-risk, high-reward options'),
(7, 13, 'Focus on sustainable and eco-friendly companies'),
(8, 15, 'Looking for dividend-paying stocks'),
(9, 17, 'Tech startups and innovative companies'),
(10, 19, 'Interested in international markets');


INSERT INTO Wishlist_Stock (wishlist_stock_id, stock_id, wishlist_id, [priority_level]) VALUES
(1, 1, 1, 1),   -- High priority (1) for TechCorp stock in wishlist 1
(2, 2, 2, 2),   -- Priority level 2 for GreenEnergy stock in wishlist 2
(3, 3, 3, 3),   -- Priority level 3 for HealthPlus stock in wishlist 3
(4, 4, 4, 4),   -- Priority level 4 for FastTravel stock in wishlist 4
(5, 5, 5, 5),   -- Priority level 5 for BioFood stock in wishlist 5
(6, 6, 6, 6),   -- Priority level 6 for EduTech stock in wishlist 6
(7, 7, 7, 7),   -- Priority level 7 for OceanClean stock in wishlist 7
(8, 8, 8, 8),   -- Priority level 8 for SolarPower stock in wishlist 8
(9, 9, 9, 9),   -- Priority level 9 for AIAdvance stock in wishlist 9
(10, 10, 10, 10); -- Lowest priority (10) for NanoMaterials stock in wishlist 10