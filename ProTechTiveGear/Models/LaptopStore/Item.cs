using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace LaptopStore.Models
{
    [Table("Item")]
    public class StoreItem
    {
        [Key]
        public long ID { get; set; }

        [Required(ErrorMessage = "Tên laptop không được để trống")]
        [Display(Name = "Tên Laptop")]
        [StringLength(400)]
        public string Name { get; set; }

        [Display(Name = "Giá nhập")]
        public decimal? PurcharsePrice { get; set; }

        [Required(ErrorMessage = "Giá bán không được để trống")]
        [Range(0, double.MaxValue, ErrorMessage = "Giá bán phải lớn hơn hoặc bằng 0")]
        [Display(Name = "Giá bán (VNĐ)")]
        public decimal SellPrice { get; set; }

        [Display(Name = "Ngày nhập")]
        public DateTime? DateImport { get; set; } = DateTime.Now;

        [Required(ErrorMessage = "Số lượng tồn không được để trống")]
        [Range(0, int.MaxValue, ErrorMessage = "Số lượng không được âm")]
        [Display(Name = "Số lượng tồn")]
        public int? Quantity { get; set; }

        [Display(Name = "Loại máy")]
        public long? TypeID { get; set; }

        [Display(Name = "Hãng sản xuất")]
        public long? BrandID { get; set; }

        [Display(Name = "Hình ảnh")]
        public string Picture { get; set; }

        [Display(Name = "Trạng thái bày bán")]
        public bool? Active { get; set; }

        [Display(Name = "Mô tả chi tiết")]
        public string Describe { get; set; }

        [ForeignKey("BrandID")]
        public virtual StoreBrand Brand { get; set; }

        [ForeignKey("TypeID")]
        public virtual StoreItemType ItemType { get; set; }
    }
}
