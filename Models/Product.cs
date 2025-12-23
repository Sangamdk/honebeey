using System.ComponentModel.DataAnnotations;

namespace Honeybee.Models
{
    public class Product
    {
        public int Id { get; set; }

        [Required]
        [StringLength(200)]
        public string Name { get; set; } = string.Empty;

        [StringLength(1000)]
        public string? Description { get; set; }

        [Required]
        [Range(0.01, double.MaxValue, ErrorMessage = "Price must be greater than 0")]
        public decimal Price { get; set; }

        [Range(0, int.MaxValue)]
        public int StockQuantity { get; set; }

        [StringLength(200)]
        public string? ImageUrl { get; set; }

        [StringLength(100)]
        public string? Category { get; set; }

        public DateTime CreatedDate { get; set; } = DateTime.Now;
    }
}

