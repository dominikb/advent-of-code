<?php

function hasIncreasingStraightOfThree($password)
{
    for ($i = 0; $i < strlen($password) - 2; $i++) {
        if ($password[$i + 1] === chr(ord($password[$i]) + 1)
            && $password[$i + 2] === chr(ord($password[$i]) + 2)
        ) {
            return true;
        }
    }

    return false;
}

function doesNotContainInvalidLetters($password)
{
    foreach (str_split('iol') as $invalidLetter) {
        if (strpos($password, $invalidLetter) !== false) {
            return false;
        }
    }

    return true;
}

function containsTwoNonOverlappingPairs($password)
{
    $firstAlreadyFound = false;
    for ($i = 0; $i < strlen($password) - 1; $i++) {
        if ($password[$i] == $password[$i + 1]) {
            if ($firstAlreadyFound) {
                return true;
            } else {
                $firstAlreadyFound = true;
                $i = $i + 1;
            }
        }
    }

    return false;
}

function nextPassword($password)
{
    $letters = array_map('ord', str_split($password));
    $index = count($letters) - 1;
    $last = count($letters) - 1;

    do {
        $letters[$last]++;
        
        if($letters[$last] > ord('z')) {
            $letters[$last] = ord('a');

            $index = $last - 1;
            $next = true;
            while($next && $index > 0) {
                $next = false;
                $letters[$index]++;
                
                if($letters[$index] > ord('z')) {
                    $letters[$index] = ord('a');
                    $next = true;
                    $index--;
                }
            }
        }

        $newPassword = implode('', array_map('chr', $letters));
    } while (! (doesNotContainInvalidLetters($newPassword)
        && hasIncreasingStraightOfThree($newPassword)
        && containsTwoNonOverlappingPairs($newPassword)));

    return $newPassword;
}

$p1 = nextPassword('vzbxkghb');
$p2 = nextPassword($p1);

echo "Part1: $p1 \n";
echo "Part2: $p2 \n";
