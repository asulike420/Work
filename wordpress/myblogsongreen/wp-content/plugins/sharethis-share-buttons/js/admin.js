/**
 * ShareThis Share Buttons
 *
 * @package ShareThisShareButtons
 */

/* exported ShareButtons */
var ShareButtons = ( function( $, wp ) {
	'use strict';

	return {
		/**
		 * Holds data.
		 */
		data: {},

		/**
		 * Boot plugin.
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
			this.$container = $( '.sharethis-wrap' );
			this.$resultWrapper = $( '#category-result-wrapper' );

			// Get and set current accounts platform configurations to global.
			this.$config = this.getConfig();

			this.listen();
			this.createReset();
			this.markSelected();
		},

		/**
		 * Initiate listeners.
		 */
		listen: function() {
			var self = this,
				timer = '';

			// On off button events.
			this.$container.on( 'click', '.share-on, .share-off', function() {

				// Revert to default color.
				$( this ).closest( 'div' ).find( 'div.label-text' ).css( 'color', '#8d8d8d' );

				// Change the input selected color to white.
				$( this ).find( '.label-text' ).css( 'color', '#ffffff' );
			} );

			// Copy text from read only input fields.
			this.$container.on( 'click', '#copy-shortcode, #copy-template', function() {
				self.copyText( $( this ).closest( 'div' ).find( 'input' ) );
			} );

			// Open close options and update platform and WP on off status.
			this.$container.on( 'click', '.enable-buttons .share-on, .enable-buttons .share-off', function() {
				var button = $( this ).closest( 'div' ).attr( 'id' ),
					type = $( this ).find( 'div.label-text' ).html();

				self.updateButtons( button, type );
				self.updatePlatform( button, type );
			} );

			// Toggle button menus when arrows are clicked.
			this.$container.on( 'click', 'span.st-arrow', function() {
				var button = $( this ).attr( 'id' ),
					type = $( this ).html();

				self.updateButtons( button, type );
			} );

			// Click reset buttons.
			this.$container.on( 'click', 'p.submit #reset', function() {
				var type = $( this ).closest( 'p.submit' ).prev().find( '.enable-buttons' ).attr( 'id' );

				self.setDefaults( type );
			} );

			// Send user input to category search AFTER they stop typing.
			this.$container.on( 'keyup', 'input#category-ta, input#page-ta', function( e ) {
				var type = $( this ).siblings( '.search-st-icon' ).attr( 'id' ),
					result = '#' + type + '-result-wrapper';

				clearTimeout( timer );

				timer = setTimeout( function() {
					self.returnResults( $( this ).val(), type, result );
				}.bind( this ), 500 );
			} );

			// Force search when search icon is clicked.
			this.$container.on( 'click', '.search-st-icon', function() {
				var type = $( this ).attr( 'id' ),
					key = $( this ).siblings( 'input' ).val(),
					result = '#' + type + '-result-wrapper';

				self.returnResults( key, type, result );
			} );

			// Select an item to exclude. Add it to list.
			this.$container.on( 'click', '.ta-page-item, .ta-category-item', function() {
				var type = $( this ).closest( '.list-wrapper' ).find( 'span.search-st-icon' ).attr( 'id' );

				self.updateOmit( $( this ), type );
			} );

			// Remove excluded item from list.
			this.$container.on( 'click', '.remove-omit', function() {
				$( this ).closest( 'li.omit-item' ).remove();
			} );

			// Toggle margin control buttons.
			this.$container.on( 'click', 'button.margin-control-button', function() {
				var status = $( this ).hasClass( 'active-margin' );

				self.activateMargin( this, status );
			} );
		},

		/**
		 * Change font color of selected buttons.
		 * Also decide whether to update WP enable / disable status or just show / hide menu options.
		 */
		markSelected: function() {
			var sConfigSet = null !== this.$config && undefined !== this.$config['sticky-share-buttons'],
				iConfigSet = null !== this.$config && undefined !== this.$config['inline-share-buttons'],
				iturnOn,
				iturnOff,
				sturnOn,
				sturnOff,
				stickyEnable,
				inlineEnable;

			// Check if api call is successful and if sticky buttons are enabled.  Use WP data base if not.
			if ( sConfigSet ) {
				stickyEnable = this.$config['sticky-share-buttons']['enabled']; // Dot notation cannot be used due to dashes in name.
			} else {
				stickyEnable = this.data.stickyEnabled;
			}

			// Check if api call is successful and if inline buttons are enabled.  Use WP data base if not.
			if ( iConfigSet ) {
				inlineEnable = this.$config['inline-share-buttons']['enabled']; // Dot notation cannot be used due to dashes in name.
			} else {
				inlineEnable = this.data.inlineEnabled;
			}

			// Decide whether to update WP database or just show / hide menu options.
			if ( ! iConfigSet || this.data.inlineEnabled === this.$config['inline-share-buttons']['enabled'] ) { // Dot notation cannot be used due to dashes in name.
				iturnOn = 'show';
				iturnOff = 'hide';
			} else {
				iturnOn = 'On';
				iturnOff = 'Off';
			}

			// If enabled show button configuration.
			if ( inlineEnable ) {
				this.updateButtons( 'Inline', iturnOn );
				$( '#Inline label.share-on input' ).prop( 'checked', true );
			} else {
				this.updateButtons( 'Inline', iturnOff );
				$( '#Inline label.share-off input' ).prop( 'checked', true );
			}

			// Decide whether to update WP database or just show / hide menu options.
			if ( ! sConfigSet || this.data.stickyEnabled === this.$config['sticky-share-buttons']['enabled'] ) { // Dot notation cannot be used due to dashes in name.
				sturnOn = 'show';
				sturnOff = 'hide';
			} else {
				sturnOn = 'On';
				sturnOff = 'Off';
			}

			// If enabled show sticky options.
			if ( stickyEnable ) {
				this.updateButtons( 'Sticky', sturnOn );
				$( '#Sticky label.share-on input' ).prop( 'checked', true );
			} else {
				this.updateButtons( 'Sticky', sturnOff );
				$( '#Sticky label.share-off input' ).prop( 'checked', true );
			}

			// Change button font color based on status.
			$( '.share-on input:checked, .share-off input:checked' ).closest( 'label' ).find( 'span.label-text' ).css( 'color', '#ffffff' );
		},

		/**
		 * Show button configuration.
		 *
		 * @param button
		 * @param type
		 * @param when
		 */
		updateButtons: function( button, type ) {
			var when = 'last-of-type',
				pTypes = [ 'show', 'On', '►', 'true' ],
				aTypes = [ 'show', 'hide', '►', '▼' ];

			// Determine which style.
			if ( 'Inline' === button ) {
				when = 'first-of-type';
			}

			// If not one of the show types then hide.
			if ( -1 !== $.inArray( type, pTypes ) ) {

				// Show the button configs.
				$( '.sharethis-wrap form .form-table:' + when + ' tr' ).not( ':eq(0)' ).show();

				// Show the submit / reset buttons.
				$( '.sharethis-wrap form .submit:' + when ).show();

				// Change the icon next to title.
				$( '.sharethis-wrap h2:' + when + ' span' ).html( '&#9660;' );

			} else {

				// Hide the button configs.
				$( '.sharethis-wrap form .form-table:' + when + ' tr' ).not( ':eq(0)' ).hide();

				// Hide the submit / reset buttons.
				$( '.sharethis-wrap form .submit:' + when ).hide();

				// Change the icon next to title.
				$( '.sharethis-wrap h2:' + when + ' span' ).html( '&#9658;' );
			}

			// AJAX to disable or enable buttons directly to database.
			if ( -1 === $.inArray( type, aTypes ) ) {

				// Send upate to database.
				wp.ajax.post( 'update_buttons', {
					type: button,
					onoff: type,
					nonce: this.data.nonce
				} ).always( function() {
				} );
			}
		},

		/**
		 * Update buttons on platform
		 *
		 * @param button
		 * @param type
		 */
		updatePlatform: function( button, type ) {
			var status,
				button_config;

			// Set status variable to bool.
			if ( 'On' === type ) {
				status = true;
			} else {
				status = false;
			}

			// Default button config with enable.
			if ( 'inline' === button ) {
				button_config = { "enabled": ( true === status ), "alignment" : "center", "font_size" : 12, "has_spacing" : true, "labels" : "cta", "min_count" : 10, "networks" : [ "facebook", "twitter", "pinterest", "email", "sms", "sharethis" ], "num_networks" : 6, "padding" : 10, "radius" : 4, "show_total" : true, "size" : 40, "size_label" : "medium", "spacing" : 8 }
			} else {
				button_config = { "enabled": ( true === status ), "alignment" : "left", "labels" : "cta", "min_count" : 10, "mobile_breakpoint" : 1024, "networks" : [ "facebook", "twitter", "pinterest", "email", "sms", "sharethis" ], "num_networks" : 6, "padding" : 12, "radius" : 4, "show_mobile" : true, "show_toggle" : true, "show_total" : true, "size" : 48, "top" : 160 }
			}

			// Send new button status value.
			$.ajax( {
				url: 'https://platform-api.sharethis.com/v1.0/property/product',
				method: 'POST',
				async: false,
				contentType: 'application/json; charset=utf-8',
				data: JSON.stringify( {
					'secret': this.data.secret,
					'id': this.data.propertyid,
					'product': button.toLowerCase() + '-share-buttons',
					'config': button_config
				} ),
			} );
		},

		/**
		 * Copy text to clipboard
		 *
		 * @param copiedText
		 */
		copyText: function( copiedText ) {
			copiedText.select();
			document.execCommand( 'copy' );
		},

		/**
		 * Add the reset buttons to share buttons menu
		 */
		createReset: function() {
			var button = '<input type="button" id="reset" class="button button-primary" value="Reset">',
				newButtons = $( '.sharethis-wrap form .submit' ).append( button ).clone();

			// Add new cloned reset button to inline menu list.
			$( '.sharethis-wrap form .form-table:first-of-type' ).after( newButtons );
			$( newButtons ).find( '#submit:first-of-type' ).addClass( 'st-submit-2' );
		},

		/**
		 * Set to default settings when reset is clicked.
		 *
		 * @param type
		 */
		setDefaults: function( type ) {
			wp.ajax.post( 'set_default_settings', {
				type: type,
				nonce: this.data.nonce
			} ).always( function() {
				if ( 'both' !== type ) {
					location.href = location.pathname + '?page=sharethis-share-buttons&reset=' + type;
				} else {
					location.reload();
				}
			} );
		},

		/**
		 * Send input value and return LIKE categories/pages.
		 *
		 * @param key
		 * @param type
		 * @param result
		 */
		returnResults: function( key, type, result ) {
			wp.ajax.post( 'return_omit', {
				key: key,
				type: type,
				nonce: this.data.nonce
			} ).always( function( results ) {
				if ( '' !== results ) {;
					$( result ).show().html( results );
				} else {
					$( result ).hide();
				}
			}.bind( this ) );
		},

		/**
		 * Add / remove selected omit item to omit list.
		 *
		 * @param value
		 * @param type
		 */
		updateOmit: function( value, type ) {
			var result = '#' + type + '-current-omit',
				wrapper = '#' + type + '-result-wrapper';

			// Hide the results when item is selected and add it to list.
			$( wrapper ).hide();
			$( result ).append( '<li class="omit-item">' + value.html() + '<span id="' + value.attr( "data-id" ) + '" class="remove-omit">X</span><input type="hidden" name="sharethis_sticky_' + type + '_off[' + value.html() + ']" value="' + value.attr( "data-id" ) + '" id="sharethis_sticky_' + type + '_off[' + value.html() + ']" value="' + value.attr( "data-id" ) + '" /></li>' );
		},

		/**
		 * Get current config data from user.
		 */
		getConfig: function() {
			var result = null;
				$.ajax( {
					url: 'https://platform-api.sharethis.com/v1.0/property/?secret=' + this.data.secret + '&id=' + this.data.propertyid,
					method: 'GET',
					async: false,
					contentType: 'application/json; charset=utf-8',
					success: function( results ) {
						result = results;
					}
				} );

			return result;
		},

		/**
		 * Activate specified option margin controls and show/hide
		 *
		 * @param marginButton
		 * @param status
		 */
		activateMargin: function( marginButton, status ) {
			if ( ! status ) {
				$( marginButton ).addClass( 'active-margin' ).find( 'span.margin-on-off' ).html( 'On' );
				$( marginButton ).siblings( 'div.margin-input-fields' ).show().find( 'input' ).prop( 'disabled', false );
			} else {
				$( marginButton ).removeClass( 'active-margin' ).find( 'span.margin-on-off' ).html( 'Off' );
				$( marginButton ).siblings( 'div.margin-input-fields' ).hide().find( 'input' ).prop( 'disabled', true );
			}
		}
	};
} )( window.jQuery, window.wp );
