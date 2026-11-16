-- Bảng Voucher (mã giảm giá theo %) và 2 cột lưu mã/tiền giảm trên đơn hàng.
-- Chạy cả file trong SSMS (Ctrl+A rồi Execute) với database MyStore.
USE MyStore;
GO

IF OBJECT_ID(N'dbo.Voucher') IS NULL
CREATE TABLE dbo.Voucher (
    VoucherID       INT IDENTITY(1,1) NOT NULL,
    Code            NVARCHAR(30)  NOT NULL,
    DiscountPercent INT           NOT NULL,
    Description     NVARCHAR(200) NULL,
    MinOrder        DECIMAL(18,0) NOT NULL CONSTRAINT DF_Voucher_MinOrder DEFAULT 0,   -- đơn tối thiểu để dùng mã
    ExpiryDate      DATE          NULL,                                                -- NULL = không hết hạn
    IsActive        BIT           NOT NULL CONSTRAINT DF_Voucher_Active DEFAULT 1,
    CreatedAt       DATETIME      NOT NULL CONSTRAINT DF_Voucher_Created DEFAULT GETDATE(),
    CONSTRAINT PK_Voucher PRIMARY KEY CLUSTERED (VoucherID),
    CONSTRAINT UQ_Voucher_Code UNIQUE (Code),
    CONSTRAINT CK_Voucher_Percent CHECK (DiscountPercent BETWEEN 1 AND 90)
);
GO

IF COL_LENGTH('dbo.[Order]', 'VoucherCode') IS NULL
    ALTER TABLE dbo.[Order] ADD VoucherCode NVARCHAR(30) NULL;
GO
IF COL_LENGTH('dbo.[Order]', 'DiscountAmount') IS NULL
    ALTER TABLE dbo.[Order] ADD DiscountAmount DECIMAL(18,2) NOT NULL CONSTRAINT DF_Order_Discount DEFAULT 0;
GO

-- Mã mẫu
INSERT INTO dbo.Voucher (Code, DiscountPercent, Description, MinOrder)
SELECT v.c, v.p, v.d, v.m FROM (VALUES
    (N'SALE50',        50, N'Giảm 50% cho đơn từ 1.000.000đ',        1000000),
    (N'VUICUNGMUASAM', 12, N'Vui cùng mua sắm - giảm 12%',            0),
    (N'GIAMGIA10',     10, N'Giảm 10% cho mọi đơn hàng',              0)
) v(c, p, d, m)
WHERE NOT EXISTS (SELECT 1 FROM dbo.Voucher x WHERE x.Code = v.c);
GO

SELECT * FROM dbo.Voucher;
GO
