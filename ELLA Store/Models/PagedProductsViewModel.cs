using System.Collections.Generic;

namespace ELLA_Store.Models
{
    // Dữ liệu cho trang danh sách sản phẩm theo hãng (Nike, Adidas, Asics...) có phân trang.
    public class PagedProductsViewModel
    {
        public List<Product> Items { get; set; }

        public string Title { get; set; }            // vd: "Nike"
        public string ActionName { get; set; }       // action của trang, dùng tạo link phân trang (vd: "Nike")

        public int CurrentPage { get; set; }
        public int TotalPages { get; set; }
        public int TotalItems { get; set; }

        public int SelectedCategoryId { get; set; }
        public string SearchTerm { get; set; }
        public decimal? MinPrice { get; set; }
        public decimal? MaxPrice { get; set; }
        public string SortOrder { get; set; }        // "", "price_asc", "price_desc", "name"
    }
}
