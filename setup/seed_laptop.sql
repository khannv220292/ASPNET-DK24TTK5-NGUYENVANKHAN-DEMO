-- seed_laptop.sql
-- Dữ liệu mẫu đầy đủ (Item, Menu, Customer, Order, ...) đã nằm trong database.sql
-- (export từ local SQL Server laptopstore). Không cần chạy file này nếu đã chạy database.sql.
--
-- Snapshot row counts (local @ export):
-- Admin=1, Banner=3, Blogs=0, Brand=2, Customer=9,
-- Item=38, ItemType=16, Menu=11, Order=8, OrderDetail=8, Payment=6

USE [laptopstore];
GO
PRINT N'seed_laptop.sql: dữ liệu đã được seed trong database.sql — bỏ qua.';
GO