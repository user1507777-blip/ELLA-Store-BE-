-- =====================================================================
-- MyStore - database của ELLA Store (đã chỉnh cho khớp project ASP.NET MVC 5)
-- Dựa trên database2024.txt. Chạy toàn bộ file này trong SSMS / Query của VS.
-- Mọi chỗ khác bản gốc đều có chú thích "-- [ĐỔI]" hoặc "-- [THÊM]".
-- =====================================================================
IF DB_ID(N'MyStore') IS NULL CREATE DATABASE MyStore;
GO
USE MyStore;
GO
 
-- Xóa bảng cũ (nếu chạy lại) theo thứ tự ngược khóa ngoại
IF OBJECT_ID(N'dbo.OrderDetail') IS NOT NULL DROP TABLE dbo.OrderDetail;
IF OBJECT_ID(N'dbo.[Order]')     IS NOT NULL DROP TABLE dbo.[Order];
IF OBJECT_ID(N'dbo.Product')     IS NOT NULL DROP TABLE dbo.Product;
IF OBJECT_ID(N'dbo.Category')    IS NOT NULL DROP TABLE dbo.Category;
IF OBJECT_ID(N'dbo.Customer')    IS NOT NULL DROP TABLE dbo.Customer;
IF OBJECT_ID(N'dbo.[User]')      IS NOT NULL DROP TABLE dbo.[User];
GO
 
-- ---------------------------------------------------------------------
-- Bảng User: tài khoản của khách hàng và admin
-- ---------------------------------------------------------------------
CREATE TABLE dbo.[User] (
    Username   NVARCHAR(50)  NOT NULL,                  -- [ĐỔI] 255 -> 50 (khớp StringLength(50) của project)
    Password   NVARCHAR(200) NOT NULL,                  -- [ĐỔI] NCHAR(50) -> NVARCHAR(200): chuỗi băm PBKDF2 dài ~70 ký tự, NCHAR còn độn khoảng trắng
    UserRole   CHAR(1)       NOT NULL,                  -- A: admin, C: customer (code đổi 'A'<->"Admin", 'C'<->"Customer")
    IsActive   BIT           NOT NULL CONSTRAINT DF_User_IsActive DEFAULT 1,       -- [THÊM] khóa/mở khóa tài khoản
    CreatedAt  DATETIME      NOT NULL CONSTRAINT DF_User_CreatedAt DEFAULT GETDATE(), -- [THÊM]
    FullName   NVARCHAR(100) NULL,                      -- [THÊM] hồ sơ của admin (khách thì dùng bảng Customer)
    Email      NVARCHAR(100) NULL,                      -- [THÊM]
    Phone      NVARCHAR(15)  NULL,                      -- [THÊM]
    BirthYear  INT           NULL,                      -- [THÊM]
    CONSTRAINT PK_User PRIMARY KEY CLUSTERED (Username ASC),
    CONSTRAINT CK_User_Role CHECK (UserRole IN ('A', 'C'))   -- [THÊM]
);
GO
 
-- ---------------------------------------------------------------------
-- Bảng Customer: thông tin khách hàng (1 tài khoản C = 1 khách hàng)
-- ---------------------------------------------------------------------
CREATE TABLE dbo.Customer (
    CustomerID      INT IDENTITY(1,1) NOT NULL,
    CustomerName    NVARCHAR(100) NOT NULL,             -- [ĐỔI] MAX -> 100
    CustomerPhone   NVARCHAR(15)  NOT NULL,
    CustomerEmail   NVARCHAR(100) NULL,                 -- [ĐỔI] MAX -> 100
    CustomerAddress NVARCHAR(250) NULL,                 -- [ĐỔI] MAX -> 250
    Username        NVARCHAR(50)  NOT NULL,
    CONSTRAINT PK_Customer PRIMARY KEY CLUSTERED (CustomerID ASC),
    CONSTRAINT UQ_Customer_Username UNIQUE (Username),  -- [THÊM] mỗi tài khoản chỉ có 1 hồ sơ khách
    CONSTRAINT FK_User_Customer FOREIGN KEY (Username) REFERENCES dbo.[User](Username)
);
GO
 
-- ---------------------------------------------------------------------
-- Bảng Category: danh mục sản phẩm (hãng giày)
-- ---------------------------------------------------------------------
CREATE TABLE dbo.Category (
    CategoryID   INT IDENTITY(1,1) NOT NULL,
    CategoryName NVARCHAR(100) NOT NULL,                -- [ĐỔI] MAX -> 100 (cột MAX không tạo được UNIQUE)
    Description  NVARCHAR(250) NULL,                    -- [THÊM] form Quản lý danh mục có ô Mô tả
    CONSTRAINT PK_Category PRIMARY KEY CLUSTERED (CategoryID ASC),
    CONSTRAINT UQ_Category_Name UNIQUE (CategoryName)   -- [THÊM] không cho trùng tên danh mục
);
GO
 
-- ---------------------------------------------------------------------
-- Bảng Product: sản phẩm / hàng hóa
-- ---------------------------------------------------------------------
CREATE TABLE dbo.Product (
    ProductID          INT IDENTITY(1,1) NOT NULL,
    CategoryID         INT NOT NULL,
    ProductName        NVARCHAR(200)   NOT NULL,        -- [ĐỔI] MAX -> 200
    ProductDecription  NVARCHAR(MAX)   NULL,            -- [ĐỔI] NOT NULL -> NULL (form thêm hàng hóa chưa có ô mô tả). Giữ nguyên chính tả "Decription" của bản gốc
    ProductPrice       DECIMAL(18, 2)  NOT NULL,
    ProductImage       NVARCHAR(255)   NULL,            -- [ĐỔI] MAX -> 255 (tên file trong Content/image)
    ProductStock       INT NOT NULL CONSTRAINT DF_Product_Stock DEFAULT 0,  -- [THÊM] tồn kho: Quản lý kho hàng cần cột này
    CONSTRAINT PK_Product PRIMARY KEY CLUSTERED (ProductID ASC),
    CONSTRAINT FK_Pro_Category FOREIGN KEY (CategoryID) REFERENCES dbo.Category(CategoryID),  -- chặn xóa danh mục còn hàng
    CONSTRAINT CK_Product_Price CHECK (ProductPrice > 0),   -- [THÊM]
    CONSTRAINT CK_Product_Stock CHECK (ProductStock >= 0)   -- [THÊM] tồn kho không âm
);
GO
 
-- ---------------------------------------------------------------------
-- Bảng Order: đơn hàng
-- ---------------------------------------------------------------------
CREATE TABLE dbo.[Order] (
    OrderID         INT IDENTITY(1,1) NOT NULL,
    CustomerID      INT NULL,                           -- [ĐỔI] NOT NULL -> NULL: cho phép khách chưa đăng nhập đặt hàng. Muốn bắt buộc đăng nhập thì đổi lại NOT NULL
    OrderDate       DATETIME NOT NULL CONSTRAINT DF_Order_Date DEFAULT GETDATE(),  -- [ĐỔI] DATE -> DATETIME (hiện cả giờ)
    TotalAmount     DECIMAL(18, 2) NOT NULL,            -- = tổng tiền hàng + ShippingFee (code tính khi thêm đơn)
    PaymentStatus   NVARCHAR(50)  NULL,                 -- [ĐỔI] MAX -> 50. Trạng thái thanh toán (vd: Chưa thanh toán / Đã thanh toán)
    AddressDelivery NVARCHAR(250) NOT NULL,             -- [ĐỔI] MAX -> 250
    ReceiverName    NVARCHAR(100) NOT NULL,             -- [THÊM] người nhận (có thể khác tên khách)
    ReceiverPhone   NVARCHAR(15)  NOT NULL,             -- [THÊM]
    ReceiverEmail   NVARCHAR(100) NULL,                 -- [THÊM]
    PaymentMethod   NVARCHAR(30)  NOT NULL CONSTRAINT DF_Order_Method DEFAULT N'COD',  -- [THÊM] COD / Chuyển khoản
    ShippingFee     DECIMAL(18, 2) NOT NULL CONSTRAINT DF_Order_Ship DEFAULT 30000,    -- [THÊM]
    OrderStatus     NVARCHAR(30)  NOT NULL CONSTRAINT DF_Order_Status DEFAULT N'Chờ xác nhận',  -- [THÊM] quy trình xử lý đơn của trang Quản lý đơn hàng
    CONSTRAINT PK_Order PRIMARY KEY CLUSTERED (OrderID ASC),
    CONSTRAINT FK_Order_Customer FOREIGN KEY (CustomerID) REFERENCES dbo.Customer(CustomerID),
    CONSTRAINT CK_Order_Status CHECK (OrderStatus IN (N'Chờ xác nhận', N'Đang giao', N'Hoàn thành', N'Đã hủy')),  -- [THÊM]
    CONSTRAINT CK_Order_Total CHECK (TotalAmount >= 0)
);
GO
 
-- ---------------------------------------------------------------------
-- Bảng OrderDetail: các dòng sản phẩm trong đơn
-- ---------------------------------------------------------------------
CREATE TABLE dbo.OrderDetail (
    ID          INT IDENTITY(1,1) NOT NULL,
    ProductID   INT NOT NULL,
    OrderID     INT NOT NULL,
    Quantity    INT NOT NULL,
    UnitPrice   DECIMAL(18, 2) NOT NULL,                -- giá tại thời điểm đặt
    ProductName NVARCHAR(200) NULL,                     -- [THÊM] tên lúc đặt (hóa đơn không đổi dù sau này sửa tên sản phẩm)
    Size        NVARCHAR(10)  NULL,                     -- [THÊM] size giày khách chọn
    CONSTRAINT PK_OrderDetail PRIMARY KEY CLUSTERED (ID ASC),
    CONSTRAINT FK_OD_Product FOREIGN KEY (ProductID) REFERENCES dbo.Product(ProductID),   -- chặn xóa sản phẩm đã có trong đơn
    CONSTRAINT FK_OD_Order   FOREIGN KEY (OrderID)   REFERENCES dbo.[Order](OrderID),
    CONSTRAINT CK_OD_Qty CHECK (Quantity > 0)           -- [THÊM]
);
GO
 
-- =====================================================================
-- DỮ LIỆU MẪU (khớp dữ liệu đang chạy trong bộ nhớ của project)
-- =====================================================================
 
-- Tài khoản: admin / Admin@123 ; khach01..03 / Khach@123 (mật khẩu đã băm PBKDF2 đúng định dạng PasswordHasher)
INSERT INTO dbo.[User] (Username, Password, UserRole, IsActive, FullName) VALUES
 (N'admin',   N'10000.a8SVATHebROGz8K5CsLabQ==.IER2jeHniQV8iefw8YwnTMpFaM6OABnM3K3CzpUFIfg=', 'A', 1, N'Quản trị viên');
INSERT INTO dbo.[User] (Username, Password, UserRole, IsActive) VALUES
 (N'khach01', N'10000.L21oKlhGf8WDEjEKS7/A5Q==.4Fnls3VPPo2DTNjmpfDDDfr2anfaRZ8dNOmSn1biCnM=', 'C', 1),
 (N'khach02', N'10000.9DtJefiYbWwKfaoS0xbCUw==.+Fo5/v696UIlIP9WbewwfJ/wfMI59bOJtvnHxH70kxM=', 'C', 1),
 (N'khach03', N'10000.8VIRbFvk/MSQ3zS4k03uaw==.dvbdgw4h05op7Drei4LmluNb8pjNZFbEsArHZEZLxXU=', 'C', 0);
 
INSERT INTO dbo.Customer (CustomerName, CustomerPhone, CustomerEmail, CustomerAddress, Username) VALUES
 (N'Trần Thị Bình',  N'0901234567', N'binh.tran@example.com', N'12 Lê Lợi, Quận 1, TP.HCM', N'khach01'),
 (N'Lê Minh Châu',   N'0987654321', N'chau.le@example.com',   N'45 Hai Bà Trưng, Hải Châu, Đà Nẵng', N'khach02'),
 (N'Phạm Quốc Dũng', N'0912345678', NULL,                     N'88 Nguyễn Huệ, Huế', N'khach03');
 
SET IDENTITY_INSERT dbo.Category ON;
INSERT INTO dbo.Category (CategoryID, CategoryName, Description) VALUES
 (1, N'Nike',   N'Giày thể thao Nike'),
 (2, N'Adidas', N'Giày thể thao Adidas'),
 (3, N'Biti''s',N'Giày Biti''s Hunter'),
 (4, N'Asics',  N'Giày chạy bộ Asics'),
 (5, N'Puma',   N'Giày Puma');
SET IDENTITY_INSERT dbo.Category OFF;
 
-- ProductID 1-10 khớp với trang Chitietsanpham?id= của giao diện khách
SET IDENTITY_INSERT dbo.Product ON;
INSERT INTO dbo.Product (ProductID, CategoryID, ProductName, ProductPrice, ProductImage, ProductStock) VALUES
 (1,  1, N'Nike Air Force 1',              2500000, N'giay1.jpg',   25),
 (2,  2, N'Adidas Superstar',              1900000, N'Adidas Superstar.jpg', 18),
 (3,  2, N'Adida Grand Court 2.0k',        1350000, N'adida1.webp', 12),
 (4,  2, N'Adidas UltraBoost',             4500000, N'adidas2.jpg',  4),
 (5,  2, N'Adidas Handball Spezial',       2800000, N'adidas3.avif', 9),
 (6,  1, N'Nike SB Dunk Low Premium',      4900000, N'nike1.webp',   7),
 (7,  1, N'Nike Air Jordan 1 Elevate Low', 4800000, N'nike2.webp',   0),
 (8,  1, N'Nike Winflo 12',                5300000, N'nike3.avif',  15),
 (9,  1, N'Nike Free Metcon 7',            3000000, N'nike4.webp',   3),
 (10, 1, N'Nike Vomero 18',                4300000, N'nike5.avif',  20);
SET IDENTITY_INSERT dbo.Product OFF;
 
-- 5 đơn mẫu (TotalAmount = tiền hàng + 30.000 phí ship)
SET IDENTITY_INSERT dbo.[Order] ON;
INSERT INTO dbo.[Order] (OrderID, CustomerID, OrderDate, TotalAmount, PaymentStatus, AddressDelivery, ReceiverName, ReceiverPhone, ReceiverEmail, PaymentMethod, ShippingFee, OrderStatus) VALUES
 (1, 1,    DATEADD(DAY,-12,GETDATE()), 2530000, N'Đã thanh toán',     N'12 Lê Lợi, Quận 1, TP.HCM',          N'Trần Thị Bình',  N'0901234567', N'binh.tran@example.com', N'COD',          30000, N'Hoàn thành'),
 (2, 1,    DATEADD(DAY,-3, GETDATE()), 3830000, N'Đã thanh toán',     N'12 Lê Lợi, Quận 1, TP.HCM',          N'Trần Thị Bình',  N'0901234567', N'binh.tran@example.com', N'Chuyển khoản', 30000, N'Đang giao'),
 (3, 2,    DATEADD(DAY,-1, GETDATE()), 4930000, N'Chưa thanh toán',   N'45 Hai Bà Trưng, Hải Châu, Đà Nẵng', N'Lê Minh Châu',   N'0987654321', N'chau.le@example.com',   N'COD',          30000, N'Chờ xác nhận'),
 (4, 3,    DATEADD(DAY,-8, GETDATE()), 4530000, N'Chưa thanh toán',   N'88 Nguyễn Huệ, Huế',                 N'Phạm Quốc Dũng', N'0912345678', NULL,                     N'COD',          30000, N'Đã hủy'),
 (5, NULL, GETDATE(),                  5330000, N'Chưa thanh toán',   N'5 Pasteur, Quận 3, TP.HCM',          N'Nguyễn Văn Hải', N'0933333333', NULL,                     N'COD',          30000, N'Chờ xác nhận');
SET IDENTITY_INSERT dbo.[Order] OFF;
 
INSERT INTO dbo.OrderDetail (OrderID, ProductID, ProductName, Size, Quantity, UnitPrice) VALUES
 (1, 1, N'Nike Air Force 1',         N'40', 1, 2500000),
 (2, 2, N'Adidas Superstar',         N'41', 2, 1900000),
 (3, 6, N'Nike SB Dunk Low Premium', N'42', 1, 4900000),
 (4, 4, N'Adidas UltraBoost',        N'41', 1, 4500000),
 (5, 8, N'Nike Winflo 12',           N'43', 1, 5300000);
GO
 
-- Bản gốc có dòng này; chỉ bật nếu máy bạn có đăng nhập 'sa':
-- ALTER AUTHORIZATION ON DATABASE::MyStore TO sa;