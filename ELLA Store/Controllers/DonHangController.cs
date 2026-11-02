using System;
using System.Linq;
using System.Web.Mvc;
using ELLA_Store.Filters;
using ELLA_Store.Models;

namespace ELLA_Store.Controllers
{
    // Quản lý đơn hàng: xem, lọc theo trạng thái, đổi trạng thái theo quy trình. Chỉ Admin.
    // Không có Thêm/Sửa/Xóa: đơn do khách đặt, admin chỉ xử lý; đơn sai thì chuyển "Đã hủy".
    [AdminRequired]
    public class DonHangController : Controller
    {
        // GET: DonHang?trangThai=...&q=...
        public ActionResult Index(string trangThai, string q)
        {
            var list = OrderStore.All();
            if (!string.IsNullOrEmpty(trangThai))
                list = list.Where(o => o.Status == trangThai).ToList();
            if (!string.IsNullOrWhiteSpace(q))
            {
                string k = q.Trim();
                list = list.Where(o => o.Receiver.IndexOf(k, StringComparison.OrdinalIgnoreCase) >= 0
                                    || o.Phone.Contains(k)
                                    || o.OrderID.ToString() == k).ToList();
            }
            ViewBag.TrangThai = trangThai;
            ViewBag.Q = q;
            var tatCa = OrderStore.All();
            ViewBag.DoanhThu = tatCa.Where(o => o.Status == OrderStatus.HoanThanh).Sum(o => o.TotalPrice);
            ViewBag.DemTheoTrangThai = OrderStatus.All.ToDictionary(s => s, s => tatCa.Count(o => o.Status == s));
            return View(list);
        }

        // GET: DonHang/ChiTiet/5
        public ActionResult ChiTiet(int? id)
        {
            // Chặn trường hợp không có id trên URL
            if (id == null)
            {
                TempData["Loi"] = "Mã đơn hàng không hợp lệ hoặc không tồn tại.";
                return RedirectToAction("Index");
            }
            var o = OrderStore.Find(id.Value);
            // Gõ bừa id không có trong CSDL thì quay về danh sách
            if (o == null)
            {
                TempData["Loi"] = "Đơn hàng không tồn tại trên hệ thống.";
                return RedirectToAction("Index");
            }
            return View(o);
        }

        // POST: DonHang/DoiTrangThai
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult DoiTrangThai(int id, string trangThaiMoi)
        {
            string loi;
            if (OrderStore.ChangeStatus(id, trangThaiMoi, out loi))
                TempData["ThongBao"] = "Đơn #" + id + " đã chuyển sang \"" + trangThaiMoi + "\"."
                                     + (trangThaiMoi == OrderStatus.DaHuy ? " Tồn kho đã được hoàn lại." : "");
            else
                TempData["Loi"] = loi;
            return RedirectToAction("ChiTiet", new { id });
        }

        // Danh sách mã voucher hợp lệ: mã -> số tiền giảm (VNĐ)
        private static readonly System.Collections.Generic.Dictionary<string, decimal> DanhSachVoucher =
            new System.Collections.Generic.Dictionary<string, decimal>(StringComparer.OrdinalIgnoreCase)
            {
                { "GIAMGIA50K", 50000m },
                { "GIAMGIA100K", 100000m }
            };

        // POST: DonHang/ApDungVoucher
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult ApDungVoucher(string voucherCode)
        {
            string ma = (voucherCode ?? "").Trim();
            decimal giam;
            if (ma.Length > 0 && DanhSachVoucher.TryGetValue(ma, out giam))
            {
                Session["VoucherCode"] = ma.ToUpper();
                Session["DiscountAmount"] = giam;
                TempData["ThongBao"] = "Áp dụng mã giảm giá thành công!";
            }
            else
            {
                TempData["Loi"] = "Mã voucher không hợp lệ!";
            }
            return RedirectToAction("Index");
        }

        // POST: DonHang/HuyVoucher
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult HuyVoucher()
        {
            Session.Remove("VoucherCode");
            Session.Remove("DiscountAmount");
            TempData["ThongBao"] = "Đã bỏ mã giảm giá.";
            return RedirectToAction("Index");
        }
    }
}
