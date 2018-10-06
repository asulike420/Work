<?php
/**
 * Main Custom admin functions area
 *
 * @since SparklewpThemes
 *
 * @param Editorial_Mag
 */


/**
 * Editorial Mag Breaking News
*/
if ( ! function_exists( 'editorialmag_breaking_news' ) ) {
    function editorialmag_breaking_news(){
        $breakingnews = new WP_Query( array(
            'posts_per_page' => 10,
            'post_type'      => 'post',
            'cat'            => get_theme_mod( 'editorialmag_breaking_news_team_id', 1 )
        ) );

        $options = get_theme_mod( 'editorialmag_breaking_news_section','enable' );
            if(!empty( $options ) && $options == 'enable' ){
        ?>
            <section class="hot-news-slider">
                <div class="sparkle-wrapper">
                    <ul class="hot-news-wrap cS-hidden clearfix">
                        <?php if( $breakingnews->have_posts() ) : while( $breakingnews->have_posts() ) : $breakingnews->the_post(); ?>
                            <li>
                                <?php if( has_post_thumbnail() ){ ?>
                                    <figure class="hot-news-img">
                                        <?php the_post_thumbnail('thumbnail'); ?>
                                    </figure>
                                <?php } ?>
                                <div class="news-title-wrap">
                                    <div class="news-categories">
                                        <?php the_category( ' / ' ); ?>
                                    </div>
                                    <h2 class="news-title">
                                        <a href="<?php the_permalink(); ?>"><?php the_title(); ?></a>
                                    </h2>
                                    <div class="publish-date">
                                        <i class="icofont fa fa-clock-o"></i>
                                        <a href="<?php the_permalink(); ?>"><?php the_date(); ?></a>
                                    </div>
                                </div>
                            </li>
                        <?php endwhile; endif; wp_reset_postdata(); ?>                        
                    </ul>
                </div>
            </section> <!-- HOT NEWS SECTION -->
        <?php 
            }
    }
}
add_action( 'editorialmag_breaking_news', 'editorialmag_breaking_news', 15 );


/**
  * Footer Copyright Information
 */
if ( ! function_exists( 'editorialmag_footer_copyright' ) ){
    function editorialmag_footer_copyright() {
        $copyright = get_theme_mod( 'editorialmag_footer_buttom_copyright_setting' ); 
        if( !empty( $copyright ) ) { 
            echo apply_filters( 'editorialmag_copyright_text', $copyright . ' ' ); 
        } else { 
            echo esc_html( apply_filters( 'editorialmag_copyright_text', $content = esc_html__('Copyright  &copy; ','editorialmag') . date( 'Y' ) . ' ' . get_bloginfo( 'name' ) .' - ' ) );
            printf( '%1$s By %2$s', esc_html__(' Powered ','editorialmag'), '<a href=" ' . esc_url('http://wordpress.org/') . ' " rel="designer" target="_blank">'.esc_html__('WordPress','editorialmag').'</a>' );
        }   
    }
}
add_action( 'editorialmag_copyright', 'editorialmag_footer_copyright', 5 );


/**
 * Color Category
*/
if ( !function_exists('editorialmag_colored_category') ){
    function editorialmag_colored_category() {
        global $post;
        $categories = get_the_category();
        $separator = '&nbsp;';
        $output = '';
        if($categories) {
            $output .= '<div class="colorful-cat">';
                foreach($categories as $category) {
                    $color_code = editorialmag_category_color( get_cat_id( $category->cat_name ) );
                    if (!empty($color_code)) {
                        $output .= '<a href="'.get_category_link( $category->term_id ).'" style="background:' . editorialmag_category_color( get_cat_id( $category->cat_name ) ) . '" rel="category tag">'.esc_attr( $category->cat_name ).'</a>'.$separator;
                    } else {
                        $output .= '<a href="'.get_category_link( $category->term_id ).'"  rel="category tag">'.$category->cat_name.'</a>'.$separator;
                    }
                }
            $output .='</div>';
            echo trim( $output, $separator );
        }
    }
}

if ( ! function_exists( 'editorialmag_category_color' ) ){
    function editorialmag_category_color( $wp_category_id ) {
        $args = array(
          'orderby' => 'id',
          'hide_empty' => 0
        );
        $category = get_categories( $args );
        foreach ( $category as $category_list ) {
          $color = get_theme_mod( 'editorialmag_category_color_'.$wp_category_id );
          return $color;
        }
    }
}

/**
 * Customizer Custom Control Class Layout 
*/

if(class_exists( 'WP_Customize_control')) {
    
    /** 
     * Page Layout Control
    */
    class Editorialmag_Image_Radio_Control extends WP_Customize_Control {
        public $type = 'radioimage';
        public function render_content() {
            $name = '_customize-radio-' . $this->id;
            ?>
            <span class="customize-control-title"><?php echo esc_html( $this->label ); ?></span>
            <div id="input_<?php echo esc_attr( $this->id ); ?>" class="image">
                <?php foreach ( $this->choices as $value => $label ) : ?>                
                        <label for="<?php echo esc_attr( $this->id ) . esc_attr( $value ); ?>">
                            <input class="image-select" type="radio" value="<?php echo esc_attr( $value ); ?>" name="<?php echo esc_attr( $name ); ?>" id="<?php echo esc_attr( $this->id ) . esc_attr( $value ); ?>" <?php esc_url( $this->link() ); checked( $this->value(), $value ); ?>>
                            <img src="<?php echo esc_url( $label ); ?>"/>
                        </label>
                <?php endforeach; ?>
            </div>
            <?php 
        }
    } 

    /** 
     * Theme Important Info 
    */
    class Editorialmag_theme_Info_Text extends WP_Customize_Control{
        public function render_content(){  ?>
            <span class="customize-control-title">
                <?php echo esc_html( $this->label ); ?>
            </span>
            <?php if($this->description){ ?>
                <span class="description customize-control-description">
                <?php echo wp_kses_post($this->description); ?>
                </span>
            <?php }
        }
    }  

    /** 
     * Category
    */
    class Editorialmag_Category_Dropdown extends WP_Customize_Control{
        private $cats = false;
        public function __construct($manager, $id, $args = array(), $options = array()){
            $this->cats = get_categories($options);
            parent::__construct( $manager, $id, $args );
        }

        public function render_content(){
            if(!empty($this->cats)){
                ?>
                    <label>
                        <span class="customize-control-title"><?php echo esc_html( $this->label ); ?></span>
                        <select <?php $this->link(); ?>>
                            <?php
                                foreach ( $this->cats as $cat ){
                                    printf('<option value="%1$s" %2$s>%3$s</option>', esc_attr($cat->term_id), selected($this->value(), $cat->term_id, false), esc_attr( $cat->name ));
                                }
                            ?>
                        </select>
                    </label>
                    <?php if($this->description){ ?>
                        <span class="description customize-control-description">
                            <?php echo wp_kses_post($this->description); ?>
                        </span>
                <?php }
            }
       }
    }

}



/**
 * Filter the except length to 20 words.
 *
 * @param int $length Excerpt length.
 * @return int (Maybe) modified excerpt length.
 */
function editorialmag_custom_excerpt_length( $length ) {
	if(is_admin() ){
		return $length;
	}
    return 42;
}
add_filter( 'excerpt_length', 'editorialmag_custom_excerpt_length', 999 );

/**
 * Filter the excerpt "read more" string.
 *
 * @param string $more "Read more" excerpt string.
 * @return string (Maybe) modified "read more" excerpt string.
 */
function editorialmag_excerpt_more( $more ) {
	if(is_admin() ){
		return $more;
	}
    return '...';
}
add_filter( 'excerpt_more', 'editorialmag_excerpt_more' );

/**
 * WooCommerce Section Start Here
*/
if ( ! function_exists( 'editorialmag_is_woocommerce_activated' ) ) {
    function editorialmag_is_woocommerce_activated() {
        if ( class_exists( 'WooCommerce' ) ) { return true; } else { return false; }
    }
}


/**
 * Schema type
*/
function editorialmag_html_tag_schema() {
    $schema     = 'http://schema.org/';
    $type       = 'WebPage';
    // Is single post
    if ( is_singular( 'post' ) ) {
        $type   = 'Article';
    }
    // Is author page
    elseif ( is_author() ) {
        $type   = 'ProfilePage';
    }
    // Is search results page
    elseif ( is_search() ) {
        $type   = 'SearchResultsPage';
    }
    echo 'itemscope="itemscope" itemtype="' . esc_attr( $schema ) . esc_attr( $type ) . '"';
}


/**
 * Page and Post Page Display Layout Metabox function
*/
add_action('add_meta_boxes', 'editorialmag_metabox_section');
if ( ! function_exists( 'editorialmag_metabox_section' ) ) {
    function editorialmag_metabox_section(){   
        add_meta_box('editorialmag_display_layout', 
            esc_html__( 'Display Layout Options', 'editorialmag' ), 
            'editorialmag_display_layout_callback', 
            array('page','post'), 
            'normal', 
            'high'
        );
    }
}

$editorialmag_page_layouts =array(
    'leftsidebar' => array(
        'value'     => 'leftsidebar',
        'label'     => esc_html__( 'Left Sidebar', 'editorialmag' ),
        'thumbnail' => get_template_directory_uri() . '/assets/images/left-sidebar.png',
    ),
    'rightsidebar' => array(
        'value'     => 'rightsidebar',
        'label'     => esc_html__( 'Right (Default)', 'editorialmag' ),
        'thumbnail' => get_template_directory_uri() . '/assets/images/right-sidebar.png',
    ),
     'nosidebar' => array(
        'value'     => 'nosidebar',
        'label'     => esc_html__( 'Full width', 'editorialmag' ),
        'thumbnail' => get_template_directory_uri() . '/assets/images/no-sidebar.png',
    )
);

/**
 * Function for Page layout meta box
*/
if ( ! function_exists( 'editorialmag_display_layout_callback' ) ) {
    function editorialmag_display_layout_callback(){
        global $post, $editorialmag_page_layouts;
        wp_nonce_field( basename( __FILE__ ), 'editorialmag_settings_nonce' ); ?>
        <table>
            <tr>
              <td>            
                <?php
                  $i = 0;  
                  foreach ($editorialmag_page_layouts as $field) {  
                  $editorialmag_page_metalayouts = esc_attr( get_post_meta( $post->ID, 'editorialmag_page_layouts', true ) ); 
                ?>            
                  <div class="radio-image-wrapper slidercat" id="slider-<?php echo intval( $i ); ?>">
                    <label class="description">
                        <span>
                          <img src="<?php echo esc_url( $field['thumbnail'] ); ?>" />
                        </span></br>
                        <input type="radio" name="editorialmag_page_layouts" value="<?php echo esc_attr( $field['value'] ); ?>" <?php checked( esc_html( $field['value'] ), 
                            $editorialmag_page_metalayouts ); if(empty($editorialmag_page_metalayouts) && esc_html( $field['value'] ) =='rightsidebar'){ echo "checked='checked'";  } ?>/>
                         <?php echo esc_html( $field['label'] ); ?>
                    </label>
                  </div>
                <?php  $i++; }  ?>
              </td>
            </tr>            
        </table>
    <?php
    }
}

/**
 * Save the custom metabox data
*/
if ( ! function_exists( 'editorialmag_save_page_settings' ) ) {
    function editorialmag_save_page_settings( $post_id ) { 
        global $editorialmag_page_layouts, $post;
         if ( !isset( $_POST[ 'editorialmag_settings_nonce' ] ) || !wp_verify_nonce( sanitize_key( $_POST[ 'editorialmag_settings_nonce' ] ) , basename( __FILE__ ) ) ) 
            return;
        if ( defined( 'DOING_AUTOSAVE' ) && DOING_AUTOSAVE)  
            return;        
        if (isset( $_POST['post_type'] ) && 'page' == $_POST['post_type']) {  
            if (!current_user_can( 'edit_page', $post_id ) )  
                return $post_id;  
        } elseif (!current_user_can( 'edit_post', $post_id ) ) {  
                return $post_id;  
        }  

        foreach ($editorialmag_page_layouts as $field) {  
            $old = esc_attr( get_post_meta( $post_id, 'editorialmag_page_layouts', true) );
            if ( isset( $_POST['editorialmag_page_layouts']) ) { 
                $new = sanitize_text_field( wp_unslash( $_POST['editorialmag_page_layouts'] ) );
            }
            if ($new && $new != $old) {  
                update_post_meta($post_id, 'editorialmag_page_layouts', $new);  
            } elseif ('' == $new && $old) {  
                delete_post_meta($post_id,'editorialmag_page_layouts', $old);  
            } 
         } 
    }
}
add_action('save_post', 'editorialmag_save_page_settings');