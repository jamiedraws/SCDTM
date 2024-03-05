using Dtm.Framework.ClientSites.Web;
using System.Web.Mvc;
using Dtm.Framework.Models;
using System.Web.Routing;
using System.Collections.Generic;
using System.Linq;

namespace SCDTM
{
    public class MvcApplication : ClientSiteApplication
    {
        protected override void ConfigureAdditionalRoutes(RouteCollection routes)
        {
            routes.MapRoute("GetSubmissionForm", "LoadSubmitProductForm", new { controller = "SubmitProduct", action = "RenderSubmitProductPartial", pageCode = "None" });
            routes.MapRoute("GetSubmitProductMessage", "GetConfirmationMessage", new { controller = "SubmitProduct", action = "RenderSubmitMessagePartial", pageCode = "None" });
            base.ConfigureAdditionalRoutes(routes);
        }
    }
}