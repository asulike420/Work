<?php
/**
 * The template for displaying the footer
 *
 * Contains the closing of the #content div and all content after.
 *
 * @link https://developer.wordpress.org/themes/basics/template-files/#template-partials
 *
 * @package Editorial_Mag
 */

?>

	</div><!-- #content -->

	<?php
		/**
		 * Footer Before Blank Hooks
		*/ 
		do_action( 'editorialmag_footer_before' );
	?>
		<footer id="colophon" class="site-footer" itemscope="itemscope" itemtype="http://schema.org/WPFooter">
			<?php
				$facebook  = get_theme_mod( 'editorialmag_social_facebook' );
				$twitter   = get_theme_mod( 'editorialmag_social_twitter' );
				$linkedin  = get_theme_mod( 'editorialmag_social_linkedin' );
				$youtube   = get_theme_mod( 'editorialmag_social_youtube' );
				$instagram = get_theme_mod( 'editorialmag_social_instagram' );
				$social_media = get_theme_mod( 'editorialmag_social_media_link','enable' );
				if(!empty( $social_media ) && $social_media == 'enable'){
			?>
				<div class="footer-social">
					<div class="sparkle-wrapper">
						<?php if( !empty( $facebook ) ) { ?>
							<div class="footer-social-block">
								<a href="<?php echo esc_url( $facebook ); ?>" class="facebook">
									<i class="icofont fa fa-facebook"></i>
									<div class="footer-social-content">
										<?php esc_html_e('Facebook','editorialmag'); ?>
										<span class="social-sub-title"><?php esc_html_e('Like us on facebook','editorialmag'); ?></span>
									</div>
								</a>
							</div>
						<?php } if( !empty( $twitter ) ) { ?>
							<div class="footer-social-block">
								<a href="<?php echo esc_url( $twitter ); ?>" class="twitter">
									<i class="icofont fa fa-twitter"></i>
									<div class="footer-social-content">
										<?php esc_html_e('Twitter','editorialmag'); ?>
										<span class="social-sub-title"><?php esc_html_e('Tweet us on twitter','editorialmag'); ?></span>
									</div>
								</a>
							</div>
						<?php } if( !empty( $linkedin ) ) { ?>
							<div class="footer-social-block">
								<a href="<?php echo esc_url( $linkedin ); ?>" class="linkedin">
									<i class="icofont fa fa-linkedin"></i>
									<div class="footer-social-content">
										<?php esc_html_e('Linkedin','editorialmag'); ?>
										<span class="social-sub-title"><?php esc_html_e('Join us on Linkedin','editorialmag'); ?></span>
									</div>
								</a>
							</div>
						<?php } if( !empty( $youtube ) ) { ?>
							<div class="footer-social-block">
								<a href="<?php echo esc_url( $youtube ); ?>" class="youtube">
									<i class="icofont fa fa-youtube-play"></i>
									<div class="footer-social-content">
										<?php esc_html_e('youtube','editorialmag'); ?>
										<span class="social-sub-title"><?php esc_html_e('Subscribe us on youtube','editorialmag'); ?></span>
									</div>
								</a>
							</div>
						<?php } if( !empty( $instagram ) ) { ?>
							<div class="footer-social-block">
								<a href="<?php echo esc_url( $instagram ); ?>" class="instagram">
									<i class="icofont fa fa-instagram"></i>
									<div class="footer-social-content">
										<?php esc_html_e('Instagram','editorialmag'); ?>
										<span class="social-sub-title"><?php esc_html_e('Join us on instagram','editorialmag'); ?></span>
									</div>
								</a>
							</div>
						<?php } ?>
					</div>
				</div>
			<?php } ?>

			<!-- Main Footer Area -->
			<?php if( is_active_sidebar( 'footer-1' ) || is_active_sidebar( 'footer-2' ) || is_active_sidebar( 'footer-3' ) || is_active_sidebar( 'footer-4' ) ){ ?>
				<div class="bottom-footer column-4">
					<div class="sparkle-wrapper">
						<div class="bottom-footer-block">
							<?php 
							    if( is_active_sidebar( 'footer-1' ) ){
							        dynamic_sidebar( 'footer-1' );
							    }
							?>
						</div>
						<div class="bottom-footer-block">
							<?php 
							    if( is_active_sidebar( 'footer-2' ) ){
							        dynamic_sidebar( 'footer-2' );
							    }
							?>
						</div>
						<div class="bottom-footer-block">
							<?php 
							    if( is_active_sidebar( 'footer-3' ) ){
							        dynamic_sidebar( 'footer-3' );
							    }
							?>
						</div>
						<div class="bottom-footer-block">
							<?php 
							    if( is_active_sidebar( 'footer-4' ) ){
							        dynamic_sidebar( 'footer-4' );
							    }
							?>
						</div>
					</div>
				</div>
			<?php } ?>
			<div class="copyright-footer">
				<div class="sparkle-wrapper">
					<div class="copyright-block">
						<?php do_action( 'editorialmag_copyright', 5 ); ?>
					</div>
					<div class="theme-author-block">
						<?php printf( '%1$s by %2$s', esc_html__('Designed & Developed','editorialmag'), '<a href=" ' . 'https://www.sparklewpthemes.com/' . ' " rel="designer" target="_blank">'.esc_html__('Sparkle Themes','editorialmag').'</a>' ); ?>
					</div>
				</div>
			</div>

			<div class="scroll-to-top">
				<i class="icofont fa fa-angle-up"></i>
			</div>
		</footer>
	<?php
		/**
		 * Footer After Blank Hooks
		*/ 
		do_action( 'editorialmag_footer_after' );
	?>

</div><!-- #page -->

<?php wp_footer(); ?>

</body>
</html>
