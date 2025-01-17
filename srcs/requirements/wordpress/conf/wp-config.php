<?php
// Configurazione database
define('DB_NAME', getenv('DB_NAME'));
define('DB_USER', getenv('DB_USER'));
define('DB_PASSWORD', getenv('DB_PASSWORD'));
define('DB_HOST', getenv('DB_HOST'));

// URL del sito
define('WP_HOME', getenv('WP_FULL_URL'));
define('WP_SITEURL', getenv('WP_FULL_URL'));

// Chiavi di autenticazione e salt - possono essere generate automaticamente
// https://api.wordpress.org/secret-key/1.1/salt/
require_once(dirname(__FILE__) . '/wp-keys.php');

// Prefisso tabelle - necessario
$table_prefix = 'wp_';

// Configurazioni di sicurezza
define('WP_DEBUG', false);
define('FORCE_SSL_ADMIN', true);
define('AUTOMATIC_UPDATER_DISABLED', true);

// Definizione ABSPATH - necessaria
if (!defined('ABSPATH')) {
    define('ABSPATH', __DIR__ . '/');
}

require_once ABSPATH . 'wp-settings.php';
