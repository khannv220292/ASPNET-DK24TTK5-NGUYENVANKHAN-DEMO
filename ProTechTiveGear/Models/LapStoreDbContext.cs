using System.Data.Entity;
using System.Data.Entity.ModelConfiguration.Conventions;

namespace ProTechTiveGear.Models
{
	/// <summary>
	/// DbContext Code First ánh xạ CSDL webgaming (cùng bảng với EDMX Database First).
	/// Không tự tạo/xóa CSDL: SetInitializer = null.
	/// </summary>
	public class LapStoreDbContext : DbContext
	{
		public LapStoreDbContext()
			: base("name=LapStoreDbContext")
		{
			Database.SetInitializer<LapStoreDbContext>(null);
		}

		public DbSet<Item> Items { get; set; }
		public DbSet<Brand> Brands { get; set; }
		public DbSet<ItemType> ItemTypes { get; set; }
		public DbSet<Customer> Customers { get; set; }
		public DbSet<Order> Orders { get; set; }
		public DbSet<OrderDetail> OrderDetails { get; set; }
		public DbSet<Admin> Admins { get; set; }

		protected override void OnModelCreating(DbModelBuilder modelBuilder)
		{
			modelBuilder.Conventions.Remove<PluralizingTableNameConvention>();

			modelBuilder.Entity<Item>().ToTable("Item");
			modelBuilder.Entity<Brand>().ToTable("Brand");
			modelBuilder.Entity<ItemType>().ToTable("ItemType");
			modelBuilder.Entity<Customer>().ToTable("Customer");
			modelBuilder.Entity<Order>().ToTable("Order");
			modelBuilder.Entity<OrderDetail>().ToTable("OrderDetail");
			modelBuilder.Entity<Admin>().ToTable("Admin");
			modelBuilder.Entity<Admin>().HasKey(a => a.Username);

			// Bảng phụ (Menu, Payment, Feedback...) vẫn do EDMX quản lý — không map ở đây
			modelBuilder.Entity<Brand>().Ignore(x => x.Menu);
			modelBuilder.Entity<ItemType>().Ignore(x => x.Menu);
			modelBuilder.Entity<Customer>().Ignore(x => x.Feedbacks);
			modelBuilder.Entity<Customer>().Ignore(x => x.ReplyFeedbacks);
			modelBuilder.Entity<Order>().Ignore(x => x.Payments);

			base.OnModelCreating(modelBuilder);
		}
	}
}
