using System;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using ELLA_Store.Filters;
using ELLA_Store.Models;

namespace ELLA_Store.Controllers
{
    // Quản lý hàng hóa (thông tin sản phẩm: tên, danh mục, giá, ảnh). Chỉ Admin.
    // Tồn kho nhập/xuất nằm ở Admin/SanPham (Quản lý kho hàng); cả hai dùng chung ProductStore.
    [AdminRequired]
    public class HangHoaController : Controller
    {
        private static readonly string[] AnhHopLe = { ".jpg", ".jpeg", ".png", ".webp", ".avif", ".gif" };

        // GET: HangHoa?q=...&danhMuc=...
        public ActionResult Index(string q, int? danhMuc)
        {
            var list = ProductStore.All();
            if (!string.IsNullOrWhiteSpace(q))
                list = list.Where(p => p.NamePro.IndexOf(q.Trim(), StringComparison.OrdinalIgnoreCase) >= 0).ToList();
            if (danhMuc.HasValue && danhMuc.Value > 0)
                list = list.Where(p => p.CategoryID == danhMuc.Value).ToList();

            ViewBag.Q = q;
            ViewBag.DanhMuc = danhMuc;
            ViewBag.DanhMucs = CategoryStore.All();
            return View(list);
        }

        // GET: HangHoa/ChiTiet/5 - trang chi tiết (dùng chung partial _ChiTietSanPham)
        public ActionResult ChiTiet(int id)
        {
            var p = ProductStore.Find(id);
            if (p == null) return HttpNotFound();
            ViewBag.DaBan = OrderStore.HasProduct(id);
            return View(p);
        }

        // GET: HangHoa/Them
        public ActionResult Them()
        {
            LoadLists();
            ViewBag.TieuDe = "Thêm hàng hóa";
            return View("Form", new Product());
        }

        // POST: HangHoa/Them
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Them(Product model, HttpPostedFileBase anhTaiLen)
        {
            XuLyAnh(model, anhTaiLen);
            if (!ModelState.IsValid)
            {
                LoadLists();
                ViewBag.TieuDe = "Thêm hàng hóa";
                return View("Form", model);
            }
            ProductStore.Add(model);
            TempData["ThongBao"] = "Đã thêm hàng hóa \"" + model.NamePro + "\".";
            return RedirectToAction("Index");
        }

        // GET: HangHoa/Sua/5
        public ActionResult Sua(int id)
        {
            var p = ProductStore.Find(id);
            if (p == null) return HttpNotFound();
            LoadLists();
            ViewBag.TieuDe = "Sửa hàng hóa";
            return View("Form", p);
        }

        // POST: HangHoa/Sua/5
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Sua(Product model, HttpPostedFileBase anhTaiLen)
        {
            XuLyAnh(model, anhTaiLen);
            if (!ModelState.IsValid)
            {
                LoadLists();
                ViewBag.TieuDe = "Sửa hàng hóa";
                return View("Form", model);
            }
            var cu = ProductStore.Find(model.ProductID);
            if (cu == null) return HttpNotFound();
            model.Stock = cu.Stock;                 // tồn kho chỉ chỉnh ở Quản lý kho hàng
            ProductStore.Update(model);
            TempData["ThongBao"] = "Đã cập nhật hàng hóa \"" + model.NamePro + "\".";
            return RedirectToAction("Index");
        }

        // GET: HangHoa/Xoa/5 - trang xác nhận xóa
        public ActionResult Xoa(int id)
        {
            var p = ProductStore.Find(id);
            if (p == null) return HttpNotFound();
            ViewBag.DaBan = OrderStore.HasProduct(id);
            return View(p);
        }

        // POST: HangHoa/Xoa/5
        [HttpPost]
        [ValidateAntiForgeryToken]
        [ActionName("Xoa")]
        public ActionResult XoaXacNhan(int id)
        {
            var p = ProductStore.Find(id);
            if (p == null) return HttpNotFound();

            if (OrderStore.HasProduct(id))
            {
                TempData["Loi"] = "Không thể xóa \"" + p.NamePro + "\" vì đã phát sinh trong đơn hàng.";
                return RedirectToAction("Index");
            }
            ProductStore.Delete(id);
            TempData["ThongBao"] = "Đã xóa hàng hóa \"" + p.NamePro + "\".";
            return RedirectToAction("Index");
        }

        // ============================ HỖ TRỢ ============================

        // Nếu có tải ảnh lên thì lưu vào Content/image và dùng ảnh đó thay cho ảnh chọn từ danh sách.
        private void XuLyAnh(Product model, HttpPostedFileBase file)
        {
            if (file == null || file.ContentLength == 0) return;

            string ext = Path.GetExtension(file.FileName ?? "").ToLowerInvariant();
            if (!AnhHopLe.Contains(ext))
            {
                ModelState.AddModelError("ImagePro", "Chỉ nhận ảnh .jpg, .png, .webp, .avif, .gif");
                return;
            }
            if (file.ContentLength > 3 * 1024 * 1024)
            {
                ModelState.AddModelError("ImagePro", "Ảnh tối đa 3MB");
                return;
            }

            string dir = Server.MapPath("~/Content/image");
            Directory.CreateDirectory(dir);
            string ten = Guid.NewGuid().ToString("N").Substring(0, 8) + ext;   // tên mới, tránh trùng + tránh ký tự lạ
            file.SaveAs(Path.Combine(dir, ten));

            model.ImagePro = ten;
            ModelState.Remove("ImagePro");          // đã có ảnh -> bỏ lỗi "Required"
        }

        private void LoadLists()
        {
            ViewBag.Brands = CategoryStore.Names();
            string dir = Server.MapPath("~/Content/image");
            ViewBag.Images = Directory.Exists(dir)
                ? Directory.GetFiles(dir).Select(Path.GetFileName).OrderBy(n => n).ToArray()
                : new string[0];
        }
    }
}
