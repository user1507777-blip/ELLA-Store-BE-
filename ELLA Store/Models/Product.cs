using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace ELLA_Store.Models
{
    // Sản phẩm / hàng hóa. Dùng chung cho Quản lý hàng hóa và Quản lý kho hàng.
    // Ánh xạ bảng Product: NamePro=ProductName, Price=ProductPrice, Stock=ProductStock, ImagePro=ProductImage.
    public class Product
    {
        private string _categoryName;

        public int ProductID { get; set; }

        [Required(ErrorMessage = "Vui lòng nhập tên sản phẩm")]
        [StringLength(200, MinimumLength = 3, ErrorMessage = "Tên từ 3 đến 200 ký tự")]
        [Display(Name = "Tên sản phẩm")]
        public string NamePro { get; set; }

        // Khóa ngoại tới Category.CategoryID (được gán tự động khi chọn CategoryName)
        public int CategoryID { get; set; }

        // Tên danh mục. Form (gửi lên tên hãng) gán vào đây thì CategoryID tự được tra ra.
        [Required(ErrorMessage = "Vui lòng chọn hãng")]
        [Display(Name = "Hãng")]
        public string CategoryName
        {
            get { return _categoryName ?? CategoryStore.NameOf(CategoryID); }
            set { _categoryName = value; CategoryID = CategoryStore.IdOf(value); }
        }

        // Dùng khi đọc từ database (đã có sẵn tên danh mục, khỏi tra lại từng dòng).
        public void SetCategoryCache(string name) { _categoryName = name; }

        [Range(1000, 100000000, ErrorMessage = "Giá phải từ 1.000 đến 100.000.000")]
        [Display(Name = "Giá")]
        public decimal Price { get; set; }

        [Range(0, 100000, ErrorMessage = "Tồn kho phải từ 0 đến 100.000")]
        [Display(Name = "Tồn kho")]
        public int Stock { get; set; }

        [Required(ErrorMessage = "Vui lòng chọn hoặc tải lên ảnh")]
        [Display(Name = "Ảnh")]
        public string ImagePro { get; set; }   // tên file trong Content/image

        // % giảm giá (0 = không sale). Cột Product.DiscountPercent trong database.
        [Range(0, 90, ErrorMessage = "Giảm giá từ 0 đến 90%")]
        [Display(Name = "Giảm giá (%)")]
        public int DiscountPercent { get; set; }

        // Số lượng đã bán (tổng Quantity trong các đơn chưa hủy). Chỉ để lọc "Bán chạy", không lưu trong bảng Product.
        public int Sold { get; set; }
        public bool IsBestSeller { get; set; }      // top bán chạy: tự gắn nhãn BEST SELLER (không lưu DB)

        // Tồn kho theo từng size (bảng trung gian ProductSize). Stock luôn bằng tổng các size.
        public List<SizeStock> Sizes { get; set; }

        public Product() { Sizes = new List<SizeStock>(); }

        public bool IsSale { get { return DiscountPercent > 0; } }

        // Giá bán thực tế sau giảm (làm tròn đến 1.000đ).
        public decimal SalePrice { get { return ComputeSalePrice(Price, DiscountPercent); } }

        public static decimal ComputeSalePrice(decimal price, int discountPercent)
        {
            if (discountPercent <= 0) return price;
            return Math.Round(price * (100 - discountPercent) / 100m / 1000m, MidpointRounding.AwayFromZero) * 1000m;
        }
    }
}

namespace ELLA_Store.Models
{
    // Số lượng tồn của một size.
    public class SizeStock
    {
        public string Size { get; set; }
        public int Quantity { get; set; }
    }

    // Một dòng lịch sử nhập/xuất kho.
    public class StockMove
    {
        public int MovementID { get; set; }
        public int ProductID { get; set; }
        public string ProductName { get; set; }
        public string Size { get; set; }
        public int Quantity { get; set; }          // dương = vào kho, âm = ra khỏi kho
        public string Type { get; set; }           // Nhập kho / Xuất kho / Bán hàng / Hoàn kho
        public string Note { get; set; }
        public int? OrderID { get; set; }
        public DateTime CreatedAt { get; set; }
        public string CreatedBy { get; set; }
    }

    // Một dòng thống kê nhập - xuất của sản phẩm trong khoảng thời gian.
    public class StockReportRow
    {
        public int ProductID { get; set; }
        public string ProductName { get; set; }
        public int Imported { get; set; }          // nhập kho
        public int Returned { get; set; }          // hoàn kho do hủy đơn
        public int Sold { get; set; }              // bán ra (đơn đặt hàng)
        public int OtherOut { get; set; }          // xuất kho khác (hỏng, điều chỉnh...)
        public int Stock { get; set; }             // tồn hiện tại
    }
}
