<?php

require_once 'IntcodeVM.php';

$memory = file_get_contents('input.txt');

$part1 = function() use ($memory) {
    $vm = new IntcodeVM($memory);
    $vm->pushInput(1);

    while(!$vm->isHalted()) {
        $vm->runUntilOutput();
        print_r($vm->getOutput().PHP_EOL);
    }
};

$part2 = function() use ($memory) {
    $vm = new IntcodeVM($memory);
    $vm->pushInput(2);

    while(!$vm->isHalted()) {
        $vm->runUntilOutput();
        print_r($vm->getOutput().PHP_EOL);
    }
};

echo "PART 1: \n";
$part1();

echo "PART 2: \n";
$part2();