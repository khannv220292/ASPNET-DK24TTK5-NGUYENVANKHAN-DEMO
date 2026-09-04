using System;
using System.Text.RegularExpressions;

namespace ProTechTiveGear.Models
{
	public class LaptopCardInfo
	{
		public string Cpu { get; set; }
		public string Ram { get; set; }
		public string Storage { get; set; }
		public string Gpu { get; set; }
		public string Display { get; set; }
		public string Brand { get; set; }
		public decimal OldPrice { get; set; }
		public int DiscountPercent { get; set; }
		public bool IsHot { get; set; }

		public static LaptopCardInfo From(Item item)
		{
			var text = ((item.Name ?? "") + " " + StripHtml(item.Describe)).Replace('\u00A0', ' ');
			var brand = item.Brand != null && !string.IsNullOrWhiteSpace(item.Brand.Name)
				? item.Brand.Name
				: GuessBrand(item.Name);

			decimal oldPrice = item.SellPrice;
			if (item.PurcharsePrice.HasValue && item.PurcharsePrice.Value > item.SellPrice)
				oldPrice = item.PurcharsePrice.Value;
			else
				oldPrice = Math.Round(item.SellPrice * 1.08m / 1000m) * 1000m;

			int pct = 0;
			if (oldPrice > item.SellPrice)
				pct = (int)Math.Round((double)((oldPrice - item.SellPrice) / oldPrice * 100m));

			return new LaptopCardInfo
			{
				Brand = brand,
				Cpu = Match(text, @"(?:Intel\s*)?(?:Core\s*)?(?:Ultra\s*\d[\w-]*)|(?:i[3579][-\s]?\d{3,5}\w*)|(?:Ryzen\s*\d\s*[\w-]*)|(?:R[3579]-\d{4,5}\w*)|(?:Celeron\s*\w+)|(?:Pentium\s*\w+)") ?? "Intel",
				Ram = Compact(Match(text, @"\b(?:8|16|32|64)\s*GB\b") ?? "8GB"),
				Storage = Compact(Match(text, @"\b(?:256|512|1024)\s*GB\b") ?? Match(text, @"\b1\s*TB\b") ?? "256GB"),
				Gpu = Match(text, @"(?:RTX\s*\d{3,4}\w*)|(?:GTX\s*\d{3,4}\w*)|(?:Iris\s*Xe)|(?:UHD(?:\s*Graphics)?)|(?:Radeon\s*[\w\s]+)|(?:MX\s*\d{3})") ?? "Onboard",
				Display = Match(text, @"(\d{2}(?:\.\d)?)\s*(?:inch|""|”|FHD|WUXGA|OLED|IPS)") is string d ? d : GuessInch(text),
				OldPrice = oldPrice,
				DiscountPercent = pct,
				IsHot = (item.Quantity ?? 0) >= 8
			};
		}

		static string GuessInch(string text)
		{
			var m = Regex.Match(text, @"\b(13\.3|14\.0|14|15\.6|16\.0|16|17\.3)\b");
			return m.Success ? m.Value + "\"" : "15.6\"";
		}

		static string GuessBrand(string name)
		{
			if (string.IsNullOrEmpty(name)) return "LAPTOP";
			var n = name.ToUpperInvariant();
			if (n.Contains("LENOVO") || n.Contains("THINKPAD") || n.Contains("IDEAPAD")) return "LENOVO";
			if (n.Contains("DELL") || n.Contains("INSPIRON") || n.Contains("XPS") || n.Contains("LATITUDE")) return "DELL";
			if (n.Contains("HP") || n.Contains("ELITEBOOK") || n.Contains("PROBOOK") || n.Contains("OMNIBOOK") || n.Contains("VICTUS")) return "HP";
			if (n.Contains("ASUS") || n.Contains("TUF") || n.Contains("ROG") || n.Contains("VIVOBOOK")) return "ASUS";
			if (n.Contains("ACER") || n.Contains("NITRO") || n.Contains("SWIFT")) return "ACER";
			if (n.Contains("MSI")) return "MSI";
			if (n.Contains("GIGABYTE")) return "GIGABYTE";
			return "LAPTOP";
		}

		static string StripHtml(string html)
		{
			if (string.IsNullOrEmpty(html)) return "";
			return Regex.Replace(html, "<[^>]+>", " ");
		}

		static string Compact(string value)
		{
			return Regex.Replace((value ?? "").Trim(), @"\s+", "").ToUpperInvariant();
		}

		static string Match(string text, string pattern)
		{
			var m = Regex.Match(text, pattern, RegexOptions.IgnoreCase);
			if (!m.Success) return null;
			return Regex.Replace(m.Value.Trim(), @"\s+", " ");
		}
	}
}
