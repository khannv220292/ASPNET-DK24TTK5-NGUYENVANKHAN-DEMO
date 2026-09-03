using System.Data.Entity;

namespace LaptopStore.Models
{
    public class LapStoreDbContext : DbContext
    {
        public LapStoreDbContext() : base("name=LapStoreDbContext")
        {
            Database.SetInitializer<LapStoreDbContext>(null);
        }

        public virtual DbSet<StoreAdmin> Admins { get; set; }
        public virtual DbSet<StoreBrand> Brands { get; set; }
        public virtual DbSet<StoreItemType> ItemTypes { get; set; }
        public virtual DbSet<StoreItem> Items { get; set; }
        public virtual DbSet<StoreCustomer> Customers { get; set; }
        public virtual DbSet<StoreOrder> Orders { get; set; }
        public virtual DbSet<StoreOrderDetail> OrderDetails { get; set; }
    }
}
