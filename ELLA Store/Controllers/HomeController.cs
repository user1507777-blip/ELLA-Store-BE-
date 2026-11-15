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
        public ActionResult Adidas(string keyword, decimal? minPrice, decimal? maxPrice, string sortOrder, string tieuChi = null, int page = 1)
        {
            return DanhSachTheoHang("Adidas", "Adidas", keyword, minPrice, maxPrice, sortOrder, tieuChi, page);
        }

        // GET: Home/Asics
        public ActionResult Asics(string keyword, decimal? minPrice, decimal? maxPrice, string sortOrder, string tieuChi = null, int page = 1)
        {
            return DanhSachTheoHang("Asics", "Asics", keyword, minPrice, maxPrice, sortOrder, tieuChi, page);
        }

        // GET: Home/Biti
        public ActionResult Biti(string keyword, decimal? minPrice, decimal? maxPrice, string sortOrder, string tieuChi = null, int page = 1)
        {
            return DanhSachTheoHang("Biti", "Biti's", keyword, minPrice, maxPrice, sortOrder, tieuChi, page);
        }

        // GET: Home/Nike
        public ActionResult Nike(string keyword, decimal? minPrice, decimal? maxPrice, string sortOrder, string tieuChi = null, int page = 1)
        {
            return DanhSachTheoHang("Nike", "Nike", keyword, minPrice, maxPrice, sortOrder, tieuChi, page);
        }

        // GET: Home/Puma
        public ActionResult Puma(string keyword, decimal? minPrice, decimal? maxPrice, string sortOrder, string tieuChi = null, int page = 1)
        {
            return DanhSachTheoHang("Puma", "Puma", keyword, minPrice, maxPrice, sortOrder, tieuChi, page);
        }

        // GET: Home/TimKiem?keyword=...  (ô tìm kiếm ở đầu trang: tìm sản phẩm trong CSDL, mọi hãng, có phân trang)
        public ActionResult TimKiem(string keyword, decimal? minPrice, decimal? maxPrice, string sortOrder, string tieuChi = null, int page = 1)
        {
            return DanhSachTheoHang("TimKiem", null, keyword, minPrice, maxPrice, sortOrder, tieuChi, page);
        }

        public ActionResult ChiTietSanPham(int? id)
        {
            ViewBag.Id = id;
            // Nạp toàn bộ sản phẩm từ CSDL cho trang chi tiết (JavaScript dùng để hiện chi tiết + sản phẩm cùng hãng)
            var ds = ProductStore.All().Select(p => new
            {
                id = p.ProductID.ToString(),
                name = p.NamePro,
                price = p.SalePrice,          // giá bán thực tế (đã trừ giảm giá)
                oldPrice = p.Price,           // giá gốc
                discount = p.DiscountPercent,
                bestSeller = p.IsBestSeller,
                image = Url.Content("~/Content/image/" + p.ImagePro),
                brand = p.CategoryName,
                stock = p.Stock,
                sizes = p.Sizes.Select(z => new { size = z.Size, qty = z.Quantity })
            });
            ViewBag.SanPhamJson = JsonConvert.SerializeObject(ds,
                new JsonSerializerSettings { StringEscapeHandling = StringEscapeHandling.EscapeHtml });
            return View();
        }

        public ActionResult GioHang()
        {
            return View();
        }

        // Đặt hàng phải đăng nhập: chưa đăng nhập thì chuyển sang trang Đăng nhập, xong quay lại đây.
        [LoginRequired]
        public ActionResult DatHang()
        {
            var c = UserStore.FindCustomerByUsername((string)Session["Username"]);
            ViewBag.HoTen = c != null ? c.FullName : (string)Session["FullName"];
            ViewBag.Sdt = c != null ? c.Phone : "";
            ViewBag.Email = c != null ? c.Email : "";
            ViewBag.DiaChi = c != null ? c.Address : "";
            return View();
        }

        // Một dòng trong giỏ hàng do trang đặt hàng gửi lên (JSON).
        private class DongGioHang
        {
            public string id { get; set; }
            public string name { get; set; }
            public string size { get; set; }
            public int quantity { get; set; }
        }

        // POST: Home/TaoDonHang - khách bấm "Xác nhận đặt hàng": lưu đơn vào database (Order + OrderDetail),
        // trừ tồn kho, lấy giá thật từ database. Đơn hiện ngay ở trang Quản lý đơn hàng của Admin.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult TaoDonHang(string items, string hoTen, string sdt, string email, string diaChi, string phuongThuc, string voucherCode)
        {
            if (Session["UserID"] == null)
                return Json(new { ok = false, needLogin = true, message = "Vui lòng đăng nhập để đặt hàng." });

            // Kiểm tra dữ liệu người nhận (cả phía server, phòng khi bỏ qua kiểm tra trên trình duyệt)
            string loiNhap = KiemTraNguoiNhan(hoTen, sdt, email, diaChi);
            if (loiNhap != null) return Json(new { ok = false, message = loiNhap });

            System.Collections.Generic.List<DongGioHang> gio;
            try { gio = JsonConvert.DeserializeObject<System.Collections.Generic.List<DongGioHang>>(items ?? ""); }
            catch { gio = null; }
            if (gio == null || gio.Count == 0)
                return Json(new { ok = false, message = "Giỏ hàng đang trống." });

            var dsSp = ProductStore.All();
            var order = new Order
            {
                Receiver = hoTen.Trim(),
                Phone = sdt.Trim().Replace(" ", ""),
                Email = string.IsNullOrWhiteSpace(email) ? null : email.Trim(),
                Address = diaChi.Trim(),
                PaymentMethod = phuongThuc == "Chuyển khoản" ? "Chuyển khoản" : "COD",
                VoucherCode = string.IsNullOrWhiteSpace(voucherCode) ? null : voucherCode.Trim()
            };

            // Đã đăng nhập thì gắn đơn vào hồ sơ khách hàng (để xem trong "Tài khoản của tôi")
            if (Session["Username"] != null)
            {
                var c = UserStore.FindCustomerByUsername((string)Session["Username"]);
                if (c != null) order.CustomerID = c.CustomerID;
            }

            foreach (var g in gio)
            {
                int pid;
                Product sp = null;
                if (int.TryParse(g.id, out pid)) sp = dsSp.FirstOrDefault(p => p.ProductID == pid);
                if (sp == null && !string.IsNullOrEmpty(g.name))      // giỏ cũ chưa có mã sản phẩm: tìm theo tên
                    sp = dsSp.FirstOrDefault(p => p.NamePro == g.name);
                if (sp == null)
                    return Json(new { ok = false, message = "Sản phẩm \"" + g.name + "\" không còn trong cửa hàng." });
                order.Items.Add(new OrderItem { ProductID = sp.ProductID, ProductName = sp.NamePro, Size = g.size, Quantity = g.quantity });
            }

            string loi;
            if (!OrderStore.Place(order, out loi))
                return Json(new { ok = false, message = loi });

            return Json(new
            {
                ok = true,
                order = new
                {
                    id = order.OrderID,
                    date = order.CreatedAt.ToString("dd/MM/yyyy HH:mm"),
                    receiver = order.Receiver,
                    phone = order.Phone,
                    email = order.Email,
                    address = order.Address,
                    paymentMethod = order.PaymentMethod,
                    paymentStatus = order.PaymentStatus,
                    shipping = order.ShippingFee,
                    subtotal = order.SubTotal,
                    voucherCode = order.VoucherCode,
                    discount = order.DiscountAmount,
                    total = order.TotalPrice,
                    items = order.Items.Select(i => new { name = i.ProductName, size = i.Size, quantity = i.Quantity, price = i.UnitPrice })
                }
            });
        }

        // POST: Home/KiemTraVoucher - khách nhập mã ở trang đặt hàng; tính tiền giảm theo giá thật trong database.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult KiemTraVoucher(string items, string ma)
        {
            System.Collections.Generic.List<DongGioHang> gio;
            try { gio = JsonConvert.DeserializeObject<System.Collections.Generic.List<DongGioHang>>(items ?? ""); }
            catch { gio = null; }
            if (gio == null || gio.Count == 0)
                return Json(new { ok = false, message = "Giỏ hàng đang trống." });

            var dsSp = ProductStore.All();
            decimal tien = 0;
            foreach (var g in gio)
            {
                int pid;
                Product sp = null;
                if (int.TryParse(g.id, out pid)) sp = dsSp.FirstOrDefault(p => p.ProductID == pid);
                if (sp == null && !string.IsNullOrEmpty(g.name)) sp = dsSp.FirstOrDefault(p => p.NamePro == g.name);
                if (sp == null) continue;
                tien += sp.SalePrice * g.quantity;
            }

            Voucher v; decimal giam; string loi;
            if (!VoucherStore.Check(ma, tien, out v, out giam, out loi))
                return Json(new { ok = false, message = loi });
            return Json(new
            {
                ok = true,
                code = v.Code,
                percent = v.DiscountPercent,
                discount = giam,
                subtotal = tien,
                message = "Đã áp dụng mã " + v.Code + " (giảm " + v.DiscountPercent + "%)."
            });
        }

        // Trả về thông báo lỗi đầu tiên, hoặc null nếu hợp lệ.
        private static string KiemTraNguoiNhan(string hoTen, string sdt, string email, string diaChi)
        {
            hoTen = (hoTen ?? "").Trim();
            sdt = (sdt ?? "").Trim().Replace(" ", "");
            email = (email ?? "").Trim();
            diaChi = (diaChi ?? "").Trim();

            if (hoTen.Length < 2 || hoTen.Length > 100)
                return "Họ tên phải từ 2 đến 100 ký tự.";
            if (!System.Text.RegularExpressions.Regex.IsMatch(hoTen, @"^[\p{L}][\p{L}\s'.-]*$"))
                return "Họ tên chỉ gồm chữ cái, không chứa số hoặc ký tự đặc biệt.";
            if (!System.Text.RegularExpressions.Regex.IsMatch(sdt, @"^(0|\+84)(3|5|7|8|9)\d{8}$"))
                return "Số điện thoại không hợp lệ (ví dụ 0912345678).";
            if (email.Length > 0 && !System.Text.RegularExpressions.Regex.IsMatch(email, @"^[^@\s]+@[^@\s]+\.[^@\s]+$"))
                return "Email không đúng định dạng.";
            if (diaChi.Length < 10 || diaChi.Length > 200)
                return "Địa chỉ giao hàng phải từ 10 đến 200 ký tự (số nhà, đường, phường/xã, quận/huyện).";
            return null;
        }

        public ActionResult Bill()
        {
            return View();
        }

        // GET: Home/LichSuMuaHang - các đơn của khách đang đăng nhập (đọc từ database)
        [LoginRequired]
        public ActionResult LichSuMuaHang()
        {
            var c = UserStore.FindCustomerByUsername((string)Session["Username"]);
            var ds = c == null ? new System.Collections.Generic.List<Order>() : OrderStore.OfCustomer(c.CustomerID);
            return View(ds);
        }

        // GET: Home/ChiTietMuaHang/5 - chi tiết một đơn của chính khách đó
        [LoginRequired]
        public ActionResult ChiTietMuaHang(int? id)
        {
            if (id == null) return RedirectToAction("LichSuMuaHang");
            var c = UserStore.FindCustomerByUsername((string)Session["Username"]);
            var o = OrderStore.Find(id.Value);
            if (o == null || c == null || o.CustomerID != c.CustomerID) return HttpNotFound();
            return View(o);
        }


        // POST: Home/HuyDonHang - khách tự hủy đơn của mình khi đơn còn "Chờ xác nhận"
        [HttpPost]
        [LoginRequired]
        [ValidateAntiForgeryToken]
        public ActionResult HuyDonHang(int id)
        {
            var c = UserStore.FindCustomerByUsername((string)Session["Username"]);
            string loi;
            if (c != null && OrderStore.CustomerCancel(id, c.CustomerID, out loi))
            {
                var o = OrderStore.Find(id);
                TempData["ThongBao"] = "Đã hủy đơn #" + id + "."
                    + (o != null && o.PaymentStatus == PayStatus.ChoHoanTien ? " Bạn đã thanh toán trước nên cửa hàng sẽ hoàn tiền sớm." : "");
            }
            else
                TempData["Loi"] = c == null ? "Không tìm thấy tài khoản." : loi = null;
            return RedirectToAction("ChiTietMuaHang", new { id });
        }


        // ============== DANH SÁCH SẢN PHẨM THEO HÃNG (có tìm kiếm, lọc giá, sắp xếp, phân trang) ==============
        private const int PageSize = 6;   // số sản phẩm mỗi trang

        private ActionResult DanhSachTheoHang(string viewName, string categoryName, string keyword,
            decimal? minPrice, decimal? maxPrice, string sortOrder, string tieuChi, int page)
        {
            // categoryName == null: tìm trên tất cả các hãng (dùng cho ô tìm kiếm ở header)
            int categoryId = categoryName == null ? 0 : CategoryStore.IdOf(categoryName);
            var query = ProductStore.All().Where(p => categoryId == 0 || p.CategoryID == categoryId);

            if (!string.IsNullOrWhiteSpace(keyword))
            {
                string k = keyword.Trim();
                query = query.Where(p => p.NamePro.IndexOf(k, StringComparison.OrdinalIgnoreCase) >= 0);
            }
            // Lọc theo giá bán thực tế (đã trừ giảm giá)
            if (minPrice.HasValue) query = query.Where(p => p.SalePrice >= minPrice.Value);
            if (maxPrice.HasValue) query = query.Where(p => p.SalePrice <= maxPrice.Value);
            // Tiêu chí: sale / bán chạy / mới / còn hàng
            query = ProductStore.LocTheoTieuChi(query, tieuChi);

            switch (sortOrder)
            {
                case "price_asc": query = query.OrderBy(p => p.SalePrice); break;
                case "price_desc": query = query.OrderByDescending(p => p.SalePrice); break;
                case "name": query = query.OrderBy(p => p.NamePro); break;
                default:
                    // sale / bán chạy / mới đã tự sắp xếp; còn lại theo mã sản phẩm
                    if (!ProductStore.TieuChiTuSapXep(tieuChi)) query = query.OrderBy(p => p.ProductID);
                    break;
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
                Criteria = tieuChi,
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
            // Kiểm tra trùng tên đăng nhập TRƯỚC, để lỗi này luôn hiện cùng các lỗi khác
            if (!string.IsNullOrWhiteSpace(model.Username) && UserStore.UsernameExists(model.Username.Trim()))
                ModelState.AddModelError("Username", "Tên đăng nhập đã tồn tại, vui lòng chọn tên khác.");

            if (!ModelState.IsValid) return View(model);

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
            // Khách lấy tên trong hồ sơ khách hàng; quản trị viên lấy họ tên của tài khoản (không có thì dùng tên đăng nhập)
            Session["FullName"] = customer != null && !string.IsNullOrEmpty(customer.FullName) ? customer.FullName
                                : !string.IsNullOrWhiteSpace(user.FullName) ? user.FullName
                                : user.Username;

            if (!string.IsNullOrEmpty(returnUrl) && Url.IsLocalUrl(returnUrl))
                return Redirect(returnUrl);
            if (user.Role == "Admin") return Redirect("/Admin/SanPham");     // quản trị viên vào thẳng khu quản trị
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

            NapThongKeTaiKhoan(c);
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
            NapThongKeTaiKhoan(c);
            ViewBag.ThongBao = "Đã cập nhật thông tin.";
            return View(model);
        }

        // Số liệu đơn hàng hiện ở đầu trang "Tài khoản của tôi"
        private void NapThongKeTaiKhoan(Customer c)
        {
            var ds = OrderStore.OfCustomer(c.CustomerID);
            ViewBag.TongDon = ds.Count;
            ViewBag.DonDangXuLy = ds.Count(o => !OrderStatus.IsFinal(o.Status));
            ViewBag.DonHoanThanh = ds.Count(o => o.Status == OrderStatus.HoanThanh);
            ViewBag.TongChiTieu = ds.Where(o => o.Status == OrderStatus.HoanThanh).Sum(o => o.TotalPrice);
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