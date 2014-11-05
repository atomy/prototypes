<?php

$ret = file_get_contents('http://selunes.de/api/ampel');

$val = intval($ret);

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
