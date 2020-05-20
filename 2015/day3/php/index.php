<?php

$orders = str_split(file_get_contents(__DIR__ . '/../input.txt'), 1);
$houses = ["00" => true];

$x = 0;
$y = 0;

foreach($orders as $order) {
    switch ($order) {
        case '^': $y++;break;
        case 'v': $y--;break;
        case '>': $x++;break;
        case '<': $x--;break;
    }
    $houses["$x$y"] = true;
}

$count = sizeof(array_keys($houses));

$x = 0;
$y = 0;
$x2 = 0;
$y2 = 0;
$roboSanta = false;
$houses = ["00" => true];

foreach($orders as $order) {
    if (! $roboSanta) {
        switch ($order) {
            case '^': $y++;break;
            case 'v': $y--;break;
            case '>': $x++;break;
            case '<': $x--;break;
        }
        $houses["$x$y"] = true;
    } else {
        switch ($order) {
            case '^': $y2++;break;
            case 'v': $y2--;break;
            case '>': $x2++;break;
            case '<': $x2--;break;
        }
        $houses["$x2$y2"] = true;
    }
    $roboSanta = ! $roboSanta;
}

$part2Houses = sizeof(array_keys($houses));

echo <<<OUT
Part1: $count
Part2: $part2Houses

OUT;
