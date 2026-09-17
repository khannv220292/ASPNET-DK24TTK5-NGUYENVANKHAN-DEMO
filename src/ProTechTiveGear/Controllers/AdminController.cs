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
			Session["Account"] = null;
			Session.Clear();
			Session.Abandon();
			if (Request.Cookies["usr"] != null)
			{
				var c = new HttpCookie("usr") { Expires = DateTime.Now.AddDays(-1) };
				Response.Cookies.Add(c);
			}
			if (Request.Cookies["Name"] != null)
			{
				var c = new HttpCookie("Name") { Expires = DateTime.Now.AddDays(-1) };
				Response.Cookies.Add(c);
			}
			if (Request.Cookies["avatar"] != null)
			{
				var c = new HttpCookie("avatar") { Expires = DateTime.Now.AddDays(-1) };
				Response.Cookies.Add(c);
			}
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
				var temp = db.Orders.Where(a => a.Orderdate.Value.Month == dateTimeNow.Month
					&& a.Orderdate.Value.Year == dateTimeNow.Year).Sum(s => s.Totalprice);
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

			if (string.IsNullOrEmpty(userName) || string.IsNullOrEmpty(passWord))
			{
				ModelState.AddModelError("", "Vui lòng nhập tài khoản và mật khẩu.");
				return View();
			}

			Admin ad = db.Admins.ToList().FirstOrDefault(n =>
				string.Equals(n.Username, userName, StringComparison.OrdinalIgnoreCase)
				&& Encryption.VerifyPassword(passWord, n.Passwords));

			if (ad != null)
			{
				if (ad.Passwords == passWord)
				{
					ad.Passwords = Encryption.HashPassword(passWord);
					db.SaveChanges();
				}
				Session["Account"] = ad;
				Response.Cookies["usr"].Value = ad.Username;
				Response.Cookies["usr"].Expires = DateTime.Now.AddDays(7);

				Response.Cookies["Name"].Value = ad.Name ?? ad.Username;
				Response.Cookies["Name"].Expires = DateTime.Now.AddDays(7);

				var atar = ad.Picture;
				if (string.IsNullOrEmpty(atar))
					atar = "~/img/Item/avatar-default-icon.png";
				Response.Cookies["avatar"].Value = atar;

				return RedirectToAction("AllListOrder", "Admin");
			}

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
			if (string.IsNullOrWhiteSpace(admin.Username) || string.IsNullOrWhiteSpace(admin.Passwords))
			{
				ModelState.AddModelError("", "Vui lòng nhập Username và Password.");
			}
			else if (db.Admins.Any(a => a.Username == admin.Username))
			{
				ModelState.AddModelError("", "Tài khoản admin đã tồn tại.");
			}

			if (ModelState.IsValid)
			{
				admin.Passwords = Encryption.HashPassword(admin.Passwords);
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
		private List<Order> GetFilteredOrders(string tab, string q)
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
			return temp;
		}

		public ActionResult AllListOrder(string tab = "all", string q = null)
		{
			var temp = GetFilteredOrders(tab, q);
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

		public ActionResult ExportOrdersExcel(string tab = "all", string q = null)
		{
			var orders = GetFilteredOrders(tab, q);
			var sb = new System.Text.StringBuilder();
			sb.AppendLine("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
			sb.AppendLine("<?mso-application progid=\"Excel.Sheet\"?>");
			sb.AppendLine("<Workbook xmlns=\"urn:schemas-microsoft-com:office:spreadsheet\"");
			sb.AppendLine(" xmlns:ss=\"urn:schemas-microsoft-com:office:spreadsheet\">");
			sb.AppendLine("<Worksheet ss:Name=\"DonHang\"><Table>");

			string[] headers = {
				"Ma don", "Ngay tao", "Khach hang", "Dien thoai", "Email",
				"Thanh toan", "Giao hang", "SL san pham", "Tong tien", "Kenh"
			};
			sb.Append("<Row>");
			foreach (var h in headers)
				sb.Append("<Cell><Data ss:Type=\"String\">").Append(XmlEsc(h)).Append("</Data></Cell>");
			sb.AppendLine("</Row>");

			foreach (var o in orders)
			{
				string ma = "G" + o.ID.ToString("D6");
				string ngay = o.Orderdate.HasValue ? o.Orderdate.Value.ToString("dd/MM/yyyy HH:mm") : "";
				string ten = o.Customer != null ? (o.Customer.Name ?? "") : "";
				string sdt = o.Customer != null ? (o.Customer.Phone ?? "") : "";
				string email = o.Customer != null ? (o.Customer.EmailAddress ?? "") : "";
				bool paid = o.Payments != null && o.Payments.Any();
				string tt = paid ? "Da thanh toan" : "Chua thanh toan";
				string gh = o.Deliverystatus == true ? "Da giao" : (o.Status == true ? "Da xu ly" : "Cho xu ly");
				int sl = o.OrderDetails != null ? o.OrderDetails.Sum(d => d.Quantity) : 0;
				decimal tien = o.Totalprice ?? 0;

				sb.Append("<Row>");
				sb.Append(CellStr(ma));
				sb.Append(CellStr(ngay));
				sb.Append(CellStr(ten));
				sb.Append(CellStr(sdt));
				sb.Append(CellStr(email));
				sb.Append(CellStr(tt));
				sb.Append(CellStr(gh));
				sb.Append(CellNum(sl));
				sb.Append(CellNum(tien));
				sb.Append(CellStr("Web"));
				sb.AppendLine("</Row>");
			}

			sb.AppendLine("</Table></Worksheet></Workbook>");

			string file = "DonHang_laptopstore_" + DateTime.Now.ToString("yyyyMMdd_HHmm") + ".xls";
			return File(System.Text.Encoding.UTF8.GetBytes(sb.ToString()),
				"application/vnd.ms-excel", file);
		}

		private static string XmlEsc(string s)
		{
			if (string.IsNullOrEmpty(s)) return "";
			return s.Replace("&", "&amp;").Replace("<", "&lt;").Replace(">", "&gt;").Replace("\"", "&quot;");
		}

		private static string CellStr(string s)
		{
			return "<Cell><Data ss:Type=\"String\">" + XmlEsc(s) + "</Data></Cell>";
		}

		private static string CellNum(decimal n)
		{
			return "<Cell><Data ss:Type=\"Number\">" + n.ToString(System.Globalization.CultureInfo.InvariantCulture) + "</Data></Cell>";
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

		[HttpPost]
		[ValidateAntiForgeryToken]
		public ActionResult DeleteOrder(long id, string tab = "all", string q = null)
		{
			if (Session["Account"] == null)
			{
				return RedirectToAction("Login", "Admin");
			}

			var order = db.Orders
				.Include("OrderDetails")
				.Include("Payments")
				.SingleOrDefault(o => o.ID == id);
			if (order == null)
			{
				TempData["Error"] = "Không tìm thấy đơn hàng.";
				return RedirectToAction("AllListOrder", new { tab, q });
			}

			if (order.Payments != null && order.Payments.Any())
			{
				db.Payments.RemoveRange(order.Payments.ToList());
			}
			if (order.OrderDetails != null && order.OrderDetails.Any())
			{
				db.OrderDetails.RemoveRange(order.OrderDetails.ToList());
			}
			db.Orders.Remove(order);
			db.SaveChanges();

			TempData["Ok"] = "Đã xóa đơn hàng G" + id.ToString("D6") + ".";
			return RedirectToAction("AllListOrder", new { tab, q });
		}
		
		public ActionResult Revenue(DateTime? from, DateTime? to)
		{
			return RedirectToAction("Index", new { from, to });
		}

		public ActionResult Productnotsold()
		{
			var soldIds = db.OrderDetails.Select(od => od.ItemId).Distinct();
			var notSold = db.Items
				.Where(i => !soldIds.Contains(i.ID))
				.OrderBy(i => i.Name)
				.ToList();
			return View(notSold);
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