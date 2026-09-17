using System;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Security;
using ProTechTiveGear.Models;

namespace ProTechTiveGear.Controllers
{
	public class LoginController : Controller
	{
		ProTechTiveGearEntities db = new ProTechTiveGearEntities();

		public ActionResult Login(string returnUrl)
		{
			ViewBag.ReturnUrl = returnUrl;
			return View();
		}

		[HttpPost]
		[ValidateAntiForgeryToken]
		public ActionResult Login(FormCollection collection)
		{
			var userName = (collection["userName"] ?? "").Trim();
			var passWord = (collection["passWord"] ?? "").Trim();
			var returnUrl = (collection["returnUrl"] ?? "").Trim();

			if (string.IsNullOrEmpty(userName) || string.IsNullOrEmpty(passWord))
			{
				ModelState.AddModelError("", "Vui lòng nhập tài khoản và mật khẩu.");
				ViewBag.ReturnUrl = returnUrl;
				return View();
			}

			// Admin
			Admin ad = db.Admins.ToList().FirstOrDefault(n =>
				string.Equals(n.Username, userName, StringComparison.OrdinalIgnoreCase)
				&& Encryption.VerifyPassword(passWord, n.Passwords));
			if (ad != null)
			{
				UpgradePasswordIfNeeded(ad, passWord);
				Session["Account"] = ad;
				Session["usr"] = null;
				SetUserCookie(ad.Username, ad.Name);
				return RedirectToAction("AllListOrder", "Admin");
			}

			// Customer
			Customer cs = db.Customers.ToList().FirstOrDefault(n =>
				string.Equals(n.Username, userName, StringComparison.OrdinalIgnoreCase)
				&& Encryption.VerifyPassword(passWord, n.Passwords));
			if (cs != null)
			{
				UpgradePasswordIfNeeded(cs, passWord);
				Session["usr"] = cs;
				Session["Account"] = null;
				SetUserCookie(cs.Username, cs.Name);
				if (!string.IsNullOrEmpty(returnUrl) && returnUrl.StartsWith("/") && !returnUrl.StartsWith("//"))
					return Redirect(returnUrl);
				return RedirectToAction("Index", "Shop");
			}

			ModelState.AddModelError("", "Tài khoản hoặc mật khẩu không đúng");
			ViewBag.ReturnUrl = returnUrl;
			return View();
		}

		public ActionResult Register()
		{
			return View();
		}

		[HttpPost]
		[ValidateAntiForgeryToken]
		public ActionResult Register(FormCollection collection)
		{
			string userName = (collection["Username"] ?? "").Trim();
			string passWord = collection["Password"] ?? "";
			string conFirmPassWord = collection["ConfirmPassword"] ?? "";
			string name = (collection["Name"] ?? "").Trim();
			string Email = (collection["Email"] ?? "").Trim();
			string address = (collection["Address"] ?? "").Trim();
			string phoneNumber = (collection["PhoneNumber"] ?? "").Trim();

			if (string.IsNullOrWhiteSpace(userName))
				ModelState.AddModelError("", "Vui lòng nhập tài khoản.");
			if (string.IsNullOrWhiteSpace(passWord))
				ModelState.AddModelError("", "Vui lòng nhập mật khẩu.");
			else if (passWord.Length < 4)
				ModelState.AddModelError("", "Mật khẩu phải từ 4 ký tự trở lên.");
			if (passWord != conFirmPassWord)
			{
				ViewBag.Confirm = "Mật khẩu xác nhận không khớp.";
				ModelState.AddModelError("", "Mật khẩu xác nhận không khớp.");
			}
			if (string.IsNullOrWhiteSpace(name))
				ModelState.AddModelError("", "Vui lòng nhập họ tên.");
			if (string.IsNullOrWhiteSpace(Email))
				ModelState.AddModelError("", "Vui lòng nhập email.");
			if (string.IsNullOrWhiteSpace(address))
				ModelState.AddModelError("", "Vui lòng nhập địa chỉ.");
			if (string.IsNullOrWhiteSpace(phoneNumber))
				ModelState.AddModelError("", "Vui lòng nhập số điện thoại.");

			if (!ModelState.IsValid)
				return View();

			var exists = db.Customers.Any(a => a.Username == userName)
				|| db.Admins.Any(a => a.Username == userName);
			if (exists)
			{
				ModelState.AddModelError("", "Tài khoản '" + userName + "' đã tồn tại.");
				return View();
			}

			var cs = new Customer
			{
				Username = userName,
				Passwords = Encryption.HashPassword(passWord),
				Name = name,
				EmailAddress = Email,
				Address = address,
				Phone = phoneNumber
			};
			db.Customers.Add(cs);
			db.SaveChanges();
			TempData["LoginMessage"] = "Đăng ký thành công. Vui lòng đăng nhập.";
			return RedirectToAction("Login", "Login");
		}

		public ActionResult Forgotpassword()
		{
			if (Session["usr"] == null)
				return RedirectToAction("Login", "Login");
			return View(new AccountClientEntity((Customer)Session["usr"]));
		}

		[HttpPost]
		[ValidateAntiForgeryToken]
		public ActionResult Forgotpassword(FormCollection fc)
		{
			return ChangePasswordCore(fc);
		}

		public ActionResult Changepassword()
		{
			if (Session["usr"] == null)
				return RedirectToAction("Login", "Login");
			return View(new AccountClientEntity((Customer)Session["usr"]));
		}

		[HttpPost]
		[ValidateAntiForgeryToken]
		public ActionResult Changepassword(FormCollection fc)
		{
			return ChangePasswordCore(fc);
		}

		private ActionResult ChangePasswordCore(FormCollection fc)
		{
			var ac = Session["usr"] as Customer;
			if (ac == null)
				return RedirectToAction("Login", "Login");

			string userName = (fc["userName"] ?? ac.Username ?? "").Trim();
			string pass = fc["pass"] ?? "";
			string newpass = fc["newpass"] ?? "";
			string repass = fc["repass"] ?? "";

			if (string.IsNullOrEmpty(pass) || string.IsNullOrEmpty(newpass) || string.IsNullOrEmpty(repass))
			{
				ModelState.AddModelError("", "Vui lòng nhập đủ mật khẩu cũ, mật khẩu mới và xác nhận.");
				return View(new AccountClientEntity(ac));
			}
			if (newpass != repass)
			{
				ModelState.AddModelError("", "Mật khẩu mới và nhập lại không khớp.");
				return View(new AccountClientEntity(ac));
			}
			if (newpass.Length < 4)
			{
				ModelState.AddModelError("", "Mật khẩu mới phải từ 4 ký tự trở lên.");
				return View(new AccountClientEntity(ac));
			}
			if (newpass == pass)
			{
				ModelState.AddModelError("", "Mật khẩu mới phải khác mật khẩu cũ.");
				return View(new AccountClientEntity(ac));
			}

			var temp = db.Customers.FirstOrDefault(x => x.Username == userName);
			if (temp == null || !Encryption.VerifyPassword(pass, temp.Passwords))
			{
				ModelState.AddModelError("", "Mật khẩu cũ không chính xác.");
				return View(new AccountClientEntity(ac));
			}

			temp.Passwords = Encryption.HashPassword(newpass);
			db.SaveChanges();
			Session["usr"] = temp;
			TempData["ProfileMessage"] = "Đã đổi mật khẩu thành công.";
			return RedirectToAction("Profile", "Shop");
		}

		private void UpgradePasswordIfNeeded(Customer cs, string plainPassword)
		{
			if (cs.Passwords == plainPassword)
			{
				cs.Passwords = Encryption.HashPassword(plainPassword);
				db.SaveChanges();
			}
		}

		private void UpgradePasswordIfNeeded(Admin ad, string plainPassword)
		{
			if (ad.Passwords == plainPassword)
			{
				ad.Passwords = Encryption.HashPassword(plainPassword);
				db.SaveChanges();
			}
		}

		private void SetUserCookie(string username, string name)
		{
			Response.Cookies["usr"].Value = username;
			Response.Cookies["usr"].Expires = DateTime.Now.AddDays(7);
			Response.Cookies["Name"].Value = name ?? username;
			Response.Cookies["Name"].Expires = DateTime.Now.AddDays(7);
		}
	}
}
