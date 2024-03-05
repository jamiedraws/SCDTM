#region " Copyright Information... "
/*****************************************************************************
******************************** Default.cs ************************************
******************************************************************************
      PROJECT:  SCDTM 
         FILE:  Default.cs
      PURPOSE:  
 
       AUTHOR:  gserna
 
   This program is proprietary to Digital Target Marketing and is not to 
   be reproduced, used, or disclosed without permission.
 
*****************************************************************************
***************** Copyright © 2010, Digital Target Marketing ****************
*****************************************************************************/
#endregion

using System.Web;
using System.Web.Mvc;
using System.Web.UI;

namespace SCDTM
{
    public partial class _Default : Page
    {
        #region " Events... "

        //TODO: Add reference to the Dtm.Framework
        //TODO: Add reference to the Framework.Models
        //TODO: Add the directories css, images, and views to project from website. 
        //TODO: Add the file web.config from the website.
        public void Page_Load(object sender, System.EventArgs e)
        {
            // Change the current path so that the Routing handler can correctly interpret
            // the request, then restore the original path so that the OutputCache module
            // can correctly process the response (if caching is enabled).

            string originalPath = Request.Path;
            HttpContext.Current.RewritePath(Request.ApplicationPath, false);
            IHttpHandler httpHandler = new MvcHttpHandler();
            httpHandler.ProcessRequest(HttpContext.Current);
            HttpContext.Current.RewritePath(originalPath, false);
        }
        #endregion
    }
}
