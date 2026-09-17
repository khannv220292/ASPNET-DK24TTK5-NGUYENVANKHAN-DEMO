using System.Linq;
using System.Web.Mvc;
using LaptopStore.Models;

namespace LaptopStore.Controllers
{
    public class StoreController : Controller
    {
        private LapStoreDbContext db = new LapStoreDbContext();

        // Tìm kiếm tương đối với .Contains()
        public ActionResult Index(string search, long? brandId)
        {
            var items = db.Items.Where(i => i.Active == true);

            if (!string.IsNullOrWhiteSpace(search))
            {
                // LINQ Contains tương đương toán tử LIKE '%search%' trong SQL Server
                items = items.Where(i => i.Name.Contains(search));
                ViewBag.CurrentSearch = search;
            }

            if (brandId.HasValue)
            {
                items = items.Where(i => i.BrandID == brandId);
            }

            ViewBag.Brands = db.Brands.ToList();
            return View(items.OrderByDescending(i => i.DateImport).ToList());
        }

        public ActionResult Details(long id)
        {
            var item = db.Items.Find(id);
            if (item == null) return HttpNotFound();
            return View(item);
        }

        protected override void Dispose(bool disposing)
        {
            if (disposing) db.Dispose();
            base.Dispose(disposing);
        }
    }
}
