<?php
/**
 * Meta Box Template
 *
 * The template wrapper for post/page meta box.
 *
 * @package ShareThisShareButtons
 */

?>
<div id="sharethis-meta-box">
	<?php if ( ! in_array( $inline_enable, array( null, false, 'false' ), true ) ) : ?>
		<div id="inline" class="button-setting-wrap">
			<h3><?php esc_html_e( 'Inline share buttons', 'sharethis-share-buttons' ); ?></h3>

			<div class="button-check-wrap">
				<input class="top" type="checkbox" id="sharethis-top-post" <?php echo checked( 'true', $this->is_box_checked( 'inline', '_top' ) ); ?>>

				<label for="sharethis-top-post"><?php
					// translators: The post type.
					printf( esc_html__( 'Include at top of %1$s content', 'sharethis-share-buttons' ), esc_html( $post_type ) ); ?>
				</label>
			</div>
			<div class="button-check-wrap">
				<input class="bottom" type="checkbox" id="sharethis-bottom-post" <?php echo checked( 'true', $this->is_box_checked( 'inline', '_bottom' ) ); ?>>

				<label for="sharethis-bottom-post"><?php
					// translators: The post type.
					printf( esc_html__( 'Include at bottom of %1$s content', 'sharethis-share-buttons' ), esc_html( $post_type ) ); ?>
				</label>
			</div>
			<input type="text" class="sharethis-shortcode" readonly value="[sharethis-inline-buttons]">

			<span class="under-message"><?php esc_html_e( 'Inline share button shortcode.', 'sharethis-share-buttons' ); ?></span>
		</div>
	<?php endif; ?>
	<?php if ( ! in_array( $sticky_enable, array( null, false, 'false' ), true ) ) : ?>
		<div id="sticky" class="button-setting-wrap">
			<h3><?php esc_html_e( 'Sticky share buttons', 'sharethis-share-buttons' ); ?></h3>

			<input class="" type="checkbox" id="sharethis-sticky-show" <?php echo checked( 'true', $this->is_box_checked( 'sticky' ) ); ?>>

			<label for="sharethis-sticky-show"><?php
				// translators: The post type.
				printf( esc_html__( 'Include on this %1$s', 'sharethis-share-buttons' ), esc_html( $post_type ) ); ?>
			</label>
		</div>
	<?php endif; ?>
	<a href="<?php echo esc_url( admin_url( 'admin.php?page=sharethis-share-buttons' ) ); ?>">
		<?php esc_html_e( 'Update your default settings', 'sharethis-share-buttons' ); ?>
	</a>
</div>
