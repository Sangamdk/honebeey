using System.ComponentModel.DataAnnotations;

namespace Honeybee.Models
{
    public class Payment
    {
        public int Id { get; set; }

        [Required]
        public int OrderId { get; set; }

        public Order Order { get; set; } = null!;

        [Required]
        [StringLength(50)]
        public string PaymentMethod { get; set; } = "Credit Card";

        [Required]
        public decimal Amount { get; set; }

        [StringLength(100)]
        public string? CardNumber { get; set; }

        [StringLength(50)]
        public string? CardHolderName { get; set; }

        [StringLength(10)]
        public string? ExpiryDate { get; set; }

        [StringLength(10)]
        public string? CVV { get; set; }

        [Required]
        [StringLength(50)]
        public string Status { get; set; } = "Pending";

        public DateTime PaymentDate { get; set; } = DateTime.Now;

        [StringLength(500)]
        public string? TransactionId { get; set; }
    }
}

