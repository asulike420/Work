<?php
/**
 * Plugin Name: ShareThis Share Buttons
 * Plugin URI: https://sharethis.com/
 * Description: Integrates the ShareThis Sharing Buttons directly into your website.
 * Version: 1.0.5
 * Author: ShareThis
 * Author URI: https://sharethis.com/
 * Text Domain: sharethis-share-buttons
 * Domain Path: /languages
 * License:     GPL v2 or later

Copyright 2017 ShareThis

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

 * @package ShareThisShareButtons
 */

if ( version_compare( phpversion(), '5.3', '>=' ) ) {
	require_once __DIR__ . '/instance.php';
} else {
	if ( defined( 'WP_CLI' ) ) {
		WP_CLI::warning( _sharethis_share_buttons_php_version_text() );
	} else {
		add_action( 'admin_notices', '_sharethis_share_buttons_php_version_error' );
	}
}

/**
 * Admin notice for incompatible versions of PHP.
 */
function _sharethis_share_buttons_php_version_error() {
	printf( '<div class="error"><p>%s</p></div>', esc_html( _sharethis_share_buttons_php_version_text() ) );
}

/**
 * String describing the minimum PHP version.
 *
 * @return string
 */
function _sharethis_share_buttons_php_version_text() {
	return __( 'ShareThis Share Buttons plugin error: Your version of PHP is too old to run this plugin. You must be running PHP 5.3 or higher.', 'sharethis-share-buttons' );
}

/**
 * The helper function to insert the proper inline button container.
 *
 * @return string
 */
function sharethis_inline_buttons() {
	return '<div class="sharethis-inline-share-buttons"></div>';
}
