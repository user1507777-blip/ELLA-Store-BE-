using System;
using System.Linq;
using System.Web.Mvc;
using ELLA_Store.Filters;
using ELLA_Store.Helpers;
using ELLA_Store.Models;

namespace ELLA_Store.Controllers
{
    // Khu quản trị: Quản lý kho hàng + Quản lý người dùng (chỉ Admin).
    [AdminRequired]
    public class AdminController : Controller
    {
        // ======================= QUẢN LÝ KHO HÀNG =======================

        // GET: Admin/SanPham?q=... - thống kê 2 phần: hàng tồn (tồn > 0) và hàng cần nhập (tồn = 0)
        public ActionResult SanPham(string q)
        {
            var list = ProductStore.All();
            if (!string.IsNullOrWhiteSpace(q))
                list = list.Where(p => p.NamePro.IndexOf(q.Trim(), StringComparison.OrdinalIgnoreCase) >= 0).ToList();

            ViewBag.Q = q;
            ViewBag.HangTon = list.Where(p => p.Stock > 0).ToList();
            ViewBag.CanNhap = list.Where(p => p.Stock == 0).ToList();
            ViewBag.TongTon = list.Sum(p => p.Stock);
            ViewBag.SapHet = list.Count(p => p.Stock > 0 && p.Stock < 5);
            return View();
        }

        // POST: Admin/DieuChinhKho - soLuong > 0: nhập kho, soLuong < 0: xuất/giảm kho
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult DieuChinhKho(int id, int? soLuong)
        {
            // soLuong để trống (null) hoặc bằng 0 thì báo lỗi, không để văng exception
            if (!soLuong.HasValue || soLuong.Value == 0)
            {
                TempData["Loi"] = "Vui lòng nhập số lượng khác 0.";
            }
            else if (ProductStore.AdjustStock(id, soLuong.Value))
            {
                var p = ProductStore.Find(id);
                TempData["ThongBao"] = (soLuong.Value > 0 ? "Nhập kho +" : "Xuất kho ") + soLuong.Value
                                     + " cho \"" + p.NamePro + "\". Tồn hiện tại: " + p.Stock + ".";
            }
            else
            {
                TempData["Loi"] = "Không thể điều chỉnh: sản phẩm không tồn tại hoặc tồn kho sẽ bị âm.";
            }
            return RedirectToAction("SanPham");
        }

        // ===================== QUẢN LÝ NGƯỜI DÙNG (quản trị viên) =====================

        // GET: Admin/NguoiDung - chỉ liệt kê tài khoản quản trị
        public ActionResult NguoiDung()
        {
            string me = (string)Session["Username"];
            var rows = UserStore.Admins().Select(u => new UserRowViewModel
            {
                Username = u.Username,
                FullName = u.FullName,
                Email = u.Email,
                Phone = u.Phone,
                IsActive = u.IsActive,
                CreatedAt = u.CreatedAt,
                IsCurrentUser = u.Username == me
            }).ToList();
            return View(rows);
        }

        // GET: Admin/ThemQuanTri
        public ActionResult ThemQuanTri()
        {
            return View(new AdminCreateViewModel());
        }

        // POST: Admin/ThemQuanTri
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult ThemQuanTri(AdminCreateViewModel model)
        {
            if (!string.IsNullOrEmpty(model.Username) && UserStore.UsernameExists(model.Username))
                ModelState.AddModelError("Username", "Tên đăng nhập đã tồn tại");
            if (!ModelState.IsValid) return View(model);

            UserStore.AddAdmin(new User
            {
                Username = model.Username,
                PasswordHash = PasswordHasher.Hash(model.Password),
                Role = "Admin",
                IsActive = true,
                FullName = model.FullName,
                Email = string.IsNullOrWhiteSpace(model.Email) ? null : model.Email.Trim(),
                Phone = string.IsNullOrWhiteSpace(model.Phone) ? null : model.Phone.Trim()
            });
            TempData["ThongBao"] = "Đã thêm quản trị viên " + model.Username + ".";
            return RedirectToAction("NguoiDung");
        }

        // GET: Admin/SuaQuanTri/tendangnhap
        public ActionResult SuaQuanTri(string id)
        {
            var u = UserStore.FindUser(id);
            if (u == null || u.Role != "Admin") return HttpNotFound();
            return View(new AdminEditViewModel
            {
                Username = u.Username,
                FullName = u.FullName,
                Email = u.Email,
                Phone = u.Phone,
                IsActive = u.IsActive
            });
        }

        // POST: Admin/SuaQuanTri
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult SuaQuanTri(AdminEditViewModel model)
        {
            var u = UserStore.FindUser(model.Username);
            if (u == null || u.Role != "Admin") return HttpNotFound();

            if (model.Username == (string)Session["Username"] && !model.IsActive)
                ModelState.AddModelError("IsActive", "Bạn không thể tự khóa tài khoản đang đăng nhập");
            if (!ModelState.IsValid) return View(model);

            string hash = string.IsNullOrEmpty(model.NewPassword) ? null : PasswordHasher.Hash(model.NewPassword);
            UserStore.UpdateUser(
                u.Username,
                model.FullName,
                string.IsNullOrWhiteSpace(model.Email) ? null : model.Email.Trim(),
                string.IsNullOrWhiteSpace(model.Phone) ? null : model.Phone.Trim(),
                model.IsActive,
                hash);
            TempData["ThongBao"] = "Đã cập nhật quản trị viên " + u.Username + ".";
            return RedirectToAction("NguoiDung");
        }

        // POST: Admin/XoaNguoiDung - xóa tài khoản quản trị
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult XoaNguoiDung(string id)
        {
            var u = UserStore.FindUser(id);
            if (u == null || u.Role != "Admin") return HttpNotFound();

            if (id == (string)Session["Username"])
                TempData["Loi"] = "Bạn không thể tự xóa tài khoản đang đăng nhập.";
            else if (UserStore.CountAdmins() <= 1)
                TempData["Loi"] = "Không thể xóa quản trị viên cuối cùng.";
            else if (UserStore.Remove(id))
                TempData["ThongBao"] = "Đã xóa quản trị viên " + id + ".";
            else
                TempData["Loi"] = "Không xóa được tài khoản " + id + ".";
            return RedirectToAction("NguoiDung");
        }
    }
}
