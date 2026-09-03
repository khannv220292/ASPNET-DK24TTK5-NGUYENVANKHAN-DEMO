using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;
using LaptopStore.Models;

namespace LaptopStore.Controllers
{
    public class CartController : Controller
    {
        private LapStoreDbContext db = new LapStoreDbContext();

        private List<CartItem> GetCart()
        {
            var cart = Session["Cart"] as List<CartItem>;
            if (cart == null)
            {
                cart = new List<CartItem>();
                Session["Cart"] = cart;
            }
            return cart;
        }

        public ActionResult Index()
        {
            return View(GetCart());
        }

        public ActionResult AddToCart(long id)
        {
            var item = db.Items.Find(id);
            if (item != null)
            {
                var cart = GetCart();
                var cartItem = cart.FirstOrDefault(c => c.ItemId == id);
                if (cartItem == null)
                {
                    cart.Add(new CartItem
                    {
                        ItemId = item.ID,
                        ItemName = item.Name,
                        Picture = item.Picture,
                        UnitPrice = item.SellPrice,
                        Quantity = 1
                    });
                }
                else
                {
                    cartItem.Quantity++;
                }
            }
            return RedirectToAction("Index");
        }

        [HttpPost]
        public ActionResult Checkout(string customerName, string phone, string address)
        {
            var cart = GetCart();
            if (!cart.Any()) return RedirectToAction("Index");

            var customer = new StoreCustomer
            {
                Username = "guest_" + Guid.NewGuid().ToString().Substring(0, 6),
                Passwords = "1",
                Name = customerName,
                Phone = phone,
                Address = address
            };
            db.Customers.Add(customer);
            db.SaveChanges();

            var order = new StoreOrder
            {
                CustomerID = customer.ID,
                Orderdate = DateTime.Now,
                Status = false,
                Deliverystatus = false,
                Totalprice = cart.Sum(c => c.TotalPrice)
            };
            db.Orders.Add(order);
            db.SaveChanges();

            foreach (var item in cart)
            {
                db.OrderDetails.Add(new StoreOrderDetail
                {
                    OrderID = order.ID,
                    ItemId = item.ItemId,
                    Quantity = item.Quantity,
                    Totalprice = item.TotalPrice
                });
            }
            db.SaveChanges();

            Session["Cart"] = null; // Làm rỗng giỏ
            return View("OrderSuccess", order);
        }
    }
}
