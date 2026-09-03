using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Mvc;
using ProTechTiveGear.Models;
namespace ProTechTiveGear.Controllers
{
	
    public class ShopAdminController : Controller
    {
		// GET: Admin
		ProTechTiveGearEntities db = new ProTechTiveGearEntities();
		public ActionResult SignOut()
		{
			//FormsAuthentication.SignOut();
			Response.Cookies.Clear();
			return RedirectToAction("Login", "ShopAdmin");

		}
		public ActionResult Index()
        {
			DateTime dateTimeNow = DateTime.Now.Date;
			dateTimeNow = dateTimeNow.AddYears(-1);

			string[] dateX = new string[12];
			string[] data = new string[12];
			for (int i = 0; i < 12; i++)
			{

				dateX[i] = (dateTimeNow.Month.ToString() + "/" + dateTimeNow.Year.ToString()).ToString();
				var temp = db.Orders.Where(a => a.Orderdate.Value.Month == dateTimeNow.Month).Sum(s => s.Totalprice);
				if (temp == null)
				{
					temp = 0;
				}
				data[i] = temp.ToString();
				dateTimeNow = dateTimeNow.AddMonths(1);
			}
			ViewBag.dateX = dateX;
			ViewBag.data = data;

			// DatachartLine();
			var ac = (Admin)Session["Account"];
			if (ac == null)
			{
				return RedirectToAction("Login", "ShopAdmin");
			}
			else { return View(); }
			
        }

		bool IsAdmin()
		{
			return Session["Account"] != null;
		}

		/// <summary>CRUD laptop — danh sách (Read).</summary>
		public ActionResult Laptop()
		{
			if (!IsAdmin()) return RedirectToAction("Login");
			var items = db.Items.Include("Brand").Include("ItemType").ToList();
			return View(items);
		}

		public ActionResult CreateLaptop()
		{
			if (!IsAdmin()) return RedirectToAction("Login");
			ViewBag.BrandID = new SelectList(db.Brands, "ID", "Name");
			ViewBag.TypeID = new SelectList(db.ItemTypes, "ID", "TypeName");
			return View();
		}

		[HttpPost]
		[ValidateAntiForgeryToken]
		public ActionResult CreateLaptop([Bind(Include = "Name,PurcharsePrice,SellPrice,Quantity,TypeID,BrandID,Picture,ShortTitle,Describe")] Item item)
		{
			if (!IsAdmin()) return RedirectToAction("Login");
			if (ModelState.IsValid)
			{
				item.DateImport = DateTime.Now;
				item.Active = true;
				if (string.IsNullOrWhiteSpace(item.Picture))
					item.Picture = "laptop-hp-01.jpg";
				db.Configuration.ValidateOnSaveEnabled = false;
				db.Items.Add(item);
				db.SaveChanges();
				return RedirectToAction("Laptop");
			}
			ViewBag.BrandID = new SelectList(db.Brands, "ID", "Name", item.BrandID);
			ViewBag.TypeID = new SelectList(db.ItemTypes, "ID", "TypeName", item.TypeID);
			return View(item);
		}

		public ActionResult EditLaptop(long? id)
		{
			if (!IsAdmin()) return RedirectToAction("Login");
			if (id == null) return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
			var item = db.Items.Find(id);
			if (item == null) return HttpNotFound();
			ViewBag.BrandID = new SelectList(db.Brands, "ID", "Name", item.BrandID);
			ViewBag.TypeID = new SelectList(db.ItemTypes, "ID", "TypeName", item.TypeID);
			return View(item);
		}

		[HttpPost]
		[ValidateAntiForgeryToken]
		public ActionResult EditLaptop([Bind(Include = "ID,Name,PurcharsePrice,SellPrice,Quantity,TypeID,BrandID,Picture,ShortTitle,Describe,DateImport")] Item item)
		{
			if (!IsAdmin()) return RedirectToAction("Login");
			if (ModelState.IsValid)
			{
				item.Active = true;
				db.Configuration.ValidateOnSaveEnabled = false;
				db.Entry(item).State = System.Data.Entity.EntityState.Modified;
				db.SaveChanges();
				return RedirectToAction("Laptop");
			}
			ViewBag.BrandID = new SelectList(db.Brands, "ID", "Name", item.BrandID);
			ViewBag.TypeID = new SelectList(db.ItemTypes, "ID", "TypeName", item.TypeID);
			return View(item);
		}

		public ActionResult DeleteLaptop(long? id)
		{
			if (!IsAdmin()) return RedirectToAction("Login");
			if (id == null) return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
			var item = db.Items.Find(id);
			if (item == null) return HttpNotFound();
			return View(item);
		}

		[HttpPost, ActionName("DeleteLaptop")]
		[ValidateAntiForgeryToken]
		public ActionResult DeleteLaptopConfirmed(long id)
		{
			if (!IsAdmin()) return RedirectToAction("Login");
			var item = db.Items.Find(id);
			if (item != null)
			{
				item.Active = false;
				db.SaveChanges();
			}
			return RedirectToAction("Laptop");
		}

		/// <summary>Laptop chưa từng xuất hiện trong OrderDetail (chưa bán).</summary>
		public ActionResult Productnotsold()
		{
			if (!IsAdmin()) return RedirectToAction("Login");
			var soldIds = db.OrderDetails.Where(d => d.ItemId != null).Select(d => d.ItemId);
			var results = db.Items.Include("Brand").Include("ItemType")
				.Where(t1 => !soldIds.Contains(t1.ID));
			return View(results.ToList());
		}
		public ActionResult Login()
		{
			return View();

		}
		[HttpPost]
		public ActionResult Login(FormCollection collection)
		{
			var userName = (collection["userName"] ?? "").Trim();
			var passWord = (collection["passWord"] ?? "").Trim();

			Admin ad = db.Admins.SingleOrDefault(n => n.Username == userName && n.Passwords == passWord);
			if (ad == null)
			{
				ad = db.Admins.ToList().FirstOrDefault(n =>
					string.Equals(n.Username, userName, StringComparison.OrdinalIgnoreCase)
					&& n.Passwords == passWord);
			}
			if (ad != null)
			{
				Session["Account"] = ad;
				Response.Cookies["usr"].Value = ad.Username;

				var name = db.Admins.SingleOrDefault(a => a.Username == ad.Username).Name;
				Response.Cookies["Name"].Value = name;

				var atar = db.Admins.SingleOrDefault(a => a.Username == ad.Username).Picture;
				if (atar == null || atar == "")
				{
					atar = "~/img/Item/avatar-default-icon.png";
				}

				Response.Cookies["avatar"].Value = atar;

				return RedirectToAction("AllListOrder", "ShopAdmin");
			}
			else
			
				ModelState.AddModelError("", "Tài khoản hoặc mật khẩu không đúng");
			
			return View();


		
	}

		public ActionResult Create()
		{
			return View();
		}

		// POST: Admins/Create
		// To protect from overposting attacks, please enable the specific properties you want to bind to, for 
		// more details see https://go.microsoft.com/fwlink/?LinkId=317598.
		[HttpPost]
		[ValidateAntiForgeryToken]
		public ActionResult Create([Bind(Include = "Username,Passwords,Name,Picture")] Admin admin)
		{
			if (ModelState.IsValid)
			{
				db.Admins.Add(admin);
				db.SaveChanges();
				return RedirectToAction("Index");
			}

			return View(admin);
		}



		///  
		/// </summary>
		/// <returns></returns>
		/// 


		//order
		public ActionResult ListOrder()
		{
			var temp = db.Orders.Where(o => o.Status == false).ToList();
			List<OrderEntity> lisorder = new List<OrderEntity>();
			foreach (var item in temp)
			{
				OrderEntity or = new OrderEntity();
				or.TypeOf_OrderEntity(item);
				lisorder.Add(or);


			}


			return View(lisorder);
		}

		// xacs nhan

		public ActionResult Comfirm(long ? id)
		{
			var temp = db.OrderDetails.Where(d => d.OrderID == id);
			List<OrderDetailEntity> listdetail = new List<OrderDetailEntity>();
			foreach (var item in temp)
			{
				OrderDetailEntity or = new OrderDetailEntity();
				or.TypeOf_OrderEntity(item);
				listdetail.Add(or);
			}
			ViewBag.Date = db.Orders.SingleOrDefault(a => a.ID == id).Deliverydate;
			ViewBag.id = id;
			return View(listdetail);

		}

		[HttpPost]

		public ActionResult Comfirm(FormCollection fc)
		{
			var date = DateTime.Now;
			long id = Convert.ToInt64(fc["id"]);
			var tem = db.Orders.SingleOrDefault(d => d.ID ==id);

			tem.Status = true;
			tem.Deliverydate = date;
			db.SaveChanges();

            if (!tem.Payments.Any())
            {
				Payment pm = new Payment();
				pm.Payprices = tem.Totalprice;
				pm.OrderID = tem.ID;
				db.Payments.Add(pm);
				db.SaveChanges();
			}
		
			return RedirectToAction("ListOrder");

		}
		//-------------------------------------------
		public ActionResult AllListOrder()
		{
			var temp = db.Orders.ToList();
			List<OrderEntity> lisorder = new List<OrderEntity>();
			foreach (var item in temp)
			{
				OrderEntity or = new OrderEntity();
				or.TypeOf_OrderEntity(item);
				lisorder.Add(or);


			}


			return View(lisorder);
		}

		// xacs nhan

		public ActionResult OrderDetail(long? id)
		{
			var temp = db.OrderDetails.Where(d => d.OrderID == id);
			List<OrderDetailEntity> listdetail = new List<OrderDetailEntity>();
			foreach (var item in temp)
			{
				OrderDetailEntity or = new OrderDetailEntity();
				or.TypeOf_OrderEntity(item);
				listdetail.Add(or);
			}
			
			return View(listdetail);

		}
	}
}