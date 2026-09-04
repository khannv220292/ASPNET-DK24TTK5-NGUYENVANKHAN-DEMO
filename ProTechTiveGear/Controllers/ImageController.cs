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

				var fileName = Path.GetFileName(file.FileName);
				if (string.IsNullOrEmpty(fileName))
					return "";

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
