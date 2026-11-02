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
                ImagePro = e.ProductImage
            };
            if (e.Category != null) p.SetCategoryCache(e.Category.CategoryName);
            return p;
        }

        public static List<Product> All()
        {
            using (var db = new Db.MyStoreEntities())
            {
                return db.Product.Include(x => x.Category).OrderBy(x => x.ProductID).ToList().Select(x => ToModel(x)).ToList();
            }
        }

        public static Product Find(int id)
        {
            using (var db = new Db.MyStoreEntities())
            {
                var e = db.Product.Include(x => x.Category).FirstOrDefault(x => x.ProductID == id);
                return e == null ? null : ToModel(e);
            }
        }

        public static int CountByCategory(int categoryId)
        {
            using (var db = new Db.MyStoreEntities())
            {
                return db.Product.Count(x => x.CategoryID == categoryId);
            }
        }

        public static void Add(Product p)
        {
            using (var db = new Db.MyStoreEntities())
            {
                var e = new Db.Product
                {
                    CategoryID = p.CategoryID,
                    ProductName = p.NamePro,
                    ProductPrice = p.Price,
                    ProductStock = p.Stock,
                    ProductImage = p.ImagePro
                };
                db.Product.Add(e);
                db.SaveChanges();
                p.ProductID = e.ProductID;
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
                e.ProductStock = p.Stock;
                e.ProductImage = p.ImagePro;
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

        // Nhập kho (delta > 0) hoặc xuất/điều chỉnh giảm (delta < 0). Tồn kho không được âm.
        public static bool AdjustStock(int id, int delta)
        {
            using (var db = new Db.MyStoreEntities())
            {
                var e = db.Product.Find(id);
                if (e == null || e.ProductStock + delta < 0) return false;
                e.ProductStock += delta;
                db.SaveChanges();
                return true;
            }
        }
    }
}
