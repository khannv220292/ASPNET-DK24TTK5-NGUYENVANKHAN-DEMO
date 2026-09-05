# ASPNET-DK24TTK5-NGUYENVANKHAN-DEMO

Đồ án học phần **Chuyên đề ASP.NET** — Trường Đại học Trà Vinh.

Website bán laptop **laptop.khannv.vn**.

| Mục | Nội dung |
|---|---|
| **Đề tài** | Xây dựng website bán laptop |
| **Website** | laptop.khannv.vn |
| **Sinh viên** | Nguyễn Văn Khan |
| **Lớp** | DK24TTK5 |
| **Repository** | [ASPNET-DK24TTK5-NGUYENVANKHAN-DEMO](https://github.com/khannv220292/ASPNET-DK24TTK5-NGUYENVANKHAN-DEMO) |

## Công nghệ

- ASP.NET MVC 5, C#, .NET Framework 4.8
- Entity Framework 6 (Database First / EDMX)
- SQL Server (`webgaming`)
- Razor View, Bootstrap, IIS Express
- Visual Studio

## Chức năng chính

**Khách hàng**

- Trang chủ: banner, hãng nổi bật, danh sách laptop, sản phẩm mới
- Tìm kiếm tương đối theo tên (`Name.Contains`)
- Lọc theo hãng / loại; sắp xếp giá, khuyến mãi, mới nhất, bán chạy
- Chi tiết sản phẩm, thêm giỏ hàng, đặt hàng
- Đăng ký / đăng nhập / hồ sơ khách

**Quản trị**

- Đăng nhập Admin
- CRUD sản phẩm, loại, hãng, menu, banner, blog, khách hàng
- Duyệt / xử lý đơn hàng
- Thống kê sản phẩm chưa bán

## Cấu trúc thư mục

```
├── ProTechTiveGear.sln          # Solution Visual Studio
├── ProTechTiveGear/             # Project web ASP.NET MVC
├── packages/                    # NuGet packages
├── Database/                    # Tài nguyên CSDL
├── database.sql                 # Script tạo database webgaming
├── phan1_csdl_webgaming.sql
├── seed_laptop.sql              # Dữ liệu mẫu laptop
├── progress_report/             # Báo cáo tiến độ
└── thesis/                      # Tài liệu đồ án
```

## Yêu cầu môi trường

1. Windows + Visual Studio (workload **ASP.NET and web development**)
2. .NET Framework 4.8 Targeting Pack
3. SQL Server Database Engine (`localhost`)

## Cài đặt và chạy

```bash
git clone https://github.com/khannv220292/ASPNET-DK24TTK5-NGUYENVANKHAN-DEMO.git
cd ASPNET-DK24TTK5-NGUYENVANKHAN-DEMO
```

1. Chạy `database.sql` trên SQL Server để tạo DB **webgaming**
2. Kiểm tra `ProTechTiveGear/Web.config`: `Data Source=localhost;Initial Catalog=webgaming;Integrated Security=True`
3. Mở `ProTechTiveGear.sln` bằng Visual Studio → **F5**
4. Truy cập: http://localhost:51494/AuraStore/Index

## Tài khoản mẫu

| Vai trò | Tài khoản | Ghi chú |
|---|---|---|
| Admin | `Admin` / `1` | Theo `database.sql` (chỉ dùng demo) |
| Khách | Đăng ký trên web | Form Register |

## Lỗi thường gặp

| Hiện tượng | Hướng xử lý |
|---|---|
| `provider failed on Open` | Sai Data Source / SQL chưa chạy / chưa có DB `webgaming` |
| Không load project web | Thiếu workload ASP.NET trên Visual Studio |
| NuGet lỗi | Restore packages |

## Mục đích

Đồ án học phần — phục vụ học tập và bảo vệ môn **Chuyên đề ASP.NET**.
