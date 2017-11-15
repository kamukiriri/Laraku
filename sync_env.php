<?php
define(APP_ENV, "../.env");
define(LARADOCK_ENV, "./.env");

define(DEBUG, isset($argv[1]) && !empty($argv[1]));

$db_type = "pgsql";
$db_host = "postgres";
$db_port = "5432";
$conf_prefix = strtoupper($db_host);

preg_match_all("/${conf_prefix}_(.+?)=(.+?)\n/", file_get_contents(LARADOCK_ENV), $m, PREG_SET_ORDER);
if(DEBUG) print_r($m);

$db_conf = [];
foreach ($m as $conf) {
	$db_conf[$conf[1]] = $conf[2];
}

$app_conf = [
	"DB_CONNECTION"=> $db_type,
	"DB_HOST"=> $db_host,
	"DB_PORT"=> $db_port,
	"DB_DATABASE"=> $db_conf["DB"] ?: $db_conf["DATABASE"],
	"DB_USERNAME"=> $db_conf["USER"],
	"DB_PASSWORD"=> $db_conf["PASSWORD"],
];

if(DEBUG) print_r($app_conf);

$edited_env = preg_replace_callback("/(DB_.*?)=.*?\n/",
	function($m)use($app_conf){ return $m[1]."=".$app_conf[$m[1]]."\n"; },
	file_get_contents(APP_ENV));

if(DEBUG) print_r($edit_env);

file_put_contents(APP_ENV, $edited_env);

?>