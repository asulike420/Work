<?php
/**
 * Share Buttons.
 *
 * @package ShareThisShareButtons
 */

namespace ShareThisShareButtons;

/**
 * Share Buttons Class
 *
 * @package ShareThisShareButtons
 */
class Share_Buttons {

	/**
	 * Plugin instance.
	 *
	 * @var object
	 */
	public $plugin;

	/**
	 * Button Widget instance.
	 *
	 * @var object
	 */
	public $button_widget;

	/**
	 * Menu slug.
	 *
	 * @var string
	 */
	public $menu_slug;

	/**
	 * Menu hook suffix.
	 *
	 * @var string
	 */
	private $hook_suffix;

	/**
	 * Sub Menu hook suffix.
	 *
	 * @var string
	 */
	private $general_hook_suffix;

	/**
	 * Holds the settings sections.
	 *
	 * @var string
	 */
	public $setting_sections;

	/**
	 * Holds the settings fields.
	 *
	 * @var string
	 */
	public $setting_fields;

	/**
	 * Class constructor.
	 *
	 * @param object $plugin Plugin class.
	 */
	public function __construct( $plugin, $button_widget ) {
		$this->button_widget = $button_widget;
		$this->plugin = $plugin;
		$this->menu_slug = 'sharethis';
		$this->set_settings();

		// Configure your buttons notice on activation.
		register_activation_hook( $this->plugin->dir_path . '/sharethis-share-buttons.php', array( $this, 'st_activation_hook' ) );

		// Clean up plugin information on deactivation.
		register_deactivation_hook( $this->plugin->dir_path . '/sharethis-share-buttons.php', array( $this, 'st_deactivation_hook' ) );
	}

	/**
	 * Set the settings sections and fields.
	 *
	 * @access private
	 */
	private function set_settings() {
		// Sections config.
		$this->setting_sections = array(
			'<span id="Inline" class="st-arrow">&#9658;</span>' . esc_html__( 'Inline Share Buttons', 'sharethis-share-buttons' ),
			'<span id="Sticky" class="st-arrow">&#9658;</span>' . esc_html__( 'Sticky Share Buttons', 'sharethis-share-buttons' ),
		);

		// Setting configs.
		$this->setting_fields = array(
			array(
				'id_suffix'   => 'inline',
				'description' => '',
				'callback'    => 'enable_cb',
				'section'     => 'share_button_section_1',
				'arg'         => 'inline',
			),
			array(
				'id_suffix'   => 'inline_settings',
				'description' => $this->get_descriptions( 'Inline' ),
				'callback'    => 'config_settings',
				'section'     => 'share_button_section_1',
				'arg'         => 'inline',
			),
			array(
				'id_suffix'   => 'sticky',
				'description' => '',
				'callback'    => 'enable_cb',
				'section'     => 'share_button_section_2',
				'arg'         => 'sticky',
			),
			array(
				'id_suffix'   => 'sticky_settings',
				'description' => $this->get_descriptions( 'Sticky' ),
				'callback'    => 'config_settings',
				'section'     => 'share_button_section_2',
				'arg'         => 'sticky',
			),
			array(
				'id_suffix'   => 'shortcode',
				'description' => $this->get_descriptions( '', 'shortcode' ),
				'callback'    => 'shortcode_template',
				'section'     => 'share_button_section_1',
				'arg'         => array(
					'type' => 'shortcode',
					'value' => '[sharethis-inline-buttons]',
					),
			),
			array(
				'id_suffix'   => 'template',
				'description' => $this->get_descriptions( '', 'template' ),
				'callback'    => 'shortcode_template',
				'section'     => 'share_button_section_1',
				'arg'         => array(
					'type' => 'template',
					'value' => '<?php echo sharethis_inline_buttons(); ?>',
				),
			),
			array(
				'id_suffix'   => 'social',
				'description' => $this->get_descriptions( 'Inline', 'social' ),
				'callback'    => 'social_button_link',
				'section'     => 'share_button_section_1',
				'arg'         => 'inline-share-buttons',
			),
			array(
				'id_suffix'   => 'social',
				'description' => $this->get_descriptions( 'Sticky', 'social' ),
				'callback'    => 'social_button_link',
				'section'     => 'share_button_section_2',
				'arg'         => 'sticky-share-buttons',
			),
		);

		// Inline setting array.
		$this->inline_setting_fields = array(
			array(
				'id_suffix'  => 'inline_post_top',
				'title'      => esc_html__( 'Top of post body', 'sharethis-share-buttons' ),
				'callback'   => 'onoff_cb',
				'type'       => '',
				'default'    => array(
					'true'   => 'checked="checked"',
					'false'  => '',
					'margin' => true,
				),
			),
			array(
				'id_suffix'  => 'inline_post_bottom',
				'title'      => esc_html__( 'Bottom of post body', 'sharethis-share-buttons' ),
				'callback'   => 'onoff_cb',
				'type'       => '',
				'default'    => array(
					'true'   => '',
					'false'  => 'checked="checked"',
					'margin' => true,
				),
			),
			array(
				'id_suffix' => 'inline_page_top',
				'title'     => esc_html__( 'Top of page body', 'sharethis-share-buttons' ),
				'callback'  => 'onoff_cb',
				'type'      => '',
				'default'    => array(
					'true'   => '',
					'false'  => 'checked="checked"',
					'margin' => true,
				),
			),
			array(
				'id_suffix' => 'inline_page_bottom',
				'title'     => esc_html__( 'Bottom of page body', 'sharethis-share-buttons' ),
				'callback'  => 'onoff_cb',
				'type'      => '',
				'default'    => array(
					'true'   => '',
					'false'  => 'checked="checked"',
					'margin' => true,
				),
			),
			array(
				'id_suffix' => 'excerpt',
				'title'     => esc_html__( 'Include in excerpts', 'sharethis-share-buttons' ),
				'callback'  => 'onoff_cb',
				'type'      => '',
				'default'    => array(
					'true'   => '',
					'false'  => 'checked="checked"',
					'margin' => true,
				),
			),
		);

		// Sticky setting array.
		$this->sticky_setting_fields = array(
			array(
				'id_suffix' => 'sticky_home',
				'title'     => esc_html__( 'Home Page', 'sharethis-share-buttons' ),
				'callback'  => 'onoff_cb',
				'type'      => '',
				'default'   => array(
					'true'  => 'checked="checked"',
					'false' => '',
				),
			),
			array(
				'id_suffix' => 'sticky_post',
				'title'     => esc_html__( 'Posts', 'sharethis-share-buttons' ),
				'callback'  => 'onoff_cb',
				'type'      => '',
				'default'   => array(
					'true'  => 'checked="checked"',
					'false' => '',
				),
			),
			array(
				'id_suffix' => 'sticky_custom_posts',
				'title'     => esc_html__( 'Custom Post Types', 'sharethis-share-buttons' ),
				'callback'  => 'onoff_cb',
				'type'      => '',
				'default'   => array(
					'true'  => 'checked="checked"',
					'false' => '',
				),
			),
			array(
				'id_suffix' => 'sticky_page',
				'title'     => esc_html__( 'Pages', 'sharethis-share-buttons' ),
				'callback'  => 'onoff_cb',
				'type'      => '',
				'default'   => array(
					'true'  => 'checked="checked"',
					'false' => '',
				),
			),
			array(
				'id_suffix' => 'sticky_page_off',
				'title'     => esc_html__( 'Exclude specific pages:', 'sharethis-share-buttons' ),
				'callback'  => 'list_cb',
				'type'      => array(
					'single' => 'page',
					'multi'  => 'pages',
				),
			),
			array(
				'id_suffix' => 'sticky_category',
				'title'     => esc_html__( 'Category archive pages', 'sharethis-share-buttons' ),
				'callback'  => 'onoff_cb',
				'type'      => '',
				'default'   => array(
					'true'  => 'checked="checked"',
					'false' => '',
				),
			),
			array(
				'id_suffix' => 'sticky_category_off',
				'title'     => esc_html__( 'Exclude specific category archives:', 'sharethis-share-buttons' ),
				'callback'  => 'list_cb',
				'type'      => array(
					'single' => 'category',
					'multi'  => 'categories',
				),
			),
			array(
				'id_suffix' => 'sticky_tags',
				'title'     => esc_html__( 'Tags Archives', 'sharethis-share-buttons' ),
				'callback'  => 'onoff_cb',
				'type'      => '',
				'default'   => array(
					'true'  => 'checked="checked"',
					'false' => '',
				),
			),
			array(
				'id_suffix' => 'sticky_author',
				'title'     => esc_html__( 'Author pages', 'sharethis-share-buttons' ),
				'callback'  => 'onoff_cb',
				'type'      => '',
				'default'   => array(
					'true'  => 'checked="checked"',
					'false' => '',
				),
			),
		);
	}

	/**
	 * Add in ShareThis menu option.
	 *
	 * @action admin_menu
	 */
	public function define_sharethis_menus() {
		$propertyid = get_option( 'sharethis_property_id' );

		// Menu base64 Encoded icon.
		$icon = 'data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiIHN0YW5kYWxvbmU9Im5vIj8+Cjxzdmcgd2lkdGg9IjE2cHgiIGhlaWdodD0iMTZweCIgdmlld0JveD0iMCAwIDE2IDE2IiB2ZXJzaW9uPSIxLjEiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyIgeG1sbnM6eGxpbms9Imh0dHA6Ly93d3cudzMub3JnLzE5OTkveGxpbmsiPgogICAgPCEtLSBHZW5lcmF0b3I6IFNrZXRjaCA0NC4xICg0MTQ1NSkgLSBodHRwOi8vd3d3LmJvaGVtaWFuY29kaW5nLmNvbS9za2V0Y2ggLS0+CiAgICA8dGl0bGU+RmlsbCAzPC90aXRsZT4KICAgIDxkZXNjPkNyZWF0ZWQgd2l0aCBTa2V0Y2guPC9kZXNjPgogICAgPGRlZnM+PC9kZWZzPgogICAgPGcgaWQ9IlBhZ2UtMSIgc3Ryb2tlPSJub25lIiBzdHJva2Utd2lkdGg9IjEiIGZpbGw9Im5vbmUiIGZpbGwtcnVsZT0iZXZlbm9kZCI+CiAgICAgICAgPGcgaWQ9IkRlc2t0b3AtSEQiIHRyYW5zZm9ybT0idHJhbnNsYXRlKC0xMC4wMDAwMDAsIC00MzguMDAwMDAwKSIgZmlsbD0iI0ZFRkVGRSI+CiAgICAgICAgICAgIDxwYXRoIGQ9Ik0yMy4xNTE2NDMyLDQ0OS4xMDMwMTEgQzIyLjcyNjg4NzcsNDQ5LjEwMzAxMSAyMi4zMzM1MDYyLDQ0OS4yMjg5OSAyMS45OTcwODA2LDQ0OS40Mzc5ODkgQzIxLjk5NTE0OTksNDQ5LjQzNTA5MyAyMS45OTcwODA2LDQ0OS40Mzc5ODkgMjEuOTk3MDgwNiw0NDkuNDM3OTg5IEMyMS44ODA3NTU1LDQ0OS41MDg5NDMgMjEuNzM1NDY5OCw0NDkuNTQ1NjI2IDIxLjU4OTIxODgsNDQ5LjU0NTYyNiBDMjEuNDUzMTA0LDQ0OS41NDU2MjYgMjEuMzE5ODg1Miw0NDkuNTA3NDk0IDIxLjIwODg2OTYsNDQ5LjQ0NTIyOSBMMTQuODczNzM4Myw0NDYuMDM4OTggQzE0Ljc2NDE3MDcsNDQ1Ljk5MDIzIDE0LjY4NzkwNzgsNDQ1Ljg3ODczMSAxNC42ODc5MDc4LDQ0NS43NTEzMDUgQzE0LjY4NzkwNzgsNDQ1LjYyMzM5NSAxNC43NjUxMzYsNDQ1LjUxMTg5NyAxNC44NzQ3MDM2LDQ0NS40NjI2NjQgTDIxLjIwODg2OTYsNDQyLjA1Njg5NyBDMjEuMzE5ODg1Miw0NDEuOTk1MTE1IDIxLjQ1MzEwNCw0NDEuOTU2NTAxIDIxLjU4OTIxODgsNDQxLjk1NjUwMSBDMjEuNzM1NDY5OCw0NDEuOTU2NTAxIDIxLjg4MDc1NTUsNDQxLjk5MzY2NyAyMS45OTcwODA2LDQ0Mi4wNjQ2MiBDMjEuOTk3MDgwNiw0NDIuMDY0NjIgMjEuOTk1MTQ5OSw0NDIuMDY3MDM0IDIxLjk5NzA4MDYsNDQyLjA2NDYyIEMyMi4zMzM1MDYyLDQ0Mi4yNzMxMzcgMjIuNzI2ODg3Nyw0NDIuMzk5MTE1IDIzLjE1MTY0MzIsNDQyLjM5OTExNSBDMjQuMzY2NTQwMyw0NDIuMzk5MTE1IDI1LjM1MTY4MzQsNDQxLjQxNDQ1NSAyNS4zNTE2ODM0LDQ0MC4xOTk1NTggQzI1LjM1MTY4MzQsNDM4Ljk4NDY2IDI0LjM2NjU0MDMsNDM4IDIzLjE1MTY0MzIsNDM4IEMyMi4wMTYzODc2LDQzOCAyMS4wOTMwMjcyLDQzOC44NjMwMjYgMjAuOTc1MjU0MSw0MzkuOTY3MzkgQzIwLjk3MTM5MjYsNDM5Ljk2MzA0NiAyMC45NzUyNTQxLDQzOS45NjczOSAyMC45NzUyNTQxLDQzOS45NjczOSBDMjAuOTUwNjM3NSw0NDAuMjM5MTM3IDIwLjc2OTE1MTEsNDQwLjQ2NzkyNiAyMC41MzYwMTgzLDQ0MC41ODQyNTEgTDE0LjI3OTU2MzMsNDQzLjk0NzU0MiBDMTQuMTY0MjAzNiw0NDQuMDE3MDQ3IDE0LjAyNDIyNzMsNDQ0LjA1NjE0NCAxMy44Nzk0MjQzLDQ0NC4wNTYxNDQgQzEzLjcwODU1NjgsNDQ0LjA1NjE0NCAxMy41NDgzMDgxLDQ0NC4wMDQ0OTggMTMuNDIwODgxNSw0NDMuOTEwMzc2IEMxMy4wNzUyODUsNDQzLjY4NDk2NiAxMi42NjUwMDk4LDQ0My41NTEyNjQgMTIuMjIxOTEyNiw0NDMuNTUxMjY0IEMxMS4wMDcwMTU1LDQ0My41NTEyNjQgMTAuMDIyMzU1MSw0NDQuNTM2NDA3IDEwLjAyMjM1NTEsNDQ1Ljc1MTMwNSBDMTAuMDIyMzU1MSw0NDYuOTY2MjAyIDExLjAwNzAxNTUsNDQ3Ljk1MDg2MiAxMi4yMjE5MTI2LDQ0Ny45NTA4NjIgQzEyLjY2NTAwOTgsNDQ3Ljk1MDg2MiAxMy4wNzUyODUsNDQ3LjgxNzY0MyAxMy40MjA4ODE1LDQ0Ny41OTIyMzMgQzEzLjU0ODMwODEsNDQ3LjQ5NzYyOSAxMy43MDg1NTY4LDQ0Ny40NDY0NjUgMTMuODc5NDI0Myw0NDcuNDQ2NDY1IEMxNC4wMjQyMjczLDQ0Ny40NDY0NjUgMTQuMTY0MjAzNiw0NDcuNDg1MDc5IDE0LjI3OTU2MzMsNDQ3LjU1NDU4NSBMMjAuNTM2MDE4Myw0NTAuOTE4MzU4IEMyMC43Njg2Njg0LDQ1MS4wMzQyMDEgMjAuOTUwNjM3NSw0NTEuMjYzNDcyIDIwLjk3NTI1NDEsNDUxLjUzNTIxOSBDMjAuOTc1MjU0MSw0NTEuNTM1MjE5IDIwLjk3MTM5MjYsNDUxLjUzOTU2MyAyMC45NzUyNTQxLDQ1MS41MzUyMTkgQzIxLjA5MzAyNzIsNDUyLjYzOTEwMSAyMi4wMTYzODc2LDQ1My41MDI2MDkgMjMuMTUxNjQzMiw0NTMuNTAyNjA5IEMyNC4zNjY1NDAzLDQ1My41MDI2MDkgMjUuMzUxNjgzNCw0NTIuNTE3NDY2IDI1LjM1MTY4MzQsNDUxLjMwMjU2OSBDMjUuMzUxNjgzNCw0NTAuMDg3NjcyIDI0LjM2NjU0MDMsNDQ5LjEwMzAxMSAyMy4xNTE2NDMyLDQ0OS4xMDMwMTEiIGlkPSJGaWxsLTMiPjwvcGF0aD4KICAgICAgICA8L2c+CiAgICA8L2c+Cjwvc3ZnPg==';

		// Main sharethis menu.
		add_menu_page(
			__( 'Share Buttons by ShareThis', 'sharethis-share-buttons' ),
			__( 'ShareThis', 'sharethis-share-buttons' ),
			'manage_options',
			$this->menu_slug . '-general',
			null,
			$icon,
			26
		);

		// Create submenu to replace default submenu item. Set hook for enqueueing styles.
		$this->general_hook_suffix = add_submenu_page(
			$this->menu_slug . '-general',
			__( 'ShareThis General Settings', 'sharethis-share-buttons' ),
			__( 'General Settings', 'sharethis-share-buttons' ),
			'manage_options',
			$this->menu_slug . '-general',
			array( $this, 'general_settings_display' )
		);

		// If the property ID is set then register the share buttons menu.
		if ( $this->is_property_id_set( 'empty' ) ) {
			$this->share_buttons_settings();
		}
	}

	/**
	 * Add Share Buttons settings page.
	 */
	public function share_buttons_settings() {
		$this->hook_suffix = add_submenu_page(
			$this->menu_slug . '-general',
			$this->get_descriptions( '', 'share_buttons' ),
			__( 'Share Buttons', 'sharethis-share-buttons' ),
			'manage_options',
			$this->menu_slug . '-share-buttons',
			array( $this, 'share_button_display' )
		);
	}

	/**
	 * Enqueue main MU script.
	 *
	 * @action wp_enqueue_scripts
	 */
	public function enqueue_mu() {
		wp_enqueue_script( "{$this->plugin->assets_prefix}-mu" );
	}

	/**
	 * Enqueue admin assets.
	 *
	 * @action admin_enqueue_scripts
	 * @param string $hook_suffix The current admin page.
	 */
	public function enqueue_admin_assets( $hook_suffix ) {
		// Are sticky and inline buttons enabled.
		$inline = 'true' === get_option( 'sharethis_inline' ) ? true : false;
		$sticky = 'true' === get_option( 'sharethis_sticky' ) ? true : false;
		$first_exists = get_option( 'sharethis_first_product' );
		$first_exists = false === $first_exists || null === $first_exists || '' === $first_exists ? true : false;
		$propertyid = explode( '-', get_option( 'sharethis_property_id' ), 2 );

		// Only euqueue assets on this plugin admin menu.
		if ( $hook_suffix !== $this->hook_suffix && $hook_suffix !== $this->general_hook_suffix ) {
			return;
		}

		// Enqueue the styles globally throughout the ShareThis menus.
		wp_enqueue_style( "{$this->plugin->assets_prefix}-admin" );

		// Only enqueue these scripts on share buttons plugin admin menu.
		if ( $hook_suffix === $this->hook_suffix ) {
			if ( $first_exists && ( $inline || $sticky ) ) {
				$first = $inline ? 'inline' : 'sticky';

				update_option( 'sharethis_first_product', $first );
			}
			wp_enqueue_script( "{$this->plugin->assets_prefix}-admin" );
			wp_add_inline_script( "{$this->plugin->assets_prefix}-admin", sprintf( 'ShareButtons.boot( %s );',
				wp_json_encode( array(
					'inlineEnabled' => $inline,
					'stickyEnabled' => $sticky,
					'propertyid'    => $propertyid[0],
					'secret'        => $propertyid[1],
					'nonce'         => wp_create_nonce( $this->plugin->meta_prefix ),
				) )
			) );
		}

		// Only enqueue this script on the general settings page for credentials.
		if ( $hook_suffix === $this->general_hook_suffix ) {
			wp_enqueue_script( "{$this->plugin->assets_prefix}-credentials" );
			wp_add_inline_script( "{$this->plugin->assets_prefix}-credentials", sprintf( 'Credentials.boot( %s );',
				wp_json_encode( array(
					'nonce' => wp_create_nonce( $this->plugin->meta_prefix ),
				) )
			) );
		}
	}

	/**
	 * Call back for displaying the General Settings page.
	 */
	public function general_settings_display() {
		global $current_user;

		// Check user capabilities.
		if ( ! current_user_can( 'manage_options' ) ) {
			return;
		}

		// If the property id is set then show the general settings template.
		if ( $this->is_property_id_set() ) {
			include_once( "{$this->plugin->dir_path}/templates/general/general-settings.php" );
		} else {
			// Get the current sites true url including sub directories.
			$admin_url = str_replace( '/wp-admin/', '', admin_url() );

			include_once( "{$this->plugin->dir_path}/templates/general/connection-template.php" );
		}
	}

	/**
	 * Call back for property id setting view.
	 */
	public function property_setting() {
		// Check user capabilities.
		if ( ! current_user_can( 'manage_options' ) ) {
			return;
		}

		$credential = get_option( 'sharethis_property_id' );
		$credential = null !== $credential && false !== $credential ? $credential : '';
		$error_message = '' === $credential ? '<div class="st-error"><strong>' . esc_html__( 'ERROR', 'sharethis-share-buttons' ) . '</strong>: ' . esc_html__( 'Property ID is required.', 'sharethis-share-buttons' ) . '</div>' : '';

		include_once( "{$this->plugin->dir_path}/templates/general/property-setting.php" );
	}

	/**
	 * Call back for displaying Share Buttons settings page.
	 */
	public function share_button_display() {
		// Check user capabilities.
		if ( ! current_user_can( 'manage_options' ) ) {
			return;
		}

		$description = $this->get_descriptions( '', 'share_buttons' );

		include_once( "{$this->plugin->dir_path}/templates/share-buttons/share-button-settings.php" );
	}

	/**
	 * Define general setting section and fields.
	 *
	 * @action admin_init
	 */
	public function general_settings() {
		// Add setting section.
		add_settings_section(
			'property_id_section',
			null,
			null,
			$this->menu_slug . '-general'
		);

		// Register Setting.
		register_setting( $this->menu_slug . '-general', 'sharethis_property_id' );

		// Property id field.
		add_settings_field(
			'property_id',
			$this->get_descriptions( '', 'property' ),
			array( $this, 'property_setting' ),
			$this->menu_slug . '-general',
			'property_id_section'
		);
	}

	/**
	 * Define share button setting sections and fields.
	 *
	 * @action admin_init
	 */
	public function settings_api_init() {
		// Register sections.
		foreach ( $this->setting_sections as $index => $title ) {
			// Since the index starts at 0, let's increment it by 1.
			$i = $index + 1;
			$section = "share_button_section_{$i}";

			// Add setting section.
			add_settings_section(
				$section,
				$title,
				null,
				$this->menu_slug . '-share-buttons'
			);
		}

		// Register setting fields.
		foreach ( $this->setting_fields as $setting_field ) {
			register_setting( $this->menu_slug . '-share-buttons', $this->menu_slug . '_' . $setting_field['id_suffix'] );
			add_settings_field(
				$this->menu_slug . '_' . $setting_field['id_suffix'],
				$setting_field['description'],
				array( $this, $setting_field['callback'] ),
				$this->menu_slug . '-share-buttons',
				$setting_field['section'],
				$setting_field['arg']
			);
		}

		// Register omit settings.
		register_setting( $this->menu_slug . '-share-buttons', $this->menu_slug . '_sticky_page_off' );
		register_setting( $this->menu_slug . '-share-buttons', $this->menu_slug . '_sticky_category_off' );
	}

	/**
	 * Call back function for on / off buttons.
	 *
	 * @param string $type The setting type.
	 */
	public function config_settings( $type ) {
		$config_array = 'inline' === $type ? $this->inline_setting_fields : $this->sticky_setting_fields;

		// Display on off template for inline settings.
		foreach ( $config_array as $setting ) {
			$option = 'sharethis_' . $setting['id_suffix'];
			$title = isset( $setting['title'] ) ? $setting['title'] : '';
			$option_value = get_option( 'sharethis_' . $type . '_settings' );
			$default = isset( $setting['default'] ) ? $setting['default'] : '';
			$allowed = array(
				'li' => array(
					'class' => array(),
				),
				'span' => array(
					'id'    => array(),
					'class' => array(),
				),
				'input' => array(
					'id'    => array(),
					'name'  => array(),
					'type'  => array(),
					'value' => array(),
				),
			);

			// Margin control variables.
			$margin = isset( $setting['default']['margin'] ) ? $setting['default']['margin'] : false;
			$mclass = isset( $option_value[ $option . '_margin_top' ] ) && 0 !== (int) $option_value[ $option . '_margin_top' ] || isset( $option_value[ $option . '_margin_bottom' ] ) && 0 !== (int) $option_value[ $option . '_margin_bottom' ] ? 'active-margin' : '';
			$onoff = '' !== $mclass ? __( 'On', 'sharethis-share-buttons' ) : __( 'Off', 'sharethis-share-buttons' );
			$active = array(
				'class' => $mclass,
				'onoff' => esc_html( $onoff ),
			);

			if ( isset( $option_value[ $option ] ) && false !== $option_value[ $option ] && null !== $option_value[ $option ] ) {
				$default = array(
					'true'  => '',
					'false' => '',
				);
			}

			// Display the list call back if specified.
			if ( 'onoff_cb' === $setting['callback'] ) {
				include( "{$this->plugin->dir_path}/templates/share-buttons/onoff-buttons.php" );
			} else {
				$current_omit = $this->get_omit( $setting['type'] );

				$this->list_cb( $setting['type'], $current_omit, $allowed );
			}
		} // End foreach().
	}

	/**
	 * Helper function to build the omit list html
	 *
	 * @access private
	 *
	 * @param array $setting the omit type.
	 * @return string The html for omit list.
	 */
	private function get_omit( $setting ) {
		$current_omit = get_option( 'sharethis_sticky_' . $setting['single'] . '_off' );
		$current_omit = isset( $current_omit ) ? $current_omit : '';
		$html = '';

		if ( is_array( $current_omit ) ) {
			foreach ( $current_omit as $title => $id ) {
				$html .= '<li class="omit-item">';
				$html .= $title;
				$html .= '<span id="' . $id . '" class="remove-omit">X</span>';
				$html .= '<input type="hidden" name="sharethis_sticky_' . $setting['single'] . '_off[' . $title . ']" value="' . $id . '" id="sharethis_sticky_' . $setting['single'] . '_off[' . $title . ']">';
				$html .= '</li>';
			}
		}

		// Add ommit ids to meta box option.
		$this->update_metabox_list( $current_omit );

		return $html;
	}

	/**
	 * Helper function to update metabox list to sync with omit.
	 *
	 * @param array $current_omit The omit list.
	 */
	private function update_metabox_list( $current_omit ) {
		$current_on = get_option( 'sharethis_sticky_page_on' );

		if ( isset( $current_on, $current_omit ) && is_array( $current_on ) && is_array( $current_omit ) ) {
			$new_on = array_diff( $current_on, $current_omit );

			if ( is_array( $new_on ) ) {
				delete_option( 'sharethis_sticky_page_on' );
				delete_option( 'sharethis_sticky_page_off' );

				update_option( 'sharethis_sticky_page_off', $current_omit );
				update_option( 'sharethis_sticky_page_on', $new_on );
			}
		}
	}

	/**
	 * Callback function for onoff buttons
	 *
	 * @param array $id The setting type.
	 */
	public function enable_cb( $id ) {
		include( "{$this->plugin->dir_path}/templates/share-buttons/enable-buttons.php" );
	}

	/**
	 * Callback function for omitting fields.
	 *
	 * @param array $type The type of list to return for exlusion.
	 * @param array $current_omit The currently omited items.
	 * @param array $allowed The allowed html that an omit item can echo.
	 */
	public function list_cb( $type, $current_omit, $allowed ) {
		include( "{$this->plugin->dir_path}/templates/share-buttons/list.php" );
	}

	/**
	 * Callback function for the shortcode and template code fields.
	 *
	 * @param string $type The type of template to pull.
	 */
	public function shortcode_template( $type ) {
		include( "{$this->plugin->dir_path}/templates/share-buttons/shortcode-templatecode.php" );
	}

	/**
	 * Callback function for the login buttons.
	 *
	 * @param string $product The specific product to link to.
	 */
	public function social_button_link( $product ) {
		?>
		<a class="social-login-button" href="https://platform.sharethis.com/<?php echo esc_attr( $product ); ?>?utm_source=sharethis-plugin&utm_medium=sharethis-plugin-page&utm_campaign=login" target="_blank">
			<?php esc_html_e( 'Login to the ShareThis Platform', 'sharethis-share-buttons' ); ?>
		</a>
		<?php
	}

	/**
	 * Callback function for random gif field.
	 *
	 * @access private
	 * @return string
	 */
	private function random_gif() {
		if ( ! is_wp_error( wp_safe_remote_get( 'http://api.giphy.com/v1/gifs/random?api_key=dc6zaTOxFJmzC&rating=g' ) ) ) {
			$content = wp_safe_remote_get( 'http://api.giphy.com/v1/gifs/random?api_key=dc6zaTOxFJmzC&rating=g' )['body'];

			return '<div id="random-gif-container"><img src="' . esc_url( json_decode( $content, ARRAY_N )['data']['image_url'] ) . '"/></div>';
		} else {
			return esc_html__( 'Sorry we couldn\'t show you a funny gif.  Refresh if you can\'t live without it.', 'sharethis-share-buttons' );
		}
	}

	/**
	 * Define setting descriptions.
	 *
	 * @param string $type Type of button.
	 * @param string $subtype Setting type.
	 *
	 * @access private
	 * @return string|void
	 */
	private function get_descriptions( $type = '', $subtype = '' ) {
		global $current_user;

		switch ( $subtype ) {
			case '' :
				$description = esc_html__( 'WordPress Display Settings', 'sharethis-share-buttons' );
				$description .= '<span>';
				$description .= esc_html__( 'Use these settings to automatically include or restrict the display of ', 'sharethis-share-buttons' ) . esc_html( $type ) . esc_html__( ' Share Buttons on specific pages of your site.', 'sharethis-share-buttons' );
				$description .= '</span>';
				break;
			case 'shortcode' :
				$description = esc_html__( 'Shortcode', 'sharethis-share-buttons' );
				$description .= '<span>';
				$description .= esc_html__( 'Use this shortcode to deploy your inline share buttons in a widget, or WYSIWYG editor.', 'sharethis-share-buttons' );
				$description .= '</span>';
				break;
			case 'template' :
				$description = esc_html__( 'PHP', 'sharethis-share-buttons' );
				$description .= '<span>';
				$description .= esc_html__( 'Use this PHP snippet to include your inline share buttons anywhere else in your template.', 'sharethis-share-buttons' );
				$description .= '</span>';
				break;
			case 'social' :
				$description = esc_html__( 'Social networks and button styles', 'sharethis-share-buttons' );
				$description .= '<span>';
				$description .= esc_html__( 'Login to ShareThis Platform to add, remove or re-order social networks in your ', 'sharethis-share-buttons' ) . esc_html( $type ) . esc_html__( ' Share buttons.  You may also update the alignment, size, labels and count settings.', 'sharethis-share-buttons' );
				$description .= '</span>';
				break;
			case 'property' :
				$description = esc_html__( 'Property ID', 'sharethis-share-buttons' );
				$description .= '<span>';
				$description .= esc_html__( 'We use this unique ID to identify your property. Copy it from your ', 'sharethis-share-buttons' );
				$description .= '<a class="st-support" href="https://platform.sharethis.com/settings?utm_source=sharethis-plugin&utm_medium=sharethis-plugin-page&utm_campaign=property-settings" target="_blank">';
				$description .= esc_html__( 'ShareThis platform settings', 'sharethis-share-buttons' );
				$description .= '</a></span>';
				break;
			case 'share_buttons' :
				$description = '<h1>';
				$description .= esc_html__( 'Share Buttons by ShareThis', 'sharethis-share-buttons' );
				$description .= '</h1>';
				$description .= '<h3>';
				$description .= esc_html__( 'Welcome aboard, ', 'sharethis-share-buttons' ) . esc_html( $current_user->display_name ) . '! ';
				$description .= esc_html__( 'Use the settings panels below for complete control over where and how share buttons appear on your site.  ', 'sharethis-share-buttons' );
				$description .= esc_html__( 'To change or re-order channels, or to update other advanced functions like corner radius, please login to the ShareThis Platform.', 'sharethis-share-buttons' );
				break;
		} // End switch().

		return wp_kses_post( $description );
	}

	/**
	 * Set the property id and secret key for the user's platform account if query params are present.
	 *
	 * @action wp_ajax_set_credentials
	 */
	public function set_credentials() {
		check_ajax_referer( $this->plugin->meta_prefix, 'nonce' );

		if ( ! isset( $_POST['data'] ) || '' === $_POST['data'] ) { // WPCS: input var ok.
			wp_send_json_error( 'Set credentials failed.' );
		}

		// Strip out hash and sanitize string.
		$data = str_replace( '#', '', sanitize_text_field( wp_unslash( $_POST['data'] ) ) ); // WPCS: input var ok.

		// Parse the credentials.
		parse_str( $data, $credential );

		// If both variables exist add them to a database option.
		if ( isset( $credential['property_id'], $credential['secret'] ) && false === get_option( 'sharethis_property_id' ) ) {
			update_option( 'sharethis_property_id', $credential['property_id'] . '-' . $credential['secret'] );

			// Send url to redirect to.
			wp_send_json_success( 'admin.php?page=sharethis-share-buttons&connected=true' );
		}
	}

	/**
	 * Helper function to determine if property ID is set.
	 *
	 * @param string $type Should empty count as false.
	 *
	 * @access private
	 * @return bool
	 */
	private function is_property_id_set( $type = '' ) {
		$property_id = get_option( 'sharethis_property_id' );

		// If the property id is set then show the general settings template.
		if ( false !== $property_id && null !== $property_id ) {
			if ( 'empty' === $type && '' === $property_id ) {
				return false;
			}

			return true;
		}

		return false;
	}

	/**
	 * AJAX Call back to update status of buttons
	 *
	 * @action wp_ajax_update_buttons
	 */
	public function update_buttons() {
		check_ajax_referer( $this->plugin->meta_prefix, 'nonce' );

		if ( ! isset( $_POST['type'], $_POST['onoff'] ) ) { // WPCS: CSRF ok. input var ok.
			wp_send_json_error( 'Update buttons failed.' );
		}

		// Set option type and button value.
		$type = 'sharethis_' . strtolower( sanitize_text_field( wp_unslash( $_POST['type'] ) ) ); // WPCS: input var ok.
		$onoff = sanitize_text_field( wp_unslash( $_POST['onoff'] ) ); // WPCS: input var ok.

		if ( 'On' === $onoff ) {
			update_option( $type, 'true' );
		} elseif ( 'Off' === $onoff ) {
			update_option( $type, 'false' );
		}
	}

	/**
	 * AJAX Call back to set defaults when rest button is clicked.
	 *
	 * @action wp_ajax_set_default_settings
	 */
	public function set_default_settings() {
		check_ajax_referer( $this->plugin->meta_prefix, 'nonce' );

		if ( ! isset( $_POST['type'] ) ) { // WPCS: CRSF ok. input var ok.
			wp_send_json_error( 'Update buttons failed.' );
		}

		// Set option type and button value.
		$type = strtolower( sanitize_text_field( wp_unslash( $_POST['type'] ) ) ); // WPCS: input var ok.

		$this->set_the_defaults( $type );
	}

	/**
	 * Helper function to set the default button options.
	 *
	 * @param string $type The type of default to set.
	 */
	private function set_the_defaults( $type ) {
		$default = array(
			'inline_settings'     => array(
				'sharethis_inline_post_top'                  => 'true',
				'sharethis_inline_post_bottom'               => 'false',
				'sharethis_inline_page_top'                  => 'false',
				'sharethis_inline_page_bottom'               => 'false',
				'sharethis_excerpt'                          => 'false',
				'sharethis_inline_post_top_margin_top'       => 0,
				'sharethis_inline_post_top_margin_bottom'    => 0,
				'sharethis_inline_post_bottom_margin_top'    => 0,
				'sharethis_inline_post_bottom_margin_bottom' => 0,
				'sharethis_inline_page_top_margin_top'       => 0,
				'sharethis_inline_page_top_margin_bottom'    => 0,
				'sharethis_inline_page_bottom_margin_top'    => 0,
				'sharethis_inline_page_bottom_margin_bottom' => 0,
				'sharethis_excerpt_margin_top'               => 0,
				'sharethis_excerpt_margin_bottom'            => 0,
			),
			'sticky_settings'     => array(
				'sharethis_sticky_home'         => 'true',
				'sharethis_sticky_post'         => 'true',
				'sharethis_sticky_custom_posts' => 'true',
				'sharethis_sticky_page'         => 'true',
				'sharethis_sticky_category'     => 'true',
				'sharethis_sticky_tags'         => 'true',
				'sharethis_sticky_author'       => 'true',
			),
			'sticky_page_off'     => '',
			'sticky_category_off' => '',
		);

		if ( 'both' !== $type ) {
			update_option( 'sharethis_' . $type . '_settings', $default[ $type . '_settings' ] );

			if ( 'sticky' === $type ) {
				update_option( 'sharethis_sticky_page_off', '' );
				update_option( 'sharethis_sticky_category_off', '' );
			}
		} else {
			foreach ( $default as $types => $settings ) {
				update_option( 'sharethis_' . $types, $settings );
			}
		}
	}

	/**
	 * AJAC Call back to return categories or pages based on input.
	 *
	 * @action wp_ajax_return_omit
	 */
	public function return_omit() {
		check_ajax_referer( $this->plugin->meta_prefix, 'nonce' );

		if ( ! isset( $_POST['key'], $_POST['type'] ) || '' === $_POST['key'] ) { // WPCS: input var ok.
			wp_send_json_error( '' );
		}

		$key_input = sanitize_text_field( wp_unslash( $_POST['key'] ) ); // WPCS: input var ok.
		$type = sanitize_text_field( wp_unslash( $_POST['type'] ) ); // WPCS: input var ok.
		$current_cat = array_values( get_option( 'sharethis_sticky_category_off' ) );

		if ( 'category' === $type ) {
			// Search category names LIKE $key_input.
			$categories = get_categories( array(
				'name__like' => $key_input,
				'exclude'    => $current_cat,
				'hide_empty' => false,
			) );

			foreach ( $categories as $cats ) {
				$related[] = array(
					'id'    => $cats->term_id,
					'title' => $cats->name,
				);
			}
		} else {
			// Search page names like $key_input.
			$pages = get_pages();

			foreach ( $pages as $page ) {
				if ( false !== stripos( $page->post_title, $key_input ) && $this->not_in_list( $page->ID ) ) {
					$related[] = array(
						'id'     => $page->ID,
						'title'  => $page->post_title,
					);
				}
			}
		}

		// Create output list if any results exist.
		if ( count( $related ) > 0 ) {
			foreach ( $related as $items ) {
				$item_option[] = sprintf(
					'<li class="ta-' . $type . '-item" data-id="%1$d">%2$s</li>',
					(int) $items['id'],
					esc_html( $items['title'] )
				);
			}

			wp_send_json_success( $item_option );
		} else {
			wp_send_json_error( 'no results' );
		}
	}

	/**
	 * Helper function to determine if page is in the list already.
	 *
	 * @param integer $id The page id.
	 *
	 * @return bool
	 */
	private function not_in_list( $id ) {
		$current_pages = array_values( get_option( 'sharethis_sticky_page_off' ) );

		if ( ! is_array( $current_pages ) || array() === $current_pages || ! in_array( (string) $id, $current_pages, true ) ) {
			return true;
		}

		return false;
	}

	/**
	 * Display custom admin notice.
	 *
	 * @action admin_notices
	 */
	public function connection_made_admin_notice() {
		settings_errors();

		$screen = get_current_screen();
		if ( 'sharethis_page_sharethis-share-buttons' === $screen->base ) {
			if ( isset( $_GET['reset'] ) && '' !== $_GET['reset'] ) { // WPCS: CSRF ok. Input var ok. ?>
					<div class="notice notice-success is-dismissible">
						<p><?php
							// translators: The type of button.
							printf( esc_html__( 'Successfully reset your %1$s share button options!', 'sharethis-share-buttons' ), esc_html( sanitize_text_field( wp_unslash( $_GET['reset'] ) ) ) ); // WPCS: CSRF ok. Input var ok. ?></p>
					</div>
			<?php };
		}
	}

	/**
	 * Runs only when the plugin is activated.
	 */
	public function st_activation_hook() {
		// Create transient data.
		set_transient( 'st-activation', true, 5 );
		set_transient( 'st-connection', true, 360 );

		// Set the default optons.
		$this->set_the_defaults( 'both' );
	}

	/**
	 * Admin Notice on Activation.
	 *
	 * @action admin_notices
	 */
	public function activation_inform_notice() {
		$screen = get_current_screen();
		$product = get_option( 'sharethis_first_product' );
		$product = null !== $product && false !== $product ? ucfirst( $product ) : 'your';
		$gen_url = '<a href="' . esc_url( admin_url( 'admin.php?page=sharethis-share-buttons&nft' ) ) . '">configuration</a>';

		if ( ! $this->is_property_id_set() ) {
			$gen_url = '<a href="' . esc_url( admin_url( 'admin.php?page=sharethis-general' ) ) . '">configuration</a>';
		}

		// Check transient, if available display notice.
		if ( get_transient( 'st-activation' ) ) {
			?>
			<div class="updated notice is-dismissible">
				<p><?php
					// translators: The general settings url.
					printf( esc_html__( 'Your ShareThis Share Button plugin requires %1$s', 'sharethis-share-button' ), wp_kses_post( $gen_url ) ); ?>.</p>
			</div>
			<?php
			// Delete transient, only display this notice once.
			delete_transient( 'st-activation' );
		}

		if ( 'sharethis_page_sharethis-share-buttons' === $screen->base && get_transient( 'st-connection' ) && ! isset( $_GET['nft'] ) ) { // WPCS: CSRF ok. input var ok.
			?>
			<div class="notice notice-success is-dismissible">
				<p><?php
					// translators: The product type.
					printf( esc_html__( 'Congrats! You’ve activated %1$s Share Buttons. Sit tight, they’ll appear on your site in just a few minutes!', 'sharethis-share-buttons' ), esc_html( $product ) ); ?></p>
			</div>
			<?php
			delete_transient( 'st-connection' );
		}
	}

	/**
	 * Remove all database information when plugin is deactivated.
	 */
	public function st_deactivation_hook() {
		global $wp_registered_settings;

		foreach ( $wp_registered_settings as $name => $value ) {
			if ( in_array( 'sharethis', explode( '_', $name ), true ) && 'sharethis_property_id' !== $name ) {
				delete_option( $name );
			}
		}
	}

	/**
	 * Register the button widget.
	 *
	 * @action widgets_init
	 */
	public function register_widgets() {
		register_widget( $this->button_widget );
	}
}
