using System;
using System.Collections.Generic;
using System.Linq;
using Db = ELLA_Store.Data;

namespace ELLA_Store.Models
{
    public static class VoucherStore
    {
        private static Voucher ToModel(Db.Voucher e)
        {
            return new Voucher
            {
                VoucherID = e.VoucherID,
                Code = e.Code,
                DiscountPercent = e.DiscountPercent,
                Description = e.Description,
                MinOrder = e.MinOrder,
                ExpiryDate = e.ExpiryDate,
                IsActive = e.IsActive
            };
        }

        // Tất cả voucher kèm số đơn đã dùng và tổng tiền đã giảm.
        public static List<Voucher> All()
        {
            using (var db = new Db.MyStoreEntities())
            {
                var list = db.Voucher.OrderBy(v => v.VoucherID).ToList().Select(ToModel).ToList();
                var dung = db.Order.Where(o => o.VoucherCode != null && o.OrderStatus != "Đã hủy")
                                   .GroupBy(o => o.VoucherCode)
                                   .Select(g => new { Code = g.Key, N = g.Count(), Giam = g.Sum(o => o.DiscountAmount) })
                                   .ToList();
                foreach (var v in list)
                {
                    var d = dung.FirstOrDefault(x => string.Equals(x.Code, v.Code, StringComparison.OrdinalIgnoreCase));
                    if (d != null) { v.UsedCount = d.N; v.TotalDiscount = d.Giam; }
                }
                return list;
            }
        }

        public static List<Voucher> Usable()
        {
            return All().Where(v => v.IsUsable).ToList();
        }

        public static Voucher Find(int id)
        {
            using (var db = new Db.MyStoreEntities())
            {
                var e = db.Voucher.Find(id);
                return e == null ? null : ToModel(e);
            }
        }

        public static bool CodeExists(string code, int exceptId)
        {
            using (var db = new Db.MyStoreEntities())
            {
                string c = (code ?? "").Trim();
                return db.Voucher.Any(v => v.Code == c && v.VoucherID != exceptId);
            }
        }

        public static void Add(Voucher v)
        {
            using (var db = new Db.MyStoreEntities())
            {
                var e = new Db.Voucher
                {
                    Code = v.Code.Trim().ToUpper(),
                    DiscountPercent = v.DiscountPercent,
                    Description = string.IsNullOrWhiteSpace(v.Description) ? null : v.Description.Trim(),
                    MinOrder = v.MinOrder,
                    ExpiryDate = v.ExpiryDate,
                    IsActive = v.IsActive,
                    CreatedAt = DateTime.Now
                };
                db.Voucher.Add(e);
                db.SaveChanges();
                v.VoucherID = e.VoucherID;
            }
        }

        public static bool Update(Voucher v)
        {
            using (var db = new Db.MyStoreEntities())
            {
                var e = db.Voucher.Find(v.VoucherID);
                if (e == null) return false;
                e.Code = v.Code.Trim().ToUpper();
                e.DiscountPercent = v.DiscountPercent;
                e.Description = string.IsNullOrWhiteSpace(v.Description) ? null : v.Description.Trim();
                e.MinOrder = v.MinOrder;
                e.ExpiryDate = v.ExpiryDate;
                e.IsActive = v.IsActive;
                db.SaveChanges();
                return true;
            }
        }

        public static bool SetActive(int id, bool active)
        {
            using (var db = new Db.MyStoreEntities())
            {
                var e = db.Voucher.Find(id);
                if (e == null) return false;
                e.IsActive = active;
                db.SaveChanges();
                return true;
            }
        }

        // Đơn cũ vẫn giữ mã dạng chữ nên xóa voucher không ảnh hưởng đơn đã đặt.
        public static bool Delete(int id)
        {
            using (var db = new Db.MyStoreEntities())
            {
                var e = db.Voucher.Find(id);
                if (e == null) return false;
                db.Voucher.Remove(e);
                db.SaveChanges();
                return true;
            }
        }

        // Kiểm tra mã khách nhập với tiền hàng tạm tính; trả về số tiền giảm.
        public static bool Check(string code, decimal subtotal, out Voucher voucher, out decimal discount, out string error)
        {
            using (var db = new Db.MyStoreEntities())
            {
                return Check(db, code, subtotal, out voucher, out discount, out error);
            }
        }

        public static bool Check(Db.MyStoreEntities db, string code, decimal subtotal, out Voucher voucher, out decimal discount, out string error)
        {
            voucher = null; discount = 0; error = null;
            string c = (code ?? "").Trim();
            if (c.Length == 0) { error = "Vui lòng nhập mã voucher."; return false; }
            var e = db.Voucher.FirstOrDefault(v => v.Code == c);   // so sánh không phân biệt hoa/thường theo collation của SQL Server
            if (e == null) { error = "Mã voucher không tồn tại."; return false; }
            var m = ToModel(e);
            if (!m.IsActive) { error = "Mã voucher này đang tạm ngưng."; return false; }
            if (m.IsExpired) { error = "Mã voucher đã hết hạn (" + m.ExpiryDate.Value.ToString("dd/MM/yyyy") + ")."; return false; }
            if (subtotal < m.MinOrder) { error = "Mã chỉ áp dụng cho đơn từ " + m.MinOrder.ToString("#,##0") + "đ."; return false; }
            voucher = m;
            discount = Math.Round(subtotal * m.DiscountPercent / 100m, 0);
            return true;
        }
    }
}
