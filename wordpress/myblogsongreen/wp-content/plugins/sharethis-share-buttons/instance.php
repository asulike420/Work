<?php
/**
 * Instantiates the ShareThis Share Buttons plugin
 *
 * @package ShareThisShareButtons
 */

namespace ShareThisShareButtons;

global $sharethis_share_buttons_plugin;

require_once __DIR__ . '/php/class-plugin-base.php';
require_once __DIR__ . '/php/class-plugin.php';

$sharethis_share_buttons_plugin = new Plugin();

/**
 * ShareThis Share Buttons Plugin Instance
 *
 * @return Plugin
 */
function get_plugin_instance() {
	global $sharethis_share_buttons_plugin;
	return $sharethis_share_buttons_plugin;
}
