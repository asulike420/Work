<?php
/**
 * Main Custom admin functions area
 *
 * @since SparklewpThemes
 *
 * @param Editorial_Mag
 *
*/

/**
 * Load Editorialmag woocommerce Action and Filter.
*/
remove_action( 'woocommerce_before_main_content','woocommerce_breadcrumb', 20 );
add_filter( 'woocommerce_show_page_title', '__return_false' );

remove_action('woocommerce_after_shop_loop_item_title', 'woocommerce_template_loop_rating', 5);

/**
 * WooCommerce add content primary div function
*/
remove_action( 'woocommerce_before_main_content', 'woocommerce_output_content_wrapper', 10 );
if (!function_exists('editorialmag_woocommerce_output_content_wrapper')) {
    function editorialmag_woocommerce_output_content_wrapper(){ ?>
    	<div class="home-right-side">
			<div class="sparkle-wrapper">
				<div id="primary" class="home-main-content content-area">
					<main id="main" class="site-main">
    <?php }
}
add_action( 'woocommerce_before_main_content', 'editorialmag_woocommerce_output_content_wrapper', 10 );

remove_action( 'woocommerce_after_main_content', 'woocommerce_output_content_wrapper_end', 10 );
if (!function_exists('editorialmag_woocommerce_output_content_wrapper_end')) {
    function editorialmag_woocommerce_output_content_wrapper_end(){ ?>
              		</main>
              	</div>

              	<?php get_sidebar('woocommerce'); ?>

            </div>
        </div>
    <?php }
}
add_action( 'woocommerce_after_main_content', 'editorialmag_woocommerce_output_content_wrapper_end', 10 );
remove_action('woocommerce_sidebar', 'woocommerce_get_sidebar', 10 );


/**
 * Woo Commerce Number of row filter Function
*/
add_filter('loop_shop_columns', 'editorialmag_loop_columns');
if (!function_exists('editorialmag_loop_columns')) {
    function editorialmag_loop_columns() {
        return 3;
    }
}

add_action( 'body_class', 'editorialmag_woo_body_class');
if (!function_exists('editorialmag_woo_body_class')) {
    function editorialmag_woo_body_class( $class ) {
           $class[] = 'columns-'.intval(editorialmag_loop_columns());
           return $class;
    }
}

/**
 * WooCommerce display related product.
*/
if (!function_exists('editorialmag_related_products_args')) {
  function editorialmag_related_products_args( $args ) {
      $args['posts_per_page']   = 6;
      $args['columns']          = 3;
      return $args;
  }
}
add_filter( 'woocommerce_output_related_products_args', 'editorialmag_related_products_args' );

/**
 * WooCommerce display upsell product.
*/
remove_action( 'woocommerce_after_single_product_summary', 'woocommerce_upsell_display', 15 );
if ( ! function_exists( 'editorialmag_woocommerce_upsell_display' ) ) {
  function editorialmag_woocommerce_upsell_display() {
      woocommerce_upsell_display( 6, 3 ); 
  }
}
add_action( 'woocommerce_after_single_product_summary', 'editorialmag_woocommerce_upsell_display', 15 );
