using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using Db = ELLA_Store.Data;

namespace ELLA_Store.Models
{
    // Đọc/ghi bảng Order và OrderDetail trong database MyStore (qua Entity Framework).
    public static class OrderStore
    {
        private static Order ToModel(Db.Order e)
        {
            var o = new Order
            {
                OrderID = e.OrderID,
                CustomerID = e.CustomerID,
                Receiver = e.ReceiverName,
                Phone = e.ReceiverPhone,
                Email = e.ReceiverEmail,
                Address = e.AddressDelivery,
                PaymentMethod = e.PaymentMethod,
                ShippingFee = e.ShippingFee,
                Status = e.OrderStatus,
                CreatedAt = e.OrderDate
            };
            foreach (var d in e.OrderDetail.OrderBy(x => x.ID))
            {
                o.Items.Add(new OrderItem
                {
                    OrderItemID = d.ID,
                    OrderID = d.OrderID,
                    ProductID = d.ProductID,
                    ProductName = d.ProductName,
                    Size = d.Size,
                    Quantity = d.Quantity,
                    UnitPrice = d.UnitPrice
                });
            }
            return o;
        }

        public static List<Order> All()
        {
            using (var db = new Db.MyStoreEntities())
            {
                return db.Order.Include(o => o.OrderDetail).OrderByDescending(o => o.OrderDate).ToList().Select(x => ToModel(x)).ToList();
            }
        }

        public static Order Find(int id)
        {
            using (var db = new Db.MyStoreEntities())
            {
                var e = db.Order.Include(o => o.OrderDetail).FirstOrDefault(o => o.OrderID == id);
                return e == null ? null : ToModel(e);
            }
        }

        public static List<Order> OfCustomer(int customerId)
        {
            using (var db = new Db.MyStoreEntities())
            {
                return db.Order.Include(o => o.OrderDetail)
                    .Where(o => o.CustomerID == customerId)
                    .OrderByDescending(o => o.OrderDate).ToList().Select(x => ToModel(x)).ToList();
            }
        }

        public static int CountOfCustomer(int customerId)
        {
            using (var db = new Db.MyStoreEntities())
            {
                return db.Order.Count(o => o.CustomerID == customerId);
            }
        }

        // Sản phẩm đã xuất hiện trong đơn nào chưa (dùng để chặn xóa sản phẩm).
        public static bool HasProduct(int productId)
        {
            using (var db = new Db.MyStoreEntities())
            {
                return db.OrderDetail.Any(d => d.ProductID == productId);
            }
        }

        // Dùng khi có chức năng đặt hàng phía khách: thêm đơn mới kèm các dòng hàng.
        public static void Add(Order o)
        {
            using (var db = new Db.MyStoreEntities())
            {
                var e = new Db.Order
                {
                    CustomerID = o.CustomerID,
                    OrderDate = DateTime.Now,
                    TotalAmount = o.SubTotal + o.ShippingFee,
                    PaymentStatus = "Chưa thanh toán",
                    AddressDelivery = o.Address,
                    ReceiverName = o.Receiver,
                    ReceiverPhone = o.Phone,
                    ReceiverEmail = o.Email,
                    PaymentMethod = string.IsNullOrEmpty(o.PaymentMethod) ? "COD" : o.PaymentMethod,
                    ShippingFee = o.ShippingFee,
                    OrderStatus = string.IsNullOrEmpty(o.Status) ? OrderStatus.ChoXacNhan : o.Status
                };
                foreach (var it in o.Items)
                {
                    e.OrderDetail.Add(new Db.OrderDetail
                    {
                        ProductID = it.ProductID,
                        ProductName = it.ProductName,
                        Size = it.Size,
                        Quantity = it.Quantity,
                        UnitPrice = it.UnitPrice
                    });
                }
                db.Order.Add(e);
                db.SaveChanges();
                o.OrderID = e.OrderID;
            }
        }

        // Đổi trạng thái theo quy trình; hủy đơn thì hoàn lại tồn kho (cùng một lần lưu).
        public static bool ChangeStatus(int id, string newStatus, out string error)
        {
            error = null;
            using (var db = new Db.MyStoreEntities())
            {
                var o = db.Order.Include(x => x.OrderDetail).FirstOrDefault(x => x.OrderID == id);
                if (o == null) { error = "Không tìm thấy đơn hàng."; return false; }
                if (!OrderStatus.NextOf(o.OrderStatus).Contains(newStatus))
                {
                    error = "Không thể chuyển từ \"" + o.OrderStatus + "\" sang \"" + newStatus + "\".";
                    return false;
                }
                if (newStatus == OrderStatus.DaHuy)
                {
                    foreach (var d in o.OrderDetail)
                    {
                        var p = db.Product.Find(d.ProductID);
                        if (p != null) p.ProductStock += d.Quantity;
                    }
                }
                o.OrderStatus = newStatus;
                db.SaveChanges();
                return true;
            }
        }
    }
}
