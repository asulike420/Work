<?php
/**
 * Minute Control.
 *
 * @package ShareThisShareButtons
 */

namespace ShareThisShareButtons;

/**
 * Minute Control Class
 *
 * @package ShareThisShareButtons
 */
class Minute_Control {

	/**
	 * Plugin instance.
	 *
	 * @var object
	 */
	public $plugin;

	/**
	 * Class constructor.
	 *
	 * @param object $plugin Plugin class.
	 */
	public function __construct( $plugin ) {
		$this->plugin = $plugin;
	}

	/**
	 * Register the new share buttons metabox.
	 *
	 * @action add_meta_boxes
	 */
	public function share_buttons_metabox() {
		// Get all post types available.
		$post_types = array( 'post', 'page' );

		// Add the Share Buttons meta box to editor pages.
		add_meta_box( 'sharethis_share_buttons', esc_html__( 'Share Buttons', 'sharethis-share-buttons' ), array(
			$this,
			'share_buttons_custom_box',
			),
		$post_types, 'side', 'high' );
	}

	/**
	 * Enqueue admin assets.
	 *
	 * @action admin_enqueue_scripts
	 * @param string $hook The page hook name.
	 */
	public function enqueue_admin_assets( $hook ) {
		global $post;

		// Enqueue the assets on editor pages.
		if ( in_array( $hook, array( 'post.php', 'post-new.php' ), true ) ) {
			wp_enqueue_style( "{$this->plugin->assets_prefix}-meta-box" );
			wp_enqueue_script( "{$this->plugin->assets_prefix}-meta-box" );
			wp_add_inline_script( "{$this->plugin->assets_prefix}-meta-box", sprintf( 'MinuteControl.boot( %s );',
				wp_json_encode( array(
					'postid' => $post->ID,
					'nonce' => wp_create_nonce( $this->plugin->meta_prefix ),
				) )
			) );
		}
	}

	/**
	 * Call back function for the share buttons metabox.
	 */
	public function share_buttons_custom_box() {
		global $post_type;

		switch ( $post_type ) {
			case 'post' :
				$iptype = 'post_';
				$sptype = 'posts';
			break;
			case 'page' :
				$iptype = 'page_';
				$sptype = 'pages';
			break;
			default :
				$iptype = 'post_';
				$sptype = 'posts';
		}

		// Get all needed options for meta boxes.
		$inline_options = get_option( 'sharethis_inline_settings' );
		$sticky_options = get_option( 'sharethis_sticky_settings' );
		$inline_enable = get_option( 'sharethis_inline' );
		$sticky_enable = get_option( 'sharethis_sticky' );

		// Include the meta box template.
		include_once( "{$this->plugin->dir_path}/templates/minute-control/meta-box.php" );
	}

	/**
	 * AJAX Call back function to add a post / page to ommit / show list.
	 *
	 * @action wp_ajax_update_list
	 */
	public function update_list() {
		check_ajax_referer( $this->plugin->meta_prefix, 'nonce' );

		if ( ! isset( $_POST['type'], $_POST['checked'], $_POST['placement'], $_POST['postid'] ) || '' === $_POST['type'] ) { // WPCS: input var okay.
			wp_send_json_error( 'Add to list failed.' );
		}

		// Set and sanitize post values.
		$type = sanitize_text_field( wp_unslash( $_POST['type'] ) ); // WPCS: input var okay.
		$onoff = 'true' === sanitize_text_field( wp_unslash( $_POST['checked'] ) ) ? 'on' : 'off'; // WPCS: input var okay.
		$opposite = 'true' === sanitize_text_field( wp_unslash( $_POST['checked'] ) ) ? 'off' : 'on'; // WPCS: input var okay.
		$placement = '' !== sanitize_text_field( wp_unslash( $_POST['placement'] ) ) ? '_' . sanitize_text_field( wp_unslash( $_POST['placement'] ) ) : ''; // WPCS: input var okay.
		$postid = intval( wp_unslash( $_POST['postid'] ) ); // WPCS: input var okay.

		// Create remaining variables needed for list placement.
		$post_info = get_post( $postid );
		$post_type = $post_info->post_type;
		$option = 'sharethis_' . $type . '_' . $post_type . $placement . '_' . $onoff;
		$oppose = 'sharethis_' . $type . '_' . $post_type . $placement . '_' . $opposite;
		$title = $post_info->post_title;

		// Get current list and opposing list options.
		$current_list = get_option( $option );
		$current_oppose = get_option( $oppose );
		$current_list = isset( $current_list ) && null !== $current_list && false !== $current_list ? $current_list : '';
		$current_oppose = isset( $current_oppose ) && null !== $current_oppose && false !== $current_oppose ? $current_oppose : '';

		// Add post id and title to current list.
		if ( is_array( $current_list ) && array() !== $current_list ) {
			$current_list[ $title ] = (int) $postid;
		} else {
			$current_list = array(
				$title => (int) $postid,
			);
		}

		// Remove item from opposing list.
		if ( is_array( $current_oppose ) && array() !== $current_oppose && in_array( (int) $postid, array_map( 'intval',  $current_oppose ), true ) ) {
			unset( $current_oppose[ $title ] );
			delete_option( $oppose );
		}

		// Update both list options.
		update_option( $option, $current_list );
		update_option( $oppose, $current_oppose );
	}

	/**
	 * Helper function to determine whether to check box or not.
	 *
	 * @param string $type The type of button.
	 * @param string $placement The position of the button in question.
	 */
	private function is_box_checked( $type, $placement = '' ) {
		global $post, $post_type;

		$options = array(
			'true'  => 'sharethis_' . $type . '_' . $post_type . $placement . '_on',
			'false' => 'sharethis_' . $type . '_' . $post_type . $placement . '_off',
		);

		$default_option = get_option( 'sharethis_' . $type . '_settings' );
		$default_option = isset( $default_option ) && null !== $default_option && false !== $default_option ? $default_option : '';
		$default = $default_option[ "sharethis_{$type}_{$post_type}{$placement}" ];

		foreach ( $options as $answer => $option ) {
			$current_list = get_option( $option );
			$current_list = isset( $current_list ) && null !== $current_list && false !== $current_list ? $current_list : '';
			$answer_minute = (
				is_array( $current_list )
				&&
				in_array( (int) $post->ID, array_map( 'intval', $current_list ), true )
			);

			if ( $answer_minute ) {
				return $answer;
			}
		}

		return $default;
	}

	/**
	 * Register the inline share button shortcode
	 *
	 * @shortcode sharethis-inline-buttons
	 *
	 * @return string
	 */
	public function inline_shortcode() {
		global $post;

		$data_url = '';

		if ( is_archive() || is_front_page() || is_tag() ) {
			$data_url = esc_attr( 'data-url=' . get_permalink( $post->ID ) );
		}

		// Build container.
		return '<div class="sharethis-inline-share-buttons" ' . $data_url . '></div>';
	}

	/**
	 * Set inline container based on plugin config.
	 *
	 * @param string $content The post's content.
	 *
	 * @filter the_content
	 *
	 * @return string
	 */
	public function set_inline_content( $content ) {
		global $post;

		// Get inline settings.
		$inline_settings = get_option( 'sharethis_inline_settings' );
		$excerpt = null !== $inline_settings && false !== $inline_settings && 'true' === $inline_settings['sharethis_excerpt'] ? true : false;

		if ( $excerpt && is_archive() || $excerpt && is_home() ) {
			return $content . $this->get_inline_container( $inline_settings, 'sharethis_excerpt', $post );
		}

		if ( null !== $inline_settings && false !== $inline_settings && is_array( $inline_settings ) ) {
			foreach ( $inline_settings as $type => $value ) {
				$position = $this->get_position( $type, $value );
				$container = $this->get_inline_container( $inline_settings, $type );

				if ( '' !== $position ) {
					switch ( $position ) {
						case 'top' :
							$content = $container . $content;
						break;
						case 'bottom' :
							$content = $content . $container;
						break;
					}
				}
			}
		}

		return $content;
	}

	/**
	 * Helper function to determine the inline button container.
	 *
	 * @param array  $settings The current inline settings.
	 * @param string $type The type of button setting.
	 * @param object $post The current post object.
	 *
	 * @return string
	 */
	private function get_inline_container( $settings, $type, $post = '' ) {
		$data_url = 'sharethis_excerpt' === $type && '' !== $post ? esc_attr( 'data-url=' . get_permalink( $post->ID ) ) : '';
		$margin_t = isset( $settings[ "{$type}_margin_top" ] ) ? $settings[ "{$type}_margin_top" ] . 'px' : '';
		$margin_b = isset( $settings[ "{$type}_margin_bottom" ] ) ? $settings[ "{$type}_margin_bottom" ] . 'px' : '';
		$margin = '';

		if ( ! in_array( '', array( $margin_t, $margin_b ), true ) ) {
			$margin = 'margin-top: ' . $margin_t . '; margin-bottom: ' . $margin_b . ';';
		}

		return '<div style="' . esc_attr( $margin ) . '" class="sharethis-inline-share-buttons" ' . $data_url . '></div>';
	}

	/**
	 * Hide sticky if configured.
	 *
	 * @action wp_enqueue_scripts
	 */
	public function set_sticky_visibility() {
		// Enqueue the blank style sheet.
		wp_enqueue_style( "{$this->plugin->assets_prefix}-sticky" );

		// Get sticky settings.
		$settings = get_option( 'sharethis_sticky_settings' );
		$settings = null !== $settings && false !== $settings && is_array( $settings ) ? $settings : array();
		$hide_sticky = '
               .st-sticky-share-buttons{
                        display: none!important;
                }';

		// Get hide status.
		foreach ( $settings as $type => $value ) {
			$hide = $this->get_hide_status( $type, $value );

			if ( $hide ) {
				wp_add_inline_style( "{$this->plugin->assets_prefix}-sticky", $hide_sticky );
			}
		}
	}

	/**
	 * Helper function to get the hide status for sticky buttons.
	 *
	 * @param string $type The button setting.
	 * @param string $value The setting value.
	 *
	 * @return bool
	 */
	private function get_hide_status( $type, $value ) {
		global $post;

		// The non post id dependant types.
		$alternate_types = array( 'sharethis_sticky_home', 'sharethis_sticky_category', 'sharethis_sticky_tags', 'sharethis_sticky_author', 'sharethis_sticky_custom_posts' );
		$alternate_pages = (
			! is_front_page()
			&&
		    ! is_archive()
			&&
		    ! is_author()
			&&
		    ! is_tag()
		);

		if ( in_array( $type, $alternate_types, true ) ) {
			return $this->get_alternate_hide( $type, $value );
		}

		$page_option_on = get_option( $type . '_on' );
		$page_option_off = get_option( $type . '_off' );

		if ( ! is_array( $page_option_off ) && ! is_array( $page_option_on ) && 'false' === $value && $alternate_pages && in_array( $post->post_type, explode( '_', $type ), true ) ) {
			$hide = true;
		} else {
			$hide = (
				is_array( $page_option_on )
				&&
				'false' === $value
				&&
				! in_array( (int) $post->ID, array_map( 'intval', $page_option_on ), true )
				&&
				$alternate_pages
				&&
				in_array( $post->post_type, explode( '_', $type ), true )
				||
				is_array( $page_option_off )
				&&
				in_array( (int) $post->ID, array_map( 'intval', $page_option_off ), true )
				&&
				$alternate_pages
				&&
			    in_array( $post->post_type, explode( '_', $type ), true )
			);
		}

		return $hide;
	}

	/**
	 * Get the hide values for the non post or page types.
	 *
	 * @param string $type The setting type.
	 * @param string $value The value of the option.
	 *
	 * @return bool
	 */
	private function get_alternate_hide( $type, $value ) {
		$value = 'true' === $value ? false : true;

		switch ( $type ) {
			case 'sharethis_sticky_home' :
				if ( is_front_page() ) {
					return $value;
				}
			break;
			case 'sharethis_sticky_category' :
				$current_cats = get_option( 'sharethis_sticky_category_off' );
				$current_cats = is_array( $current_cats ) ? $current_cats : array();
				$queried_object = get_queried_object();

				if ( is_archive() ) {
					if ( ! in_array( (string) $queried_object->term_id, array_values( $current_cats ), true ) ) {
						return $value;
					} else {
						return true;
					}
				}
			break;
			case 'sharethis_sticky_author' :
				if ( is_author() ) {
					return $value;
				}
			break;
			case 'sharethis_sticky_tags' :
				if ( is_tag() ) {
					return $value;
				}
			break;
			case 'sharethis_sticky_custom_posts' :
				if ( ! is_singular( array( 'post', 'page' ) ) ) {
					return $value;
				}
			break;
		}
		return false;
	}
	/**
	 * Set inline container based on plugin config.
	 *
	 * @param string $excerpt The excerpt of the post.
	 *
	 * @filter get_the_excerpt
	 *
	 * @return string
	 */
	public function set_inline_excerpt( $excerpt ) {
		global $post;

		if ( is_admin() ) {
			return;
		}

		// Get inline settings.
		$inline_settings = get_option( 'sharethis_inline_settings' );
		$container = $this->get_inline_container( $inline_settings, 'sharethis_excerpt', $post );

		if ( null === $inline_settings || false === $inline_settings || ! is_array( $inline_settings ) ) {
			return $excerpt;
		}

		$excerpt = isset( $inline_settings['sharethis_excerpt'] ) && 'true' === $inline_settings['sharethis_excerpt'] ? $excerpt . $container : $excerpt;

		return $excerpt;
	}


	/**
	 * Determine the position of the inline buttons.
	 *
	 * @param string $type The button type.
	 * @param string $value The value of the button.
	 *
	 * @return string
	 */
	private function get_position( $type, $value ) {
		global $post;

		$page_option_on = get_option( $type . '_on' );
		$page_option_off = get_option( $type . '_off' );
		$page_option_on = is_array( $page_option_on ) ? array_values( $page_option_on ) : array();
		$page_option_off = is_array( $page_option_off ) ? array_values( $page_option_off ) : array();
		$type_array = explode( '_', $type );
		$position = '';

		$show = (
			'true' === $value
			&&
			! in_array( (int) $post->ID, $page_option_off, true )
			||
			in_array( (int) $post->ID, $page_option_on, true ) );

		if ( in_array( 'top', $type_array, true ) && in_array( $post->post_type, $type_array, true ) ) {
			$position = 'top';
		} elseif ( in_array( 'bottom', explode( '_', $type ), true ) && in_array( $post->post_type, $type_array, true ) ) {
			$position = 'bottom';
		}

		if ( $show ) {
			return $position;
		}

		return '';
	}
}
