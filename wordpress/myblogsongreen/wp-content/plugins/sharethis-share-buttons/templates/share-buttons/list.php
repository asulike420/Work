<?php
/**
 * List Template
 *
 * The template wrapper for the list of pages / categories used for exclusion.
 *
 * @package ShareThisShareButtons
 */

?>
<div class="list-wrapper">
	<h4><?php
		// translators: The list type plural.
		printf( esc_html__( 'Exclude specific %1$s', 'sharethis-share-buttons' ), esc_html( $type['multi'] ) ); ?></h4>
	<input id="<?php echo esc_attr( $type['single'] ); ?>-ta" type="text" placeholder="
	<?php
		// translators: The list type singular.
		printf( esc_html__( 'Search for a %1$s', 'sharethis-share-buttons' ), esc_html( $type['single'] ) ); ?>" size="40" autocomplete="off">
	<span id="<?php echo esc_attr( $type['single'] ); ?>" class="search-st-icon"></span>
	<ul id="<?php echo esc_attr( $type['single'] ); ?>-result-wrapper"></ul>
	<ul id="<?php echo esc_attr( $type['single'] ); ?>-current-omit"><?php echo wp_kses( $current_omit, $allowed ); ?></ul>
</div>

