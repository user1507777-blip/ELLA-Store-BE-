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
        public DateTime CreatedAt { get; set; }
        public List<OrderItem> Items { get; set; }

        public Order() { Items = new List<OrderItem>(); }

        public decimal SubTotal { get { return Items.Sum(i => i.UnitPrice * i.Quantity); } }
        public decimal TotalPrice { get { return SubTotal + ShippingFee; } }
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

    public static class OrderStatus
    {
        public const string ChoXacNhan = "Chờ xác nhận";
        public const string DangGiao = "Đang giao";
        public const string HoanThanh = "Hoàn thành";
        public const string DaHuy = "Đã hủy";

        public static readonly string[] All = { ChoXacNhan, DangGiao, HoanThanh, DaHuy };

        // Các trạng thái được phép chuyển tới từ trạng thái hiện tại.
        public static string[] NextOf(string current)
        {
            switch (current)
            {
                case ChoXacNhan: return new[] { DangGiao, DaHuy };
                case DangGiao: return new[] { HoanThanh, DaHuy };
                default: return new string[0];     // Hoàn thành / Đã hủy là trạng thái cuối
            }
        }

        public static string CssClass(string status)
        {
            switch (status)
            {
                case HoanThanh: return "st-xong";
                case DangGiao: return "st-giao";
                case DaHuy: return "st-huy";
                default: return "st-cho";
            }
        }
    }
}
