using System.Collections.Generic;
using System.Linq;
using Dtm.Framework.ClientSites.Web;
using Dtm.Framework.Models;

namespace SCDTM.PageHandlers
{
    public class UpsellNamePageHandler : PageHandler
    {
        #region " Overrides... "

        public override void PreProcessPageActions(IList<PageAction> pageActions)
        {

        }

        public override void PostProcessPageActions()
        {
            //////***************************** WORKING WITH MVC Request Form ************************
            //////***************************************************************************************

            //string cbxChecked;
            //if (((object)(System.Web.HttpContext.Current.Request.Form["controlName"])) == null)
            //    cbxChecked = "false";
            //else
            //    cbxChecked = System.Web.HttpContext.Current.Request.Form["controlName"].ToString();

            //if (cbxChecked == "true")
            //{
            //    if (Order.Items["SKU2"].Quantity >= 1)
            //        OrderManager.UpgradeProduct("SKU1", "SKU3");              
            //}

            ////***************************** WORKING WITH MVC FORM COLLECTION ************************
            ////***************************************************************************************

            //System.Web.Mvc.FormCollection form = new System.Web.Mvc.FormCollection();

            ////Use the formcollection to get the  value for a checkbox or radio button.            
            //if (form["ActionCode1"] == "SKU1")
            //    OrderManager.SetProductQuantity("SKU2", 1);

            //if (form["ActionCode1"] == "SKU2")
            //    OrderManager.SetProductQuantity("SKU3", Order.Items["SKUITEM"].Quantity);

            ////********************************** WORKING WITH CHECKBOXES ****************************
            ////***************************************************************************************

            ////<input type="checkbox" name="ActionCode2" id="cbxSelectProduct" value="SKU" /> code used for checkbox.
            ////If Quantity == 0 that means checkbox is not checked. if it is 1 checkbox is ckecked.
            //if (Order.Items["SKU"].Quantity == 0)
            //{
            //    OrderManager.SetProductQuantity("SKU1", 1);
            //}
            //else
            //{
            //    OrderManager.SetProductQuantity("SKU2", Order.Items["SKUITEM"].Quantity);
            //}

            ////********************************** WORKING WITH TEXTBOXES ****************************
            ////***************************************************************************************

            //System.Web.Mvc.FormCollection form = new System.Web.Mvc.FormCollection();

            ////Use the formcollection to get the  value for a checkbox or radio button.            
            //if (form["ActionCode3"].Trim().ToUpper() == "FREEGIFT")
            //    OrderManager.SetProductQuantity("SKUPROMO", 1);

            ////**************** SHIPPING RULES FOR NON CONTIGUOUS STATES AND CANADA ******************
            ////***************************************************************************************

            ////Creating a list of Non Contiguous States. 
            //IList<string> ExtraShippingStates = StateCodes.NonContiguousStates;

            ////Adding extra state to the list (Example)
            ////ExtraShippingStates.Add("FL");

            //if (Order.ShippingCountryCode == "CAN" || ExtraShippingStates.Any(s => s == Order.ShippingStateCode))
            //{
            //    OrderManager.SetProductQuantity("SKURUSH", 1);
            //}

            ////***************************** SETTING PRODUCT QUANTITY ********************************
            ////***************************************************************************************

            //OrderManager.SetProductQuantity("SKURUSH", 1);
            //OrderManager.SetProductQuantity("SKU", Order.Items["SKUITEM"].Quantity);

            ////*********************************** UPGRADING SKU ************************************
            ////***************************************************************************************

            //OrderManager.UpgradeProduct("SKU1", "SKU2");
            //OrderManager.UpgradeProduct("SKU3", "SKU4");
            //OrderManager.UpgradeProduct("SKU5", "SKU6");

            ////******************************* UPGRADING MULTIPLE SKUS *******************************
            ////***************************************************************************************

            //OrderManager.UpgradeProducts(new string[] { "SKU1", "SKU2" }, "NEWSKU3");
            //OrderManager.UpgradeProducts(new string[] { "SKU4", "SKU5" }, "NEWSKU6");

            ////*********************************** REPLACING SKUS ************************************
            ////***************************************************************************************

            //OrderManager.ReplaceProducts(new string[] { "SKU1", "SKU2" }, "SKU3", 2);
            //OrderManager.ReplaceProducts(new string[] { "SKU4", "SKU5" }, "SKU6", Order.Items["SKUITEM"].Quantity);

            ////***************************************************************************************
        }

        public override void PreRoute()
        {
            ////*********************************** ROUTING CODE **************************************
            ////***************************************************************************************

            //ControllerContext.HttpContext.Response.Redirect("MyUpsell.dtm");

            ////***************************************************************************************
        }
        #endregion
    }
}
