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
    $answers = [];
    foreach(explode(PHP_EOL, $group) as $person) {
      foreach(str_split($person) as $answer) {
        if (isset($answers[$answer]))
          $answers[$answer]++;
        else
          $answers[$answer] = 1;
      }
    }

    $everyone = [];
    $peopleInGroup = count(explode(PHP_EOL, $group));
    foreach(array_keys($answers) as $answer) {
      if ($answers[$answer] === $peopleInGroup)
        $everyone[] = $answer;
    }

    $sum += count($everyone);
  }

  echo "$file: Sum of counts: $sum" . PHP_EOL;
}