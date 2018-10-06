<?php
/**
 * Property Settings Template
 *
 * The template wrapper for the property setting.
 *
 * @package ShareThisShareButtons
 */

?>
<?php echo wp_kses_post( $error_message ); ?>
<input type="text" name="sharethis_property_id" placeholder="Enter Property ID" value="<?php echo esc_attr( $credential ); ?>" size="72">
