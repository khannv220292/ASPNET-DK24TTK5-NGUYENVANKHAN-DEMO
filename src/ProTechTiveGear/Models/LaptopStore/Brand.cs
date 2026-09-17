using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace LaptopStore.Models
{
    [Table("Brand")]
    public class StoreBrand
    {
        [Key]
        public long ID { get; set; }

        [Required]
        [StringLength(100)]
        public string Name { get; set; }
    }
}
