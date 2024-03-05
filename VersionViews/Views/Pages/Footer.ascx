<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<ClientSiteViewData>" %>
<%@ Import Namespace="Dtm.Framework.ClientSites" %>


	<footer class="@print-only-hide clearfix">

        <div id="contact" class="contact"></div>
		&copy;<% Html.RenderPartial("Year", Model); %> SwipeCart&trade; All Rights Reserved
		<img src="/images/logo-footer.png" alt="Swipe Cart">
        <p class="copyright">Patent Pending<br>As an Amazon Associate I earn from qualifying purchases.</p>
	</footer>




	<%-- // @JS-FOOTER --%>
	<% switch ( DtmContext.Page.IsStartPageType ) { %>

		<% case false: %>


			<% break; %>
		<% default: %>

		    <% Html.RenderPartial("Scripts"); %>
		    <script src="/js/jquery.slicknav.min.js"></script>
		    <script src="/shared/swipe/js/swipe.min.js?appV=<%= DtmContext.ApplicationVersion %>"></script>
            <script>
                var $body = $('body');
                var $html = $('html');
                var $contact = $('#contact');
                var $nav = $('.nav-btns');
                var swipe__scroll, swipe__demo, swipe__submit, $ei;
                var isValidLead = false;
                var isScrolling = false;

                $(function(){
                    $('#menu').slicknav({
                        label:'',
                        beforeOpen: function () {
                            $('header, footer, main').css('position','relative').css('left','-40%');
                            $('.slicknav_menu').css('background','#3c3c3c').css('height','100%');
                        },
                        afterClose: function () {
                            $('header, footer, main').css('left','0');
                            $('.slicknav_menu').css('background','none').css('height','auto');
                        },
                        closeOnClick: true,
                        duration: 0
                    });
                });

                function validateFormOverride(event) {
                    return validateForm(event);
                }

                function onFormPostValidation(event) {
                    var $form = $('.modal--contact');
                    var $BillingFullName = $form.find('#BillingFullName');
                    var $Email = $form.find('#Email');
                    var $Phone = $form.find('#Phone');
                    var $Company = $form.find('#Company');
                    var $Comments = $form.find('#Comments');
                    var $swipe__submit = $form.find('.contact__submit .swipe');

                    var errors = [];

                    if (isEmpty("BillingFullName")) {
                        errors.push('Full name is required');
                        $BillingFullName.addClass('has-error');
                    } else {
                        $BillingFullName.removeClass('has-error');
                    }
                    if (isEmpty("Email")) {
                        errors.push('Email is required');
                        $Email.addClass('has-error');
                    } else {
                        $Email.removeClass('has-error');
                    }
                    if (isEmpty("Phone")) {
                        errors.push('Phone Number is required');
                        $BillingFullName.addClass('has-error');
                    } else {
                        $BillingFullName.removeClass('has-error');
                    }
                    // deactivate button to be clickable
                    $swipe__submit.addClass('swipe--not-clickable');
                    // animate button to end
                    swipe__submit.gotoEnd();

                    // check if there are errors
                    if ( errors.length !== 0 ) {
                        // display validation message
                        swipe__submit.setBeforeState();

                        setTimeout(function () {
                            // animate button to start
                            swipe__submit.gotoStart();
                            // activate button to be clickable
                            $swipe__submit.removeClass('swipe--not-clickable');
                        }, 1000);
                    } else {
                        // display success message
                        swipe__submit.setAfterState();

                        setTimeout(function () {
                            // animate button to start
                            swipe__submit.gotoStart();
                            // activate button to be clickable
                            $swipe__submit.removeClass('swipe--not-clickable');
                        }, 3000);

                        // get confirmation modal
                        if ( typeof $ei === 'undefined' ) {
                            $.post('/GetConfirmationMessage', { name : $BillingFullName.val() }, function (html) {
                                // append the confirmation to the page
                                $body.append(html);
                                $ei = $('.__ei');
                                // animate the confirmation in
                                $ei.addClass('ei--is-active');
                                //setTimeout(closeModal, 10000);
                            });
                        } else {
                            // animate the confirmation in
                            $ei.removeClass('ei--is-hidden-and-out').addClass('ei--is-active');
                        }
                        //submit form values
                        submitForm($BillingFullName.val(), $Email.val(), $Phone.val(), $Company.val(), $Comments.val());
                        // clear all values
                        $form.find('input, textarea').val('');
                        // clear validation errors
                        $form.find('.vse').html('');
                    }

                    return errors;
                }

                function closeModal () {
                    $ei.removeClass('ei--is-active');

                    $ei.one('transitionend', function () {
                        $ei.addClass('ei--is-hidden-and-out');
                    });
                }

                function undoMaxHeight () {
                    $('.modal--contact .c-brand--form').removeClass('c-brand--form--will-slide').addClass('has-no-max-height');
                }

                (function () {
                    // when framework js is ready
                    $html.on('dtm/fwjs', function () {
                        var showContactForm = false;


                        if (window && window.location && window.location.href && window.location.href.indexOf("contact-form=1") >= 0) {
                            showContactForm = true;
                            // get contact form
                            $.post('/LoadSubmitProductForm', function (html) {
                                var $form = $('<div/>', { html: html });

                                var form__submit = new DTMSwipeCartTemplate({
                                    $target: $form.find('.contact__submit'),
                                    insertionMethod: 'appendTo',
                                    data: {
                                        initState: 'Submit',
                                        termState: '{initState}',
                                        beforeState: 'Validating...',
                                        afterState: 'Submitted!'
                                    }
                                }).done(function ($swipe) {
                                    // add support for swipe
                                    $form.addClass('modal--has-swipe');
                                    // insert form onto the page
                                    $contact.html($form);
                                    $swipe.attr('data-swipe-api-key', 'contactSubmit');
                                    // sync swipe interaction
                                    swipe__submit = new DTMSwipeCart($swipe)['contactSubmit'];

                                    if (!isScrolling) {
                                        isScrolling = true;
                                        // scroll to destination
                                        $("#contact").eflex({
                                            type: 'scroll',
                                            trigger: true,
                                            onAfter: function () {
                                                isScrolling = false;
                                            }
                                        });
                                    }
                                });
                            });
                        }

                        // set lazy load on the form
                        _dtm.animateToTargetOnScroll({
                            target : $contact,
                            distance : 1,
                            callbackInRange : function () {
                                // if contact form doesn't exist
                                if ( !showContactForm ) {
                                    // set status to shown
                                    showContactForm = true;
                                    // get contact form
                                    $.post('/LoadSubmitProductForm', function (html) {
                                        var $form = $('<div/>', { html : html });

                                        var form__submit = new DTMSwipeCartTemplate({
                                            $target : $form.find('.contact__submit'),
                                            insertionMethod : 'appendTo',
                                            data : {
                                                initState : 'Submit',
                                                termState : '{initState}',
                                                beforeState : 'Validating...',
                                                afterState : 'Submitted!'
                                            }
                                        }).done(function ($swipe) {
                                            // add support for swipe
                                            $form.addClass('modal--has-swipe');
                                            // insert form onto the page
                                            $contact.html($form);
                                            $swipe.attr('data-swipe-api-key', 'contactSubmit');
                                            // sync swipe interaction
                                            swipe__submit = new DTMSwipeCart($swipe)['contactSubmit'];
                                        });
                                    });
                                }
                            }
                        });

                        _dtm.animateToTargetOnScroll({
                            target: $contact,
                            distance : 1,
                            callbackInRange: function () {
                                $nav.css({ 'opacity': 0, 'pointer-events': 'none' });
                                if ( !$nav.hasClass('new-btns--is-hidden') ) {
                                    $nav.addClass('new-btns--is-hidden');
                                }
                            },
                            callbackOutRange: function () {
                                $nav.css({ 'opacity': 1, 'pointer-events': 'all' });
                                if ( $nav.hasClass('new-btns--is-hidden') ) {
                                    $nav.removeClass('new-btns--is-hidden');
                                }
                            }
                        });
                    });

                    // initialize new swipe button
                    var formTemplate = new DTMSwipeCartTemplate({
                        $target : $('[data-id="#contact"]'),
                        insertionMethod : 'appendTo',
                        url : {
                            initIcon : '{termIcon}',
                            termIcon : '/shared/swipe/images/arrow-icon-init.svg'
                        },
                        data : {
                            initState : 'Get Started Now',
                            termState : '{initState}',
                            beforeState : 'Scroll Down',
                            afterState : 'Good Job!'
                        }
                    // promise method : bind template to swipe interaction
                    }).done(function ($swipe) {
                        // initialize new swipe functionality
                        swipe__scroll = new DTMSwipeCart($swipe);
                    });

                    // initialize new swipe button
                    var demoTemplate = new DTMSwipeCartTemplate({
                        $target : $('[data-id="#demo"]'),
                        insertionMethod : 'appendTo',
                        url : {
                            initIcon : '/shared/swipe/images/arrow-icon-init.svg',
                            termIcon : '{initIcon}'
                        },
                        data : {
                            initState : 'How It Works',
                            termState : '{initState}',
                            beforeState : 'Scroll Down',
                            afterState : 'Good Job!'
                        }
                    // promise method : bind template to swipe interaction
                    }).done(function ($swipe) {
                        // initialize new swipe functionality
                        swipe__demo = new DTMSwipeCart($swipe);
                    });

                    // user role : when user wants to close the modal by the close button
                    $body.on('click', '.ei__close, .ei--is-close', closeModal);

                    // user role : when user wants to close the modal by the background
                    $body.on('click', '.ei__in', function (e) {
                        if ( e.currentTarget === e.target && !$ei.hasClass('ei--is-selected') ) {
                            closeModal();
                        }
                    });

                    // use case : any device that supports touch
                    // public event : form validation
                    $body.on('swipe:end', '.swipe-link .swipe', function (e) {
                        // get id
                        var id = $(this).parent().data('id');

                        // lock swipe
                        e.swipe.setLock = true;
                        // display validation message
                        e.swipe.setBeforeState();

                        if ( !isScrolling ) {
                            isScrolling = true;
                            // scroll to destination
                            $(id).eflex({
                                type : 'scroll',
                                trigger : true,
                                onAfter : function () {
                                    isScrolling = false;
                                }
                            });
                        }

                        // example validation cycle
                        setTimeout(function () {
                            // display success message
                            e.swipe.setAfterState();

                            setTimeout(function () {
                                // unlock swipe
                                e.swipe.setLock = false;
                                // animate button to start
                                e.swipe.gotoStart();
                            }, 3000);
                        }, 3000);
                    });

                    // use case : any device that supports mouse wheel
                    $body.on('swipe:click', '.swipe-link .swipe', function (e) {
                        // deactivate button to be clickable
                        $(e.target).addClass('swipe--not-clickable');
                        // animate button to end
                        e.swipe.gotoEnd();
                        // display validation message
                        e.swipe.setBeforeState();

                        // example validation cycle
                        setTimeout(function () {
                            // display success message
                            e.swipe.setAfterState();

                            setTimeout(function () {
                                // animate button to start
                                e.swipe.gotoStart();
                                // activate button to be clickable
                                $(e.target).removeClass('swipe--not-clickable');
                            }, 3000);
                        }, 3000);
                    });

                    // when submit swipe is clicked or swiped
                    $body.one('swipe:end', '.contact__submit .swipe', undoMaxHeight);

                    // when submit swipe is clicked or swiped
                    $body.on('click', '.contact__submit .swipe', function () {
                        swipe__submit.gotoEnd();
                    });
                    $body.on('swipe:end', '.contact__submit .swipe', validateFormOverride);
                })();

                function submitForm(name, email, phone, company, comments) {
                    $.post('Index.dtm', {
                        BillingFullName: name,
                        Email: email,
                        Phone: phone,
                        Company: company,
                        Comments: comments,
                        acceptOffer: 'acceptOffer',
                        RemoteType: 'ProductLead',
                        CardType: 'none'
                    }, function (data) {
                    });
                }
            </script>

            <%-- Html.RenderSnippet("ORDERFORMSCRIPT"); --%>
            <script type="text/javascript">
                var verifyBState = false;
                var verifyBZip = false;
                var verifyBStreet = false;
                var verifyBCity = false;
                var verifyBCountry = false;
                var verifyPhone = false;
                var verifyBFullName = false;
                var verifyEmail = false;
            </script>

            <style>
                .contact {
                    min-height: 50rem;
                    transition: all 500ms ease-in-out;
                }

                .contact--is-closed {
                    min-height: 0;
                }

                .contact--is-closed .modal--has-swipe {
                    display: none;
                }

                .modal--contact .vse {
                    text-align: left;
                }

                .contact__submit .swipe {
                    width: 60%;
                    margin: auto;
                }

                .contact__submit .swipe__init__text {
                    padding-left: 5%;
                }

                .modal--has-swipe .submit__no-swipe {
                    display: none;
                }

                .modal--contact .c-brand--form {
                    transition: all 250ms ease-in-out;
                    overflow: hidden;
                }

                .modal--is-visible .c-brand--form--will-slide {
                    max-height: 0;
                    opacity: 0;
                    -webkit-animation: slideDown 300ms ease-in-out 300ms forwards;
                    animation: slideDown 300ms ease-in-out 300ms forwards;
                }

                .modal--is-visible .contact__title,
                .modal--is-visible .contact__desc {
                    opacity: 0;
                    -webkit-animation: fadeSlideIn 250ms ease-in-out forwards;
                    animation: fadeSlideIn 250ms ease-in-out forwards;
                }

                .modal--is-visible .contact__title {
                    -webkit-transform: translateX(10%);
                    transform: translateX(10%);
                }

                .modal--is-visible .contact__desc {
                    -webkit-transform: translateX(-10%);
                    transform: translateX(-10%);
                    -webkit-animation-delay: 300ms;
                    animation-delay: 300ms;
                }

                .modal--is-invisible .c-brand--form {
                    max-height: 60rem;
                    -webkit-animation: slideUp 300ms ease-in-out forwards;
                    animation: slideUp 300ms ease-in-out forwards;
                }

                .modal--is-invisible .contact__desc {
                    -webkit-animation: fadeSlideOutLeft 250ms ease-in-out forwards 500ms;
                    animation: fadeSlideOutLeft 250ms ease-in-out forwards 500ms;
                }

                .modal--is-invisible .contact__title {
                    -webkit-animation: fadeSlideOutRight 250ms ease-in-out forwards 300ms;
                    animation: fadeSlideOutRight 250ms ease-in-out forwards 300ms;
                }

                .modal--contact .has-no-max-height {
                    max-height: none;
                    overflow: visible;
                }

                @-webkit-keyframes fadeSlideIn {
                    to {
                        -webkit-transform: translateX(0);
                        opacity: 1;
                    }
                }

                @keyframes fadeSlideIn {
                    to {
                        transform: translateX(0);
                        opacity: 1;
                    }
                }

                @-webkit-keyframes fadeSlideOutLeft {
                    to {
                        -webkit-transform: translateX(-10%);
                        opacity: 0;
                    }
                }

                @keyframes fadeSlideOutLeft {
                    to {
                        transform: translateX(-10%);
                        opacity: 0;
                    }
                }

                @-webkit-keyframes fadeSlideOutRight {
                    to {
                        -webkit-transform: translateX(10%);
                        opacity: 0;
                    }
                }

                @keyframes fadeSlideOutRight {
                    to {
                        transform: translateX(10%);
                        opacity: 0;
                    }
                }

                @-webkit-keyframes slideDown {
                    to {
                        max-height: 50rem;
                        opacity: 1;
                    }
                }

                @keyframes slideDown {
                    to {
                        max-height: 50rem;
                        opacity: 1;
                    }
                }

                @-webkit-keyframes undoMaxHeight {
                    to {
                        max-height: none;
                    }
                }

                @keyframes undoMaxHeight {
                    to {
                        max-height: none;
                    }
                }

                @-webkit-keyframes slideUp {
                    to {
                        max-height: 0;
                        opacity: 0;
                    }
                }

                @keyframes slideUp {
                    to {
                        max-height: 0;
                        opacity: 0;
                    }
                }
            </style>

            <style>
                /*	@Layout | Exit Intent
                * --------------------------------------------------------------------- */
                @font-face {
                    font-family: 'Exit Intent Gotham Medium';
                    src: url(/shared/webfonts/gotham/medium/Gotham-Medium.eot?) format('eot');
                    src: local('☺︎'),
                        url(/shared/webfonts/gotham/medium/Gotham-Medium.woff) format('woff'),
                        url(/shared/webfonts/gotham/medium/Gotham-Medium.svg#Gotham-Medium) format('svg');
                }

                @font-face {
                    font-family: 'Exit Intent Gotham Book';
                    src: url(/shared/webfonts/gotham/book/Gotham-Book.eot?) format('eot');
                    src: local('☺︎'),
                        url(/shared/webfonts/gotham/book/Gotham-Book.woff) format('woff'),
                        url(/shared/webfonts/gotham/book/Gotham-Book.svg#Gotham-Book) format('svg');
                }

                .__ei, .__ei * {
                    box-sizing: border-box;
                }

                .__ei {
                    position: fixed;
                    width: 100%;
                    height: 100%;
                    background: rgba(0,0,0,0.8);
                    top: 0;
                    left: 0;
                    z-index: 10000;
                }

                .ei__in {
                    position: absolute;
                    top: 0;
                    left: 0;
                    right: 0;
                    bottom: 0;
                    margin: auto;
                    display: flex;
                    justify-items: center;
                    align-items: center;
                }

                .ei__fieldset {
                    background: rgba(237, 237, 237, 0.9);
                    font: normal 1.6rem/1.45 'Exit Intent Gotham Book', Helvetica, sans-serif;
                    text-align: center;
                    width: 95vw;
                    margin: auto;
                    position: relative;
                }

                @media all and ( min-width: 500px ) {
                    .ei__fieldset {
                        width: 50%;
                        min-width: 500px;
                    }
                }

                .ei__title {
                    display: block;
                    padding: 4rem 2rem 2rem;
                    font-size: 2rem;
                    font: normal 2rem/1 'Exit Intent Gotham Medium', 'Exit Intent Gotham Book', Helvetica, sans-serif;
                    border-bottom: 1px solid transparent;
                }

                .ei__grid {
                    display: table;
                    width: 100%;
                }

                .ei__grid__item {
                    display: table-cell;
                    vertical-align: middle;
                    width: 50%;
                }

                .ei__label {
                    padding: 2rem 1rem;
                    background: white;
                    color: #252525;
                    width: 100%;
                    cursor: pointer;
                }

                .ei__label:hover {
                    color: #065606;
                    background: #a8ffa8;
                }

                .ei__radio {
                    width: 1px;
                    opacity: 0;
                }

                .ei__textarea {
                    height: auto;
                    border: none;
                    text-align: center;
                    background: none;
                    border-bottom: 1px solid #b5b5b5;
                    line-height: 1.45;
                    font-size: 1.8rem;
                }

                .ei__group {
                    padding: 2rem;
                }

                .ei__group--textarea {
                    display: block;
                    margin: 0;
                    width: auto;
                    padding: 2rem;
                }

                .ei__group--submit {
                    margin: 1rem;
                }

                .ei__submit {
                    background: #252525;
                    color: white;
                    padding: 2rem;
                    width: 100%;
                    text-align: center;
                    border: none;
                }

                .ei__close {
                    display: inline-block;
                    position: absolute;
                    right: 0;
                    font-size: 1.25rem;
                    top: 0;
                    padding: 0.75rem 1rem;
                    background: rgba(90, 90, 90, 0.9);
                    color: rgba(255, 255, 255, 0.7);
                    line-height: 1;
                    cursor: pointer;
                }

                .ei__close:hover {
                    background: rgba(255, 255, 255, 0.7);
                    color: rgba(90, 90, 90, 0.9);
                }


                /*	@Model | Exit Intent
                * --------------------------------------------------------------------- */
                .ei__item {
                    display: block;
                    margin: 0.5em;
                    width: auto;
                    max-height: none;
                }


                /*	@State | Exit Intent
                * --------------------------------------------------------------------- */
                .ei__label,
                .ei__title,
                .ei__textarea,
                .ei__close,
                .ei__has-nav,
                .ei--is-post-submit .ei__has-nav {
                    transition: all 250ms ease-in-out;
                }

                .ei--is-selected .ei__title {
                    border-bottom-color: #b5b5b5;
                }

                .__ei .ei--is-inactive {
                    pointer-events: none;
                    background: #e4e2e2;
                    color: #acacac;
                }

                .ei--is-texting .ei__fieldset {
                    background: rgba(86, 86, 86, 0.8);
                    color: white;
                }

                .ei--is-texting .ei--has-answer--other .ei__label {
                    color: white;
                }

                .ei--is-hidden {
                    display: none;
                }

                .__ei,
                .ei__item,
                .ei--is-selected .ei__item:not(.ei--is-selected),
                .ei__fieldset {
                    opacity: 0;
                    transition: all 150ms ease-in-out;
                }

                .ei--is-active,
                .ei--is-active .ei__fieldset,
                .ei--is-active .ei__item {
                    opacity: 1;
                }

                .ei--is-active .ei__item:nth-child(odd),
                .ei--is-active .ei__item:nth-child(even) {
                    transform: translateX(0);
                    transition-delay: 300ms;
                }

                .ei--is-active .ei__fieldset,
                .ei--is-active .ei__item:last-child:nth-child(odd) {
                    transform: translateY(0);
                }

                .ei__fieldset {
                    transform: translateY(-30%);
                }

                .ei__item:nth-child(odd),
                .ei--is-selected .ei__item:not(.ei--is-selected):nth-child(odd) {
                    transform: translateX(-10%);
                }

                .ei__item:nth-child(even),
                .ei--is-selected .ei__item:not(.ei--is-selected):nth-child(even) {
                    transform: translateX(10%);
                }

                .ei__item:last-child:nth-child(odd),
                .ei--is-selected .ei__item:not(.ei--is-selected):last-child:nth-child(odd) {
                    transform: translateY(30%);
                }

                .ei--is-selected .ei__item:not(.ei--is-selected) {
                    transition-delay: 100ms;
                }

                .ei--is-hidden-and-out {
                    display: block;
                    max-height: 0;
                    margin: 0;
                    pointer-events: none;
                }

                .ei--is-expanded {
                    width: 98%;
                }

                .ei--is-expanded .ei__label {
                    background: transparent;
                    color: #252525;
                    cursor: default;
                }

                .ei--is-selected .ei__has-nav {
                    max-height: 4em;
                    transition-delay: 650ms;
                }

                .ei--is-selected .ei__close {
                    pointer-events: none;
                }
            </style>

			<% break; %>

	<% } %>



	<%= Model.FrameworkVersion %>

	<div class="l-controls">
		<% Html.RenderSiteControls(SiteControlLocation.ContentTop); %>
		<% Html.RenderSiteControls(SiteControlLocation.ContentBottom); %>
		<% Html.RenderSiteControls(SiteControlLocation.PageBottom); %>
	</div>
