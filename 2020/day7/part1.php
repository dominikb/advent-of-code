<?php

//$input = 'example.txt';
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

function canContainShinyGoldBag($containers, $color) {
  if (count($containers[$color]) == 0) return false;

  if (isset($containers[$color]['shiny gold'])) return true;

  foreach(array_keys($containers[$color]) as $childColor) {
    if (canContainShinyGoldBag($containers, $childColor))
      return true;
  }

  return false;
}

$possibleOuterMostBags = [];
foreach($containers as $color => $children) {
  if (canContainShinyGoldBag($containers, $color))
    $possibleOuterMostBags[] = $color;
}

echo count($possibleOuterMostBags) . PHP_EOL;
