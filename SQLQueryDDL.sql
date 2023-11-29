
Create database trading_platform


use trading_platform

CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'Avengers@2023';

CREATE CERTIFICATE TraderCert WITH SUBJECT = 'Trader Data Encryption';

CREATE SYMMETRIC KEY TraderSymmetricKey
WITH ALGORITHM = AES_256
ENCRYPTION BY CERTIFICATE TraderCert;



-- Supertype table
CREATE TABLE Person (
    person_id INT PRIMARY KEY,
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    mobile_no VARCHAR(10),
    email VARCHAR(50),
    date_of_birth DATE,
    street_name VARCHAR(250),
    zipcode INT,
    city VARCHAR(50),
    [state] VARCHAR(10),
    [type] VARCHAR(1), -- This column is used to indicate the subtype
    CONSTRAINT CHK_Person_DateOfBirth CHECK (date_of_birth <= GETDATE())
);


-- Creating the subtype table 'Trader' that references supertype 'Person'
CREATE TABLE Trader (
    trader_id INT PRIMARY KEY,
    license_number VARBINARY(8000), -- Changed to VARBINARY for encrypted data
    FOREIGN KEY (trader_id) REFERENCES Person(person_id)
);

-- Creating the subtype table 'Employee' that references supertype 'Person'

CREATE TABLE Employee (
    employee_id INT PRIMARY KEY,
    date_of_joining DATE,
    FOREIGN KEY (employee_id) REFERENCES Person(person_id)
);

-- Step 4: Create the Login table with encrypted password column
CREATE TABLE Login (
    login_id INT PRIMARY KEY,
    username VARCHAR(255) NOT NULL,
    [password] VARBINARY(256) NOT NULL, -- Storing encrypted data
    [login_type] VARCHAR(1) NOT NULL,
    FOREIGN KEY (login_id) REFERENCES Person(person_id)
);

-- Creating the subtype table 'Trader_Login' that references 'Login'
CREATE TABLE Trader_Login (
    trader_login_id INT PRIMARY KEY,
    social_security_number VARBINARY(128), -- Changed to VARBINARY to store encrypted data
    FOREIGN KEY (trader_login_id) REFERENCES Login(login_id)
);

-- Creating the subtype table 'Employee_Login' that references 'Login'
CREATE TABLE Employee_Login (
    employee_login_id INT PRIMARY KEY,
    department VARCHAR(10),
    FOREIGN KEY (employee_login_id) REFERENCES Login(login_id)
);

-- Creating the 'Portfolio' table
CREATE TABLE Portfolio (
    portfolio_id INT PRIMARY KEY,
    trader_id INT,
    number_of_stocks INT,
    current_amount DECIMAL(15,2), -- Assuming a precision of 15 digits with 2 decimal places
    invested_amount DECIMAL(15,2) -- Assuming a precision of 15 digits with 2 decimal places
    FOREIGN KEY (trader_id) REFERENCES Trader(trader_id)
);


-- Creating the 'Order' table
CREATE TABLE [Order] (
    order_id INT PRIMARY KEY,
    date_of_order DATE,
    [status] VARCHAR(50),
    total_amount DECIMAL(15,2),
    total_stocks_count INT,
    pending_stocks_count INT,
    trader_id INT,
    FOREIGN KEY (trader_id) REFERENCES Trader(trader_id),
    CHECK (total_amount >= 0), -- Ensure total_amount is non-negative
    CHECK (total_stocks_count >= 0), -- Ensure total_stocks_count is non-negative
    CHECK (pending_stocks_count >= 0) -- Ensure pending_stocks_count is non-negative
);


CREATE TABLE Company (
    company_ID INT PRIMARY KEY,
    Company_name VARCHAR(255),
    date_of_registration DATE
);

CREATE FUNCTION dbo.CalculateStockValue (@quantity INT, @price DECIMAL(15,2))
RETURNS DECIMAL(15,2)
AS
BEGIN
    RETURN @quantity * @price
END


CREATE TABLE Stock (
    stock_id INT PRIMARY KEY,
    stock_name VARCHAR(255),
    price_on_listing DECIMAL (15,2),
    date_of_listing DATE,
    quantity INT,
	total_value AS dbo.CalculateStockValue(quantity, price_on_listing),
    stock_category_id INT,
    company_id INT,
    FOREIGN KEY (company_id) REFERENCES Company(company_id)
);

-- Creating the 'Order_Stock' table
CREATE TABLE Order_Stock (
    order_stock_id INT PRIMARY KEY,
    order_id INT,
    stock_id INT,
    quantity INT,
    price_asked DECIMAL(15,2),
    margin DECIMAL(15,2),
    price_placed DECIMAL(15,2),
    status VARCHAR(50),
    order_of_market_price INT,
    order_of_buy_price INT,
    FOREIGN KEY (order_id) REFERENCES [Order](order_id),
    FOREIGN KEY (stock_id) REFERENCES Stock(stock_id)
);

CREATE FUNCTION TotalStockValue(@number_of_stocks INT, @current_price DECIMAL(15,2))
RETURNS DECIMAL(15,2)
AS
BEGIN
    RETURN (@number_of_stocks * @current_price)
END

-- Creating the 'Portfolio_Stock' table
CREATE TABLE Portfolio_Stock (
    portfolio_stock_id INT PRIMARY KEY,
    portfolio_id INT,
    stock_id INT,
    quantity INT CHECK (quantity > 0),  -- Ensure quantity is positive
    purchase_price DECIMAL(15,2) CHECK (purchase_price >= 0), -- Ensure purchase price is non-negative
    current_price DECIMAL(15,2) CHECK (current_price >= 0),  -- Ensure current price is non-negative
    total_stock_value AS dbo.TotalStockValue(quantity, current_price), -- Computed column
    FOREIGN KEY (portfolio_id) REFERENCES Portfolio(portfolio_id),
    FOREIGN KEY (stock_id) REFERENCES Stock(stock_id)
);



-- Creating the 'Wishlist' table
CREATE TABLE Wishlist (
    wishlist_id INT PRIMARY KEY,
    trader_id INT,
	[description] varchar(250)
    FOREIGN KEY (trader_id) REFERENCES Trader(trader_id)
);

-- Creating the 'Wishlist_Stock' table
CREATE TABLE Wishlist_Stock (
    wishlist_stock_id INT PRIMARY KEY,
    stock_id INT,
	wishlist_id INT,
	[priority_level] INT,
    FOREIGN KEY (wishlist_id) REFERENCES Wishlist(wishlist_id),
    FOREIGN KEY (stock_id) REFERENCES Stock(stock_id)
);

CREATE TRIGGER UpdateOrder 
ON [order]
AFTER UPDATE  
AS
BEGIN
    -- Assuming that only one row will be updated at a time
    DECLARE @order_id INT, @status VARCHAR(50);

    SELECT @order_id = order_id, @status = [status] FROM inserted;

    IF @status = 'completed'
    BEGIN
        UPDATE [order]
        SET pending_stocks_count = pending_stocks_count - 1
        WHERE order_id = @order_id;
    END;
END;


CREATE TRIGGER UpdatePortfolioStockCurrentPrice
ON Stock
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE ps
    SET ps.current_price = i.price_on_listing
    FROM portfolio_stock AS ps
    INNER JOIN inserted AS i ON ps.stock_id = i.stock_id;
END;





CREATE NONCLUSTERED INDEX IDX_Person_LastName_Email ON Person (last_name, email);
CREATE NONCLUSTERED INDEX IDX_Order_Date_Status ON [Order] (date_of_order, [status]);
CREATE NONCLUSTERED INDEX IDX_Stock_CategoryID_Price ON Stock (stock_category_id, price_on_listing);

CREATE FUNCTION dbo.CalculateProfitOrLoss (@portfolio_stock_id INT, @selling_price DECIMAL(15,2))
RETURNS DECIMAL(15,2)
AS
BEGIN
    DECLARE @profit_or_loss DECIMAL(15,2)
    DECLARE @purchase_price DECIMAL(15,2)
    DECLARE @quantity INT

    SELECT @purchase_price = purchase_price, @quantity = quantity
    FROM Portfolio_Stock
    WHERE portfolio_stock_id = @portfolio_stock_id

    SET @profit_or_loss = (@selling_price - @purchase_price) * @quantity

    RETURN @profit_or_loss
END


CREATE FUNCTION dbo.GetTraderAge (@trader_id INT)
RETURNS INT
AS
BEGIN
    DECLARE @dob DATE
    DECLARE @age INT

    SELECT @dob = date_of_birth
    FROM Person
    WHERE person_id = @trader_id

    SET @age = DATEDIFF(YEAR, @dob, GETDATE())
    IF (MONTH(@dob) > MONTH(GETDATE())) OR (MONTH(@dob) = MONTH(GETDATE()) AND DAY(@dob) > DAY(GETDATE()))
        SET @age = @age - 1

    RETURN @age
END



CREATE PROCEDURE allStocksOfATrader 
    @TraderID INT,
    @ResultMessage NVARCHAR(255) OUTPUT
AS
BEGIN
    SELECT P.stock_id, S.stock_name, P.quantity, P.purchase_price, P.current_price
    FROM Portfolio_Stock P
    INNER JOIN Stock S ON P.stock_id = S.stock_id
    WHERE P.portfolio_id IN (
        SELECT portfolio_id
        FROM Portfolio
        WHERE trader_id = @TraderID
    )
    SET @ResultMessage = 'Stocks retrieved successfully.'
END
GO

-- Example trader ID and ResultMessage declaration
DECLARE @TraderID INT = 1;
DECLARE @ResultMessage NVARCHAR(255);

-- Execute the stored procedure
EXECUTE allStocksOfATrader 
    @TraderID = @TraderID,
    @ResultMessage = @ResultMessage OUTPUT;

-- Output the result message
SELECT @ResultMessage AS OutputMessage;





CREATE PROCEDURE GetTraderPortfolioSummary
    @TraderID INT,
    @TotalInvestment DECIMAL(15,2) OUTPUT,
    @TotalCurrentValue DECIMAL(15,2) OUTPUT
AS
BEGIN
    SELECT 
        @TotalInvestment = SUM(invested_amount), 
        @TotalCurrentValue = SUM(current_amount)
    FROM Portfolio
    WHERE trader_id = @TraderID
END


DECLARE @TraderID INT = 1; -- Example trader ID
DECLARE @TotalInvestment DECIMAL(15,2);
DECLARE @TotalCurrentValue DECIMAL(15,2);

EXEC GetTraderPortfolioSummary 
    @TraderID = @TraderID,
    @TotalInvestment = @TotalInvestment OUTPUT,
    @TotalCurrentValue = @TotalCurrentValue OUTPUT;

SELECT @TotalInvestment AS TotalInvestment, @TotalCurrentValue AS TotalCurrentValue;




CREATE PROCEDURE GetTraderStocksAndOrders
    @TraderID INT
AS
BEGIN
    SELECT 
        ps.stock_id, 
        s.stock_name, 
        ps.quantity AS stock_quantity, 
        ps.current_price, 
        ps.purchase_price, 
        o.order_id, 
        o.date_of_order, 
        o.total_amount, 
        o.[status]
    FROM Portfolio_Stock ps
    INNER JOIN Stock s ON ps.stock_id = s.stock_id
    LEFT JOIN [Order] o ON ps.portfolio_id = o.trader_id
    WHERE ps.portfolio_id IN (
        SELECT portfolio_id
        FROM Portfolio
        WHERE trader_id = @TraderID
    )
    AND o.trader_id = @TraderID;
END;
GO


DECLARE @TraderID INT = 1; -- Example trader ID

EXEC GetTraderStocksAndOrders @TraderID = @TraderID;







CREATE VIEW activeTraderPortfolios AS
SELECT p.trader_id, 
       t.license_number, 
       p.number_of_stocks, 
       p.current_amount, 
       p.invested_amount
FROM Portfolio p
JOIN Trader t ON p.trader_id = t.trader_id
WHERE p.current_amount > 0;
GO

SELECT * FROM activeTraderPortfolios;




CREATE VIEW wishlistStockDetails AS
SELECT ws.wishlist_id, 
       t.trader_id, 
       s.stock_name, 
       ws.priority_level
FROM Wishlist_Stock ws
JOIN Wishlist w ON ws.wishlist_id = w.wishlist_id
JOIN Trader t ON w.trader_id = t.trader_id
JOIN Stock s ON ws.stock_id = s.stock_id;
GO

SELECT * FROM wishlistStockDetails
ORDER BY wishlist_id, priority_level;



CREATE VIEW TraderProfile AS
SELECT 
    p.person_id, 
    p.first_name, 
    p.last_name, 
    p.mobile_no, 
    p.email, 
    p.date_of_birth, 
    p.street_name, 
    p.zipcode, 
    p.city, 
    p.[state], 
    t.license_number
FROM 
    Person p
JOIN 
    Trader t ON p.person_id = t.trader_id
WHERE 
    p.type = 'T';
GO

SELECT * FROM TraderProfile;
