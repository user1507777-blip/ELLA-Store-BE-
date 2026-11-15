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

        // GET: Admin/SanPham?q=...&tu=...&den=... - kho hàng theo size + thống kê nhập/xuất
        public ActionResult SanPham(string q, DateTime? tu, DateTime? den, string sx)
        {
            var list = ProductStore.All();
            if (!string.IsNullOrWhiteSpace(q))
                list = list.Where(p => p.NamePro.IndexOf(q.Trim(), StringComparison.OrdinalIgnoreCase) >= 0).ToList();

            // Sắp xếp: hang (mặc định) = theo hãng rồi A-Z | moi = mới nhất | az = A-Z | ton = tồn ít nhất | id = ID tăng dần | iddesc = ID giảm dần
            switch (sx)
            {
                case "id": list = list.OrderBy(p => p.ProductID).ToList(); break;
                case "iddesc": list = list.OrderByDescending(p => p.ProductID).ToList(); break;
                case "moi": list = list.OrderByDescending(p => p.ProductID).ToList(); break;
                case "az": list = list.OrderBy(p => p.NamePro, StringComparer.CurrentCultureIgnoreCase).ToList(); break;
                case "ton": list = list.OrderBy(p => p.Stock).ThenBy(p => p.NamePro, StringComparer.CurrentCultureIgnoreCase).ToList(); break;
                default:
                    sx = "hang";
                    list = list.OrderBy(p => p.CategoryName, StringComparer.CurrentCultureIgnoreCase)
                               .ThenBy(p => p.NamePro, StringComparer.CurrentCultureIgnoreCase).ToList();
                    break;
            }

            ViewBag.Sx = sx;
            ViewBag.Q = q;
            ViewBag.Tu = tu;
            ViewBag.Den = den;
            ViewBag.HangTon = list.Where(p => p.Stock > 0).ToList();
            ViewBag.CanNhap = list.Where(p => p.Stock == 0).ToList();
            ViewBag.TongTon = list.Sum(p => p.Stock);
            ViewBag.SapHet = list.Count(p => p.Stock > 0 && p.Stock < 5);
            ViewBag.Sizes = ProductStore.AllSizeNames();

            // Thống kê nhập - xuất trong khoảng ngày (mặc định: toàn bộ thời gian)
            var bc = ProductStore.MovementReport(tu, den).Where(r => r.Imported + r.Returned + r.Sold + r.OtherOut > 0).ToList();
            ViewBag.BaoCao = bc;
            ViewBag.TongNhap = bc.Sum(r => r.Imported);
            ViewBag.TongHoan = bc.Sum(r => r.Returned);
            ViewBag.TongBan = bc.Sum(r => r.Sold);
            ViewBag.TongXuatKhac = bc.Sum(r => r.OtherOut);
            ViewBag.LichSu = ProductStore.RecentMovements(30, tu, den);
            return View();
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
                IsCurrentUser = u.Username == me,
                IsProtected = UserStore.IsProtectedAdmin(u.Username)
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

            if (UserStore.IsProtectedAdmin(model.Username) && !model.IsActive)
                ModelState.AddModelError("IsActive", "Không thể khóa tài khoản admin gốc của hệ thống");
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

            if (UserStore.IsProtectedAdmin(id))
                TempData["Loi"] = "Không được xóa tài khoản admin gốc của hệ thống.";
            else if (id == (string)Session["Username"])
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
