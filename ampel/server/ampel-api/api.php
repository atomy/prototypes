<?php
error_reporting(-1);

$loader = require 'vendor/autoload.php';
$loader->add('Api', __DIR__ . '/src/');

//require_once 'src/Request.php';

/**
 * Created by JetBrains PhpStorm.
 * User: atomy
 * Date: 07.05.13
 * Time: 22:56
 * To change this template use File | Settings | File Templates.
 */

if (strlen($_REQUEST['request']) > 50) {
    die('EOF');
}

$args = explode('/', $_REQUEST['request']);
$revArgs = array_reverse($args);

$key = array_pop($revArgs);
$args = array_reverse($revArgs);

$req = new Api_Request($key, $args);
echo $req->get();