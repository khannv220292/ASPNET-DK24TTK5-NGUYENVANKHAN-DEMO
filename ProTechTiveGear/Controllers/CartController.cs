using ProTechTiveGear.Models;
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Net;
using System.Text;
using System.Web.Mvc;
using Newtonsoft.Json.Linq;
using System.IO;
using System.Security.Cryptography;
namespace ProTechTiveGear.Controllers
{
    public class CartController : Controller
    {
        ProTechTiveGearEntities db = new ProTechTiveGearEntities();
        public List<CartEntity> GetCart()
        {
            List<CartEntity> lstCart = Session["Cart"] as List<CartEntity>;
            if (lstCart == null)
            {

                lstCart = new List<CartEntity>();
                Session["Cart"] = lstCart;
            }
            return lstCart;
        }
        public ActionResult AddtoCart(long id, string strURL)
        {
            List<CartEntity> lstcart = GetCart();
            CartEntity Product = lstcart.Find(n => n.IdItem == id);
            if (Product == null)
            {
                Product = new CartEntity(id);
                lstcart.Add(Product);
            }
            else
            {
                Product.Quantity++;
            }
            // Sau khi thêm → mở trang giỏ để thấy kết quả rõ ràng
            return RedirectToAction("Cart");
        }
        public ActionResult Cart()
        {
            List<CartEntity> lstCart = GetCart();
            ViewBag.TotalQuantity = TotalQuantity();
            ViewBag.ToTalPrice = ToTalPrice();
            ViewBag.HideBanner = true;
            // Giỏ trống vẫn hiển thị trang giỏ (không đá về Index)
            return View(lstCart ?? new List<CartEntity>());
        }

        private int TotalQuantity()
        {
            int iTongSoLuong = 0;
            List<CartEntity> lstcart = Session["Cart"] as List<CartEntity>;
            if (lstcart != null)
            {
                iTongSoLuong = lstcart.Sum(n => n.Quantity);
            }
            return iTongSoLuong;
        }

        private Double ToTalPrice()
        {
            double ToTal = 0;
            List<CartEntity> lstCart = Session["Cart"] as List<CartEntity>;
            if (lstCart != null)
            {
                ToTal = lstCart.Sum(n => n.TotalPrices);
            }
            return ToTal;
        }

        public ActionResult CartPartial()
        {
            ViewBag.TotalQuantity = TotalQuantity();
            ViewBag.TotalPrice = ToTalPrice();
            return PartialView();
        }
        //Cap nhat Giỏ hàng
        public ActionResult EditCart(long id, FormCollection f)
        {


            List<CartEntity> lstGiohang = GetCart();

            CartEntity item = lstGiohang.SingleOrDefault(n => n.IdItem == id);

            if (item != null)
            {
                item.Quantity = int.Parse(f["txtSoluong"].ToString());
            }
            return RedirectToAction("Cart");
        }
        //Xoa Giohang
        public ActionResult DeleteCart(long id)
        {

            List<CartEntity> lstGiohang = GetCart();

            CartEntity sanpham = lstGiohang.SingleOrDefault(n => n.IdItem == id);

            if (sanpham != null)
            {
                lstGiohang.RemoveAll(n => n.IdItem == id);
                return RedirectToAction("Cart");

            }
            if (lstGiohang.Count == 0)
            {
                return RedirectToAction("Index", "AuraStore");
            }
            return RedirectToAction("Cart");
        }

        public ActionResult DeleteAll()
        {

            List<CartEntity> lstGiohang = GetCart();
            lstGiohang.Clear();
            return RedirectToAction("Index", "AuraStore");
        }
        [HttpGet]
        public ActionResult Order()
        {
            // Không bắt buộc đăng nhập — form thanh toán hiển thị như mẫu (có link Đăng nhập)
            List<CartEntity> listcart = GetCart();
            if (listcart == null || listcart.Count == 0)
            {
                return RedirectToAction("Cart");
            }
            ViewBag.TotalQuantity = TotalQuantity();
            ViewBag.ToTalPrice = ToTalPrice();
            ViewBag.HideBanner = true;
            return View(listcart);
        }

        [HttpPost]
        public ActionResult Order(FormCollection collection)
        {
            List<CartEntity> crt = GetCart();
            if (crt == null || crt.Count == 0)
            {
                return RedirectToAction("Cart");
            }

            string fullName = (collection["fullName"] ?? "").Trim();
            string phone = (collection["phone"] ?? "").Trim();
            string address = (collection["address"] ?? "").Trim();
            string province = (collection["province"] ?? "").Trim();
            string district = (collection["district"] ?? "").Trim();
            string ward = (collection["ward"] ?? "").Trim();
            string note = (collection["note"] ?? "").Trim();
            string paymentMethod = (collection["paymentMethod"] ?? "COD").Trim();

            if (string.IsNullOrEmpty(fullName) || string.IsNullOrEmpty(phone) || string.IsNullOrEmpty(address))
            {
                TempData["CheckoutError"] = "Vui lòng nhập đầy đủ họ tên, số điện thoại và địa chỉ.";
                return RedirectToAction("Order");
            }

            string fullAddress = address;
            if (!string.IsNullOrEmpty(ward)) fullAddress += ", " + ward;
            if (!string.IsNullOrEmpty(district)) fullAddress += ", " + district;
            if (!string.IsNullOrEmpty(province)) fullAddress += ", " + province;
            if (!string.IsNullOrEmpty(note)) fullAddress += " | Ghi chú: " + note;
            // Customer.Address trong DB chỉ tối đa 100 ký tự
            if (fullAddress.Length > 100) fullAddress = fullAddress.Substring(0, 100);

            Customer cus = Session["usr"] as Customer;
            if (cus != null)
            {
                var dbCus = db.Customers.Find(cus.ID);
                if (dbCus != null)
                {
                    dbCus.Name = fullName.Length > 45 ? fullName.Substring(0, 45) : fullName;
                    dbCus.Phone = phone.Length > 15 ? phone.Substring(0, 15) : phone;
                    dbCus.Address = fullAddress;
                    SafeSaveChanges(db);
                    Session["usr"] = dbCus;
                    cus = dbCus;
                }
            }
            else
            {
                // Khách vãng lai: tìm theo SĐT hoặc tạo tài khoản tạm
                cus = db.Customers.FirstOrDefault(x => x.Phone == phone);
                if (cus == null)
                {
                    string guestUser = "guest_" + phone;
                    cus = db.Customers.FirstOrDefault(x => x.Username == guestUser);
                }
                if (cus == null)
                {
                    cus = new Customer
                    {
                        Username = "guest_" + phone,
                        Passwords = Guid.NewGuid().ToString("N").Substring(0, 8),
                        Name = fullName.Length > 45 ? fullName.Substring(0, 45) : fullName,
                        Phone = phone.Length > 15 ? phone.Substring(0, 15) : phone,
                        Address = fullAddress,
                        EmailAddress = (phone + "@guest.local")
                    };
                    db.Customers.Add(cus);
                    SafeSaveChanges(db);
                }
                else
                {
                    cus.Name = fullName.Length > 45 ? fullName.Substring(0, 45) : fullName;
                    cus.Phone = phone.Length > 15 ? phone.Substring(0, 15) : phone;
                    cus.Address = fullAddress;
                    SafeSaveChanges(db);
                }
            }

            if (string.Equals(paymentMethod, "MoMo", StringComparison.OrdinalIgnoreCase))
            {
                Session["usr"] = cus; // MoMo cần Session customer
                return RedirectToAction("PaymentMoMo");
            }

            // Lưu Order + OrderDetail trong 1 transaction — tránh đơn “trống” khi bước sau lỗi
            using (var tx = db.Database.BeginTransaction())
            {
                try
                {
                    Order or = new Order();
                    or.CustomerID = cus.ID;
                    or.Orderdate = DateTime.Now;
                    or.Status = false;
                    or.Deliverystatus = false;
                    or.Totalprice = (decimal)ToTalPrice();
                    db.Orders.Add(or);
                    SafeSaveChanges(db);

                    foreach (var item in crt)
                    {
                        OrderDetail ordt = new OrderDetail();
                        ordt.OrderID = or.ID;
                        ordt.ItemId = item.IdItem;
                        ordt.Quantity = item.Quantity;
                        ordt.Totalprice = (decimal)(item.Prices * item.Quantity);
                        db.OrderDetails.Add(ordt);

                        // Trừ kho bằng SQL — tránh EF validate lại tên SP dài > 30 ký tự
                        db.Database.ExecuteSqlCommand(
                            "UPDATE [Item] SET Quantity = CASE WHEN ISNULL(Quantity,0) >= {0} THEN Quantity - {0} ELSE 0 END WHERE ID = {1}",
                            item.Quantity, item.IdItem);
                    }
                    SafeSaveChanges(db);
                    tx.Commit();
                }
                catch
                {
                    tx.Rollback();
                    TempData["CheckoutError"] = "Không lưu được đơn hàng. Vui lòng thử lại.";
                    return RedirectToAction("Order");
                }
            }
            Session["Cart"] = null;
            TempData["PaymentMethod"] = paymentMethod;

            return RedirectToAction("OrderConfirmation", "Cart");
        }

        /// <summary>SaveChanges kèm thông báo lỗi validation rõ ràng.</summary>
        private static void SafeSaveChanges(ProTechTiveGearEntities context)
        {
            try
            {
                context.SaveChanges();
            }
            catch (System.Data.Entity.Validation.DbEntityValidationException ex)
            {
                var msgs = ex.EntityValidationErrors
                    .SelectMany(e => e.ValidationErrors)
                    .Select(e => e.PropertyName + ": " + e.ErrorMessage);
                throw new Exception("Lỗi lưu dữ liệu: " + string.Join("; ", msgs), ex);
            }
        }


        //MoMo

        public ActionResult PaymentMoMo()
        {
            Customer cus = (Customer)Session["usr"];
            List<CartEntity> crt = GetCart();
            if (cus == null || crt == null || crt.Count == 0)
            {
                return RedirectToAction("Order");
            }

            Order or;
            using (var tx = db.Database.BeginTransaction())
            {
                try
                {
                    or = new Order();
                    or.CustomerID = cus.ID;
                    or.Orderdate = DateTime.Now;
                    or.Status = false;
                    or.Deliverystatus = false;
                    or.Totalprice = (decimal)ToTalPrice();
                    db.Orders.Add(or);
                    SafeSaveChanges(db);
                    foreach (var item in crt)
                    {
                        OrderDetail ordt = new OrderDetail();
                        ordt.OrderID = or.ID;
                        ordt.ItemId = item.IdItem;
                        ordt.Quantity = item.Quantity;
                        ordt.Totalprice = (decimal)(item.Prices * item.Quantity);
                        db.OrderDetails.Add(ordt);

                        db.Database.ExecuteSqlCommand(
                            "UPDATE [Item] SET Quantity = CASE WHEN ISNULL(Quantity,0) >= {0} THEN Quantity - {0} ELSE 0 END WHERE ID = {1}",
                            item.Quantity, item.IdItem);
                    }
                    SafeSaveChanges(db);
                    tx.Commit();
                }
                catch
                {
                    tx.Rollback();
                    TempData["CheckoutError"] = "Không lưu được đơn hàng. Vui lòng thử lại.";
                    return RedirectToAction("Order");
                }
            }
            Session["Cart"] = null;
            //
            var obj = or;
            var total = obj.Totalprice;
            string url = "http://localhost:51494//Cart/ReturnUrl/" + or.ID;
            //request params need to request to MoMo system
            string endpoint = "https://test-payment.momo.vn/gw_payment/transactionProcessor";
            string partnerCode = "MOMOOJOI20210710";
            string accessKey = "iPXneGmrJH0G8FOP";
            string serectkey = "sFcbSGRSJjwGxwhhcEktCHWYUuTuPNDB";
            string orderInfo = "Thanh toán cho đơn hàng";
            string returnUrl = url;
            string notifyurl = "http://ba1adf48beba.ngrok.io/Home/SavePayment"; //lưu ý: notifyurl không được sử dụng localhost, có thể sử dụng ngrok để public localhost trong quá trình test

            string amount = total.ToString();
            string orderid = DateTime.Now.Ticks.ToString();
            string requestId = DateTime.Now.Ticks.ToString();
            string extraData = "";

            //Before sign HMAC SHA256 signature
            string rawHash = "partnerCode=" +
                partnerCode + "&accessKey=" +
                accessKey + "&requestId=" +
                requestId + "&amount=" +
                amount + "&orderId=" +
                orderid + "&orderInfo=" +
                orderInfo + "&returnUrl=" +
                returnUrl + "&notifyUrl=" +
                notifyurl + "&extraData=" +
                extraData;

            //sign signature SHA256
            string signature = signSHA256(rawHash, serectkey);

            //build body json request
            JObject message = new JObject
            {
                { "partnerCode", partnerCode },
                { "accessKey", accessKey },
                { "requestId", requestId },
                { "amount", amount },
                { "orderId", orderid },
                { "orderInfo", orderInfo },
                { "returnUrl", returnUrl },
                { "notifyUrl", notifyurl },
                { "extraData", extraData },
                { "requestType", "captureMoMoWallet" },
                { "signature", signature }

            };

            string responseFromMomo = sendPaymentRequest(endpoint, message.ToString());

            JObject jmessage = JObject.Parse(responseFromMomo);


            return Redirect(jmessage.GetValue("payUrl").ToString());
        }

        public ActionResult ReturnUrl(int id)
        {
            Payment pm = new Payment();
            var obj = db.Orders.FirstOrDefault(x => x.ID == id);
            pm.Payprices = obj.Totalprice;
            pm.OrderID = obj.ID;
            db.Payments.Add(pm);
            db.SaveChanges();
            return RedirectToAction("OrderConfirmation", "Cart");
        }

        //Khi thanh toán xong ở cổng thanh toán Momo, Momo sẽ trả về một số thông tin, trong đó có errorCode để check thông tin thanh toán
        //errorCode = 0 : thanh toán thành công (Request.QueryString["errorCode"])
        //Tham khảo bảng mã lỗi tại: https://developers.momo.vn/#/docs/aio/?id=b%e1%ba%a3ng-m%c3%a3-l%e1%bb%97i
        public ActionResult ConfirmPaymentClient()
        {
            //hiển thị thông báo cho người dùng
            return View();
        }

        [HttpPost]
        public void SavePayment()
        {
            //cập nhật dữ liệu vào db
        }
        public string getHash(string partnerCode, string merchantRefId,
          string amount, string paymentCode, string storeId, string storeName, string publicKeyXML)
        {
            string json = "{\"partnerCode\":\"" +
                partnerCode + "\",\"partnerRefId\":\"" +
                merchantRefId + "\",\"amount\":" +
                amount + ",\"paymentCode\":\"" +
                paymentCode + "\",\"storeId\":\"" +
                storeId + "\",\"storeName\":\"" +
                storeName + "\"}";

            byte[] data = Encoding.UTF8.GetBytes(json);
            string result = null;
            using (var rsa = new RSACryptoServiceProvider(4096)) //KeySize
            {
                try
                {
                    // MoMo's public key has format PEM.
                    // You must convert it to XML format. Recommend tool: https://superdry.apphb.com/tools/online-rsa-key-converter
                    rsa.FromXmlString(publicKeyXML);
                    var encryptedData = rsa.Encrypt(data, false);
                    var base64Encrypted = Convert.ToBase64String(encryptedData);
                    result = base64Encrypted;
                }
                finally
                {
                    rsa.PersistKeyInCsp = false;
                }

            }

            return result;

        }
        public string buildQueryHash(string partnerCode, string merchantRefId,
            string requestid, string publicKey)
        {
            string json = "{\"partnerCode\":\"" +
                partnerCode + "\",\"partnerRefId\":\"" +
                merchantRefId + "\",\"requestId\":\"" +
                requestid + "\"}";

            byte[] data = Encoding.UTF8.GetBytes(json);
            string result = null;
            using (var rsa = new RSACryptoServiceProvider(2048))
            {
                try
                {
                    // client encrypting data with public key issued by server
                    rsa.FromXmlString(publicKey);
                    var encryptedData = rsa.Encrypt(data, false);
                    var base64Encrypted = Convert.ToBase64String(encryptedData);
                    result = base64Encrypted;
                }
                finally
                {
                    rsa.PersistKeyInCsp = false;
                }

            }

            return result;

        }

        public string buildRefundHash(string partnerCode, string merchantRefId,
            string momoTranId, long amount, string description, string publicKey)
        {
            string json = "{\"partnerCode\":\"" +
                partnerCode + "\",\"partnerRefId\":\"" +
                merchantRefId + "\",\"momoTransId\":\"" +
                momoTranId + "\",\"amount\":" +
                amount + ",\"description\":\"" +
                description + "\"}";

            byte[] data = Encoding.UTF8.GetBytes(json);
            string result = null;
            using (var rsa = new RSACryptoServiceProvider(2048))
            {
                try
                {
                    // client encrypting data with public key issued by server
                    rsa.FromXmlString(publicKey);
                    var encryptedData = rsa.Encrypt(data, false);
                    var base64Encrypted = Convert.ToBase64String(encryptedData);
                    result = base64Encrypted;
                }
                finally
                {
                    rsa.PersistKeyInCsp = false;
                }

            }

            return result;

        }
        public string signSHA256(string message, string key)
        {
            byte[] keyByte = Encoding.UTF8.GetBytes(key);
            byte[] messageBytes = Encoding.UTF8.GetBytes(message);
            using (var hmacsha256 = new HMACSHA256(keyByte))
            {
                byte[] hashmessage = hmacsha256.ComputeHash(messageBytes);
                string hex = BitConverter.ToString(hashmessage);
                hex = hex.Replace("-", "").ToLower();
                return hex;

            }
        }

        public static string sendPaymentRequest(string endpoint, string postJsonString)
        {

            try
            {
                HttpWebRequest httpWReq = (HttpWebRequest)WebRequest.Create(endpoint);

                var postData = postJsonString;

                var data = Encoding.UTF8.GetBytes(postData);

                httpWReq.ProtocolVersion = HttpVersion.Version11;
                httpWReq.Method = "POST";
                httpWReq.ContentType = "application/json";

                httpWReq.ContentLength = data.Length;
                httpWReq.ReadWriteTimeout = 30000;
                httpWReq.Timeout = 15000;
                Stream stream = httpWReq.GetRequestStream();
                stream.Write(data, 0, data.Length);
                stream.Close();

                HttpWebResponse response = (HttpWebResponse)httpWReq.GetResponse();

                string jsonresponse = "";

                using (var reader = new StreamReader(response.GetResponseStream()))
                {

                    string temp = null;
                    while ((temp = reader.ReadLine()) != null)
                    {
                        jsonresponse += temp;
                    }
                }


                //todo parse it
                return jsonresponse;
                //return new MomoResponse(mtid, jsonresponse);

            }
            catch (WebException e)
            {
                return e.Message;
            }
        }

        //


        public ActionResult OrderConfirmation()
        {
            return View();
        }
        public ActionResult Newinformation()
        {
            if (Session["usr"] == null)
            {
                return RedirectToAction("Login", "Login");
            }
            var ac = ((Customer)Session["usr"]);

            return View(new AccountClientEntity(ac));
        }
        [HttpPost]
        public ActionResult Newinformation(FormCollection fc)
        {
            //string userName = collection["Username"];
            //string passWord = collection["Password"];
            //string conFirmPassWord = collection["ConfirmPassword"];
            //string name = collection["Name"];
            //var Birthday = String.Format("{0:MM/dd/yyyy}", collection["Birthday"]);
            //string Email = collection["Email"];
            //string address = collection["Address"];
            //int Gender = Convert.ToInt32(collection["Gender"]);
            //string phoneNumber = collection["PhoneNumber"];
            var ac = ((Customer)Session["usr"]);

            if (Session["usr"] != null)
            {
                string userName = fc["userName"].ToString();
                string address = fc["address"].ToString();
                string phoneNumber = fc["phonenumber"].ToString();
                string name = fc["name"].ToString();
                string emailAdress = fc["email"].ToString();

                var temp = db.Customers.SingleOrDefault(x => x.Username == userName);
                if (temp != null && address != "")
                {
                    temp.Address = fc["address"];
                    temp.Name = fc["name"];
                    temp.Phone = fc["phonenumber"];
                    temp.EmailAddress = fc["email"];
                    db.SaveChanges();
                    Session["usr"] = temp;
                    return RedirectToAction("Order", "Cart");

                }



            }
            else
            {
                return RedirectToAction("Index", "AuraStore");
            }
            ModelState.AddModelError("", "Error cannot change Infomation..");
            return View(new AccountClientEntity(ac));
        }
    }

}