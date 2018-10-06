<?php
/**
 * The base configuration for WordPress
 *
 * The wp-config.php creation script uses this file during the
 * installation. You don't have to use the web site, you can
 * copy this file to "wp-config.php" and fill in the values.
 *
 * This file contains the following configurations:
 *
 * * MySQL settings
 * * Secret keys
 * * Database table prefix
 * * ABSPATH
 *
 * @link https://codex.wordpress.org/Editing_wp-config.php
 *
 * @package WordPress
 */

// ** MySQL settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define('DB_NAME', 'myblogsongreen');

/** MySQL database username */
define('DB_USER', 'myblogsongreen');

/** MySQL database password */
define('DB_PASSWORD', 'harrypotter');

/** MySQL hostname */
define('DB_HOST', 'localhost');

/** Database Charset to use in creating database tables. */
define('DB_CHARSET', 'utf8');

/** The Database Collate type. Don't change this if in doubt. */
define('DB_COLLATE', '');

/**#@+
 * Authentication Unique Keys and Salts.
 *
 * Change these to different unique phrases!
 * You can generate these using the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}
 * You can change these at any point in time to invalidate all existing cookies. This will force all users to have to log in again.
 *
 * @since 2.6.0
 */
define('AUTH_KEY',         '!_F]1`)8{gZcFCw|Lg_bV:q*|aCQz9w#CcOpn]n(A5UdZi7*O*NyJ9Y<Ba~ryDcv');
define('SECURE_AUTH_KEY',  '-/u5QX*/GiTSHkcx<gx4q_v#gzK>R*J]lCK`*_Q~l.4>Yae)uSd?| 2Hn9^1>#L&');
define('LOGGED_IN_KEY',    '=7JkU;T1c?5l.$kRh>j5+`fz@c<o-IzDwcOe8:4QPP4y(b:.I-D@p)Ls$0e_3U:4');
define('NONCE_KEY',        '{wu?L}03/a5=Pov}}Jx-uap`5ZaphrkR+3z`|X,4>-jMRen9::a@UEOU,[2| lh ');
define('AUTH_SALT',        'fWn?Y}8QmZRy+|^0a2.Sw81k$|PtS*37l9h#,p=++K5t1:#sv`IT$I4G j<9U+oK');
define('SECURE_AUTH_SALT', '1>{t0+ILgyukE@$H.2:Hx2DMhYmJ=4y127b7im6~?DT!qV$[ gk[*;UhMLdnaDPp');
define('LOGGED_IN_SALT',   'KkWJ&9-h-b74NF$l{k*v(^6ZvHvOvs+y+7$z@?6X3a`ThiWZE}5LW)919wX%vF*}');
define('NONCE_SALT',       'FGxQ/|!{EQ})/-d}H]}7v(t@45-iN FD`|1M+m?3~3VVJxsklH$mvhfv-<w5)?GX');

/**#@-*/

/**
 * WordPress Database Table prefix.
 *
 * You can have multiple installations in one database if you give each
 * a unique prefix. Only numbers, letters, and underscores please!
 */
$table_prefix  = 'wp_';

/**
 * For developers: WordPress debugging mode.
 *
 * Change this to true to enable the display of notices during development.
 * It is strongly recommended that plugin and theme developers use WP_DEBUG
 * in their development environments.
 *
 * For information on other constants that can be used for debugging,
 * visit the Codex.
 *
 * @link https://codex.wordpress.org/Debugging_in_WordPress
 */
define('WP_DEBUG', false);

/* That's all, stop editing! Happy blogging. */

/** Absolute path to the WordPress directory. */
if ( !defined('ABSPATH') )
	define('ABSPATH', dirname(__FILE__) . '/');

/** Sets up WordPress vars and included files. */
require_once(ABSPATH . 'wp-settings.php');
