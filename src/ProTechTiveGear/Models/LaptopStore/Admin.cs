using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace LaptopStore.Models
{
    [Table("Admin")]
    public class StoreAdmin
    {
        [Key]
        [StringLength(50)]
        public string Username { get; set; }

        [Required]
        [StringLength(50)]
        public string Passwords { get; set; }

        [StringLength(100)]
        public string Name { get; set; }
    }
}
