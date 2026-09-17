using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Web;

namespace ProTechTiveGear.Models
{
	public class Encryption
	{

		public static string ComputeHash(string plainText,
									 string hashAlgorithm,
									 byte[] saltBytes)
		{
			// If salt is not specified, generate it on the fly.
			if (saltBytes == null)
			{
				// Define min and max salt sizes.
				int minSaltSize = 4;
				int maxSaltSize = 8;

				// Generate a random number for the size of the salt.
				Random random = new Random();
				int saltSize = random.Next(minSaltSize, maxSaltSize);

				// Allocate a byte array, which will hold the salt.
				saltBytes = new byte[saltSize];

				// Initialize a random number generator.
				RNGCryptoServiceProvider rng = new RNGCryptoServiceProvider();

				// Fill the salt with cryptographically strong byte values.
				rng.GetNonZeroBytes(saltBytes);
			}

			// Convert plain text into a byte array.
			byte[] plainTextBytes = Encoding.UTF8.GetBytes(plainText);

			// Allocate array, which will hold plain text and salt.
			byte[] plainTextWithSaltBytes =
					new byte[plainTextBytes.Length + saltBytes.Length];

			// Copy plain text bytes into resulting array.
			for (int i = 0; i < plainTextBytes.Length; i++)
				plainTextWithSaltBytes[i] = plainTextBytes[i];

			// Append salt bytes to the resulting array.
			for (int i = 0; i < saltBytes.Length; i++)
				plainTextWithSaltBytes[plainTextBytes.Length + i] = saltBytes[i];

			// Because we support multiple hashing algorithms, we must define
			// hash object as a common (abstract) base class. We will specify the
			// actual hashing algorithm class later during object creation.
			HashAlgorithm hash;

			// Make sure hashing algorithm name is specified.
			if (hashAlgorithm == null)
				hashAlgorithm = "";

			// Initialize appropriate hashing algorithm class.
			switch (hashAlgorithm.ToUpper())
			{
				case "SHA1":
					hash = new SHA1Managed();
					break;

				case "SHA256":
					hash = new SHA256Managed();
					break;

				case "SHA384":
					hash = new SHA384Managed();
					break;

				case "SHA512":
					hash = new SHA512Managed();
					break;

				default:
					hash = new MD5CryptoServiceProvider();
					break;
			}

			// Compute hash value of our plain text with appended salt.
			byte[] hashBytes = hash.ComputeHash(plainTextWithSaltBytes);

			// Create array which will hold hash and original salt bytes.
			byte[] hashWithSaltBytes = new byte[hashBytes.Length +
												saltBytes.Length];

			// Copy hash bytes into resulting array.
			for (int i = 0; i < hashBytes.Length; i++)
				hashWithSaltBytes[i] = hashBytes[i];

			// Append salt bytes to the result.
			for (int i = 0; i < saltBytes.Length; i++)
				hashWithSaltBytes[hashBytes.Length + i] = saltBytes[i];

			// Convert result into a base64-encoded string.
			string hashValue = Convert.ToBase64String(hashWithSaltBytes);

			// Return the result.
			return hashValue;
		}

		/// <summary>Salt cố định (giống demo mahoa) để hash tái lập được khi đăng nhập.</summary>
		private static readonly byte[] FixedSalt = Encoding.UTF8.GetBytes("laptop.khannv.vn");

		public static string HashPassword(string plainText)
		{
			if (string.IsNullOrEmpty(plainText)) return plainText;
			return ComputeHash(plainText, "SHA256", FixedSalt);
		}

		/// <summary>
		/// Khớp mật khẩu đã hash hoặc mật khẩu cũ dạng plaintext (tài khoản demo).
		/// </summary>
		public static bool VerifyPassword(string plainText, string storedPassword)
		{
			if (plainText == null || storedPassword == null) return false;
			if (storedPassword == plainText) return true; // legacy plaintext
			try
			{
				return string.Equals(HashPassword(plainText), storedPassword, StringComparison.Ordinal);
			}
			catch
			{
				return false;
			}
		}

		/// <summary>Trả về hash nếu đang lưu plaintext (nâng cấp sau khi đăng nhập thành công).</summary>
		public static string EnsureHashed(string plainText, string storedPassword)
		{
			if (storedPassword == plainText) return HashPassword(plainText);
			return storedPassword;
		}
	}
}