-- DEPRECATED stub — dùng setup/database.sql (full schema + data laptopstore).
-- File này trước đây tạo DB webgaming với dữ liệu mẫu cũ; đã thay bằng dump local.

USE [master]
GO
IF DB_ID(N'laptopstore') IS NULL
    CREATE DATABASE [laptopstore];
GO
PRINT N'Chạy setup/database.sql để tạo đầy đủ schema + dữ liệu laptopstore.';
GO