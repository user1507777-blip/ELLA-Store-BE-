using System.ComponentModel.DataAnnotations;

namespace ELLA_Store.Models
{
    // Thông tin khách hàng (bảng Customer), gắn với đúng 1 tài khoản User qua Username.
    public class Customer
    {
        public int CustomerID { get; set; }

        [Required, StringLength(100)]
        public string FullName { get; set; }

        [Required, StringLength(15)]
        public string Phone { get; set; }

        [Required(ErrorMessage = "Email không được để trống")]
        [StringLength(100, ErrorMessage = "Email không được dài quá 100 ký tự")]
        [EmailAddress(ErrorMessage = "Địa chỉ email không hợp lệ")]
        [RegularExpression(@"^[a-zA-Z0-9._%+-]+@gmail\.com$", ErrorMessage = "Hệ thống chỉ chấp nhận tài khoản Email định dạng @gmail.com")]
        public string Email { get; set; }

        [Required, StringLength(250)]
        public string Address { get; set; }

        public string Username { get; set; }
    }
}
