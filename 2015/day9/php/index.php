<?php

$input = file_get_contents(__DIR__ . '/../input.txt');

$lines = explode(PHP_EOL, $input);

$locations = [];
$distances = [];

foreach($lines as $line) {
    [$origin, $_to, $dest, $eq, $distance] = explode(' ', $line);
    $locations = [...$locations, $dest, $origin];
    $distances["$origin$dest"] = (int) $distance;
    $distances["$dest$origin"] = (int) $distance;
}
$locations = array_unique($locations);

function permutations($array) {
    $variants = [];

    $recurse = function($result, $rest) use (&$recurse, &$variants) {
        if (count($rest) > 0) {
            foreach ($rest as $item) {
                $variants[] = $recurse([...$result, $item], array_diff($rest, [$item]));
            }
        }
        return $result;
    };

    $recurse([], $array);

    return array_filter($variants, fn($e) => sizeof($e) === sizeof($array));
}

$a = [];
foreach(permutations($locations) as $option) {
    $distance = 0;

    for($i=0; $i < count($option) - 1; $i++) {
        [$from, $to] = array_slice($option, $i, 2);
        $distance = $distance + (int) $distances["$from$to"];
    }
    
    $a[implode(' -> ', $option)] = $distance;
}

echo "Part1: " . min($a) . PHP_EOL;
echo "Part2: " . max($a) . PHP_EOL;
