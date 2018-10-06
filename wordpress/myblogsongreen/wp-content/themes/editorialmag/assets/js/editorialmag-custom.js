/**
 * Buzzmag Theme Custom Js
*/
jQuery(document).ready( function($){
	/**
	 * Features News Ticker
	 */
    $(".hot-news-wrap").lightSlider({
        item:3,
        pager:false,
        loop:true,
        speed:600,
        controls:true,
        slideMargin:20,
        auto:true,
        pauseOnHover:true,
        onSliderLoad: function() {
            $('.hot-news-wrap').removeClass('cS-hidden');
        },
        responsive : [
            {
                breakpoint:800,
                settings: {
                    item:2,
                    slideMove:1,
                    slideMargin:6,
                  }
            },
            {
                breakpoint:480,
                settings: {
                    item:1,
                    slideMove:1,
                  }
            }
        ]
    });

    $('.banner-list-group').lightSlider({
        gallery:true,
        item:1,
        thumbItem:5,
        thumbMargin:10,
        slideMargin:0,
        loop:true,
        onSliderLoad: function() {
            $('.banner-list-group').removeClass('cS-hidden');
        },
    });

    /**
     * Equal Height 
    */
    $('.equalheight').matchHeight();

    /**
     * Widget Sticky sidebar
    */
    $('.content-area').theiaStickySidebar({
        additionalMarginTop: 30
    });

    $('.widget-area').theiaStickySidebar({
        additionalMarginTop: 30
    });

    /**
     * Date & Time 
    */
    var datetime = null,
     date = null;
    var update = function() {
        date = moment(new Date())
        datetime.html(date.format('dddd, D MMMM  YYYY, h:mm:ss a'));
    };
    datetime = $('.date-time')
        update();
    setInterval(update, 1000);

    /**
     * ScrollUp
     */
    if ($('.scroll-to-top').length) {
        var scrollTrigger = 100, // px
            goToTop = function() {
                var scrollTop = $(window).scrollTop();
                if (scrollTop > scrollTrigger) {
                    $('.scroll-to-top').addClass('show');
                } else {
                    $('.scroll-to-top').removeClass('show');
                }
            };
        //goToTop();
        $(window).on('scroll', function() {
            goToTop();
        });
        $('.scroll-to-top').on('click', function(e) {
            e.preventDefault();
            $('html,body').animate({
                scrollTop: 0
            }, 700);
        });
    }

    /**
     * Search
     */
    $('.search-wrap .icofont').click(function() {
        $('.search-form-wrap').toggleClass('search-form-active');
    });

    /**
     * Social Media Post Share
     */
    $('.icofont.magsocial, .video-list-group .news-share').on('click', function() {
        $(this).parent('.news-share').children('.news-social-icons').toggleClass('news-social-active');
    });


    /**
     * Sticky Main Header Menu
     */
    var headerHeight = $('.site-header').height();
    $(window).scroll(function() {
        if ($(window).scrollTop() > headerHeight) {
            $('.sticky-menu').addClass('fixed-header');
        } else {
            $('.sticky-menu').removeClass('fixed-header');
        }
    });


    /**
     * Responsive Toggle Button for Main Menu
     */
    $('.sticky-menu .main-navigation ul li.menu-item-has-children').prepend('<span class="icofont fa fa-chevron-down"></span>');
    $('.sticky-menu .main-navigation ul li.page_item_has_children').prepend('<span class="icofont fa fa-chevron-down"></span>');

    $('.nav-wrap .main-navigation ul li.menu-item-has-children').prepend('<span class="icofont fa fa-chevron-down"></span>');
    $('.nav-wrap .main-navigation ul li.page_item_has_children').prepend('<span class="icofont fa fa-chevron-down"></span>');
        
    $('.nav-wrap .main-navigation').prepend('<span class="magicofont fa fa-arrow-circle-left"></span>');
    $('.nav-wrap .main-navigation ul > li .icofont').click(function() {
        $(this).siblings('ul.sub-menu').slideToggle();
        $(this).siblings('ul.children').slideToggle();
    });

    $('.main-navigation .toggle-button').on('click', function() {
        $('body').addClass('menu-active');
    });

    $('.nav-wrap .main-navigation > span.magicofont').on('click', function() {
        $('body').removeClass('menu-active');
    });
	
});


/* Tabs Widget */
jQuery(document).ready( function() {
    if ( jQuery.isFunction(jQuery.fn.tabs) ) {
        jQuery( ".emag-tabs-wdt" ).tabs();
    }
});
