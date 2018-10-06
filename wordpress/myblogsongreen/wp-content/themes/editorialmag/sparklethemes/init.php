<?php
/**
 * Main Custom admin functions area
 *
 * @since SparklewpThemes
 *
 * @param Editorial_Mag
 *
*/
if( !function_exists('editorialmag_file_directory') ){

    function editorialmag_file_directory( $file_path ){
        if( file_exists( trailingslashit( get_stylesheet_directory() ) . $file_path) ) {
            return trailingslashit( get_stylesheet_directory() ) . $file_path;
        }
        else{
            return trailingslashit( get_template_directory() ) . $file_path;
        }
    }
}


/**
 * Load Custom Admin functions that act independently of the theme functions.
*/
require editorialmag_file_directory('sparklethemes/functions.php');

/**
 * Custom functions that act independently of the theme header.
*/
require editorialmag_file_directory('sparklethemes/core/custom-header.php');

/**
 * Custom functions that act independently of the theme templates.
*/
require editorialmag_file_directory('sparklethemes/core/template-functions.php');

/**
 * Custom template tags for this theme.
*/
require editorialmag_file_directory('sparklethemes/core/template-tags.php');

/**
 * Load Jetpack compatibility file.
 */
if ( defined( 'JETPACK__VERSION' ) ) {
   require editorialmag_file_directory('sparklethemes/core/jetpack.php');
}

/**
 * Customizer additions.
*/
require editorialmag_file_directory('sparklethemes/customizer/customizer.php');

/**
 * Load widget compatibility field file.
*/
require editorialmag_file_directory('sparklethemes/widget-fields.php');

/**
 * Load widget compatibility tgm file.
*/
require editorialmag_file_directory('sparklethemes/tgm.php');

/**
 * Load theme about page
*/
require editorialmag_file_directory('sparklethemes/admin/about-theme/editorialmag-about.php');


/**
 * Load woocommerce hooks file.
*/
if ( editorialmag_is_woocommerce_activated() ) {
	
	require editorialmag_file_directory('sparklethemes/hooks/woocommerce.php');
}

