<?php

define('TRAFFIC_NONE', 0);
define('TRAFFIC_GREEN', 1);
define('TRAFFIC_YELLOW', 2);
define('TRAFFIC_RED', 4);

define('ROOT_DIR', realpath(dirname(__FILE__)) . '/');
define('PYTHON_INTERPRETER', '/usr/bin/python');

if (file_exists(ROOT_DIR . 'daemon.pid')) {
    $pid = (int) file_get_contents(ROOT_DIR . 'daemon.pid');
    $ret = posix_kill($pid, 0);

    if ($ret) {
        die('already running!' . PHP_EOL);
    } else {
        unlink(ROOT_DIR . 'daemon.pid');
    }
}

file_put_contents(ROOT_DIR . 'daemon.pid', posix_getpid());

declare(ticks = 1);

function sig_handler($sig) {
    echo 'receiving sig: ' . $sig . PHP_EOL;

    switch($sig) {
        case SIGINT:
        case SIGTERM:
            echo 'suiciding...';
            unlink(ROOT_DIR . 'daemon.pid');
            setTraffic(TRAFFIC_NONE);
            die('DONE' . PHP_EOL);
            break;
    }
}

pcntl_signal(SIGINT,  "sig_handler");
pcntl_signal(SIGTERM, "sig_handler");
pcntl_signal(SIGHUP,  "sig_handler");

/**
 * @param string $host
 * @return bool
 */
function checkInternetConnection($host = 'www.google.com')
{
    return (bool) @fsockopen($host, 80, $errNo, $errStr, 20);
}

function checkVpnConnection()
{
    exec("/bin/ping -W 2 -n -c 3 10.0.4.1", $outcome, $status);

    if (0 == $status) {
        return true;
    } else {
        return false;
    }
}

/**
 * @param $value
 * @throws Exception
 */
function setTraffic($value)
{
    $val = intval($value);
    $pyScript = PYTHON_INTERPRETER . ' ' . ROOT_DIR . 'tool_hub_ctrl.py';

    if (!file_exists(PYTHON_INTERPRETER)) {
        die('python interpreter doesnt exists at: ' . PYTHON_INTERPRETER . PHP_EOL);
    }

    if (!file_exists(ROOT_DIR . 'tool_hub_ctrl.py')) {
        die('pyscript doesnt exists at: ' . $pyScript . PHP_EOL);
    }

    if ($val & 1) {
        exec($pyScript . ' -h 0 -P 4 -p 1');
    } else {
        exec($pyScript . ' -h 0 -P 4 -p 0');
    }

    if ($val & 2) {
        exec($pyScript . ' -h 0 -P 2 -p 1');
    } else {
        exec($pyScript . ' -h 0 -P 2 -p 0');
    }

    if ($val & 4) {
        exec($pyScript . ' -h 0 -P 3 -p 1');
    } else {
        exec($pyScript . ' -h 0 -P 3 -p 0');
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
        case 'IDLE':
        case 'NO_VPN':
            file_put_contents(ROOT_DIR . 'current_state', $state);
            break;
        default:
            throw new \Exception(sprintf('Invalid arguments given for: \'%s\'', $state));
    }
}

$i = 0;
$lastConnectionCheck = $lastVpnCheck = 0;
$currentState = null;
$a = true;
$firstRun = true;

while (true) {
    if ($firstRun) {
        setTraffic(TRAFFIC_NONE);
        $firstRun = false;
    }

    if ($lastConnectionCheck + 60 < time()) {
        echo 'checking internet connection...';

        if (!checkInternetConnection()) {
            setState('NO_INTERNET');
            echo 'OFFLINE :-(' . PHP_EOL;
        } else {
            setState('NO_VPN');
            echo 'ONLINE' . PHP_EOL;
        }

        $lastConnectionCheck = time();
    }

    if ($lastVpnCheck + 60 < time() && $currentState == 'NO_VPN') {
        echo 'checking vpn connection...';

        if (!checkVpnConnection()) {
            setState('NO_VPN');
            echo 'NO VPN ESTABLISHED :-(' . PHP_EOL;
        } else {
            setState('IDLE');
            echo 'VPN ESTABLISHED' . PHP_EOL;
        }

        $lastVpnCheck = time();
    }

    if (file_exists(ROOT_DIR . 'current_state')) {
        $currentState = file_get_contents(ROOT_DIR . 'current_state');
    }

    if ($currentState == 'NO_INTERNET') {
        if ($a) {
            setTraffic(TRAFFIC_RED);
        } else {
            setTraffic(TRAFFIC_NONE);
        }

        $a = !$a;
    } else if ($currentState == 'NO_VPN') {
        if ($a) {
            setTraffic(TRAFFIC_YELLOW);
        } else {
            setTraffic(TRAFFIC_NONE);
        }

        $a =! $a;
    } else if ($currentState == 'IDLE') {
        if ($a) {
            setTraffic(TRAFFIC_GREEN);
        } else {
            setTraffic(TRAFFIC_NONE);
        }

        $a =! $a;
    }

    sleep(1);
}
