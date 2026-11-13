using System;
using System.Collections.Generic;
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
        public ActionResult Index(string q, int? danhMuc, string tieuChi)
        {
            var list = ProductStore.All();
            if (!string.IsNullOrWhiteSpace(q))
                list = list.Where(p => p.NamePro.IndexOf(q.Trim(), StringComparison.OrdinalIgnoreCase) >= 0).ToList();
            if (danhMuc.HasValue && danhMuc.Value > 0)
                list = list.Where(p => p.CategoryID == danhMuc.Value).ToList();

            // Tiêu chí: sale, banchay, moi, conhang, saphet, hethang
            list = ProductStore.LocTheoTieuChi(list, tieuChi).ToList();

            ViewBag.Q = q;
            ViewBag.TieuChi = tieuChi;
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
            ProductStore.Add(model, DocTonTheoSize(), (string)Session["Username"]);
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
            // Nhập thêm hàng: ô "them_<size>" = số lượng cộng thêm vào tồn của size đó (ghi lịch sử "Nhập kho")
            var nhap = new System.Collections.Generic.List<KeyValuePair<string, int>>();
            foreach (var sz in ProductStore.AllSizeNames())
            {
                string raw = (Request.Form["them_" + sz] ?? "").Trim();
                if (raw.Length == 0) continue;
                int n;
                if (!int.TryParse(raw, out n) || n < 0 || n > 100000)
                    ModelState.AddModelError("", "Số lượng nhập thêm cho size " + sz + " phải từ 0 đến 100.000.");
                else if (n > 0) nhap.Add(new KeyValuePair<string, int>(sz, n));
            }
            if (!ModelState.IsValid)
            {
                LoadLists();
                ViewBag.TieuDe = "Sửa hàng hóa";
                model.Sizes = cu.Sizes;
                return View("Form", model);
            }
            model.Stock = cu.Stock;                 // tồn kho chỉ đổi bằng cách nhập thêm ở các ô size bên dưới
            ProductStore.Update(model);
            int tongNhap = 0;
            foreach (var kv in nhap)
            {
                string loiKho;
                if (ProductStore.AdjustSize(model.ProductID, kv.Key, kv.Value, "Nhập kho", "Nhập thêm khi sửa hàng hóa", (string)Session["Username"], out loiKho))
                    tongNhap += kv.Value;
                else
                    TempData["Loi"] = loiKho;
            }
            TempData["ThongBao"] = "Đã cập nhật hàng hóa \"" + model.NamePro + "\"" + (tongNhap > 0 ? " và nhập thêm " + tongNhap + " đôi." : ".");
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

            // Đang nằm trong đơn chưa kết thúc (khách đã đặt, chưa giao xong) -> không được xóa
            int donDangXuLy = OrderStore.ActiveOrderOfProduct(id);
            if (donDangXuLy > 0)
            {
                TempData["Loi"] = "Không thể xóa \"" + p.NamePro + "\": sản phẩm đang có trong đơn hàng #" + donDangXuLy + " chưa hoàn tất.";
                return RedirectToAction("Index");
            }
            // Đã từng được bán (có trong lịch sử đơn) -> không được xóa để giữ dữ liệu đơn hàng
            if (OrderStore.HasProduct(id))
            {
                TempData["Loi"] = "Không thể xóa \"" + p.NamePro + "\": sản phẩm đã phát sinh trong đơn hàng.";
                return RedirectToAction("Index");
            }
            if (!ProductStore.Delete(id))
            {
                TempData["Loi"] = "Không thể xóa \"" + p.NamePro + "\": sản phẩm đang được dữ liệu khác sử dụng.";
                return RedirectToAction("Index");
            }
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

        // Đọc ô nhập số lượng từng size trên form thêm hàng hóa (tên ô: sl_38, sl_39, ...).
        private Dictionary<string, int> DocTonTheoSize()
        {
            var kq = new Dictionary<string, int>();
            foreach (var size in ProductStore.AllSizeNames())
            {
                int n;
                if (int.TryParse(Request.Form["sl_" + size], out n) && n > 0)
                {
                    if (n > 100000) n = 100000;
                    kq[size] = n;
                }
            }
            return kq;
        }

        private void LoadLists()
        {
            ViewBag.Sizes = ProductStore.AllSizeNames();
            ViewBag.Brands = CategoryStore.Names();
            string dir = Server.MapPath("~/Content/image");
            ViewBag.Images = Directory.Exists(dir)
                ? Directory.GetFiles(dir).Select(Path.GetFileName).OrderBy(n => n).ToArray()
                : new string[0];
        }
    }
}
