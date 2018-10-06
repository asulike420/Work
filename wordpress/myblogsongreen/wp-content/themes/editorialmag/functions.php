<?php
/**
 * Editorial Mag functions and definitions
 *
 * @link https://developer.wordpress.org/themes/basics/theme-functions/
 *
 * @package Editorial_Mag
 */

if ( ! function_exists( 'editorialmag_setup' ) ) :
	/**
	 * Sets up theme defaults and registers support for various WordPress features.
	 *
	 * Note that this function is hooked into the after_setup_theme hook, which
	 * runs before the init hook. The init hook is too late for some features, such
	 * as indicating support for post thumbnails.
	 */
	function editorialmag_setup() {
		/*
		 * Make theme available for translation.
		 * Translations can be filed in the /languages/ directory.
		 * If you're building a theme based on Editorial Mag, use a find and replace
		 * to change 'editorialmag' to the name of your theme in all the template files.
		 */
		load_theme_textdomain( 'editorialmag', get_template_directory() . '/languages' );

		// Add default posts and comments RSS feed links to head.
		add_theme_support( 'automatic-feed-links' );

		/*
		 * This theme styles the visual editor to resemble the theme style.
		*/
		add_editor_style( array( 'assets/css/editor-style.css', editorialmag_fonts_url() ) );

		/*
		 * Let WordPress manage the document title.
		 * By adding theme support, we declare that this theme does not use a
		 * hard-coded <title> tag in the document head, and expect WordPress to
		 * provide it for us.
		 */
		add_theme_support( 'title-tag' );

		/*
		 * WooCommerce support.
		 */
		add_theme_support( 'woocommerce' );

		/*
		 * Add support for WooCommerce
		 */
		add_theme_support( 'wc-product-gallery-zoom' );
		add_theme_support( 'wc-product-gallery-lightbox' );
		add_theme_support( 'wc-product-gallery-slider' );

		/*
		 * Enable support for Post Thumbnails on posts and pages.
		 *
		 * @link https://developer.wordpress.org/themes/functionality/featured-images-post-thumbnails/
		 */
		add_theme_support( 'post-thumbnails' );

		//Advance Image Size Crop
		add_image_size('editorialmag-normal-image', 580, 375, true);
		add_image_size('editorialmag-large', 795, 385, true);
		add_image_size('editorialmag-slider', 1175, 500, true);

		// This theme uses wp_nav_menu() in one location.
		register_nav_menus( array(
			'menu-1' => esc_html__( 'Primary Menu', 'editorialmag' ),
			'menu-2' => esc_html__( 'Top Menu', 'editorialmag' )
		) );

		/*
		 * Switch default core markup for search form, comment form, and comments
		 * to output valid HTML5.
		 */
		add_theme_support( 'html5', array(
			'search-form',
			'comment-form',
			'comment-list',
			'gallery',
			'caption',
		) );

		// Set up the WordPress core custom background feature.
		add_theme_support( 'custom-background', apply_filters( 'editorialmag_custom_background_args', array(
			'default-color' => 'ffffff',
			'default-image' => '',
		) ) );

		// Add theme support for selective refresh for widgets.
		add_theme_support( 'customize-selective-refresh-widgets' );

		/**
		 * Add support for core custom logo.
		 *
		 * @link https://codex.wordpress.org/Theme_Logo
		 */
		add_theme_support( 'custom-logo', array(
			'height'      => 90,
			'width'       => 240,
			'flex-width'  => true,
			'flex-height' => true,
		) );
	}
endif;
add_action( 'after_setup_theme', 'editorialmag_setup' );

/**
 * Set the content width in pixels, based on the theme's design and stylesheet.
 *
 * Priority 0 to make it available to lower priority callbacks.
 *
 * @global int $content_width
 */
function editorialmag_content_width() {
	$GLOBALS['content_width'] = apply_filters( 'editorialmag_content_width', 640 );
}
add_action( 'after_setup_theme', 'editorialmag_content_width', 0 );

/**
 * Register widget area.
 *
 * @link https://developer.wordpress.org/themes/functionality/sidebars/#registering-a-sidebar
 */
function editorialmag_widgets_init() {
	register_sidebar( array(
		'name'          => esc_html__( 'Right Sidebar Widget Area', 'editorialmag' ),
		'id'            => 'sidebar-1',
		'description'   => esc_html__( 'Add widgets here.', 'editorialmag' ),
		'before_widget' => '<aside id="%1$s" class="widget clearfix %2$s">',
		'after_widget'  => '</aside>',
		'before_title'  => '<h2 class="widget-title"><span>',
		'after_title'   => '</span></h2>',
	) );

	register_sidebar( array(
		'name'          => esc_html__( 'Left Sidebar Widget Area', 'editorialmag' ),
		'id'            => 'sidebar-2',
		'description'   => esc_html__( 'Add widgets here.', 'editorialmag' ),
		'before_widget' => '<aside id="%1$s" class="widget clearfix %2$s">',
		'after_widget'  => '</aside>',
		'before_title'  => '<h2 class="widget-title"><span>',
		'after_title'   => '</span></h2>',
	) );

	if ( is_customize_preview() ) {
	    $editorialmag_home_description = sprintf( esc_html__( 'Displays widgets on home page main content area.%1$s Note : Please go to %2$s "Static Front Page"%3$s setting, Select "A static page" then "Front page" and "Posts page" to show added widgets', 'editorialmag' ), '<br />','<b><a class="sparkle-customizer" data-section="static_front_page" style="cursor: pointer">','</a></b>' );
	}
	else{
	    $editorialmag_home_description = esc_html__( 'Displays widgets on Front/Home page. Note : Please go to Setting => Reading, Select "A static page" then "Front page" and "Posts page" to show added widgets', 'editorialmag' );
	}

	register_sidebar( array(
		'name'          => esc_html__( 'Home 1 - Full Width Section', 'editorialmag' ),
		'id'            => 'home-1',
		'description'   => $editorialmag_home_description,
		'before_widget' => '<aside id="%1$s" class="widget clearfix %2$s">',
		'after_widget'  => '</aside>',
		'before_title'  => '<h2 class="widget-title"><span>',
		'after_title'   => '</span></h2>',
	) );

	register_sidebar( array(
		'name'          => esc_html__( 'Home 2 - 3/1 Main Block Section', 'editorialmag' ),
		'id'            => 'home-2',
		'description'   => $editorialmag_home_description,
		'before_widget' => '<aside id="%1$s" class="widget clearfix %2$s">',
		'after_widget'  => '</aside>',
		'before_title'  => '<h2 class="widget-title"><span>',
		'after_title'   => '</span></h2>',
	) );

	register_sidebar( array(
		'name'          => esc_html__( 'Home 3 - Full Width Section', 'editorialmag' ),
		'id'            => 'home-3',
		'description'   => $editorialmag_home_description,
		'before_widget' => '<aside id="%1$s" class="widget clearfix %2$s">',
		'after_widget'  => '</aside>',
		'before_title'  => '<h2 class="widget-title"><span>',
		'after_title'   => '</span></h2>',
	) );

	register_sidebar( array(
		'name'          => esc_html__( 'Home Header ADS Section', 'editorialmag' ),
		'id'            => 'headerads',
		'description'   => esc_html__( 'Add widgets here.', 'editorialmag' ),
		'before_widget' => '<section id="%1$s" class="widget %2$s">',
		'after_widget'  => '</section>',
		'before_title'  => '<h2 class="widget-title">',
		'after_title'   => '</h2>',
	) );

	register_sidebar( array(
		'name'          => esc_html__( 'Footer 1 - 1/4 Widget Area', 'editorialmag' ),
		'id'            => 'footer-1',
		'description'   => esc_html__( 'Add widgets here.', 'editorialmag' ),
		'before_widget' => '<section id="%1$s" class="widget %2$s">',
		'after_widget'  => '</section>',
		'before_title'  => '<h2 class="widget-title">',
		'after_title'   => '</h2>',
	) );

	register_sidebar( array(
		'name'          => esc_html__( 'Footer 2 - 1/4 Widget Area', 'editorialmag' ),
		'id'            => 'footer-2',
		'description'   => esc_html__( 'Add widgets here.', 'editorialmag' ),
		'before_widget' => '<section id="%1$s" class="widget %2$s">',
		'after_widget'  => '</section>',
		'before_title'  => '<h2 class="widget-title">',
		'after_title'   => '</h2>',
	) );

	register_sidebar( array(
		'name'          => esc_html__( 'Footer 3 - 1/4 Widget Area', 'editorialmag' ),
		'id'            => 'footer-3',
		'description'   => esc_html__( 'Add widgets here.', 'editorialmag' ),
		'before_widget' => '<section id="%1$s" class="widget %2$s">',
		'after_widget'  => '</section>',
		'before_title'  => '<h2 class="widget-title">',
		'after_title'   => '</h2>',
	) );

	register_sidebar( array(
		'name'          => esc_html__( 'Footer 4 - 1/4 Widget Area', 'editorialmag' ),
		'id'            => 'footer-4',
		'description'   => esc_html__( 'Add widgets here.', 'editorialmag' ),
		'before_widget' => '<section id="%1$s" class="widget %2$s">',
		'after_widget'  => '</section>',
		'before_title'  => '<h2 class="widget-title">',
		'after_title'   => '</h2>',
	) );


}
add_action( 'widgets_init', 'editorialmag_widgets_init' );

/**
 * Enqueue scripts and styles.
 */
function editorialmag_scripts() {

	$editorialmag_theme = wp_get_theme('editorialmag');
	
	$theme_version = $editorialmag_theme->get( 'Version' );

    /* Editorial Mag Icon Font Awesome */
    wp_enqueue_style( 'font-awesome', get_template_directory_uri() . '/assets/library/font-awesome/css/font-awesome.min.css', esc_attr( $theme_version ) );

	/* Editorial Mag Lightslider CSS */
    wp_enqueue_style( 'lightslider', get_template_directory_uri() . '/assets/library/lightslider/css/lightslider.min.css' );

	/* Editorial Mag Main Style */
	wp_enqueue_style( 'editorialmag-style', get_stylesheet_uri() );

	/* Editorial Mag Responsive CSS */
    wp_enqueue_style( 'editorialmag-responsive', get_template_directory_uri() . '/assets/css/responsive.css' );

    /**
     * Editorial Mag Theme Google Fonts
    */
    wp_enqueue_style( 'editorialmag-fonts', editorialmag_fonts_url(), array(), $theme_version );


	if ( has_header_image() ) {
		$custom_css = '.header-bgimg{ background-image: url("' . esc_url( get_header_image() ) . '"); background-repeat: no-repeat; background-position: center center; background-size: cover; }';
		wp_add_inline_style( 'editorialmag-style', $custom_css );
	}
	
	/* Editorial Mag html5 js library */
	wp_enqueue_script('html5', get_template_directory_uri() . '/assets/library/html5shiv/html5shiv.min.js', array('jquery'), $theme_version, false);
	wp_script_add_data( 'html5', 'conditional', 'lt IE 9' );

	/* Editorial Mag Respond js library */
	wp_enqueue_script('respond', get_template_directory_uri() . '/assets/library/respond/respond.min.js', array('jquery'), $theme_version, false);
	wp_script_add_data( 'respond', 'conditional', 'lt IE 9' );

	/* Editorial Mag Lightslider */
	wp_enqueue_script('lightslider', get_template_directory_uri() . '/assets/library/lightslider/js/lightslider.min.js', array('jquery'), esc_attr( $theme_version ), true);

	/* Editorial Mag Imagesloaded */
	wp_enqueue_script('imagesloaded', get_template_directory_uri() . '/assets/js/imagesloaded.js', array('jquery'), esc_attr( $theme_version ), true);

	/* Editorial Mag underscore default js library */
	wp_enqueue_script( 'editorialmag-navigation', get_template_directory_uri() . '/assets/js/navigation.js', array(), '20151215', true );

	wp_enqueue_script( 'editorialmag-skip-link-focus-fix', get_template_directory_uri() . '/assets/js/skip-link-focus-fix.js', array(), '20151215', true );

	/* Editorial Mag Sidebar Widget Ticker */
    wp_enqueue_script('theia-sticky-sidebar', get_template_directory_uri() . '/assets/library/theia-sticky-sidebar/js/theia-sticky-sidebar.min.js', array('jquery'), esc_attr( $theme_version ), true);

	/* Editorial Mag jquery match height Ticker */
	wp_enqueue_script('jquery-matchHeight', get_template_directory_uri() . '/assets/library/jquery-match-height/js/jquery.matchHeight-min.js', array('jquery'), esc_attr( $theme_version ), true);

	/* Editorial Mag jquery Moment Date & Time */
	wp_enqueue_script('moment', get_template_directory_uri() . '/assets/js/moment.js', array('jquery'), esc_attr( $theme_version ), true);
	
	/* Editorial Mag theme custom js */
	wp_enqueue_script('editorialmag-custom', get_template_directory_uri() . '/assets/js/editorialmag-custom.js', array('jquery', 'masonry'), $theme_version, 'ture');

	if ( is_singular() && comments_open() && get_option( 'thread_comments' ) ) {
		wp_enqueue_script( 'comment-reply' );
	}
}
add_action( 'wp_enqueue_scripts', 'editorialmag_scripts' );


/**
 * Admin Panle Enqueue Scripts and Styles
 */
if ( ! function_exists( 'editorialmag_media_scripts' ) ) {
    function editorialmag_media_scripts( $hook ) {
    	if( 'widgets.php' != $hook )
        return;
        wp_enqueue_script('editorialmag-media-uploader', get_template_directory_uri() . '/assets/js/editorialmag-admin.js', array('jquery') );
        wp_localize_script('editorialmag-media-uploader', 'editorialmag_widget_img', array(
            'upload' => esc_html__('Upload', 'editorialmag'),
            'remove' => esc_html__('Remove', 'editorialmag')
        ));
        wp_enqueue_style( 'editorialmag-admin-style', get_template_directory_uri() . '/assets/css/editorialmag-admin.css');    
    }
}
add_action('admin_enqueue_scripts', 'editorialmag_media_scripts');

/**
 * Admin Panle Enqueue Scripts and Styles
 */
if ( ! function_exists( 'editorialmag_allpageposts_style' ) ) {
    function editorialmag_allpageposts_style() {    	
        wp_enqueue_style( 'editorialmag-admin-style', get_template_directory_uri() . '/assets/css/editorialmag-admin.css');    
    }
}
add_action('admin_enqueue_scripts', 'editorialmag_allpageposts_style');

/**
 * Buzzmag Theme Call Google Fonts
*/
if ( ! function_exists( 'editorialmag_fonts_url' ) ) :
	/**
	 * Register default Google fonts
	 */
	function editorialmag_fonts_url() {

	    $fonts_url = '';

	    /* Translators: If there are characters in your language that are not
	    * supported by Signika Negative, translate this to 'off'. Do not translate
	    * into your own language.
	    */
	    $signikanegative = _x( 'on', 'Signika Negative font: on or off', 'editorialmag' );

	    /* Translators: If there are characters in your language that are not
	    * supported by Open Sans, translate this to 'off'. Do not translate
	    * into your own language.
	    */
	    $open_sans = _x( 'on', 'Open Sans font: on or off', 'editorialmag' );

	    if ( 'off' !== $signikanegative || 'off' !== $open_sans ) {
	        $font_families = array();

	        if ( 'off' !== $signikanegative ) {
	            $font_families[] = 'Signika Negative:300,400,600,700';
	        }

	        if ( 'off' !== $open_sans ) {
	            $font_families[] = 'Open Sans:400,300,300italic,400italic,600,600italic,700,700italic';
	        }

	        $query_args = array(
	            'family' => urlencode( implode( '|', $font_families ) ),
	            'subset' => urlencode( 'latin,latin-ext' ),
	        );

	        $fonts_url = add_query_arg( $query_args, 'https://fonts.googleapis.com/css' );
	    }

	    return esc_url_raw( $fonts_url );
	}
endif;


/**
 * Require init.
*/
require  trailingslashit( get_template_directory() ).'sparklethemes/init.php';