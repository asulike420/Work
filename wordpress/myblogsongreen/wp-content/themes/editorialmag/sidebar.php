<?php
/**
 * The sidebar containing the main widget area
 *
 * @link https://developer.wordpress.org/themes/basics/template-files/#template-partials
 *
 * @package Editorial_Mag
 */

$post_sidebar = esc_attr( get_post_meta($post->ID, 'editorialmag_page_layouts', true) );

if(!$post_sidebar){
	$post_sidebar = 'rightsidebar';
}

if ( $post_sidebar ==  'nosidebar' ) {
	return;
}


if( $post_sidebar == 'rightsidebar' && is_active_sidebar('sidebar-1')){ ?>
		<section id="secondaryright" class="home-right-sidebar widget-area" role="complementary">
			<?php dynamic_sidebar( 'sidebar-1' ); ?>
		</section><!-- #secondary -->
	<?php
}

if( $post_sidebar == 'leftsidebar' && is_active_sidebar('sidebar-2')){ ?>
		<section id="secondaryleft" class="home-left-sidebar widget-area" role="complementary">
			<?php dynamic_sidebar( 'sidebar-2' ); ?>
		</section><!-- #secondary -->
	<?php
}