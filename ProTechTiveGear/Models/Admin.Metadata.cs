using System.ComponentModel.DataAnnotations;

namespace ProTechTiveGear.Models
{
	[MetadataType(typeof(AdminMetadata))]
	public partial class Admin { }

	public class AdminMetadata
	{
		[Required]
		[StringLength(50)]
		public string Username { get; set; }

		[Required]
		[StringLength(100)]
		public string Passwords { get; set; }

		[Required]
		public string Name { get; set; }
	}
}
