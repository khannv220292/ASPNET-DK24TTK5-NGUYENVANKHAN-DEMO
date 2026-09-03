using System.ComponentModel.DataAnnotations;

namespace ProTechTiveGear.Models
{
	[MetadataType(typeof(BrandMetadata))]
	public partial class Brand { }

	public class BrandMetadata
	{
		[Required(ErrorMessage = "Nhập tên thương hiệu / tình trạng hàng")]
		[StringLength(40)]
		public string Name { get; set; }
	}
}
