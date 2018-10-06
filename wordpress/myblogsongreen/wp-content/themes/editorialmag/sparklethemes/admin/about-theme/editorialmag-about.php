<?php
/**
 * About page of editorialmag Theme
 *
 * @package Sparkle Themes
 * @subpackage Editorialmag_Mag
 * @since 1.0.6
 */

if ( ! defined( 'ABSPATH' ) ) {
	exit;
}

if ( ! class_exists( 'Editorialmag_About' ) ) :

class Editorialmag_About {

	/**
	 * Constructor.
	 */
	public function __construct() {
		add_action( 'admin_menu', array( $this, 'admin_menu' ) );
		add_action( 'wp_loaded', array( __CLASS__, 'hide_notices' ) );
		add_action( 'load-themes.php', array( $this, 'admin_notice' ) );
	}

	/**
	 * Add admin menu.
	 */
	public function admin_menu() {
		$theme = wp_get_theme( get_template() );

		$page = add_theme_page( esc_html__( 'About', 'editorialmag' ) . ' ' . $theme->display( 'Name' ), esc_html__( 'About', 'editorialmag' ) . ' ' . $theme->display( 'Name' ), 'activate_plugins', 'editorialmag-welcome', array( $this, 'welcome_screen' ) );
		add_action( 'admin_print_styles-' . $page, array( $this, 'enqueue_styles' ) );
	}

	/**
	 * Enqueue styles.
	*/
	public function enqueue_styles() {
		global $editorialmag_version;
		wp_enqueue_style( 'editorialmag-about-theme', get_template_directory_uri() . '/sparklethemes/admin/about-theme/about.css', array(), $editorialmag_version );
	}

	/**
	 * Add admin notice.
	*/
	public function admin_notice() {
		global $editorialmag_version, $pagenow;
		// Let's bail on theme activation.
		if ( 'themes.php' == $pagenow && isset( $_GET['activated'] ) ) {
			add_action( 'admin_notices', array( $this, 'welcome_notice' ) );
			update_option( 'editorialmag_admin_notice_welcome', 1 );

		// No option? Let run the notice wizard again..
		} elseif( ! get_option( 'editorialmag_admin_notice_welcome' ) ) {
			add_action( 'admin_notices', array( $this, 'welcome_notice' ) );
		}
	}

	/**
	 * Hide a notice if the GET variable is set.
	 */
	public static function hide_notices() {
		if ( isset( $_GET['editorialmag-hide-notice'] ) && isset( $_GET['_editorialmag_notice_nonce'] ) ) {
			if ( ! wp_verify_nonce( wp_unslash( $_GET['_editorialmag_notice_nonce'] ), 'editorialmag_hide_notices_nonce' ) ) {
				wp_die( esc_html__( 'Action failed. Please refresh the page and retry.', 'editorialmag' ) );
			}

			if ( ! current_user_can( 'manage_options' ) ) {
				wp_die( esc_html__( 'Cheatin&#8217; huh?', 'editorialmag' ) );
			}

			$hide_notice = sanitize_text_field( $_GET['editorialmag-hide-notice'] );
			update_option( 'editorialmag_admin_notice_' . $hide_notice, 1 );
		}
	}

	/**
	 * Show welcome notice.
	 */
	public function welcome_notice() {
		?>
		<div id="message" class="updated editorialmag-message">
			<a class="editorialmag-message-close notice-dismiss" href="<?php echo esc_url( wp_nonce_url( remove_query_arg( array( 'activated' ), add_query_arg( 'editorialmag-hide-notice', 'welcome' ) ), 'editorialmag_hide_notices_nonce', '_editorialmag_notice_nonce' ) ); ?>"><?php esc_html_e( 'Dismiss', 'editorialmag' ); ?></a>
			<p><?php printf( esc_html__( 'Welcome! Thank you for choosing editorialmag! To fully take advantage of the best our theme can offer please make sure you visit our %1$sswelcome page%2$s.', 'editorialmag' ), '<a href="' . esc_url( admin_url( 'themes.php?page=editorialmag-welcome' ) ) . '">', '</a>' ); ?></p>
			<p class="submit">
				<a class="button-secondary" href="<?php echo esc_url( admin_url( 'themes.php?page=editorialmag-welcome' ) ); ?>"><?php esc_html_e( 'Get started with Editorialmag', 'editorialmag' ); ?></a>
			</p>
		</div>
		<?php
	}

	/**
	 * Intro text/links shown to all about pages.
	 *
	 * @access private
	 */
	private function intro() {
		global $editorialmag_version;
		$theme = wp_get_theme( get_template() );

		// Drop minor version if 0
		//$major_version = substr( $editorialmag_version, 0, 3 );
		?>
		<div class="editorialmag-theme-info">
				<h1>
					<?php esc_html_e('About', 'editorialmag'); ?>
					<?php echo esc_attr( $theme->display( 'Name' ) ); ?>
					<?php printf( '%s', esc_attr( $editorialmag_version ) ); ?>
				</h1>

			<div class="welcome-description-wrap">
				<div class="about-text"><?php echo esc_attr( $theme->display( 'Description' ) ); ?></div>

				<div class="editorialmag-screenshot">
					<img src="<?php echo esc_url( get_template_directory_uri() ) . '/screenshot.png'; ?>" />
				</div>
			</div>
		</div>

		<p class="editorialmag-actions">		

			<a href="<?php echo esc_url( apply_filters( 'editorialmag_pro_theme_url', 'https://www.sparklewpthemes.com/wordpress-themes/editorialmagpro' ) ); ?>" class="button button-primary docs" target="_blank"><?php esc_html_e( 'View PRO version', 'editorialmag' ); ?></a>

			<a href="<?php echo esc_url( apply_filters( 'editorialmag_pro_theme_url', 'http://demo.sparklewpthemes.com/editorialmagpro/demos/' ) ); ?>" class="button button-primary docs" target="_blank"><?php esc_html_e( 'View PRO Demo', 'editorialmag' ); ?></a>

			<a href="<?php echo esc_url( 'https://www.sparklewpthemes.com/wordpress-themes/editorialmag/' ); ?>" class="button button-secondary" target="_blank"><?php esc_html_e( 'Theme Info', 'editorialmag' ); ?></a>

			<a href="<?php echo esc_url( apply_filters( 'editorialmag_pro_theme_url', 'http://demo.sparklewpthemes.com/editorialmag/demos/' ) ); ?>" class="button button-secondary docs" target="_blank"><?php esc_html_e( 'View Demo', 'editorialmag' ); ?></a>


			<a href="<?php echo esc_url( apply_filters( 'editorialmag_pro_theme_url', 'https://wordpress.org/support/theme/editorialmag/reviews/?filter=5' ) ); ?>" class="button button-secondary docs" target="_blank"><?php esc_html_e( 'Rate this theme', 'editorialmag' ); ?></a>
		</p>

		<h2 class="nav-tab-wrapper">
			<a class="nav-tab <?php if ( empty( $_GET['tab'] ) && $_GET['page'] == 'editorialmag-welcome' ) echo 'nav-tab-active'; ?>" href="<?php echo esc_url( admin_url( add_query_arg( array( 'page' => 'editorialmag-welcome' ), 'themes.php' ) ) ); ?>">
				<?php echo esc_attr( $theme->display( 'Name' ) ); ?>
			</a>
			
			<a class="nav-tab <?php if ( isset( $_GET['tab'] ) && $_GET['tab'] == 'free_vs_pro' ) echo 'nav-tab-active'; ?>" href="<?php echo esc_url( admin_url( add_query_arg( array( 'page' => 'editorialmag-welcome', 'tab' => 'free_vs_pro' ), 'themes.php' ) ) ); ?>">
				<?php esc_html_e( 'Free Vs Pro', 'editorialmag' ); ?>
			</a>

			<a class="nav-tab <?php if ( isset( $_GET['tab'] ) && $_GET['tab'] == 'more_themes' ) echo 'nav-tab-active'; ?>" href="<?php echo esc_url( admin_url( add_query_arg( array( 'page' => 'editorialmag-welcome', 'tab' => 'more_themes' ), 'themes.php' ) ) ); ?>">
				<?php esc_html_e( 'More Themes', 'editorialmag' ); ?>
			</a>

			<a class="nav-tab <?php if ( isset( $_GET['tab'] ) && $_GET['tab'] == 'changelog' ) echo 'nav-tab-active'; ?>" href="<?php echo esc_url( admin_url( add_query_arg( array( 'page' => 'editorialmag-welcome', 'tab' => 'changelog' ), 'themes.php' ) ) ); ?>">
				<?php esc_html_e( 'Changelog', 'editorialmag' ); ?>
			</a>
		</h2>
		<?php
	}

	/**
	 * Welcome screen page.
	 */
	public function welcome_screen() {
		$current_tab = empty( $_GET['tab'] ) ? 'about' : sanitize_title( $_GET['tab'] );

		// Look for a {$current_tab}_screen method.
		if ( is_callable( array( $this, $current_tab . '_screen' ) ) ) {
			return $this->{ $current_tab . '_screen' }();
		}

		// Fallback to about screen.
		return $this->about_screen();
	}

	/**
	 * Output the about screen.
	 */
	public function about_screen() {
		$theme = wp_get_theme( get_template() );
		?>
		<div class="wrap about-wrap">

			<?php $this->intro(); ?>

			<div class="changelog point-releases">
				<div class="under-the-hood two-col">
					
					<div class="col">
						<h3><?php esc_html_e( 'Need more features ?', 'editorialmag' ); ?></h3>
						<p><?php esc_html_e( 'Upgrade to PRO version for more exciting features.', 'editorialmag' ) ?></p>
						<p><a href="<?php echo esc_url( 'https://www.sparklewpthemes.com/wordpress-themes/editorialmagpro/' ); ?>" class="button button-secondary" target="_blank"><?php esc_html_e( 'View PRO version', 'editorialmag' ); ?></a></p>
					</div>

					<div class="col">
						<h3><?php esc_html_e( 'Have you need customization?', 'editorialmag' ); ?></h3>
						<p><?php esc_html_e( 'Please send message with your requirement.', 'editorialmag' ) ?></p>
						<p><a href="<?php echo esc_url( 'https://www.sparklewpthemes.com/request-wordpress-customization-with-our-dedicated-support-team/' ); ?>" class="button button-secondary" target="_blank"><?php esc_html_e( 'Customization', 'editorialmag' ); ?></a></p>
					</div>

					<div class="col">
						<h3><?php esc_html_e( 'Documentation', 'editorialmag' ); ?></h3>
						<p><?php esc_html_e( 'Please view our documentation page to setup the theme.', 'editorialmag' ) ?></p>
						<p><a href="<?php echo esc_url( 'http://docs.sparklewpthemes.com/editorialmag/' ); ?>" class="button button-secondary" target="_blank"><?php esc_html_e( 'Documentation', 'editorialmag' ); ?></a></p>
					</div>

					<div class="col">
						<h3><?php esc_html_e( 'Theme Customizer', 'editorialmag' ); ?></h3>
						<p><?php esc_html_e( 'All Theme Options are available via Customize screen.', 'editorialmag' ) ?></p>
						<p><a href="<?php echo esc_url( admin_url( 'customize.php' ) ); ?>" class="button button-secondary"><?php esc_html_e( 'Customize', 'editorialmag' ); ?></a></p>
					</div>

					<div class="col">
						<h3><?php esc_html_e( 'Got theme support question?', 'editorialmag' ); ?></h3>
						<p><?php esc_html_e( 'Please put it in our dedicated support forum.', 'editorialmag' ) ?></p>
						<p><a href="<?php echo esc_url( 'https://www.sparklewpthemes.com/support/' ); ?>" class="button button-secondary" target="_blank"><?php esc_html_e( 'Support', 'editorialmag' ); ?></a></p>
					</div>

					<div class="col">
						<h3>
							<?php
							esc_html_e( 'Translate', 'editorialmag' );
							echo ' ' . esc_attr( $theme->display( 'Name' ) );
							?>
						</h3>
						<p><?php esc_html_e( 'Click below to translate this theme into your own language.', 'editorialmag' ) ?></p>
						<p>
							<a href="<?php echo esc_url( 'https://translate.wordpress.org/projects/wp-themes/editorialmag' ); ?>" class="button button-secondary" target="_blank">
								<?php
								esc_html_e( 'Translate', 'editorialmag' );
								echo ' ' . esc_attr( $theme->display( 'Name' ) );
								?>
							</a>
						</p>
					</div>
				</div>
			</div>

			<div class="return-to-dashboard editorialmag">
				<?php if ( current_user_can( 'update_core' ) && isset( $_GET['updated'] ) ) : ?>
					<a href="<?php echo esc_url( self_admin_url( 'update-core.php' ) ); ?>">
						<?php is_multisite() ? esc_html_e( 'Return to Updates', 'editorialmag' ) : esc_html_e( 'Return to Dashboard &rarr; Updates', 'editorialmag' ); ?>
					</a> |
				<?php endif; ?>
				<a href="<?php echo esc_url( self_admin_url() ); ?>"><?php is_blog_admin() ? esc_html_e( 'Go to Dashboard &rarr; Home', 'editorialmag' ) : esc_html_e( 'Go to Dashboard', 'editorialmag' ); ?></a>
			</div>
		</div>
		<?php
	}

	/**
	 * Output the more themes screen
	 */
	public function more_themes_screen() {
?>
		<div class="wrap about-wrap">

			<?php $this->intro(); ?>
			<div class="theme-browser rendered">
				<div class="themes wp-clearfix">
					<?php
						// Set the argument array with author name.
						$args = array(
							'author' => 'sparklewpthemes',
						);
						// Set the $request array.
						$request = array(
							'body' => array(
								'action'  => 'query_themes',
								'request' => serialize( (object)$args )
							)
						);
						$themes = $this->editorialmag_get_themes( $request );
						$active_theme = wp_get_theme()->get( 'Name' );
						$counter = 1;

						// For currently active theme.
						foreach ( $themes->themes as $theme ) {
							if( $active_theme == $theme->name ) { ?>

								<div id="<?php echo esc_attr( $theme->slug ); ?>" class="theme active">
									<div class="theme-screenshot">
										<img src="<?php echo esc_url( $theme->screenshot_url ); ?>"/>
									</div>
									<h3 class="theme-name" id="editorialmag-name"><strong><?php esc_html_e( 'Active', 'editorialmag' ); ?></strong>: <?php echo esc_attr( $theme->name ); ?></h3>
									<div class="theme-actions">
										<a class="button button-primary customize load-customize hide-if-no-customize" href="<?php echo esc_url( get_site_url() ). '/wp-admin/customize.php' ?>"><?php esc_html_e( 'Customize', 'editorialmag' ); ?></a>
									</div>
								</div><!-- .theme active -->
							<?php
							$counter++;
							break;
							}
						}

						// For all other themes.
						foreach ( $themes->themes as $theme ) {
							if( $active_theme != $theme->name ) {
								// Set the argument array with author name.
								$args = array(
									'slug' => $theme->slug,
								);
								// Set the $request array.
								$request = array(
									'body' => array(
										'action'  => 'theme_information',
										'request' => serialize( (object)$args )
									)
								);
								$theme_details = $this->editorialmag_get_themes( $request );
							?>
								<div id="<?php echo esc_attr( $theme->slug ); ?>" class="theme">
									<div class="theme-screenshot">
										<img src="<?php echo esc_url( $theme->screenshot_url ); ?>"/>
									</div>

									<h3 class="theme-name"><?php echo esc_attr( $theme->name ); ?></h3>

									<div class="theme-actions">
										<?php if( wp_get_theme( $theme->slug )->exists() ) { ?>											
											<!-- Activate Button -->
											<a  class="button button-secondary activate"
												href="<?php echo wp_nonce_url( admin_url( 'themes.php?action=activate&amp;stylesheet=' . urlencode( $theme->slug ) ), 'switch-theme_' . $theme->slug ); ?>" ><?php esc_html_e( 'Activate', 'editorialmag' ) ?></a>
										<?php } else {
											// Set the install url for the theme.
											$install_url = add_query_arg( array(
													'action' => 'install-theme',
													'theme'  => $theme->slug,
												), self_admin_url( 'update.php' ) );
										?>
											<!-- Install Button -->
											<a data-toggle="tooltip" data-placement="bottom" title="<?php echo 'Downloaded ' . number_format( $theme_details->downloaded ) . ' times'; ?>" class="button button-secondary activate" href="<?php echo esc_url( wp_nonce_url( $install_url, 'install-theme_' . $theme->slug ) ); ?>" ><?php esc_html_e( 'Install Now', 'editorialmag' ); ?></a>
										<?php } ?>

										<a class="button button-primary load-customize hide-if-no-customize" target="_blank" href="<?php echo esc_url( $theme->preview_url ); ?>"><?php esc_html_e( 'Live Preview', 'editorialmag' ); ?></a>
									</div>
								</div><!-- .theme -->
								<?php
							}
						}


					?>
				</div>
			</div><!-- .mt-theme-holder -->
		</div><!-- .wrap.about-wrap -->
<?php
	}

	/** 
	 * Get all our themes by using API.
	 */
	private function editorialmag_get_themes( $request ) {

		// Generate a cache key that would hold the response for this request:
		$key = 'editorialmag_' . md5( serialize( $request ) );

		// Check transient. If it's there - use that, if not re fetch the theme
		if ( false === ( $themes = get_transient( $key ) ) ) {

			// Transient expired/does not exist. Send request to the API.
			$response = wp_remote_post( 'http://api.wordpress.org/themes/info/1.0/', $request );

			// Check for the error.
			if ( !is_wp_error( $response ) ) {

				$themes = unserialize( wp_remote_retrieve_body( $response ) );

				if ( !is_object( $themes ) && !is_array( $themes ) ) {

					// Response body does not contain an object/array
					return new WP_Error( 'theme_api_error', 'An unexpected error has occurred' );
				}

				// Set transient for next time... keep it for 24 hours should be good
				set_transient( $key, $themes, 60 * 60 * 24 );
			}
			else {
				// Error object returned
				return $response;
			}
		}
		return $themes;
	}
	
	/**
	 * Output the changelog screen.
	 */
	public function changelog_screen() {
		global $wp_filesystem;

		?>
		<div class="wrap about-wrap">

			<?php $this->intro(); ?>

			<h4><?php esc_html_e( 'View changelog below:', 'editorialmag' ); ?></h4>

			<?php
				$changelog_file = apply_filters( 'editorialmag_changelog_file', get_template_directory() . '/readme.txt' );

				// Check if the changelog file exists and is readable.
				if ( $changelog_file && is_readable( $changelog_file ) ) {
					WP_Filesystem();
					$changelog = $wp_filesystem->get_contents( $changelog_file );
					$changelog_list = $this->parse_changelog( $changelog );

					echo wp_kses_post( $changelog_list );
				}
			?>
		</div>
		<?php
	}

	/**
	 * Parse changelog from readme file.
	 * @param  string $content
	 * @return string
	 */
	private function parse_changelog( $content ) {
		$matches   = null;
		$regexp    = '~==\s*Changelog\s*==(.*)($)~Uis';
		$changelog = '';

		if ( preg_match( $regexp, $content, $matches ) ) {
			$changes = explode( '\r\n', trim( $matches[1] ) );

			$changelog .= '<pre class="changelog">';

			foreach ( $changes as $index => $line ) {
				$changelog .= wp_kses_post( preg_replace( '~(=\s*Version\s*(\d+(?:\.\d+)+)\s*=|$)~Uis', '<span class="title">${1}</span>', $line ) );
			}

			$changelog .= '</pre>';
		}

		return wp_kses_post( $changelog );
	}

	/**
	 * Output the free vs pro screen.
	 */
	public function free_vs_pro_screen() {
		?>
		<div class="wrap about-wrap">

			<?php $this->intro(); ?>

			<h4><?php esc_html_e( 'Upgrade to PRO version for more exciting features.', 'editorialmag' ); ?></h4>

			<table>
				<thead>
					<tr>
						<th class="table-feature-title"><h3><?php esc_html_e( 'Features', 'editorialmag' ); ?></h3></th>
						<th><h3><?php esc_html_e( 'Editorialmag', 'editorialmag' ); ?></h3></th>
						<th><h3><?php esc_html_e( 'Editorialmag Pro', 'editorialmag' ); ?></h3></th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td><h3><?php esc_html_e( 'Price', 'editorialmag' ); ?></h3></td>
						<td><?php esc_html_e( 'Free', 'editorialmag' ); ?></td>
						<td><?php esc_html_e( '$55', 'editorialmag' ); ?></td>
					</tr>
					<tr>
						<td><h3><?php esc_html_e( 'Import Demo Data', 'editorialmag' ); ?></h3></td>
						<td><span class="dashicons dashicons-no"></span></td>
						<td><span class="dashicons dashicons-yes"></span></td>
					</tr>
					<tr>
						<td><h3><?php esc_html_e( 'Header Layouts', 'editorialmag' ); ?></h3></td>
						<td><?php esc_html_e( '1', 'editorialmag' ); ?></td>
						<td><?php esc_html_e( '4', 'editorialmag' ); ?></td>
					</tr>
					<tr>
						<td><h3><?php esc_html_e( 'Advance Category Page Options', 'editorialmag' ); ?></h3></td>
						<td><span class="dashicons dashicons-no"></span></td>
						<td><span class="dashicons dashicons-yes"></span></td>
					</tr>
					<tr>
						<td><h3><?php esc_html_e( 'Advance Post Format Options', 'editorialmag' ); ?></h3></td>
						<td><span class="dashicons dashicons-no"></span></td>
						<td><span class="dashicons dashicons-yes"></span></td>
					</tr>
					<tr>
						<td><h3><?php esc_html_e( 'Typography Options', 'editorialmag' ); ?></h3></td>
						<td><span class="dashicons dashicons-no"></span></td>
						<td><span class="dashicons dashicons-yes"></span></td>
					</tr>
					<tr>
						<td><h3><?php esc_html_e( 'No. of Widgets', 'editorialmag' ); ?></h3></td>
						<td><?php esc_html_e( '9', 'editorialmag' ); ?></td>
						<td><?php esc_html_e( '10+', 'editorialmag' ); ?></td>
					</tr>

					<tr>
						<td><h3><?php esc_html_e( 'Unlimited Colors', 'editorialmag' ); ?></h3></td>
						<td><span class="dashicons dashicons-no"></span></td>
						<td><span class="dashicons dashicons-yes"></span></td>
					</tr>					

					<tr>
						<td><h3><?php esc_html_e( 'Footer Copyright', 'editorialmag' ); ?></h3></td>
						<td><span class="dashicons dashicons-no"></span></td>
						<td><span class="dashicons dashicons-yes"></span></td>
					</tr>

					<tr>
						<td><h3><?php esc_html_e( 'WooCommerce Compatible', 'editorialmag' ); ?></h3></td>
						<td><span class="dashicons dashicons-yes"></span></td>
						<td><span class="dashicons dashicons-yes"></span></td>
					</tr>

					<tr>
						<td><h3><?php esc_html_e( 'Contact Form 7 Plugin Compatible', 'editorialmag' ); ?></h3></td>
						<td><span class="dashicons dashicons-yes"></span></td>
						<td><span class="dashicons dashicons-yes"></span></td>
					</tr>

					<tr>
						<td><h3><?php esc_html_e( 'Responsive Design', 'editorialmag' ); ?></h3></td>
						<td><span class="dashicons dashicons-yes"></span></td>
						<td><span class="dashicons dashicons-yes"></span></td>
					</tr>

					<tr>
						<td><h3><?php esc_html_e( 'SEO Optimized', 'editorialmag' ); ?></h3></td>
						<td><span class="dashicons dashicons-yes"></span></td>
						<td><span class="dashicons dashicons-yes"></span></td>
					</tr>
					<tr>
						<td><h3><?php esc_html_e( 'Webpage Boxed/Full width Options', 'editorialmag' ); ?></h3></td>
						<td><span class="dashicons dashicons-no"></span></td>
						<td><span class="dashicons dashicons-yes"></span></td>
					</tr>

					<tr>
						<td><h3><?php esc_html_e( 'Child Theme Support', 'editorialmag' ); ?></h3></td>
						<td><span class="dashicons dashicons-yes"></span></td>
						<td><span class="dashicons dashicons-yes"></span></td>
					</tr>

					<tr>
						<td><h3><?php esc_html_e( 'Quality Code', 'editorialmag' ); ?></h3></td>
						<td><span class="dashicons dashicons-yes"></span></td>
						<td><span class="dashicons dashicons-yes"></span></td>
					</tr>

					<tr>
						<td><h3><?php esc_html_e( 'Category Color Options', 'editorialmag' ); ?></h3></td>
						<td><span class="dashicons dashicons-yes"></span></td>
						<td><span class="dashicons dashicons-yes"></span></td>
					</tr>
					
					<tr>
						<td></td>
						<td class="btn-wrapper">
							<a href="<?php echo esc_url( apply_filters( 'editorialmag_theme_url', 'https://wordpress.org/themes/editorialmag/' ) ); ?>" class="button button-secondary docs" target="_blank"><?php esc_html_e( 'Download', 'editorialmag' ); ?></a>
						</td>
						<td class="btn-wrapper">
							<a href="<?php echo esc_url( apply_filters( 'editorialmag_pro_theme_url', 'https://www.sparklewpthemes.com/wordpress-themes/editorialmagpro/' ) ); ?>" class="button button-secondary docs" target="_blank"><?php esc_html_e( 'Buy Pro', 'editorialmag' ); ?></a>
						</td>
					</tr>
				</tbody>
			</table>

		</div>
		<?php
	}
}

endif;

return new Editorialmag_About();