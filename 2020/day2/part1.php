<?php

$input = ['example.txt', 'input.txt'];

foreach($input as $file) {
  $content = file_get_contents($file);
  $lines = array_map('parse', explode(PHP_EOL, $content));


  $valid = 0;
  foreach($lines as $line) {
    isValidPassword($line) ? $valid++ : $valid;
  }
  echo "Valid: ${valid}" . PHP_EOL;
}

function parse($line) {
  preg_match('/(\d+)-(\d+) (\w+): (.*)/', $line, $matches);

  return [
    'lower' => $matches[1],
    'upper' => $matches[2],
    'letter' => $matches[3],
    'password' => $matches[4],
  ];
}

function isValidPassword($entry) {
  $pattern = implode([
    '/^',
     '[^', $entry['letter'], ']*(',
      $entry['letter'],
      '[^', $entry['letter'], ']*){',
      $entry['lower'], ',', $entry['upper'], '}',
      '[^', $entry['letter'], ']*',
    '$/'
  ]);

  preg_match($pattern, $entry['password'], $matches);

  $valid = count($matches) > 1;

  echo implode(':', $entry) . " valid? " . ($valid ? "yes" : "no")  . " ${pattern}" . PHP_EOL;

  return $valid;
}