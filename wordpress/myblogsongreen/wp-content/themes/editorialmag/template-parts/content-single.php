<?php
/**
 * Template part for displaying posts
 *
 * @link https://codex.wordpress.org/Template_Hierarchy
 *
 * @package Editorial_Mag
 */

$image = wp_get_attachment_image_src( get_post_thumbnail_id( get_the_ID() ), 'editorialmag-large', true);

?>
<article id="post-<?php the_ID(); ?>" <?php post_class(); ?>>
	<header class="entry-header">
		<div class="entry-meta">
			<span class="posted-on">
				<?php esc_html_e('Posted on :','editorialmag'); ?> <a href="<?php the_permalink(); ?>"><?php the_time( get_option( 'date_format' ) ); ?></a>
			</span>
			<span class="byline"> 
				By 
				<span class="author vcard">
					<?php the_author_posts_link(); ?>
				</span>
			</span>
		</div><!-- .entry-meta -->
	</header><!-- .entry-header -->

	<div class="entry-content">		
		<?php if( has_post_thumbnail() ){ ?>
		    <figure class="nosidebar-image">
		        <img src="<?php echo esc_url( $image[0] ); ?>" alt="<?php the_title(); ?>">
		    </figure>
		<?php } ?>
		
		<?php editorialmag_colored_category(); ?>

		<?php 
		    the_content( sprintf(
		      /* translators: %s: Name of current post. */
		      wp_kses( esc_html__( 'Continue reading %s <span class="meta-nav">&rarr;</span>', 'editorialmag' ), array( 'span' => array( 'class' => array() ) ) ),
		      the_title( '<span class="screen-reader-text">"', '"</span>', false )
		    ) );

		    wp_link_pages( array(
			    'before'            => '<div class="desc-nav">'.esc_html__( 'Pages:', 'editorialmag' ),
			    'after'             => '</div>',
			    'link_before'       => '<span>',
			    'link_after'        => '</span>'
		    ) );
		?>
	</div><!-- .entry-content -->
</article><!-- #post-## -->

<div class="sparkle-author-box">
	<div class="sparkle-author-image">
		<?php echo wp_kses_post( get_avatar( get_the_author_meta('email'), 260) ); ?>
	</div>
	<div class="sparkle-author-details">
		<span class="author-name">
			<?php the_author_posts_link(); ?>
		</span>
		<span class="author-designation">
			<?php esc_html_e('News Reporter','editorialmag'); ?>
		</span>
		<div class="author-desc">
			<?php the_author_meta('description'); ?>
		</div>
	</div><!-- .author-details -->
</div>

<nav class="navigation post-navigation">
	<div class="nav-links">
		<?php
			previous_post_link( '<div class="nav-previous">%link</div>', '%title', TRUE );
			next_post_link( '<div class="nav-next">%link</div>', '%title', TRUE );
		?>
	</div>
</nav>

