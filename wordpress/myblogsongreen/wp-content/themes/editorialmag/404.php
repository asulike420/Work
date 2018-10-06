<?php
/**
 * The template for displaying 404 pages (not found)
 *
 * @link https://codex.wordpress.org/Creating_an_Error_404_Page
 *
 * @package Editorial_Mag
 */

get_header(); ?>	
	<div class="site-content home-no-side">
		<div class="sparkle-wrapper">
			<div class="home-main-content">
				<section class="error-404 not-found">

					<header class="page-header">
						<h1 class="page-title"><?php esc_html_e( 'Oops! That page can&rsquo;t be found.', 'editorialmag' ); ?></h1>
					</header><!-- .page-header -->

					<div class="page-content">
						<p><?php esc_html_e('It looks like nothing was found at this location.','editorialmag'); ?></p>
						<p><a href="<?php echo esc_url( home_url( '/' ) ); ?>"><?php esc_html_e('Click Here','editorialmag'); ?></a> <?php esc_html_e('to go back to homepage.','editorialmag'); ?></p>
						<div class="error-404-text">
							<h1><?php esc_html_e('404','editorialmag'); ?></h1>
						</div>
					</div><!-- .page-content -->
				</section>
			</div><!-- HOME MAIN CONTENT -->
		</div>
	</div>

<?php get_footer();
