using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text.RegularExpressions;

namespace ELLA_Store.Models
{
    public class RegisterViewModel
    {
        [Required(ErrorMessage = "Vui lòng nhập tên đăng nhập")]
        [RegularExpression("^[a-zA-Z][a-zA-Z0-9]{4,29}$", ErrorMessage = "Tên đăng nhập 5-30 ký tự, bắt đầu bằng chữ cái, chỉ gồm chữ và số (không được chỉ toàn số)")]
        [Display(Name = "Tên đăng nhập")]
        public string Username { get; set; }

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

        [Required(ErrorMessage = "Vui lòng nhập họ tên")]
        [StringLength(100)]
        [Display(Name = "Họ và tên")]
        public string FullName { get; set; }

        [Required(ErrorMessage = "Vui lòng nhập số điện thoại")]
        [RegularExpression(@"^(03|05|07|08|09)\d{8}$", ErrorMessage = "Số điện thoại gồm đúng 10 số, bắt đầu bằng 03, 05, 07, 08 hoặc 09 (ví dụ 0912345678)")]
        [Display(Name = "Số điện thoại")]
        public string Phone { get; set; }

        [EmailAddress(ErrorMessage = "Email không hợp lệ")]
        [StringLength(100)]
        public string Email { get; set; }

        [Required(ErrorMessage = "Vui lòng nhập địa chỉ")]
        [StringLength(250)]
        [DiaChiHopLe]
        [Display(Name = "Địa chỉ")]
        public string Address { get; set; }
    }

    // Kiểm tra địa chỉ có dạng thật: tối thiểu 10 ký tự, có chữ, từ 3 từ trở lên, không có ký tự lặp vô nghĩa (aaaa, ....)
    public class DiaChiHopLeAttribute : ValidationAttribute
    {
        public const string Loi = "Địa chỉ chưa hợp lệ. Vui lòng nhập đầy đủ: số nhà, đường, phường/xã, quận/huyện, tỉnh/thành.";

        public static bool Check(string s)
        {
            if (string.IsNullOrWhiteSpace(s)) return false;
            s = s.Trim();
            if (s.Length < 10) return false;
            if (!s.Any(char.IsLetter)) return false;
            if (Regex.IsMatch(s, @"(.)\1{3,}")) return false;                     // 4 ký tự giống nhau liền nhau
            var tu = Regex.Split(s, @"[\s,.\-/]+").Where(x => x.Length > 0).ToList();
            if (tu.Count < 3) return false;                                        // ít nhất 3 từ
            if (tu.Count(x => x.Any(char.IsLetter)) < 2) return false;             // ít nhất 2 từ có chữ
            return true;
        }

        public override bool IsValid(object value)
        {
            return value == null || Check(value as string);   // để Required lo trường hợp trống
        }

        public DiaChiHopLeAttribute() { ErrorMessage = Loi; }
    }

    public class LoginViewModel
    {
        [Required(ErrorMessage = "Vui lòng nhập tên đăng nhập")]
        public string Username { get; set; }

        [Required(ErrorMessage = "Vui lòng nhập mật khẩu")]
        [DataType(DataType.Password)]
        public string Password { get; set; }
    }

    public class ProfileViewModel
    {
        public string Username { get; set; }

        [Required(ErrorMessage = "Vui lòng nhập họ tên")]
        [StringLength(100)]
        public string FullName { get; set; }

        [Required(ErrorMessage = "Vui lòng nhập số điện thoại")]
        [RegularExpression(@"^(03|05|07|08|09)\d{8}$", ErrorMessage = "Số điện thoại gồm đúng 10 số, bắt đầu bằng 03, 05, 07, 08 hoặc 09 (ví dụ 0912345678)")]
        public string Phone { get; set; }

        [EmailAddress(ErrorMessage = "Email không hợp lệ")]
        [StringLength(100)]
        public string Email { get; set; }

        [Required(ErrorMessage = "Vui lòng nhập địa chỉ")]
        [StringLength(250)]
        [DiaChiHopLe]
        public string Address { get; set; }
    }

    public class ChangePasswordViewModel
    {
        [Required(ErrorMessage = "Vui lòng nhập mật khẩu hiện tại")]
        [DataType(DataType.Password)]
        public string OldPassword { get; set; }

        [Required(ErrorMessage = "Vui lòng nhập mật khẩu mới")]
        [StringLength(100, MinimumLength = 8, ErrorMessage = "Mật khẩu tối thiểu 8 ký tự")]
        [DataType(DataType.Password)]
        public string NewPassword { get; set; }

        [Required(ErrorMessage = "Vui lòng nhập lại mật khẩu mới")]
        [Compare("NewPassword", ErrorMessage = "Mật khẩu xác nhận chưa trùng khớp")]
        [DataType(DataType.Password)]
        public string ConfirmPassword { get; set; }
    }
}
