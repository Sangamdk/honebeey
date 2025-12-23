using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Honeybee.Data;
using Honeybee.Models;

namespace Honeybee.Controllers
{
    public class PaymentController : Controller
    {
        private readonly HoneybeeDbContext _context;

        public PaymentController(HoneybeeDbContext context)
        {
            _context = context;
        }

        // GET: Payment/Create/5
        public async Task<IActionResult> Create(int? orderId)
        {
            if (orderId == null)
            {
                return NotFound();
            }

            var order = await _context.Orders
                .Include(o => o.Customer)
                .Include(o => o.OrderItems)
                    .ThenInclude(oi => oi.Product)
                .FirstOrDefaultAsync(o => o.Id == orderId);

            if (order == null)
            {
                return NotFound();
            }

            if (order.Payment != null)
            {
                return RedirectToAction("Details", "Orders", new { id = orderId });
            }

            ViewBag.Order = order;
            return View();
        }

        // POST: Payment/Create
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create([Bind("OrderId,PaymentMethod,CardNumber,CardHolderName,ExpiryDate,CVV")] Payment payment)
        {
            var order = await _context.Orders
                .Include(o => o.OrderItems)
                .FirstOrDefaultAsync(o => o.Id == payment.OrderId);

            if (order == null)
            {
                return NotFound();
            }

            if (ModelState.IsValid)
            {
                payment.Amount = order.TotalAmount;
                payment.Status = "Completed";
                payment.PaymentDate = DateTime.Now;
                payment.TransactionId = Guid.NewGuid().ToString();

                // Mask card number for security (only store last 4 digits)
                if (!string.IsNullOrEmpty(payment.CardNumber) && payment.CardNumber.Length > 4)
                {
                    payment.CardNumber = "****-****-****-" + payment.CardNumber.Substring(payment.CardNumber.Length - 4);
                }

                _context.Add(payment);
                order.Status = "Paid";
                _context.Update(order);
                await _context.SaveChangesAsync();

                return RedirectToAction("Details", "Orders", new { id = payment.OrderId });
            }

            ViewBag.Order = order;
            return View(payment);
        }

        // GET: Payment/Details/5
        public async Task<IActionResult> Details(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var payment = await _context.Payments
                .Include(p => p.Order)
                    .ThenInclude(o => o.Customer)
                .Include(p => p.Order)
                    .ThenInclude(o => o.OrderItems)
                        .ThenInclude(oi => oi.Product)
                .FirstOrDefaultAsync(m => m.Id == id);
            if (payment == null)
            {
                return NotFound();
            }

            return View(payment);
        }
    }
}

