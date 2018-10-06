<?php
/**
 * Adds editorialmag_grid_widget widget.
*/
add_action('widgets_init', 'editorialmag_grid_widget');

function editorialmag_grid_widget() {
    register_widget('editorialmag_grid_widget_area');
}

class editorialmag_grid_widget_area extends WP_Widget {

    /**
     * Register widget with WordPress.
    */
    public function __construct() {
        parent::__construct(
            'emag_magazine_grid_posts', esc_html_x('EMag Grid Posts', 'widget name', 'editorialmag'),
            array(
                'classname' => 'emag_magazine_grid_posts',
                'description' => esc_html__('Widget display all posts in grid layout', 'editorialmag'),
                'customize_selective_refresh' => true
            )
        );
    }

    private function widget_fields() {

        $args = array(
            'type'       => 'post',
            'child_of'   => 0,
            'orderby'    => 'name',
            'order'      => 'ASC',
            'hide_empty' => 1,
            'taxonomy'   => 'category',
        );
        $categories = get_categories( $args );
        $cat_lists = array();
        foreach ($categories as $category) {
            $cat_lists[$category->term_id] = $category->name;
        }

        $fields = array(
            
            'editorialmag_block_title' => array(
                'editorialmag_widgets_name' => 'editorialmag_block_title',
                'editorialmag_widgets_title' => esc_html__('Block Title', 'editorialmag'),
                'editorialmag_widgets_field_type' => 'title',
            ),

            'editorialmag_category_list' => array(
                'editorialmag_widgets_name' => 'editorialmag_category_list',
                'editorialmag_mulicheckbox_title' => esc_html__('Select Posts Category', 'editorialmag'),
                'editorialmag_widgets_field_type' => 'multicheckboxes',
                'editorialmag_widgets_field_options' => $cat_lists
            ),

            'editorialmag_block_display_number_posts' => array(
                'editorialmag_widgets_name' => 'editorialmag_block_display_number_posts',
                'editorialmag_widgets_title' => esc_html__('Enter Display Number of Posts', 'editorialmag'),
                'editorialmag_widgets_field_type' => 'number',
            ),

            'editorialmag_block_info' => array(
                'editorialmag_widgets_name' => 'editorialmag_block_info',
                'editorialmag_widgets_title' => esc_html__('Info', 'editorialmag'),
                'editorialmag_widgets_description' => esc_html__('This is the lite version of this widget with basic features. More features and options are available in the premium version of Editorial Magazine.', 'editorialmag'),
                'editorialmag_widgets_field_type' => 'info',
            )
            
        );

        return $fields;
    }

    public function widget($args, $instance) {
        extract($args);
        
        /**
         * wp query for first block
        */
	    $title = apply_filters( 'widget_title', empty($instance['editorialmag_block_title']) ? '' : $instance['editorialmag_block_title'], $instance, $this->id_base);
        $number_posts        = empty( $instance['editorialmag_block_display_number_posts'] ) ? 5 : $instance['editorialmag_block_display_number_posts'];
        $category_list       = empty( $instance['editorialmag_category_list'] ) ? '' : $instance['editorialmag_category_list'];

        $block_cat_id = array();
        if (!empty($category_list)) {
            $block_cat_id = array_keys($category_list);
        }

        $args = array(
            'post_type' => 'post',
            'posts_per_page' => $number_posts,
            'tax_query' => array(
                array(
                    'taxonomy' => 'category',
                    'field'    => 'term_id',
                    'terms'    => $block_cat_id
                ),
            ),
        );

        $query = new WP_Query( $args );

        echo $before_widget; 
    ?>  
        <div class="news-with-grid-layout">
            <?php if(!empty( $title )){ ?>
                <h2 class="widget-title">
                    <span><?php echo esc_attr( $title ); ?></span>
                </h2>
            <?php } ?>
            <div class="news-with-grid-layout-wrap clearfix">
                <?php  while( $query->have_posts() ){ $query->the_post(); ?>
                    <div class="news-with-grid-block equalheight">
                        <?php if( has_post_thumbnail() ){ ?>
                            <figure>
                                <a href="<?php the_permalink(); ?>"><?php the_post_thumbnail( 'medium' ); ?></a>
                            </figure>
                        <?php } ?>
                        <div class="news-content">
                            <h3 class="news-title">
                                <a href="<?php the_permalink(); ?>"><?php the_title(); ?></a>
                            </h3>
                            <div class="news-block-footer">
                                <div class="news-date">
                                    <i class="icofont fa fa-clock-o"></i> <a href="<?php the_permalink(); ?>"><?php the_time( get_option( 'date_format' ) ); ?></a>
                                </div>
                                <div class="news-comment">
                                    <i class="icofont fa fa-commenting"></i> <?php comments_popup_link( esc_html__( 'No comment', 'editorialmag' ), esc_html__( '1 Comment', 'editorialmag' ), esc_html__( '% Comments', 'editorialmag' ) ); ?>
                                </div>
                            </div>
                        </div>
                    </div>
                <?php }  wp_reset_postdata(); ?>               
            </div>
        </div> <!-- NEWS WITH GRID LAYOUT -->            
    <?php
        echo $after_widget;
    }

    public function update($new_instance, $old_instance) {
        $instance = $old_instance;
        $widget_fields = $this->widget_fields();
        foreach ($widget_fields as $widget_field) {
            extract($widget_field);
            $instance[$editorialmag_widgets_name] = editorialmag_widgets_updated_field_value( $widget_field, $new_instance[$editorialmag_widgets_name] );
        }
        return $instance;
    }

    public function form($instance) {
        $widget_fields = $this->widget_fields();
        foreach ( $widget_fields as $widget_field ) {
            extract( $widget_field );
            $editorialmag_widgets_field_value = !empty( $instance[ $editorialmag_widgets_name ] ) ? $instance[ $editorialmag_widgets_name ] : '';
            editorialmag_widgets_show_widget_field( $this, $widget_field, $editorialmag_widgets_field_value );
        }
    }

}
