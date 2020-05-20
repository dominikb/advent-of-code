<?php

$input = '1113222113';

$r = $input;
foreach(range(1,40) as $iteration) {
    $out = "";
    $in = $r;

    for($i=0; $i<strlen($in); $i++) {
        $count = 1;
        $l = $in[$i];
        for($j=$i+1;$j<strlen($in);$j++) {
            if ($in[$i] !== $in[$j]) {
                $i = $j - 1;
                break;
            }
            $count++;
        }
        $out .= $count . $l;
    }

    $r = $out;
}

echo "Part1: " . strlen($r) . PHP_EOL;
$r = $input;
foreach(range(1,50) as $iteration) {
    $out = "";
    $in = $r;

    for($i=0; $i<strlen($in); $i++) {
        $count = 1;
        $l = $in[$i];
        for($j=$i+1;$j<strlen($in);$j++) {
            if ($in[$i] !== $in[$j]) {
                $i = $j - 1;
                break;
            }
            $count++;
        }
        $out .= $count . $l;
    }

    $r = $out;
}

echo "Part2: " . strlen($r) . PHP_EOL;