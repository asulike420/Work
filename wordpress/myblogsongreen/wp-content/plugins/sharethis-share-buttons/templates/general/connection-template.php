<?php
/**
 * Connection Template
 *
 * The template wrapper for the property id connection page.
 *
 * @package ShareThisShareButtons
 */

?>
<div class="wrap sharethis-connection-wrap">
	<h1>
		<?php echo esc_html( get_admin_page_title() ); ?>
	</h1>

	<h4>
		<?php esc_html_e( 'Hi there,', 'sharethis-share-buttons' ); ?> <?php echo esc_html( $current_user->display_name ); ?>!
		<?php esc_html_e( 'Unlock the power of ShareThis + WordPress. Click the button below to get started', 'sharethis-share-buttons' ); ?>.
	</h4>

	<a class="create-account" href="https://platform.sharethis.com/get-share-buttons?domain=<?php echo esc_attr( $admin_url ); ?>&product=wordpress&utm_source=sharethis-plugin&utm_medium=sharethis-plugin-page&utm_campaign=registration" target="_self">
		<?php esc_html_e( 'Configure share buttons and create an account', 'sharethis-share-buttons' ); ?>
	</a>
	<div id="sharethis-loading">
		<img src="<?php echo esc_url( "{$this->plugin->dir_url}assets/st-loading.gif" ); ?>"/>
		<span><?php esc_html_e( 'Your connection is being made', 'sharethis-share-buttons' ); ?>...</span>
	</div>
</div>
