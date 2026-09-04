using System;
using System.Diagnostics;
using System.IO;
using System.Web;
using System.Web.Mvc;

namespace ProTechTiveGear.Controllers
{
	public class ImageController : Controller
	{
		public ActionResult UploadImage()
		{
			return View();
		}

		[HttpPost]
		public string ProcessUpload(HttpPostedFileBase file)
		{
			try
			{
				if (file == null || file.ContentLength <= 0)
					return "";

				var folder = Server.MapPath("~/img/Item");
				if (!Directory.Exists(folder))
					Directory.CreateDirectory(folder);

				var ext = Path.GetExtension(file.FileName);
				if (string.IsNullOrEmpty(ext)) ext = ".jpg";
				var fileName = DateTime.Now.ToString("yyyyMMddHHmmssfff") + "_" + Guid.NewGuid().ToString("N").Substring(0, 6) + ext;
				var path = Path.Combine(folder, fileName);
				file.SaveAs(path);
				return fileName;
			}
			catch (Exception ex)
			{
				Debug.WriteLine(ex.Message);
				return "";
			}
		}
	}
}
