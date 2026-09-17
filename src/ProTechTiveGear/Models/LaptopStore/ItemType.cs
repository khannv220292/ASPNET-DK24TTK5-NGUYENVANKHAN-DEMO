using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace LaptopStore.Models
{
    [Table("ItemType")]
    public class StoreItemType
    {
        [Key]
        public long ID { get; set; }

        [Required]
        [StringLength(100)]
        public string TypeName { get; set; }
    }
}
