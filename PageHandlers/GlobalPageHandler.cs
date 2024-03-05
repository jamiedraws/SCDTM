using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using Dtm.Framework.ClientSites.Web;
using Dtm.Framework.Models;
using Dtm.Framework.Models.Ecommerce;
using SCDTM.Models;


namespace SCDTM.PageHandlers
{
    public class GlobalPageHandler : PageHandler
    {

        #region " Overrides... "

        public override void PostProcessPageActions()
        {
            //Checking for the pages code based on the main order pages array on line ten.
            if (DtmContext.Page.IsStartPageType)
            {
                Trace.WriteLine("Processing post page actions...");

                var fullName = Form["BillingFullName"] ?? "";
                var email = Form["Email"] ?? "";
                var phone = Form["Phone"] ?? "";
                var company = Form["Company"] ?? "";
                var comments = Form["Comments"] ?? "";

                string[] names = fullName.Trim().Split(' ');

                if (names.Length > 1)
                {
                    Order.BillingFirstName = names[0];
                    Order.BillingLastName = names[1];
                }
                else
                {
                    Order.BillingFirstName = names[0];
                }

                if (!string.IsNullOrEmpty(fullName))
                    OrderManager.AddOrderCode(fullName, "Full Name");

                if (!string.IsNullOrEmpty(phone))
                    OrderManager.AddOrderCode(phone, "Phone");

                if (!string.IsNullOrEmpty(company))
                    OrderManager.AddOrderCode(company, "Company");

                if (!string.IsNullOrEmpty(company))
                    OrderManager.AddOrderCode(comments, "Comments");

                var mailEngine = new EmailEngine();

                mailEngine.SendEmail(
                    "info@digitaltargetmarketing.com",
                    "",
                    "",
                    "ideas@digitaltargetmarketing.com",
                    "Swipe Cart Submission",
                    string.Format(
                        "Name: {0}<br/>" +
                        "Email: {1}<br/>" +
                        "Phone: {2}<br/>" +
                        "Company: {3}<br/>" +
                        "Comments: {4}<br/>",
                        fullName, email, phone, company, comments
                    ));
            }
        }

        #endregion
    }
}
