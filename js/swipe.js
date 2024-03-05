(function () {
    // private property : cache body element
    var $body = $('body');

    // private method : sets a universal unique identifier for the button
    var uuid = function () {
        var s4 = function () {
            return Math.floor((1 + Math.random()) * 0x10000).toString(16).substring(1);
        };

        return s4() + s4() + '-' + s4() + '-' + s4() + '-' + s4() + '-' + s4() + s4() + s4();
    };

    // private method : create new swipe button template
    window.DTMSwipeCartTemplate = function (option) {
        // capture the swipe button
        var self = this;

        // set deferred
        var $defer = new $.Deferred();
        // set HTML template
        var $swipe = $('<div/>');

        // set options
        option = option || {};
        // set insertion method 
        option.insertionMethod = option.insertionMethod || 'insertAfter';
        // set the target element
        option.$target = option.$target || $('#AcceptOfferButton');
        // set the stylesheet target element
        option.$cssTarget = option.$cssTarget || $('#DTMFWJS');
        // set the stylesheet insertion method 
        option.cssInsertionMethod = option.cssInsertionMethod || 'appendTo';

        // set the url object 
        option.url = option.url || {};
        // set the html template url 
        option.url.html = option.url.html || '/shared/swipe/swipe.html';
        // set the initial icon graphic url 
        option.url.initIcon = option.url.initIcon || '/shared/swipe/images/cart-icon-init.svg';
        // set the terminal icon graphic url 
        option.url.termIcon = option.url.termIcon || '/shared/swipe/images/cart-icon-term.svg';
        // set the css template url 
        option.url.css = option.url.css || '/shared/swipe/css/swipe.css';

        // set the data object 
        option.data = option.data || {};

        // private method : converts data by token {Data}
        var tokenize = function (string, o) {
            try {
                var regex = new RegExp(/{([a-zA-Z]*?)}/, 'g');
            } catch (e) {
                var regex = new RegExp("\\{([a-zA-Z]*?)}", 'g');
            }
            
            var tokens = regex.exec(string);
            var result = string;

            while ( tokens !== null ) {
                if ( typeof tokens[0] === 'string' && typeof tokens[1] === 'string' ) {
                    if ( typeof o[tokens[1]] !== 'undefined' ) {
                        result = result.replace(tokens[0], o[tokens[1]]);
                    }
                    tokens = regex.exec(string);
                } else {
                    break;
                }
            }

            return result;
        };

        // private property : generates a universal unique identifier for the button
        var group__uuid = uuid();

        // private method : makes all template requests and constructs the button template
        var buildTemplate = function () {

            /*  request method
                get the HTML template for the button
                get the graphics for the init & term cart icon
            */
            $.when(
                
                $.get(option.url.html),
                $.get(tokenize(option.url.initIcon, option.url)),
                $.get(tokenize(option.url.termIcon, option.url))

            ).done(function (html, initIcon, termIcon) {
                
                // set up html template
                $swipe = $swipe.html(html[0]);

                // add init text
                if ( typeof option.data.initState === 'string' ) {
                    $swipe.find('.swipe__init__text .swipe__text').text(tokenize(option.data.initState, option.data));
                }

                // add term text
                if ( typeof option.data.termState === 'string' ) {
                    $swipe.find('.swipe__term__text .swipe__text').text(tokenize(option.data.termState, option.data));
                }
                
                // add before state text
                if ( typeof option.data.beforeState === 'string' ) {
                    $swipe.find('.swipe__term__text').attr('data-swipe-before', tokenize(option.data.beforeState, option.data));
                }

                // add after state text
                if ( typeof option.data.afterState === 'string' ) {
                    $swipe.find('.swipe__term__text').attr('data-swipe-after', tokenize(option.data.afterState, option.data));
                }

                // add init & term graphics
                $swipe.find('.swipe__button__init').html(initIcon[0].childNodes[0]);
                $swipe.find('.swipe__button__term').html(termIcon[0].childNodes[0]);
                
                // get swipe button and assign it with a uuid
                $swipe = $swipe.find('.swipe').attr('data-swipe-group-uuid', group__uuid);

                try {
                    if ( option.$target.length > 1 ) {
                        // cycle each instance of the target selector
                        option.$target.each(function () {
                            $swipe = $swipe.clone();
                            var $target = $(this);
                            $swipe[option.insertionMethod]($target);
                        });
                        // re-query all multiple elements by their group uuid
                        $swipe = $('[data-swipe-group-uuid="' + group__uuid + '"]');
                    } else {
                        $swipe[option.insertionMethod](option.$target);
                    }
                    
                    option.$swipe = $swipe;
                    
                    $swipe.trigger({ type : 'swipe:ready', swipe : option });
                    $defer.resolve($swipe);
                } catch (e) {
                    $swipe.trigger({ type : 'swipe:reject', swipe : option });
                    $defer.reject();
                }

            }).fail(function () {
                // return feedback to the user with selector identifier
                console.log('the template could not be loaded for ' + option.$target.selector);
            });

        };

        // check if our stylesheet template for the button is not loaded
        if ( $('link[id="DTMSWIPECSS"]').length === 0 ) {
            var $link = $('<link/>', {
                type : 'text/css',
                id : 'DTMSWIPECSS',
                rel : 'stylesheet',
                href : option.url.css
            })[option.cssInsertionMethod](option.$cssTarget);

            $('#DTMSWIPECSS').on('load', function () {
                buildTemplate();
            });
        } else {
            buildTemplate();
        }

        return $defer.promise();
    };

    // private method : adds swipe functionality to the button
    window.DTMSwipeCart = function ($swipe) {
        // private property : capture swipe object
        var self = this;

        // private method : kick off all actions
        var init = function ($swipe) {
            var self = this;
            // private property : cache window object
            var $window = $(window);
            var window__width__cached = $window.width();
            // private properties : set all button variables
            var $swipe = $swipe, 
                $swipe__in = $swipe.find('.swipe__in'), 
                $swipe__button = $swipe.find('.swipe__button'), 
                $swipe__term = $swipe.find('.swipe__term'),
                $swipe__init__text = $swipe.find('.swipe__init__text'),
                $swipe__term__text = $swipe.find('.swipe__term__text');

            // private properties : stores touch event data
            var touch = {};

            // private properties : stores initial button properties
            var button = {
                opacity : {},
                translateX : 0
            };

            var method;

            // private method : assigns api key to the button & detects key conflicts
            var assignApiKey = function () {
                // private property : set access key prefix
                var id = 'swipe';
                // private property : set the attribute
                var attr = 'data-swipe-api-key';
                // get api key
                var key = $swipe.attr(attr);
                // get length of api keys
                var keys = $('[' + attr + '="' + $swipe.attr(attr) + '"]').length;
                // private method : generates an access key identifier
                var apiKey = function () {
                    return $('[data-swipe-api-key]').length;
                };

                // assign api key to the button if override doesn't exist
                if ( typeof key === 'undefined' ) $swipe.attr(attr, id + apiKey());
                // check for override api key on multiple buttons
                if ( typeof key !== 'undefined' && keys > 1 ) {
                    $swipe.attr(attr, key + keys);
                }

                return $swipe.attr(attr);
            };

            // public property : generates a global unique identifier for the button
            self.uuid = uuid();

            // public property : generates an api key if an override doesn't exist
            self.apikey = assignApiKey();

            // private method : sets an incremental & decremental opacity value
            var setCSSOpacity = function () {
                button.opacity.x = 0 + (button.translateX * 0.005);
                button.opacity.y = 1 - (button.translateX * 0.005);

                button.opacity.x = button.opacity.x > 1 ? 1 : button.opacity.x < 0 ? 0 : button.opacity.x;
                button.opacity.y = button.opacity.y > 1 ? 1 : button.opacity.y < 0 ? 0 : button.opacity.y;
            };

            /**
            * private method : sets the clip path pixel on demand
            * @param {Integer} value An absolute value to override the clip path pixel
            */
            var setClipPath = function (value) {
                button.termClipPath = typeof value !== 'undefined' 
                    ? value : button.width - ( button.translateX + ($swipe__button.outerWidth() / 2) );

                $swipe__term.css({
                    '-webkit-clip-path' : 'inset(0 ' + button.termClipPath + 'px 0 0)',
                    'clip-path' : 'inset(0 ' + button.termClipPath + 'px 0 0)'
                });

                if ( $swipe__term.hasClass('swipe--is-hidden') ) $swipe__term.removeClass('swipe--is-hidden');
            };

            // private method : updates all button properties on touch move event
            var doSwipe = function () {
                method = undefined;
                button.translateX = touch.touchmovex - touch.touchstartx;
                
                if ( button.translateX < 0 ) button.translateX = 0;
                if ( button.translateX > self.getEndPoint() ) button.translateX = self.getEndPoint();

                if ( !self.setLock ) {
                    setCSSOpacity();
                    setClipPath();
                    $swipe__button.css({
                        'transform' : 'translateX(' + button.translateX + 'px)'
                    });

                    $swipe__init__text.css('opacity', button.opacity.y);
                    $swipe__term__text.css('opacity', button.opacity.x);
                }
            };

            // private method : determines if swipe has past the threshold point
            var isPastThreshold = function (status) {
                if ( typeof method !== 'undefined' ) {
                    try {
                        self[method]();
                    } catch (e) {
                        console.log(e.message);
                    }
                    
                } else if ( button.translateX < ( button.width * self.threshold ) ) {
                    self.gotoStart();
                } else {
                    self.gotoEnd();
                }
            };

            // private method : adds support for resistance animation
            var setResistance = function () {
                $swipe__button.addClass('swipe__button--resistance');
                $swipe__term.addClass('swipe__term--resistance');
            };

            // public property : configure the threshold from 0 to 1 range
            self.threshold = 0.5;

            // public property : activate/deactivate the button from animation
            self.setLock = false;

            // public method : enforce button back to the start point
            self.gotoStart = function () {
                method = 'gotoStart';
                setResistance();

                $swipe__button.removeAttr('style');
                $swipe__term.removeAttr('style');

                setClipPath(button.width);
                self.unbindStates();

                $swipe.addClass('swipe--is-start').removeClass('swipe--in-motion');
                $swipe__button.css('transform', 'translateX(0)');
                
                $swipe__init__text.css('opacity', 1);
                $swipe__term__text.css('opacity', 1);
                
                $swipe.trigger({ type : 'swipe:start', swipe : self });
            };

            // public method : enforce button to the end point
            self.gotoEnd = function (o) {
                o = o || {};
                method = 'gotoEnd';
                setResistance();

                // check if duration property was set
                if ( typeof o.duration === 'number' ) {
                    o.easing = o.easing || 'linear';

                    $swipe__button.css({
                        'transition-duration' : o.duration * 0.95 + 'ms',
                        'transition-timing-function' : o.easing
                    });
                    $swipe__term.css({
                        'transition-duration' : o.duration + 'ms',
                        'transition-timing-function' : o.easing
                    });
                }

                setClipPath(0);
                self.unbindStates();

                $swipe.removeClass('swipe--is-start').addClass('swipe--in-motion');
                $swipe__button.css('transform', 'translateX(' + self.getEndPoint() + 'px)');

                $swipe__init__text.css('opacity', 0);
                $swipe__term__text.css('opacity', 1);

                $swipe.trigger({ type : 'swipe:end', swipe : self });
            };

            // public method : activates before state & deactivates after state
            self.setBeforeState = function () {
                $swipe__term.removeAttr('style');

                $swipe
                    .removeClass('swipe--has-after-mode')
                    .addClass('swipe--has-before-mode');
            };

            // public method : activates after state & deactivates before state
            self.setAfterState = function () {
                $swipe__term.removeAttr('style');

                $swipe
                    .removeClass('swipe--has-before-mode')
                    .addClass('swipe--has-after-mode');
            };

            // public method : unbinds both before and after states 
            self.unbindStates = function () {
                if ( !self.setLock ) $swipe.removeClass('swipe--has-before-mode swipe--has-after-mode');
            };

            // public method : recapture all measurements when enviroment changes
            self.set = function (o) {
                o = o || {};
                window__width__cached = o.updateCachedWidth || window__width__cached;
                $swipe = $('[data-swipe-uuid="' + self.uuid + '"]');
                $swipe__in = $swipe.find('.swipe__in');
                $swipe__button = $swipe.find('.swipe__button');
                $swipe__term = $swipe.find('.swipe__term');
                $swipe__init__text = $swipe.find('.swipe__init__text');
                $swipe__term__text = $swipe.find('.swipe__term__text');

                button.width = $swipe.width();
                button.height = $swipe.height();

                setClipPath();
                isPastThreshold();
            };

            // public method : get the end position pixel value
            self.getEndPoint = function () {
                return Math.floor($swipe__in.width() - $swipe__button.outerWidth());
            };

            // assign uuid to the button
            $swipe.attr('data-swipe-uuid', self.uuid);
            // assign api key to the button
            assignApiKey();

            // capture measurements & set button position
            self.set();

            // recapture measurements when window resizes
            $(window).resize(function () {
                var window__width__new = $(window).width();
                if ( window__width__new !== window__width__cached ) {
                    self.set({
                        updateCachedWidth : window__width__new
                    });
                }
            });

            // disable form from submitting
            $swipe.on('click', function (e) {
                e.preventDefault();
                $swipe.trigger({ type : 'swipe:click', swipe : self });
            });

            // public event : capture initial touch by x coordinate
            $swipe__button.on('touchstart', function (e) {
                touch.touchstartx = e.originalEvent.touches[0].pageX;
            });

            // public event : recapture touch by x coordinate and set directional events
            $swipe__button.on('touchmove', function (e) {
                touch.touchmovex = e.originalEvent.touches[0].pageX;

                switch ( true ) {
                    case touch.touchmovex > touch.touchstartx:
                        $swipe__button.trigger({ type : 'swipe:right', swipe : e });
                        break;
                    case touch.touchmovex < touch.touchstartx: 
                        $swipe__button.trigger({ type : 'swipe:left', swipe : e });
                        break;
                }
            });

            // public events : direct events to the swipe method
            $swipe__button.on('swipe:right', doSwipe);
            $swipe__button.on('swipe:left', doSwipe);

            // public event : capture final touch by x coordinate
            $swipe__button.on('touchend', function (e) {
                touch.touchendx = e.originalEvent.pageX;

                if ( !self.setLock ) isPastThreshold();
            });

            // public event : unbind animation classes after resistance cycle completes
            $swipe__button.on('transitionend', function () {
                $swipe__button.removeClass('swipe__button--resistance');
                $swipe__term.removeClass('swipe__term--resistance');
            });
        };
        
        // cycle each swipe button instance
        $swipe.each(function () {
            // initialize api
            var _ = new init($(this));
            // build new api construct
            self[_.apikey] = _;
        });

        // return the api to the user
        return self;
    };
})();