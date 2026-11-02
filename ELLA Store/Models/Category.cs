using System.ComponentModel.DataAnnotations;

namespace ELLA_Store.Models
{
    // Danh mục sản phẩm (hãng giày): Nike, Adidas, Biti's...
    public class Category
    {
        public int CategoryID { get; set; }

        [Required(ErrorMessage = "Vui lòng nhập tên danh mục")]
        [StringLength(100, MinimumLength = 2, ErrorMessage = "Tên danh mục từ 2 đến 100 ký tự")]
        [Display(Name = "Tên danh mục")]
        public string CategoryName { get; set; }

        [StringLength(250, ErrorMessage = "Mô tả tối đa 250 ký tự")]
        [Display(Name = "Mô tả")]
        public string Description { get; set; }
    }
}
