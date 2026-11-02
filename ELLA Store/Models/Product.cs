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
    }
}
