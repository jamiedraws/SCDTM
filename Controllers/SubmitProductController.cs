using Dtm.Framework.Base.Controllers;
using Dtm.Framework.Base.Models;
using Dtm.Framework.ClientSites.Web;
using Dtm.Framework.ClientSites.Web.Controllers;
using Dtm.Framework.Models.Ecommerce;
using Dtm.Framework.Models.Ecommerce.Repositories;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
using System.Data.SqlClient;
using System.Linq;
using System.Web.Caching;
using System.Web.Mvc;

namespace SCDTM.Controllers
{
    public class SubmitProductController : ClientSiteController <ClientSiteViewData>
    {
        [HttpPost]
        public ActionResult RenderSubmitProductPartial()
        {
            return View("GetSubmissionForm");
        }

        [HttpPost]
        public ActionResult RenderSubmitMessagePartial()
        {
            return View("GetSubmitProductMessage", Model);
        }
    }
}