using System;
using System.ComponentModel.DataAnnotations;

namespace ELLA_Store.Models
{
    // Mã giảm giá theo phần trăm. Admin quản lý ở trang Voucher; khách nhập mã khi đặt hàng;
    // admin cũng có thể chọn mã để áp giảm giá cho sản phẩm (trang Thống kê).
    public class Voucher
    {
        public int VoucherID { get; set; }

        [Required(ErrorMessage = "Vui lòng nhập mã voucher")]
        [RegularExpression(@"^[A-Za-z0-9_-]{3,30}$", ErrorMessage = "Mã gồm 3-30 ký tự: chữ, số, gạch ngang hoặc gạch dưới (không dấu, không khoảng trắng)")]
        public string Code { get; set; }

        [Range(1, 90, ErrorMessage = "Phần trăm giảm từ 1 đến 90")]
        public int DiscountPercent { get; set; }

        [StringLength(200, ErrorMessage = "Mô tả tối đa 200 ký tự")]
        public string Description { get; set; }

        [Range(0, 1000000000, ErrorMessage = "Đơn tối thiểu không hợp lệ")]
        public decimal MinOrder { get; set; }

        [DataType(DataType.Date)]
        public DateTime? ExpiryDate { get; set; }

        public bool IsActive { get; set; }

        // Thống kê sử dụng (không lưu DB): số đơn đã dùng mã (không tính đơn hủy) và tổng tiền đã giảm
        public int UsedCount { get; set; }
        public decimal TotalDiscount { get; set; }

        public bool IsExpired { get { return ExpiryDate.HasValue && ExpiryDate.Value.Date < DateTime.Today; } }
        public bool IsUsable { get { return IsActive && !IsExpired; } }
    }
}
