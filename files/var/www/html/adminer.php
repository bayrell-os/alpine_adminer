<?php

define("SID", "PHPSESSID");
session_set_cookie_params([
	"lifetime" => 7*24*60*60,
	"path" => isset($_SERVER["HTTP_X_ROUTE_PREFIX"]) ? $_SERVER["HTTP_X_ROUTE_PREFIX"] : "/",
]);
session_start();

include "adminer-5.4.2.php";