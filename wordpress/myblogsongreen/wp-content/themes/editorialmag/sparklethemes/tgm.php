<?php
/**
 * Plugin recommendation.
 *
 * @package Editorial_Mag
 */

// Load TGM library.
require_once trailingslashit( get_template_directory() ) . 'sparklethemes/tgm/class-tgm-plugin-activation.php';

if ( ! function_exists( 'editorialmag_register_recommended_plugins' ) ) :

	/**
	 * Register recommended plugins.
	 *
	 * @since 1.0.0
	 */
	function editorialmag_register_recommended_plugins() {

		$plugins = array(						
            array(
				'name' => esc_html__( 'Share Buttons by AddThis', 'editorialmag' ),
				'slug' => 'addthis',
				'required' => false,
            ),
            array(
				'name' => esc_html__( 'Social Media Share Buttons | MashShare', 'editorialmag' ),
				'slug' => 'mashsharer',
				'required' => false,
            ),
            array(
				'name' => esc_html__( 'Contact Form 7', 'editorialmag' ),
				'slug' => 'contact-form-7',
				'required' => false,
            ),
            array(
				'name' => esc_html__( 'Regenerate Thumbnails', 'editorialmag' ),
				'slug' => 'regenerate-thumbnails',
				'required' => false,
            ),
            array(
            	'name'     => esc_html__( 'WooCommerce', 'editorialmag' ),
            	'slug'     => 'woocommerce',
            	'required' => false,
            ),
		);

		$config = array();

		tgmpa( $plugins, $config );

	}

endif;

add_action( 'tgmpa_register', 'editorialmag_register_recommended_plugins' );
