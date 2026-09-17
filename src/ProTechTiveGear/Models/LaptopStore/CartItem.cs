namespace LaptopStore.Models
{
    public class CartItem
    {
        public long ItemId { get; set; }
        public string ItemName { get; set; }
        public string Picture { get; set; }
        public decimal UnitPrice { get; set; }
        public int Quantity { get; set; }
        public decimal TotalPrice => UnitPrice * Quantity;
    }
}
