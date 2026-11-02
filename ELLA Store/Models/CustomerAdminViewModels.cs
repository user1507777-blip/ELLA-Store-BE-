using System;

namespace ELLA_Store.Models
{
    // Một dòng trong bảng Quản lý khách hàng (ghép User + Customer + số đơn).
    public class CustomerRowViewModel
    {
        public int CustomerID { get; set; }
        public string Username { get; set; }
        public string FullName { get; set; }
        public string Phone { get; set; }
        public string Email { get; set; }
        public string Address { get; set; }
        public bool IsActive { get; set; }
        public DateTime CreatedAt { get; set; }
        public int OrderCount { get; set; }
    }
}
