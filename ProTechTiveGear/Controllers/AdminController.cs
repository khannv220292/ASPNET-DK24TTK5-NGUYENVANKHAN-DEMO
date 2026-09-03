using System;
using System.Data.Entity;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using LaptopStore.Models;

namespace LaptopStore.Controllers
{
    public class AdminController : Controller
    {
        private LapStoreDbContext db = new LapStoreDbContext();

        // 1. READ: Danh sách Laptop
        public ActionResult Index()
        {
            var items = db.Items.Include(i => i.Brand).Include(i => i.ItemType);
            return View(items.ToList());
        }

        // 2. CREATE: Thêm mới
        public ActionResult Create()
        {
            ViewBag.BrandID = new SelectList(db.Brands, "ID", "Name");
            ViewBag.TypeID = new SelectList(db.ItemTypes, "ID", "TypeName");
            return View();
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create(StoreItem item, HttpPostedFileBase photo)
        {
            item.Picture = SavePicture(photo, item.Picture);
            if (ModelState.IsValid)
            {
                if (string.IsNullOrWhiteSpace(item.Picture))
                    item.Picture = "laptop-hp-01.jpg";
                db.Items.Add(item);
                db.SaveChanges();
                return RedirectToAction("Index");
            }
            ViewBag.BrandID = new SelectList(db.Brands, "ID", "Name", item.BrandID);
            ViewBag.TypeID = new SelectList(db.ItemTypes, "ID", "TypeName", item.TypeID);
            return View(item);
        }

        // 3. UPDATE: Sửa
        public ActionResult Edit(long id)
        {
            var item = db.Items.Find(id);
            if (item == null) return HttpNotFound();
            ViewBag.BrandID = new SelectList(db.Brands, "ID", "Name", item.BrandID);
            ViewBag.TypeID = new SelectList(db.ItemTypes, "ID", "TypeName", item.TypeID);
            return View(item);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit(StoreItem item, HttpPostedFileBase photo)
        {
            item.Picture = SavePicture(photo, item.Picture);
            if (ModelState.IsValid)
            {
                db.Entry(item).State = EntityState.Modified;
                db.SaveChanges();
                return RedirectToAction("Index");
            }
            ViewBag.BrandID = new SelectList(db.Brands, "ID", "Name", item.BrandID);
            ViewBag.TypeID = new SelectList(db.ItemTypes, "ID", "TypeName", item.TypeID);
            return View(item);
        }

        string SavePicture(HttpPostedFileBase photo, string currentName)
        {
            if (photo == null || photo.ContentLength <= 0)
                return currentName;
            var ext = Path.GetExtension(photo.FileName);
            if (string.IsNullOrEmpty(ext))
                ext = ".jpg";
            var fileName = Guid.NewGuid().ToString("N") + ext.ToLowerInvariant();
            var folderItem = Server.MapPath("~/img/Item");
            var folderRoot = Server.MapPath("~/img");
            if (!Directory.Exists(folderItem))
                Directory.CreateDirectory(folderItem);
            if (!Directory.Exists(folderRoot))
                Directory.CreateDirectory(folderRoot);
            var pathItem = Path.Combine(folderItem, fileName);
            photo.SaveAs(pathItem);
            try { System.IO.File.Copy(pathItem, Path.Combine(folderRoot, fileName), true); } catch { }
            return fileName;
        }

        // 4. DELETE: Xóa an toàn
        public ActionResult Delete(long id)
        {
            var item = db.Items.Find(id);
            if (item == null) return HttpNotFound();
            return View(item);
        }

        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public ActionResult DeleteConfirmed(long id)
        {
            var item = db.Items.Find(id);
            db.Items.Remove(item);
            db.SaveChanges();
            return RedirectToAction("Index");
        }

        // 5. THỐNG KÊ (Tiêu chí 8): Sản phẩm tồn kho chưa từng bán
        public ActionResult Productnotsold()
        {
            var soldItemIds = db.OrderDetails.Where(od => od.ItemId != null).Select(od => od.ItemId).Distinct();
            var unsoldItems = db.Items.Include(i => i.Brand).Include(i => i.ItemType)
                .Where(i => !soldItemIds.Contains(i.ID)).ToList();
            return View(unsoldItems);
        }
    }
}
