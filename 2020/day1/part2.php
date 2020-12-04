<?php

$input = ['example.txt', 'input.txt'];

foreach($input as $file) {
  $content = file_get_contents($file);
  $lines = array_map(fn($x) => (int) $x, explode(PHP_EOL, $content));

  for($i = 0; $i < count($lines); $i++) {
    for($j = $i + 1; $j < count($lines); $j++) {
      for($k = $j + 1; $k < count($lines); $k++) {
        if ($lines[$i] + $lines[$j] + $lines[$k]  === 2020) {
          echo "File: $file --> " . $lines[$i] * $lines[$j] * $lines[$k]. PHP_EOL;
        }
      }
    }
  }
}

