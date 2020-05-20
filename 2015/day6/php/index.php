<?php

$commands = explode(PHP_EOL, file_get_contents(__DIR__ . '/../input.txt'));

$grid = [];
foreach(range(0,999) as $i) {
    $grid[$i] = array_map(fn($_x) => false, range(0, 999));
}

foreach($commands as $command) {
    if ('turn off' === substr($command, 0, 8)) {
        $apply = fn($x) => false;
        $parts = explode(' ', $command);
        $range = [
            explode(',', $parts[2]),
            explode(',', $parts[4]),
        ];
    }
    else if ('turn on' === substr($command, 0, 7)) {
        $apply = fn($x) => true;
        $parts = explode(' ', $command);
        $range = [
            explode(',', $parts[2]),
            explode(',', $parts[4]),
        ];
    }
    else {
        $parts = explode(' ', $command);
        $range = [
            explode(',', $parts[1]),
            explode(',', $parts[3]),
        ];
        
        $apply = fn ($x) => !$x;
    }
    
    [[$x1, $y1],[$x2, $y2]] = $range;
    foreach(range($x1,$x2) as $x) {
        foreach(range($y1,$y2) as $y) {
            $grid[$x][$y] = $apply($grid[$x][$y]);
        }
    }
}

$lightsLit = array_sum(
    array_map(function($g) {
        return array_reduce($g, fn($acc, $cur) => $cur ? $acc + 1 : $acc, 0);
    }, $grid)
);

// ----------- PART 2

$grid = [];
foreach(range(0,999) as $i) {
    $grid[$i] = array_map(fn($_x) => 0, range(0, 999));
}

foreach($commands as $command) {
    if ('turn off' === substr($command, 0, 8)) {
        $apply = fn($x) => $x > 0 ? $x-1 : $x;
        $parts = explode(' ', $command);
        $range = [
            explode(',', $parts[2]),
            explode(',', $parts[4]),
        ];
    }
    else if ('turn on' === substr($command, 0, 7)) {
        $apply = fn($x) => $x+1;
        $parts = explode(' ', $command);
        $range = [
            explode(',', $parts[2]),
            explode(',', $parts[4]),
        ];
    }
    else {
        $parts = explode(' ', $command);
        $range = [
            explode(',', $parts[1]),
            explode(',', $parts[3]),
        ];

        $apply = fn ($x) => $x+2;
    }

    [[$x1, $y1],[$x2, $y2]] = $range;
    foreach(range($x1,$x2) as $x) {
        foreach(range($y1,$y2) as $y) {
            $grid[$x][$y] = $apply($grid[$x][$y]);
        }
    }
}

$lightsLit2 = array_sum(array_map(fn($g) => array_sum($g), $grid));

echo <<<OUT
Part1: $lightsLit
Part2: $lightsLit2

OUT;
