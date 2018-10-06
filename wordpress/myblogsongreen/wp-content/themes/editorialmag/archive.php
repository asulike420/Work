<?php
/**
 * The template for displaying archive pages
 *
 * @link https://codex.wordpress.org/Template_Hierarchy
 *
 * @package Editorial_Mag
 */

get_header(); ?>

<?php 
    $post_sidebar = get_theme_mod( 'editorialmag_archive_page_layout','rightsidebar' );
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
					if ( have_posts() ) : ?>

						<header class="page-header">
							<?php
								the_archive_title( '<h1 class="page-title"><span>', '</span></h1>' );
								the_archive_description( '<div class="archive-description">', '</div>' );
							?>
						</header><!-- .page-header -->

						<div class="archive-grid-wrap clearfix">
							<?php
								/* Start the Loop */
								while ( have_posts() ) : the_post();

									/*
									 * Include the Post-Format-specific template for the content.
									 * If you want to override this in a child theme, then include a file
									 * called content-___.php (where ___ is the Post Format name) and that will be used instead.
									 */
									get_template_part( 'template-parts/content', get_post_format() );

								endwhile;
							?>
						</div>
						<?php
								the_posts_pagination( 
				            		array(
									    'prev_text' => esc_html__( 'Prev', 'editorialmag' ),
									    'next_text' => esc_html__( 'Next', 'editorialmag' ),
									)
					            );

						else :

							get_template_part( 'template-parts/content', 'none' );

						endif; 
					?>
				</main><!-- #main -->
			</div><!-- #primary -->

			<?php get_sidebar(); ?><!-- SIDEBAR -->
		</div>
	</div>

<?php get_footer();
