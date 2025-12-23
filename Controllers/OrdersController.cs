using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Text.Json;
using Honeybee.Data;
using Honeybee.Models;

namespace Honeybee.Controllers
{
    public class OrdersController : Controller
    {
        private readonly HoneybeeDbContext _context;

        public OrdersController(HoneybeeDbContext context)
        {
            _context = context;
        }

        // GET: Orders
        public async Task<IActionResult> Index()
        {
            var orders = await _context.Orders
                .Include(o => o.Customer)
                .Include(o => o.OrderItems)
                    .ThenInclude(oi => oi.Product)
                .OrderByDescending(o => o.OrderDate)
                .ToListAsync();
            return View(orders);
        }

        // GET: Orders/Details/5
        public async Task<IActionResult> Details(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var order = await _context.Orders
                .Include(o => o.Customer)
                .Include(o => o.OrderItems)
                    .ThenInclude(oi => oi.Product)
                .Include(o => o.Payment)
                .FirstOrDefaultAsync(m => m.Id == id);
            if (order == null)
            {
                return NotFound();
            }

            return View(order);
        }

        // GET: Orders/Create
        public async Task<IActionResult> Create(int? customerId)
        {
            var cartJson = HttpContext.Session.GetString("Cart");
            if (string.IsNullOrEmpty(cartJson))
            {
                return RedirectToAction("Index", "Cart");
            }

            var cart = JsonSerializer.Deserialize<List<CartItem>>(cartJson);
            if (cart == null || cart.Count == 0)
            {
                return RedirectToAction("Index", "Cart");
            }

            ViewBag.Customers = await _context.Customers.ToListAsync();
            ViewBag.Cart = cart;
            ViewBag.SelectedCustomerId = customerId;

            return View();
        }

        // POST: Orders/Create
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create([Bind("CustomerId,ShippingAddress")] Order order)
        {
            var cartJson = HttpContext.Session.GetString("Cart");
            if (string.IsNullOrEmpty(cartJson))
            {
                return RedirectToAction("Index", "Cart");
            }

            var cart = JsonSerializer.Deserialize<List<CartItem>>(cartJson);
            if (cart == null || cart.Count == 0)
            {
                return RedirectToAction("Index", "Cart");
            }

            if (ModelState.IsValid)
            {
                order.OrderDate = DateTime.Now;
                order.Status = "Pending";
                order.TotalAmount = cart.Sum(c => c.Subtotal);

                _context.Add(order);
                await _context.SaveChangesAsync();

                foreach (var item in cart)
                {
                    var product = await _context.Products.FindAsync(item.ProductId);
                    if (product != null && product.StockQuantity >= item.Quantity)
                    {
                        var orderItem = new OrderItem
                        {
                            OrderId = order.Id,
                            ProductId = item.ProductId,
                            Quantity = item.Quantity,
                            UnitPrice = item.Price
                        };
                        _context.Add(orderItem);

                        product.StockQuantity -= item.Quantity;
                        _context.Update(product);
                    }
                }

                await _context.SaveChangesAsync();
                HttpContext.Session.Remove("Cart");

                return RedirectToAction("Details", new { id = order.Id });
            }

            ViewBag.Customers = await _context.Customers.ToListAsync();
            ViewBag.Cart = cart;
            return View(order);
        }

        // GET: Orders/Edit/5
        public async Task<IActionResult> Edit(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var order = await _context.Orders.FindAsync(id);
            if (order == null)
            {
                return NotFound();
            }
            return View(order);
        }

        // POST: Orders/Edit/5
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(int id, [Bind("Id,CustomerId,OrderDate,Status,TotalAmount,ShippingAddress")] Order order)
        {
            if (id != order.Id)
            {
                return NotFound();
            }

            if (ModelState.IsValid)
            {
                try
                {
                    _context.Update(order);
                    await _context.SaveChangesAsync();
                }
                catch (DbUpdateConcurrencyException)
                {
                    if (!OrderExists(order.Id))
                    {
                        return NotFound();
                    }
                    else
                    {
                        throw;
                    }
                }
                return RedirectToAction(nameof(Index));
            }
            return View(order);
        }

        private bool OrderExists(int id)
        {
            return _context.Orders.Any(e => e.Id == id);
        }
    }
}

