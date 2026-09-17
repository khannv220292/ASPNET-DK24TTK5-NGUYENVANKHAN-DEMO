# Hướng dẫn cài đặt (setup)

Thư mục này chứa script và dữ liệu để dựng lại hệ thống **laptop.khannv.vn** / database **laptopstore**.

## File

| File | Mục đích |
|---|---|
| `database.sql` | **Script chính**: tạo DB `laptopstore` + schema + dữ liệu đầy đủ (export từ local) |
| `phan1_csdl_laptopstore.sql` | Schema các bảng chính (không gồm data) |
| `seed_laptop.sql` | Không cần nếu đã chạy `database.sql` (data đã có sẵn) |
| `fix_missing_images.sql`, `fix_product_images.sql` | Tùy chọn — chỉnh Picture nếu cần (dump đã gồm ảnh) |
| `update_hp.ps1`, `update_hp.py` | Tiện ích cập nhật dữ liệu HP (tùy chọn) |
| `Database/` | Stub trỏ về `database.sql` |

## Snapshot dữ liệu (local SQL Server)

| Bảng | Số dòng |
|---|---|
| Admin | 1 |
| Banner | 3 |
| Blogs | 0 |
| Brand | 2 |
| Customer | 9 |
| Item | 38 |
| ItemType | 16 |
| Menu | 11 |
| Order | 8 |
| OrderDetail | 8 |
| Payment | 6 |

## Các bước

1. Cài **SQL Server** (Database Engine), xác nhận instance `localhost` (hoặc sửa chuỗi kết nối).
2. Mở SQL Server Management Studio, chạy **`database.sql`** (đủ schema + data).
3. Không bắt buộc chạy `seed_laptop.sql` / `fix_*.sql` nếu đã chạy bước 2.
4. Mở `src/ProTechTiveGear/Web.config`, kiểm tra:

```
Data Source=localhost;Initial Catalog=laptopstore;Integrated Security=True
```

5. Mở `src/ProTechTiveGear.sln` bằng Visual Studio, Restore NuGet nếu được hỏi, nhấn F5.

## Tài khoản demo (đồ án)

- Admin: `Admin` / `admin`
- Khách: đăng ký trên trang `/Login/Register`