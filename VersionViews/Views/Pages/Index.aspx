<%@ Page Language="C#" MasterPageFile="~/VersionViews/Views/Layouts/InternalLayout.master" Inherits="System.Web.Mvc.ViewPage<OrderPageViewData>" %>
<%@ Import Namespace="Dtm.Framework.ClientSites" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server"></asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

<% var CampaignName = SettingsManager.ContextSettings["Label.ProductName"]; %>

<main>
	<div class="inner">
		<img src="/images/phone.png" alt="See how it works" class="hero__img">
		<div class="hero__text">
			<h1><span>Turn Your Ads</span> <span>Into a One-Click</span> <span>Purchase With Ease.</span></h1>
			<p>Simply swipe to purchase,<span class="desktop-break"></span> it's that easy!</p>

			<!-- // Swipe HTML -->
			<div class="h1000">
				<div class="swipe-link" id="swipePlaceholder" data-id="#contact"></div>
				<div class="swipe-link" id="demoPlaceholder" data-id="#demo"></div>
			</div>
			<div class="b1000 nav-btns">
				<div class="row-to-center u-vw--100">
					<div class="col u-vw--50">
						<div class="swipe-link" data-id="#contact"></div>
					</div>
					<div class="col u-vw--50">
						<div class="swipe-link" data-id="#demo"></div>
					</div>
				</div>
			</div>


		</div>

		<div class="clearfix"></div>
	</div>
	<div id="demo" class="white-bkg">
		<div class="inner">
			<h1 class="center-text h1000">Enable one click purchasing directly from an ad unit!</h1>
			<div class="u-pad--vert @x2-pad">
				<img src="/images/walmart-steps.png" alt="See the steps to checkout" class="center-margin width-at-100 h1000">
				<div class="b1000 padding @x2-pad mobile-section">
					<h1 class="center-margin center-text">Here's how it works!</h1>
					<div class="block">
						<div class="block">
							<img class="responsive-img" src="/images/MobileView.gif?appV=<%= DtmContext.ApplicationVersion %>" alt="See the steps">
						</div>
					</div>
				</div>
			</div>
			<div class="ar h1000">
				<div class="arrow arrow-1">
					<img src="/images/arrow-1.png" alt="">
					<h2 class="num">1</h2>
					<h1>Here's<br>how it<br>works!</h1>
				</div><!--
				--><div class="arrow arrow-2">
					<img src="/images/arrow-2.png" alt="">
					<h2 class="num">2</h2>
					<p><%= CampaignName %> can be added to any digital ad unit, taking the consumer from the ad unit to purchase in an instant!</p>
				</div><!--
				--><div class="arrow arrow-3">
					<h3 class="num">3</h3>
					<img src="/images/arrow-3.png" alt="">
					<p>
						With a simple <strong>SWIPE</strong>, we automatically add the product to the retailers cart using their API.<br><strong>It's that easy!</strong>
					</p>
				</div>
				<ul class="mobile-list">
					<li><%= CampaignName %> can be added to any digital ad unit, taking the consumer from the ad unit to purchase in an instant!</li>
					<li>With a simple <strong>SWIPE</strong>, we automatically add the product to the retailers cart using their API</li>
					<li><strong>It's that easy!</strong></li>
				</ul>
			</div><!-- end arrow section -->
			<div id="associates" class="text text--left clearfix">
				<img class="min-903" src="/images/associates.png" alt="Swipe Cart associates">
				<h4>We've figured out the hard part.</h4>
				<p>This coding works seamlessly within Amazon, Walmart, Walgreens, PayPal, Shopify and more!. <%= CampaignName %> can be used in all types of digital ad units. Turning your ad into a measurable return on investment.</p>
				<p>Whether your goal is to increase in-store or online retail conversions with the big players like Walmart, Target and Bed Bath and Beyond, or you are just looking for a fresh way to get the consumer from impression to sale quicker and easier, <%= CampaignName %> is your solution. Now you're not just getting reach and impressions, hoping they convert, you are helping to close the sale.</p>
				<img src="/images/associates.png" class="max-903" alt="Swipe Cart associates">
			</div><!-- end .text -->
			<div id="how" class="text text--right clearfix">
				<img class="min-903" src="/images/computer.png" alt="See how it works on desktop computers">
				<h4>The idea is simple. Let them purchase!</h4>
				<p>If the consumer sees your ad whether that's video, display or social a good amount of those eyeballs are ready to purchase right then and there. Let them! Sometimes as advertisers and marketers, we end up overselling someone who is already sold. Too much info, too much copy, too many steps. Close the sale and let them purchase!</p>
				<p>It's really that easy. <%= CampaignName %> lets consumers seamlessly go for ad unit to sale in an instant. Simply swipe right to add to the cart of your choice from the ad unit.</p>
				<img src="/images/computer.png" class="max-903" alt="See how it works on desktop computers">
			</div><!-- end .text -->
			<div id="api" class="text text--left api clearfix">
				<img class="min-903" src="/images/api.png" alt="Many API options available">
				<h4>Many API options are available with <span class="desktop-break"></span> more being onboarded.</h4>
				<p>If you are an advertiser and don't see the cart option you are looking for, <a href="#contact">contact us</a>. If we aren't already working on setting it up, we can be!</p>
				<p>If you are a retailer or distributor and would like a <%= CampaignName %> API dedicated to your brand added to our platform, no problem. Just <a href="#contact">contact us</a> and we will get it started.</p>
				<img src="/images/api.png" class="max-903" alt="Many API options available">
			</div><!-- end .text -->
		</div>
	</div><!-- end white-bkg area -->

</main>

</asp:Content>
