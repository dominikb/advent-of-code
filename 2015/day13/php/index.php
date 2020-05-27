
<?php

ini_set('memory_limit', '1024M');

$input = file_get_contents(__DIR__ . '/../input.txt');

$pairs = [];
$indexed = array_reduce(
    explode(PHP_EOL, $input),
    function ($acc, $line) {
        $parts = explode(' ', $line);
        $person = $parts[0];
        $neighbour = rtrim($parts[10], '.');
        $happiness = $parts[2] === 'gain'
            ? (int) $parts[3]
            : -1 * (int) $parts[3];

        $acc[$person] ??= [];
        $acc[$neighbour] ??= [];

        $acc[$person][$neighbour] = $happiness;

        return $acc;
    });

$uniques = array_unique(array_keys($indexed));

$best = [];
function permutations($array)
{
    $variants = [];

    $recurse = function ($result, $rest) use (&$recurse, &$variants) {
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

$calculateHapiness = function ($seatingOrder) use (&$indexed) {
    $happiness = 0;

    $seatingOrder = [...$seatingOrder, $seatingOrder[0]];
    for ($i = 0; $i < count($seatingOrder) - 1; $i++) {
        $a = $seatingOrder[$i];
        $b = $seatingOrder[$i + 1];
        if ( ! (isset($indexed[$a][$b])
        && isset($indexed[$b][$a]))) {
            return PHP_INT_MIN;
        }
        $happiness += $indexed[$b][$a];
        $happiness += $indexed[$a][$b];
    }

    return $happiness;
};

$happySeating = array_map(
    fn($order) => [$calculateHapiness($order), $order],
    permutations($uniques),
);

usort(
    $happySeating,
    fn($a, $b) => $a[0] < $b[0]
);

echo "Part1: " . $happySeating[0][0] . PHP_EOL;

$indexed['myself'] = array_map(
    fn() => 0,
    array_flip($uniques),
);
$uniques = [...$uniques, 'myself'];

$indexed = array_map(
    fn($entry) => array_merge($entry, ['myself' => 0]),
    $indexed,
);

$happySeating = array_map(
    fn($order) => [$calculateHapiness($order), $order],
    permutations($uniques),
);

usort(
    $happySeating,
    fn($a, $b) => $a[0] < $b[0]
);

echo "Part2: " . $happySeating[0][0] . PHP_EOL;
