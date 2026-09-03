using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace LaptopStore.Models
{
    [Table("Order")]
    public class StoreOrder
    {
        [Key]
        public long ID { get; set; }

        public DateTime? Orderdate { get; set; }

        public bool? Status { get; set; }

        public bool? Deliverystatus { get; set; }

        public decimal? Totalprice { get; set; }

        public long? CustomerID { get; set; }

        [ForeignKey("CustomerID")]
        public virtual StoreCustomer Customer { get; set; }

        public virtual ICollection<StoreOrderDetail> OrderDetails { get; set; }
    }
}
