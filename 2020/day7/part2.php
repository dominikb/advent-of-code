<?php

$input = 'example.txt';
$input = 'example2.txt';
$input = 'input.txt';


$containers = [];
foreach(explode(PHP_EOL, file_get_contents($input)) as $line)
{
  $parts = explode(' ', $line);

  $color = implode(' ', array_slice($parts,0, 2));
  $containers[$color] = [];

  $containedBags = array_map('trim', explode(',', implode(' ', array_slice($parts, 4))));

  if ($containedBags[0] == "no other bags.") continue;

  foreach($containedBags as $bag) {
    $count = (int) explode(' ', $bag)[0];
    $containedColor = implode(' ', array_slice(explode(' ', $bag), 1, 2));
    $containers[$color][$containedColor] = $count;
  }

}

function countContainingBags($containers, $color) {
  if (count($containers[$color]) == 0) return 0;

  return array_reduce(
    array_keys($containers[$color]),
    function($sum, $innerColor) use ($containers, $color) {
      return $sum
        + $containers[$color][$innerColor]
        + $containers[$color][$innerColor]
        * countContainingBags($containers, $innerColor);
    },
    0
  );
}

echo countContainingBags($containers, 'shiny gold') . PHP_EOL;
