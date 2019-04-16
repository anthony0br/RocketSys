/*
 * Apperle | Responsive App Landing Page.
 * Author: perleTheme Template
 * Copyright: 2017;
 * This is a premium product available exclusively here : https://themeforest.net/user/perletheme
 */

(function ($) {
    "use strict";

    var $window = $(window);

    //Fading Out Loader
    $window.on("load", function() {
        $(".pre-loader").fadeOut("slow");
        AOS.refresh();
    });

    $(document).ready(function () {


        var $icon4 = $("#hamburger-menu"),
            $socialHamburger = $('#social-hamburger'),
            $buttonCollapse = $(".button-collapse"),
            header = $("#main-header"),
            height = header.outerHeight(),
            offset = height / 2,
            navColor = $("#nav-color"),
            range = 200,
            didScroll,
            lastScrollTop = 0,
            delta = 5,
            $mainNav = $("#main-nav"),
            $mainNavHeight = $mainNav.outerHeight(),
            ww = $window.width(),
            scrollTop;

        /*----- Close SideNav when on resize width-----*/

        $window.on('resize', function(){
            if( ww != $window.width() ){
                ww = $window.width();
                $buttonCollapse.sideNav("hide");
            }
        });

        //Toggle Social Hamburger Icon on click
        $socialHamburger.on('click', function () {
            $(this).toggleClass('open')
        });


        /*----- Materialize JS Setup-----*/

        // SideNav Initialize
        $buttonCollapse.sideNav({
            draggable: true,
            closeOnClick: true,
            //Toggle the hamburger icon
            onOpen: function () {
                $icon4.addClass("open");
            },
            onClose: function () {
                $icon4.removeClass("open");
            }
        });

        // SideNav DropDown Initialize
        $(".dropdown-button").dropdown({
            belowOrigin: true,
            constrainWidth: false
        });

        // Header Slider Initialize
        $(".slider").slider();

        // Screenshots Carousel Initialize
        $(".carousel").carousel({
            dist: -70,
            fullWidth: false,
            shift: 0,
            padding: -100
        });

        //Auto Play the Carousel
        setInterval(function() {
            $(".carousel").carousel("next");
        }, 10000);

        $("#screenshot-next").on("click", function () {
            $(".carousel").carousel("next");
        });
        $("#screenshot-prev").on("click", function () {
            $(".carousel").carousel("prev");
        });

        // FAQ Collapsible Initialize
        $(".collapsible").collapsible();



        /*----- Fade Header and NavColor on Scroll-----*/

        $window.on("scroll", function () {
            didScroll = true;
            scrollTop = $(this).scrollTop();
            if(scrollTop > 1000) {
                navColor.css({ "opacity": 1});
                return;
            }
            var calc = 1 - (offset - scrollTop + range) / range + 1;
            if(calc < 1) {
                navColor.css({ "opacity": calc});
            } else {
                navColor.css({ "opacity": 1});
            }
        });

        // Set nav bar opacity to 0 if on top of page
        if($(document).scrollTop() === 0) {
            navColor.css({ "opacity": 0});
        }


        setInterval(function() {
            if (didScroll) {
                hasScrolled();
                didScroll = false;
            }
        }, 200);

        function hasScrolled() {
            if(Math.abs(lastScrollTop - scrollTop) <= delta) {
                return;
            }
            if (scrollTop > lastScrollTop && scrollTop > $mainNavHeight){
                $mainNav.removeClass("nav-down").addClass("nav-up");
            } else {
                if(scrollTop + $(window).height() < $(document).height()) {
                    $mainNav.removeClass("nav-up").addClass("nav-down");
                }
            }
            lastScrollTop = scrollTop;
        }



        /*----- ScrollIt JS Setup-----*/

        $.scrollIt({
            easing: "ease-out",
            topOffset: -1
        });


        /*----- Owl Carousal Setup-----*/

        // Initialize Header Carousel
        $(".owl-header").owlCarousel({
            loop: true,
            responsiveClass: true,
            items: 1,
            nav: false,
            dots: true,
            autoplay: true,
            margin: 30,
            animateOut: "bounceOutRight",
            animateIn: "bounceInLeft"
        });

        // Features Owl Carousal initialize
        var $owlFeatures = $(".owl-features"),
            $featureLinks = $(".feature-link");

        function highLightFeature($singleFeatureLink) {
            $featureLinks.removeClass("active");
            $singleFeatureLink.addClass("active");
        }

        // Initialize Features Carousel
        $owlFeatures.owlCarousel({
            loop: true,
            responsiveClass: true,
            margin: 20,
            autoplay: true,
            items: 1,
            nav: false,
            dots: false,
            animateOut: "slideOutDown",
            animateIn: "fadeInUp"
        });

        //Highlight the current link when owl changes
        $owlFeatures.on("changed.owl.carousel", function(event) {
            //Fix the current link
            var current = (event.item.index + 1) - event.relatedTarget._clones.length / 2;
            var allItems = event.item.count;
            if (current > allItems || current == 0) {
                current = allItems - (current % allItems);
            }
            current--;
            var $featureLink = $(".feature-link:nth("+ current + ")");
            highLightFeature($featureLink);
        });

        //Highlight the current link when feature clicked
        $featureLinks.on("click", function () {
            var $item = $(this).data("owl-item");
            $owlFeatures.trigger("to.owl.carousel", $item);
            highLightFeature($(this));
        });

        // Testimonials Owl Carousal
        $(".owl-testimonials").owlCarousel({
            loop: true,
            responsiveClass: true,
            dots: true,
            items:1
        });

        // News and team Owl Carousal
        $(".owl-news, .owl-teams").owlCarousel({
            loop: true,
            responsiveClass: true,
            dots: true,
            margin: 20,
            nav: false,
            stagePadding: 10,
            responsive:{
                0: {
                    items:1,
                    margin: 300
                },
                500: {
                    items: 2
                },
                992: {
                    items: 3
                }
            }
        });


        /*----- AOS Setup-----*/

        AOS.init({
            disable: "mobile",
            once: true,
            duration: 400,
            easing: "ease-in-sine"
        });


        /*----- Spectaram Setup-----*/

        // $.fn.spectragram.accessData = {
        //     accessToken: "2136707.4dd19c1.d077b227b0474d80a5665236d2e90fcf",
        //     clientID: "4dd19c1f5c7745a2bca7b4b3524124d0"
        // };
        //
        // $(".instagram").spectragram("getUserFeed", {
        //     query: "adrianengine", //this gets adrianengine"s photo feed
        //     size: "small",
        //     max: 4
        // });


        /*----- Counter Up Setup fot statistics section-----*/

        $(".counter").counterUp({
            delay: 10,
            time: 1000
        });


        /*----- Color Switcher Setup-----*/

        function colorSwitcher (){

            var div = $("#colors-switcher");

            $("#fa-cog").on('click', function(e){
                e.preventDefault();
                div.toggleClass("active");
            });

            $(".colors li a").on("click", function(e){
                e.preventDefault();
                var styleSheet = "css/color/" + $(this).data("class");
                $("#colors").attr("href", styleSheet);
                $(this).parent().parent().find("a").removeClass("active");
                $(this).addClass("active");
            });
        }

        colorSwitcher();


        /*----- Same Height Plugin Setup-----*/

        $(".same-height").matchHeight({
            property: "min-height",
            byRow: false
        });

        /*----- Count-Down Setup -----*/
        var $countDownWrapper = $('.apperle-count-down-wrapper');

        //Set the dead line and time zone for your app
        var deadline = 'Jun 25 2019 18:40:18 GMT-0400';

        function time_remaining(endtime){
            var t = Date.parse(endtime) - Date.parse(new Date());
            var seconds = Math.floor( (t/1000) % 60 );
            var minutes = Math.floor( (t/1000/60) % 60 );
            var hours = Math.floor( (t/(1000*60*60)) % 24 );
            var days = Math.floor( t/(1000*60*60*24) );
            return {'total':t, 'days':days, 'hours':hours, 'minutes':minutes, 'seconds':seconds};
        }

        function run_clock(id,endtime){
            var clock = document.getElementById(id);

            // get spans where our clock numbers are held
            var days_span = clock.querySelector('.days');
            var hours_span = clock.querySelector('.hours');
            var minutes_span = clock.querySelector('.minutes');
            var seconds_span = clock.querySelector('.seconds');

            function update_clock(){
                var t = time_remaining(endtime);

                // update the numbers in each part of the clock
                days_span.innerHTML = t.days;
                hours_span.innerHTML = ('0' + t.hours).slice(-2);
                minutes_span.innerHTML = ('0' + t.minutes).slice(-2);
                seconds_span.innerHTML = ('0' + t.seconds).slice(-2);

                if(t.total<=0){ clearInterval(timeinterval); }
            }
            update_clock();
            var timeinterval = setInterval(update_clock,1000);
        }

        if($countDownWrapper.length) {
            run_clock('clockdiv',deadline);
        }

    });

})(jQuery);
