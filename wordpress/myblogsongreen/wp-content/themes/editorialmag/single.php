<?php
/**
 * The template for displaying all single posts
 *
 * @link https://developer.wordpress.org/themes/basics/template-hierarchy/#single-post
 *
 * @package Editorial_Mag
 */

get_header(); ?>

<?php 
    $post_sidebar = esc_attr( get_post_meta($post->ID, 'editorialmag_page_layouts', true) );
    if(empty($post_sidebar)){
    	$post_sidebar = esc_attr( get_theme_mod( 'editorialmag_single_posts_layout','rightsidebar' ) );
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
					<header class="page-header">
						<?php the_title( '<h1 class="page-title"><span>', '</span></h1>' ); ?>
					</header><!-- .page-header -->
					<?php
						while ( have_posts() ) : the_post();

							get_template_part( 'template-parts/content', 'single' );

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
