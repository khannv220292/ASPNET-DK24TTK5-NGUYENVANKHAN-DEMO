using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Data.Entity.Validation;
using System.Globalization;
using System.Linq;
using System.IO;
using System.Net;
using System.Web;
using System.Web.Mvc;
using ProTechTiveGear.Models;

namespace ProTechTiveGear.Controllers
{
    public class ItemsController : Controller
    {
        private ProTechTiveGearEntities db = new ProTechTiveGearEntities();

        // GET: Items
        public ActionResult Index()
        {
			//var ac = (Admin)Session["Account"];
			//if (ac == null)
			//{
			//	return RedirectToAction("Login", "Admin");
			//}
			var items = db.Items.Include(i => i.Brand).Include(i => i.ItemType).Where(a=>a.Active==true);
            return View(items.ToList());
        }
		public ActionResult Itemunactive()
		{
			//var ac = (Admin)Session["Account"];
			//if (ac == null)
			//{
			//	return RedirectToAction("Login", "Admin");
			//}
			var items = db.Items.Include(i => i.Brand).Include(i => i.ItemType).Where(a => a.Active == false);
			return View(items.ToList());
		}
		// GET: Items/Details/5
		public ActionResult Details(long? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            Item item = db.Items.Find(id);
            if (item == null)
            {
                return HttpNotFound();
            }
            return View(item);
        }

        // GET: Items/Create
        public ActionResult Create()
        {
            ViewBag.BrandID = new SelectList(db.Brands, "ID", "Name");
            ViewBag.TypeID = new SelectList(db.ItemTypes, "ID", "TypeName");
            return View();
        }

        // POST: Items/Create
        // To protect from overposting attacks, please enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
		[ValidateInput(false)]
		public ActionResult Create([Bind(Include = "ID,Name,PurcharsePrice,SellPrice,Quantity,TypeID,BrandID,Picture,ShortTitle,Describe")] Item item)
        {
			try
			{
				ApplyVnPrices(item);
				PrepareItem(item);
				if (!ModelState.IsValid)
				{
					FillLists(item);
					return View(item);
				}

				db.Configuration.ValidateOnSaveEnabled = false;
				db.Items.Add(item);
				db.SaveChanges();
				return RedirectToAction("Index");
			}
			catch (Exception ex)
			{
				foreach (var eve in db.GetValidationErrors())
					foreach (var ve in eve.ValidationErrors)
						ModelState.AddModelError("", ve.PropertyName + ": " + ve.ErrorMessage);

				var msg = ex.Message;
				var inner = ex.InnerException;
				while (inner != null)
				{
					msg += " | " + inner.Message;
					inner = inner.InnerException;
				}
				var dbEx = ex as DbEntityValidationException;
				if (dbEx != null)
					AddValidationErrors(dbEx);
				ModelState.AddModelError("", msg);
				FillLists(item);
				return View(item);
			}
        }

		void FillLists(Item item)
		{
            ViewBag.BrandID = new SelectList(db.Brands, "ID", "Name", item == null ? (long?)null : item.BrandID);
            ViewBag.TypeID = new SelectList(db.ItemTypes, "ID", "TypeName", item == null ? (long?)null : item.TypeID);
		}

        // GET: Items/Edit/5
        public ActionResult Edit(long? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            Item item = db.Items.Find(id);
            if (item == null)
            {
                return HttpNotFound();
            }
            ViewBag.BrandID = new SelectList(db.Brands, "ID", "Name", item.BrandID);
            ViewBag.TypeID = new SelectList(db.ItemTypes, "ID", "TypeName", item.TypeID);
            return View(item);
        }

        // POST: Items/Edit/5
        // To protect from overposting attacks, please enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
		[ValidateAntiForgeryToken]
		[ValidateInput(false)]
		public ActionResult Edit([Bind(Include = "ID,Name,PurcharsePrice,SellPrice,DateImport,Quantity,TypeID,BrandID,Picture,ShortTitle,Describe")] Item item)
        {
			ApplyVnPrices(item);
			PrepareItem(item);
            if (ModelState.IsValid)
            {
				try
				{
					db.Configuration.ValidateOnSaveEnabled = false;
					db.Entry(item).State = EntityState.Modified;
					db.SaveChanges();
					return RedirectToAction("Index");
				}
				catch (Exception ex)
				{
					var dbEx = ex as DbEntityValidationException;
					if (dbEx != null)
						AddValidationErrors(dbEx);
					ModelState.AddModelError("", ex.Message);
				}
            }
            ViewBag.BrandID = new SelectList(db.Brands, "ID", "Name", item.BrandID);
            ViewBag.TypeID = new SelectList(db.ItemTypes, "ID", "TypeName", item.TypeID);
            return View(item);
        }

        // GET: Items/Delete/5
        public ActionResult Delete(long? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            Item item = db.Items.Find(id);
            if (item == null)
            {
                return HttpNotFound();
            }
            return View(item);
        }

        // POST: Items/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public ActionResult DeleteConfirmed(long id)
        {
            Item item = db.Items.Find(id);
            db.Items.Remove(item);
            db.SaveChanges();
            return RedirectToAction("Index");
        }

        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                db.Dispose();
            }
            base.Dispose(disposing);
        }
		//public ActionResult ActiveEmployee(long? id)
		//{
		//	if (id == null)
		//	{
		//		return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
		//	}
		//	Item item = db.Items.Find(id);
		//	if (item==null)
		//	{
		//		return HttpNotFound();
		//	}
		//	else
		//	{
		//		return RedirectToAction("Login", "Admin");
		//	}


		//}
		//[HttpPost]
		//public ActionResult ActiveEmployee(Item item)
		//{
		//	var temp = db.Items.Find(item.ID);

		//	temp.Active = false;
		//	db.SaveChanges();

		//	return RedirectToAction("Index");


		//}
		public ActionResult UnactiveProduct(long? id)
		{
		
			var temp = db.Items.SingleOrDefault(p => p.ID == id);
			temp.Active = false;
			db.SaveChanges();

			return RedirectToAction("Index");
		}
		public ActionResult Active(long? id)
		{

			var temp = db.Items.SingleOrDefault(p => p.ID == id);
			temp.Active = true;
			db.SaveChanges();

			return RedirectToAction("Itemunactive");
		}

		void AddValidationErrors(DbEntityValidationException ex)
		{
			foreach (var eve in ex.EntityValidationErrors)
				foreach (var ve in eve.ValidationErrors)
					ModelState.AddModelError(ve.PropertyName ?? "", ve.ErrorMessage + " (" + ve.PropertyName + ")");
		}

		void PrepareItem(Item item)
		{
			item.DateImport = DateTime.Now;
			item.Active = true;
			item.Name = Truncate(item.Name, 400);
			item.ShortTitle = Truncate(string.IsNullOrWhiteSpace(item.ShortTitle) ? item.Name : item.ShortTitle, 1000);
			item.Picture = Truncate(string.IsNullOrWhiteSpace(item.Picture) ? "laptop-hp-01.jpg" : Path.GetFileName(item.Picture.Replace("\\", "/")), 400);
			if (string.IsNullOrWhiteSpace(item.Describe))
				item.Describe = item.Name;
			if (!item.Quantity.HasValue || item.Quantity < 0)
				item.Quantity = 1;
			if (!item.TypeID.HasValue || item.TypeID == 0)
			{
				var t = db.ItemTypes.FirstOrDefault();
				if (t != null) item.TypeID = t.ID;
			}
			if (!item.BrandID.HasValue || item.BrandID == 0)
			{
				var b = db.Brands.FirstOrDefault();
				if (b != null) item.BrandID = b.ID;
			}
			if (string.IsNullOrWhiteSpace(item.Name))
				ModelState.AddModelError("Name", "Nhập tên sản phẩm.");
		}

		static string Truncate(string s, int max)
		{
			if (string.IsNullOrEmpty(s)) return s;
			s = s.Trim();
			return s.Length <= max ? s : s.Substring(0, max);
		}

		void ApplyVnPrices(Item item)
		{
			var buyRaw = Request["PurcharsePrice"];
			var sellRaw = Request["SellPrice"];
			var buy = ParseVnMoney(buyRaw);
			var sell = ParseVnMoney(sellRaw);
			ModelState.Remove("PurcharsePrice");
			ModelState.Remove("SellPrice");
			if (buy.HasValue)
				item.PurcharsePrice = buy;
			else if (!string.IsNullOrWhiteSpace(buyRaw))
				ModelState.AddModelError("PurcharsePrice", "Giá mua không hợp lệ. Gõ 20990000 (không dùng 20.990.000).");
			if (sell.HasValue)
				item.SellPrice = sell.Value;
			else
				ModelState.AddModelError("SellPrice", "Giá bán không hợp lệ. Gõ 20990000 (không dùng 20.990.000).");
		}

		static decimal? ParseVnMoney(string raw)
		{
			if (string.IsNullOrWhiteSpace(raw))
				return null;
			raw = raw.Trim().Replace("đ", "").Replace("₫", "").Replace(" ", "");
			raw = raw.Replace(".", "").Replace(",", "");
			decimal v;
			if (decimal.TryParse(raw, NumberStyles.Number, CultureInfo.InvariantCulture, out v))
				return v;
			return null;
		}
	}
}
