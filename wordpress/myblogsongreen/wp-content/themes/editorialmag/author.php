<?php
/**
 * The template for displaying archive pages
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

					<header class="page-header">
						<?php the_archive_title( '<h1 class="page-title"><span>', '</span></h1>' ); ?>
					</header><!-- .page-header -->

					<div class="author-info">
						<figure>
							<?php echo wp_kses_post( get_avatar( get_the_author_meta('email'), 260) ); ?>
						</figure>
						<div class="author-info-content">
							<p><?php the_author_posts_link(); ?></p>
							<div class="author-text">
								<?php the_author_meta('description'); ?>
							</div>
						</div>
					</div>

					<div class="home-alt-list-wrap">						
						<?php
							/* Start the Loop */
							while ( have_posts() ) : the_post();

								/*
								 * Include the Post-Format-specific template for the content.
								 * If you want to override this in a child theme, then include a file
								 * called content-___.php (where ___ is the Post Format name) and that will be used instead.
								 */
								get_template_part( 'template-parts/content', 'author' );

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
