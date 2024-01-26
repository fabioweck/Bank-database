
-- DATA2201 - Relational databases 23SEPMNTR2 - Michael Dorsey
-- Project - Phase 1

-- GROUP D
-- Fabio Augusto Weck
-- Lorenzo Liwanag
-- Hugo Zeminian Camargo

--================================= || DATABASE CREATION || =================================--
							  --====|| SKS National Bank ||====--

USE master;

--====|| Create Database ||====--

DROP DATABASE IF EXISTS SKSBank;

CREATE DATABASE SKSBank;
GO

--====|| Create tables ||====--

USE SKSBank;

--Attribute name	||		 Type		||  Constraints 

CREATE TABLE Location
(
  LocationID		INT					PRIMARY KEY	IDENTITY,
  City				VARCHAR(255)		NOT NULL,
  isBranch			BIT					NOT NULL,
)

CREATE TABLE Branch
(
  BranchName		VARCHAR(255)		PRIMARY KEY,
  LocationID		INT REFERENCES Location(LocationID),
)

CREATE TABLE Employee 
(
  EmployeeID		INT					PRIMARY KEY	IDENTITY,
  EmpName				VARCHAR(255)		NOT NULL,
  EmpAddress			VARCHAR(255)		NOT NULL,
  isManager			BIT					NOT NULL,
  Manager			INT REFERENCES Employee(EmployeeID) DEFAULT NULL,
  StartDate			DATETIME			NOT NULL DEFAULT (GETDATE())
)

CREATE TABLE Employee_Location 
(
  EmployeeID		INT REFERENCES Employee(EmployeeID),
  LocationID		INT REFERENCES Location(LocationID),
  PRIMARY KEY (EmployeeID, LocationID)
)

CREATE TABLE Account 
(
  AccountID			INT					PRIMARY KEY	IDENTITY,
  isSaving			BIT					NOT NULL,
  BranchName		VARCHAR(255) REFERENCES Branch(BranchName),
  Balance			MONEY				NOT NULL DEFAULT (0),
  LastAccess		DATETIME			NOT NULL DEFAULT (GETDATE()),
  InterestRate		DECIMAL(3, 2)		DEFAULT 0
)

CREATE TABLE Customer 
(
  CustomerID		INT					PRIMARY KEY	IDENTITY,
  CustomerName		VARCHAR(255)		NOT NULL,
  CustomerAddress			VARCHAR(255)		NOT NULL
)

CREATE TABLE Account_Customer 
(
  AccountID			INT REFERENCES Account(AccountID),
  CustomerID		INT REFERENCES Customer(CustomerID),
  PRIMARY KEY (AccountID, CustomerID)
)

CREATE TABLE Employee_Customer
(
	EmployeeID		INT REFERENCES Employee(EmployeeID),
	CustomerID		INT REFERENCES Customer(CustomerID),
	PRIMARY KEY (EmployeeID, CustomerID)
)

CREATE TABLE Loan 
(
  LoanID			INT					PRIMARY KEY IDENTITY,
  BranchName		VARCHAR(255) REFERENCES Branch(BranchName),
  Amount			MONEY				NOT NULL	DEFAULT (0),
  Balance			MONEY				NOT NULL	DEFAULT (0)
)

CREATE TABLE Loan_Customer 
(
  LoanID			INT REFERENCES Loan(LoanID),
  CustomerID		INT REFERENCES Customer(CustomerID)
  PRIMARY KEY (LoanID, CustomerID)
)

CREATE TABLE Operation 
(
  OperationID		INT					PRIMARY KEY,
  Description		VARCHAR(255)		NOT NULL
)

CREATE TABLE Transactions 
(
  TransactionID		INT					PRIMARY KEY		IDENTITY,
  OperationID		INT REFERENCES Operation(OperationID), 
  TransactionDate	DATETIME			NOT NULL		DEFAULT (GETDATE()),
  Amount			MONEY				NOT NULL		DEFAULT (0),
  AccountID			INT REFERENCES Account(AccountID),
  LoanID			INT REFERENCES Loan(LoanID)			DEFAULT NULL,
  TransferTo		INT									DEFAULT NULL,					
)

CREATE TABLE Overdrafts 
(
  CheckNumberID		INT PRIMARY KEY		IDENTITY,
  AccountID			INT REFERENCES Account(AccountID),
  Amount			MONEY				NOT NULL,
  OverdraftDate		DATETIME			NOT NULL	DEFAULT (GETDATE()),
InterestRate		DECIMAL(3, 2)		NOT NULL	DEFAULT (0.06)		-- 22% of interest rate a year => 22% / 365 days = 0.06 per day
)
GO

--====|| Populate tables ||====--

--Location table
SET IDENTITY_INSERT Location OFF;

INSERT INTO Location(City, isBranch)	VALUES ('Calgary', 1)
INSERT INTO Location(City, isBranch)	VALUES ('Calgary', 0)
INSERT INTO Location(City, isBranch)	VALUES ('Edmonton', 1)
INSERT INTO Location(City, isBranch)	VALUES ('Edmonton', 0)
INSERT INTO Location(City, isBranch)	VALUES ('Red Deer', 1)
INSERT INTO Location(City, isBranch)	VALUES ('Calgary', 1)
INSERT INTO Location(City, isBranch)	VALUES ('Calgary', 1)


--Branch table
INSERT INTO Branch(BranchName, LocationID)		VALUES ('Main Branch', 1);
INSERT INTO Branch(BranchName, LocationID)		VALUES ('South Branch', 6);
INSERT INTO Branch(BranchName, LocationID)		VALUES ('Red Deer Branch', 5);
INSERT INTO Branch(BranchName, LocationID)		VALUES ('Downtown Branch', 3);
INSERT INTO Branch(BranchName, LocationID)		VALUES ('North Branch', 7);

--Employee table
SET IDENTITY_INSERT Employee OFF;

INSERT INTO Employee (StartDate, EmpName, EmpAddress, isManager)			VALUES ('2023-05-09',	'David Miller',		'456 Oak Avenue, Calgary',			1)
INSERT INTO Employee (StartDate, EmpName, EmpAddress, isManager, Manager)	VALUES ('2023-06-30',	'Linda Davis',		'789 Pine Drive, Calgary',			0,	1)
INSERT INTO Employee (StartDate, EmpName, EmpAddress, isManager, Manager)	VALUES ('2023-06-29',	'Michael Smith',	'101 Elm Boulevard, Calgary',		0,	1)
INSERT INTO Employee (StartDate, EmpName, EmpAddress, isManager, Manager)	VALUES ('2023-05-08',	'Emily Brown',		'101 Spruce Boulevard, Calgary',	0,	1)
INSERT INTO Employee (StartDate, EmpName, EmpAddress, isManager)			VALUES ('2023-05-05',	'Jackson Robinson',	'202 Cedar Lane, Calgary',			1)
INSERT INTO Employee (StartDate, EmpName, EmpAddress, isManager, Manager)	VALUES ('2023-06-03',	'Ethan Hall',		'101 Oak Boulevard, Calgary',		0,	5)
INSERT INTO Employee (StartDate, EmpName, EmpAddress, isManager)			VALUES ('2023-07-11',	'Daniel Anderson',	'123 Elm Street, Edmonton',			1)
INSERT INTO Employee (StartDate, EmpName, EmpAddress, isManager)			VALUES ('2023-06-22',	'Sophia Garcia',	'456 Maple Avenue, Edmonton',		1)
INSERT INTO Employee (StartDate, EmpName, EmpAddress, isManager)			VALUES ('2023-05-27',	'Logan Davis',		'975 Orange Avenue, Red Deer',		1)
INSERT INTO Employee (StartDate, EmpName, EmpAddress, isManager, Manager)	VALUES ('2023-05-23',	'Olivia Lee',		'101 Oak Boulevard, Edmonton',		0,	7)
INSERT INTO Employee (StartDate, EmpName, EmpAddress, isManager, Manager)	VALUES ('2023-06-12',	'Emma White',		'111 Oak Boulevard, Edmonton',		0,	8)
INSERT INTO Employee (StartDate, EmpName, EmpAddress, isManager, Manager)	VALUES ('2023-05-01',	'Lucas Hall',		'345 Elm Street, Red Deer',			0,	9)
INSERT INTO Employee (StartDate, EmpName, EmpAddress, isManager, Manager)	VALUES ('2023-07-13',	'Sophia Parker',	'131 Oak Boulevard, Red Deer',		0,	9)
INSERT INTO Employee (StartDate, EmpName, EmpAddress, isManager, Manager)	VALUES ('2023-05-23',	'Lily Robinson',	'910 Pine Drive, Red Deer',			0,	9)
INSERT INTO Employee (StartDate, EmpName, EmpAddress, isManager, Manager)	VALUES ('2023-04-29',	'Mason Adams',		'2022 Maple Lane, Red Deer',		0,	9)
INSERT INTO Employee (StartDate, EmpName, EmpAddress, isManager)			VALUES ('2023-07-20',	'Fabio Weck',		'1012 15 ave., Calgary',			1)
INSERT INTO Employee (StartDate, EmpName, EmpAddress, isManager, Manager)	VALUES ('2023-07-30',	'Hugo Camargo',		'987 Maple Lane, Calgary',			0,	16)

--Employee_Location table
INSERT INTO Employee_Location(EmployeeID, LocationID)	VALUES (1,	1)
INSERT INTO Employee_Location(EmployeeID, LocationID)	VALUES (2,	1)
INSERT INTO Employee_Location(EmployeeID, LocationID)	VALUES (3,	6)
INSERT INTO Employee_Location(EmployeeID, LocationID)	VALUES (4,	1)
INSERT INTO Employee_Location(EmployeeID, LocationID)	VALUES (5,	2)
INSERT INTO Employee_Location(EmployeeID, LocationID)	VALUES (6,	2)
INSERT INTO Employee_Location(EmployeeID, LocationID)	VALUES (7,	3)
INSERT INTO Employee_Location(EmployeeID, LocationID)	VALUES (8,	4)
INSERT INTO Employee_Location(EmployeeID, LocationID)	VALUES (9,	5)
INSERT INTO Employee_Location(EmployeeID, LocationID)	VALUES (10, 3)
INSERT INTO Employee_Location(EmployeeID, LocationID)	VALUES (11, 4)
INSERT INTO Employee_Location(EmployeeID, LocationID)	VALUES (12, 5)
INSERT INTO Employee_Location(EmployeeID, LocationID)	VALUES (13, 5)
INSERT INTO Employee_Location(EmployeeID, LocationID)	VALUES (14, 5)
INSERT INTO Employee_Location(EmployeeID, LocationID)	VALUES (15, 5)
INSERT INTO Employee_Location(EmployeeID, LocationID)	VALUES (16, 7)
INSERT INTO Employee_Location(EmployeeID, LocationID)	VALUES (17, 7)


--Customer table
SET IDENTITY_INSERT Customer OFF;

INSERT INTO Customer	VALUES ('John Smith',		'123 Main St,			Calgary');
INSERT INTO Customer	VALUES ('Alice Johnson',	'456 Elm St,			Calgary');
INSERT INTO Customer	VALUES ('Michael Davis',	'789 Oak St,			Calgary');
INSERT INTO Customer	VALUES ('David Wilson',		'202 Maple St,			Calgary');
INSERT INTO Customer	VALUES ('Sarah Lee',		'321 Cedar St,			Edmonton');
INSERT INTO Customer	VALUES ('Ryan Moore',		'654 Birch St,			Edmonton');
INSERT INTO Customer	VALUES ('Linda Anderson',	'987 Spruce St,			Edmonton');
INSERT INTO Customer	VALUES ('Brian Hall',		'111 Fir St,			Edmonton');
INSERT INTO Customer	VALUES ('Karen Clark',		'222 Pine St,			Edmonton');
INSERT INTO Customer	VALUES ('Melissa Young',	'888 Fir St,			Edmonton');
INSERT INTO Customer	VALUES ('Joseph Perez',		'999 Cedar St,			Red Deer');
INSERT INTO Customer	VALUES ('Kimberly Scott',	'111 Pine St,			Red Deer');
INSERT INTO Customer	VALUES ('William White',	'222 Elm St,			Red Deer');
INSERT INTO Customer	VALUES ('Eric Roberts',		'444 Spruce St,			Red Deer');
INSERT INTO Customer	VALUES ('Sophia Adams',		'555 Maple St,			Red Deer');
INSERT INTO Customer	VALUES ('Emma Thompson',	'123 Mountain Ave,		Calgary');
INSERT INTO Customer	VALUES ('Oliver Davis',		'456 Pine St,			Banff');
INSERT INTO Customer	VALUES ('Chloe Walker',		'789 River Rd,			Calgary');
INSERT INTO Customer	VALUES ('Liam Martinez',	'321 Mountain View Dr,	Canmore');
INSERT INTO Customer	VALUES ('Ethan Butler',		'987 River Dr,			Edmonton');

--Employee_Customer table

INSERT INTO Employee_Customer(EmployeeID, CustomerID)	VALUES (12, 5)
INSERT INTO Employee_Customer(EmployeeID, CustomerID)	VALUES (4, 4)
INSERT INTO Employee_Customer(EmployeeID, CustomerID)	VALUES (4, 18)
INSERT INTO Employee_Customer(EmployeeID, CustomerID)	VALUES (4, 19)
INSERT INTO Employee_Customer(EmployeeID, CustomerID)	VALUES (2, 3)
INSERT INTO Employee_Customer(EmployeeID, CustomerID)	VALUES (2, 1)
INSERT INTO Employee_Customer(EmployeeID, CustomerID)	VALUES (4, 17)
INSERT INTO Employee_Customer(EmployeeID, CustomerID)	VALUES (2, 19)
INSERT INTO Employee_Customer(EmployeeID, CustomerID)	VALUES (10, 10)
INSERT INTO Employee_Customer(EmployeeID, CustomerID)	VALUES (10, 5)
INSERT INTO Employee_Customer(EmployeeID, CustomerID)	VALUES (10, 6)
INSERT INTO Employee_Customer(EmployeeID, CustomerID)	VALUES (11, 7)
INSERT INTO Employee_Customer(EmployeeID, CustomerID)	VALUES (11, 20)
INSERT INTO Employee_Customer(EmployeeID, CustomerID)	VALUES (12, 11)
INSERT INTO Employee_Customer(EmployeeID, CustomerID)	VALUES (12, 9)
INSERT INTO Employee_Customer(EmployeeID, CustomerID)	VALUES (13, 12)
INSERT INTO Employee_Customer(EmployeeID, CustomerID)	VALUES (14, 13)
INSERT INTO Employee_Customer(EmployeeID, CustomerID)	VALUES (14, 15)
INSERT INTO Employee_Customer(EmployeeID, CustomerID)	VALUES (15, 14)
INSERT INTO Employee_Customer(EmployeeID, CustomerID)	VALUES (2, 16)

--Account table
SET IDENTITY_INSERT Account OFF;

-- 0.35% per month
DECLARE @iRate DECIMAL(3, 2) = 0.35
INSERT INTO Account(isSaving, BranchName, Balance, InterestRate, LastAccess)	VALUES (0, 'Main Branch',		599.57,		NULL,		'2023-10-13')
INSERT INTO Account(isSaving, BranchName, Balance, InterestRate, LastAccess)	VALUES (0, 'Downtown Branch',	96,			NULL,		'2023-10-03')
INSERT INTO Account(isSaving, BranchName, Balance, InterestRate, LastAccess)	VALUES (0, 'Main Branch',		3511.09,	NULL,		'2023-10-06')
INSERT INTO Account(isSaving, BranchName, Balance, InterestRate, LastAccess)	VALUES (1, 'Main Branch',		2000,		@iRate,		'2023-10-14')
INSERT INTO Account(isSaving, BranchName, Balance, InterestRate, LastAccess)	VALUES (0, 'Downtown Branch',	100,		NULL,		'2023-09-29')
INSERT INTO Account(isSaving, BranchName, Balance, InterestRate, LastAccess)	VALUES (0, 'Downtown Branch',	0,			NULL,		'2023-10-15')
INSERT INTO Account(isSaving, BranchName, Balance, InterestRate, LastAccess)	VALUES (1, 'Red Deer Branch',	331,		@iRate,		'2023-10-15')
INSERT INTO Account(isSaving, BranchName, Balance, InterestRate, LastAccess)	VALUES (1, 'Red Deer Branch',	999,		@iRate,		'2023-10-17')
INSERT INTO Account(isSaving, BranchName, Balance, InterestRate, LastAccess)	VALUES (1, 'Main Branch',		500,		@iRate,		'2023-10-20')
INSERT INTO Account(isSaving, BranchName, Balance, InterestRate, LastAccess)	VALUES (0, 'Main Branch',		6800.18,	NULL,		'2023-10-20')
INSERT INTO Account(isSaving, BranchName, Balance, InterestRate, LastAccess)	VALUES (0, 'South Branch',		1452.97,	NULL,		'2023-10-20')
INSERT INTO Account(isSaving, BranchName, Balance, InterestRate, LastAccess)	VALUES (0, 'Red Deer Branch',	1665.54,	NULL,		'2023-10-02')
INSERT INTO Account(isSaving, BranchName, Balance, InterestRate, LastAccess)	VALUES (0, 'Red Deer Branch',	10,			NULL,		'2023-10-15')
INSERT INTO Account(isSaving, BranchName, Balance, InterestRate, LastAccess)	VALUES (1, 'Red Deer Branch',	52,			@iRate,		'2023-10-19')
INSERT INTO Account(isSaving, BranchName, Balance, InterestRate, LastAccess)	VALUES (0, 'Red Deer Branch',	-230,		NULL,		'2023-10-15')
INSERT INTO Account(isSaving, BranchName, Balance, InterestRate, LastAccess)	VALUES (1, 'Red Deer Branch',	15053.32,	@iRate,		'2023-10-18')
INSERT INTO Account(isSaving, BranchName, Balance, InterestRate, LastAccess)	VALUES (0, 'Main Branch',		-899,		NULL,		'2023-10-19')
INSERT INTO Account(isSaving, BranchName, Balance, InterestRate, LastAccess)	VALUES (1, 'Main Branch',		3750,		@iRate,		'2023-10-17')

--Account_Customer table
INSERT INTO Account_Customer	VALUES (1, 1)
INSERT INTO Account_Customer	VALUES (2, 6)
INSERT INTO Account_Customer	VALUES (3, 3)
INSERT INTO Account_Customer	VALUES (4, 3)
INSERT INTO Account_Customer	VALUES (5, 8)
INSERT INTO Account_Customer	VALUES (5, 10)
INSERT INTO Account_Customer	VALUES (6, 5)
INSERT INTO Account_Customer	VALUES (7, 9)
INSERT INTO Account_Customer	VALUES (8, 11)
INSERT INTO Account_Customer	VALUES (9, 19)
INSERT INTO Account_Customer	VALUES (10, 16)
INSERT INTO Account_Customer	VALUES (11, 2)
INSERT INTO Account_Customer	VALUES (12, 13)
INSERT INTO Account_Customer	VALUES (13, 12)
INSERT INTO Account_Customer	VALUES (14, 12)
INSERT INTO Account_Customer	VALUES (15, 15)
INSERT INTO Account_Customer	VALUES (16, 14)
INSERT INTO Account_Customer	VALUES (17, 4)
INSERT INTO Account_Customer	VALUES (17, 18)
INSERT INTO Account_Customer	VALUES (18, 17)


--Operation table
INSERT INTO Operation		VALUES (1, 'Deposit')	
INSERT INTO Operation		VALUES (2, 'Withdrawal')
INSERT INTO Operation		VALUES (3, 'Transfer')
INSERT INTO Operation		VALUES (4, 'Payment')
INSERT INTO Operation		VALUES (5, 'Borrow')


--Loan table
SET IDENTITY_INSERT Loan OFF;

INSERT INTO Loan(BranchName, Amount, Balance)	VALUES('Downtown Branch',	1000,	900);
INSERT INTO Loan(BranchName, Amount, Balance)	VALUES('Main Branch',		5000,	4650);
INSERT INTO Loan(BranchName, Amount, Balance)	VALUES('Red Deer Branch',	3250,	2950);
INSERT INTO Loan(BranchName, Amount, Balance)	VALUES('Main Branch',		550,	550);
INSERT INTO Loan(BranchName, Amount, Balance)	VALUES('Red Deer Branch',	2000,	2000);


--Transactions table
SET IDENTITY_INSERT Transactions OFF;

INSERT INTO Transactions(TransactionDate, OperationID, Amount, AccountID, LoanID, TransferTo)	VALUES ('2023-10-13',	 3,		500,		1,		NULL,	3)
INSERT INTO Transactions(TransactionDate, OperationID, Amount, AccountID, LoanID, TransferTo)	VALUES ('2023-10-13',	 1,		342.50,		11,		NULL,	NULL)
INSERT INTO Transactions(TransactionDate, OperationID, Amount, AccountID, LoanID, TransferTo)	VALUES ('2023-10-13',	 2,		250,		15,		NULL,	NULL)
INSERT INTO Transactions(TransactionDate, OperationID, Amount, AccountID, LoanID, TransferTo)	VALUES ('2023-10-14',	 1,		1000,		4,		NULL,	NULL)
INSERT INTO Transactions(TransactionDate, OperationID, Amount, AccountID, LoanID, TransferTo)	VALUES ('2023-10-14',	 5,		1000,		6,		1,		NULL)
INSERT INTO Transactions(TransactionDate, OperationID, Amount, AccountID, LoanID, TransferTo)	VALUES ('2023-10-15',	 1,		225,		7,		NULL,	NULL)
INSERT INTO Transactions(TransactionDate, OperationID, Amount, AccountID, LoanID, TransferTo)	VALUES ('2023-10-15',	 2,		130,		15,		NULL,	NULL)
INSERT INTO Transactions(TransactionDate, OperationID, Amount, AccountID, LoanID, TransferTo)	VALUES ('2023-10-15',	 2,		90,			13,		NULL,	NULL)
INSERT INTO Transactions(TransactionDate, OperationID, Amount, AccountID, LoanID, TransferTo)	VALUES ('2023-10-15',	 4,		100,		6,		1,		NULL)
INSERT INTO Transactions(TransactionDate, OperationID, Amount, AccountID, LoanID, TransferTo)	VALUES ('2023-10-16',	 2,		1975.68,	16,		NULL,	NULL)
INSERT INTO Transactions(TransactionDate, OperationID, Amount, AccountID, LoanID, TransferTo)	VALUES ('2023-10-17',	 4,		350,		17,		2,		NULL)
INSERT INTO Transactions(TransactionDate, OperationID, Amount, AccountID, LoanID, TransferTo)	VALUES ('2023-10-17',	 1,		120,		18,		NULL,	NULL)
INSERT INTO Transactions(TransactionDate, OperationID, Amount, AccountID, LoanID, TransferTo)	VALUES ('2023-10-17',	 4,		150,		8,		3,		NULL)
INSERT INTO Transactions(TransactionDate, OperationID, Amount, AccountID, LoanID, TransferTo)	VALUES ('2023-10-18',	 2,		800,		17,		NULL,	NULL)
INSERT INTO Transactions(TransactionDate, OperationID, Amount, AccountID, LoanID, TransferTo)	VALUES ('2023-10-18',	 3,		100,		16,		NULL,	10)
INSERT INTO Transactions(TransactionDate, OperationID, Amount, AccountID, LoanID, TransferTo)	VALUES ('2023-10-19',	 4,		150,		14,		3,		NULL)
INSERT INTO Transactions(TransactionDate, OperationID, Amount, AccountID, LoanID, TransferTo)	VALUES ('2023-10-19',	 3,		99,			17,		NULL,	11)
INSERT INTO Transactions(TransactionDate, OperationID, Amount, AccountID, LoanID, TransferTo)	VALUES ('2023-10-19',	 1,		400,		10,		NULL,	NULL)
INSERT INTO Transactions(TransactionDate, OperationID, Amount, AccountID, LoanID, TransferTo)	VALUES ('2023-10-20',	 5,		550,		9,		4,		NULL)
INSERT INTO Transactions(TransactionDate, OperationID, Amount, AccountID, LoanID, TransferTo)	VALUES ('2023-10-20',	 2,		247.03,		11,		NULL,	NULL)


--Loan_Customer table

INSERT INTO Loan_Customer(LoanID, CustomerID)	VALUES (1, 5)
INSERT INTO Loan_Customer(LoanID, CustomerID)	VALUES (2, 18)
INSERT INTO Loan_Customer(LoanID, CustomerID)	VALUES (2, 4)
INSERT INTO Loan_Customer(LoanID, CustomerID)	VALUES (3, 11)
INSERT INTO Loan_Customer(LoanID, CustomerID)	VALUES (3, 12)
INSERT INTO Loan_Customer(LoanID, CustomerID)	VALUES (4, 19)
INSERT INTO Loan_Customer(LoanID, CustomerID)	VALUES (5, 13)

--Overdrafts table

SET IDENTITY_INSERT Overdrafts OFF;

INSERT INTO Overdrafts (OverdraftDate, AccountID, Amount)	VALUES ('2023-09-24', 9, -345)
INSERT INTO Overdrafts (OverdraftDate, AccountID, Amount)	VALUES ('2023-09-27', 9, -500)
INSERT INTO Overdrafts (OverdraftDate, AccountID, Amount)	VALUES ('2023-09-29', 2, -700)
INSERT INTO Overdrafts (OverdraftDate, AccountID, Amount)	VALUES ('2023-10-13', 15, -100)
INSERT INTO Overdrafts (OverdraftDate, AccountID, Amount)	VALUES ('2023-10-15', 15, -230)
INSERT INTO Overdrafts (OverdraftDate, AccountID, Amount)	VALUES ('2023-10-18', 17, -800)
INSERT INTO Overdrafts (OverdraftDate, AccountID, Amount)	VALUES ('2023-10-19', 15, -899)

--================================= || END OF DATABASE CREATION || =================================--

----====|| User cases ||====--

--== 1. Check the total amount of deposits and loans that each branch holds ==--

CREATE PROCEDURE uspBranchTotals
AS
BEGIN
	SELECT Totals.BranchName, SUM(Totals.Balance) AS Total
	FROM (SELECT b.BranchName, 
		CASE
			WHEN SUM(a.Balance) IS NULL THEN 0
			ELSE SUM(a.Balance)
		END AS Balance
		FROM Branch b
		LEFT JOIN Account a
		ON b.BranchName = a.BranchName
		GROUP BY b.BranchName
		UNION
		SELECT b.BranchName,
		CASE
			WHEN SUM(l.Balance) IS NULL THEN 0
			ELSE SUM(l.Balance)
		END AS Balance
		FROM Branch b
		LEFT JOIN Loan l
		ON b.BranchName = l.BranchName
		GROUP BY b.BranchName) AS Totals
	GROUP BY Totals.BranchName
END

EXEC uspBranchTotals;

--== 2. Check loans and their customers. Can be filtered by loan ID. ==--

CREATE PROCEDURE uspCustomerLoan @loanID INT = NULL
AS
BEGIN
	SELECT *--c.CustomerID, c.CustomerName, lc.LoanID, l.Amount, l.Balance 
	FROM Customer c
	JOIN Loan_Customer lc
	ON c.CustomerID = lc.CustomerID
	JOIN Loan l
	ON lc.LoanID = l.LoanID
	WHERE (@loanID IS NULL OR @loanID = l.LoanID)
END

EXEC uspCustomerLoan;		-- Displays all loans and their customers
EXEC uspCustomerLoan 4;		-- Filters results by Loan ID
EXEC uspCustomerLoan 3;		-- This example shows a loan held by two customers (joint account)


--== 3. Check all customers who went into overdraft (amount per day in overdraft) ==--

CREATE PROCEDURE uspCustomerOverdraft
AS
BEGIN
	SELECT c.CustomerID, c.CustomerName, ac.AccountID, o.Amount, o.OverdraftDate
	FROM Customer c
	JOIN Account_Customer ac
	ON c.CustomerID = ac.CustomerID
	JOIN Overdrafts o
	ON ac.AccountID = o.AccountID
END

EXEC uspCustomerOverdraft;


--== 4. A banker/loan officer can check the amount he/she has under management ==--

CREATE PROCEDURE uspEmployeeAmount @EmpID VARCHAR(250)
AS
BEGIN
	SELECT EmployeeID, EmpName, SUM(Balance) TotalManaged 
	FROM(SELECT 
		e.EmployeeID, 
		e.EmpName, 
		AccountBalance.Balance
		FROM (SELECT a.AccountID, 
			MIN(a.Balance) AS Balance,		--Function to select one value from duplicated values originated by joint accounts
			MIN(c.CustomerID) AS CustomerID	--Function to select one customer from a joint account, since both have the same banker
		FROM Account a
		LEFT JOIN Account_Customer ac
		ON a.AccountID = ac.AccountID
		JOIN Customer c
		ON ac.CustomerID = c.CustomerID
		GROUP BY a.AccountID) AS AccountBalance
	LEFT JOIN Employee_Customer ec
	ON AccountBalance.CustomerID = ec.CustomerID
	JOIN Employee e
	ON ec.EmployeeID = e.EmployeeID
	UNION
	SELECT e.EmployeeID, e.EmpName, LoanBalance.Balance
	FROM(SELECT l.LoanID, 
			MIN(l.Balance) AS Balance,		--Function to select one value from duplicated values originated by joint accounts
			MIN(c.CustomerID) AS CustomerID	--Function to select one customer from a joint account, since both have the same banker
		FROM Loan l
		LEFT JOIN Loan_Customer lc
		ON l.LoanID = lc.LoanID
		JOIN Customer c
		ON lc.CustomerID = c.CustomerID
		GROUP BY l.LoanID) AS LoanBalance
	LEFT JOIN Employee_Customer ec
	ON LoanBalance.CustomerID = ec.CustomerID
	JOIN Employee e
	ON ec.EmployeeID = e.EmployeeID) AS Totals
	GROUP BY EmployeeID, EmpName
	HAVING EmployeeID = @EmpID
END

EXEC uspEmployeeAmount 2;
EXEC uspEmployeeAmount 4;


--== 5. Bankers can check all transactions - Can be filtered by branch or account ID ==--

CREATE PROCEDURE uspAllTransactions @accountID INT = NULL, @branchName VARCHAR(250) = NULL
AS
BEGIN
	SELECT t.TransactionID, 
	   t.TransactionDate,
	   o.Description AS Operation,
	   t.Amount,
	   a.AccountID, 
	   a.BranchName
	FROM Transactions t
	JOIN Operation o
	ON t.OperationID = o.OperationID
	JOIN Account a
	ON t.AccountID = a.AccountID
	WHERE (@accountID IS NULL OR a.AccountID = @accountID)
		   AND (@branchName IS NULL OR a.BranchName = @branchName)
END

EXEC uspAllTransactions;								--All transactions
EXEC uspAllTransactions @branchName = 'Main Branch';	--Filtered by branch name
EXEC uspAllTransactions @accountID = 17;				--Filtered by account ID


--== 6. Check employees who are not bankers and work at offices ==--

CREATE PROCEDURE uspOfficeWorkers
AS
BEGIN
	SELECT e.EmployeeID, e.EmpName
	FROM Employee e
	JOIN Employee_Location el ON e.EmployeeID = el.EmployeeID
	JOIN Location l ON el.LocationID = l.LocationID
	WHERE l.isBranch = 0
END

EXEC uspOfficeWorkers;


--== 7. A customer can check his/her accounts balance and last access dates ==--
CREATE PROCEDURE uspAccountsBalance @customerID INT
AS
BEGIN
	SELECT c.CustomerName, 
		   a.AccountID,
		   CASE
		   WHEN a.isSaving = 0 THEN 'Checking'
		   ELSE 'Saving'
		   END AS AccountType,
		   a.Balance, a.LastAccess
	FROM Customer c
	JOIN Account_Customer ac
	ON c.CustomerID = ac.CustomerID
	JOIN Account a
	ON ac.AccountID = a.AccountID
	WHERE c.CustomerID = @customerID
END

EXEC uspAccountsBalance 12; -- Displays both accounts when a customer have checking and saving account
EXEC uspAccountsBalance 15;
EXEC uspAccountsBalance 3;



--== 8. A customer can check transactions in a date range ==--
CREATE PROCEDURE uspCustomerTransactions @customerID INT, @minDate DATE, @maxDate DATE
AS
BEGIN
	SELECT t.TransactionID,
		   o.Description AS Operation,
		   t.TransactionDate,
	       t.Amount	   
	FROM Transactions t
	JOIN Operation o
	ON t.OperationID = o.OperationID
	JOIN Account_Customer ac
	ON t.AccountID = ac.AccountID
	JOIN Customer c
	ON ac.CustomerID = c.CustomerID
	WHERE c.CustomerID = @CustomerID 
	AND t.TransactionDate BETWEEN @minDate AND @maxDate
END

EXEC uspCustomerTransactions 18, '2023-09-20', '2023-10-20';
EXEC uspCustomerTransactions 15, '2023-09-20', '2023-10-20';
EXEC uspCustomerTransactions 18, '2023-09-20', '2023-10-20';
EXEC uspCustomerTransactions 5, '2023-09-20', '2023-10-20';


--== 9. A customer can visualize fees that will be charged in the next month after going into overdrafts ==--
CREATE PROCEDURE uspOverdraftFees @customerID INT
AS
BEGIN
	SELECT Fees.AccountID, 
		   SUM(Fees.DailyInterestCharge) + 5 AS Fees, -- Banks usually have 5 dollars fee charged when the customer goes into overdraft
		   MAX(DATEADD(DAY, 1, EOMONTH(Fees.OverdraftDate))) AS ChargeDate
	FROM
	(SELECT AccountID, CAST((Amount * -1) * (InterestRate/100) AS DECIMAL(10,2)) AS DailyInterestCharge, OverdraftDate
	FROM Overdrafts) AS Fees
	GROUP BY Fees.AccountID
	HAVING Fees.AccountID = @customerID
END

EXEC uspOverdraftFees 15;
EXEC uspOverdraftFees 9;	-- Charged on October
EXEC uspOverdraftFees 17;

--== 10. A customer can check his/her loan balance ==--
CREATE PROCEDURE uspCheckLoan @customerID INT
AS
BEGIN
	SELECT DISTINCT c.CustomerName, l.LoanID, l.Amount, l.Balance
	FROM Customer c
	JOIN Account_Customer ac
	ON c.CustomerID = ac.CustomerID
	JOIN Account a
	ON ac.AccountID = a.AccountID
	JOIN Loan_Customer lc
	ON c.CustomerID = lc.CustomerID
	JOIN Loan l
	ON lc.LoanID = l.LoanID
	WHERE c.CustomerID = @customerID
END

EXEC uspCheckLoan 12;
EXEC uspCheckLoan 4;
EXEC uspCheckLoan 18; -- Customers ID 4 and 18 hold the same loan ID (joint account)


