using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Mvc;
using ProTechTiveGear.Models;

namespace ProTechTiveGear.Controllers
{
    public class ItemTypesController : Controller
    {
        private ProTechTiveGearEntities db = new ProTechTiveGearEntities();

        // GET: ItemTypes
        public ActionResult Index()
        {
            var itemTypes = db.ItemTypes.Include(i => i.Menu);
            return View(itemTypes.ToList());
        }

        // GET: ItemTypes/Details/5
        public ActionResult Details(long? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            ItemType itemType = db.ItemTypes.Find(id);
            if (itemType == null)
            {
                return HttpNotFound();
            }
            return View(itemType);
        }

        // GET: ItemTypes/Create
        public ActionResult Create()
        {
            ViewBag.MenuID = new SelectList(db.Menus.OrderBy(x => x.ID), "ID", "Name");
            return View();
        }

        // POST: ItemTypes/Create
        // To protect from overposting attacks, please enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create([Bind(Include = "TypeName,MenuID")] ItemType itemType)
        {
            if (string.IsNullOrWhiteSpace(itemType.TypeName))
            {
                ModelState.AddModelError("TypeName", "Nhập tên loại sản phẩm");
            }
            if (itemType.MenuID == null)
            {
                ModelState.AddModelError("MenuID", "Chọn loại (Lenovo, Dell, HP, Phụ kiện...)");
            }
            if (ModelState.IsValid)
            {
                try
                {
                    db.ItemTypes.Add(itemType);
                    db.SaveChanges();
                    return RedirectToAction("Index");
                }
                catch (Exception ex)
                {
                    var msg = ex.InnerException != null && ex.InnerException.InnerException != null
                        ? ex.InnerException.InnerException.Message
                        : (ex.InnerException != null ? ex.InnerException.Message : ex.Message);
                    ModelState.AddModelError("", "Không lưu được: " + msg);
                }
            }

            ViewBag.MenuID = new SelectList(db.Menus.OrderBy(x => x.ID), "ID", "Name", itemType.MenuID);
            return View(itemType);
        }

        // GET: ItemTypes/Edit/5
        public ActionResult Edit(long? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            ItemType itemType = db.ItemTypes.Find(id);
            if (itemType == null)
            {
                return HttpNotFound();
            }
            ViewBag.MenuID = new SelectList(db.Menus.OrderBy(x => x.ID), "ID", "Name", itemType.MenuID);
            return View(itemType);
        }

        // POST: ItemTypes/Edit/5
        // To protect from overposting attacks, please enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit([Bind(Include = "ID,TypeName,MenuID")] ItemType itemType)
        {
            if (ModelState.IsValid)
            {
                try
                {
                    db.Entry(itemType).State = EntityState.Modified;
                    db.SaveChanges();
                    return RedirectToAction("Index");
                }
                catch (Exception ex)
                {
                    var msg = ex.InnerException != null && ex.InnerException.InnerException != null
                        ? ex.InnerException.InnerException.Message
                        : (ex.InnerException != null ? ex.InnerException.Message : ex.Message);
                    ModelState.AddModelError("", "Không lưu được: " + msg);
                }
            }
            ViewBag.MenuID = new SelectList(db.Menus.OrderBy(x => x.ID), "ID", "Name", itemType.MenuID);
            return View(itemType);
        }

        // GET: ItemTypes/Delete/5
        public ActionResult Delete(long? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            ItemType itemType = db.ItemTypes.Find(id);
            if (itemType == null)
            {
                return HttpNotFound();
            }
            return View(itemType);
        }

        // POST: ItemTypes/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public ActionResult DeleteConfirmed(long id)
        {
            ItemType itemType = db.ItemTypes.Find(id);
            if (itemType == null)
            {
                return HttpNotFound();
            }
            try
            {
                var items = db.Items.Where(x => x.TypeID == id).ToList();
                foreach (var it in items)
                {
                    it.TypeID = null;
                }
                db.ItemTypes.Remove(itemType);
                db.SaveChanges();
            }
            catch (Exception ex)
            {
                var msg = ex.InnerException != null && ex.InnerException.InnerException != null
                    ? ex.InnerException.InnerException.Message
                    : (ex.InnerException != null ? ex.InnerException.Message : ex.Message);
                TempData["Error"] = "Không xóa được: " + msg;
            }
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
    }
}
