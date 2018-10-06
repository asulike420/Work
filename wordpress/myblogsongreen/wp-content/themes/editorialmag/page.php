<?php
/**
 * The template for displaying all pages
 *
 * This is the template that displays all pages by default.
 * Please note that this is the WordPress construct of pages
 * and that other 'pages' on your WordPress site may use a
 * different template.
 *
 * @link https://codex.wordpress.org/Template_Hierarchy
 *
 * @package Editorial_Mag
 */

get_header(); ?>

<?php 
    $post_sidebar = esc_attr( get_post_meta($post->ID, 'editorialmag_page_layouts', true) );
    if(empty($post_sidebar)){
    	$post_sidebar = esc_attr( get_theme_mod( 'editorialmag_page_layout','rightsidebar' ) );
    }
    if($post_sidebar == 'rightsidebar'){
        $post_sidebar = 'right';
    }elseif($post_sidebar == 'leftsidebar'){
        $post_sidebar = 'left';
    }else{
    	$post_sidebar = 'no';
    }
?>

<div class="home-<?php echo esc_attr( $post_sidebar ); ?>-side">
	<div class="sparkle-wrapper">
		<div id="primary" class="home-main-content content-area">
			<main id="main" class="site-main">
				<?php
					while ( have_posts() ) : the_post();

						get_template_part( 'template-parts/content', 'page' );

						// If comments are open or we have at least one comment, load up the comment template.
						if ( comments_open() || get_comments_number() ) :
							comments_template();
						endif;

					endwhile; // End of the loop.
				?>
			</main><!-- #main -->
		</div><!-- #primary -->

		<?php get_sidebar(); ?><!-- SIDEBAR -->
	</div>
</div>
<?php get_footer();
