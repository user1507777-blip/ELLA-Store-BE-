using System;
using System.ComponentModel.DataAnnotations;

namespace ELLA_Store.Models
{
    // Một dòng trong bảng Quản lý người dùng (tài khoản quản trị).
    public class UserRowViewModel
    {
        public string Username { get; set; }
        public string FullName { get; set; }
        public string Email { get; set; }
        public string Phone { get; set; }
        public bool IsActive { get; set; }
        public DateTime CreatedAt { get; set; }
        public bool IsCurrentUser { get; set; }   // chính tài khoản đang đăng nhập
    }

    // Form thêm quản trị viên
    public class AdminCreateViewModel
    {
        [Required(ErrorMessage = "Vui lòng nhập tên đăng nhập")]
        [RegularExpression("^[a-zA-Z0-9]{5,50}$", ErrorMessage = "Tên đăng nhập từ 5 ký tự trở lên, chỉ gồm chữ và số")]
        [Display(Name = "Tên đăng nhập")]
        public string Username { get; set; }

        [Required(ErrorMessage = "Vui lòng nhập họ tên")]
        [StringLength(100, MinimumLength = 3, ErrorMessage = "Họ tên từ 3 đến 100 ký tự")]
        [Display(Name = "Họ và tên")]
        public string FullName { get; set; }

        [EmailAddress(ErrorMessage = "Email không hợp lệ")]
        [StringLength(100, ErrorMessage = "Email tối đa 100 ký tự")]
        public string Email { get; set; }

        [RegularExpression(@"^(0\d{9,10})?$", ErrorMessage = "Số điện thoại gồm 10-11 chữ số, bắt đầu bằng 0")]
        [Display(Name = "Số điện thoại")]
        public string Phone { get; set; }

        [Required(ErrorMessage = "Vui lòng nhập mật khẩu")]
        [StringLength(100, MinimumLength = 8, ErrorMessage = "Mật khẩu tối thiểu 8 ký tự")]
        [DataType(DataType.Password)]
        [Display(Name = "Mật khẩu")]
        public string Password { get; set; }

        [Required(ErrorMessage = "Vui lòng nhập lại mật khẩu")]
        [Compare("Password", ErrorMessage = "Mật khẩu xác nhận chưa trùng khớp")]
        [DataType(DataType.Password)]
        [Display(Name = "Xác nhận mật khẩu")]
        public string ConfirmPassword { get; set; }
    }

    // Form sửa quản trị viên (để trống mật khẩu = giữ nguyên)
    public class AdminEditViewModel
    {
        public string Username { get; set; }

        [Required(ErrorMessage = "Vui lòng nhập họ tên")]
        [StringLength(100, MinimumLength = 3, ErrorMessage = "Họ tên từ 3 đến 100 ký tự")]
        [Display(Name = "Họ và tên")]
        public string FullName { get; set; }

        [EmailAddress(ErrorMessage = "Email không hợp lệ")]
        [StringLength(100, ErrorMessage = "Email tối đa 100 ký tự")]
        public string Email { get; set; }

        [RegularExpression(@"^(0\d{9,10})?$", ErrorMessage = "Số điện thoại gồm 10-11 chữ số, bắt đầu bằng 0")]
        [Display(Name = "Số điện thoại")]
        public string Phone { get; set; }

        [StringLength(100, MinimumLength = 8, ErrorMessage = "Mật khẩu mới tối thiểu 8 ký tự")]
        [DataType(DataType.Password)]
        [Display(Name = "Mật khẩu mới")]
        public string NewPassword { get; set; }

        [Display(Name = "Đang hoạt động")]
        public bool IsActive { get; set; }
    }
}
