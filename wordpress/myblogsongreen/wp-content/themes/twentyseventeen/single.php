<?php
/**
 * The template for displaying all single posts
 *
 * @link https://developer.wordpress.org/themes/basics/template-hierarchy/#single-post
 *
 * @package WordPress
 * @subpackage Twenty_Seventeen
 * @since 1.0
 * @version 1.0
 */

get_header(); ?>

<div class="wrap">
	<div id="primary" class="content-area">
		<main id="main" class="site-main" role="main">

			<?php
			/* Start the Loop */
			while ( have_posts() ) : the_post();

				get_template_part( 'template-parts/post/content', get_post_format() );

				// If comments are open or we have at least one comment, load up the comment template.
				if ( comments_open() || get_comments_number() ) :
					comments_template();
				endif;

				the_post_navigation( array(
					'prev_text' => '<span class="screen-reader-text">' . __( 'Previous Post', 'twentyseventeen' ) . '</span><span aria-hidden="true" class="nav-subtitle">' . __( 'Previous', 'twentyseventeen' ) . '</span> <span class="nav-title"><span class="nav-title-icon-wrapper">' . twentyseventeen_get_svg( array( 'icon' => 'arrow-left' ) ) . '</span>%title</span>',
					'next_text' => '<span class="screen-reader-text">' . __( 'Next Post', 'twentyseventeen' ) . '</span><span aria-hidden="true" class="nav-subtitle">' . __( 'Next', 'twentyseventeen' ) . '</span> <span class="nav-title">%title<span class="nav-title-icon-wrapper">' . twentyseventeen_get_svg( array( 'icon' => 'arrow-right' ) ) . '</span></span>',
				) );

			endwhile; // End of the loop.
			?>

		</main><!-- #main -->
	</div><!-- #primary -->

<?php
if ( is_category('uvm') || ( is_single() && in_category('uvm') ) ) {
    get_sidebar('uvm');  //sidebar-uvm.php
} elseif ( is_category('sv') || ( is_single() && in_category('sv') ) ) {
    get_sidebar('sv'); //sidebar-sv.php
} elseif ( is_category('ethernet') || ( is_single() && in_category('ethernet') ) ) {
    get_sidebar('ethernet'); 
}elseif ( is_category('pcie') || ( is_single() && in_category('pcie') ) ) {
    get_sidebar('pcie'); 
}elseif ( is_category('cplus') || ( is_single() && in_category('cplus') ) ) {
    get_sidebar('cplus'); 
}else {
    get_sidebar();
}
?>


<!-- Abhay ?php get_sidebar(); ?-->
</div><!-- .wrap -->

<?php get_footer();
