-- DATA2201 - Relational databases 23SEPMNTR2 - Michael Dorsey
-- Project - Phase 2

-- GROUP D
-- Fabio Augusto Weck		ID: 441977
-- Lorenzo Liwanag			ID: 452203
-- Hugo Zeminian Camargo	ID: 440258

--================================= ||       PHASE 2     || =================================--

-- Hugo Camargo --

--== Util Procedures. ==-- (*not required)

--Procedures created to facilitate user creation and tests

USE SKSBank;

-- Procedure to CHECK if the user exists (procedure for testing the user creation - *not required)
CREATE PROCEDURE sp_CheckIsTheUserExist
	@username NVARCHAR(255)
AS
BEGIN
	IF EXISTS (
		SELECT 1
		FROM sys.database_principals
		WHERE name = @username AND type_desc = 'SQL_USER'
	)
	BEGIN
		PRINT 'User ' + @username + ' exists.';
	END
	ELSE
	BEGIN
		PRINT '*** User ' + @username + ' does not exist. ***';
	END;
END;

-- Procedure to DELETE users (procedure to facilitate user deletion - *not required)
CREATE PROCEDURE sp_DeleteUser
    @username NVARCHAR(255)
AS
BEGIN

	IF EXISTS (
		SELECT 1
		FROM sys.database_principals
		WHERE name = @username AND type_desc = 'SQL_USER'
	)
	BEGIN
		DECLARE @dropUserSql NVARCHAR(255);
		SET @dropUserSql = 
			'DROP USER [' + @username + '];';
		EXEC sp_executesql @dropUserSql;

		DECLARE @dropLoginSql NVARCHAR(255);
		SET @dropLoginSql = 
			'DROP LOGIN [' + @username + '];';
		EXEC sp_executesql @dropLoginSql;

		PRINT '### User ' + @username + ' deleted. ###';
	END
	ELSE
	BEGIN
		PRINT '*** User ' + @username + ' does not exist. ***';
	END;
END;

--== STEP 1. Create different levels of users and assign appropriate privileges. ==--

/*
•	Create a user named “customer_group_[?]” where [?] is your group letter. For example, 
	“customer_group_B”. Have the user’s password be “customer”. When you login with this 
	account you should be able to read only the tables that are related to customers 
	(such as customer, account, loan and payment tables). 
	Provide a SQL script to test that you have properly enforced the privileges. 
*/

-- Procedure to create ### CUSTOMER ### user and give appropriate access level
CREATE PROCEDURE sp_CreateCustomerUserWithPrivileges
    @username NVARCHAR(255),
    @password NVARCHAR(255)
AS
BEGIN
    -- Create LOGIN
    DECLARE @userStatement NVARCHAR(MAX)
	SET @userStatement =
        'CREATE LOGIN ' + QUOTENAME(@username) + ' WITH PASSWORD = ''' + @password + '''';
    EXEC sp_executesql @userStatement;


    -- Create USER
    DECLARE @loginStatement NVARCHAR(MAX)
	SET @loginStatement =
        'CREATE USER ' + QUOTENAME(@username) + ' FOR LOGIN ' + QUOTENAME(@username);
    EXEC sp_executesql @loginStatement;


    -- Grant PRIVILEGES
	-- SELECT
    -- List of tables to grant select privilege
    DECLARE @tables TABLE (TableName NVARCHAR(255));
    INSERT INTO @tables VALUES 
	('Location'),		
	('Branch'),				
	('Employee'),		
	('Employee_Location'),		
	('Account'),
	('Customer'),		
	('Account_Customer'),   
	('Employee_Customer'), 
	('Loan'), 
	('Loan_Customer'),
    ('Operation'), 
	('Transactions'), 
	('Overdrafts');

	-- Loop variables
	DECLARE @tableCount INT;
	DECLARE @counter INT;
	DECLARE @tableName NVARCHAR(255);
	DECLARE @grantStatement NVARCHAR(MAX);

	SET @counter = 1;

	-- Temporary table to store the results of the CTE
	CREATE TABLE #TempNumberedTables (
		TableName NVARCHAR(255),
		RowNum INT
	);

	-- Check the number of the row
	WITH NumberedTables AS (
		SELECT TableName, ROW_NUMBER() OVER (ORDER BY TableName) AS RowNum
		FROM @tables
	)
	-- Insert the CTE results into the temporary table
	INSERT INTO #TempNumberedTables
	SELECT * FROM NumberedTables;

	-- Assign the table count
	SELECT @tableCount = COUNT(*) FROM #TempNumberedTables;

	-- Loop through tables and grant select privilege
	WHILE @counter <= @tableCount
	BEGIN
		SELECT @tableName = TableName
		FROM #TempNumberedTables
		WHERE RowNum = @counter;

		SET @grantStatement =
			'GRANT SELECT ON OBJECT::' + QUOTENAME(@tableName) + ' TO ' + QUOTENAME(@username);
		EXEC sp_executesql @grantStatement;

		SET @counter = @counter + 1;
	END;

	-- Drop the temporary table
	DROP TABLE #TempNumberedTables;

END;

/*
•	Create a user named “accountant_group_[?]” where [?] is your group letter. 
	For example, “accountant_group_F”. Have the user’s password be “accountant”. 
	When you login with this account you should be able to read all tables, 
	but cannot update account, payment and loan tables. 
	Provide a SQL script to test that you have properly enforced the privileges.
*/

-- Procedure to create ### ACCOUNTANT ### user and give appropriate access level
CREATE PROCEDURE sp_CreateAccountantUserWithPrivileges
    @username NVARCHAR(255),
    @password NVARCHAR(255)
AS
BEGIN
    -- Create LOGIN
    DECLARE @userStatement NVARCHAR(MAX)
	SET @userStatement =
        'CREATE LOGIN ' + QUOTENAME(@username) + ' WITH PASSWORD = ''' + @password + '''';
    EXEC sp_executesql @userStatement;


    -- Create USER
    DECLARE @loginStatement NVARCHAR(MAX)
	SET @loginStatement =
        'CREATE USER ' + QUOTENAME(@username) + ' FOR LOGIN ' + QUOTENAME(@username);
    EXEC sp_executesql @loginStatement;

	 -- Grant PRIVILEGES
	 -- SELECT
	DECLARE @selectPrivilegeStatement NVARCHAR(MAX)
	SET @selectPrivilegeStatement =
		'GRANT SELECT ON SCHEMA::dbo' + ' TO ' + QUOTENAME(@username);
    EXEC sp_executesql @selectPrivilegeStatement;

	-- UPDATE
	-- List of tables to grant update privilege
    DECLARE @tables TABLE (TableName NVARCHAR(255));
    INSERT INTO @tables VALUES 
	('Location'),		
	('Branch'),				
	('Employee'),		
	('Employee_Location'),		
	('Customer'),		
	('Account_Customer'),   
	('Employee_Customer'), 
	('Loan_Customer'),
    ('Operation');

		-- Loop variables
	DECLARE @tableCount INT;
	DECLARE @counter INT;
	DECLARE @tableName NVARCHAR(255);
	DECLARE @grantStatement NVARCHAR(MAX);

	SET @counter = 1;

	-- Temporary table to store the results of the CTE
	CREATE TABLE #TempNumberedTables (
		TableName NVARCHAR(255),
		RowNum INT
	);

	-- Check the number of the row
	WITH NumberedTables AS (
		SELECT TableName, ROW_NUMBER() OVER (ORDER BY TableName) AS RowNum
		FROM @tables
	)
	-- Insert the CTE results into the temporary table
	INSERT INTO #TempNumberedTables
	SELECT * FROM NumberedTables;

	-- Assign the table count
	SELECT @tableCount = COUNT(*) FROM #TempNumberedTables;

	-- Loop through tables and grant select privilege
	WHILE @counter <= @tableCount
	BEGIN
		SELECT @tableName = TableName
		FROM #TempNumberedTables
		WHERE RowNum = @counter;

		SET @grantStatement =
			'GRANT UPDATE ON OBJECT::' + QUOTENAME(@tableName) + ' TO ' + QUOTENAME(@username);
		EXEC sp_executesql @grantStatement;

		SET @counter = @counter + 1;
	END;

	-- Drop the temporary table
	DROP TABLE #TempNumberedTables;
END;


-- Please run the following procedures to create CUSTOMER USERS --
EXEC sp_CreateCustomerUserWithPrivileges	@username = 'customer_group_D',			@password = 'customer';

--Users used for testing only (*not required)
--EXEC sp_CreateCustomerUserWithPrivileges	@username = 'customer_441977',			@password = 'customer';			-- Fabio Augusto Weck		ID: 441977
--EXEC sp_CreateCustomerUserWithPrivileges	@username = 'customer_452203',			@password = 'customer';			-- Lorenzo Liwanag			ID: 452203
--EXEC sp_CreateCustomerUserWithPrivileges	@username = 'customer_440258',			@password = 'customer';			-- Hugo Zeminian Camargo	ID: 440258

-- Please run the following procedures to create ACCOUNTANT USERS --
EXEC sp_CreateAccountantUserWithPrivileges	@username = 'accountant_group_D',		@password = 'accountant';

--Users used for testing only (*not required)
--EXEC sp_CreateAccountantUserWithPrivileges	@username = 'accountant_441977',		@password = 'accountant';		-- Fabio Augusto Weck		ID: 441977
--EXEC sp_CreateAccountantUserWithPrivileges	@username = 'accountant_452203',		@password = 'accountant';		-- Lorenzo Liwanag			ID: 452203
--EXEC sp_CreateAccountantUserWithPrivileges	@username = 'accountant_440258',		@password = 'accountant';		-- Hugo Zeminian Camargo	ID: 440258


-- Check if user exist (*not required)
EXEC sp_CheckIsTheUserExist					@username = 'customer_group_D';
--EXEC sp_CheckIsTheUserExist					@username = 'customer_441977';
--EXEC sp_CheckIsTheUserExist					@username = 'customer_452203';
--EXEC sp_CheckIsTheUserExist					@username = 'customer_440258';

EXEC sp_CheckIsTheUserExist					@username = 'accountant_group_D';
--EXEC sp_CheckIsTheUserExist					@username = 'accountant_441977';
--EXEC sp_CheckIsTheUserExist					@username = 'accountant_452203';
--EXEC sp_CheckIsTheUserExist					@username = 'accountant_440258';

-- Delete the user (*not required)
--EXEC sp_DeleteUser							@username = 'customer_441977';
--EXEC sp_DeleteUser							@username = 'customer_452203';
--EXEC sp_DeleteUser							@username = 'customer_440258';

--EXEC sp_DeleteUser							@username = 'accountant_441977';
--EXEC sp_DeleteUser							@username = 'accountant_452203';
--EXEC sp_DeleteUser							@username = 'accountant_440258';


--====|| User testing query  ||====--

-- Provide a SQL script to test that you have properly enforced the privileges.

-- CUSTOMER Tests
CREATE PROCEDURE sp_CustomerOperationsTest
    @username NVARCHAR(255)
AS
BEGIN
    DECLARE @userContext NVARCHAR(255) = QUOTENAME(@username);

    -- Dynamic SQL to set user context
    DECLARE @executeAsStatement NVARCHAR(MAX) =
        'EXECUTE AS USER = ' + @userContext;
    EXEC sp_executesql @executeAsStatement;

    -- SELECT operations
	SELECT * FROM Loan;	-- (Customers can retrieve information from Loan table)
	SELECT * FROM Account;	-- (Customers can retrieve information from Account table)
	
	-- UPDATE operation
	UPDATE Account SET Balance = Balance + 100 WHERE AccountID = 1;	-- (Customers cannot update Account table)

    -- Revert to the original user
    REVERT;
END;

-- Running the procedure, the messages tab must show a forbidden operation (update on Account table)
-- Results tab must properly show tables selected (Location and Account tables)
EXEC sp_CustomerOperationsTest @username = 'customer_group_D'; 

-- ACCOUNTANT Tests
CREATE PROCEDURE sp_AccountantOperationsTest
    @username NVARCHAR(255)
AS
BEGIN
    DECLARE @userContext NVARCHAR(255) = QUOTENAME(@username);

    -- Dynamic SQL to set user context
    DECLARE @executeAsStatement NVARCHAR(MAX) =
        'EXECUTE AS USER = ' + @userContext;
    EXEC sp_executesql @executeAsStatement;

    -- SELECT operations
	SELECT * FROM Location;	-- (Accountants can retrieve information from Location table)
    SELECT * FROM Account;	-- (Accountants can retrieve information from Account table)
    

    -- UPDATE operation
    UPDATE Location SET City = 'New city Calgary' WHERE LocationID = 1; -- (Accountants can update Location table)
    SELECT * FROM Location;

    UPDATE Account SET Balance = Balance + 100 WHERE AccountID = 1;	-- (Accountants cannot update Account table)
	SELECT * FROM Account;

    -- Revert to the original user
    REVERT;
END;

-- Running the procedure, the messages tab must show a forbidden operation (update on Account table)
-- and an update operation on table Location.
-- Results tab must properly show tables selected (Location and Account tables)
EXEC sp_AccountantOperationsTest @username = 'accountant_group_D';


--== STEP 2. Create triggers to monitor the different DML and DDL activities on your database. ==--

--Lorenzo Liwanag

CREATE TABLE Audit
(

ID INT PRIMARY KEY IDENTITY(1,1),
Message NVARCHAR(MAX),
Timestamp DATETIME DEFAULT GETDATE()

)

--Trigger For New Customer Creation
CREATE TRIGGER tg_NewCustomerCreated
ON Customer
AFTER INSERT
AS
BEGIN 
DECLARE @CustomerID INT, @CustomerName NVARCHAR(255), @CustomerAddress NVARCHAR(255);
SELECT @CustomerID = CustomerID, @CustomerName = CustomerName, @CustomerAddress = CustomerAddress
FROM inserted;    
INSERT INTO SKSBank.dbo.Audit (Message)    
VALUES ('New customer created. CustomerID: ' + CAST(@CustomerID AS NVARCHAR(10)) + ', CustomerName: ' + @CustomerName + ', CustomerAddress: ' + @CustomerAddress);
END;

--Test audit table
INSERT INTO Customer VALUES ('Fabio Augusto', 'Hogwarts 1011');
INSERT INTO Customer VALUES ('Joaquim Weck', '9090 Jd. Primavera');

--Trigger For a Loan payment
CREATE TRIGGER tg_LoanPayment
ON Transactions
AFTER INSERT
AS 
BEGIN
	DECLARE @LoanID INT, 
			@Balance MONEY,
			@OperationID INT,
			@Amount MONEY,
			@AccountID INT;
	SELECT  @LoanID = i.LoanID,
			@AccountID = I.AccountID,
			@OperationID = i.OperationID,
			@Amount = i.Amount
			FROM inserted i
	SELECT @Balance = Balance FROM Loan WHERE LoanID = @LoanID
	IF @OperationID = 4 AND @LoanID IS NOT NULL
	BEGIN
		UPDATE Loan SET Balance = @Balance - @Amount WHERE LoanID = @LoanID
		SELECT @Balance = Balance FROM Loan WHERE LoanID = @LoanID
		INSERT INTO SKSBank.dbo.Audit (Message)    
		VALUES 
		(
			'Loan payment for LoanID ' + CAST(@LoanID AS NVARCHAR(10)) +
			' was made on account ID ' + CAST(@AccountID AS NVARCHAR(5)) +
			'. Remaining balance is: ' + CAST((@Balance) AS NVARCHAR(20))
		);
	END;
END;

--Test audit table
INSERT INTO Transactions(OperationID, Amount, AccountID, LoanID) VALUES (4, 200, 14, 3);
INSERT INTO Transactions(OperationID, Amount, AccountID, LoanID) VALUES (4, 170, 6, 1);

--Trigger for a new savings account opened

CREATE TRIGGER trg_NewSavingsAccount
ON Account_Customer
AFTER INSERT
AS
BEGIN
	DECLARE @AccountID INT, @CustomerName NVARCHAR(255), @BranchName NVARCHAR(255), @IsSaving BIT;
	SELECT @AccountID = a.AccountID, 
		   @BranchName = a.BranchName, 
		   @CustomerName = c.CustomerName,
		   @IsSaving = a.isSaving
	FROM inserted i
	JOIN Account a ON i.AccountID = a.AccountID
	JOIN Customer c ON i.CustomerID = c.CustomerID;
	IF @IsSaving = 1
	BEGIN
		INSERT INTO dbo.Audit (Message)    
		VALUES ('New savings account opened. Account ID: ' + CAST(@AccountID AS NVARCHAR(10)) + 
				', Customer Name: ' + @CustomerName + 
				', Branch Name: ' + @BranchName);
	END
END;

--Test audit table
INSERT INTO Account(isSaving, BranchName, Balance, InterestRate) VALUES (1, 'Main Branch', 100, 0.35);
INSERT INTO Account(isSaving, BranchName, Balance, InterestRate) VALUES (1, 'Red Deer Branch', 100, 0.35);
INSERT INTO Account_Customer VALUES (18, 21);
INSERT INTO Account_Customer VALUES (19, 22);

----== STEP 3. Create an index based on frequently used attributes for three of any table. ==--

--Fabio Augusto Weck

-- 1. Replace the default clustered index of any table with a new clustered index that uses a non-key attribute.

-- Check the indexes of a table and find the index file name
EXEC sp_helpindex 'Overdrafts';

BEGIN
	ALTER TABLE Overdrafts
	DROP CONSTRAINT PK__Overdraf__453A6F31AACDD2C5; -- Drops the table constraint 
	CREATE CLUSTERED INDEX cix_overdrafts_amount ON Overdrafts(Amount);
END


--2. Replace the default clustered index of any table with a new composite clustered index.

-- Check the indexes of a table and find the index file name
EXEC sp_helpindex 'Operation';

BEGIN
	ALTER TABLE Transactions
	DROP CONSTRAINT FK__Transacti__Opera__5EBF139D;

	ALTER TABLE Operation
	DROP CONSTRAINT PK__Operatio__A4F5FC64678EDC68; -- Drops the constraint

	CREATE CLUSTERED INDEX cix_operation_id_description ON Operation(OperationID, [Description]);
END

--3. Create a composite nonclustered index for any table.

EXEC sp_helpindex 'Employee'; -- Checks if any other non clustered index constraint must be dropped 

CREATE NONCLUSTERED INDEX ncix_employee_name_ismanager ON Employee(EmpName, isManager); 


--== STEP 4. Alter your database to include a table that can store JSON records. ==--

--Fabio Augusto Weck

ALTER TABLE Customer ADD CustomerInfoJson VARCHAR(MAX);

BEGIN
	DECLARE @counter INT = 1;
	DECLARE @noOfRows INT = (SELECT COUNT(*) FROM Customer)
	WHILE(@counter <= @noOfRows)
		BEGIN
			DECLARE @json VARCHAR(MAX) = (SELECT CustomerID, CustomerName, CustomerAddress 
										  FROM Customer 
										  WHERE CustomerID = @counter 
										  FOR JSON AUTO, INCLUDE_NULL_VALUES, WITHOUT_ARRAY_WRAPPER);
			UPDATE Customer SET CustomerInfoJson = @json WHERE CustomerID = @counter;
			SET @counter += 1;
		END
END

--== STEP 5. Alter your database to include a table that can store Spatial information. ==--

--Fabio Augusto Weck

-- Add a new column to table 'Location' to store spatial data
ALTER TABLE [Location] ADD SpatialLocation geography;

-- Declare all spatial data to be stored and update the table
BEGIN
	DECLARE @Calgary1	geography = geography::STPointFromText('POINT(-114.07877515282645 51.043917714294345)',	4326); 
	DECLARE @Calgary2	geography = geography::STPointFromText('POINT(-114.07502816768104 51.05070298938732)',	4326);
	DECLARE @Edmonton1	geography = geography::STPointFromText('POINT(-113.48534101374916 53.52638998791837)',	4326);
	DECLARE @Edmonton2	geography = geography::STPointFromText('POINT(-113.52138103772839 53.55159635125876)',	4326);
	DECLARE @RedDeer1	geography = geography::STPointFromText('POINT(-113.82227132843188 52.27972197604645)',	4326);
	DECLARE @Calgary3	geography = geography::STPointFromText('POINT(-114.06380291835902 50.977375299200126)', 4326);
	DECLARE @Calgary4	geography = geography::STPointFromText('POINT(-114.05687026552819 51.12093166988201)',	4326);

	UPDATE [Location] SET SpatialLocation = @Calgary1 WHERE LocationID = 1;
	UPDATE [Location] SET SpatialLocation = @Calgary2 WHERE LocationID = 2;
	UPDATE [Location] SET SpatialLocation = @Edmonton1 WHERE LocationID = 3;
	UPDATE [Location] SET SpatialLocation = @Edmonton2 WHERE LocationID = 4;
	UPDATE [Location] SET SpatialLocation = @RedDeer1 WHERE LocationID = 5;
	UPDATE [Location] SET SpatialLocation = @Calgary3 WHERE LocationID = 6;
	UPDATE [Location] SET SpatialLocation = @Calgary4 WHERE LocationID = 7;
END


--BACKUP FILE

BACKUP DATABASE SKSBank TO DISK = 'D:\projectGroupD.bak';
