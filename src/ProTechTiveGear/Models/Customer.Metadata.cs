using System.ComponentModel.DataAnnotations;

namespace ProTechTiveGear.Models
{
	[MetadataType(typeof(CustomerMetadata))]
	public partial class Customer { }

	public class CustomerMetadata
	{
		[Required(ErrorMessage = "Nhập tên đăng nhập")]
		[StringLength(50)]
		public string Username { get; set; }

		[Required(ErrorMessage = "Nhập mật khẩu")]
		[StringLength(100)]
		public string Passwords { get; set; }

		[Required(ErrorMessage = "Nhập họ tên")]
		public string Name { get; set; }

		[EmailAddress(ErrorMessage = "Email không hợp lệ")]
		public string EmailAddress { get; set; }
	}
}
