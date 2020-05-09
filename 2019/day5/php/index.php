<?php

include 'IntcodeVM.php';

$memory = file_get_contents('../input.txt');

$vm = new IntcodeVM($memory);

$vm->run();
