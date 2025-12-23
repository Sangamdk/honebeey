using Microsoft.AspNetCore.Mvc;
using Honeybee.Data;
using Microsoft.EntityFrameworkCore;

namespace Honeybee.Controllers
{
    public class HomeController : Controller
    {
        private readonly HoneybeeDbContext _context;
        private readonly ILogger<HomeController> _logger;

        public HomeController(HoneybeeDbContext context, ILogger<HomeController> logger)
        {
            _context = context;
            _logger = logger;
        }

        public async Task<IActionResult> Index()
        {
            var products = await _context.Products
                .Where(p => p.StockQuantity > 0)
                .OrderByDescending(p => p.CreatedDate)
                .Take(8)
                .ToListAsync();
            return View(products);
        }

        public IActionResult Privacy()
        {
            return View();
        }
    }
}

