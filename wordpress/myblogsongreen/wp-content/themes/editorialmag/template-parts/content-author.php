<?php
/**
 * Template part for displaying posts
 *
 * @link https://codex.wordpress.org/Template_Hierarchy
 *
 * @package Editorial_Mag
 */

$image = wp_get_attachment_image_src( get_post_thumbnail_id( get_the_ID() ), 'editorialmag-normal-image', true);

?>
<article id="post-<?php the_ID(); ?>" <?php post_class('home-alt-list-block'); ?>>
	<?php if( has_post_thumbnail() ){ ?>
	    <figure class="nosidebar-image">
	        <a href="<?php the_permalink(); ?>">
	        	<img src="<?php echo esc_url( $image[0] ); ?>" alt="<?php the_title(); ?>">
	        </a>
	    </figure>
	<?php } ?>
	<div class="news-content-wrap">
		
		<h3 class="news-title">
			<a href="<?php the_permalink(); ?>"><?php the_title(); ?></a>
		</h3>

		<?php editorialmag_posted_on(); ?>

		<div class="news-block-content authorpost-content">
			<?php the_excerpt(); ?>
		</div>

		<div class="news-block-footer">
			<div class="news-comment">
				<i class="icofont fa fa-commenting"></i> <?php comments_popup_link( esc_html__( 'No comment', 'editorialmag' ), esc_html__( '1 Comment', 'editorialmag' ), esc_html__( '% Comments', 'editorialmag' ) ); ?>
			</div>
			<div class="news-comment readmore">
                <a href="<?php the_permalink(); ?>">
                	<?php esc_html_e('Continue Reading','editorialmag'); ?> <i class="icofont fa fa-arrow-circle-o-right"></i>
                </a>
            </div>
		</div>
	</div>
</article>