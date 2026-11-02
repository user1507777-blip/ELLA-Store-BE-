using System;
using System.ComponentModel.DataAnnotations;

namespace ELLA_Store.Models
{
    // Tài khoản đăng nhập (bảng User trong MyStore): khách mua hàng hoặc quản trị viên.
    // Khóa chính là Username. Trong database cột UserRole lưu 'A'/'C'; ở đây dùng "Admin"/"Customer".
    public class User
    {
        [Required, StringLength(50)]
        public string Username { get; set; }

        [Required, StringLength(200)]
        public string PasswordHash { get; set; }       // KHÔNG lưu mật khẩu thô (cột Password trong database)

        [Required, StringLength(20)]
        public string Role { get; set; }               // "Customer" hoặc "Admin"

        public bool IsActive { get; set; }             // false = khóa tài khoản
        public DateTime CreatedAt { get; set; }

        // Thông tin hồ sơ của quản trị viên (khách hàng lưu ở bảng Customer).
        [StringLength(100)]
        public string FullName { get; set; }

        [StringLength(100)]
        public string Email { get; set; }

        [StringLength(15)]
        public string Phone { get; set; }

        public int? BirthYear { get; set; }
    }
}
