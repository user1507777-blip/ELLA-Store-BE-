using System;
using System.Collections.Generic;
using System.Data.Entity.Infrastructure;
using System.Linq;
using Db = ELLA_Store.Data;

namespace ELLA_Store.Models
{
    // Đọc/ghi bảng User và Customer trong database MyStore (qua Entity Framework).
    // Database lưu UserRole = 'A'/'C'; ở phía ứng dụng dùng "Admin"/"Customer".
    public static class UserStore
    {
        private static string RoleCode(string role) { return role == "Admin" ? "A" : "C"; }
        private static string RoleName(string code) { return (code ?? "").Trim() == "A" ? "Admin" : "Customer"; }

        private static User UserToModel(Db.User e)
        {
            return new User
            {
                Username = e.Username,
                PasswordHash = e.Password,
                Role = RoleName(e.UserRole),
                IsActive = e.IsActive,
                CreatedAt = e.CreatedAt,
                FullName = e.FullName,
                Email = e.Email,
                Phone = e.Phone,
                BirthYear = e.BirthYear
            };
        }

        private static Customer CustomerToModel(Db.Customer e)
        {
            return new Customer
            {
                CustomerID = e.CustomerID,
                FullName = e.CustomerName,
                Phone = e.CustomerPhone,
                Email = e.CustomerEmail,
                Address = e.CustomerAddress,
                Username = e.Username
            };
        }

        // ---------------- Tài khoản ----------------

        public static User FindUser(string username)
        {
            if (string.IsNullOrEmpty(username)) return null;
            using (var db = new Db.MyStoreEntities())
            {
                var e = db.User.Find(username);
                return e == null ? null : UserToModel(e);
            }
        }

        public static bool UsernameExists(string username)
        {
            using (var db = new Db.MyStoreEntities())
            {
                return db.User.Any(u => u.Username == username);
            }
        }

        // Danh sách tài khoản quản trị (trang Quản lý người dùng)
        public static List<User> Admins()
        {
            using (var db = new Db.MyStoreEntities())
            {
                return db.User.Where(u => u.UserRole == "A").OrderBy(u => u.Username).ToList().Select(x => UserToModel(x)).ToList();
            }
        }

        public static int CountAdmins()
        {
            using (var db = new Db.MyStoreEntities())
            {
                return db.User.Count(u => u.UserRole == "A");
            }
        }

        public static void AddAdmin(User user)
        {
            using (var db = new Db.MyStoreEntities())
            {
                db.User.Add(new Db.User
                {
                    Username = user.Username,
                    Password = user.PasswordHash,
                    UserRole = "A",
                    IsActive = user.IsActive,
                    CreatedAt = DateTime.Now,
                    FullName = user.FullName,
                    Email = user.Email,
                    Phone = user.Phone,
                    BirthYear = user.BirthYear
                });
                db.SaveChanges();
            }
        }

        // Cập nhật hồ sơ/trạng thái tài khoản. passwordHash = null nghĩa là giữ nguyên mật khẩu.
        public static bool UpdateUser(string username, string fullName, string email, string phone, bool isActive, string passwordHash)
        {
            using (var db = new Db.MyStoreEntities())
            {
                var e = db.User.Find(username);
                if (e == null) return false;
                e.FullName = fullName;
                e.Email = email;
                e.Phone = phone;
                e.IsActive = isActive;
                if (!string.IsNullOrEmpty(passwordHash)) e.Password = passwordHash;
                db.SaveChanges();
                return true;
            }
        }

        public static bool SetPassword(string username, string passwordHash)
        {
            using (var db = new Db.MyStoreEntities())
            {
                var e = db.User.Find(username);
                if (e == null) return false;
                e.Password = passwordHash;
                db.SaveChanges();
                return true;
            }
        }

        // Xóa tài khoản và hồ sơ khách hàng đi kèm (nếu có).
        public static bool Remove(string username)
        {
            try
            {
                using (var db = new Db.MyStoreEntities())
                {
                    var e = db.User.Find(username);
                    if (e == null) return false;
                    var customers = db.Customer.Where(c => c.Username == username).ToList();
                    db.Customer.RemoveRange(customers);
                    db.User.Remove(e);
                    db.SaveChanges();
                    return true;
                }
            }
            catch (DbUpdateException)
            {
                return false;   // khách đã có đơn hàng (khóa ngoại chặn)
            }
        }

        // ---------------- Khách hàng ----------------

        // Đăng ký: thêm tài khoản kèm hồ sơ khách hàng trong cùng một lần lưu.
        public static void AddCustomerAccount(User user, Customer customer)
        {
            using (var db = new Db.MyStoreEntities())
            {
                db.User.Add(new Db.User
                {
                    Username = user.Username,
                    Password = user.PasswordHash,
                    UserRole = "C",
                    IsActive = user.IsActive,
                    CreatedAt = DateTime.Now
                });
                var c = new Db.Customer
                {
                    CustomerName = customer.FullName,
                    CustomerPhone = customer.Phone,
                    CustomerEmail = customer.Email,
                    CustomerAddress = customer.Address,
                    Username = user.Username
                };
                db.Customer.Add(c);
                db.SaveChanges();
                customer.CustomerID = c.CustomerID;
                customer.Username = user.Username;
            }
        }

        public static List<Customer> Customers()
        {
            using (var db = new Db.MyStoreEntities())
            {
                return db.Customer.OrderBy(c => c.CustomerID).ToList().Select(x => CustomerToModel(x)).ToList();
            }
        }

        public static Customer FindCustomer(int customerId)
        {
            using (var db = new Db.MyStoreEntities())
            {
                var e = db.Customer.Find(customerId);
                return e == null ? null : CustomerToModel(e);
            }
        }

        public static Customer FindCustomerByUsername(string username)
        {
            if (string.IsNullOrEmpty(username)) return null;
            using (var db = new Db.MyStoreEntities())
            {
                var e = db.Customer.FirstOrDefault(c => c.Username == username);
                return e == null ? null : CustomerToModel(e);
            }
        }

        public static bool UpdateCustomer(Customer c)
        {
            using (var db = new Db.MyStoreEntities())
            {
                var e = db.Customer.Find(c.CustomerID);
                if (e == null) return false;
                e.CustomerName = c.FullName;
                e.CustomerPhone = c.Phone;
                e.CustomerEmail = c.Email;
                e.CustomerAddress = c.Address;
                db.SaveChanges();
                return true;
            }
        }
    }
}
