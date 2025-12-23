# Honeybee - Online Product Sale Portal

A modern web-based e-commerce application built with ASP.NET Core MVC and SQL Server.

## Features

- **Product Management**: Create, read, update, and delete products with categories, pricing, and inventory management
- **Customer Management**: Register and manage customer information
- **Shopping Cart**: Add products to cart, update quantities, and remove items
- **Order Management**: Create orders from cart items and track order status
- **Payment Processing**: Process payments for orders with multiple payment methods
- **Modern UI**: Beautiful, responsive design with Bootstrap 5 and Font Awesome icons

## Prerequisites

- .NET 8.0 SDK or later
- SQL Server (LocalDB is used by default, which comes with Visual Studio)
- Visual Studio 2022 or VS Code (optional)

## Getting Started

1. **Restore Dependencies**
   ```bash
   dotnet restore
   ```

2. **Update Database Connection** (if needed)
   - Open `appsettings.json`
   - Update the `ConnectionStrings:DefaultConnection` if you're using a different SQL Server instance

3. **Run the Application**
   ```bash
   dotnet run
   ```

4. **Access the Application**
   - Open your browser and navigate to `https://localhost:5001` or `http://localhost:5000`
   - The database will be automatically created on first run

## Database

The application uses Entity Framework Core with SQL Server. The database is automatically created when you first run the application using `EnsureCreated()`.

### Database Schema

- **Products**: Product catalog with name, description, price, stock quantity, category, and image URL
- **Customers**: Customer information including name, email, phone, and address
- **Orders**: Order records with customer reference, order date, status, and total amount
- **OrderItems**: Individual items within an order
- **Payments**: Payment records linked to orders

## Project Structure

```
Honeybee/
├── Controllers/          # MVC Controllers
│   ├── HomeController.cs
│   ├── ProductsController.cs
│   ├── CustomersController.cs
│   ├── CartController.cs
│   ├── OrdersController.cs
│   └── PaymentController.cs
├── Models/              # Data Models
│   ├── Product.cs
│   ├── Customer.cs
│   ├── Order.cs
│   ├── OrderItem.cs
│   ├── Payment.cs
│   └── CartItem.cs
├── Views/               # Razor Views
│   ├── Home/
│   ├── Products/
│   ├── Customers/
│   ├── Cart/
│   ├── Orders/
│   ├── Payment/
│   └── Shared/
├── Data/                # Database Context
│   └── HoneybeeDbContext.cs
├── wwwroot/            # Static Files
│   ├── css/
│   └── js/
└── Program.cs          # Application Entry Point
```

## Usage

1. **Add Products**: Navigate to Products page and click "Create New Product"
2. **Register Customers**: Go to Customers page and add customer information
3. **Browse Products**: View products on the home page or Products page
4. **Add to Cart**: Click "Add to Cart" on any product
5. **View Cart**: Click the Cart icon in the navigation bar
6. **Create Order**: From the cart, click "Proceed to Checkout" and select a customer
7. **Process Payment**: After creating an order, process payment for the order
8. **View Orders**: Navigate to Orders page to see all orders

## Technologies Used

- ASP.NET Core 8.0 MVC
- Entity Framework Core 8.0
- SQL Server
- Bootstrap 5.3
- jQuery 3.7
- Font Awesome 6.4

## Notes

- This is a demo application. Payment processing is simulated and does not process real payments.
- The application uses session storage for cart functionality.
- Card numbers are masked for security (only last 4 digits are stored).

## License

This project is provided as-is for educational purposes.

