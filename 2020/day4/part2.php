<?php

$input = [
  'example2.txt', 
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

// byr (Birth Year) - four digits; at least 1920 and at most 2002.
  $byr = (int) $fields['byr'];
  if ($byr < 1920 || $byr > 2002)
    return false;

// iyr (Issue Year) - four digits; at least 2010 and at most 2020.
  $iyr = (int) $fields['iyr'];
  if ($iyr < 2010 || $iyr > 2020)
    return false;
  
// eyr (Expiration Year) - four digits; at least 2020 and at most 2030.
  $eyr = (int) $fields['eyr'];
  if ($eyr < 2020 || $eyr > 2030)
    return false;

// hgt (Height) - a number followed by either cm or in:
// If cm, the number must be at least 150 and at most 193.
// If in, the number must be at least 59 and at most 76.
  $unit = substr($fields['hgt'], -2);
  $val = (int) substr($fields['hgt'], 0, -2);

  if(! in_array($unit, ['in', 'cm']))
    return false;
  if ($unit == 'in' && ($val < 59 || $val > 76))
    return false;
  if ($unit == 'cm' && ($val < 150 || $val > 193))
    return false;

// hcl (Hair Color) - a # followed by exactly six characters 0-9 or a-f.
  preg_match('/^#[0-9a-f]{6}$/', $fields['hcl'], $matches);
  if (count($matches) != 1)
    return false;

// ecl (Eye Color) - exactly one of: amb blu brn gry grn hzl oth.
  if (! in_array($fields['ecl'], ['amb', 'blu', 'brn', 'gry', 'grn', 'hzl', 'oth']))
    return false;
  
// pid (Passport ID) - a nine-digit number, including leading zeroes.
  preg_match('/^[0-9]{9}$/', $fields['pid'], $matches);
  if (count($matches) != 1)
    return false;

  return true;
}