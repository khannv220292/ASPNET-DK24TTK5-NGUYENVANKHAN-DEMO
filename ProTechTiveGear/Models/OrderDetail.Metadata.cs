using System.ComponentModel.DataAnnotations;

namespace ProTechTiveGear.Models
{
	[MetadataType(typeof(OrderDetailMetadata))]
	public partial class OrderDetail { }

	public class OrderDetailMetadata
	{
		[Required]
		[Range(1, 1000, ErrorMessage = "Số lượng phải từ 1 trở lên")]
		public int Quantity { get; set; }

		[Required]
		public long? ItemId { get; set; }
	}
}
