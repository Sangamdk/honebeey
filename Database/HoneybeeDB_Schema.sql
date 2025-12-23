-- Honeybee Database Schema
-- SQL Server Database Creation Script

-- Create Database
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'HoneybeeDB')
BEGIN
    CREATE DATABASE HoneybeeDB;
END
GO

USE HoneybeeDB;
GO

-- Create Products Table
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Products]') AND type in (N'U'))
BEGIN
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
END
GO

-- Create Customers Table
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Customers]') AND type in (N'U'))
BEGIN
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
    
    -- Create unique index on Email
    CREATE UNIQUE NONCLUSTERED INDEX [IX_Customers_Email] ON [dbo].[Customers]([Email]);
END
GO

-- Create Orders Table
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Orders]') AND type in (N'U'))
BEGIN
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
    
    -- Create index on CustomerId
    CREATE NONCLUSTERED INDEX [IX_Orders_CustomerId] ON [dbo].[Orders]([CustomerId]);
END
GO

-- Create OrderItems Table
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OrderItems]') AND type in (N'U'))
BEGIN
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
    
    -- Create indexes
    CREATE NONCLUSTERED INDEX [IX_OrderItems_OrderId] ON [dbo].[OrderItems]([OrderId]);
    CREATE NONCLUSTERED INDEX [IX_OrderItems_ProductId] ON [dbo].[OrderItems]([ProductId]);
END
GO

-- Create Payments Table
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Payments]') AND type in (N'U'))
BEGIN
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
    
    -- Create index on OrderId
    CREATE NONCLUSTERED INDEX [IX_Payments_OrderId] ON [dbo].[Payments]([OrderId]);
END
GO

PRINT 'Database schema created successfully!';
GO

