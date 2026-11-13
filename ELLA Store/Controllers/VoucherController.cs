using System;
using System.Linq;
using System.Web.Mvc;
using ELLA_Store.Filters;
using ELLA_Store.Models;

namespace ELLA_Store.Controllers
{
    // Quản lý voucher (mã giảm giá theo %). Chỉ Admin.
    [AdminRequired]
    public class VoucherController : Controller
    {
        // GET: Voucher
        public ActionResult Index()
        {
            return View(VoucherStore.All());
        }

        // GET: Voucher/Them
        public ActionResult Them()
        {
            ViewBag.TieuDe = "Thêm voucher";
            return View("Form", new Voucher { IsActive = true, DiscountPercent = 10 });
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Them(Voucher model)
        {
            KiemTra(model);
            if (!ModelState.IsValid) { ViewBag.TieuDe = "Thêm voucher"; return View("Form", model); }
            VoucherStore.Add(model);
            TempData["ThongBao"] = "Đã thêm voucher " + model.Code.ToUpper() + ".";
            return RedirectToAction("Index");
        }

        // GET: Voucher/Sua/5
        public ActionResult Sua(int? id)
        {
            if (id == null) return RedirectToAction("Index");
            var v = VoucherStore.Find(id.Value);
            if (v == null) return HttpNotFound();
            ViewBag.TieuDe = "Sửa voucher";
            return View("Form", v);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Sua(Voucher model)
        {
            KiemTra(model);
            if (!ModelState.IsValid) { ViewBag.TieuDe = "Sửa voucher"; return View("Form", model); }
            if (!VoucherStore.Update(model)) return HttpNotFound();
            TempData["ThongBao"] = "Đã cập nhật voucher " + model.Code.ToUpper() + ".";
            return RedirectToAction("Index");
        }

        // POST: Voucher/BatTat/5 - tạm ngưng hoặc bật lại mã
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult BatTat(int id, bool bat)
        {
            if (VoucherStore.SetActive(id, bat))
                TempData["ThongBao"] = bat ? "Đã bật lại voucher." : "Đã tạm ngưng voucher.";
            else
                TempData["Loi"] = "Không tìm thấy voucher.";
            return RedirectToAction("Index");
        }

        // POST: Voucher/Xoa/5
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Xoa(int id)
        {
            if (VoucherStore.Delete(id))
                TempData["ThongBao"] = "Đã xóa voucher. Các đơn đã dùng mã này vẫn giữ nguyên.";
            else
                TempData["Loi"] = "Không tìm thấy voucher.";
            return RedirectToAction("Index");
        }

        private void KiemTra(Voucher v)
        {
            if (!string.IsNullOrWhiteSpace(v.Code) && VoucherStore.CodeExists(v.Code, v.VoucherID))
                ModelState.AddModelError("Code", "Mã voucher này đã tồn tại.");
            if (v.ExpiryDate.HasValue && v.ExpiryDate.Value.Date < DateTime.Today && v.IsActive)
                ModelState.AddModelError("ExpiryDate", "Ngày hết hạn đã qua.");
        }
    }
}
