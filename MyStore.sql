/* ===== TAI KHOAN DANG NHAP ===== 
  Tài Khoản Admin để cô đăng nhập  : admin   / Admin@123
  Khach hang: khach01 / Khach@123
================================== */
IF DB_ID(N'MyStore') IS NULL CREATE DATABASE [MyStore];
GO
USE [MyStore]
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE name = N'CK_Voucher_Percent' AND parent_object_id = OBJECT_ID(N'[dbo].[Voucher]'))
ALTER TABLE [dbo].[Voucher] DROP CONSTRAINT [CK_Voucher_Percent]
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE name = N'CK_User_Role' AND parent_object_id = OBJECT_ID(N'[dbo].[User]'))
ALTER TABLE [dbo].[User] DROP CONSTRAINT [CK_User_Role]
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE name = N'CK_PS_Qty' AND parent_object_id = OBJECT_ID(N'[dbo].[ProductSize]'))
ALTER TABLE [dbo].[ProductSize] DROP CONSTRAINT [CK_PS_Qty]
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE name = N'CK_Product_Stock' AND parent_object_id = OBJECT_ID(N'[dbo].[Product]'))
ALTER TABLE [dbo].[Product] DROP CONSTRAINT [CK_Product_Stock]
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE name = N'CK_Product_Price' AND parent_object_id = OBJECT_ID(N'[dbo].[Product]'))
ALTER TABLE [dbo].[Product] DROP CONSTRAINT [CK_Product_Price]
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE name = N'CK_Product_Discount' AND parent_object_id = OBJECT_ID(N'[dbo].[Product]'))
ALTER TABLE [dbo].[Product] DROP CONSTRAINT [CK_Product_Discount]
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE name = N'CK_OD_Qty' AND parent_object_id = OBJECT_ID(N'[dbo].[OrderDetail]'))
ALTER TABLE [dbo].[OrderDetail] DROP CONSTRAINT [CK_OD_Qty]
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE name = N'CK_Order_Total' AND parent_object_id = OBJECT_ID(N'[dbo].[Order]'))
ALTER TABLE [dbo].[Order] DROP CONSTRAINT [CK_Order_Total]
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE name = N'CK_Order_Status' AND parent_object_id = OBJECT_ID(N'[dbo].[Order]'))
ALTER TABLE [dbo].[Order] DROP CONSTRAINT [CK_Order_Status]
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE name = N'FK_SM_Size' AND parent_object_id = OBJECT_ID(N'[dbo].[StockMovement]'))
ALTER TABLE [dbo].[StockMovement] DROP CONSTRAINT [FK_SM_Size]
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE name = N'FK_SM_Product' AND parent_object_id = OBJECT_ID(N'[dbo].[StockMovement]'))
ALTER TABLE [dbo].[StockMovement] DROP CONSTRAINT [FK_SM_Product]
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE name = N'FK_PS_Size' AND parent_object_id = OBJECT_ID(N'[dbo].[ProductSize]'))
ALTER TABLE [dbo].[ProductSize] DROP CONSTRAINT [FK_PS_Size]
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE name = N'FK_PS_Product' AND parent_object_id = OBJECT_ID(N'[dbo].[ProductSize]'))
ALTER TABLE [dbo].[ProductSize] DROP CONSTRAINT [FK_PS_Product]
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE name = N'FK_Pro_Category' AND parent_object_id = OBJECT_ID(N'[dbo].[Product]'))
ALTER TABLE [dbo].[Product] DROP CONSTRAINT [FK_Pro_Category]
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE name = N'FK_OD_Product' AND parent_object_id = OBJECT_ID(N'[dbo].[OrderDetail]'))
ALTER TABLE [dbo].[OrderDetail] DROP CONSTRAINT [FK_OD_Product]
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE name = N'FK_OD_Order' AND parent_object_id = OBJECT_ID(N'[dbo].[OrderDetail]'))
ALTER TABLE [dbo].[OrderDetail] DROP CONSTRAINT [FK_OD_Order]
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE name = N'FK_Order_Customer' AND parent_object_id = OBJECT_ID(N'[dbo].[Order]'))
ALTER TABLE [dbo].[Order] DROP CONSTRAINT [FK_Order_Customer]
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE name = N'FK_User_Customer' AND parent_object_id = OBJECT_ID(N'[dbo].[Customer]'))
ALTER TABLE [dbo].[Customer] DROP CONSTRAINT [FK_User_Customer]
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE name = N'DF_Voucher_Created' AND parent_object_id = OBJECT_ID(N'[dbo].[Voucher]'))
ALTER TABLE [dbo].[Voucher] DROP CONSTRAINT [DF_Voucher_Created]
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE name = N'DF_Voucher_Active' AND parent_object_id = OBJECT_ID(N'[dbo].[Voucher]'))
ALTER TABLE [dbo].[Voucher] DROP CONSTRAINT [DF_Voucher_Active]
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE name = N'DF_Voucher_MinOrder' AND parent_object_id = OBJECT_ID(N'[dbo].[Voucher]'))
ALTER TABLE [dbo].[Voucher] DROP CONSTRAINT [DF_Voucher_MinOrder]
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE name = N'DF_User_CreatedAt' AND parent_object_id = OBJECT_ID(N'[dbo].[User]'))
ALTER TABLE [dbo].[User] DROP CONSTRAINT [DF_User_CreatedAt]
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE name = N'DF_User_IsActive' AND parent_object_id = OBJECT_ID(N'[dbo].[User]'))
ALTER TABLE [dbo].[User] DROP CONSTRAINT [DF_User_IsActive]
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE name = N'DF_SM_CreatedAt' AND parent_object_id = OBJECT_ID(N'[dbo].[StockMovement]'))
ALTER TABLE [dbo].[StockMovement] DROP CONSTRAINT [DF_SM_CreatedAt]
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE name = N'DF_ProductSize_Qty' AND parent_object_id = OBJECT_ID(N'[dbo].[ProductSize]'))
ALTER TABLE [dbo].[ProductSize] DROP CONSTRAINT [DF_ProductSize_Qty]
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE name = N'DF_Product_Discount' AND parent_object_id = OBJECT_ID(N'[dbo].[Product]'))
ALTER TABLE [dbo].[Product] DROP CONSTRAINT [DF_Product_Discount]
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE name = N'DF_Product_Stock' AND parent_object_id = OBJECT_ID(N'[dbo].[Product]'))
ALTER TABLE [dbo].[Product] DROP CONSTRAINT [DF_Product_Stock]
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE name = N'DF_Order_Discount' AND parent_object_id = OBJECT_ID(N'[dbo].[Order]'))
ALTER TABLE [dbo].[Order] DROP CONSTRAINT [DF_Order_Discount]
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE name = N'DF_Order_Status' AND parent_object_id = OBJECT_ID(N'[dbo].[Order]'))
ALTER TABLE [dbo].[Order] DROP CONSTRAINT [DF_Order_Status]
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE name = N'DF_Order_Ship' AND parent_object_id = OBJECT_ID(N'[dbo].[Order]'))
ALTER TABLE [dbo].[Order] DROP CONSTRAINT [DF_Order_Ship]
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE name = N'DF_Order_Method' AND parent_object_id = OBJECT_ID(N'[dbo].[Order]'))
ALTER TABLE [dbo].[Order] DROP CONSTRAINT [DF_Order_Method]
GO
IF EXISTS (SELECT 1 FROM sys.objects WHERE name = N'DF_Order_Date' AND parent_object_id = OBJECT_ID(N'[dbo].[Order]'))
ALTER TABLE [dbo].[Order] DROP CONSTRAINT [DF_Order_Date]
GO
/****** Object:  Index [UQ_Voucher_Code]    Script Date: 16/11/2026 10:38:37 SA ******/
IF EXISTS (SELECT 1 FROM sys.objects WHERE name = N'UQ_Voucher_Code' AND parent_object_id = OBJECT_ID(N'[dbo].[Voucher]'))
ALTER TABLE [dbo].[Voucher] DROP CONSTRAINT [UQ_Voucher_Code]
GO
/****** Object:  Index [UQ_Size_Name]    Script Date: 16/11/2026 10:38:37 SA ******/
IF EXISTS (SELECT 1 FROM sys.objects WHERE name = N'UQ_Size_Name' AND parent_object_id = OBJECT_ID(N'[dbo].[Size]'))
ALTER TABLE [dbo].[Size] DROP CONSTRAINT [UQ_Size_Name]
GO
/****** Object:  Index [UQ_Customer_Username]    Script Date: 16/11/2026 10:38:37 SA ******/
IF EXISTS (SELECT 1 FROM sys.objects WHERE name = N'UQ_Customer_Username' AND parent_object_id = OBJECT_ID(N'[dbo].[Customer]'))
ALTER TABLE [dbo].[Customer] DROP CONSTRAINT [UQ_Customer_Username]
GO
/****** Object:  Index [UQ_Category_Name]    Script Date: 16/11/2026 10:38:37 SA ******/
IF EXISTS (SELECT 1 FROM sys.objects WHERE name = N'UQ_Category_Name' AND parent_object_id = OBJECT_ID(N'[dbo].[Category]'))
ALTER TABLE [dbo].[Category] DROP CONSTRAINT [UQ_Category_Name]
GO
/****** Object:  Table [dbo].[Voucher]    Script Date: 16/11/2026 10:38:37 SA ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Voucher]') AND type in (N'U'))
DROP TABLE [dbo].[Voucher]
GO
/****** Object:  Table [dbo].[User]    Script Date: 16/11/2026 10:38:37 SA ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[User]') AND type in (N'U'))
DROP TABLE [dbo].[User]
GO
/****** Object:  Table [dbo].[StockMovement]    Script Date: 16/11/2026 10:38:37 SA ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[StockMovement]') AND type in (N'U'))
DROP TABLE [dbo].[StockMovement]
GO
/****** Object:  Table [dbo].[Size]    Script Date: 16/11/2026 10:38:37 SA ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Size]') AND type in (N'U'))
DROP TABLE [dbo].[Size]
GO
/****** Object:  Table [dbo].[ProductSize]    Script Date: 16/11/2026 10:38:37 SA ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ProductSize]') AND type in (N'U'))
DROP TABLE [dbo].[ProductSize]
GO
/****** Object:  Table [dbo].[Product]    Script Date: 16/11/2026 10:38:37 SA ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Product]') AND type in (N'U'))
DROP TABLE [dbo].[Product]
GO
/****** Object:  Table [dbo].[OrderDetail]    Script Date: 16/11/2026 10:38:37 SA ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OrderDetail]') AND type in (N'U'))
DROP TABLE [dbo].[OrderDetail]
GO
/****** Object:  Table [dbo].[Order]    Script Date: 16/11/2026 10:38:37 SA ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Order]') AND type in (N'U'))
DROP TABLE [dbo].[Order]
GO
/****** Object:  Table [dbo].[Customer]    Script Date: 16/11/2026 10:38:37 SA ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Customer]') AND type in (N'U'))
DROP TABLE [dbo].[Customer]
GO
/****** Object:  Table [dbo].[Category]    Script Date: 16/11/2026 10:38:37 SA ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Category]') AND type in (N'U'))
DROP TABLE [dbo].[Category]
GO
/****** Object:  Table [dbo].[Category]    Script Date: 16/11/2026 10:38:37 SA ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Category](
	[CategoryID] [int] IDENTITY(1,1) NOT NULL,
	[CategoryName] [nvarchar](100) NOT NULL,
	[Description] [nvarchar](250) NULL,
 CONSTRAINT [PK_Category] PRIMARY KEY CLUSTERED 
(
	[CategoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Customer]    Script Date: 16/11/2026 10:38:37 SA ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Customer](
	[CustomerID] [int] IDENTITY(1,1) NOT NULL,
	[CustomerName] [nvarchar](100) NOT NULL,
	[CustomerPhone] [nvarchar](15) NOT NULL,
	[CustomerEmail] [nvarchar](100) NULL,
	[CustomerAddress] [nvarchar](250) NULL,
	[Username] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_Customer] PRIMARY KEY CLUSTERED 
(
	[CustomerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Order]    Script Date: 16/11/2026 10:38:37 SA ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Order](
	[OrderID] [int] IDENTITY(1,1) NOT NULL,
	[CustomerID] [int] NULL,
	[OrderDate] [datetime] NOT NULL,
	[TotalAmount] [decimal](18, 2) NOT NULL,
	[PaymentStatus] [nvarchar](50) NULL,
	[AddressDelivery] [nvarchar](250) NOT NULL,
	[ReceiverName] [nvarchar](100) NOT NULL,
	[ReceiverPhone] [nvarchar](15) NOT NULL,
	[ReceiverEmail] [nvarchar](100) NULL,
	[PaymentMethod] [nvarchar](30) NOT NULL,
	[ShippingFee] [decimal](18, 2) NOT NULL,
	[OrderStatus] [nvarchar](30) NOT NULL,
	[VoucherCode] [nvarchar](30) NULL,
	[DiscountAmount] [decimal](18, 2) NOT NULL,
 CONSTRAINT [PK_Order] PRIMARY KEY CLUSTERED 
(
	[OrderID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OrderDetail]    Script Date: 16/11/2026 10:38:37 SA ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrderDetail](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ProductID] [int] NOT NULL,
	[OrderID] [int] NOT NULL,
	[Quantity] [int] NOT NULL,
	[UnitPrice] [decimal](18, 2) NOT NULL,
	[ProductName] [nvarchar](200) NULL,
	[Size] [nvarchar](10) NULL,
 CONSTRAINT [PK_OrderDetail] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Product]    Script Date: 16/11/2026 10:38:37 SA ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Product](
	[ProductID] [int] IDENTITY(1,1) NOT NULL,
	[CategoryID] [int] NOT NULL,
	[ProductName] [nvarchar](200) NOT NULL,
	[ProductDecription] [nvarchar](max) NULL,
	[ProductPrice] [decimal](18, 2) NOT NULL,
	[ProductImage] [nvarchar](255) NULL,
	[ProductStock] [int] NOT NULL,
	[DiscountPercent] [int] NOT NULL,
 CONSTRAINT [PK_Product] PRIMARY KEY CLUSTERED 
(
	[ProductID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ProductSize]    Script Date: 16/11/2026 10:38:37 SA ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProductSize](
	[ProductID] [int] NOT NULL,
	[SizeID] [int] NOT NULL,
	[Quantity] [int] NOT NULL,
 CONSTRAINT [PK_ProductSize] PRIMARY KEY CLUSTERED 
(
	[ProductID] ASC,
	[SizeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Size]    Script Date: 16/11/2026 10:38:37 SA ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Size](
	[SizeID] [int] IDENTITY(1,1) NOT NULL,
	[SizeName] [nvarchar](10) NOT NULL,
 CONSTRAINT [PK_Size] PRIMARY KEY CLUSTERED 
(
	[SizeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[StockMovement]    Script Date: 16/11/2026 10:38:37 SA ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[StockMovement](
	[MovementID] [int] IDENTITY(1,1) NOT NULL,
	[ProductID] [int] NOT NULL,
	[SizeID] [int] NOT NULL,
	[Quantity] [int] NOT NULL,
	[MovementType] [nvarchar](20) NOT NULL,
	[Note] [nvarchar](200) NULL,
	[OrderID] [int] NULL,
	[CreatedAt] [datetime] NOT NULL,
	[CreatedBy] [nvarchar](50) NULL,
 CONSTRAINT [PK_StockMovement] PRIMARY KEY CLUSTERED 
(
	[MovementID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[User]    Script Date: 16/11/2026 10:38:37 SA ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[User](
	[Username] [nvarchar](50) NOT NULL,
	[Password] [nvarchar](200) NOT NULL,
	[UserRole] [char](1) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[CreatedAt] [datetime] NOT NULL,
	[FullName] [nvarchar](100) NULL,
	[Email] [nvarchar](100) NULL,
	[Phone] [nvarchar](15) NULL,
	[BirthYear] [int] NULL,
 CONSTRAINT [PK_User] PRIMARY KEY CLUSTERED 
(
	[Username] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Voucher]    Script Date: 16/11/2026 10:38:37 SA ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Voucher](
	[VoucherID] [int] IDENTITY(1,1) NOT NULL,
	[Code] [nvarchar](30) NOT NULL,
	[DiscountPercent] [int] NOT NULL,
	[Description] [nvarchar](200) NULL,
	[MinOrder] [decimal](18, 0) NOT NULL,
	[ExpiryDate] [date] NULL,
	[IsActive] [bit] NOT NULL,
	[CreatedAt] [datetime] NOT NULL,
 CONSTRAINT [PK_Voucher] PRIMARY KEY CLUSTERED 
(
	[VoucherID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[Category] ON 

INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Description]) VALUES (1, N'Nike', N'Giày thể thao Nike')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Description]) VALUES (2, N'Adidas', N'Giày thể thao Adidas')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Description]) VALUES (3, N'Biti''s', N'Giày Biti''s Hunter')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Description]) VALUES (4, N'Asics', N'Giày chạy bộ Asics')
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Description]) VALUES (5, N'Puma', N'Giày Puma')
SET IDENTITY_INSERT [dbo].[Category] OFF
GO
SET IDENTITY_INSERT [dbo].[Customer] ON 

INSERT [dbo].[Customer] ([CustomerID], [CustomerName], [CustomerPhone], [CustomerEmail], [CustomerAddress], [Username]) VALUES (1, N'Trần Thị Bình', N'0901234567', N'binh.tran@example.com', N'12 Lê Lợi, Quận 1, TP.HCM', N'khach01')
INSERT [dbo].[Customer] ([CustomerID], [CustomerName], [CustomerPhone], [CustomerEmail], [CustomerAddress], [Username]) VALUES (2, N'Lê Minh Châu', N'0987654321', N'chau.le@example.com', N'45 Hai Bà Trưng, Hải Châu, Đà Nẵng', N'khach02')
INSERT [dbo].[Customer] ([CustomerID], [CustomerName], [CustomerPhone], [CustomerEmail], [CustomerAddress], [Username]) VALUES (3, N'Phạm Quốc Dũng', N'0912345678', NULL, N'88 Nguyễn Huệ, Huế', N'khach03')
INSERT [dbo].[Customer] ([CustomerID], [CustomerName], [CustomerPhone], [CustomerEmail], [CustomerAddress], [Username]) VALUES (5, N'Lê Thảo', N'0923456789', N'thao@gmail.com', N'tphcm', N'thao2')
SET IDENTITY_INSERT [dbo].[Customer] OFF
GO
SET IDENTITY_INSERT [dbo].[Order] ON 

INSERT [dbo].[Order] ([OrderID], [CustomerID], [OrderDate], [TotalAmount], [PaymentStatus], [AddressDelivery], [ReceiverName], [ReceiverPhone], [ReceiverEmail], [PaymentMethod], [ShippingFee], [OrderStatus], [VoucherCode], [DiscountAmount]) VALUES (1, 1, CAST(N'2026-10-17T15:53:11.820' AS DateTime), CAST(2530000.00 AS Decimal(18, 2)), N'Đã thanh toán', N'12 Lê Lợi, Quận 1, TP.HCM', N'Trần Thị Bình', N'0901234567', N'binh.tran@example.com', N'COD', CAST(30000.00 AS Decimal(18, 2)), N'Hoàn thành', NULL, CAST(0.00 AS Decimal(18, 2)))
INSERT [dbo].[Order] ([OrderID], [CustomerID], [OrderDate], [TotalAmount], [PaymentStatus], [AddressDelivery], [ReceiverName], [ReceiverPhone], [ReceiverEmail], [PaymentMethod], [ShippingFee], [OrderStatus], [VoucherCode], [DiscountAmount]) VALUES (2, 1, CAST(N'2026-10-26T15:53:11.820' AS DateTime), CAST(3830000.00 AS Decimal(18, 2)), N'Đã thanh toán', N'12 Lê Lợi, Quận 1, TP.HCM', N'Trần Thị Bình', N'0901234567', N'binh.tran@example.com', N'Chuyển khoản', CAST(30000.00 AS Decimal(18, 2)), N'Đang giao', NULL, CAST(0.00 AS Decimal(18, 2)))
INSERT [dbo].[Order] ([OrderID], [CustomerID], [OrderDate], [TotalAmount], [PaymentStatus], [AddressDelivery], [ReceiverName], [ReceiverPhone], [ReceiverEmail], [PaymentMethod], [ShippingFee], [OrderStatus], [VoucherCode], [DiscountAmount]) VALUES (3, 2, CAST(N'2026-10-28T15:53:11.820' AS DateTime), CAST(4930000.00 AS Decimal(18, 2)), N'Chưa thanh toán', N'45 Hai Bà Trưng, Hải Châu, Đà Nẵng', N'Lê Minh Châu', N'0987654321', N'chau.le@example.com', N'COD', CAST(30000.00 AS Decimal(18, 2)), N'Đang giao', NULL, CAST(0.00 AS Decimal(18, 2)))
INSERT [dbo].[Order] ([OrderID], [CustomerID], [OrderDate], [TotalAmount], [PaymentStatus], [AddressDelivery], [ReceiverName], [ReceiverPhone], [ReceiverEmail], [PaymentMethod], [ShippingFee], [OrderStatus], [VoucherCode], [DiscountAmount]) VALUES (4, 3, CAST(N'2026-10-21T15:53:11.820' AS DateTime), CAST(4530000.00 AS Decimal(18, 2)), N'Chưa thanh toán', N'88 Nguyễn Huệ, Huế', N'Phạm Quốc Dũng', N'0912345678', NULL, N'COD', CAST(30000.00 AS Decimal(18, 2)), N'Đã hủy', NULL, CAST(0.00 AS Decimal(18, 2)))
INSERT [dbo].[Order] ([OrderID], [CustomerID], [OrderDate], [TotalAmount], [PaymentStatus], [AddressDelivery], [ReceiverName], [ReceiverPhone], [ReceiverEmail], [PaymentMethod], [ShippingFee], [OrderStatus], [VoucherCode], [DiscountAmount]) VALUES (5, NULL, CAST(N'2026-10-29T15:53:11.820' AS DateTime), CAST(5330000.00 AS Decimal(18, 2)), N'Chưa thanh toán', N'5 Pasteur, Quận 3, TP.HCM', N'Nguyễn Văn Hải', N'0933333333', NULL, N'COD', CAST(30000.00 AS Decimal(18, 2)), N'Chờ xác nhận', NULL, CAST(0.00 AS Decimal(18, 2)))
INSERT [dbo].[Order] ([OrderID], [CustomerID], [OrderDate], [TotalAmount], [PaymentStatus], [AddressDelivery], [ReceiverName], [ReceiverPhone], [ReceiverEmail], [PaymentMethod], [ShippingFee], [OrderStatus], [VoucherCode], [DiscountAmount]) VALUES (6, 5, CAST(N'2026-11-05T13:48:38.813' AS DateTime), CAST(2000000.00 AS Decimal(18, 2)), N'Đã thanh toán', N'số 1, xã abc, huyện xyz, tphcm', N'Lê Thảo', N'0923456789', N'thao@gmail.com', N'COD', CAST(0.00 AS Decimal(18, 2)), N'Hoàn thành', NULL, CAST(0.00 AS Decimal(18, 2)))
INSERT [dbo].[Order] ([OrderID], [CustomerID], [OrderDate], [TotalAmount], [PaymentStatus], [AddressDelivery], [ReceiverName], [ReceiverPhone], [ReceiverEmail], [PaymentMethod], [ShippingFee], [OrderStatus], [VoucherCode], [DiscountAmount]) VALUES (7, 5, CAST(N'2026-11-10T21:19:46.057' AS DateTime), CAST(3000000.00 AS Decimal(18, 2)), N'Đã hoàn tiền', N'số abc, xã xyz, tp HCM', N'Lê Thảo', N'0923456789', N'thao@gmail.com', N'Chuyển khoản', CAST(0.00 AS Decimal(18, 2)), N'Đã hủy', NULL, CAST(0.00 AS Decimal(18, 2)))
INSERT [dbo].[Order] ([OrderID], [CustomerID], [OrderDate], [TotalAmount], [PaymentStatus], [AddressDelivery], [ReceiverName], [ReceiverPhone], [ReceiverEmail], [PaymentMethod], [ShippingFee], [OrderStatus], [VoucherCode], [DiscountAmount]) VALUES (8, 5, CAST(N'2026-11-13T14:44:57.550' AS DateTime), CAST(540000.00 AS Decimal(18, 2)), N'Chưa thanh toán', N'503,đường abc, xã xyz, tphcm', N'Lê Thảo', N'0923456789', N'thao@gmail.com', N'COD', CAST(0.00 AS Decimal(18, 2)), N'Đã hủy', N'SALE50', CAST(540000.00 AS Decimal(18, 2)))
SET IDENTITY_INSERT [dbo].[Order] OFF
GO
SET IDENTITY_INSERT [dbo].[OrderDetail] ON 

INSERT [dbo].[OrderDetail] ([ID], [ProductID], [OrderID], [Quantity], [UnitPrice], [ProductName], [Size]) VALUES (1, 1, 1, 1, CAST(2500000.00 AS Decimal(18, 2)), N'Nike Air Force 1', N'40')
INSERT [dbo].[OrderDetail] ([ID], [ProductID], [OrderID], [Quantity], [UnitPrice], [ProductName], [Size]) VALUES (2, 2, 2, 2, CAST(1900000.00 AS Decimal(18, 2)), N'Adidas Superstar', N'41')
INSERT [dbo].[OrderDetail] ([ID], [ProductID], [OrderID], [Quantity], [UnitPrice], [ProductName], [Size]) VALUES (3, 6, 3, 1, CAST(4900000.00 AS Decimal(18, 2)), N'Nike SB Dunk Low Premium', N'42')
INSERT [dbo].[OrderDetail] ([ID], [ProductID], [OrderID], [Quantity], [UnitPrice], [ProductName], [Size]) VALUES (4, 4, 4, 1, CAST(4500000.00 AS Decimal(18, 2)), N'Adidas UltraBoost', N'41')
INSERT [dbo].[OrderDetail] ([ID], [ProductID], [OrderID], [Quantity], [UnitPrice], [ProductName], [Size]) VALUES (5, 8, 5, 1, CAST(5300000.00 AS Decimal(18, 2)), N'Nike Winflo 12', N'43')
INSERT [dbo].[OrderDetail] ([ID], [ProductID], [OrderID], [Quantity], [UnitPrice], [ProductName], [Size]) VALUES (6, 27, 6, 1, CAST(2000000.00 AS Decimal(18, 2)), N'Giày chạy bộ nam Nike Invincible 3 DR2615-102', N'43')
INSERT [dbo].[OrderDetail] ([ID], [ProductID], [OrderID], [Quantity], [UnitPrice], [ProductName], [Size]) VALUES (7, 9, 7, 1, CAST(3000000.00 AS Decimal(18, 2)), N'Nike Free Metcon 7', N'40')
INSERT [dbo].[OrderDetail] ([ID], [ProductID], [OrderID], [Quantity], [UnitPrice], [ProductName], [Size]) VALUES (8, 3, 8, 1, CAST(1080000.00 AS Decimal(18, 2)), N'Adida Grand Court 2.0k', N'41')
SET IDENTITY_INSERT [dbo].[OrderDetail] OFF
GO
SET IDENTITY_INSERT [dbo].[Product] ON 

INSERT [dbo].[Product] ([ProductID], [CategoryID], [ProductName], [ProductDecription], [ProductPrice], [ProductImage], [ProductStock], [DiscountPercent]) VALUES (1, 1, N'Nike Air Force 1', NULL, CAST(2500000.00 AS Decimal(18, 2)), N'giay1.jpg', 25, 25)
INSERT [dbo].[Product] ([ProductID], [CategoryID], [ProductName], [ProductDecription], [ProductPrice], [ProductImage], [ProductStock], [DiscountPercent]) VALUES (2, 2, N'Adidas Superstar', NULL, CAST(1900000.00 AS Decimal(18, 2)), N'Adidas Superstar.jpg', 18, 20)
INSERT [dbo].[Product] ([ProductID], [CategoryID], [ProductName], [ProductDecription], [ProductPrice], [ProductImage], [ProductStock], [DiscountPercent]) VALUES (3, 2, N'Adida Grand Court 2.0k', NULL, CAST(1350000.00 AS Decimal(18, 2)), N'adida1.webp', 12, 20)
INSERT [dbo].[Product] ([ProductID], [CategoryID], [ProductName], [ProductDecription], [ProductPrice], [ProductImage], [ProductStock], [DiscountPercent]) VALUES (4, 2, N'Adidas UltraBoost', NULL, CAST(4500000.00 AS Decimal(18, 2)), N'adidas2.jpg', 4, 0)
INSERT [dbo].[Product] ([ProductID], [CategoryID], [ProductName], [ProductDecription], [ProductPrice], [ProductImage], [ProductStock], [DiscountPercent]) VALUES (5, 2, N'Adidas Handball Spezial', NULL, CAST(2800000.00 AS Decimal(18, 2)), N'adidas3.avif', 9, 0)
INSERT [dbo].[Product] ([ProductID], [CategoryID], [ProductName], [ProductDecription], [ProductPrice], [ProductImage], [ProductStock], [DiscountPercent]) VALUES (6, 1, N'Nike SB Dunk Low Premium', NULL, CAST(4900000.00 AS Decimal(18, 2)), N'nike1.webp', 7, 0)
INSERT [dbo].[Product] ([ProductID], [CategoryID], [ProductName], [ProductDecription], [ProductPrice], [ProductImage], [ProductStock], [DiscountPercent]) VALUES (7, 1, N'Nike Air Jordan 1 Elevate Low', NULL, CAST(4800000.00 AS Decimal(18, 2)), N'nike2.webp', 2, 0)
INSERT [dbo].[Product] ([ProductID], [CategoryID], [ProductName], [ProductDecription], [ProductPrice], [ProductImage], [ProductStock], [DiscountPercent]) VALUES (8, 1, N'Nike Winflo 12', NULL, CAST(5300000.00 AS Decimal(18, 2)), N'nike3.avif', 15, 0)
INSERT [dbo].[Product] ([ProductID], [CategoryID], [ProductName], [ProductDecription], [ProductPrice], [ProductImage], [ProductStock], [DiscountPercent]) VALUES (9, 1, N'Nike Free Metcon 7', NULL, CAST(3000000.00 AS Decimal(18, 2)), N'nike4.webp', 1, 0)
INSERT [dbo].[Product] ([ProductID], [CategoryID], [ProductName], [ProductDecription], [ProductPrice], [ProductImage], [ProductStock], [DiscountPercent]) VALUES (10, 1, N'Nike Vomero 18', NULL, CAST(4300000.00 AS Decimal(18, 2)), N'nike5.avif', 20, 12)
INSERT [dbo].[Product] ([ProductID], [CategoryID], [ProductName], [ProductDecription], [ProductPrice], [ProductImage], [ProductStock], [DiscountPercent]) VALUES (11, 3, N'Biti''s Hunter Running Nữ Màu Xanh Dương HSW011000XDG', NULL, CAST(1335000.00 AS Decimal(18, 2)), N'biti1.webp', 10, 10)
INSERT [dbo].[Product] ([ProductID], [CategoryID], [ProductName], [ProductDecription], [ProductPrice], [ProductImage], [ProductStock], [DiscountPercent]) VALUES (12, 3, N'Biti''s Hunter EZ Lift Nam Màu Đen HSM012000DEN', NULL, CAST(1335000.00 AS Decimal(18, 2)), N'biti2.webp', 10, 0)
INSERT [dbo].[Product] ([ProductID], [CategoryID], [ProductName], [ProductDecription], [ProductPrice], [ProductImage], [ProductStock], [DiscountPercent]) VALUES (13, 3, N'Biti''s Hunter X Nam Màu Đen HSM011700DEN', NULL, CAST(1035000.00 AS Decimal(18, 2)), N'biti3.webp', 10, 0)
INSERT [dbo].[Product] ([ProductID], [CategoryID], [ProductName], [ProductDecription], [ProductPrice], [ProductImage], [ProductStock], [DiscountPercent]) VALUES (14, 3, N'Biti''s Hunter X Nam Màu Trắng HSM011700TRG', NULL, CAST(1035000.00 AS Decimal(18, 2)), N'biti4.webp', 10, 0)
INSERT [dbo].[Product] ([ProductID], [CategoryID], [ProductName], [ProductDecription], [ProductPrice], [ProductImage], [ProductStock], [DiscountPercent]) VALUES (15, 3, N'Biti''s Hunter Layered Upper Nữ', NULL, CAST(919000.00 AS Decimal(18, 2)), N'biti5.webp', 10, 0)
INSERT [dbo].[Product] ([ProductID], [CategoryID], [ProductName], [ProductDecription], [ProductPrice], [ProductImage], [ProductStock], [DiscountPercent]) VALUES (16, 3, N'Giày thể thao nữ Biti''s Hunter HSW002900 phối màu', NULL, CAST(1335000.00 AS Decimal(18, 2)), N'biti6.png', 10, 0)
INSERT [dbo].[Product] ([ProductID], [CategoryID], [ProductName], [ProductDecription], [ProductPrice], [ProductImage], [ProductStock], [DiscountPercent]) VALUES (17, 3, N'Giày Đôi Nam - Nữ Biti''s Hunter Street HSM004700XNH/HSW004700XNH', NULL, CAST(685000.00 AS Decimal(18, 2)), N'biti7.jpg', 10, 0)
INSERT [dbo].[Product] ([ProductID], [CategoryID], [ProductName], [ProductDecription], [ProductPrice], [ProductImage], [ProductStock], [DiscountPercent]) VALUES (18, 3, N'Giày Thể Thao Biti''s Nữ BSW003900', NULL, CAST(375000.00 AS Decimal(18, 2)), N'biti8.webp', 10, 0)
INSERT [dbo].[Product] ([ProductID], [CategoryID], [ProductName], [ProductDecription], [ProductPrice], [ProductImage], [ProductStock], [DiscountPercent]) VALUES (19, 3, N'Giày Thể Thao Biti''s Hunter Jogging Nam Màu Xám Lợt HSM004901XAL', NULL, CAST(735000.00 AS Decimal(18, 2)), N'biti9.jpg', 10, 0)
INSERT [dbo].[Product] ([ProductID], [CategoryID], [ProductName], [ProductDecription], [ProductPrice], [ProductImage], [ProductStock], [DiscountPercent]) VALUES (20, 3, N'Biti''s Hunter Verse Màu Đen HSM014500DEN', NULL, CAST(820000.00 AS Decimal(18, 2)), N'biti10.webp', 10, 0)
INSERT [dbo].[Product] ([ProductID], [CategoryID], [ProductName], [ProductDecription], [ProductPrice], [ProductImage], [ProductStock], [DiscountPercent]) VALUES (21, 3, N'Giày thể thao nam Bitis Hunter Street HSM011900', NULL, CAST(735000.00 AS Decimal(18, 2)), N'biti11.jpg', 10, 0)
INSERT [dbo].[Product] ([ProductID], [CategoryID], [ProductName], [ProductDecription], [ProductPrice], [ProductImage], [ProductStock], [DiscountPercent]) VALUES (22, 3, N'Giày thể thao Bitis Hunter HSM012500.XNH', NULL, CAST(799000.00 AS Decimal(18, 2)), N'biti12.png', 10, 0)
INSERT [dbo].[Product] ([ProductID], [CategoryID], [ProductName], [ProductDecription], [ProductPrice], [ProductImage], [ProductStock], [DiscountPercent]) VALUES (23, 3, N'Giày Thể Thao Nữ Biti''s Hunter Street DSWH01300 Màu Đỏ', NULL, CAST(599000.00 AS Decimal(18, 2)), N'biti13.jpg', 10, 0)
INSERT [dbo].[Product] ([ProductID], [CategoryID], [ProductName], [ProductDecription], [ProductPrice], [ProductImage], [ProductStock], [DiscountPercent]) VALUES (24, 3, N'Giày Thể Thao Nam - Nữ Biti''s Hunter X HSM002900KEM', NULL, CAST(1220000.00 AS Decimal(18, 2)), N'biti14.jpg', 10, 0)
INSERT [dbo].[Product] ([ProductID], [CategoryID], [ProductName], [ProductDecription], [ProductPrice], [ProductImage], [ProductStock], [DiscountPercent]) VALUES (26, 1, N'Giày Nike Air Jordan 1 Low SE Coconut Milk Black HQ3437', NULL, CAST(3350000.00 AS Decimal(18, 2)), N'nike7.webp', 10, 0)
INSERT [dbo].[Product] ([ProductID], [CategoryID], [ProductName], [ProductDecription], [ProductPrice], [ProductImage], [ProductStock], [DiscountPercent]) VALUES (27, 1, N'Giày chạy bộ nam Nike Invincible 3 DR2615-102', NULL, CAST(2000000.00 AS Decimal(18, 2)), N'nike8.webp', 9, 0)
INSERT [dbo].[Product] ([ProductID], [CategoryID], [ProductName], [ProductDecription], [ProductPrice], [ProductImage], [ProductStock], [DiscountPercent]) VALUES (28, 1, N'Giày Nike Air Jordan 1 Low Bred Toe 553558-612', NULL, CAST(3890000.00 AS Decimal(18, 2)), N'nike9.webp', 10, 0)
INSERT [dbo].[Product] ([ProductID], [CategoryID], [ProductName], [ProductDecription], [ProductPrice], [ProductImage], [ProductStock], [DiscountPercent]) VALUES (29, 2, N'Giày Adidas Equipment Cloud White Blue Core Black GW8919', NULL, CAST(1100000.00 AS Decimal(18, 2)), N'adidas5.jpg', 10, 0)
INSERT [dbo].[Product] ([ProductID], [CategoryID], [ProductName], [ProductDecription], [ProductPrice], [ProductImage], [ProductStock], [DiscountPercent]) VALUES (30, 2, N'Giày adidas Campus 2', NULL, CAST(2190000.00 AS Decimal(18, 2)), N'adidas6.jpg', 10, 0)
INSERT [dbo].[Product] ([ProductID], [CategoryID], [ProductName], [ProductDecription], [ProductPrice], [ProductImage], [ProductStock], [DiscountPercent]) VALUES (31, 2, N'GIÀY ADIDAS SAMBA OG ''CLOUD WHITE'' ID1480', NULL, CAST(1200000.00 AS Decimal(18, 2)), N'adidas7.webp', 10, 0)
INSERT [dbo].[Product] ([ProductID], [CategoryID], [ProductName], [ProductDecription], [ProductPrice], [ProductImage], [ProductStock], [DiscountPercent]) VALUES (32, 2, N'Giày Golf Da Đinh Liền S2G 26', NULL, CAST(3100000.00 AS Decimal(18, 2)), N'adidas8.avif', 10, 0)
INSERT [dbo].[Product] ([ProductID], [CategoryID], [ProductName], [ProductDecription], [ProductPrice], [ProductImage], [ProductStock], [DiscountPercent]) VALUES (33, 2, N'Giày Adidas Samba OG ''White Hazy Green'' IH2752', NULL, CAST(3100000.00 AS Decimal(18, 2)), N'adidas9.png', 10, 0)
INSERT [dbo].[Product] ([ProductID], [CategoryID], [ProductName], [ProductDecription], [ProductPrice], [ProductImage], [ProductStock], [DiscountPercent]) VALUES (34, 5, N'Giày Thể Thao Speedcat OG Unisex', NULL, CAST(2600000.00 AS Decimal(18, 2)), N'puma1.jpg', 10, 0)
INSERT [dbo].[Product] ([ProductID], [CategoryID], [ProductName], [ProductDecription], [ProductPrice], [ProductImage], [ProductStock], [DiscountPercent]) VALUES (35, 5, N'Palermo Sneakers Unisex', NULL, CAST(2300000.00 AS Decimal(18, 2)), N'puma2.avif', 10, 0)
INSERT [dbo].[Product] ([ProductID], [CategoryID], [ProductName], [ProductDecription], [ProductPrice], [ProductImage], [ProductStock], [DiscountPercent]) VALUES (36, 5, N'Giày Thể Thao Suede Classic Unisex', NULL, CAST(2300000.00 AS Decimal(18, 2)), N'puma3.avif', 10, 0)
INSERT [dbo].[Product] ([ProductID], [CategoryID], [ProductName], [ProductDecription], [ProductPrice], [ProductImage], [ProductStock], [DiscountPercent]) VALUES (37, 5, N'Giày Thể Thao PRM PUMA Tackle Unisex', NULL, CAST(1700000.00 AS Decimal(18, 2)), N'puma4.avif', 10, 0)
INSERT [dbo].[Product] ([ProductID], [CategoryID], [ProductName], [ProductDecription], [ProductPrice], [ProductImage], [ProductStock], [DiscountPercent]) VALUES (38, 5, N'Giày thể thao da lộn Arizona', NULL, CAST(1500000.00 AS Decimal(18, 2)), N'puma5.jpg', 10, 0)
INSERT [dbo].[Product] ([ProductID], [CategoryID], [ProductName], [ProductDecription], [ProductPrice], [ProductImage], [ProductStock], [DiscountPercent]) VALUES (39, 5, N'Giày thể thao Basket Classic XXI', NULL, CAST(1260000.00 AS Decimal(18, 2)), N'puma6.avif', 10, 0)
INSERT [dbo].[Product] ([ProductID], [CategoryID], [ProductName], [ProductDecription], [ProductPrice], [ProductImage], [ProductStock], [DiscountPercent]) VALUES (40, 5, N'Giày Thời Trang PUMA Unisex Palermo Poised Pink-Gold Moon Màu Hồng', NULL, CAST(1750000.00 AS Decimal(18, 2)), N'puma7.webp', 10, 0)
INSERT [dbo].[Product] ([ProductID], [CategoryID], [ProductName], [ProductDecription], [ProductPrice], [ProductImage], [ProductStock], [DiscountPercent]) VALUES (41, 5, N'Giày Puma Suede Bulk Nam - Navy Nâu', NULL, CAST(1890000.00 AS Decimal(18, 2)), N'puma8.jpg', 10, 0)
INSERT [dbo].[Product] ([ProductID], [CategoryID], [ProductName], [ProductDecription], [ProductPrice], [ProductImage], [ProductStock], [DiscountPercent]) VALUES (42, 5, N'Giày Sneaker Chính hãng Puma Palermo Green Vine Clementine - Xanh lá', NULL, CAST(2990000.00 AS Decimal(18, 2)), N'9.webp', 10, 0)
INSERT [dbo].[Product] ([ProductID], [CategoryID], [ProductName], [ProductDecription], [ProductPrice], [ProductImage], [ProductStock], [DiscountPercent]) VALUES (43, 5, N'Puma Speedcat OG Red', NULL, CAST(2450000.00 AS Decimal(18, 2)), N'puma10.webp', 10, 0)
INSERT [dbo].[Product] ([ProductID], [CategoryID], [ProductName], [ProductDecription], [ProductPrice], [ProductImage], [ProductStock], [DiscountPercent]) VALUES (44, 4, N'GIÀY SNEAKER UNISEX ASICS GEL-1130', NULL, CAST(2799000.00 AS Decimal(18, 2)), N'asics1.webp', 10, 0)
INSERT [dbo].[Product] ([ProductID], [CategoryID], [ProductName], [ProductDecription], [ProductPrice], [ProductImage], [ProductStock], [DiscountPercent]) VALUES (45, 4, N'Giày Pickleball Tennis Asics GeL-Resolution X Nam', NULL, CAST(3290000.00 AS Decimal(18, 2)), N'asics2.jpg', 10, 0)
INSERT [dbo].[Product] ([ProductID], [CategoryID], [ProductName], [ProductDecription], [ProductPrice], [ProductImage], [ProductStock], [DiscountPercent]) VALUES (46, 4, N'Giày Asics Solition Speed 3 Huddle Yellow Blue Coast 1042A250-750', NULL, CAST(2800000.00 AS Decimal(18, 2)), N'asic3.webp', 10, 0)
INSERT [dbo].[Product] ([ProductID], [CategoryID], [ProductName], [ProductDecription], [ProductPrice], [ProductImage], [ProductStock], [DiscountPercent]) VALUES (47, 4, N'Giày chạy bộ nam Asics Magic Speed 4', NULL, CAST(3000000.00 AS Decimal(18, 2)), N'asic4.jpg', 10, 0)
INSERT [dbo].[Product] ([ProductID], [CategoryID], [ProductName], [ProductDecription], [ProductPrice], [ProductImage], [ProductStock], [DiscountPercent]) VALUES (48, 4, N'Giày Tennis Asics Court FF 2 White Mako Blue', NULL, CAST(2200000.00 AS Decimal(18, 2)), N'asics6.png', 10, 0)
INSERT [dbo].[Product] ([ProductID], [CategoryID], [ProductName], [ProductDecription], [ProductPrice], [ProductImage], [ProductStock], [DiscountPercent]) VALUES (49, 4, N'Giày Thể Thao Asics Court MZ Cream Black Gum 1203A127-750', NULL, CAST(2540000.00 AS Decimal(18, 2)), N'asics7.webp', 10, 0)
INSERT [dbo].[Product] ([ProductID], [CategoryID], [ProductName], [ProductDecription], [ProductPrice], [ProductImage], [ProductStock], [DiscountPercent]) VALUES (50, 4, N'Giày Tennis Asics Court FF 3 Novak', NULL, CAST(3190000.00 AS Decimal(18, 2)), N'asics5.webp', 10, 0)
INSERT [dbo].[Product] ([ProductID], [CategoryID], [ProductName], [ProductDecription], [ProductPrice], [ProductImage], [ProductStock], [DiscountPercent]) VALUES (51, 2, N'Adidas Advantage', NULL, CAST(1300000.00 AS Decimal(18, 2)), N'adidas4.webp', 10, 0)
SET IDENTITY_INSERT [dbo].[Product] OFF
GO
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (1, 3, 4)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (1, 4, 4)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (1, 5, 5)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (1, 6, 4)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (1, 7, 4)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (1, 8, 4)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (2, 3, 3)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (2, 4, 3)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (2, 5, 3)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (2, 6, 3)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (2, 7, 3)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (2, 8, 3)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (3, 3, 2)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (3, 4, 2)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (3, 5, 2)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (3, 6, 2)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (3, 7, 2)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (3, 8, 2)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (4, 3, 0)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (4, 4, 0)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (4, 5, 4)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (4, 6, 0)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (4, 7, 0)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (4, 8, 0)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (5, 3, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (5, 4, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (5, 5, 4)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (5, 6, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (5, 7, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (5, 8, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (6, 3, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (6, 4, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (6, 5, 2)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (6, 6, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (6, 7, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (6, 8, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (7, 3, 0)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (7, 4, 0)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (7, 5, 2)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (7, 6, 0)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (7, 7, 0)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (7, 8, 0)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (8, 3, 2)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (8, 4, 2)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (8, 5, 5)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (8, 6, 2)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (8, 7, 2)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (8, 8, 2)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (9, 3, 0)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (9, 4, 0)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (9, 5, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (9, 6, 0)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (9, 7, 0)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (9, 8, 0)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (10, 3, 3)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (10, 4, 3)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (10, 5, 5)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (10, 6, 3)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (10, 7, 3)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (10, 8, 3)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (11, 3, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (11, 4, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (11, 5, 5)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (11, 6, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (11, 7, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (11, 8, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (12, 3, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (12, 4, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (12, 5, 5)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (12, 6, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (12, 7, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (12, 8, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (13, 3, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (13, 4, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (13, 5, 5)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (13, 6, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (13, 7, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (13, 8, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (14, 3, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (14, 4, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (14, 5, 5)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (14, 6, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (14, 7, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (14, 8, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (15, 3, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (15, 4, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (15, 5, 5)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (15, 6, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (15, 7, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (15, 8, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (16, 3, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (16, 4, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (16, 5, 5)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (16, 6, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (16, 7, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (16, 8, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (17, 3, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (17, 4, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (17, 5, 5)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (17, 6, 1)
GO
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (17, 7, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (17, 8, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (18, 3, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (18, 4, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (18, 5, 5)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (18, 6, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (18, 7, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (18, 8, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (19, 3, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (19, 4, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (19, 5, 5)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (19, 6, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (19, 7, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (19, 8, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (20, 3, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (20, 4, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (20, 5, 5)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (20, 6, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (20, 7, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (20, 8, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (21, 3, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (21, 4, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (21, 5, 5)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (21, 6, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (21, 7, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (21, 8, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (22, 3, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (22, 4, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (22, 5, 5)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (22, 6, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (22, 7, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (22, 8, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (23, 3, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (23, 4, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (23, 5, 5)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (23, 6, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (23, 7, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (23, 8, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (24, 3, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (24, 4, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (24, 5, 5)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (24, 6, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (24, 7, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (24, 8, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (26, 3, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (26, 4, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (26, 5, 5)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (26, 6, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (26, 7, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (26, 8, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (27, 3, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (27, 4, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (27, 5, 5)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (27, 6, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (27, 7, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (27, 8, 0)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (28, 3, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (28, 4, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (28, 5, 5)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (28, 6, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (28, 7, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (28, 8, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (29, 3, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (29, 4, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (29, 5, 5)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (29, 6, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (29, 7, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (29, 8, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (30, 3, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (30, 4, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (30, 5, 5)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (30, 6, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (30, 7, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (30, 8, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (31, 3, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (31, 4, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (31, 5, 5)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (31, 6, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (31, 7, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (31, 8, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (32, 3, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (32, 4, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (32, 5, 5)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (32, 6, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (32, 7, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (32, 8, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (33, 3, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (33, 4, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (33, 5, 5)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (33, 6, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (33, 7, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (33, 8, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (34, 3, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (34, 4, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (34, 5, 5)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (34, 6, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (34, 7, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (34, 8, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (35, 3, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (35, 4, 1)
GO
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (35, 5, 5)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (35, 6, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (35, 7, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (35, 8, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (36, 3, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (36, 4, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (36, 5, 5)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (36, 6, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (36, 7, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (36, 8, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (37, 3, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (37, 4, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (37, 5, 5)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (37, 6, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (37, 7, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (37, 8, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (38, 3, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (38, 4, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (38, 5, 5)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (38, 6, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (38, 7, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (38, 8, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (39, 3, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (39, 4, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (39, 5, 5)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (39, 6, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (39, 7, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (39, 8, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (40, 3, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (40, 4, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (40, 5, 5)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (40, 6, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (40, 7, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (40, 8, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (41, 3, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (41, 4, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (41, 5, 5)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (41, 6, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (41, 7, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (41, 8, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (42, 3, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (42, 4, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (42, 5, 5)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (42, 6, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (42, 7, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (42, 8, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (43, 3, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (43, 4, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (43, 5, 5)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (43, 6, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (43, 7, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (43, 8, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (44, 3, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (44, 4, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (44, 5, 5)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (44, 6, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (44, 7, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (44, 8, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (45, 3, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (45, 4, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (45, 5, 5)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (45, 6, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (45, 7, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (45, 8, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (46, 3, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (46, 4, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (46, 5, 5)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (46, 6, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (46, 7, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (46, 8, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (47, 3, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (47, 4, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (47, 5, 5)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (47, 6, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (47, 7, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (47, 8, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (48, 3, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (48, 4, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (48, 5, 5)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (48, 6, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (48, 7, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (48, 8, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (49, 3, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (49, 4, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (49, 5, 5)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (49, 6, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (49, 7, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (49, 8, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (50, 3, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (50, 4, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (50, 5, 5)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (50, 6, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (50, 7, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (50, 8, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (51, 3, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (51, 4, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (51, 5, 5)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (51, 6, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (51, 7, 1)
INSERT [dbo].[ProductSize] ([ProductID], [SizeID], [Quantity]) VALUES (51, 8, 1)
GO
SET IDENTITY_INSERT [dbo].[Size] ON 

INSERT [dbo].[Size] ([SizeID], [SizeName]) VALUES (1, N'36')
INSERT [dbo].[Size] ([SizeID], [SizeName]) VALUES (2, N'37')
INSERT [dbo].[Size] ([SizeID], [SizeName]) VALUES (3, N'38')
INSERT [dbo].[Size] ([SizeID], [SizeName]) VALUES (4, N'39')
INSERT [dbo].[Size] ([SizeID], [SizeName]) VALUES (5, N'40')
INSERT [dbo].[Size] ([SizeID], [SizeName]) VALUES (6, N'41')
INSERT [dbo].[Size] ([SizeID], [SizeName]) VALUES (7, N'42')
INSERT [dbo].[Size] ([SizeID], [SizeName]) VALUES (8, N'43')
INSERT [dbo].[Size] ([SizeID], [SizeName]) VALUES (9, N'44')
INSERT [dbo].[Size] ([SizeID], [SizeName]) VALUES (10, N'45')
SET IDENTITY_INSERT [dbo].[Size] OFF
GO
SET IDENTITY_INSERT [dbo].[StockMovement] ON 

INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (1, 1, 3, 4, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (2, 1, 4, 4, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (3, 1, 5, 5, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (4, 1, 6, 4, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (5, 1, 7, 4, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (6, 1, 8, 4, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (7, 2, 3, 3, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (8, 2, 4, 3, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (9, 2, 5, 3, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (10, 2, 6, 3, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (11, 2, 7, 3, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (12, 2, 8, 3, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (13, 3, 3, 2, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (14, 3, 4, 2, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (15, 3, 5, 2, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (16, 3, 6, 2, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (17, 3, 7, 2, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (18, 3, 8, 2, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (19, 4, 5, 4, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (20, 5, 3, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (21, 5, 4, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (22, 5, 5, 4, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (23, 5, 6, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (24, 5, 7, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (25, 5, 8, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (26, 6, 3, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (27, 6, 4, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (28, 6, 5, 2, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (29, 6, 6, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (30, 6, 7, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (31, 6, 8, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (32, 7, 5, 2, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (33, 8, 3, 2, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (34, 8, 4, 2, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (35, 8, 5, 5, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (36, 8, 6, 2, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (37, 8, 7, 2, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (38, 8, 8, 2, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (39, 9, 5, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (40, 10, 3, 3, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (41, 10, 4, 3, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (42, 10, 5, 5, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (43, 10, 6, 3, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (44, 10, 7, 3, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (45, 10, 8, 3, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (46, 11, 3, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (47, 11, 4, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (48, 11, 5, 5, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (49, 11, 6, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (50, 11, 7, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (51, 11, 8, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (52, 12, 3, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (53, 12, 4, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (54, 12, 5, 5, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (55, 12, 6, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (56, 12, 7, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (57, 12, 8, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (58, 13, 3, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (59, 13, 4, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (60, 13, 5, 5, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (61, 13, 6, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (62, 13, 7, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (63, 13, 8, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (64, 14, 3, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (65, 14, 4, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (66, 14, 5, 5, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (67, 14, 6, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (68, 14, 7, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (69, 14, 8, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (70, 15, 3, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (71, 15, 4, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (72, 15, 5, 5, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (73, 15, 6, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (74, 15, 7, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (75, 15, 8, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (76, 16, 3, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (77, 16, 4, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (78, 16, 5, 5, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (79, 16, 6, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (80, 16, 7, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (81, 16, 8, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (82, 17, 3, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (83, 17, 4, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (84, 17, 5, 5, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (85, 17, 6, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (86, 17, 7, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (87, 17, 8, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (88, 18, 3, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (89, 18, 4, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (90, 18, 5, 5, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (91, 18, 6, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (92, 18, 7, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (93, 18, 8, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (94, 19, 3, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (95, 19, 4, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (96, 19, 5, 5, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (97, 19, 6, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (98, 19, 7, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (99, 19, 8, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
GO
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (100, 20, 3, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (101, 20, 4, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (102, 20, 5, 5, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (103, 20, 6, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (104, 20, 7, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (105, 20, 8, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (106, 21, 3, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (107, 21, 4, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (108, 21, 5, 5, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (109, 21, 6, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (110, 21, 7, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (111, 21, 8, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (112, 22, 3, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (113, 22, 4, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (114, 22, 5, 5, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (115, 22, 6, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (116, 22, 7, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (117, 22, 8, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (118, 23, 3, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (119, 23, 4, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (120, 23, 5, 5, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (121, 23, 6, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (122, 23, 7, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (123, 23, 8, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (124, 24, 3, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (125, 24, 4, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (126, 24, 5, 5, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (127, 24, 6, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (128, 24, 7, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (129, 24, 8, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (136, 26, 3, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (137, 26, 4, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (138, 26, 5, 5, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (139, 26, 6, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (140, 26, 7, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (141, 26, 8, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (142, 27, 3, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (143, 27, 4, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (144, 27, 5, 5, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (145, 27, 6, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (146, 27, 7, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (147, 27, 8, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (148, 28, 3, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (149, 28, 4, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (150, 28, 5, 5, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (151, 28, 6, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (152, 28, 7, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (153, 28, 8, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (154, 29, 3, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (155, 29, 4, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (156, 29, 5, 5, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (157, 29, 6, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (158, 29, 7, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (159, 29, 8, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (160, 30, 3, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (161, 30, 4, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (162, 30, 5, 5, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (163, 30, 6, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (164, 30, 7, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (165, 30, 8, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (166, 31, 3, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (167, 31, 4, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (168, 31, 5, 5, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (169, 31, 6, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (170, 31, 7, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (171, 31, 8, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (172, 32, 3, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (173, 32, 4, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (174, 32, 5, 5, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (175, 32, 6, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (176, 32, 7, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (177, 32, 8, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (178, 33, 3, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (179, 33, 4, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (180, 33, 5, 5, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (181, 33, 6, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (182, 33, 7, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (183, 33, 8, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (184, 34, 3, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (185, 34, 4, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (186, 34, 5, 5, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (187, 34, 6, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (188, 34, 7, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (189, 34, 8, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (190, 35, 3, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (191, 35, 4, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (192, 35, 5, 5, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (193, 35, 6, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (194, 35, 7, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (195, 35, 8, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (196, 36, 3, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (197, 36, 4, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (198, 36, 5, 5, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (199, 36, 6, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (200, 36, 7, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (201, 36, 8, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (202, 37, 3, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (203, 37, 4, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (204, 37, 5, 5, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (205, 37, 6, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
GO
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (206, 37, 7, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (207, 37, 8, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (208, 38, 3, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (209, 38, 4, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (210, 38, 5, 5, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (211, 38, 6, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (212, 38, 7, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (213, 38, 8, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (214, 39, 3, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (215, 39, 4, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (216, 39, 5, 5, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (217, 39, 6, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (218, 39, 7, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (219, 39, 8, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (220, 40, 3, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (221, 40, 4, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (222, 40, 5, 5, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (223, 40, 6, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (224, 40, 7, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (225, 40, 8, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (226, 41, 3, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (227, 41, 4, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (228, 41, 5, 5, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (229, 41, 6, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (230, 41, 7, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (231, 41, 8, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (232, 42, 3, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (233, 42, 4, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (234, 42, 5, 5, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (235, 42, 6, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (236, 42, 7, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (237, 42, 8, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (238, 43, 3, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (239, 43, 4, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (240, 43, 5, 5, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (241, 43, 6, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (242, 43, 7, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (243, 43, 8, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (244, 44, 3, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (245, 44, 4, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (246, 44, 5, 5, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (247, 44, 6, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (248, 44, 7, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (249, 44, 8, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (250, 45, 3, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (251, 45, 4, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (252, 45, 5, 5, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (253, 45, 6, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (254, 45, 7, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (255, 45, 8, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (256, 46, 3, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (257, 46, 4, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (258, 46, 5, 5, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (259, 46, 6, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (260, 46, 7, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (261, 46, 8, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (262, 47, 3, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (263, 47, 4, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (264, 47, 5, 5, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (265, 47, 6, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (266, 47, 7, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (267, 47, 8, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (268, 48, 3, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (269, 48, 4, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (270, 48, 5, 5, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (271, 48, 6, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (272, 48, 7, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (273, 48, 8, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (274, 49, 3, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (275, 49, 4, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (276, 49, 5, 5, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (277, 49, 6, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (278, 49, 7, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (279, 49, 8, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (280, 50, 3, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (281, 50, 4, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (282, 50, 5, 5, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (283, 50, 6, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (284, 50, 7, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (285, 50, 8, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (286, 51, 3, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (287, 51, 4, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (288, 51, 5, 5, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (289, 51, 6, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (290, 51, 7, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (291, 51, 8, 1, N'Nhập kho', N'Tồn đầu kỳ', NULL, CAST(N'2026-11-04T18:37:55.193' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (1002, 27, 8, -1, N'Bán hàng', N'Bán cho đơn #6', 6, CAST(N'2026-11-05T13:48:38.903' AS DateTime), N'Lê Thảo')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (1003, 9, 5, -1, N'Bán hàng', N'Bán cho đơn #7', 7, CAST(N'2026-11-10T21:19:46.130' AS DateTime), N'Lê Thảo')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (1004, 9, 5, 1, N'Hoàn kho', N'Hủy đơn #7', 7, CAST(N'2026-11-10T21:20:42.110' AS DateTime), N'admin')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (1005, 3, 6, -1, N'Bán hàng', N'Bán cho đơn #8', 8, CAST(N'2026-11-13T14:44:57.577' AS DateTime), N'Lê Thảo')
INSERT [dbo].[StockMovement] ([MovementID], [ProductID], [SizeID], [Quantity], [MovementType], [Note], [OrderID], [CreatedAt], [CreatedBy]) VALUES (1006, 3, 6, 1, N'Hoàn kho', N'Hủy đơn #8', 8, CAST(N'2026-11-13T14:48:03.773' AS DateTime), N'admin')
SET IDENTITY_INSERT [dbo].[StockMovement] OFF
GO
INSERT [dbo].[User] ([Username], [Password], [UserRole], [IsActive], [CreatedAt], [FullName], [Email], [Phone], [BirthYear]) VALUES (N'admin', N'10000.kkTTyPrcU4hjBbaLXxaepw==.xScQXxUhkQhwW7kgLKLZgJzpxKtuMkYQhspJBjtYDPc=', N'A', 1, CAST(N'2026-11-04T18:20:54.687' AS DateTime), N'Quản trị viên', NULL, NULL, NULL)
INSERT [dbo].[User] ([Username], [Password], [UserRole], [IsActive], [CreatedAt], [FullName], [Email], [Phone], [BirthYear]) VALUES (N'khach01', N'10000.L21oKlhGf8WDEjEKS7/A5Q==.4Fnls3VPPo2DTNjmpfDDDfr2anfaRZ8dNOmSn1biCnM=', N'C', 1, CAST(N'2026-10-29T15:53:11.813' AS DateTime), NULL, NULL, NULL, NULL)
INSERT [dbo].[User] ([Username], [Password], [UserRole], [IsActive], [CreatedAt], [FullName], [Email], [Phone], [BirthYear]) VALUES (N'khach02', N'10000.9DtJefiYbWwKfaoS0xbCUw==.+Fo5/v696UIlIP9WbewwfJ/wfMI59bOJtvnHxH70kxM=', N'C', 1, CAST(N'2026-10-29T15:53:11.813' AS DateTime), NULL, NULL, NULL, NULL)
INSERT [dbo].[User] ([Username], [Password], [UserRole], [IsActive], [CreatedAt], [FullName], [Email], [Phone], [BirthYear]) VALUES (N'khach03', N'10000.8VIRbFvk/MSQ3zS4k03uaw==.dvbdgw4h05op7Drei4LmluNb8pjNZFbEsArHZEZLxXU=', N'C', 0, CAST(N'2026-10-29T15:53:11.813' AS DateTime), NULL, NULL, NULL, NULL)
INSERT [dbo].[User] ([Username], [Password], [UserRole], [IsActive], [CreatedAt], [FullName], [Email], [Phone], [BirthYear]) VALUES (N'thao2', N'10000.kzZQFzGPFcauLdvsywOU2A==.hr6u+s/nhveAcU5d+ixh27ckCkl5RA3paykJzMFIT1I=', N'C', 1, CAST(N'2026-11-05T13:35:45.177' AS DateTime), NULL, NULL, NULL, NULL)
GO
SET IDENTITY_INSERT [dbo].[Voucher] ON 

INSERT [dbo].[Voucher] ([VoucherID], [Code], [DiscountPercent], [Description], [MinOrder], [ExpiryDate], [IsActive], [CreatedAt]) VALUES (1, N'SALE50', 50, N'Giảm 50% cho đơn từ 1.000.000đ', CAST(1000000 AS Decimal(18, 0)), NULL, 1, CAST(N'2026-11-09T18:44:47.300' AS DateTime))
INSERT [dbo].[Voucher] ([VoucherID], [Code], [DiscountPercent], [Description], [MinOrder], [ExpiryDate], [IsActive], [CreatedAt]) VALUES (2, N'VUICUNGMUASAM', 12, N'Vui cùng mua sắm - giảm 12%', CAST(0 AS Decimal(18, 0)), NULL, 1, CAST(N'2026-11-09T18:44:47.300' AS DateTime))
INSERT [dbo].[Voucher] ([VoucherID], [Code], [DiscountPercent], [Description], [MinOrder], [ExpiryDate], [IsActive], [CreatedAt]) VALUES (3, N'GIAMGIA10', 10, N'Giảm 10% cho mọi đơn hàng', CAST(0 AS Decimal(18, 0)), NULL, 1, CAST(N'2026-11-09T18:44:47.300' AS DateTime))
SET IDENTITY_INSERT [dbo].[Voucher] OFF
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ_Category_Name]    Script Date: 16/11/2026 10:38:38 SA ******/
ALTER TABLE [dbo].[Category] ADD  CONSTRAINT [UQ_Category_Name] UNIQUE NONCLUSTERED 
(
	[CategoryName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ_Customer_Username]    Script Date: 16/11/2026 10:38:38 SA ******/
ALTER TABLE [dbo].[Customer] ADD  CONSTRAINT [UQ_Customer_Username] UNIQUE NONCLUSTERED 
(
	[Username] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ_Size_Name]    Script Date: 16/11/2026 10:38:38 SA ******/
ALTER TABLE [dbo].[Size] ADD  CONSTRAINT [UQ_Size_Name] UNIQUE NONCLUSTERED 
(
	[SizeName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ_Voucher_Code]    Script Date: 16/11/2026 10:38:38 SA ******/
ALTER TABLE [dbo].[Voucher] ADD  CONSTRAINT [UQ_Voucher_Code] UNIQUE NONCLUSTERED 
(
	[Code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Order] ADD  CONSTRAINT [DF_Order_Date]  DEFAULT (getdate()) FOR [OrderDate]
GO
ALTER TABLE [dbo].[Order] ADD  CONSTRAINT [DF_Order_Method]  DEFAULT (N'COD') FOR [PaymentMethod]
GO
ALTER TABLE [dbo].[Order] ADD  CONSTRAINT [DF_Order_Ship]  DEFAULT ((30000)) FOR [ShippingFee]
GO
ALTER TABLE [dbo].[Order] ADD  CONSTRAINT [DF_Order_Status]  DEFAULT (N'Chờ xác nhận') FOR [OrderStatus]
GO
ALTER TABLE [dbo].[Order] ADD  CONSTRAINT [DF_Order_Discount]  DEFAULT ((0)) FOR [DiscountAmount]
GO
ALTER TABLE [dbo].[Product] ADD  CONSTRAINT [DF_Product_Stock]  DEFAULT ((0)) FOR [ProductStock]
GO
ALTER TABLE [dbo].[Product] ADD  CONSTRAINT [DF_Product_Discount]  DEFAULT ((0)) FOR [DiscountPercent]
GO
ALTER TABLE [dbo].[ProductSize] ADD  CONSTRAINT [DF_ProductSize_Qty]  DEFAULT ((0)) FOR [Quantity]
GO
ALTER TABLE [dbo].[StockMovement] ADD  CONSTRAINT [DF_SM_CreatedAt]  DEFAULT (getdate()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[User] ADD  CONSTRAINT [DF_User_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[User] ADD  CONSTRAINT [DF_User_CreatedAt]  DEFAULT (getdate()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[Voucher] ADD  CONSTRAINT [DF_Voucher_MinOrder]  DEFAULT ((0)) FOR [MinOrder]
GO
ALTER TABLE [dbo].[Voucher] ADD  CONSTRAINT [DF_Voucher_Active]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[Voucher] ADD  CONSTRAINT [DF_Voucher_Created]  DEFAULT (getdate()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[Customer]  WITH CHECK ADD  CONSTRAINT [FK_User_Customer] FOREIGN KEY([Username])
REFERENCES [dbo].[User] ([Username])
GO
ALTER TABLE [dbo].[Customer] CHECK CONSTRAINT [FK_User_Customer]
GO
ALTER TABLE [dbo].[Order]  WITH CHECK ADD  CONSTRAINT [FK_Order_Customer] FOREIGN KEY([CustomerID])
REFERENCES [dbo].[Customer] ([CustomerID])
GO
ALTER TABLE [dbo].[Order] CHECK CONSTRAINT [FK_Order_Customer]
GO
ALTER TABLE [dbo].[OrderDetail]  WITH CHECK ADD  CONSTRAINT [FK_OD_Order] FOREIGN KEY([OrderID])
REFERENCES [dbo].[Order] ([OrderID])
GO
ALTER TABLE [dbo].[OrderDetail] CHECK CONSTRAINT [FK_OD_Order]
GO
ALTER TABLE [dbo].[OrderDetail]  WITH CHECK ADD  CONSTRAINT [FK_OD_Product] FOREIGN KEY([ProductID])
REFERENCES [dbo].[Product] ([ProductID])
GO
ALTER TABLE [dbo].[OrderDetail] CHECK CONSTRAINT [FK_OD_Product]
GO
ALTER TABLE [dbo].[Product]  WITH CHECK ADD  CONSTRAINT [FK_Pro_Category] FOREIGN KEY([CategoryID])
REFERENCES [dbo].[Category] ([CategoryID])
GO
ALTER TABLE [dbo].[Product] CHECK CONSTRAINT [FK_Pro_Category]
GO
ALTER TABLE [dbo].[ProductSize]  WITH CHECK ADD  CONSTRAINT [FK_PS_Product] FOREIGN KEY([ProductID])
REFERENCES [dbo].[Product] ([ProductID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ProductSize] CHECK CONSTRAINT [FK_PS_Product]
GO
ALTER TABLE [dbo].[ProductSize]  WITH CHECK ADD  CONSTRAINT [FK_PS_Size] FOREIGN KEY([SizeID])
REFERENCES [dbo].[Size] ([SizeID])
GO
ALTER TABLE [dbo].[ProductSize] CHECK CONSTRAINT [FK_PS_Size]
GO
ALTER TABLE [dbo].[StockMovement]  WITH CHECK ADD  CONSTRAINT [FK_SM_Product] FOREIGN KEY([ProductID])
REFERENCES [dbo].[Product] ([ProductID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[StockMovement] CHECK CONSTRAINT [FK_SM_Product]
GO
ALTER TABLE [dbo].[StockMovement]  WITH CHECK ADD  CONSTRAINT [FK_SM_Size] FOREIGN KEY([SizeID])
REFERENCES [dbo].[Size] ([SizeID])
GO
ALTER TABLE [dbo].[StockMovement] CHECK CONSTRAINT [FK_SM_Size]
GO
ALTER TABLE [dbo].[Order]  WITH CHECK ADD  CONSTRAINT [CK_Order_Status] CHECK  (([OrderStatus]=N'Đã hủy' OR [OrderStatus]=N'Hoàn thành' OR [OrderStatus]=N'Đang giao' OR [OrderStatus]=N'Đã xác nhận' OR [OrderStatus]=N'Chờ xác nhận'))
GO
ALTER TABLE [dbo].[Order] CHECK CONSTRAINT [CK_Order_Status]
GO
ALTER TABLE [dbo].[Order]  WITH CHECK ADD  CONSTRAINT [CK_Order_Total] CHECK  (([TotalAmount]>=(0)))
GO
ALTER TABLE [dbo].[Order] CHECK CONSTRAINT [CK_Order_Total]
GO
ALTER TABLE [dbo].[OrderDetail]  WITH CHECK ADD  CONSTRAINT [CK_OD_Qty] CHECK  (([Quantity]>(0)))
GO
ALTER TABLE [dbo].[OrderDetail] CHECK CONSTRAINT [CK_OD_Qty]
GO
ALTER TABLE [dbo].[Product]  WITH CHECK ADD  CONSTRAINT [CK_Product_Discount] CHECK  (([DiscountPercent]>=(0) AND [DiscountPercent]<=(90)))
GO
ALTER TABLE [dbo].[Product] CHECK CONSTRAINT [CK_Product_Discount]
GO
ALTER TABLE [dbo].[Product]  WITH CHECK ADD  CONSTRAINT [CK_Product_Price] CHECK  (([ProductPrice]>(0)))
GO
ALTER TABLE [dbo].[Product] CHECK CONSTRAINT [CK_Product_Price]
GO
ALTER TABLE [dbo].[Product]  WITH CHECK ADD  CONSTRAINT [CK_Product_Stock] CHECK  (([ProductStock]>=(0)))
GO
ALTER TABLE [dbo].[Product] CHECK CONSTRAINT [CK_Product_Stock]
GO
ALTER TABLE [dbo].[ProductSize]  WITH CHECK ADD  CONSTRAINT [CK_PS_Qty] CHECK  (([Quantity]>=(0)))
GO
ALTER TABLE [dbo].[ProductSize] CHECK CONSTRAINT [CK_PS_Qty]
GO
ALTER TABLE [dbo].[User]  WITH CHECK ADD  CONSTRAINT [CK_User_Role] CHECK  (([UserRole]='C' OR [UserRole]='A'))
GO
ALTER TABLE [dbo].[User] CHECK CONSTRAINT [CK_User_Role]
GO
ALTER TABLE [dbo].[Voucher]  WITH CHECK ADD  CONSTRAINT [CK_Voucher_Percent] CHECK  (([DiscountPercent]>=(1) AND [DiscountPercent]<=(90)))
GO
ALTER TABLE [dbo].[Voucher] CHECK CONSTRAINT [CK_Voucher_Percent]
GO
