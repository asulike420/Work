<?php
/**
 * Shortcode Template
 *
 * The template wrapper for inline share button shortcode.
 *
 * @package ShareThisShareButtons
 */

?>
<textarea id="holdtext" style="display:none;"></textarea>

<div class="readonly-input-field">
	<input type="text" id="inline-<?php echo esc_attr( $type['type'] ); ?>" value="<?php echo esc_attr( $type['value'] ); ?>" readonly size="40"/>
	<button type="button" id="copy-<?php echo esc_attr( $type['type'] ); ?>"><?php esc_html_e( 'Copy', 'sharethis-share-buttons' ); ?></button>
</div>
