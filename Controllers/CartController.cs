using Microsoft.AspNetCore.Mvc;
using System.Text.Json;
using Honeybee.Data;
using Honeybee.Models;

namespace Honeybee.Controllers
{
    public class CartController : Controller
    {
        private readonly HoneybeeDbContext _context;

        public CartController(HoneybeeDbContext context)
        {
            _context = context;
        }

        // GET: Cart
        public IActionResult Index()
        {
            var cart = GetCart();
            return View(cart);
        }

        // POST: Cart/Add
        [HttpPost]
        public async Task<IActionResult> Add(int productId, int quantity = 1)
        {
            var product = await _context.Products.FindAsync(productId);
            if (product == null || product.StockQuantity < quantity)
            {
                return Json(new { success = false, message = "Product not available or insufficient stock" });
            }

            var cart = GetCart();
            var existingItem = cart.FirstOrDefault(c => c.ProductId == productId);

            if (existingItem != null)
            {
                if (existingItem.Quantity + quantity > product.StockQuantity)
                {
                    return Json(new { success = false, message = "Insufficient stock" });
                }
                existingItem.Quantity += quantity;
            }
            else
            {
                cart.Add(new CartItem
                {
                    ProductId = product.Id,
                    ProductName = product.Name,
                    Price = product.Price,
                    Quantity = quantity,
                    ImageUrl = product.ImageUrl
                });
            }

            SaveCart(cart);
            return Json(new { success = true, cartCount = cart.Sum(c => c.Quantity) });
        }

        // POST: Cart/Update
        [HttpPost]
        public async Task<IActionResult> Update(int productId, int quantity)
        {
            var product = await _context.Products.FindAsync(productId);
            if (product == null || product.StockQuantity < quantity)
            {
                return Json(new { success = false, message = "Insufficient stock" });
            }

            var cart = GetCart();
            var item = cart.FirstOrDefault(c => c.ProductId == productId);

            if (item != null)
            {
                if (quantity <= 0)
                {
                    cart.Remove(item);
                }
                else
                {
                    item.Quantity = quantity;
                }
                SaveCart(cart);
            }

            return Json(new { success = true, cartCount = cart.Sum(c => c.Quantity), total = cart.Sum(c => c.Subtotal) });
        }

        // POST: Cart/Remove
        [HttpPost]
        public IActionResult Remove(int productId)
        {
            var cart = GetCart();
            var item = cart.FirstOrDefault(c => c.ProductId == productId);
            if (item != null)
            {
                cart.Remove(item);
                SaveCart(cart);
            }

            return RedirectToAction(nameof(Index));
        }

        // POST: Cart/Clear
        [HttpPost]
        public IActionResult Clear()
        {
            HttpContext.Session.Remove("Cart");
            return RedirectToAction(nameof(Index));
        }

        // GET: Cart/Count
        [HttpGet]
        public IActionResult GetCount()
        {
            var cart = GetCart();
            return Json(new { count = cart.Sum(c => c.Quantity) });
        }

        private List<CartItem> GetCart()
        {
            var cartJson = HttpContext.Session.GetString("Cart");
            if (string.IsNullOrEmpty(cartJson))
            {
                return new List<CartItem>();
            }
            return JsonSerializer.Deserialize<List<CartItem>>(cartJson) ?? new List<CartItem>();
        }

        private void SaveCart(List<CartItem> cart)
        {
            var cartJson = JsonSerializer.Serialize(cart);
            HttpContext.Session.SetString("Cart", cartJson);
        }
    }
}

