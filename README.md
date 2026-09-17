# ASPNET-DK24TTK5-NGUYENVANKHAN-DEMO

Đồ án học phần **Chuyên đề ASP.NET** — Trường Đại học Trà Vinh.

Website bán laptop **[laptop.khannv.vn](http://laptop.khannv.vn)**.

| Mục | Nội dung |
|---|---|
| **Đề tài** | Xây dựng website bán laptop |
| **Website** | laptop.khannv.vn |
| **Sinh viên** | Nguyễn Văn Khan |
| **Lớp** | DK24TTK5 |
| **Email** | khannv220292@tvu-onschool.edu.vn |
| **Điện thoại** | 0978.111.017 |
| **Repository** | [ASPNET-DK24TTK5-NGUYENVANKHAN-DEMO](https://github.com/khannv220292/ASPNET-DK24TTK5-NGUYENVANKHAN-DEMO) |

> Database trên website và trong `Web.config` là **`laptopstore`**.

## Công nghệ

- ASP.NET MVC 5, C#, .NET Framework 4.8
- Entity Framework 6 (Database First / EDMX)
- SQL Server — catalog **`laptopstore`**
- Razor, Bootstrap, IIS Express, Visual Studio

## Chức năng chính (đúng website hiện tại)

**Khách hàng**

- Trang chủ: banner, hãng nổi bật, danh sách laptop, sản phẩm mới
- Tìm kiếm tương đối theo tên (`Name.Contains` / SQL `LIKE`)
- Lọc theo hãng (Asus, Dell, HP, Lenovo…) và loại
- Chi tiết sản phẩm, giỏ hàng, đặt hàng (kể cả khách vãng lai)
- Đăng ký / đăng nhập / hồ sơ

**Quản trị** (`/Admin`, tài khoản `Admin` / `admin`)

- CRUD sản phẩm, loại, hãng, menu, banner
- Danh sách đơn hàng: lọc tab, tìm mã/khách/SĐT, xử lý, chi tiết
- Xuất danh sách đơn ra Excel
- Báo cáo doanh thu (lọc ngày, đã thu / chưa TT, theo sản phẩm)
- Hãng nổi bật trên trang chủ

## Cây thư mục

```
├── README.md
├── setup/                      # Cài đặt và CSDL
│   ├── HUONG_DAN_CAI_DAT.md
│   ├── database.sql            # Script tạo database laptopstore
│   ├── seed_laptop.sql         # Dữ liệu mẫu laptop
│   └── phan1_csdl_laptopstore.sql
├── src/                        # Mã nguồn Visual Studio
│   ├── ProTechTiveGear.sln
│   ├── ProTechTiveGear/
│   └── packages/
├── progress-report/            # Báo cáo tiến độ
└── thesis/                     # Tài liệu đồ án (doc, pdf, html, abs, refs)
```

Nếu clone bản cũ (file `.sln` ngay thư mục gốc): vẫn mở solution đó; chuỗi kết nối trong `Web.config` phải là **Initial Catalog=laptopstore**.

## Yêu cầu môi trường

1. Windows + Visual Studio (workload **ASP.NET and web development**)
2. .NET Framework 4.8 Targeting Pack
3. SQL Server Database Engine (`localhost`)

## Cài đặt và chạy

Chi tiết: `setup/HUONG_DAN_CAI_DAT.md`

```bash
git clone https://github.com/khannv220292/ASPNET-DK24TTK5-NGUYENVANKHAN-DEMO.git
cd ASPNET-DK24TTK5-NGUYENVANKHAN-DEMO
```

1. Chạy `setup/database.sql` trên SQL Server để tạo DB **laptopstore**.
2. (Khuyến nghị) `setup/seed_laptop.sql`.
3. Kiểm tra `src/ProTechTiveGear/Web.config`:

```
Data Source=localhost;Initial Catalog=laptopstore;Integrated Security=True
```

4. Mở `src/ProTechTiveGear.sln` → **F5**.
5. Shop: http://localhost:51494/Shop/Index — Admin: http://localhost:51494/Admin

## Tài khoản mẫu

| Vai trò | Tài khoản | Ghi chú |
|---|---|---|
| Admin | `Admin` / `admin` | Môi trường đồ án |
| Khách | Đăng ký trên web | `/Login/Register` |

## Lỗi thường gặp

| Hiện tượng | Hướng xử lý |
|---|---|
| `provider failed on Open` | SQL chưa chạy / sai Data Source / chưa có DB **`laptopstore`** |
| Không load project web | Thiếu workload ASP.NET |
| NuGet lỗi | Restore packages |

## Mục đích

Đồ án học phần — học tập và bảo vệ môn **Chuyên đề ASP.NET**.
