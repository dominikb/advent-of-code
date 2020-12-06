<?php

$input = [
  'example.txt', 
  'input.txt'
];

foreach($input as $file) {
  $content = file_get_contents($file);
  $groups = explode(PHP_EOL.PHP_EOL, $content);

  $sum = 0;
  foreach($groups as $group) {
    $uniq = array_unique(str_split($group));

    $sum += count($uniq);
    if (in_array(PHP_EOL, $uniq))
      $sum--;
  }

  echo "$file: Sum of counts: $sum" . PHP_EOL;
}