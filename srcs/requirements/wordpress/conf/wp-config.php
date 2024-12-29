<?php
define('DB_NAME', getenv('DB_NAME'));
define('DB_USER', getenv('DB_USER'));
define('DB_PASSWORD', getenv('DB_PASSWORD'));
define('DB_HOST', getenv('DB_HOST'));
define('WP_HOME', getenv('WP_FULL_URL'));
define('WP_SITEURL', getenv('WP_FULL_URL'));

define('AUTH_KEY',         'uniquekey1234567890abcdefghijklmnopqrstuvwxyz');
define('SECURE_AUTH_KEY',  'secureauthkey1234567890abcdefghijklmnopqrstuvwxyz');
define('LOGGED_IN_KEY',    'loggedinkey1234567890abcdefghijklmnopqrstuvwxyz');
define('NONCE_KEY',        'noncekey1234567890abcdefghijklmnopqrstuvwxyz');
define('AUTH_SALT',        'authsalt1234567890abcdefghijklmnopqrstuvwxyz');
define('SECURE_AUTH_SALT', 'secureauthsalt1234567890abcdefghijklmnopqrstuvwxyz');
define('LOGGED_IN_SALT',   'loggedinsalt1234567890abcdefghijklmnopqrstuvwxyz');
define('NONCE_SALT',       'noncesalt1234567890abcdefghijklmnopqrstuvwxyz');

define('WP_DEBUG', false);
define('FORCE_SSL_ADMIN', true);
define('AUTOMATIC_UPDATER_DISABLED', true);

if (!defined('ABSPATH')) {
    define('ABSPATH', __DIR__ . '/');
}

require_once ABSPATH . 'wp-settings.php';
