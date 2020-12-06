<?php

$input = [
  'example.txt', 
  'input.txt'
];

foreach($input as $file) {
  $content = file_get_contents($file);
  $lines = explode(PHP_EOL, $content);
  $totalLines = count($lines);

  $treeMap = parseMap($lines);
  $position = [0,0];
  $treesHit = 0;

  while(! isDone($lines, $position)) {
    [$column, $row] = toIndex($lines, $position);

    if ($treeMap[$row][$column])
      $treesHit++;

    $position = nextPosition($position);
  }
  echo "Trees hit: ${treesHit}" . PHP_EOL;
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