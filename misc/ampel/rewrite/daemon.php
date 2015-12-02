<?php

define('TRAFFIC_NONE', 0);
define('TRAFFIC_GREEN', 1);
define('TRAFFIC_YELLOW', 2);
define('TRAFFIC_RED', 4);

/**
 * @param string $host
 * @return bool
 */
function checkInternetConnection($host = 'www.google.com')
{
    return (bool) @fsockopen($host, 80, $errno, $errStr, 20);
}

/**
 * @param $value
 * @throws Exception
 */
function setTraffic($value)
{
    $val = intval($value);

    if ($val & 1) {
        exec('/usr/bin/python ./tool_hub_ctrl.py -h 0 -P 4 -p 1');
    } else {
        exec('/usr/bin/python ./tool_hub_ctrl.py -h 0 -P 4 -p 0');
    }

    if ($val & 2) {
        exec('/usr/bin/python ./tool_hub_ctrl.py -h 0 -P 2 -p 1');
    } else {
        exec('/usr/bin/python ./tool_hub_ctrl.py -h 0 -P 2 -p 0');
    }

    if ($val & 4) {
        exec('/usr/bin/python ./tool_hub_ctrl.py -h 0 -P 3 -p 1');
    } else {
        exec('/usr/bin/python ./tool_hub_ctrl.py -h 0 -P 3 -p 0');
    }
}

/**
 * @param $state
 * @throws Exception
 */
function setState($state)
{
    switch ($state) {
        case 'NO_INTERNET':
            file_put_contents('current_state', $state);
            break;
        default:
            throw new \Exception(sprintf('Invalid arguments given for: \'%s\'', $state));
    }
}

$i = 0;
$lastConnectionCheck = 0;
$currentState = null;
$a = true;

while (true) {
    if ($lastConnectionCheck + 60 < time()) {
        echo 'checking internet connection...';

        if (!checkInternetConnection()) {
            setState('NO_INTERNET');
            echo 'OFFLINE :-(' . PHP_EOL;
        } else {
            echo 'ONLINE' . PHP_EOL;
        }

        $lastConnectionCheck = time();
    }

    if (file_exists('current_state')) {
        $currentState = file_get_contents('current_state');
    }

    if ($currentState == 'NO_INTERNET') {
        if ($a) {
            setTraffic(TRAFFIC_RED);
        } else {
            setTraffic(TRAFFIC_NONE);
        }

        $a =! $a;
    } else {
        // %TODO, do magic
    }

    //echo "setting: " . $i . PHP_EOL;
    //setTraffic(TRAFFIC_GREEN | TRAFFIC_YELLOW);

    //$i++;
    sleep(1);
}
