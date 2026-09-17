using System.ComponentModel.DataAnnotations;

namespace ProTechTiveGear.Models
{
	/// <summary>DataAnnotations cho entity Item (Database First: gắn MetadataType, không sửa file generate).</summary>
	[MetadataType(typeof(ItemMetadata))]
	public partial class Item { }

	public class ItemMetadata
	{
		[Required(ErrorMessage = "Nhập tên laptop")]
		[StringLength(400, ErrorMessage = "Tên tối đa 400 ký tự")]
		public string Name { get; set; }

		[Range(0, 999999999, ErrorMessage = "Giá mua không hợp lệ")]
		public decimal? PurcharsePrice { get; set; }

		[Required(ErrorMessage = "Nhập giá bán")]
		[Range(1, 999999999, ErrorMessage = "Giá bán phải lớn hơn 0")]
		public decimal SellPrice { get; set; }

		[Range(0, 100000, ErrorMessage = "Số lượng không hợp lệ")]
		public int? Quantity { get; set; }
	}
}
