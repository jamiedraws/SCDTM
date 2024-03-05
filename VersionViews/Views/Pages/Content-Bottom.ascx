<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<ClientSiteViewData>" %>
<%@ Import Namespace="Dtm.Framework.ClientSites" %>
<%
	var EnableOrderForm = SettingsManager.ContextSettings["Order.EnableOrderform", true];
    var renderOfferDetailsAboveAcceptOffer = SettingsManager.ContextSettings["Order.RenderOfferDetailsAboveAcceptOffer", false];
	var ShowMobileOrderForm = SettingsManager.ContextSettings["FrameworkJS/CSS.DtmStyle.ShowOrderFormOnMobile", false];
%>

	<%-- // Displays the form top on desktop --%>
	<% if ( !Model.IsMobile ) { %>

		<section id="order" class="l-outer__in bg--none" tabindex="0">

			<div class="snippet--ft top-bottom-padding @x2-pad center-text">

				<% Html.RenderSnippet("FORMTOP"); %>

			</div>

		</section>

	<% } %>


	<section id="content_bottom" class="l-outer__in c-brand block @dv-o-box--top @dv-o-shadow--out">

		<div class="l-outer__section u-mar--center">

			<% if ( !ShowMobileOrderForm ) { %>
				<%-- // Displays the back button on a mobile order form --%>
				<% Html.RenderPartial("MobileOrderFormNav", Model); %>

			<% } %>

			<% if ( EnableOrderForm ) { %>

				<%-- // Displays the order form --%>
				<% Html.RenderPartial("OrderForm", Model); %>

				<%-- // Displays the form product --%>
				<% if ( !Model.IsMobile ) { %>
					<div class="snippet--fp col u-vw--40 u-pad @x2-pad" id="formProduct">

						<% Html.RenderSnippet("FORMPRODUCT"); %>

					</div>

				<% } %>

			<% } else { %>

				<%-- // Displays the out of stock text --%>
				<% Html.RenderPartial("OutOfStock", Model); %>

			<% } %>

		</div>

	<%-- // Displays the offer details on desktop --%>
	<% if ( EnableOrderForm && !Model.IsMobile && !renderOfferDetailsAboveAcceptOffer) { %>

		<div class="u-mar--bottom @x2-mar">

			<div class="snippet--od l-disclaimer o-box u-vw--80 u-mar--center" tabindex="0">

				<% Html.RenderSnippet("OFFERDETAILS"); %>

			</div>

		</div>

	<% } %>

	</section>


	<%-- // Displays the offer details on mobile --%>
	<% if ( EnableOrderForm && Model.IsMobile && !renderOfferDetailsAboveAcceptOffer) { %>

		<div class="c-brand l-outer__in block o-box" tabindex="0">

			<% Html.RenderSnippet("OFFERDETAILS"); %>

		</div>

	<% } %>
