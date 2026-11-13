using System;
using System.Collections.Generic;
using System.Linq;

namespace ELLA_Store.Models
{
    // Đơn hàng. Tổng tiền được tính từ các dòng hàng + phí vận chuyển (không lưu riêng).
    public class Order
    {
        public int OrderID { get; set; }
        public int? CustomerID { get; set; }          // null = khách chưa đăng nhập
        public string Receiver { get; set; }
        public string Phone { get; set; }
        public string Email { get; set; }
        public string Address { get; set; }
        public string PaymentMethod { get; set; }     // "COD" hoặc "Chuyển khoản"
        public decimal ShippingFee { get; set; }
        public string Status { get; set; }
        public string PaymentStatus { get; set; }     // Chưa thanh toán / Đã thanh toán / Chờ hoàn tiền / Đã hoàn tiền
        public DateTime CreatedAt { get; set; }
        public string VoucherCode { get; set; }        // mã giảm giá khách đã dùng (null = không dùng)
        public decimal DiscountAmount { get; set; }    // số tiền được giảm nhờ voucher
        public List<OrderItem> Items { get; set; }

        public Order() { Items = new List<OrderItem>(); }

        public decimal SubTotal { get { return Items.Sum(i => i.UnitPrice * i.Quantity); } }
        public decimal TotalPrice { get { return SubTotal - DiscountAmount + ShippingFee; } }
    }

    // Một dòng hàng trong đơn: lưu lại tên và giá tại thời điểm đặt.
    public class OrderItem
    {
        public int OrderItemID { get; set; }
        public int OrderID { get; set; }
        public int ProductID { get; set; }
        public string ProductName { get; set; }
        public string Size { get; set; }
        public int Quantity { get; set; }
        public decimal UnitPrice { get; set; }

        public decimal LineTotal { get { return UnitPrice * Quantity; } }
    }

    // Trạng thái xử lý đơn hàng. Danh sách có thứ tự; admin được chọn bất kỳ trạng thái nào phía sau trạng thái hiện tại
    // (hoặc Đã hủy). Hoàn thành và Đã hủy là trạng thái kết thúc: sau đó không đổi được nữa.
    public static class OrderStatus
    {
        public const string ChoXacNhan = "Chờ xác nhận";
        public const string DaXacNhan = "Đã xác nhận";
        public const string DangGiao = "Đang giao";
        public const string HoanThanh = "Hoàn thành";
        public const string DaHuy = "Đã hủy";

        public static readonly string[] All = { ChoXacNhan, DaXacNhan, DangGiao, HoanThanh, DaHuy };

        public static bool IsFinal(string status)
        {
            return status == HoanThanh || status == DaHuy;
        }

        // Các trạng thái được phép chuyển tới từ trạng thái hiện tại.
        public static string[] NextOf(string current)
        {
            if (IsFinal(current)) return new string[0];     // trạng thái kết thúc: không đổi nữa
            int i = System.Array.IndexOf(All, current);
            var list = new System.Collections.Generic.List<string>();
            for (int k = i + 1; k < All.Length; k++) list.Add(All[k]);   // các bước phía sau (kể cả Hoàn thành, Đã hủy)
            return list.ToArray();
        }

        public static string CssClass(string status)
        {
            switch (status)
            {
                case HoanThanh: return "st-xong";
                case DangGiao:
                case DaXacNhan: return "st-giao";
                case DaHuy: return "st-huy";
                default: return "st-cho";
            }
        }
    }

    // Trạng thái thanh toán của đơn (cột Order.PaymentStatus).
    public static class PayStatus
    {
        public const string ChuaThanhToan = "Chưa thanh toán";
        public const string DaThanhToan = "Đã thanh toán";
        public const string ChoHoanTien = "Chờ hoàn tiền";
        public const string DaHoanTien = "Đã hoàn tiền";

        public static string CssClass(string s)
        {
            switch (s)
            {
                case DaThanhToan: return "st-xong";
                case ChoHoanTien: return "st-huy";
                case DaHoanTien: return "st-giao";
                default: return "st-cho";
            }
        }
    }
}
