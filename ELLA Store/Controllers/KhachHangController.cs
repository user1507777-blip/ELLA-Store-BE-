using System;
using System.Linq;
using System.Web.Mvc;
using ELLA_Store.Filters;
using ELLA_Store.Models;

namespace ELLA_Store.Controllers
{
    // Quản lý khách hàng: chỉ xem danh sách + xem chi tiết (kèm đơn hàng của khách). Chỉ Admin.
    // Không có Thêm/Sửa/Xóa: khách tự đăng ký và tự sửa hồ sơ ở phía cửa hàng.
    [AdminRequired]
    public class KhachHangController : Controller
    {
        // GET: KhachHang?q=...
        public ActionResult Index(string q)
        {
            var rows = UserStore.Customers()
                .Select(c => Build(c))
                .Where(r => r != null);

            if (!string.IsNullOrWhiteSpace(q))
            {
                string k = q.Trim();
                rows = rows.Where(r => (r.FullName ?? "").IndexOf(k, StringComparison.OrdinalIgnoreCase) >= 0
                                    || (r.Phone ?? "").Contains(k)
                                    || (r.Username ?? "").IndexOf(k, StringComparison.OrdinalIgnoreCase) >= 0);
            }
            ViewBag.Q = q;
            return View(rows.ToList());
        }

        // GET: KhachHang/ChiTiet/5 - thông tin khách + đơn hàng của khách.
        // Gọi bằng AJAX (nút "Chi tiết" ở trang danh sách) -> chỉ trả partial _ChiTiet để đổ vào khung;
        // truy cập trực tiếp trên thanh địa chỉ -> trả trang đầy đủ ChiTiet.cshtml (cũng nhúng _ChiTiet).
        public ActionResult ChiTiet(int id)
        {
            var c = UserStore.FindCustomer(id);
            var row = c == null ? null : Build(c);
            if (row == null) return HttpNotFound();
            ViewBag.DonHang = OrderStore.OfCustomer(id);
            if (Request.IsAjaxRequest()) return PartialView("_ChiTiet", row);
            return View(row);
        }

        private CustomerRowViewModel Build(Customer c)
        {
            var u = UserStore.FindUser(c.Username);
            if (u == null) return null;
            return new CustomerRowViewModel
            {
                CustomerID = c.CustomerID,
                Username = u.Username,
                FullName = c.FullName,
                Phone = c.Phone,
                Email = c.Email,
                Address = c.Address,
                IsActive = u.IsActive,
                CreatedAt = u.CreatedAt,
                OrderCount = OrderStore.CountOfCustomer(c.CustomerID)
            };
        }
    }
}
