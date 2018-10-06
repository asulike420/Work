<?php
/**
 * Editorial Mag Theme Customizer
 *
 * @package Editorial_Mag
 */

/**
 * Add postMessage support for site title and description for the Theme Customizer.
 *
 * @param WP_Customize_Manager $wp_customize Theme Customizer object.
 */
function editorialmag_customize_register( $wp_customize ) {
	$wp_customize->get_setting( 'blogname' )->transport         = 'postMessage';
	$wp_customize->get_setting( 'blogdescription' )->transport  = 'postMessage';
	$wp_customize->get_setting( 'header_textcolor' )->transport = 'postMessage';

	$wp_customize->add_panel('editorialmag_general_settings', array(
	  'capabitity' => 'edit_theme_options',
	  'priority' => 3,
	  'title' => esc_html__('General Settings', 'editorialmag')
	));

	$wp_customize->get_section('title_tagline' )->panel = 'editorialmag_general_settings';
	$wp_customize->get_section('header_image' )->panel = 'editorialmag_general_settings';
	$wp_customize->get_section('background_image' )->panel = 'editorialmag_general_settings';


/*sorting core and widget for ease of theme use*/
$wp_customize->get_section( 'static_front_page' )->priority = 1;
/**
 * Important Link
*/
$wp_customize->add_section( 'editorialmag_implink_section', array(
  'title'       => esc_html__( 'Important Links', 'editorialmag' ),
  'priority'      => 1
) );

    $wp_customize->add_setting( 'editorialmag_imp_links', array(
      'sanitize_callback' => 'editorialmag_text_sanitize'
    ));

    $wp_customize->add_control( new Editorialmag_theme_Info_Text( $wp_customize,'editorialmag_imp_links', array(
        'settings'    => 'editorialmag_imp_links',
        'section'     => 'editorialmag_implink_section',
        'description' => '<a class="implink" href="http://docs.sparklewpthemes.com/editorialmag/" target="_blank">'.esc_html__('Documentation', 'editorialmag').'</a><a class="implink" href="http://demo.sparklewpthemes.com/editorialmag/demos/" target="_blank">'.esc_html__('Live Demo', 'editorialmag').'</a><a class="implink" href="https://www.sparklewpthemes.com/support/" target="_blank">'.esc_html__('Support Forum', 'editorialmag').'</a><a class="implink" href="https://www.facebook.com/sparklethemes" target="_blank">'.esc_html__('Like Us in Facebook', 'editorialmag').'</a>',
      )
    ));

/**
 * Themes Color Settings
*/	
	$wp_customize->add_panel('editorialmag_color_options', array(
		'priority' => 4,
		'title' => esc_html__('Themes Colors Settings', 'editorialmag'),
		'description'=> esc_html__('Change the Colors from here as you want', 'editorialmag'),
	));

    $wp_customize->get_section('colors' )->panel = 'editorialmag_color_options';

   
   /**
    * Category Color Options   
    */
	$wp_customize->add_section('editorialmag_category_color_setting', array(
		'title' => esc_html__('Category Color Settings', 'editorialmag'),
		'panel' => 'editorialmag_color_options'
	));

    $i = 1;
    $args = array(
       'orderby' => 'id',
       'hide_empty' => 0
    );

    $categories = get_categories( $args );

    $wp_category_list = array();

    foreach ($categories as $category_list ) {

        $wp_category_list[$category_list->cat_ID] = $category_list->cat_name;

        $wp_customize->add_setting('editorialmag_category_color_'.get_cat_id( $wp_category_list[ $category_list->cat_ID ] ), array(
			'default' => '',
			'capability' => 'edit_theme_options',
			'sanitize_callback' => 'editorialmag_color_option_hex_sanitize',
			'sanitize_js_callback' => 'editorialmag_color_escaping_option_sanitize'  // done
        ));

        $wp_customize->add_control(new WP_Customize_Color_Control($wp_customize, 'editorialmag_category_color_'.get_cat_id( $wp_category_list[ $category_list->cat_ID ] ), array(
			'label' => sprintf( '%1$s', $wp_category_list[ $category_list->cat_ID ] ),
			'section' => 'editorialmag_category_color_setting',
			'settings' => 'editorialmag_category_color_'.get_cat_id( $wp_category_list[ $category_list->cat_ID ] ),
			'priority' => $i
        )));

        $i++;
    }

/**
 * Breaking News Section
*/
	$wp_customize->add_section('editorialmag_breaking_news_settings', array(
		'priority' => 6,
		'title' => esc_html__('Breaking News Settings', 'editorialmag'),
	));

		$wp_customize->add_setting('editorialmag_breaking_news_section', array(
		    'default' => 'enable',
		    'sanitize_callback' => 'editorialmag_radio_enable_sanitize', // done
		));

		$wp_customize->add_control('editorialmag_breaking_news_section', array(
		    'type' => 'radio',
		    'label' => esc_html__('Breaking News Section', 'editorialmag'),
		    'description' => esc_html__('Choose the option as you want', 'editorialmag'),
		    'section' => 'editorialmag_breaking_news_settings',
		    'setting' => 'editorialmag_breaking_news_section',
		    'choices' => array(
		    	'enable' => esc_html__('Enable', 'editorialmag'),
		        'disable' => esc_html__('Disable', 'editorialmag'),
		)));

		/**
		 * Breaking News Category 
		*/
		$wp_customize->add_setting( 'editorialmag_breaking_news_team_id', array(
		    'default' => 1,
		    'sanitize_callback' => 'absint',
		) );

		$wp_customize->add_control( new Editorialmag_Category_Dropdown( $wp_customize, 'editorialmag_breaking_news_team_id', array(
		    'label' => esc_html__( 'Select Breaking News Category', 'editorialmag' ),
		    'section' => 'editorialmag_breaking_news_settings'        
		) ) );


/**
 * Home 1 - Full Width Section
*/
$editorialmag_home1_section = $wp_customize->get_section( 'sidebar-widgets-home-1' );
if ( ! empty( $editorialmag_home1_section ) ) {
    $editorialmag_home1_section->panel = '';
    $editorialmag_home1_section->title = esc_html__( 'Home 1 - Full Width Section', 'editorialmag' );
    $editorialmag_home1_section->priority = 6;
}

/**
 * Home 2 - 3/1 Main Block Section
*/
$editorialmag_home2_section = $wp_customize->get_section( 'sidebar-widgets-home-2' );
if ( ! empty( $editorialmag_home2_section ) ) {
    $editorialmag_home2_section->panel = '';
    $editorialmag_home2_section->title = esc_html__( 'Home 2 - 3/1 Main Block Section', 'editorialmag' );
    $editorialmag_home2_section->priority = 6;
}

/**
 * Home 3 - Full Width Section
*/
$editorialmag_home3_section = $wp_customize->get_section( 'sidebar-widgets-home-3' );
if ( ! empty( $editorialmag_home3_section ) ) {
    $editorialmag_home3_section->panel = '';
    $editorialmag_home3_section->title = esc_html__( 'Home 3 - Full Width Section', 'editorialmag' );
    $editorialmag_home3_section->priority = 6;
}

/**
 * Design Layout Setting
*/
	$wp_customize->add_panel('editorialmag_design_options', array(
	   'description' => esc_html__('Change the Design Settings from here as you want', 'editorialmag'),
	   'priority' => 7,
	   'title' => esc_html__('Design Layout Settings', 'editorialmag')
	));
	    
		$imagepath =  get_template_directory_uri() . '/assets/images/';

		/**
		 * Layout for pages only
		*/
		$wp_customize->add_section('editorialmag_layout_page_setting', array(
			'title' => esc_html__('Layout for Pages Only', 'editorialmag'),
			'panel'=> 'editorialmag_design_options'
		));

	   	$wp_customize->add_setting('editorialmag_page_layout', array(
	   		'default' => 'rightsidebar',
	   		'sanitize_callback' => 'editorialmag_layout_sanitize'  //done
	   	));

	   	$wp_customize->add_control( new Editorialmag_Image_Radio_Control( $wp_customize, 'editorialmag_page_layout', array(
	   		'type' => 'radio',
	   		'label' => esc_html__('Select Layout for Pages. This Layout will be Reflected in all Pages Unless Unique Layout is set For Specific Page', 'editorialmag'),
	   		'section' => 'editorialmag_layout_page_setting',
	   		'settings' => 'editorialmag_page_layout',
	   		'choices' => array( 
	                'leftsidebar'  => $imagepath . 'left-sidebar.png',  
	                'rightsidebar' => $imagepath . 'right-sidebar.png',
	                'nosidebar'    => $imagepath . 'no-sidebar.png',
	            )
	   	) ) );


		/**
		* Category Page Settings
		*/
		$wp_customize->add_section('editorialmag_archive_page_layout_setting', array(
			'title' => esc_html__('Layout for Archive Page Only', 'editorialmag'),
			'panel'=> 'editorialmag_design_options'
		));

		    $wp_customize->add_setting('editorialmag_archive_page_layout', array(
				'default' => 'rightsidebar',
				'capability' => 'edit_theme_options',
				'sanitize_callback' => 'editorialmag_layout_sanitize'  //done
		    ));

		    $wp_customize->add_control( new Editorialmag_Image_Radio_Control( $wp_customize, 'editorialmag_archive_page_layout', array(
				'type' => 'radio',
				'label' => esc_html__('Select Category Page Layout', 'editorialmag'),
				'section' => 'editorialmag_archive_page_layout_setting',
				'settings' => 'editorialmag_archive_page_layout',
				'choices' => array( 
		            'leftsidebar'   => $imagepath . 'left-sidebar.png',  
		            'rightsidebar'  => $imagepath . 'right-sidebar.png',
		            'nosidebar'     => $imagepath . 'no-sidebar.png',
		        )
		    )));

		/**
		 * Single Posts Page Settings
		*/
		$wp_customize->add_section('editorialmag_single_posts_layout_setting', array(
			'title' => esc_html__('Layout for Single Posts Only', 'editorialmag'),
			'panel'=> 'editorialmag_design_options'
		));

		   	$wp_customize->add_setting('editorialmag_single_posts_layout', array(
		   		'default' => 'rightsidebar',
		   		'sanitize_callback' => 'editorialmag_layout_sanitize'  //done
		   	));

		   	$wp_customize->add_control(new Editorialmag_Image_Radio_Control($wp_customize, 'editorialmag_single_posts_layout', array(
		   		'type' => 'radio',
		   		'label' => esc_html__('Select Layout for Single Posts', 'editorialmag'),
		   		'section' => 'editorialmag_single_posts_layout_setting',
		   		'settings' => 'editorialmag_single_posts_layout',
		   		'choices' => array( 
						'leftsidebar'  => $imagepath . 'left-sidebar.png',  
						'rightsidebar' => $imagepath . 'right-sidebar.png',
						'nosidebar'    => $imagepath . 'no-sidebar.png',
		            )
		   	)));

/**
 * Social Media Link Options
*/
	$wp_customize->add_section('editorialmag_social_link_activate_settings', array(
		'priority' => 8,
		'title' => esc_html__('Social Media Links Settings', 'editorialmag'),
	));

		$wp_customize->add_setting('editorialmag_social_media_link', array(
		    'default' => 'enable',
		    'sanitize_callback' => 'editorialmag_radio_enable_sanitize', // done
		));

		$wp_customize->add_control('editorialmag_social_media_link', array(
		    'type' => 'radio',
		    'label' => esc_html__('Footer Sociala Media Link', 'editorialmag'),
		    'description' => esc_html__('Choose the option as you want', 'editorialmag'),
		    'section' => 'editorialmag_social_link_activate_settings',
		    'setting' => 'editorialmag_social_media_link',
		    'choices' => array(
		    	'enable' => esc_html__('Enable', 'editorialmag'),
		        'disable' => esc_html__('Disable', 'editorialmag'),
		)));

	    $editorialmag_social_links = array(
	          'editorialmag_social_facebook' => array(
	          'id' => 'editorialmag_social_facebook',
	          'title' => esc_html__('Facebook', 'editorialmag'),
	          'default' => ''
	        ),
	          'editorialmag_social_twitter' => array(
	          'id' => 'editorialmag_social_twitter',
	          'title' => esc_html__('Twitter', 'editorialmag'),
	          'default' => ''
	        ),
	          'editorialmag_social_linkedin' => array(
	          'id' => 'editorialmag_social_linkedin',
	          'title' => esc_html__('Linkendin', 'editorialmag'),
	          'default' => ''
	        ),
	          'editorialmag_social_youtube' => array(
	          'id' => 'editorialmag_social_youtube',
	          'title' => esc_html__('YouTube', 'editorialmag'),
	          'default' => ''
	        ),
	          'editorialmag_social_instagram' => array(
	          'id' => 'editorialmag_social_instagram',
	          'title' => esc_html__('Instagram', 'editorialmag'),
	          'default' => ''
	        ),
	    );

	    $i = 20;

	    foreach($editorialmag_social_links as $editorialmag_social_link) {

	        $wp_customize->add_setting($editorialmag_social_link['id'], array(
				'default' => $editorialmag_social_link['default'],
				'capability' => 'edit_theme_options',
				'sanitize_callback' => 'esc_url_raw'  // done
	        ));

	        $wp_customize->add_control($editorialmag_social_link['id'], array(
				'label' => $editorialmag_social_link['title'],
				'section'=> 'editorialmag_social_link_activate_settings',
				'settings'=> $editorialmag_social_link['id'],
				'priority' => $i
	        ));

	        $i++;

	    }


/**
 * Footer Section      
*/
    $wp_customize->add_panel('editorialmag_footer_settings', array(
      'priority' => 9,
      'title' => esc_html__('Footer Settings', 'editorialmag'),
    ));
   

		/**
		* Footer Area One Settings
		*/
		$wp_customize->add_section('editorialmag_footer_buttom_area_settings', array(
			'title' => esc_html__('Footer Area Settings', 'editorialmag'),
			'panel'=> 'editorialmag_footer_settings'
		));
    

		$wp_customize->add_setting('editorialmag_footer_buttom_copyright_setting', array(
			'default' => '',
			'capability' => 'edit_theme_options',
			'sanitize_callback' => 'editorialmag_text_sanitize'  //done
		));

		$wp_customize->add_control('editorialmag_footer_buttom_copyright_setting', array(
			'type' => 'textarea',
			'label' => esc_html__('Footer Content (Copyright Text)', 'editorialmag'),
			'section' => 'editorialmag_footer_buttom_area_settings',
			'settings' => 'editorialmag_footer_buttom_copyright_setting'
		) );  



	if ( isset( $wp_customize->selective_refresh ) ) {
		$wp_customize->selective_refresh->add_partial( 'blogname', array(
			'selector'        => '.site-title a',
			'render_callback' => 'editorialmag_customize_partial_blogname',
		) );
		$wp_customize->selective_refresh->add_partial( 'blogdescription', array(
			'selector'        => '.site-description',
			'render_callback' => 'editorialmag_customize_partial_blogdescription',
		) );
	}


	/**
     * Text fields sanitization
    */
    function editorialmag_text_sanitize( $input ) {
        return wp_kses_post( force_balance_tags( $input ) );
    }

    /**
     * Category Colors Sanitization
    */
	function editorialmag_color_option_hex_sanitize($color) {
	  if ($unhashed = sanitize_hex_color_no_hash($color))
	     return '#' . $unhashed;
	  return $color;
	}

	function editorialmag_color_escaping_option_sanitize($input) {
	  $input = esc_attr($input);
	  return $input;
	}

	/**
	 * Enable/Disable Sanitization
	*/
	function editorialmag_radio_enable_sanitize($input) {
	    $valid_keys = array(
	     'enable' => esc_html__('Enable', 'editorialmag'),
	     'disable' => esc_html__('Disable', 'editorialmag'),
	    );
	    if ( array_key_exists( $input, $valid_keys ) ) {
	      return $input;
	    } else {
	      return '';
	    }
	}

	/**
	 * Page Layout Sanitization
	*/
	function editorialmag_layout_sanitize($input) {
		$imagepath =  get_template_directory_uri() . '/assets/images/';

		$valid_keys = array( 
			'leftsidebar'  => $imagepath . 'left-sidebar.png',  
            'rightsidebar' => $imagepath . 'right-sidebar.png',
            'nosidebar'    => $imagepath . 'no-sidebar.png',
		);
		if ( array_key_exists( $input, $valid_keys ) ) {
			return $input;
		} else {
			return '';
		}
	}

}
add_action( 'customize_register', 'editorialmag_customize_register' );

/**
 * Render the site title for the selective refresh partial.
 *
 * @return void
 */
function editorialmag_customize_partial_blogname() {
	bloginfo( 'name' );
}

/**
 * Render the site tagline for the selective refresh partial.
 *
 * @return void
 */
function editorialmag_customize_partial_blogdescription() {
	bloginfo( 'description' );
}

/**
 * Binds JS handlers to make Theme Customizer preview reload changes asynchronously.
 */
function editorialmag_customize_preview_js() {
	wp_enqueue_script( 'editorialmag-customizer', get_template_directory_uri() . '/assets/js/customizer.js', array( 'customize-preview' ), '20151215', true );
}
add_action( 'customize_preview_init', 'editorialmag_customize_preview_js' );

/**
 * Binds JS handlers to make Theme Customizer preview reload changes asynchronously.
 */
function editorialmag_customize_controls_scripts() {
    wp_enqueue_script( 'editorialmag-customizer-controls', get_template_directory_uri() . '/assets/js/customizer-controls.js', array( 'customize-preview' ), '1.1.0', true );
}
add_action( 'customize_controls_enqueue_scripts', 'editorialmag_customize_controls_scripts' );