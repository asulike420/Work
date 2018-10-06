<?php
/**
 * The template for displaying search results pages
 *
 * @link https://developer.wordpress.org/themes/basics/template-hierarchy/#search-result
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
						<h1 class="page-title"><span>
							<?php
								/* translators: %s: search query. */
								printf( esc_html__( 'Search Results for: %s', 'editorialmag' ), '<span>' . get_search_query() . '</span>' );
							?>							
						</span></h1>
					</header><!-- .page-header -->

					<div class="archive-grid-wrap clearfix">
						<?php
							/* Start the Loop */
							while ( have_posts() ) : the_post();

								/**
								 * Run the loop for the search to output the results.
								 * If you want to overload this in a child theme then include a file
								 * called content-search.php and that will be used instead.
								 */
								get_template_part( 'template-parts/content', 'search' );

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