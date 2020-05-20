<?php

$input = 'ckczppom';

$i = 1;
while(substr(md5($input . $i), 0, 5) !== '00000') {
    $i++;
}

$j = 1;
while(substr(md5($input . $j), 0, 6) !== '000000') {
    $j++;
}

echo <<<OUT
Part1: $i
Part2: $j

OUT;
