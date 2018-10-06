<?php
/**
 * Enable Button Template
 *
 * The template wrapper for the enable button settings.
 *
 * @package ShareThisShareButtons
 */

$option_value = get_option( 'sharethis_' . $id );
?>
<div id="<?php echo esc_attr( ucfirst( $id ) ); ?>" class="enable-buttons">
	<label class="share-on">
		<input type="radio" id="sharethis_<?php echo esc_attr( $id ); ?>_on" name="sharethis_<?php echo esc_attr( $id ); ?>" value="true" <?php echo esc_attr( checked( 'true', $option_value, false ) ); ?>>
		<div class="label-text"><?php esc_html_e( 'On', 'sharethis-share-buttons' ); ?></div>
	</label>
	<label class="share-off">
		<input type="radio" id="sharethis_<?php echo esc_attr( $id ); ?>_off" name="sharethis_<?php echo esc_attr( $id ); ?>" value="false" <?php echo esc_attr( checked( 'false', $option_value, false ) ); ?>>
		<div class="label-text"><?php esc_html_e( 'Off', 'sharethis-share-buttons' ); ?></div>
	</label>
</div>
