<?php

$contents = file_get_contents('../input.txt');

$lines = explode(PHP_EOL, $contents);
$packages = array_map(fn($line) => explode('x', $line), $lines);

$total = 0;
$ribbon = 0;
foreach ($packages as $sides) {
    $sides = array_map(fn($i) => (int) $i, $sides);
    [$l, $w, $h] = $sides;
    $areas = [
        2 * $l * $w,
        2 * $w * $h,
        2 * $h * $l,
    ];
    $slack = min($areas) / 2;
    $total += (array_sum($areas) + $slack);
    
    sort($sides);
    [$a, $b] = array_slice($sides,0,2);
    
    $ribbon += ($l * $w * $h + 2 * $a + 2 * $b);
}

echo <<<OUT
Part 1: $total
Part 2: $ribbon

OUT;