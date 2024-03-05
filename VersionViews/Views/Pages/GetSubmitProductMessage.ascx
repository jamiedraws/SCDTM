<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<ClientSiteViewData>" %>
<%@ Import Namespace="Dtm.Framework.ClientSites" %>
<%@ Import Namespace="Dtm.Framework.Base.Models" %>
<% var CampaignName = SettingsManager.ContextSettings["Label.ProductName"]; %>

<div class="__ei __EI">

    <div class="ei__in">

        <fieldset class="ei__fieldset" id="ei">

            <div class="ei__close">
                <span class="icon-cross"></span>
            </div>

            <h3 class="ei__title" data-ei-survey-pre="Are You Sure?" data-ei-survey-term="Thank You">Howdy <%= Request["name"] %>!</h3>

            <div class="ei__group">Thank you for your interest in <%= CampaignName %>. One of our representatives will be in touch shortly.</div>

            <div class="ei__has-nav">
                <div class="ei__grid">
                    <div class="ei__grid__item">
                        <div class="ei__label ei--is-close">
                            <span>Go Back To Website</span>
                        </div>
                    </div>
                </div>
            </div>

        </fieldset>

    </div>

</div>