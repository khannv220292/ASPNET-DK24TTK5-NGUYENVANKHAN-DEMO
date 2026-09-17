using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Security;
using ProTechTiveGear.Models;

namespace ProTechTiveGear.Controllers
{
    public class ShopController : Controller
    {
		ProTechTiveGearEntities data = new ProTechTiveGearEntities();

		public ActionResult Signout()
		{
			Session["usr"] = null;
			Session["Account"] = null;
			Session["Cart"] = null;
			Session.Clear();
			Session.Abandon();
			FormsAuthentication.SignOut();

			ExpireCookie("usr");
			ExpireCookie("Name");
			ExpireCookie("avatar");

			return RedirectToAction("Index", "Shop");
		}

		private void ExpireCookie(string name)
		{
			if (Request.Cookies[name] != null)
			{
				Response.Cookies.Add(new HttpCookie(name) { Expires = DateTime.Now.AddDays(-1) });
			}
		}
		public ActionResult Search()
		{

			//var model = data.Items.Where(nv => nv.Name.Contains(search) || search == null).ToList();
			//return View(model);
			return PartialView();

		}
		private List<Item> NewItem(int count)
		{
			return data.Items.Where(d=>d.Active==true).OrderByDescending(a => a.DateImport).Take(count).ToList();
		}
		public ActionResult Index(string search, string hang, string sapxep)
        {
			sapxep = (sapxep ?? "").Trim().ToLowerInvariant();
			if (string.IsNullOrEmpty(sapxep)) sapxep = "gia-asc";
			search = (search ?? "").Trim();

			var q = data.Items.Include("ItemType.Menu").Include("OrderDetails").Where(x => x.Active == true);
			if (!string.IsNullOrEmpty(search))
			{
				string key = search;
				q = q.Where(nv =>
					(nv.Name != null && nv.Name.Contains(key)) ||
					(nv.ShortTitle != null && nv.ShortTitle.Contains(key)) ||
					(nv.Describe != null && nv.Describe.Contains(key)) ||
					(nv.ItemType != null && nv.ItemType.TypeName != null && nv.ItemType.TypeName.Contains(key)) ||
					(nv.ItemType != null && nv.ItemType.Menu != null && nv.ItemType.Menu.Name != null && nv.ItemType.Menu.Name.Contains(key)));
			}
			if (!string.IsNullOrEmpty(hang))
			{
				q = q.Where(x =>
					(x.ItemType != null && x.ItemType.Menu != null && x.ItemType.Menu.Name == hang) ||
					(x.Name != null && x.Name.Contains(hang)));
			}
			var list = q.ToList();

			// Tim thay dung 1 san pham → mo trang chi tiet
			if (!string.IsNullOrEmpty(search) && list.Count == 1)
			{
				return RedirectToAction("Detail", new { id = list[0].ID });
			}

			list = ApplyProductSort(list, sapxep);

			var model = list;
			ViewBag.Hang = hang;
			ViewBag.SapXep = sapxep;
			ViewBag.Search = search;
			ViewBag.TotalCount = model.Count;
			ViewBag.HangList = data.Menus.ToList()
				.Where(m => m.Name != null
					&& !(m.Name.StartsWith("Ph") && m.Name != "HP")
					&& !string.Equals(m.Name.Trim(), "LG", StringComparison.OrdinalIgnoreCase)
					&& !string.Equals(m.Name.Trim(), "App", StringComparison.OrdinalIgnoreCase))
				.GroupBy(m => m.Name.Trim(), StringComparer.OrdinalIgnoreCase)
				.Select(g => g.OrderBy(x => x.ID).First().Name)
				.OrderBy(n => n)
				.ToList();

			// Khi dang tim kiem: khong can khoi noi bat (tranh lech ket qua)
			if (!string.IsNullOrEmpty(search))
			{
				ViewBag.FeaturedItems = new List<Item>();
				ViewBag.NewItems = new List<Item>();
				ViewBag.BrandName = "Laptop";
				ViewBag.BrandId = 0L;
				ViewBag.Theme = "#0b5cab";
				ViewBag.Hero = "";
				ViewBag.HideBanner = true;
				return View(model);
			}
			// Du lieu khoi noi bat: xoay nhieu hang (giong san pham moi)
			try
			{
				var allActive = data.Items.Include("ItemType.Menu").Include("Brand")
					.Where(x => x.Active == true)
					.ToList();
				var menus = data.Menus.ToList()
					.Where(m => m.Name != null
						&& !(m.Name.StartsWith("Ph") && m.Name != "HP")
						&& !string.Equals(m.Name.Trim(), "LG", StringComparison.OrdinalIgnoreCase)
						&& !string.Equals(m.Name.Trim(), "App", StringComparison.OrdinalIgnoreCase))
					.GroupBy(m => m.Name.Trim(), StringComparer.OrdinalIgnoreCase)
					.Select(g => g.OrderBy(x => x.ID).First())
					.OrderBy(m => m.Name)
					.ToList();

				var slides = new List<FeaturedSlideInfo>();
				foreach (var m in menus)
				{
					var brandItems = allActive
						.Where(x => FeaturedSetting.IsOfBrand(x, m))
						.OrderByDescending(x => x.DateImport)
						.Take(4)
						.ToList();
					if (brandItems.Count == 0) continue;
					slides.Add(new FeaturedSlideInfo
					{
						BrandName = m.Name,
						BrandId = m.ID,
						Theme = FeaturedSetting.ColorOf(m.Name),
						Items = brandItems
					});
				}

				// Xoay thu tu theo gio de moi lan vao trang thu tu hang khac nhau
				if (slides.Count > 1)
				{
					int shift = DateTime.Now.Hour % slides.Count;
					slides = slides.Skip(shift).Concat(slides.Take(shift)).ToList();
				}

				var newest = allActive.OrderByDescending(x => x.DateImport).Take(10).ToList();
				ViewBag.FeaturedSlides = slides;
				ViewBag.FeaturedItems = slides.Count > 0 ? slides[0].Items : new List<Item>();
				ViewBag.NewItems = newest;
				ViewBag.BrandName = slides.Count > 0 ? slides[0].BrandName : "Laptop";
				ViewBag.BrandId = slides.Count > 0 ? slides[0].BrandId : 0L;
				ViewBag.Theme = slides.Count > 0 ? slides[0].Theme : "#0b5cab";
				ViewBag.Hero = slides.Count > 0 && slides[0].Items.Count > 0
					? (slides[0].Items[0].Picture ?? "").Split('|')[0]
					: "";
			}
			catch
			{
				ViewBag.FeaturedSlides = new List<FeaturedSlideInfo>();
				ViewBag.FeaturedItems = new List<Item>();
				ViewBag.NewItems = new List<Item>();
				ViewBag.BrandName = "Laptop";
				ViewBag.BrandId = 0L;
				ViewBag.Theme = "#0b5cab";
				ViewBag.Hero = "";
			}

			return View(model);
		}

		/// <summary>Sap xep danh sach san pham theo ma sapxep.</summary>
		internal static List<Item> ApplyProductSort(List<Item> list, string sapxep)
		{
			if (list == null) return new List<Item>();
			sapxep = (sapxep ?? "").Trim().ToLowerInvariant();
			switch (sapxep)
			{
				case "gia-desc":
					return list.OrderByDescending(c => c.SellPrice).ThenBy(c => c.Name).ToList();
				case "moi":
					return list.OrderByDescending(c => c.DateImport ?? DateTime.MinValue).ThenBy(c => c.Name).ToList();
				case "km":
					return list.OrderByDescending(c =>
					{
						decimal sell = c.SellPrice;
						decimal oldP = (c.PurcharsePrice.HasValue && c.PurcharsePrice.Value > sell) ? c.PurcharsePrice.Value : sell;
						return oldP > sell ? (oldP - sell) / oldP : 0m;
					}).ThenBy(c => c.SellPrice).ToList();
				case "ban-chay":
					return list.OrderByDescending(c => c.OrderDetails != null ? c.OrderDetails.Sum(o => o.Quantity) : 0)
						.ThenBy(c => c.Name).ToList();
				case "ten":
					return list.OrderBy(c => c.Name).ToList();
				case "gia-asc":
				default:
					return list.OrderBy(c => c.SellPrice).ThenBy(c => c.Name).ToList();
			}
		}
		public ActionResult Detail(int id)
		{
			var gear = data.Items.Include("ItemType.Menu").FirstOrDefault(t => t.ID == id);
			return View(gear);
		}
		public ActionResult Menu()
		{
			var hide = new HashSet<string>(StringComparer.OrdinalIgnoreCase)
			{
				"Phụ kiện", "LG", "App"
			};
			var menu = data.Menus
				.ToList()
				.Where(t =>
				{
					if (string.IsNullOrWhiteSpace(t.Name)) return false;
					var n = t.Name.Trim();
					if (hide.Contains(n)) return false;
					if (n.StartsWith("Ph") && n != "HP") return false;
					return true;
				})
				.GroupBy(t => t.Name.Trim(), StringComparer.OrdinalIgnoreCase)
				.Select(g => g.OrderBy(x => x.ID).First())
				.OrderBy(t => t.ID)
				.ToList();
			return PartialView(menu);
		}
		public ActionResult ItemMenuType(long id)
		{


			var b = (from t in data.ItemTypes where t.MenuID == id select t).ToList();

			return PartialView(b);
		}
		public ActionResult Brandtype(long id)
		{


			var c = (from d in data.Brands where d.MenuID == id select d).ToList();

			return PartialView(c);
		}
		public ActionResult ProductbyType(long id)
		{
			var type = data.ItemTypes.FirstOrDefault(t => t.ID == id);
			ViewBag.TitleList = type != null ? type.TypeName : "Laptop";
			ViewBag.HideBanner = true;
			var all = data.Items.Include("ItemType.Menu").Include("Brand").Where(d => d.Active == true).ToList();
			var menuHint = new Menu { Name = type != null ? type.TypeName : "" };
			var pr = all.Where(d => d.TypeID == id || FeaturedSetting.IsOfBrand(d, menuHint)).OrderBy(d => d.SellPrice).ToList();
			return View(pr);
		}
		public ActionResult ProductbyMenu(long id)
		{
			var menu = data.Menus.FirstOrDefault(m => m.ID == id);
			var all = data.Items.Include("ItemType.Menu").Include("Brand").Where(d => d.Active == true).ToList();
			var pr = all.Where(d =>
				(d.ItemType != null && d.ItemType.MenuID == id)
				|| FeaturedSetting.IsOfBrand(d, menu)
			).OrderByDescending(d => d.DateImport).ToList();
			ViewBag.TitleList = menu != null ? menu.Name : "Laptop";
			ViewBag.HideBanner = true;
			return View("ProductbyType", pr);
		}
		public ActionResult BrandbyType(long id)
		{
			var brand = data.Brands.FirstOrDefault(b => b.ID == id);
			var all = data.Items.Include("ItemType.Menu").Include("Brand").Where(d => d.Active == true).ToList();
			var menuHint = new Menu { Name = brand != null ? brand.Name : "" };
			var pr = all.Where(d => d.BrandID == id || FeaturedSetting.IsOfBrand(d, menuHint)).OrderByDescending(d => d.DateImport).ToList();
			ViewBag.TitleList = brand != null ? brand.Name : "Laptop";
			ViewBag.HideBanner = true;
			return View("ProductbyType", pr);
		}
		public ActionResult Banner()
		{
			var bn = (from d in data.Banners select d).ToList();
			return PartialView(bn);
		}
		private List<Blog> NewBlogs(int count)
		{
			return data.Blogs.OrderByDescending(a => a.DateImport).Take(count).ToList();
		}
		public ActionResult Blog()
		{

			return View(NewBlogs(5));
		}
		public ActionResult BlogDetail(long id)
		{

			var blog = from t in data.Blogs
					   where t.ID == id
					   select t;
			return View(blog.Single());
		}
		public ActionResult RecentBlog()
		{

			return PartialView(NewBlogs(4));
		}
		public ActionResult Relatedproducts(long id)
		{
			var cur = data.Items.Include("ItemType.Menu").FirstOrDefault(t => t.ID == id);
			var all = data.Items.Include("ItemType.Menu").Where(t => t.Active == true && t.ID != id).ToList();
			List<Item> i;
			if (cur != null && cur.ItemType != null && cur.ItemType.Menu != null)
			{
				i = all.Where(x => FeaturedSetting.IsOfBrand(x, cur.ItemType.Menu)).Take(8).ToList();
			}
			else if (cur != null && cur.TypeID != null)
			{
				i = all.Where(x => x.TypeID == cur.TypeID).Take(8).ToList();
			}
			else
			{
				i = all.Take(8).ToList();
			}
			return PartialView(i);
		}
		public ActionResult Newdproducts()
		{
			
			return PartialView(NewItem(5));
		}
		//public ActionResult Helmetss()
		//{

		//		long id = 1;


		//	var i = data.ItemTypes.Find(
		//	var listitem=data.ItemTypes.Where(a=>a.ID==id)
		//		var temp = db.Clients.Find(id);
		//		var listorder = db.Orders.Where(o => o.IDClient == id);
		//		var lissordetai = db.OrderDetails.Where(d => d.Order.IDClient == id);
		//		ViewBag.listorder = listorder;
		//		//ViewBag.lissordetai = lissordetai;
		//		return View(new ClientManagerEntity(temp));

		//}
		public ActionResult Helmets()
		{
			long id = 2;
			var i = from t in data.Items
					join c in data.ItemTypes on t.TypeID equals c.ID
					//join d in data.Menus on c.MenuID equals d.ID
					where c.MenuID == id && t.Active==true
					select new { t, c };
			List<HelmetsEntity> listhl = new List<HelmetsEntity>();

			foreach (var info in i.ToList())
			{
				HelmetsEntity hl = new HelmetsEntity();
				hl.Name = info.t.Name;
				hl.Picture = info.t.Picture;
				hl.Quantity = info.t.Quantity;
				hl.Sellprice = info.t.SellPrice;
				hl.Status = info.t.ShortTitle;
				hl.Describe = info.t.Describe;
				listhl.Add(hl);
			}
			//long id = 2;
			//var temp = data.Menus.Find(id);
			//var a = data.ItemTypes.Where(b => b.MenuID == id);

			//var listorder = db.Orders.Where(o => o.IDClient == id);
			//var lissordetai = db.OrderDetails.Where(d => d.Order.IDClient == id);
			//ViewBag.listorder = listorder;
			////ViewBag.lissordetai = lissordetai;
			//return View(new ClientManagerEntity(temp));

			return View(listhl);
		}
		public ActionResult RiddingGear()
		{
			long id = 3;
			var i = from t in data.Items
					join c in data.ItemTypes on t.TypeID equals c.ID

					where c.MenuID == id && t.Active == true
					select new { t, c };
			List<HelmetsEntity> listhl = new List<HelmetsEntity>();

			foreach (var info in i.ToList())
			{
				HelmetsEntity hl = new HelmetsEntity();
				hl.Name = info.t.Name;
				hl.Picture = info.t.Picture;
				hl.Quantity = info.t.Quantity;
				hl.Sellprice = info.t.SellPrice;
				hl.Status = info.t.ShortTitle;
				hl.Describe = info.t.Describe;
				listhl.Add(hl);
			}


			return View(listhl);
		}

		public ActionResult Accsesories()
		{
			long id = 4;
			var i = from t in data.Items
					join c in data.ItemTypes on t.TypeID equals c.ID

					where c.MenuID == id && t.Active==true
					select new { t, c };
			List<HelmetsEntity> listhl = new List<HelmetsEntity>();

			foreach (var info in i.ToList())
			{
				HelmetsEntity hl = new HelmetsEntity();
				hl.Name = info.t.Name;
				hl.Picture = info.t.Picture;
				hl.Quantity = info.t.Quantity;
				hl.Sellprice = info.t.SellPrice;
				hl.Status = info.t.ShortTitle;
				hl.Describe = info.t.Describe;
				listhl.Add(hl);
			}


			return View(listhl);
		}
		//public ActionResult DetailProduct(long? id)
		//{

		//	var temp = data.Items.Find(id);

		//	return View(new ItemEntity(temp));
		//}
		public ActionResult DetailProduct(long id)
		{


			var i = from t in data.Items
					join c in data.ItemTypes on t.TypeID equals c.ID

					where t.ID.Equals(id)
					select t;
			List<HelmetsEntity> listhl = new List<HelmetsEntity>();

			foreach (var info in i)
			{
				HelmetsEntity hl = new HelmetsEntity();
				//var a = from t in data.Items where t.ID == hl.ID;
				hl.Name = info.Name;
				hl.Picture = info.Picture;
				hl.Quantity = info.Quantity;
				hl.Sellprice = info.SellPrice;
				hl.Status = info.ShortTitle;
				hl.Describe = info.Describe;
				listhl.Add(hl);
			}


			return View(listhl);

		}
		public ActionResult Brand()
		{

			var i = from t in data.Brands select t;
				

			return View(i.ToList());
		}
		public ActionResult Contact()
		{
			return View();
		}
		public ActionResult Sessionlogin()
		{
			return PartialView();
		}
		public ActionResult ListOrderClient()
		{
			var ac = (Customer)Session["usr"];
			if (ac == null)
			{
				return RedirectToAction("Login", "Login");
			}
			
			var temp = data.Orders.Where(p => p.Customer.Username == ac.Username);
			List<OrderEntity> listProdcut = new List<OrderEntity>();
			foreach (var item in temp)
			{
				OrderEntity pr = new OrderEntity();
				pr.TypeOf_OrderEntity(item);
				listProdcut.Add(pr);
			}
			

			return View(listProdcut);

			
		}
		public ActionResult ListOrderDetailClient(long? id)
		{
			var temp = data.OrderDetails.Where(d => d.OrderID == id);
			List<OrderDetailEntity> listdetail = new List<OrderDetailEntity>();
			foreach (var item in temp)
			{
				OrderDetailEntity or = new OrderDetailEntity();
				or.TypeOf_OrderEntity(item);
				listdetail.Add(or);
			}
			
		
			return PartialView(listdetail);

		}
		public ActionResult CancelOrder(long? id)
		{
			var temp = data.OrderDetails.Where(d => d.OrderID == id);
			List<OrderDetailEntity> listdetail = new List<OrderDetailEntity>();
			foreach (var item in temp)
			{
				OrderDetailEntity or = new OrderDetailEntity();
				or.TypeOf_OrderEntity(item);
				listdetail.Add(or);
			}
			ViewBag.Date = data.Orders.SingleOrDefault(a => a.ID == id).Deliverydate;
			ViewBag.id = id;
			return View(listdetail);

		}
		[HttpPost]

		public ActionResult CancelOrder(FormCollection fc)
		{
			
			long id = Convert.ToInt64(fc["id"]);
			var tem = data.Orders.SingleOrDefault(d => d.ID == id);

			tem.Deliverystatus = false;
		
			data.SaveChanges();


			return RedirectToAction("ListOrderClient");

		}
		public ActionResult Profile()
		{
			var ac = (Customer)Session["usr"];


			var t = from a in data.Customers where a.Username == ac.Username select a;


			return View(t.ToList());


		}

		public ActionResult FeaturedBrand()
		{
			try
			{
				var menu = FeaturedSetting.Resolve(data, Server);
				if (menu == null)
				{
					ViewBag.BrandName = "Laptop";
					ViewBag.BrandId = 0;
					ViewBag.Theme = "#0b5cab";
					ViewBag.Hero = "";
					ViewBag.NewItems = new List<Item>();
					return PartialView(new List<Item>());
				}
				var items = data.Items.Include("ItemType.Menu").Include("Brand")
					.Where(x => x.Active == true)
					.ToList()
					.Where(x => FeaturedSetting.IsOfBrand(x, menu))
					.OrderByDescending(x => x.DateImport)
					.Take(10)
					.ToList();
				var newest = data.Items.Include("ItemType.Menu").Include("Brand")
					.Where(x => x.Active == true)
					.OrderByDescending(x => x.DateImport)
					.Take(10)
					.ToList();
				ViewBag.BrandName = menu.Name;
				ViewBag.BrandId = menu.ID;
				ViewBag.Theme = FeaturedSetting.ColorOf(menu.Name);
				ViewBag.Hero = items.Count > 0 ? (items[0].Picture ?? "").Split('|')[0] : "";
				ViewBag.NewItems = newest;
				return PartialView(items);
			}
			catch
			{
				ViewBag.BrandName = "Laptop";
				ViewBag.BrandId = 0;
				ViewBag.Theme = "#0b5cab";
				ViewBag.Hero = "";
				ViewBag.NewItems = new List<Item>();
				return PartialView(new List<Item>());
			}
		}
	}

	public class FeaturedSlideInfo
	{
		public string BrandName { get; set; }
		public long BrandId { get; set; }
		public string Theme { get; set; }
		public List<Item> Items { get; set; }
	}

	public static class FeaturedSetting
	{
		public static string FilePath(HttpServerUtilityBase server)
		{
			var dir = server.MapPath("~/App_Data");
			if (!System.IO.Directory.Exists(dir))
				System.IO.Directory.CreateDirectory(dir);
			return System.IO.Path.Combine(dir, "featured.txt");
		}

		public static void Save(HttpServerUtilityBase server, bool auto, long? menuId)
		{
			var line = auto ? "AUTO" : ("ID:" + (menuId ?? 0));
			System.IO.File.WriteAllText(FilePath(server), line);
		}

		public static bool IsAuto(HttpServerUtilityBase server)
		{
			var p = FilePath(server);
			if (!System.IO.File.Exists(p)) return true;
			var t = System.IO.File.ReadAllText(p).Trim();
			return string.IsNullOrEmpty(t) || t.StartsWith("AUTO", StringComparison.OrdinalIgnoreCase);
		}

		public static long? SavedId(HttpServerUtilityBase server)
		{
			var p = FilePath(server);
			if (!System.IO.File.Exists(p)) return null;
			var t = System.IO.File.ReadAllText(p).Trim();
			if (t.StartsWith("ID:", StringComparison.OrdinalIgnoreCase))
			{
				long id;
				if (long.TryParse(t.Substring(3), out id)) return id;
			}
			return null;
		}

		public static Menu Resolve(ProTechTiveGearEntities db, HttpServerUtilityBase server)
		{
			var menus = db.Menus.ToList()
				.Where(m => m.Name != null && !(m.Name.StartsWith("Ph") && m.Name != "HP"))
				.OrderBy(m => m.Name)
				.ToList();
			if (menus.Count == 0) return db.Menus.FirstOrDefault();
			if (!IsAuto(server))
			{
				var id = SavedId(server);
				var pick = menus.FirstOrDefault(x => x.ID == id);
				if (pick != null) return pick;
			}
			var items = db.Items.Include("ItemType").Include("Brand").Where(x => x.Active == true).ToList();
			var withProducts = menus.Where(m => items.Any(i => IsOfBrand(i, m))).ToList();
			if (withProducts.Count == 0) return menus[DateTime.Now.DayOfYear % menus.Count];
			return withProducts[DateTime.Now.DayOfYear % withProducts.Count];
		}

		public static bool IsOfBrand(Item x, Menu menu)
		{
			if (x == null || menu == null || string.IsNullOrEmpty(menu.Name)) return false;
			string want = DetectBrand(menu.Name);
			string blob = (x.Name ?? "") + " " + (x.ShortTitle ?? "");
			if (x.ItemType != null) blob += " " + (x.ItemType.TypeName ?? "");
			string fromText = DetectBrand(blob);
			if (fromText != null)
			{
				return want != null && fromText == want;
			}
			if (x.Brand != null && !string.IsNullOrEmpty(x.Brand.Name))
			{
				string fromBrand = DetectBrand(x.Brand.Name);
				if (fromBrand != null) return want != null && fromBrand == want;
			}
			if (x.ItemType != null && x.ItemType.Menu != null && !string.IsNullOrEmpty(x.ItemType.Menu.Name))
			{
				string fromMenu = DetectBrand(x.ItemType.Menu.Name);
				if (fromMenu != null) return want != null && fromMenu == want;
			}
			return want != null && x.ItemType != null && x.ItemType.MenuID == menu.ID;
		}

		static string DetectBrand(string text)
		{
			if (string.IsNullOrEmpty(text)) return null;
			string u = text.ToUpperInvariant();
			if (HasToken(u, "LENOVO") || HasToken(u, "THINKPAD") || HasToken(u, "IDEAPAD") || HasToken(u, "LEGION") || HasToken(u, "YOGA"))
			{
				return "LENOVO";
			}
			if (HasToken(u, "ASUS") || HasToken(u, "ROG") || u.IndexOf("TUF GAMING", StringComparison.Ordinal) >= 0 || HasToken(u, "VIVOBOOK") || HasToken(u, "ZENBOOK"))
			{
				return "ASUS";
			}
			if (HasToken(u, "DELL") || HasToken(u, "LATITUDE") || HasToken(u, "INSPIRON") || HasToken(u, "XPS") || HasToken(u, "VOSTRO") || HasToken(u, "ALIENWARE"))
			{
				return "DELL";
			}
			if (HasToken(u, "APPLE") || HasToken(u, "MACBOOK") || u.IndexOf("MAC BOOK", StringComparison.Ordinal) >= 0)
			{
				return "APPLE";
			}
			if (HasToken(u, "ACER") || HasToken(u, "PREDATOR") || HasToken(u, "SWIFT") || HasToken(u, "ASPIRE"))
			{
				return "ACER";
			}
			if (HasToken(u, "MSI"))
			{
				return "MSI";
			}
			if (HasToken(u, "GIGABYTE") || HasToken(u, "AORUS"))
			{
				return "GIGABYTE";
			}
			if (HasToken(u, "LG") || HasToken(u, "GRAM"))
			{
				return "LG";
			}
			if (HasToken(u, "HP") || HasToken(u, "OMNIBOOK") || HasToken(u, "PROBOOK") || HasToken(u, "ELITEBOOK") || HasToken(u, "VICTUS") || HasToken(u, "PAVILION") || HasToken(u, "ENVY"))
			{
				return "HP";
			}
			return null;
		}

		static bool HasToken(string hay, string token)
		{
			int i = hay.IndexOf(token, StringComparison.Ordinal);
			while (i >= 0)
			{
				bool leftOk = i == 0 || !char.IsLetterOrDigit(hay[i - 1]);
				int end = i + token.Length;
				bool rightOk = end >= hay.Length || !char.IsLetterOrDigit(hay[end]);
				if (leftOk && rightOk) return true;
				i = hay.IndexOf(token, i + 1, StringComparison.Ordinal);
			}
			return false;
		}

		public static string ColorOf(string name)
		{
			if (string.IsNullOrEmpty(name)) return "#0b5cab";
			var n = name.ToUpperInvariant();
			if (n.Contains("ASUS")) return "#0b5cab";
			if (n.Contains("DELL")) return "#0076ce";
			if (n.Contains("LENOVO")) return "#e2231a";
			if (n.Contains("HP")) return "#0096d6";
			if (n.Contains("ACER")) return "#83b81a";
			if (n.Contains("MSI")) return "#d32f2f";
			if (n.Contains("APPLE") || n.Contains("MAC")) return "#555555";
			if (n.Contains("LG")) return "#a50034";
			if (n.Contains("GIGABYTE")) return "#ee6b00";
			return "#0b5cab";
		}
	}
}