<?php
/**
 * General Settings Template
 *
 * The template wrapper for the general settings page.
 *
 * @package ShareThisShareButtons
 */

// Get random gif.
$image = $this->random_gif();
?>
<div class="wrap sharethis-general-wrap">
	<h1>
		<?php echo esc_html( get_admin_page_title() ); ?>
	</h1>

	<h4>
		<?php
		// translators: User display name.
		printf( esc_html__( 'Hi there, %1$s!', 'sharethis-share-buttons' ), esc_html( $current_user->display_name ) ); ?>

		<?php
		// translators: Contact link.
		printf( esc_html__( 'Thanks for using ShareThis. If you have any questions please don\'t hesitate to %1$s contact our support %2$s We\'re here for you!', 'sharethis-share-buttons' ), '<a class="st-contact" href="https://www.sharethis.com/contact?utm_source=sharethis-plugin&utm_medium=sharethis-plugin-page&utm_campaign=support" target="_blank">', '</a>' ); ?>
	</h4>

	<form action="options.php" method="post">
		<?php
		settings_fields( $this->menu_slug . '-general' );
		do_settings_sections( $this->menu_slug . '-general' );
		submit_button( esc_html__( 'Update', 'sharethis-share-buttons' ) );
		?>
	</form>
	<table class="random-form-table">
		<tbody>
		<tr>
			<th scope="row">
				<?php esc_html_e( 'A random GIF', 'sharethis-share-buttons' ); ?>

				<span>
					<?php esc_html_e( 'Honestly, this page was pretty boring, so we threw this in for good measure.  You\'re welcome.', 'sharethis-share-buttons' ); ?>
				</span>
			</th>
			<td>
				<?php echo wp_kses_post( $image ); ?>
			</td>
		</tr>
		</tbody>
	</table>
	<table class="random-form-table">
		<tbody>
		<tr>
			<th scope="row">
				<span>
					<?php esc_html_e( 'Re-read our', 'sharethis-share-buttons' ); ?>
					<a href="https://www.sharethis.com/privacy?utm_source=sharethis-plugin&utm_medium=sharethis-plugin-page&utm_campaign=Legal" target="_blank">
						<?php esc_html_e( 'Privacy Notice', 'sharethis-share-buttons' ); ?></a>,
					<a href="https://www.sharethis.com/publisher-terms-of-use?utm_source=sharethis-plugin&utm_medium=sharethis-plugin-page&utm_campaign=Legal" target="_blank">
						<?php esc_html_e( 'Publisher Terms of User', 'sharethis-share-buttons' ); ?></a>,
					<?php esc_html_e( 'and', 'sharethis-share-buttons' ); ?>
					<a href="https://www.sharethis.com/publisher?utm_source=sharethis-plugin&utm_medium=sharethis-plugin-page&utm_campaign=Legal" target="_blank">
						<?php esc_html_e( 'Publisher Information', 'sharethis-share-buttons' ); ?></a>
					<?php esc_html_e( 'pages.', 'sharethis-share-buttons' ); ?>
				</span>
			</th>
		</tr>
		</tbody>
	</table>
</div>
