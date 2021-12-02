<?php

$inputs = file_get_contents(__DIR__ . '/../input.txt');

$castToInt = fn($n) => (int) $n;
$containers = array_map($castToInt, explode(PHP_EOL, $inputs));
$containers = [20, 15, 10, 5, 5];

$target = 150;
$target = 25;

$sum = function($indizes) use ($containers) {
    return array_sum(array_map(function($i) use ($containers) {
        return $containers[$i];
    }, $indizes));
};
