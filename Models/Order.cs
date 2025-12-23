using System.ComponentModel.DataAnnotations;

namespace Honeybee.Models
{
    public class Order
    {
        public int Id { get; set; }

        [Required]
        public int CustomerId { get; set; }

        public Customer Customer { get; set; } = null!;

        public DateTime OrderDate { get; set; } = DateTime.Now;

        [Required]
        [StringLength(50)]
        public string Status { get; set; } = "Pending";

        [Required]
        public decimal TotalAmount { get; set; }

        [StringLength(500)]
        public string? ShippingAddress { get; set; }

        // Navigation properties
        public ICollection<OrderItem> OrderItems { get; set; } = new List<OrderItem>();
        public Payment? Payment { get; set; }
    }
}

