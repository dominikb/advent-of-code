<?php

include 'IntcodeVM.php';

$initialMemory = @file_get_contents('../input.txt');


for ($noun = 0; $noun < 100; $noun++) {
    for ($verb = 0; $verb < 100; $verb++) {
        $vm = new IntcodeVM($initialMemory);
        $vm->putAt(1, $noun);
        $vm->putAt(2, $verb);
        $vm->run();
        if ($vm->result() == 19690720) {
            $result = 100*$noun + $verb;
            echo "Noun: $noun";
            echo "Verb: $verb";
            echo "Result: $result";
            exit(0);
        }
    }
}
