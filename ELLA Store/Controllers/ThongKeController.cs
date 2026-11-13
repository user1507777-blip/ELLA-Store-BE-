using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;
using ELLA_Store.Filters;
using ELLA_Store.Models;

namespace ELLA_Store.Models
{
    public class DoanhThuNgay { public DateTime Ngay { get; set; } public int SoDon { get; set; } public decimal DoanhThu { get; set; } }
    public class DoanhThuHang { public string Hang { get; set; } public int SoLuong { get; set; } public decimal DoanhThu { get; set; } }
    public class SanPhamBanChay { public int ProductID { get; set; } public string Ten { get; set; } public int SoLuong { get; set; } public decimal DoanhThu { get; set; } }

    public class ThongKeViewModel
    {
        public DateTime Tu { get; set; }
        public DateTime Den { get; set; }
        public decimal TongDoanhThu { get; set; }
        public int SoDonHoanThanh { get; set; }
        public decimal TrungBinhMoiDon { get; set; }
        public int SoDonHuy { get; set; }
        public decimal TienHoan { get; set; }              // đơn hủy đã thanh toán trước (chờ hoàn + đã hoàn)
        public List<DoanhThuNgay> TheoNgay { get; set; }
        public List<DoanhThuHang> TheoHang { get; set; }
        public List<SanPhamBanChay> TopSanPham { get; set; }
        public List<Product> BestSeller { get; set; }       // sản phẩm đang có nhãn BEST SELLER
        public List<Product> BanCham { get; set; }          // bán chậm: gợi ý đưa vào sale
    }
}

namespace ELLA_Store.Controllers
{
    // Thống kê doanh thu cho Admin. Doanh thu = tổng tiền các đơn đã HOÀN THÀNH (gồm phí vận chuyển), không tính đơn đã hủy.
    [AdminRequired]
    public class ThongKeController : Controller
    {
        // GET: ThongKe?tu=...&den=...  (mặc định 30 ngày gần nhất)
        public ActionResult Index(DateTime? tu, DateTime? den)
        {
            DateTime d2 = (den ?? DateTime.Today).Date;
            DateTime d1 = (tu ?? d2.AddDays(-29)).Date;
            if (d1 > d2) { var t = d1; d1 = d2; d2 = t; }
            if ((d2 - d1).TotalDays > 365) d1 = d2.AddDays(-365);          // tối đa 1 năm cho bảng theo ngày

            DateTime ketThuc = d2.AddDays(1);
            var donTrongKy = OrderStore.All().Where(o => o.CreatedAt >= d1 && o.CreatedAt < ketThuc).ToList();
            var xong = donTrongKy.Where(o => o.Status == OrderStatus.HoanThanh).ToList();
            var huy = donTrongKy.Where(o => o.Status == OrderStatus.DaHuy).ToList();

            var hangCuaSp = ProductStore.All().ToDictionary(p => p.ProductID, p => p.CategoryName);

            var vm = new ThongKeViewModel
            {
                Tu = d1,
                Den = d2,
                SoDonHoanThanh = xong.Count,
                TongDoanhThu = xong.Sum(o => o.TotalPrice),
                SoDonHuy = huy.Count,
                TienHoan = huy.Where(o => o.PaymentStatus == PayStatus.ChoHoanTien || o.PaymentStatus == PayStatus.DaHoanTien)
                              .Sum(o => o.TotalPrice)
            };
            vm.TrungBinhMoiDon = xong.Count == 0 ? 0 : vm.TongDoanhThu / xong.Count;

            // Theo ngày: đủ từng ngày trong khoảng (ngày không có đơn hiện 0)
            vm.TheoNgay = new List<DoanhThuNgay>();
            for (DateTime d = d2; d >= d1; d = d.AddDays(-1))
            {
                var trongNgay = xong.Where(o => o.CreatedAt.Date == d).ToList();
                vm.TheoNgay.Add(new DoanhThuNgay { Ngay = d, SoDon = trongNgay.Count, DoanhThu = trongNgay.Sum(o => o.TotalPrice) });
            }

            // Theo hãng giày và top sản phẩm (tính trên tiền hàng, chưa gồm phí vận chuyển)
            var dong = xong.SelectMany(o => o.Items).ToList();
            vm.TheoHang = dong
                .GroupBy(i => hangCuaSp.ContainsKey(i.ProductID) ? hangCuaSp[i.ProductID] : "Khác")
                .Select(g => new DoanhThuHang { Hang = g.Key, SoLuong = g.Sum(i => i.Quantity), DoanhThu = g.Sum(i => i.LineTotal) })
                .OrderByDescending(x => x.DoanhThu).ToList();
            vm.TopSanPham = dong
                .GroupBy(i => i.ProductID)
                .Select(g => new SanPhamBanChay { ProductID = g.Key, Ten = g.First().ProductName, SoLuong = g.Sum(i => i.Quantity), DoanhThu = g.Sum(i => i.LineTotal) })
                .OrderByDescending(x => x.SoLuong).ThenByDescending(x => x.DoanhThu).Take(5).ToList();

            // Toàn thời gian (cùng cách tính với nhãn BEST SELLER ở trang khách)
            var tatCa = ProductStore.All();
            vm.BestSeller = tatCa.Where(p => p.IsBestSeller).OrderByDescending(p => p.Sold).ToList();
            // Bán chậm: còn hàng, ít người mua nhất, chưa phải best seller
            vm.BanCham = tatCa.Where(p => p.Stock > 0 && !p.IsBestSeller)
                              .OrderBy(p => p.Sold).ThenByDescending(p => p.Stock).Take(5).ToList();

            ViewBag.Vouchers = VoucherStore.All();
            return View(vm);
        }

        // POST: ThongKe/ApDungSale - áp voucher (giảm theo %) cho sản phẩm bán chậm; bấm "Bỏ sale" để gỡ giảm giá
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult ApDungSale(int id, int? voucherId, string boSale, string tu, string den)
        {
            if (boSale != null)
            {
                if (ProductStore.SetDiscount(id, 0)) TempData["ThongBao"] = "Đã bỏ giảm giá cho sản phẩm.";
                else TempData["Loi"] = "Không tìm thấy sản phẩm.";
            }
            else
            {
                var v = voucherId.HasValue ? VoucherStore.Find(voucherId.Value) : null;
                if (v == null) TempData["Loi"] = "Vui lòng chọn một voucher.";
                else if (!v.IsUsable) TempData["Loi"] = "Voucher " + v.Code + " đang tạm ngưng hoặc đã hết hạn.";
                else if (ProductStore.SetDiscount(id, v.DiscountPercent))
                    TempData["ThongBao"] = "Đã áp voucher " + v.Code + " (giảm " + v.DiscountPercent + "%) cho sản phẩm.";
                else TempData["Loi"] = "Không tìm thấy sản phẩm.";
            }
            return RedirectToAction("Index", new { tu = tu, den = den });
        }
    }
}
