<?php
/**
 * On Off Button Template
 *
 * The template wrapper for the On Off button settings.
 *
 * @package ShareThisShareButtons
 */

?>
<div class="onoff-buttons">
	<label class="share-on">
		<input type="radio" id="sharethis_<?php echo esc_attr( $type ); ?>_settings_<?php echo esc_attr( $option ); ?>_on" name="sharethis_<?php echo esc_attr( $type ); ?>_settings[<?php echo esc_attr( $option ); ?>]" value="true" <?php echo false !== $option_value[ $option ] && 'true' === $option_value[ $option ] ? 'checked="checked"' : esc_attr( $default['true'] ); ?>>

		<div class="label-text"><?php esc_html_e( 'On', 'sharethis-share-buttons' ); ?></div>
	</label>
	<label class="share-off">
		<input type="radio" id="sharethis_<?php echo esc_attr( $type ); ?>_settings_<?php echo esc_attr( $option ); ?>_off" name="sharethis_<?php echo esc_attr( $type ); ?>_settings[<?php echo esc_attr( $option ); ?>]" value="false" <?php echo false !== $option_value[ $option ] && 'false' === $option_value[ $option ] ? 'checked="checked"' : esc_attr( $default['false'] ); ?>>

		<div class="label-text"><?php esc_html_e( 'Off', 'sharethis-share-buttons' ); ?></div>
	</label>

	<div class="option-title"><?php echo esc_html( $title ); ?></div>
	<?php if ( $margin ) : ?>
		<button class="margin-control-button<?php echo ' ' . esc_attr( $active['class'] ); ?>" type="button">
			<?php esc_html_e( 'margin', 'sharethis-share-buttons' ); ?>
			<span class="margin-on-off"><?php echo esc_html( $active['onoff'] ); ?></span>
		</button>
		<div class="margin-input-fields">
			<?php esc_html_e( 'top', 'sharethis-share-buttons' ); ?> <input id="sharethis_<?php echo esc_attr( $type ); ?>_settings_<?php echo esc_attr( $option ); ?>_margin_top" name="sharethis_<?php echo esc_attr( $type ); ?>_settings[<?php echo esc_attr( $option ); ?>_margin_top]" type="number" value="<?php echo intval( $option_value[ $option . '_margin_top' ] ); ?>" min="0"> px
			<span class="margin-input-spacer">|</span>
			<?php esc_html_e( 'bottom', 'sharethis-share-buttons' ); ?> <input id="sharethis_<?php echo esc_attr( $type ); ?>_settings_<?php echo esc_attr( $option ); ?>_margin_bottom" name="sharethis_<?php echo esc_attr( $type ); ?>_settings[<?php echo esc_attr( $option ); ?>_margin_bottom]" type="number" value="<?php echo intval( $option_value[ $option . '_margin_bottom' ] ); ?>" min="0"> px
		</div>
	<?php endif; ?>
</div>
