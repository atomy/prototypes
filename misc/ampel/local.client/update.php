<?php

const ROT 		= 4;
const GELB 		= 2;
const GRUEN 	= 1;

function check()
{
	return ping("1.1.1.1", 80, 10);
}

function ping($host, $port, $timeout)
{
	$tB = microtime(true); 
  $fP = @fsockopen($host, $port, $errno, $errstr, $timeout); 
  if (!$fP) { return "-1"; } 
  $tA = microtime(true); 
  return round((($tA - $tB) * 1000), 0); 
}

if (!is_file('./lastState')) {
	file_put_contents('./lastState', ROT);	
}

while (1) {
	$ret = check();
	$lastState = file_get_contents('./lastState');
	$newState = getState($ret);

	if ($lastState == $newState) {
		echo 'state unchanged...' . PHP_EOL;
	  sleep(5);
		continue;
	}
	
	$val = intval($newState);
	file_put_contents('./lastState', $val);
	echo 'transmitting: ' . $newState . PHP_EOL;
	transmit($newState);
	
	sleep(5);
}

function transmit($val) {
	$on = array();

	if ($val & 1) {
	  $on[] = '/usr/bin/python ./tool_hub_ctrl.py -h 0 -P 4 -p 1';
	} else {
	  exec('/usr/bin/python ./tool_hub_ctrl.py -h 0 -P 4 -p 0');
	}
	
	if ($val & 2) {
		$on[] = '/usr/bin/python ./tool_hub_ctrl.py -h 0 -P 2 -p 1';
	} else {
  	exec('/usr/bin/python ./tool_hub_ctrl.py -h 0 -P 2 -p 0');
	}
	
	if ($val & 4) {
		$on[] = '/usr/bin/python ./tool_hub_ctrl.py -h 0 -P 3 -p 1';
	} else {
	  exec('/usr/bin/python ./tool_hub_ctrl.py -h 0 -P 3 -p 0');
	}

	foreach ($on as $c) {
		exec($c);
	}
}

function getState($state)
{
	if ($state <= 0 || $state >= 200) {
		return ROT;
	}

	if ($state < 60) {
		return GRUEN;
	}

	return GELB;
}
