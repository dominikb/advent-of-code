<?php

include 'IntcodeVM.php';

function permutations($range) {
    [$lower, $upper] = $range;
    
    for($a = $lower; $a <= $upper; $a++)
        for($b = $lower; $b <= $upper; $b++) {
            if (in_array($b, [$a])) continue;
            for($c = $lower; $c <= $upper; $c++) {
                if (in_array($c, [$a, $b])) continue;
                for($d = $lower; $d <= $upper; $d++) {
                    if (in_array($d, [$a, $b, $c])) continue;
                    for($e = $lower; $e <= $upper; $e++) {
                        if (in_array($e, [$a, $b, $c, $d])) continue;
                        yield [$a, $b, $c, $d, $e];
                    }
                }
            }
        }
};

$initialMemory = file_get_contents('input.txt');

$max = 0;
$maxPhaseSetting = [];

$permutations = permutations([5,9]);
foreach($permutations as $phaseSetting) {
    /** @var IntcodeVM[] $vms */
    $vms = [
        new IntcodeVM($initialMemory, 'A'),
        new IntcodeVM($initialMemory, 'B'),
        new IntcodeVM($initialMemory, 'C'),
        new IntcodeVM($initialMemory, 'D'),
        new IntcodeVM($initialMemory, 'E'),
    ];
    for($i=0;$i<5;$i++){
        $vms[$i]->pushInput($phaseSetting[$i]);
    }
    
    $signal = 0;
    $vmIndex = 0;
    while(true) {
        $vm = $vms[$vmIndex];
        $vmIndex = ($vmIndex + 1) % 5;
        
        $vm->pushInput($signal);
        $vm->runUntilOutput();
        
        if ($vm->isHalted() && $vmIndex == 4) {
            break;
        }
        
        $signal = $vm->getOutput();
        if($signal > $max) {
            $max = $signal;
            $maxPhaseSetting = $phaseSetting;
        }
    }

}
print_r($maxPhaseSetting);
print_r($max);