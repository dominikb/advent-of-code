<?php

$sentences = explode(PHP_EOL, file_get_contents(__DIR__ . '/../input.txt'));

$niceCounter = sizeof(array_filter($sentences, function($s) {
    return preg_match('/[aeiou].*[aeiou].*[aeiou]/', $s)
        && preg_match('/(.)\1/', $s)
        && ! preg_match('(ab|cd|pq|xy)', $s);
}));

$niceCounter2 = sizeof(array_filter($sentences, function($s) {
    return preg_match('/(..).*\1/', $s) 
        && preg_match('/(.).\1/', $s);
}));

echo <<<OUT
Part1: $niceCounter
Part2: $niceCounter2

OUT;