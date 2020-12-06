<?php

$input = [
  'example.txt', 
  'input.txt'
];

$slopes = [
  ['Right 1, down 1', fn($p) => [$p[0] + 1, $p[1] + 1]],
  ['Right 3, down 1', fn($p) => [$p[0] + 3, $p[1] + 1]],
  ['Right 5, down 1', fn($p) => [$p[0] + 5, $p[1] + 1]],
  ['Right 7, down 1', fn($p) => [$p[0] + 7, $p[1] + 1]],
  ['Right 1, down 2', fn($p) => [$p[0] + 1, $p[1] + 2]],
];

foreach($input as $file) {
  $content = file_get_contents($file);
  $lines = explode(PHP_EOL, $content);
  $totalLines = count($lines);

  $treeMap = parseMap($lines);
  $slopeTreeHits = [];

  foreach($slopes as [$slope, $nextPosFn]) {
    $position = [0,0];
    $treesHit = 0;

    while(! isDone($lines, $position)) {
      [$column, $row] = toIndex($lines, $position);
  
      if ($treeMap[$row][$column])
        $treesHit++;
  
      $position = $nextPosFn($position);
    }

    $slopeTreeHits[] = [$slope, $treesHit];
  }

  $product = array_reduce($slopeTreeHits, function($carry,$entry) {
    [$slope, $hits] = $entry;

    return $carry * $hits;
  }, 1);

  echo "$file : trees hit $product" . PHP_EOL;
}

function isDone($lines, $position) {
  [$x, $y] = $position;

  return $y >= count($lines);
}

function nextPosition($position) {
  [$x, $y] = $position;

  return [$x + 3, $y + 1];
}

function toIndex($lines, $position) {
  $columnWidth = strlen($lines[0]);

  [$x, $y] = $position;

  $index = [$x % $columnWidth, $y];

  return $index;
}

function parseMap($lines) {
  $map = [];

  foreach($lines as $line) {
    $row = [];
    foreach(str_split($line) as $field) {
      $row[] = $field === '#';
    }
    $map[] = $row;
  }

  return $map;
}