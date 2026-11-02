using System;
using System.Linq;
using Newtonsoft.Json;
using System.Web.Mvc;
using ELLA_Store.Filters;
using ELLA_Store.Helpers;
using ELLA_Store.Models;

namespace ELLA_Store.Controllers
{
    public class HomeController : Controller
    {
        public ActionResult Index()
        {
            return View();
        }

        // GET: Home/Adidas?keyword=&minPrice=&maxPrice=&sortOrder=&page=
        public ActionResult Adidas(string keyword, decimal? minPrice, decimal? maxPrice, string sortOrder, int page = 1)
        {
            return DanhSachTheoHang("Adidas", "Adidas", keyword, minPrice, maxPrice, sortOrder, page);
        }

        // GET: Home/Asics
        public ActionResult Asics(string keyword, decimal? minPrice, decimal? maxPrice, string sortOrder, int page = 1)
        {
            return DanhSachTheoHang("Asics", "Asics", keyword, minPrice, maxPrice, sortOrder, page);
        }

        // GET: Home/Biti
        public ActionResult Biti(string keyword, decimal? minPrice, decimal? maxPrice, string sortOrder, int page = 1)
        {
            return DanhSachTheoHang("Biti", "Biti's", keyword, minPrice, maxPrice, sortOrder, page);
        }

        // GET: Home/Nike
        public ActionResult Nike(string keyword, decimal? minPrice, decimal? maxPrice, string sortOrder, int page = 1)
        {
            return DanhSachTheoHang("Nike", "Nike", keyword, minPrice, maxPrice, sortOrder, page);
        }

        // GET: Home/Puma
        public ActionResult Puma(string keyword, decimal? minPrice, decimal? maxPrice, string sortOrder, int page = 1)
        {
            return DanhSachTheoHang("Puma", "Puma", keyword, minPrice, maxPrice, sortOrder, page);
        }

        // GET: Home/TimKiem?keyword=...  (ô tìm kiếm ở đầu trang: tìm sản phẩm trong CSDL, mọi hãng, có phân trang)
        public ActionResult TimKiem(string keyword, decimal? minPrice, decimal? maxPrice, string sortOrder, int page = 1)
        {
            return DanhSachTheoHang("TimKiem", null, keyword, minPrice, maxPrice, sortOrder, page);
        }

        public ActionResult ChiTietSanPham(int? id)
        {
            ViewBag.Id = id;
            // Nạp toàn bộ sản phẩm từ CSDL cho trang chi tiết (JavaScript dùng để hiện chi tiết + sản phẩm cùng hãng)
            var ds = ProductStore.All().Select(p => new
            {
                id = p.ProductID.ToString(),
                name = p.NamePro,
                price = p.Price,
                image = Url.Content("~/Content/image/" + p.ImagePro),
                brand = p.CategoryName,
                stock = p.Stock
            });
            ViewBag.SanPhamJson = JsonConvert.SerializeObject(ds,
                new JsonSerializerSettings { StringEscapeHandling = StringEscapeHandling.EscapeHtml });
            return View();
        }

        public ActionResult GioHang()
        {
            return View();
        }

        public ActionResult DatHang()
        {
            return View();
        }

        public ActionResult Bill()
        {
            return View();
        }



        public ActionResult LichSuMuaHang()
        {
            return View();
        }

        public ActionResult ChiTietMuaHang()
        {
            return View();
        }


        // ============== DANH SÁCH SẢN PHẨM THEO HÃNG (có tìm kiếm, lọc giá, sắp xếp, phân trang) ==============
        private const int PageSize = 6;   // số sản phẩm mỗi trang

        private ActionResult DanhSachTheoHang(string viewName, string categoryName, string keyword,
            decimal? minPrice, decimal? maxPrice, string sortOrder, int page)
        {
            // categoryName == null: tìm trên tất cả các hãng (dùng cho ô tìm kiếm ở header)
            int categoryId = categoryName == null ? 0 : CategoryStore.IdOf(categoryName);
            var query = ProductStore.All().Where(p => categoryId == 0 || p.CategoryID == categoryId);

            if (!string.IsNullOrWhiteSpace(keyword))
            {
                string k = keyword.Trim();
                query = query.Where(p => p.NamePro.IndexOf(k, StringComparison.OrdinalIgnoreCase) >= 0);
            }
            if (minPrice.HasValue) query = query.Where(p => p.Price >= minPrice.Value);
            if (maxPrice.HasValue) query = query.Where(p => p.Price <= maxPrice.Value);

            switch (sortOrder)
            {
                case "price_asc": query = query.OrderBy(p => p.Price); break;
                case "price_desc": query = query.OrderByDescending(p => p.Price); break;
                case "name": query = query.OrderBy(p => p.NamePro); break;
                default: query = query.OrderBy(p => p.ProductID); break;
            }

            var all = query.ToList();
            int totalPages = Math.Max(1, (int)Math.Ceiling(all.Count / (double)PageSize));
            if (page < 1) page = 1;
            if (page > totalPages) page = totalPages;

            var model = new PagedProductsViewModel
            {
                Items = all.Skip((page - 1) * PageSize).Take(PageSize).ToList(),
                Title = categoryName ?? "Kết quả tìm kiếm",
                ActionName = viewName,
                CurrentPage = page,
                TotalPages = totalPages,
                TotalItems = all.Count,
                SelectedCategoryId = categoryId,
                SearchTerm = keyword,
                MinPrice = minPrice,
                MaxPrice = maxPrice,
                SortOrder = sortOrder
            };
            return View(viewName, model);
        }

        // ================== KHÁCH HÀNG & NGƯỜI DÙNG ==================

        // GET: Home/DangKy
        public ActionResult DangKy()
        {
            return View(new RegisterViewModel());
        }

        // POST: Home/DangKy - tạo User (tài khoản) + Customer (khách hàng) cùng lúc, lưu trong UserStore
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult DangKy(RegisterViewModel model)
        {
            if (!ModelState.IsValid) return View(model);

            if (UserStore.UsernameExists(model.Username))
            {
                ModelState.AddModelError("Username", "Tên đăng nhập đã tồn tại");
                return View(model);
            }

            var user = new User
            {
                Username = model.Username,
                PasswordHash = PasswordHasher.Hash(model.Password),
                Role = "Customer",
                IsActive = true,
                CreatedAt = DateTime.Now
            };
            UserStore.AddCustomerAccount(user, new Customer
            {
                FullName = model.FullName,
                Phone = model.Phone,
                Email = model.Email,
                Address = model.Address
            });

            TempData["ThongBao"] = "Đăng ký thành công! Mời bạn đăng nhập.";
            return RedirectToAction("DangNhap");
        }

        // GET: Home/DangNhap
        public ActionResult DangNhap(string returnUrl)
        {
            ViewBag.ReturnUrl = returnUrl;
            return View(new LoginViewModel());
        }

        // POST: Home/DangNhap
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult DangNhap(LoginViewModel model, string returnUrl)
        {
            ViewBag.ReturnUrl = returnUrl;
            if (!ModelState.IsValid) return View(model);

            var user = UserStore.FindUser(model.Username);
            if (user == null || !PasswordHasher.Verify(model.Password, user.PasswordHash))
            {
                ModelState.AddModelError("", "Sai tên đăng nhập hoặc mật khẩu");
                return View(model);
            }
            if (!user.IsActive)
            {
                ModelState.AddModelError("", "Tài khoản đã bị khóa");
                return View(model);
            }

            var customer = UserStore.FindCustomerByUsername(user.Username);
            Session["UserID"] = user.Username;   // khóa đăng nhập = Username (bảng User dùng Username làm khóa chính)
            Session["Username"] = user.Username;
            Session["Role"] = user.Role;
            Session["FullName"] = customer != null ? customer.FullName : user.Username;

            if (!string.IsNullOrEmpty(returnUrl) && Url.IsLocalUrl(returnUrl))
                return Redirect(returnUrl);
            return RedirectToAction("Index");
        }

        // GET: Home/DangXuat
        public ActionResult DangXuat()
        {
            Session.Clear();
            Session.Abandon();
            return RedirectToAction("Index");
        }

        // GET: Home/TaiKhoan - xem thông tin khách hàng
        [LoginRequired]
        public ActionResult TaiKhoan()
        {
            var c = UserStore.FindCustomerByUsername((string)Session["Username"]);
            if (c == null) return RedirectToAction("Index");   // vd: tài khoản admin không có hồ sơ khách

            return View(new ProfileViewModel
            {
                Username = (string)Session["Username"],
                FullName = c.FullName,
                Phone = c.Phone,
                Email = c.Email,
                Address = c.Address
            });
        }

        // POST: Home/TaiKhoan - cập nhật thông tin khách hàng
        [LoginRequired]
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult TaiKhoan(ProfileViewModel model)
        {
            model.Username = (string)Session["Username"];
            if (!ModelState.IsValid) return View(model);

            var c = UserStore.FindCustomerByUsername(model.Username);
            if (c == null) return RedirectToAction("Index");

            c.FullName = model.FullName;
            c.Phone = model.Phone;
            c.Email = model.Email;
            c.Address = model.Address;
            UserStore.UpdateCustomer(c);

            Session["FullName"] = c.FullName;
            ViewBag.ThongBao = "Đã cập nhật thông tin.";
            return View(model);
        }

        // GET/POST: Home/DoiMatKhau
        [LoginRequired]
        public ActionResult DoiMatKhau()
        {
            return View(new ChangePasswordViewModel());
        }

        [LoginRequired]
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult DoiMatKhau(ChangePasswordViewModel model)
        {
            if (!ModelState.IsValid) return View(model);

            var user = UserStore.FindUser((string)Session["Username"]);
            if (user == null || !PasswordHasher.Verify(model.OldPassword, user.PasswordHash))
            {
                ModelState.AddModelError("OldPassword", "Mật khẩu hiện tại không đúng");
                return View(model);
            }

            UserStore.SetPassword(user.Username, PasswordHasher.Hash(model.NewPassword));
            ViewBag.ThongBao = "Đổi mật khẩu thành công.";
            return View(new ChangePasswordViewModel());
        }

    }
}