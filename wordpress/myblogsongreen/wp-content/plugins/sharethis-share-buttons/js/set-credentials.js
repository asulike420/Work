/**
 * Credentials
 *
 * @package ShareThisShareButtons
 */

/* exported Credentials */
var Credentials = ( function( $, wp ) {
	'use strict';

	return {
		/**
		 * Holds data.
		 */
		data: {},

		/**
		 * Boot plugin.
		 *
		 * @param data
		 */
		boot: function( data ) {
			this.data = data;

			$( document ).ready( function() {
				this.init();
			}.bind( this ) );
		},

		/**
		 * Initialize plugin.
		 */
		init: function() {
			this.setCredentials();
		},

		/**
		 * Send hash data to credential setting.
		 */
		setCredentials: function() {

			// If hash exists send it to credential setting.
			if ( window.location.hash ) {
				wp.ajax.post( 'set_credentials', {
					data: window.location.hash,
					nonce: this.data.nonce
				} ).always( function( redirect ) {
					if ( '0' !== redirect && '' !== redirect ) {
						$( '#sharethis-loading' ).show();
						location.replace( redirect );
					}
				}.bind( this ) );
			}
		},
	};
} )( window.jQuery, window.wp );
