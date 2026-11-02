using System;
using System.Linq;
using System.Web.Mvc;
using ELLA_Store.Filters;
using ELLA_Store.Models;

namespace ELLA_Store.Controllers
{
    // Quản lý danh mục (hãng giày). Chỉ Admin. Danh mục ít cột nên không có trang Chi tiết.
    [AdminRequired]
    public class DanhMucController : Controller
    {
        // GET: DanhMuc
        public ActionResult Index()
        {
            ViewBag.SoSanPham = CategoryStore.All().ToDictionary(c => c.CategoryID, c => ProductStore.CountByCategory(c.CategoryID));
            return View(CategoryStore.All());
        }

        // GET: DanhMuc/Them
        public ActionResult Them()
        {
            ViewBag.TieuDe = "Thêm danh mục";
            return View("Form", new Category());
        }

        // POST: DanhMuc/Them
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Them(Category model)
        {
            KiemTraTrung(model);
            if (!ModelState.IsValid)
            {
                ViewBag.TieuDe = "Thêm danh mục";
                return View("Form", model);
            }
            CategoryStore.Add(model);
            TempData["ThongBao"] = "Đã thêm danh mục \"" + model.CategoryName + "\".";
            return RedirectToAction("Index");
        }

        // GET: DanhMuc/Sua/5
        public ActionResult Sua(int id)
        {
            var c = CategoryStore.Find(id);
            if (c == null) return HttpNotFound();
            ViewBag.TieuDe = "Sửa danh mục";
            return View("Form", c);
        }

        // POST: DanhMuc/Sua/5
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Sua(Category model)
        {
            KiemTraTrung(model);
            if (!ModelState.IsValid)
            {
                ViewBag.TieuDe = "Sửa danh mục";
                return View("Form", model);
            }
            if (!CategoryStore.Update(model)) return HttpNotFound();
            TempData["ThongBao"] = "Đã cập nhật danh mục \"" + model.CategoryName + "\".";
            return RedirectToAction("Index");
        }

        // GET: DanhMuc/Xoa/5 - trang xác nhận
        public ActionResult Xoa(int id)
        {
            var c = CategoryStore.Find(id);
            if (c == null) return HttpNotFound();
            ViewBag.SoSanPham = ProductStore.CountByCategory(id);
            return View(c);
        }

        // POST: DanhMuc/Xoa/5 - không xóa danh mục còn sản phẩm
        [HttpPost]
        [ValidateAntiForgeryToken]
        [ActionName("Xoa")]
        public ActionResult XoaXacNhan(int id)
        {
            var c = CategoryStore.Find(id);
            if (c == null) return HttpNotFound();

            int soSp = ProductStore.CountByCategory(id);
            if (soSp > 0)
            {
                TempData["Loi"] = "Không thể xóa \"" + c.CategoryName + "\": còn " + soSp + " hàng hóa thuộc danh mục này.";
                return RedirectToAction("Index");
            }
            CategoryStore.Delete(id);
            TempData["ThongBao"] = "Đã xóa danh mục \"" + c.CategoryName + "\".";
            return RedirectToAction("Index");
        }

        private void KiemTraTrung(Category model)
        {
            if (!string.IsNullOrWhiteSpace(model.CategoryName) && CategoryStore.NameExists(model.CategoryName, model.CategoryID))
                ModelState.AddModelError("CategoryName", "Tên danh mục đã tồn tại");
        }
    }
}
