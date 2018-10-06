<?php
/**
 * Button Widget.
 *
 * @package ShareThisShareButtons
 */

namespace ShareThisShareButtons;

/**
 * Cart Widget Class
 *
 * @package ProdigyCommerce
 */
class Button_Widget extends \WP_Widget {

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

		$widget_options = array(
			'classname' => 'st_button_widget',
			'description' => esc_html__( 'Add ShareThis share buttons to your sidebar.', 'sharethis-share-buttons' ),
		);
		parent::__construct(
			'st_button_widget',
			'ShareThis Buttons',
			$widget_options
		);
	}

	/**
	 * Create the widget output.
	 *
	 * @param array $args Widget output arguments.
	 * @param array $instance The widget instance.
	 */
	public function widget( $args, $instance ) {
		global $post;

		$data_url = '';

		if ( is_archive() || is_front_page() || is_tag() ) {
			$data_url = 'data-url=' . get_permalink( $post->ID );
		}

		// Add buttons.
		?>
		  <div class="sharethis-inline-share-buttons" <?php echo esc_attr( $data_url ); ?>></div>
		<?php
	}

	/**
	 * The widget form.
	 *
	 * @param array $instance The current widget instance.
	 */
	public function form( $instance ) {
		return '';
	}

	/**
	 * Update database with new info
	 *
	 * @param array $new_instance The new instance of the widget values.
	 * @param array $old_instance The old instance of the widget values.
	 *
	 * @return array
	 */
	public function update( $new_instance, $old_instance ) {
		$instance = $old_instance;

		return $instance;
	}
}
