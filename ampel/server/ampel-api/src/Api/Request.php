<?php
/**
 * Created by JetBrains PhpStorm.
 * User: atomy
 * Date: 07.05.13
 * Time: 23:03
 * To change this template use File | Settings | File Templates.
 */

class Api_Request
{
    const KEY_UNAVAILABLE = 0;
    const DB_PROBLEM = 1;
    const INVALID_ARG = 2;

    const DB_KEY_STATUS = 1;

    private $_key;
    private $_method;
    private $_args;

    public function __construct($key, $args)
    {
        $this->_key = $key;
        $this->_method = $_SERVER['REQUEST_METHOD'];
        $this->_args = $args;
    }

    public function get()
    {
        if ($this->_key == 'ampel') {
            return $this->_process();
        }

        $this->_error(self::KEY_UNAVAILABLE);
    }

    private function _process()
    {
        if ($this->_method == 'GET') {
            $db = Api_Database::get()->getDb()->get();

            $id = self::DB_KEY_STATUS;
            /** @var $res mysqli_result */
            $query = $db->query(sprintf('SELECT * FROM `ampel` WHERE `id` = \'%d\'', $id));
            $res = $query->fetch_row();

            return $res[1];
        } else if ($this->_method == 'POST') {
            $db = Api_Database::get()->getDb()->get();

            $val = intval(current($this->_args));

            if (!self::isValid($val)) {
                $this->_error(self::INVALID_ARG);
            }

            $id = self::DB_KEY_STATUS;

            /** @var $res mysqli_result */
            $query = $db->query(sprintf('UPDATE `ampel` SET `value` = \'%d\' WHERE `id` = \'%d\'', $val, $id));

            if ($query == true) {
                die($val);
            } else {
                $this->_error(self::DB_PROBLEM);
            }

            return $res[1];
        }
    }

    private function _error($id)
    {
        if ($id == self::KEY_UNAVAILABLE) {
            header($_SERVER['SERVER_PROTOCOL'] . ' 404 Not Found', true, 404);
            die('404 Not Found');
        } else if ($id == self::DB_PROBLEM) {
            header($_SERVER['SERVER_PROTOCOL'] . ' 500 Internal Server Error', true, 500);
            die('500 Internal Server Error');
        } else if ($id == self::INVALID_ARG) {
            header($_SERVER['SERVER_PROTOCOL'] . ' 400 Bad Request', true, 400);
            die('400 Bad Request');
        } else {
            header($_SERVER['SERVER_PROTOCOL'] . ' 503 Service Unavailable', true, 503);
            die('503 Service Unavailable');
        }
    }

    public static function isValid($val)
    {
        $max = 1 << 3; // 3 bits

        if ($val >= $max || $val < 0) {
            return false;
        } else {
            return true;
        }
    }
}