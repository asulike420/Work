<?php
/**
 * The header for our theme
 *
 * This is the template that displays all of the <head> section and everything up until <div id="content">
 *
 * @link https://developer.wordpress.org/themes/basics/template-files/#template-partials
 *
 * @package Editorial_Mag
 */

?>
<!doctype html>
<html <?php language_attributes(); ?> <?php editorialmag_html_tag_schema(); ?>>
<head>
	<meta charset="<?php bloginfo( 'charset' ); ?>">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<link rel="profile" href="http://gmpg.org/xfn/11">

	<?php wp_head(); ?>
</head>

<body <?php body_class(); ?>>

<div id="page" class="site">
	<a class="skip-link screen-reader-text" href="#content"><?php esc_html_e( 'Skip to content', 'editorialmag' ); ?></a>

	<?php
		/**
		 * Header Before Blank Hooks
		*/ 
		do_action( 'editorialmag_header_before', 5 );
	?>

	<header id="masthead" class="site-header header-bgimg <?php if ( has_header_image() ) { echo 'headerimage'; } ?>" itemscope="itemscope" itemtype="http://schema.org/WPHeader">
		<div class="sticky-menu">
			<div class="sparkle-wrapper">
				<nav class="main-navigation">
					<div class="toggle-button">
						<span class="toggle-bar1"></span>
						<span class="toggle-bar2"></span>
						<span class="toggle-bar3"></span>
					</div>
					<div class="nav-menu">
						<?php
							wp_nav_menu( array(
								'theme_location' => 'menu-1',
								'menu_id'        => 'primary-menu'
							) );
						?>
					</div>
				</nav>
			</div>
		</div><!-- STICKY MENU -->

		<div class="top-header">
			<div class="sparkle-wrapper">
				<div class="top-nav">
					<?php
						wp_nav_menu( array(
							'theme_location' => 'menu-2',
							'menu_id'        => 'top-menu',
							'depth'          => 2,
						) );
					?>
				</div>
				<div class="top-right">
					<div class="date-time"></div>
					<div class="temprature">
						<?php
							$facebook  = get_theme_mod( 'editorialmag_social_facebook' );
							$twitter   = get_theme_mod( 'editorialmag_social_twitter' );
							$linkedin  = get_theme_mod( 'editorialmag_social_linkedin' );
							$youtube   = get_theme_mod( 'editorialmag_social_youtube' );
						?>
						<?php if( !empty( $facebook ) ) { ?>
							<a href="<?php echo esc_url( $facebook ); ?>" target="_blank">
								<i class="icofont fa fa-facebook"></i>
							</a>
						<?php } if( !empty( $twitter ) ) { ?>
							<a href="<?php echo esc_url( $twitter ); ?>" target="_blank">
								<i class="icofont fa fa-twitter"></i>
							</a>
						<?php } if( !empty( $youtube ) ) { ?>
							<a href="<?php echo esc_url( $youtube ); ?>" target="_blank">
								<i class="icofont fa fa-youtube-play"></i>
							</a>
						<?php } if( !empty( $linkedin ) ) { ?>	
							<a href="<?php echo esc_url( $linkedin ); ?>" target="_blank">
								<i class="icofont fa fa-linkedin"></i>
							</a>
						<?php } ?>
					</div>
				</div>
			</div>
		</div> <!-- TOP HEADER -->
		<div class="bottom-header">
			<div class="sparkle-wrapper">
				<div class="site-logo site-branding">
					<?php the_custom_logo(); ?>
					<h1 class="site-title">
						<a href="<?php echo esc_url( home_url( '/' ) ); ?>" rel="home">
							<?php bloginfo( 'name' ); ?>
						</a>
					</h1>
					<?php 
						$description = get_bloginfo( 'description', 'display' );
						if ( $description || is_customize_preview() ) { ?>
							<p class="site-description">
								<?php echo $description; /* WPCS: xss ok. */ ?>
							</p>
					<?php } ?>					
				</div> <!-- .site-branding -->

				<div class="header-ad-section">
					<?php 
					    if( is_active_sidebar( 'headerads' ) ){
					        dynamic_sidebar( 'headerads' );
					    }
					?>
				</div>
			</div>
		</div> <!-- BOTTOM HEADER -->

		<div class="nav-wrap nav-left-align">
			<div class="sparkle-wrapper">
				<nav class="main-navigation">
					<div class="toggle-button">
						<span class="toggle-bar1"></span>
						<span class="toggle-bar2"></span>
						<span class="toggle-bar3"></span>
					</div>
					<div class="nav-menu">
						<?php
							wp_nav_menu( array(
								'theme_location' => 'menu-1',
								'menu_id'        => 'primary-menu'
							) );
						?>
					</div>
				</nav>

				<div class="nav-icon-wrap">
					<div class="search-wrap">
						<i class="icofont fa fa-search"></i>
						<div class="search-form-wrap">
							<?php get_search_form(); ?>
						</div>
					</div>
				</div>
			</div>
		</div> <!-- MAIN NAVIGATION -->
	</header>

	<?php
		/**
		 * Header After Blank Hooks
		*/ 
		do_action( 'editorialmag_header_after', 10 );

		/**
		 * Header Breaking News Section
		*/ 
		do_action( 'editorialmag_breaking_news', 5 );
	?>	

	<div id="content" class="site-content">
