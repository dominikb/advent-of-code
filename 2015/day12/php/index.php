<?php

$input = file_get_contents(__DIR__ . '/../input.json');

$matches = [];
preg_match_all('(-?\d+)', $input, $matches);

$parsed = json_decode($input);

echo "Part1: " . array_sum($matches[0]) . PHP_EOL;
exit;
function hasNumericIndices($array) {
    return 0 < count(array_filter(array_keys($array), fn($key) => is_numeric($key)));
}

function hasValueRed($array) {
    return in_array('red', array_values($array));
}

function sumUp($input, $withoutReds) {
    $sum = 0;
    
    if ($withoutReds && !hasNumericIndices($input) && hasValueRed($input)) {
        return 0;
    }
    
    foreach($input as $key => $entry) {
        print_r(json_encode([$key => $entry]));
        echo PHP_EOL;
        if (is_array($entry)) {
            $sum += sumUp($entry, $withoutReds);
        }
        if (is_numeric($entry)) {
            $sum += (int) $entry;
        }
        if (! is_string($key)) {
            $sum += (int) $key;
        }
    }
    
    return $sum;
}

echo "Part1: " . sumUp(json_decode($input, true), false) .PHP_EOL;