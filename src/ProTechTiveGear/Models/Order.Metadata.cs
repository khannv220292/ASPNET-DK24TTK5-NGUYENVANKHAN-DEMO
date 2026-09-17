using System.ComponentModel.DataAnnotations;

namespace ProTechTiveGear.Models
{
	[MetadataType(typeof(OrderMetadata))]
	public partial class Order { }

	public class OrderMetadata
	{
		[Required]
		public long? CustomerID { get; set; }

		[Range(0, 999999999)]
		public decimal? Totalprice { get; set; }
	}
}
