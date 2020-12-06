<?php

$input = [
  'example.txt', 
  'input.txt'
];

const ROWS = 127;

const COLUMNS = 7;

foreach($input as $file) {
  $content = file_get_contents($file);
  $lines = explode(PHP_EOL, $content);

  $ids = [];

  $max = -1;
  foreach($lines as $line) {
    $rowDeterminators = substr($line, 0, 7);
    $columnDeterminators = substr($line, -3);

    $row = toRow($rowDeterminators);
    $column = toColumn($columnDeterminators);
    $id = $row * 8 + $column;
    $ids[] = $id;

    $max = $id > $max ? $id : $max;
  }

  sort($ids);
  $min = $ids[0];

  for($i = 0; $i < count($ids); $i++) {
    if ($ids[$i] != $min + $i) {
      echo "$file: id: " . $min+$i . PHP_EOL;
      break;
    }
  }
}


function toRow($determinators) {
  return determineBounds($determinators, ROWS, "F");
}

function toColumn($determinators) {
  return determineBounds($determinators, COLUMNS, "L");
}

function determineBounds($determinators, $upper, $firstHalfSymbol)
{
  $lower = 0;

  for($i = 0; $i < strlen($determinators); $i++) {
    $diff = $upper - $lower + 1;
    if (substr($determinators, $i, 1) === $firstHalfSymbol) {
      $upper = $upper - (int) ($diff / 2);
    } else {
      $lower = $lower + (int) ($diff / 2);
    }
  }

  return substr($determinators, -1) === $firstHalfSymbol
    ? $upper : $lower;
}