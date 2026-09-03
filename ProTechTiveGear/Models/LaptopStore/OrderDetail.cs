using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace LaptopStore.Models
{
    [Table("OrderDetail")]
    public class StoreOrderDetail
    {
        [Key]
        public long ID { get; set; }

        public int Quantity { get; set; }

        public long? ItemId { get; set; }

        public long? OrderID { get; set; }

        public decimal Totalprice { get; set; }

        [ForeignKey("ItemId")]
        public virtual StoreItem Item { get; set; }

        [ForeignKey("OrderID")]
        public virtual StoreOrder Order { get; set; }
    }
}
