-- Honeybee Database - Complete Setup Script
-- This script creates the database, schema, and seed data in one go
-- Run this script to set up the entire database from scratch

-- =============================================
-- PART 1: CREATE DATABASE
-- =============================================
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'HoneybeeDB')
BEGIN
    CREATE DATABASE HoneybeeDB;
    PRINT 'Database HoneybeeDB created successfully.';
END
ELSE
BEGIN
    PRINT 'Database HoneybeeDB already exists.';
END
GO

USE HoneybeeDB;
GO

-- =============================================
-- PART 2: CREATE TABLES
-- =============================================

-- Drop existing tables if they exist (in reverse order of dependencies)
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Payments]') AND type in (N'U'))
    DROP TABLE [dbo].[Payments];
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OrderItems]') AND type in (N'U'))
    DROP TABLE [dbo].[OrderItems];
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Orders]') AND type in (N'U'))
    DROP TABLE [dbo].[Orders];
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Customers]') AND type in (N'U'))
    DROP TABLE [dbo].[Customers];
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Products]') AND type in (N'U'))
    DROP TABLE [dbo].[Products];
GO

-- Create Products Table
CREATE TABLE [dbo].[Products] (
    [Id] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [Name] NVARCHAR(200) NOT NULL,
    [Description] NVARCHAR(1000) NULL,
    [Price] DECIMAL(18,2) NOT NULL,
    [StockQuantity] INT NOT NULL DEFAULT 0,
    [ImageUrl] NVARCHAR(200) NULL,
    [Category] NVARCHAR(100) NULL,
    [CreatedDate] DATETIME2 NOT NULL DEFAULT GETDATE()
);
PRINT 'Table Products created.';
GO

-- Create Customers Table
CREATE TABLE [dbo].[Customers] (
    [Id] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [FirstName] NVARCHAR(100) NOT NULL,
    [LastName] NVARCHAR(100) NOT NULL,
    [Email] NVARCHAR(200) NOT NULL,
    [Phone] NVARCHAR(20) NOT NULL,
    [Address] NVARCHAR(500) NULL,
    [City] NVARCHAR(100) NULL,
    [State] NVARCHAR(50) NULL,
    [ZipCode] NVARCHAR(20) NULL,
    [CreatedDate] DATETIME2 NOT NULL DEFAULT GETDATE()
);
PRINT 'Table Customers created.';
GO

-- Create unique index on Email
CREATE UNIQUE NONCLUSTERED INDEX [IX_Customers_Email] ON [dbo].[Customers]([Email]);
GO

-- Create Orders Table
CREATE TABLE [dbo].[Orders] (
    [Id] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [CustomerId] INT NOT NULL,
    [OrderDate] DATETIME2 NOT NULL DEFAULT GETDATE(),
    [Status] NVARCHAR(50) NOT NULL DEFAULT 'Pending',
    [TotalAmount] DECIMAL(18,2) NOT NULL,
    [ShippingAddress] NVARCHAR(500) NULL,
    CONSTRAINT [FK_Orders_Customers_CustomerId] FOREIGN KEY ([CustomerId]) 
        REFERENCES [dbo].[Customers] ([Id]) ON DELETE NO ACTION
);
PRINT 'Table Orders created.';
GO

-- Create index on CustomerId
CREATE NONCLUSTERED INDEX [IX_Orders_CustomerId] ON [dbo].[Orders]([CustomerId]);
GO

-- Create OrderItems Table
CREATE TABLE [dbo].[OrderItems] (
    [Id] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [OrderId] INT NOT NULL,
    [ProductId] INT NOT NULL,
    [Quantity] INT NOT NULL,
    [UnitPrice] DECIMAL(18,2) NOT NULL,
    CONSTRAINT [FK_OrderItems_Orders_OrderId] FOREIGN KEY ([OrderId]) 
        REFERENCES [dbo].[Orders] ([Id]) ON DELETE CASCADE,
    CONSTRAINT [FK_OrderItems_Products_ProductId] FOREIGN KEY ([ProductId]) 
        REFERENCES [dbo].[Products] ([Id]) ON DELETE NO ACTION
);
PRINT 'Table OrderItems created.';
GO

-- Create indexes
CREATE NONCLUSTERED INDEX [IX_OrderItems_OrderId] ON [dbo].[OrderItems]([OrderId]);
CREATE NONCLUSTERED INDEX [IX_OrderItems_ProductId] ON [dbo].[OrderItems]([ProductId]);
GO

-- Create Payments Table
CREATE TABLE [dbo].[Payments] (
    [Id] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [OrderId] INT NOT NULL,
    [PaymentMethod] NVARCHAR(50) NOT NULL DEFAULT 'Credit Card',
    [Amount] DECIMAL(18,2) NOT NULL,
    [CardNumber] NVARCHAR(100) NULL,
    [CardHolderName] NVARCHAR(50) NULL,
    [ExpiryDate] NVARCHAR(10) NULL,
    [CVV] NVARCHAR(10) NULL,
    [Status] NVARCHAR(50) NOT NULL DEFAULT 'Pending',
    [PaymentDate] DATETIME2 NOT NULL DEFAULT GETDATE(),
    [TransactionId] NVARCHAR(500) NULL,
    CONSTRAINT [FK_Payments_Orders_OrderId] FOREIGN KEY ([OrderId]) 
        REFERENCES [dbo].[Orders] ([Id]) ON DELETE CASCADE,
    CONSTRAINT [UQ_Payments_OrderId] UNIQUE ([OrderId])
);
PRINT 'Table Payments created.';
GO

-- Create index on OrderId
CREATE NONCLUSTERED INDEX [IX_Payments_OrderId] ON [dbo].[Payments]([OrderId]);
GO

-- =============================================
-- PART 3: INSERT SEED DATA
-- =============================================

-- Insert Sample Products
INSERT INTO [Products] ([Name], [Description], [Price], [StockQuantity], [Category], [ImageUrl], [CreatedDate])
VALUES 
    ('Premium Honey', 'Pure, organic honey harvested from local beehives. Rich in flavor and natural enzymes.', 24.99, 50, 'Food & Beverages', 'https://images.unsplash.com/photo-1587049352846-4a222e784d38?w=400', GETDATE()),
    ('Honey Comb', 'Fresh honeycomb with natural honey. Perfect for spreading on toast or adding to cheese boards.', 18.99, 30, 'Food & Beverages', 'https://images.unsplash.com/photo-1558642452-9d2a7deb7f62?w=400', GETDATE()),
    ('Beeswax Candles', 'Handmade beeswax candles. Natural, clean-burning, and long-lasting.', 12.99, 100, 'Home & Decor', 'https://images.unsplash.com/photo-1603561596116-5a81f4e8fbf0?w=400', GETDATE()),
    ('Honey Soap', 'Natural honey-infused soap. Moisturizing and gentle on the skin.', 8.99, 75, 'Personal Care', 'https://images.unsplash.com/photo-1556228578-0d85b1a4d571?w=400', GETDATE()),
    ('Royal Jelly', 'Premium royal jelly supplement. Rich in vitamins and nutrients.', 45.99, 25, 'Health & Wellness', 'https://images.unsplash.com/photo-1603561596116-5a81f4e8fbf0?w=400', GETDATE()),
    ('Propolis Extract', 'Natural propolis extract. Supports immune system health.', 32.99, 40, 'Health & Wellness', 'https://images.unsplash.com/photo-1587049352846-4a222e784d38?w=400', GETDATE()),
    ('Honey Gift Set', 'Beautiful gift set containing premium honey, honeycomb, and beeswax candles.', 59.99, 20, 'Gifts', 'https://images.unsplash.com/photo-1558642452-9d2a7deb7f62?w=400', GETDATE()),
    ('Raw Wildflower Honey', 'Unfiltered wildflower honey. Contains natural pollen and enzymes.', 19.99, 60, 'Food & Beverages', 'https://images.unsplash.com/photo-1587049352846-4a222e784d38?w=400', GETDATE());
PRINT 'Sample products inserted.';
GO

-- Insert Sample Customers
INSERT INTO [Customers] ([FirstName], [LastName], [Email], [Phone], [Address], [City], [State], [ZipCode], [CreatedDate])
VALUES 
    ('John', 'Doe', 'john.doe@example.com', '555-0101', '123 Main Street', 'New York', 'NY', '10001', GETDATE()),
    ('Jane', 'Smith', 'jane.smith@example.com', '555-0102', '456 Oak Avenue', 'Los Angeles', 'CA', '90001', GETDATE()),
    ('Robert', 'Johnson', 'robert.johnson@example.com', '555-0103', '789 Pine Road', 'Chicago', 'IL', '60601', GETDATE()),
    ('Emily', 'Williams', 'emily.williams@example.com', '555-0104', '321 Elm Street', 'Houston', 'TX', '77001', GETDATE()),
    ('Michael', 'Brown', 'michael.brown@example.com', '555-0105', '654 Maple Drive', 'Phoenix', 'AZ', '85001', GETDATE());
PRINT 'Sample customers inserted.';
GO

-- Insert Sample Orders
DECLARE @CustomerId1 INT = (SELECT TOP 1 [Id] FROM [Customers] WHERE [Email] = 'john.doe@example.com');
DECLARE @CustomerId2 INT = (SELECT TOP 1 [Id] FROM [Customers] WHERE [Email] = 'jane.smith@example.com');
DECLARE @ProductId1 INT = (SELECT TOP 1 [Id] FROM [Products] WHERE [Name] = 'Premium Honey');
DECLARE @ProductId2 INT = (SELECT TOP 1 [Id] FROM [Products] WHERE [Name] = 'Honey Comb');
DECLARE @ProductId3 INT = (SELECT TOP 1 [Id] FROM [Products] WHERE [Name] = 'Beeswax Candles');
DECLARE @OrderId1 INT;
DECLARE @OrderId2 INT;

-- Order 1
INSERT INTO [Orders] ([CustomerId], [OrderDate], [Status], [TotalAmount], [ShippingAddress])
VALUES (@CustomerId1, DATEADD(day, -10, GETDATE()), 'Paid', 43.98, '123 Main Street, New York, NY 10001');

SET @OrderId1 = SCOPE_IDENTITY();

INSERT INTO [OrderItems] ([OrderId], [ProductId], [Quantity], [UnitPrice])
VALUES 
    (@OrderId1, @ProductId1, 1, 24.99),
    (@OrderId1, @ProductId2, 1, 18.99);

-- Order 2
INSERT INTO [Orders] ([CustomerId], [OrderDate], [Status], [TotalAmount], [ShippingAddress])
VALUES (@CustomerId2, DATEADD(day, -5, GETDATE()), 'Shipped', 25.98, '456 Oak Avenue, Los Angeles, CA 90001');

SET @OrderId2 = SCOPE_IDENTITY();

INSERT INTO [OrderItems] ([OrderId], [ProductId], [Quantity], [UnitPrice])
VALUES 
    (@OrderId2, @ProductId2, 1, 18.99),
    (@OrderId2, @ProductId3, 1, 12.99);

PRINT 'Sample orders inserted.';
GO

-- Insert Sample Payment
DECLARE @PaidOrderId INT = (SELECT TOP 1 [Id] FROM [Orders] WHERE [Status] = 'Paid' ORDER BY [Id] DESC);

INSERT INTO [Payments] ([OrderId], [PaymentMethod], [Amount], [CardNumber], [CardHolderName], [ExpiryDate], [Status], [PaymentDate], [TransactionId])
VALUES (@PaidOrderId, 'Credit Card', 43.98, '****-****-****-1234', 'John Doe', '12/25', 'Completed', DATEADD(day, -10, GETDATE()), NEWID());

PRINT 'Sample payment inserted.';
GO

-- =============================================
-- PART 4: DISPLAY SUMMARY
-- =============================================
PRINT '';
PRINT '========================================';
PRINT 'Database Setup Complete!';
PRINT '========================================';
PRINT '';

SELECT 
    (SELECT COUNT(*) FROM [Products]) AS TotalProducts,
    (SELECT COUNT(*) FROM [Customers]) AS TotalCustomers,
    (SELECT COUNT(*) FROM [Orders]) AS TotalOrders,
    (SELECT COUNT(*) FROM [Payments]) AS TotalPayments;

PRINT '';
PRINT 'You can now use the Honeybee application!';
GO

