<?php

$input = [
  'example.txt', 
  'input.txt'
];

const EXPECTED_FIELDS = [
  'byr', 'iyr', 'eyr', 'hgt', 'hcl', 'ecl', 'pid', 'cid',
];
const FIELDS_WITHOUT_CID = [
  'byr', 'iyr', 'eyr', 'hgt', 'hcl', 'ecl', 'pid',
];

const EMPTY_LINE = '';

foreach($input as $file) {
  $content = file_get_contents($file);
  $passports = explode(PHP_EOL.PHP_EOL, $content);

  $validCount = 0;
  foreach($passports as $passport) {
    $passportFields = parseFields($passport);
    if (isValid($passportFields))
      $validCount++;
  }

  echo "$file - valid: $validCount" . PHP_EOL;
}

function parseFields($passport) {
  preg_match_all('/([^\s]+)+/', $passport, $matches);

  return array_reduce($matches[0], function($agg, $entry) {
    [$field, $val] = explode(':', $entry);

    $agg[$field] = $val;

    return $agg;
  }, []);
}

function isValid($fields) {
  $diff = array_diff(
    FIELDS_WITHOUT_CID,
    array_keys($fields)
  );

  unset($diff['cid']);

  if (count($diff) > 0)
    return false;

  return true;
}