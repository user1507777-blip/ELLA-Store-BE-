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
                PaymentStatus = string.IsNullOrEmpty(e.PaymentStatus) ? PayStatus.ChuaThanhToan : e.PaymentStatus,
                CreatedAt = e.OrderDate,
                VoucherCode = e.VoucherCode,
                DiscountAmount = e.DiscountAmount
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

        // Sản phẩm đang nằm trong đơn chưa kết thúc (chờ xác nhận / đã xác nhận / đang giao) -> trả mã đơn đầu tiên, 0 nếu không có.
        public static int ActiveOrderOfProduct(int productId)
        {
            using (var db = new Db.MyStoreEntities())
            {
                var ds = db.OrderDetail
                    .Where(d => d.ProductID == productId && d.Order.OrderStatus != "Hoàn thành" && d.Order.OrderStatus != "Đã hủy")
                    .Select(d => d.OrderID).ToList();
                return ds.Count == 0 ? 0 : ds.Min();
            }
        }

        // Khách đặt hàng: kiểm tra tồn kho THEO TỪNG SIZE, lấy giá thật từ database (đã tính sale), trừ kho,
        // ghi lịch sử xuất kho và lưu đơn trong cùng một giao dịch.
        // o.Items cần ProductID, Size, Quantity (giá và tên được gán lại từ database).
        public static bool Place(Order o, out string error)
        {
            error = null;
            if (o.Items == null || o.Items.Count == 0) { error = "Giỏ hàng trống."; return false; }

            // Gộp các dòng trùng sản phẩm + size để kiểm tra tồn đúng
            var lines = o.Items
                .GroupBy(i => new { i.ProductID, Size = (i.Size ?? "").Trim() })
                .Select(g => new OrderItem { ProductID = g.Key.ProductID, Size = g.Key.Size, Quantity = g.Sum(x => x.Quantity), ProductName = g.First().ProductName })
                .ToList();

            using (var db = new Db.MyStoreEntities())
            using (var tx = db.Database.BeginTransaction())
            {
                var e = new Db.Order
                {
                    CustomerID = o.CustomerID,
                    OrderDate = DateTime.Now,
                    PaymentStatus = o.PaymentMethod == "Chuyển khoản" ? PayStatus.DaThanhToan : PayStatus.ChuaThanhToan,
                    AddressDelivery = o.Address,
                    ReceiverName = o.Receiver,
                    ReceiverPhone = o.Phone,
                    ReceiverEmail = o.Email,
                    PaymentMethod = o.PaymentMethod == "Chuyển khoản" ? "Chuyển khoản" : "COD",
                    OrderStatus = OrderStatus.ChoXacNhan
                };
                decimal sub = 0;
                var items = new List<OrderItem>();
                var moves = new List<OrderItem>();
                foreach (var it in lines)
                {
                    var p = db.Product.Find(it.ProductID);
                    if (p == null) { error = "Sản phẩm \"" + it.ProductName + "\" không còn tồn tại."; return false; }
                    if (it.Quantity <= 0) { error = "Số lượng không hợp lệ."; return false; }
                    if (string.IsNullOrEmpty(it.Size)) { error = "Vui lòng chọn size cho \"" + p.ProductName + "\"."; return false; }

                    decimal gia = Product.ComputeSalePrice(p.ProductPrice, p.DiscountPercent);
                    sub += gia * it.Quantity;
                    e.OrderDetail.Add(new Db.OrderDetail
                    {
                        ProductID = p.ProductID,
                        ProductName = p.ProductName,
                        Size = it.Size,
                        Quantity = it.Quantity,
                        UnitPrice = gia
                    });
                    items.Add(new OrderItem { ProductID = p.ProductID, ProductName = p.ProductName, Size = it.Size, Quantity = it.Quantity, UnitPrice = gia });
                    moves.Add(it);
                }
                // Voucher: kiểm tra lại trên server, tính tiền giảm theo % trên tiền hàng
                decimal giam = 0;
                if (!string.IsNullOrWhiteSpace(o.VoucherCode))
                {
                    Voucher v; string loiVoucher;
                    if (!VoucherStore.Check(db, o.VoucherCode, sub, out v, out giam, out loiVoucher)) { error = loiVoucher; return false; }
                    e.VoucherCode = v.Code;
                    e.DiscountAmount = giam;
                }
                // miễn phí giao hàng cho đơn từ 1.000.000đ, tính trên tiền hàng SAU khi trừ voucher
                e.ShippingFee = (sub - giam) >= 1000000m ? 0m : 30000m;
                e.TotalAmount = sub - giam + e.ShippingFee;

                // Kiểm tra và trừ tồn từng size TRƯỚC khi lưu đơn; thiếu hàng thì báo lỗi, không tạo đơn
                foreach (var it in moves)
                {
                    string err;
                    if (!ProductStore.ChangeSizeStock(db, it.ProductID, it.Size, -it.Quantity, "Bán hàng", null, null, o.Receiver, out err))
                    {
                        error = err + " Vui lòng giảm số lượng.";
                        return false;
                    }
                }
                db.Order.Add(e);
                db.SaveChanges();

                // Gắn mã đơn vào lịch sử xuất kho vừa tạo
                var pending = db.StockMovement.Local.Where(m => m.MovementType == "Bán hàng" && m.OrderID == null).ToList();
                foreach (var m in pending) { m.OrderID = e.OrderID; m.Note = "Bán cho đơn #" + e.OrderID; }
                db.SaveChanges();
                tx.Commit();

                o.OrderID = e.OrderID;
                o.CreatedAt = e.OrderDate;
                o.ShippingFee = e.ShippingFee;
                o.VoucherCode = e.VoucherCode;
                o.DiscountAmount = e.DiscountAmount;
                o.PaymentStatus = e.PaymentStatus;
                o.PaymentMethod = e.PaymentMethod;
                o.Status = e.OrderStatus;
                o.Items = items;
                return true;
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
                    TotalAmount = o.TotalPrice,
                    VoucherCode = o.VoucherCode,
                    DiscountAmount = o.DiscountAmount,
                    PaymentStatus = string.IsNullOrEmpty(o.PaymentStatus) ? PayStatus.ChuaThanhToan : o.PaymentStatus,
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

        // Đổi trạng thái đơn. Không đổi được khi đơn đã ở trạng thái kết thúc (Hoàn thành / Đã hủy).
        //  - Hủy đơn: hoàn lại tồn kho; nếu khách đã thanh toán trước -> thanh toán chuyển sang "Chờ hoàn tiền".
        //  - Hoàn thành: đơn COD được ghi nhận "Đã thanh toán" (thu tiền khi giao).
        public static bool ChangeStatus(int id, string newStatus, out string error, string by = "admin")
        {
            error = null;
            using (var db = new Db.MyStoreEntities())
            {
                var o = db.Order.Include(x => x.OrderDetail).FirstOrDefault(x => x.OrderID == id);
                if (o == null) { error = "Không tìm thấy đơn hàng."; return false; }
                if (OrderStatus.IsFinal(o.OrderStatus))
                {
                    error = "Đơn đã ở trạng thái kết thúc (" + o.OrderStatus + "), không thể thay đổi.";
                    return false;
                }
                if (!OrderStatus.NextOf(o.OrderStatus).Contains(newStatus))
                {
                    error = "Không thể chuyển từ \"" + o.OrderStatus + "\" sang \"" + newStatus + "\".";
                    return false;
                }
                if (newStatus == OrderStatus.DaHuy)
                {
                    foreach (var d in o.OrderDetail)
                    {
                        string err;
                        // Trả hàng về đúng size của dòng đơn, ghi lịch sử "Hoàn kho"
                        ProductStore.ChangeSizeStock(db, d.ProductID, d.Size, d.Quantity, "Hoàn kho", "Hủy đơn #" + o.OrderID, o.OrderID, by, out err);
                    }
                    if (o.PaymentStatus == PayStatus.DaThanhToan) o.PaymentStatus = PayStatus.ChoHoanTien;
                }
                else if (newStatus == OrderStatus.HoanThanh)
                {
                    if (string.IsNullOrEmpty(o.PaymentStatus) || o.PaymentStatus == PayStatus.ChuaThanhToan)
                        o.PaymentStatus = PayStatus.DaThanhToan;
                }
                o.OrderStatus = newStatus;
                db.SaveChanges();
                return true;
            }
        }

        // Khách tự hủy đơn của chính mình, chỉ khi đơn còn "Chờ xác nhận" (chưa được cửa hàng xử lý).
        public static bool CustomerCancel(int id, int customerId, out string error)
        {
            error = null;
            var o = Find(id);
            if (o == null || o.CustomerID != customerId) { error = "Không tìm thấy đơn hàng."; return false; }
            if (o.Status != OrderStatus.ChoXacNhan)
            {
                error = "Đơn đang ở trạng thái \"" + o.Status + "\" nên không thể tự hủy. Vui lòng liên hệ cửa hàng.";
                return false;
            }
            return ChangeStatus(id, OrderStatus.DaHuy, out error, "khách");
        }

        // Admin xác nhận đã hoàn tiền cho đơn đã hủy (Chờ hoàn tiền -> Đã hoàn tiền).
        public static bool ConfirmRefund(int id, out string error)
        {
            error = null;
            using (var db = new Db.MyStoreEntities())
            {
                var o = db.Order.Find(id);
                if (o == null) { error = "Không tìm thấy đơn hàng."; return false; }
                if (o.PaymentStatus != PayStatus.ChoHoanTien) { error = "Đơn này không ở trạng thái chờ hoàn tiền."; return false; }
                o.PaymentStatus = PayStatus.DaHoanTien;
                db.SaveChanges();
                return true;
            }
        }

        // Số đơn đang chờ hoàn tiền (hiện trên trang Quản lý đơn hàng).
        public static int CountPendingRefund()
        {
            using (var db = new Db.MyStoreEntities())
            {
                return db.Order.Count(o => o.PaymentStatus == PayStatus.ChoHoanTien);
            }
        }
    }
}
