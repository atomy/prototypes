<?php
/**
 * Created by JetBrains PhpStorm.
 * User: atomy
 * Date: 07.05.13
 * Time: 23:53
 * To change this template use File | Settings | File Templates.
 */
class Api_Mysql
{
    /**
     * @var mysqli
     */
    private $_link;

    public function __construct($host, $user, $pass, $database)
    {
        $this->_link = mysqli_connect($host, $user, $pass, $database);
    }

    public function get()
    {
        return $this->_link;
    }
}