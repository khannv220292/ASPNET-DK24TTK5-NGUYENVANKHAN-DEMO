using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Mvc;
using ProTechTiveGear.Models;
namespace ProTechTiveGear.Controllers
{
	
    public class AdminController : Controller
    {
		// GET: Admin
		ProTechTiveGearEntities db = new ProTechTiveGearEntities();
		public ActionResult SignOut()
		{
			//FormsAuthentication.SignOut();
			Response.Cookies.Clear();
			return RedirectToAction("Login", "Admin");

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
				return RedirectToAction("Login", "Admin");
			}
			else { return View(); }
			
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

				return RedirectToAction("AllListOrder", "Admin");
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
			return RedirectToAction("AllListOrder", new { tab = "pending" });
		}

		// xacs nhan

		public ActionResult Comfirm(long ? id)
		{
			var order = db.Orders.Include("Customer").SingleOrDefault(a => a.ID == id);
			if (order == null)
			{
				return HttpNotFound();
			}

			var temp = db.OrderDetails.Include("Item").Where(d => d.OrderID == id).ToList();
			List<OrderDetailEntity> listdetail = new List<OrderDetailEntity>();
			foreach (var item in temp)
			{
				OrderDetailEntity or = new OrderDetailEntity();
				or.TypeOf_OrderEntity(item);
				listdetail.Add(or);
			}
			ViewBag.Date = order.Deliverydate;
			ViewBag.id = id;
			ViewBag.Order = order;
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
			tem.Deliverystatus = true;
			db.SaveChanges();

            if (!tem.Payments.Any())
            {
				Payment pm = new Payment();
				pm.Payprices = tem.Totalprice;
				pm.OrderID = tem.ID;
				db.Payments.Add(pm);
				db.SaveChanges();
			}
		
			return RedirectToAction("AllListOrder");

		}
		//-------------------------------------------
		public ActionResult AllListOrder(string tab = "all", string q = null)
		{
			var temp = db.Orders
				.Include("Customer")
				.Include("OrderDetails")
				.Include("Payments")
				.OrderByDescending(o => o.Orderdate)
				.ToList();

			if (string.Equals(tab, "unpaid", StringComparison.OrdinalIgnoreCase))
			{
				temp = temp.Where(o => o.Payments == null || !o.Payments.Any()).ToList();
			}
			else if (string.Equals(tab, "pending", StringComparison.OrdinalIgnoreCase))
			{
				temp = temp.Where(o => o.Status != true).ToList();
			}

			if (!string.IsNullOrWhiteSpace(q))
			{
				string key = q.Trim().ToLowerInvariant();
				temp = temp.Where(o =>
					("g" + o.ID).Contains(key)
					|| (o.Customer != null && (
						(o.Customer.Name ?? "").ToLowerInvariant().Contains(key)
						|| (o.Customer.Phone ?? "").ToLowerInvariant().Contains(key)
						|| (o.Customer.EmailAddress ?? "").ToLowerInvariant().Contains(key)
					))
				).ToList();
			}

			List<OrderEntity> lisorder = new List<OrderEntity>();
			foreach (var item in temp)
			{
				OrderEntity or = new OrderEntity();
				or.TypeOf_OrderEntity(item);
				lisorder.Add(or);
			}

			ViewBag.Tab = tab ?? "all";
			ViewBag.Query = q ?? "";
			return View(lisorder);
		}

		// xacs nhan

		public ActionResult OrderDetail(long? id)
		{
			var order = db.Orders.Include("Customer").Include("Payments").SingleOrDefault(a => a.ID == id);
			if (order == null)
			{
				return HttpNotFound();
			}

			var temp = db.OrderDetails.Include("Item").Where(d => d.OrderID == id).ToList();
			List<OrderDetailEntity> listdetail = new List<OrderDetailEntity>();
			foreach (var item in temp)
			{
				OrderDetailEntity or = new OrderDetailEntity();
				or.TypeOf_OrderEntity(item);
				listdetail.Add(or);
			}

			ViewBag.id = id;
			ViewBag.Order = order;
			ViewBag.Paid = order.Payments != null && order.Payments.Any();
			return View(listdetail);

		}

		[HttpPost]
		[ValidateAntiForgeryToken]
		public ActionResult ConfirmPayment(long id)
		{
			var order = db.Orders.Include("Payments").SingleOrDefault(d => d.ID == id);
			if (order == null)
			{
				return HttpNotFound();
			}

			if (order.Payments == null || !order.Payments.Any())
			{
				db.Payments.Add(new Payment
				{
					OrderID = order.ID,
					Payprices = order.Totalprice
				});
				db.SaveChanges();
			}

			TempData["Ok"] = "Đã xác nhận thanh toán (COD = Đã thanh toán).";
			return RedirectToAction("AllListOrder");
		}
		
		public ActionResult Productnotsold()
		{

			//var results = from t1 in db.Items
			//			  where !(from t2 in db.Orders where t2.Orderdate == DateTime.Now
			//					  select t2.ID).Contains(t1.ID)
			//			  select t1;
			var results = from t1 in db.Items
						  where !(from t2 in db.Orders
								  join a in db.OrderDetails on t2.ID equals a.OrderID
								  where t2.Orderdate == DateTime.Now
								  select t2.ID).Contains(t1.ID)
						  select t1;
			return View(results.ToList());
		}

		public ActionResult FeaturedBrand()
		{
			ViewBag.Auto = FeaturedSetting.IsAuto(Server);
			ViewBag.MenuId = FeaturedSetting.SavedId(Server);
			ViewBag.Menus = new SelectList(
				db.Menus.ToList().Where(m => m.Name != null && !(m.Name.StartsWith("Ph") && m.Name != "HP")).OrderBy(m => m.Name),
				"ID", "Name", ViewBag.MenuId);
			return View();
		}

		[HttpPost]
		[ValidateAntiForgeryToken]
		public ActionResult FeaturedBrand(string mode, long? menuId)
		{
			FeaturedSetting.Save(Server, mode == "auto", menuId);
			TempData["Ok"] = "Da luu hang noi bat.";
			return RedirectToAction("FeaturedBrand");
		}
	}
}