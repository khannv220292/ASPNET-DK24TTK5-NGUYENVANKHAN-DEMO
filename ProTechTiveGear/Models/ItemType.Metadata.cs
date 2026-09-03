using System.ComponentModel.DataAnnotations;

namespace ProTechTiveGear.Models
{
	[MetadataType(typeof(ItemTypeMetadata))]
	public partial class ItemType { }

	public class ItemTypeMetadata
	{
		[Required(ErrorMessage = "Nhập loại laptop")]
		[StringLength(30)]
		public string TypeName { get; set; }
	}
}
