<?php
/**
 * Template Name: Editorialmag - FrontPage
 *
 * @link https://developer.wordpress.org/themes/basics/theme-functions/
 *
 * @package Editorial_Mag
 */
get_header(); ?>
	
	<?php if( is_active_sidebar( 'home-1' ) ){ ?>
		<section class="bannersection fullwidthsection">
			<div class="sparkle-wrapper">
				<?php dynamic_sidebar( 'home-1' ); ?>				
			</div>
		</section> <!-- Full Width Top Widget Area -->
	<?php } ?>

	<?php 
	    $post_sidebar = esc_attr( get_post_meta($post->ID, 'editorialmag_page_layouts', true) );
	    if($post_sidebar == 'rightsidebar'){
	        $post_sidebar = 'right';
	    }elseif($post_sidebar == 'leftsidebar'){
	        $post_sidebar = 'left';
	    }else{
	    	$post_sidebar = 'no';
	    }
	?>

	<div class="site-content home-<?php echo esc_attr( $post_sidebar ); ?>-side bannersection">
		<div class="sparkle-wrapper">			
			<div class="home-main-content content-area">
				<?php 
				    if( is_active_sidebar( 'home-2' ) ){
				        dynamic_sidebar( 'home-2' );
				    }
				?>
			</div><!-- HOME MAIN CONTENT -->
			
			<?php get_sidebar(); ?><!-- SIDEBAR -->
		</div>
	</div>

	<?php if( is_active_sidebar( 'home-3' ) ){ ?>
		<section class="bannersection fullwidthsection">
			<div class="sparkle-wrapper">
				<?php dynamic_sidebar( 'home-3' ); ?>				
			</div>
		</section> <!-- Full Width Top Widget Area -->
	<?php } ?>

<?php get_footer();