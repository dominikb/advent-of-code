<?php

include 'IntcodeVM.php';

$memory = file_get_contents('input.txt');
//$memory = <<<EOF
//3,3,1107,-1,8,3,4,3,99
//EOF;

$vm = new IntcodeVM($memory);

$vm->run();

//print_r($vm->memory);
