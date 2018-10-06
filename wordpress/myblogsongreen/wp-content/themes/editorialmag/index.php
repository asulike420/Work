<?php
/**
 * The main template file
 *
 * This is the most generic template file in a WordPress theme
 * and one of the two required files for a theme (the other being style.css).
 * It is used to display a page when nothing more specific matches a query.
 * E.g., it puts together the home page when no home.php file exists.
 *
 * @link https://codex.wordpress.org/Template_Hierarchy
 *
 * @package Editorial_Mag
 */

get_header(); ?>

<div class="home-right-side">
	<div class="sparkle-wrapper">
		<div id="primary" class="home-main-content content-area">
			<main id="main" class="site-main">
				<?php
				if ( have_posts() ) : ?>

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
