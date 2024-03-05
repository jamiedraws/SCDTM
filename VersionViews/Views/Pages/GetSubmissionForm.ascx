<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<ClientSiteViewData>" %>
<%@ Import Namespace="Dtm.Framework.Base.Models" %>
<%@ Import Namespace="Dtm.Framework.ClientSites" %>

<div class="modal modal--contact center-text modal--is-visible">
    <h1 class="contact__title">Contact Us to Get Swiped!</h1>
    <h2 class="contact__desc">Send us your info and a representative will contact you shortly.</h2>

    <div class="c-brand--form c-brand--form--will-slide width-at-100">
        <form id="productForm" method="post" onsubmit="return false;">
            <div class="vse">
                <%= Html.ValidationSummary("The following errors have occurred:") %>
            </div>
            <%= Html.Hidden("OrderType", "None") %>
            <div>
                <input type="text" class="width-at-100 block" id="BillingFullName" name="BillingFullName" placeholder="*Name">
            </div>
            <div class="u-mar--vert">
                <input type="text" class="width-at-100 block" id="Email" name="Email" placeholder="*Email">
            </div>
            <div class="u-mar--vert">
                <input type="text" class="width-at-100 block" id="Phone" name="Phone" placeholder="*Phone">
            </div>
            <div class="u-mar--vert">
                <input type="tel" class="width-at-100 block" id="Company" name="Company" placeholder="Company">
            </div>
            <div class="u-mar--vert">
                <textarea id="Comments" name="Comments" placeholder="Anything Else?"></textarea>
            </div>
            <div class="contact__submit">
                <button type="submit" id="AcceptOfferButton" class="submit__no-swipe" name="acceptOffer">Submit</button>
            </div>
        </form>
    </div>
</div>