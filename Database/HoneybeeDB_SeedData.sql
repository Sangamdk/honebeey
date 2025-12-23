-- Honeybee Database Seed Data
-- Sample data for testing the application

USE HoneybeeDB;
GO

-- Clear existing data (optional - uncomment if you want to reset)
-- DELETE FROM [Payments];
-- DELETE FROM [OrderItems];
-- DELETE FROM [Orders];
-- DELETE FROM [Customers];
-- DELETE FROM [Products];
-- GO

-- Insert Sample Products
IF NOT EXISTS (SELECT * FROM [Products] WHERE [Name] = 'Premium Honey')
BEGIN
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
END
GO

-- Insert Sample Customers
IF NOT EXISTS (SELECT * FROM [Customers] WHERE [Email] = 'john.doe@example.com')
BEGIN
    INSERT INTO [Customers] ([FirstName], [LastName], [Email], [Phone], [Address], [City], [State], [ZipCode], [CreatedDate])
    VALUES 
        ('John', 'Doe', 'john.doe@example.com', '555-0101', '123 Main Street', 'New York', 'NY', '10001', GETDATE()),
        ('Jane', 'Smith', 'jane.smith@example.com', '555-0102', '456 Oak Avenue', 'Los Angeles', 'CA', '90001', GETDATE()),
        ('Robert', 'Johnson', 'robert.johnson@example.com', '555-0103', '789 Pine Road', 'Chicago', 'IL', '60601', GETDATE()),
        ('Emily', 'Williams', 'emily.williams@example.com', '555-0104', '321 Elm Street', 'Houston', 'TX', '77001', GETDATE()),
        ('Michael', 'Brown', 'michael.brown@example.com', '555-0105', '654 Maple Drive', 'Phoenix', 'AZ', '85001', GETDATE());
END
GO

-- Insert Sample Orders
DECLARE @CustomerId1 INT = (SELECT TOP 1 [Id] FROM [Customers] WHERE [Email] = 'john.doe@example.com');
DECLARE @CustomerId2 INT = (SELECT TOP 1 [Id] FROM [Customers] WHERE [Email] = 'jane.smith@example.com');
DECLARE @ProductId1 INT = (SELECT TOP 1 [Id] FROM [Products] WHERE [Name] = 'Premium Honey');
DECLARE @ProductId2 INT = (SELECT TOP 1 [Id] FROM [Products] WHERE [Name] = 'Honey Comb');
DECLARE @ProductId3 INT = (SELECT TOP 1 [Id] FROM [Products] WHERE [Name] = 'Beeswax Candles');
DECLARE @OrderId1 INT;
DECLARE @OrderId2 INT;

IF @CustomerId1 IS NOT NULL AND @ProductId1 IS NOT NULL AND @ProductId2 IS NOT NULL
BEGIN
    -- Order 1
    IF NOT EXISTS (SELECT * FROM [Orders] WHERE [CustomerId] = @CustomerId1 AND [OrderDate] = CAST('2024-01-15' AS DATETIME2))
    BEGIN
        INSERT INTO [Orders] ([CustomerId], [OrderDate], [Status], [TotalAmount], [ShippingAddress])
        VALUES (@CustomerId1, '2024-01-15', 'Paid', 43.98, '123 Main Street, New York, NY 10001');
        
        SET @OrderId1 = SCOPE_IDENTITY();
        
        INSERT INTO [OrderItems] ([OrderId], [ProductId], [Quantity], [UnitPrice])
        VALUES 
            (@OrderId1, @ProductId1, 1, 24.99),
            (@OrderId1, @ProductId2, 1, 18.99);
    END
    
    -- Order 2
    IF @CustomerId2 IS NOT NULL AND @ProductId3 IS NOT NULL
    BEGIN
        IF NOT EXISTS (SELECT * FROM [Orders] WHERE [CustomerId] = @CustomerId2 AND [OrderDate] = CAST('2024-01-20' AS DATETIME2))
        BEGIN
            INSERT INTO [Orders] ([CustomerId], [OrderDate], [Status], [TotalAmount], [ShippingAddress])
            VALUES (@CustomerId2, '2024-01-20', 'Shipped', 25.98, '456 Oak Avenue, Los Angeles, CA 90001');
            
            SET @OrderId2 = SCOPE_IDENTITY();
            
            INSERT INTO [OrderItems] ([OrderId], [ProductId], [Quantity], [UnitPrice])
            VALUES 
                (@OrderId2, @ProductId2, 1, 18.99),
                (@OrderId2, @ProductId3, 1, 12.99);
        END
    END
END
GO

-- Insert Sample Payments
DECLARE @PaidOrderId INT = (SELECT TOP 1 [Id] FROM [Orders] WHERE [Status] = 'Paid' ORDER BY [Id] DESC);

IF @PaidOrderId IS NOT NULL AND NOT EXISTS (SELECT * FROM [Payments] WHERE [OrderId] = @PaidOrderId)
BEGIN
    INSERT INTO [Payments] ([OrderId], [PaymentMethod], [Amount], [CardNumber], [CardHolderName], [ExpiryDate], [Status], [PaymentDate], [TransactionId])
    VALUES (@PaidOrderId, 'Credit Card', 43.98, '****-****-****-1234', 'John Doe', '12/25', 'Completed', '2024-01-15', NEWID());
END
GO

PRINT 'Seed data inserted successfully!';
GO

-- Display summary
SELECT 
    (SELECT COUNT(*) FROM [Products]) AS TotalProducts,
    (SELECT COUNT(*) FROM [Customers]) AS TotalCustomers,
    (SELECT COUNT(*) FROM [Orders]) AS TotalOrders,
    (SELECT COUNT(*) FROM [Payments]) AS TotalPayments;
GO

