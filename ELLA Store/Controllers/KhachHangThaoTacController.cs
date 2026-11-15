using System.Linq;
using System.Web.Mvc;
using ELLA_Store.Filters;
using Db = ELLA_Store.Data;

namespace ELLA_Store.Controllers
{
    // Khóa / mở khóa / xóa tài khoản khách hàng (chỉ Admin). Trang danh sách vẫn là /KhachHang.
    [AdminRequired]
    public class KhachHangThaoTacController : Controller
    {
        // POST: KhachHangThaoTac/Khoa/5
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Khoa(int id) { return DatTrangThai(id, false); }

        // POST: KhachHangThaoTac/MoKhoa/5
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult MoKhoa(int id) { return DatTrangThai(id, true); }

        private ActionResult DatTrangThai(int customerId, bool hoatDong)
        {
            using (var db = new Db.MyStoreEntities())
            {
                var c = db.Customer.Find(customerId);
                var u = (c == null || c.Username == null) ? null : db.User.Find(c.Username);
                if (u == null || LaAdmin(u))
                {
                    TempData["Loi"] = "Không tìm thấy tài khoản khách hàng.";
                    return Redirect("/KhachHang");
                }
                u.IsActive = hoatDong;
                db.SaveChanges();
                TempData["ThongBao"] = (hoatDong ? "Đã mở khóa tài khoản " : "Đã khóa tài khoản ") + u.Username
                    + (hoatDong ? "." : ". Khách sẽ không đăng nhập được nữa.");
            }
            return Redirect("/KhachHang");
        }

        // POST: KhachHangThaoTac/Xoa/5 - chỉ xóa khi khách CHƯA có đơn hàng nào
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Xoa(int id)
        {
            using (var db = new Db.MyStoreEntities())
            {
                var c = db.Customer.Find(id);
                if (c == null)
                {
                    TempData["Loi"] = "Không tìm thấy khách hàng.";
                    return Redirect("/KhachHang");
                }
                if (db.Order.Any(o => o.CustomerID == id))
                {
                    TempData["Loi"] = "Khách \"" + c.CustomerName + "\" đã có đơn hàng nên không thể xóa. Bạn có thể khóa tài khoản thay thế.";
                    return Redirect("/KhachHang");
                }

                string tenDangNhap = c.Username;
                string ten = c.CustomerName;
                db.Customer.Remove(c);
                db.SaveChanges();

                // Xóa luôn tài khoản đăng nhập nếu không còn khách nào dùng và không phải Admin
                if (!string.IsNullOrEmpty(tenDangNhap))
                {
                    var u = db.User.Find(tenDangNhap);
                    if (u != null && !LaAdmin(u) && !db.Customer.Any(x => x.Username == tenDangNhap))
                    {
                        db.User.Remove(u);
                        db.SaveChanges();
                    }
                }
                TempData["ThongBao"] = "Đã xóa khách hàng " + ten + ".";
            }
            return Redirect("/KhachHang");
        }

        private static bool LaAdmin(Db.User u)
        {
            return string.Equals(u.UserRole, "Admin", System.StringComparison.OrdinalIgnoreCase)
                || string.Equals(u.UserRole, "A", System.StringComparison.OrdinalIgnoreCase);
        }
    }
}
