# Honeybee Database SQL Scripts

This folder contains SQL scripts to set up the Honeybee database.

## Files

### 1. `HoneybeeDB_Complete.sql` (Recommended)
**Complete setup script** - Creates database, tables, and inserts sample data in one go.
- Use this if you want to set up everything from scratch
- **Warning**: This script will drop existing tables if they exist

**Usage:**
```sql
-- Run this script in SQL Server Management Studio or Azure Data Studio
-- It will create the database, all tables, and populate with sample data
```

### 2. `HoneybeeDB_Schema.sql`
**Schema only** - Creates the database structure without data.
- Use this if you only want to create the tables
- Safe to run multiple times (checks if tables exist)

**Usage:**
```sql
-- Run this to create only the database schema
-- No data will be inserted
```

### 3. `HoneybeeDB_SeedData.sql`
**Sample data only** - Inserts sample products, customers, orders, and payments.
- Use this after running the schema script
- Includes checks to avoid duplicate data

**Usage:**
```sql
-- Run this after creating the schema to populate with sample data
-- Safe to run multiple times (won't create duplicates)
```

## Database Structure

### Tables
1. **Products** - Product catalog
   - Id, Name, Description, Price, StockQuantity, ImageUrl, Category, CreatedDate

2. **Customers** - Customer information
   - Id, FirstName, LastName, Email, Phone, Address, City, State, ZipCode, CreatedDate

3. **Orders** - Order records
   - Id, CustomerId, OrderDate, Status, TotalAmount, ShippingAddress

4. **OrderItems** - Order line items
   - Id, OrderId, ProductId, Quantity, UnitPrice

5. **Payments** - Payment records
   - Id, OrderId, PaymentMethod, Amount, CardNumber, CardHolderName, ExpiryDate, CVV, Status, PaymentDate, TransactionId

### Relationships
- Orders → Customers (Many-to-One)
- OrderItems → Orders (Many-to-One)
- OrderItems → Products (Many-to-One)
- Payments → Orders (One-to-One)

## Prerequisites

- SQL Server 2016 or later (or SQL Server Express/LocalDB)
- SQL Server Management Studio (SSMS) or Azure Data Studio

## Connection String

After running the scripts, update your `appsettings.json` if needed:

```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Server=(localdb)\\mssqllocaldb;Database=HoneybeeDB;Trusted_Connection=True;MultipleActiveResultSets=true"
  }
}
```

For SQL Server Express:
```
Server=.\SQLEXPRESS;Database=HoneybeeDB;Trusted_Connection=True;MultipleActiveResultSets=true
```

For SQL Server (named instance):
```
Server=localhost\SQLEXPRESS;Database=HoneybeeDB;Trusted_Connection=True;MultipleActiveResultSets=true
```

## Sample Data

The seed data includes:
- **8 Products** - Various honey-related products
- **5 Customers** - Sample customer records
- **2 Orders** - Sample order records with items
- **1 Payment** - Sample payment record

## Notes

- The scripts use `IDENTITY(1,1)` for auto-incrementing primary keys
- Foreign key constraints ensure referential integrity
- Indexes are created on foreign keys for better performance
- Email field in Customers table has a unique constraint
- Payment table has a unique constraint on OrderId (one payment per order)

