using System;
using System.Collections.Generic;
using System.Data.Entity.Infrastructure;
using System.Linq;
using Db = ELLA_Store.Data;

namespace ELLA_Store.Models
{
    // Đọc/ghi bảng Category trong database MyStore (qua Entity Framework).
    public static class CategoryStore
    {
        private static Category ToModel(Db.Category e)
        {
            return new Category { CategoryID = e.CategoryID, CategoryName = e.CategoryName, Description = e.Description };
        }

        public static List<Category> All()
        {
            using (var db = new Db.MyStoreEntities())
            {
                return db.Category.OrderBy(c => c.CategoryName).ToList().Select(x => ToModel(x)).ToList();
            }
        }

        public static Category Find(int id)
        {
            using (var db = new Db.MyStoreEntities())
            {
                var e = db.Category.Find(id);
                return e == null ? null : ToModel(e);
            }
        }

        // Tên danh mục theo ID (null nếu không có)
        public static string NameOf(int id)
        {
            using (var db = new Db.MyStoreEntities())
            {
                var e = db.Category.Find(id);
                return e == null ? null : e.CategoryName;
            }
        }

        // ID danh mục theo tên (0 nếu không có)
        public static int IdOf(string name)
        {
            if (string.IsNullOrEmpty(name)) return 0;
            using (var db = new Db.MyStoreEntities())
            {
                string n = name.Trim();
                var e = db.Category.FirstOrDefault(c => c.CategoryName == n);
                return e == null ? 0 : e.CategoryID;
            }
        }

        public static string[] Names()
        {
            return All().Select(c => c.CategoryName).ToArray();
        }

        public static bool NameExists(string name, int exceptId)
        {
            if (string.IsNullOrWhiteSpace(name)) return false;
            string n = name.Trim();
            using (var db = new Db.MyStoreEntities())
            {
                return db.Category.Any(c => c.CategoryID != exceptId && c.CategoryName == n);
            }
        }

        public static void Add(Category c)
        {
            using (var db = new Db.MyStoreEntities())
            {
                var e = new Db.Category { CategoryName = c.CategoryName.Trim(), Description = c.Description };
                db.Category.Add(e);
                db.SaveChanges();
                c.CategoryID = e.CategoryID;
            }
        }

        public static bool Update(Category c)
        {
            using (var db = new Db.MyStoreEntities())
            {
                var e = db.Category.Find(c.CategoryID);
                if (e == null) return false;
                e.CategoryName = c.CategoryName.Trim();
                e.Description = c.Description;
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
                    var e = db.Category.Find(id);
                    if (e == null) return false;
                    db.Category.Remove(e);
                    db.SaveChanges();
                    return true;
                }
            }
            catch (DbUpdateException)
            {
                return false;   // còn sản phẩm thuộc danh mục (khóa ngoại chặn)
            }
        }
    }
}
