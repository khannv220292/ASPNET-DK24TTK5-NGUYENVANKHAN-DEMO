using System.Web.Mvc;
using System.Web.Routing;

namespace ProTechTiveGear
{
	public class RouteConfig
	{
		public static void RegisterRoutes(RouteCollection routes)
		{
			routes.IgnoreRoute("{resource}.axd/{*pathInfo}");

			// URL cũ /AuraStore/... vẫn vào được, nhưng KHÔNG dùng để sinh link (tránh Url.Action ra AuraStore)
			routes.Add("LegacyAuraStore", new IncomingOnlyRoute(
				"AuraStore/{action}/{id}",
				new RouteValueDictionary(new { controller = "Shop", action = "Index", id = UrlParameter.Optional }),
				new MvcRouteHandler()));

			routes.MapRoute(
				name: "Default",
				url: "{controller}/{action}/{id}",
				defaults: new { controller = "Shop", action = "Index", id = UrlParameter.Optional }
			);
		}
	}

	/// <summary>
	/// Route chỉ khớp request vào, không tham gia tạo URL outbound.
	/// </summary>
	public class IncomingOnlyRoute : Route
	{
		public IncomingOnlyRoute(string url, RouteValueDictionary defaults, IRouteHandler routeHandler)
			: base(url, defaults, routeHandler)
		{
		}

		public override VirtualPathData GetVirtualPath(RequestContext requestContext, RouteValueDictionary values)
		{
			return null;
		}
	}
}
