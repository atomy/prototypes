<?php
/**
 * Created by JetBrains PhpStorm.
 * User: atomy
 * Date: 07.05.13
 * Time: 23:50
 * To change this template use File | Settings | File Templates.
 */

class Api_Database
{
    private $_db;

    /**
     * @var Api_Database
     */
    protected static $_instance = null;

    protected function __construct()
    {
        $this->_db = new Api_Mysql('', '', '', '');
    }

    public static function get()
    {
        if (self::$_instance == null) {
            self::$_instance = new self();
        }

        return self::$_instance;
    }

    /**
     * @return Api_Mysql
     */
    public function getDb()
    {
        if (empty($this->_db)) {
            throw new Exception(__CLASS__ . '::' . __FUNCTION__ . '() empty db adapter!');
        }
        return $this->_db;
    }
}