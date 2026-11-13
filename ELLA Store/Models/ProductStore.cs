using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Data.Entity.Infrastructure;
using System.Linq;
using Db = ELLA_Store.Data;

namespace ELLA_Store.Models
{
    // Đọc/ghi bảng Product trong database MyStore (qua Entity Framework).
    public static class ProductStore
    {
        private static Product ToModel(Db.Product e)
        {
            var p = new Product
            {
                ProductID = e.ProductID,
                NamePro = e.ProductName,
                CategoryID = e.CategoryID,
                Price = e.ProductPrice,
                Stock = e.ProductStock,
                ImagePro = e.ProductImage,
                DiscountPercent = e.DiscountPercent
            };
            if (e.Category != null) p.SetCategoryCache(e.Category.CategoryName);
            return p;
        }

        public static List<Product> All()
        {
            using (var db = new Db.MyStoreEntities())
            {
                var list = db.Product.Include(x => x.Category).OrderBy(x => x.ProductID).ToList().Select(x => ToModel(x)).ToList();
                var sold = SoldCounts(db);
                var sizes = SizesByProduct(db);
                foreach (var p in list)
                {
                    int n;
                    if (sold.TryGetValue(p.ProductID, out n)) p.Sold = n;
                    List<SizeStock> ss;
                    if (sizes.TryGetValue(p.ProductID, out ss))
                    {
                        p.Sizes = ss;
                        p.Stock = ss.Sum(x => x.Quantity);     // tồn = tổng các size
                    }
                }
                // Top bán chạy (tối đa SoBestSeller sản phẩm, phải có người mua) được gắn nhãn BEST SELLER
                foreach (var b in list.Where(x => x.Sold > 0).OrderByDescending(x => x.Sold).ThenBy(x => x.ProductID).Take(SoBestSeller))
                    b.IsBestSeller = true;
                return list;
            }
        }

        public const int SoBestSeller = 5;

        // ---------------- Size & tồn kho theo size ----------------

        private static int SizeOrder(string name)
        {
            int n;
            return int.TryParse(name, out n) ? n : 999;
        }

        // Tất cả size có trong bảng Size (36, 37, ... 45).
        public static List<string> AllSizeNames()
        {
            using (var db = new Db.MyStoreEntities())
            {
                return db.Size.ToList().Select(x => x.SizeName).OrderBy(SizeOrder).ToList();
            }
        }

        private static Dictionary<int, List<SizeStock>> SizesByProduct(Db.MyStoreEntities db)
        {
            var names = db.Size.ToDictionary(x => x.SizeID, x => x.SizeName);
            return db.ProductSize.ToList()
                .GroupBy(x => x.ProductID)
                .ToDictionary(
                    g => g.Key,
                    g => g.Select(x => new SizeStock { Size = names[x.SizeID], Quantity = x.Quantity })
                          .OrderBy(x => SizeOrder(x.Size)).ToList());
        }

        // Đổi số lượng tồn của một size (delta > 0: vào kho, < 0: ra khỏi kho), ghi lịch sử và cập nhật tổng tồn.
        // Không gọi SaveChanges: nơi gọi tự lưu. Trả về false (kèm error) nếu size không có hoặc tồn sẽ âm.
        public static bool ChangeSizeStock(Db.MyStoreEntities db, int productId, string sizeName, int delta,
                                           string type, string note, int? orderId, string by, out string error)
        {
            error = null;
            var p = db.Product.Find(productId);
            if (p == null) { error = "Sản phẩm không tồn tại."; return false; }
            var size = db.Size.FirstOrDefault(x => x.SizeName == sizeName);
            if (size == null) { error = "Size \"" + sizeName + "\" không hợp lệ."; return false; }

            var row = db.ProductSize.FirstOrDefault(x => x.ProductID == productId && x.SizeID == size.SizeID);
            int cur = row == null ? 0 : row.Quantity;
            if (cur + delta < 0)
            {
                error = "\"" + p.ProductName + "\" size " + sizeName + " chỉ còn " + cur + ".";
                return false;
            }
            if (row == null)
                db.ProductSize.Add(new Db.ProductSize { ProductID = productId, SizeID = size.SizeID, Quantity = cur + delta });
            else
                row.Quantity = cur + delta;

            p.ProductStock += delta;
            db.StockMovement.Add(new Db.StockMovement
            {
                ProductID = productId,
                SizeID = size.SizeID,
                Quantity = delta,
                MovementType = type,
                Note = note,
                OrderID = orderId,
                CreatedAt = DateTime.Now,
                CreatedBy = by
            });
            return true;
        }

        // Admin nhập/xuất kho một size.
        public static bool AdjustSize(int productId, string size, int delta, string type, string note, string by, out string error)
        {
            using (var db = new Db.MyStoreEntities())
            {
                if (!ChangeSizeStock(db, productId, size, delta, type, note, null, by, out error)) return false;
                db.SaveChanges();
                return true;
            }
        }

        // Thống kê nhập - xuất theo sản phẩm trong khoảng ngày (from/to có thể null = không giới hạn).
        public static List<StockReportRow> MovementReport(DateTime? from, DateTime? to)
        {
            using (var db = new Db.MyStoreEntities())
            {
                var q = db.StockMovement.AsQueryable();
                if (from.HasValue) { var f = from.Value.Date; q = q.Where(m => m.CreatedAt >= f); }
                if (to.HasValue) { var t = to.Value.Date.AddDays(1); q = q.Where(m => m.CreatedAt < t); }
                var moves = q.Select(m => new { m.ProductID, m.Quantity, m.MovementType }).ToList();
                var products = db.Product.OrderBy(x => x.ProductID).Select(x => new { x.ProductID, x.ProductName, x.ProductStock }).ToList();
                return products.Select(p =>
                {
                    var mv = moves.Where(m => m.ProductID == p.ProductID).ToList();
                    return new StockReportRow
                    {
                        ProductID = p.ProductID,
                        ProductName = p.ProductName,
                        Stock = p.ProductStock,
                        Imported = mv.Where(m => m.MovementType == "Nhập kho").Sum(m => m.Quantity),
                        Returned = mv.Where(m => m.MovementType == "Hoàn kho").Sum(m => m.Quantity),
                        Sold = -mv.Where(m => m.MovementType == "Bán hàng").Sum(m => m.Quantity),
                        OtherOut = -mv.Where(m => m.MovementType == "Xuất kho").Sum(m => m.Quantity)
                    };
                }).ToList();
            }
        }

        // Lịch sử nhập/xuất gần đây (mới nhất trước).
        public static List<StockMove> RecentMovements(int take, DateTime? from, DateTime? to)
        {
            using (var db = new Db.MyStoreEntities())
            {
                var q = db.StockMovement.AsQueryable();
                if (from.HasValue) { var f = from.Value.Date; q = q.Where(m => m.CreatedAt >= f); }
                if (to.HasValue) { var t = to.Value.Date.AddDays(1); q = q.Where(m => m.CreatedAt < t); }
                var rows = q.OrderByDescending(m => m.MovementID).Take(take).ToList();
                var names = db.Size.ToDictionary(x => x.SizeID, x => x.SizeName);
                var prods = db.Product.ToDictionary(x => x.ProductID, x => x.ProductName);
                return rows.Select(m => new StockMove
                {
                    MovementID = m.MovementID,
                    ProductID = m.ProductID,
                    ProductName = prods.ContainsKey(m.ProductID) ? prods[m.ProductID] : "",
                    Size = names.ContainsKey(m.SizeID) ? names[m.SizeID] : "",
                    Quantity = m.Quantity,
                    Type = m.MovementType,
                    Note = m.Note,
                    OrderID = m.OrderID,
                    CreatedAt = m.CreatedAt,
                    CreatedBy = m.CreatedBy
                }).ToList();
            }
        }

        // Tổng số lượng đã bán của từng sản phẩm (không tính đơn đã hủy) -> dùng cho tiêu chí "Bán chạy".
        private static Dictionary<int, int> SoldCounts(Db.MyStoreEntities db)
        {
            return db.OrderDetail
                .Where(d => d.Order.OrderStatus != "Đã hủy")
                .GroupBy(d => d.ProductID)
                .Select(g => new { Id = g.Key, Qty = g.Sum(x => x.Quantity) })
                .ToList()
                .ToDictionary(x => x.Id, x => x.Qty);
        }

        // Tiêu chí lọc hàng hóa: sale, banchay, moi, conhang, saphet, hethang (rỗng = tất cả).
        public static readonly KeyValuePair<string, string>[] TieuChiKhach =
        {
            new KeyValuePair<string, string>("", "Tất cả sản phẩm"),
            new KeyValuePair<string, string>("sale", "Đang giảm giá (Sale)"),
            new KeyValuePair<string, string>("banchay", "Bán chạy"),
            new KeyValuePair<string, string>("moi", "Hàng mới"),
            new KeyValuePair<string, string>("conhang", "Còn hàng")
        };

        public static readonly KeyValuePair<string, string>[] TieuChiAdmin =
        {
            new KeyValuePair<string, string>("", "Tất cả tiêu chí"),
            new KeyValuePair<string, string>("sale", "Đang giảm giá (Sale)"),
            new KeyValuePair<string, string>("banchay", "Bán chạy"),
            new KeyValuePair<string, string>("moi", "Hàng mới"),
            new KeyValuePair<string, string>("conhang", "Còn hàng"),
            new KeyValuePair<string, string>("saphet", "Sắp hết hàng (≤ 5)"),
            new KeyValuePair<string, string>("hethang", "Hết hàng")
        };

        // true nếu tiêu chí đã tự sắp xếp kết quả (sale: giảm nhiều nhất trước, bán chạy: bán nhiều nhất trước, mới: mới nhất trước).
        public static bool TieuChiTuSapXep(string tieuChi)
        {
            return tieuChi == "sale" || tieuChi == "banchay" || tieuChi == "moi";
        }

        public static IEnumerable<Product> LocTheoTieuChi(IEnumerable<Product> src, string tieuChi)
        {
            switch (tieuChi)
            {
                case "sale": return src.Where(p => p.DiscountPercent > 0).OrderByDescending(p => p.DiscountPercent).ThenBy(p => p.ProductID);
                case "banchay": return src.Where(p => p.Sold > 0).OrderByDescending(p => p.Sold).ThenBy(p => p.ProductID);
                case "moi": return src.OrderByDescending(p => p.ProductID);
                case "conhang": return src.Where(p => p.Stock > 0);
                case "saphet": return src.Where(p => p.Stock > 0 && p.Stock <= 5);
                case "hethang": return src.Where(p => p.Stock == 0);
                default: return src;
            }
        }

        public static Product Find(int id)
        {
            using (var db = new Db.MyStoreEntities())
            {
                var e = db.Product.Include(x => x.Category).FirstOrDefault(x => x.ProductID == id);
                if (e == null) return null;
                var p = ToModel(e);
                List<SizeStock> ss;
                if (SizesByProduct(db).TryGetValue(id, out ss)) { p.Sizes = ss; p.Stock = ss.Sum(x => x.Quantity); }
                return p;
            }
        }

        public static int CountByCategory(int categoryId)
        {
            using (var db = new Db.MyStoreEntities())
            {
                return db.Product.Count(x => x.CategoryID == categoryId);
            }
        }

        // Thêm sản phẩm kèm tồn kho theo từng size (sizes: tên size -> số lượng). Mỗi size có số lượng > 0 ghi một dòng "Nhập kho".
        public static void Add(Product p, Dictionary<string, int> sizes, string by)
        {
            using (var db = new Db.MyStoreEntities())
            {
                var e = new Db.Product
                {
                    CategoryID = p.CategoryID,
                    ProductName = p.NamePro,
                    ProductPrice = p.Price,
                    ProductStock = 0,
                    ProductImage = p.ImagePro,
                    DiscountPercent = p.DiscountPercent
                };
                db.Product.Add(e);
                db.SaveChanges();
                p.ProductID = e.ProductID;

                string err;
                foreach (var kv in sizes.Where(x => x.Value > 0))
                    ChangeSizeStock(db, e.ProductID, kv.Key, kv.Value, "Nhập kho", "Nhập khi thêm sản phẩm", null, by, out err);
                db.SaveChanges();
                p.Stock = e.ProductStock;
            }
        }

        public static bool Update(Product p)
        {
            using (var db = new Db.MyStoreEntities())
            {
                var e = db.Product.Find(p.ProductID);
                if (e == null) return false;
                e.ProductName = p.NamePro;
                e.CategoryID = p.CategoryID;
                e.ProductPrice = p.Price;
                e.ProductImage = p.ImagePro;
                e.DiscountPercent = p.DiscountPercent;
                db.SaveChanges();
                return true;
            }
        }

        // Đặt riêng % giảm giá của một sản phẩm (dùng cho "bán chậm -> sale" ở trang Thống kê).
        public static bool SetDiscount(int id, int percent)
        {
            if (percent < 0) percent = 0;
            if (percent > 90) percent = 90;
            using (var db = new Db.MyStoreEntities())
            {
                var e = db.Product.Find(id);
                if (e == null) return false;
                e.DiscountPercent = percent;
                db.SaveChanges();
                return true;
            }
        }

        public static bool Delete(int id)
        {
            try
            {
                using (var db = new Db.MyStoreEntities())
                {
                    var e = db.Product.Find(id);
                    if (e == null) return false;
                    db.Product.Remove(e);
                    db.SaveChanges();
                    return true;
                }
            }
            catch (DbUpdateException)
            {
                return false;   // sản phẩm đã có trong đơn hàng (khóa ngoại chặn)
            }
        }
    }
}
