<?php

const ADD = 1;
const MULTIPLY = 2;
const HALT = 99;

class IntcodeVM
{

    /** @var int[] */
    public $memory;

    private $ip = 0;

    public function __construct(string $memory)
    {
        $memory = str_replace('\n','', $memory);
        $this->memory = array_map(function($i) {
            return intval($i);
        }, explode(',',$memory));
    }

    public function run() {
        while(true) {
            switch ($this->memory[$this->ip]) {
                case ADD: $this->add();break;
                case MULTIPLY: $this->multiply();break;
                case HALT: return;
                default: echo "error"; exit(1);
            }
        }
    }

    private function add() {
        $a = $this->getArg(1);
        $b = $this->getArg(2);

        $this->put(3, $a + $b);
        $this->ip += 4;
    }

    private function multiply() {
        $a = $this->getArg(1);
        $b = $this->getArg(2);

        $this->put(3, $a * $b);
        $this->ip += 4;
    }

    public function result() {
        return $this->memory[0];
    }
    
    private function getArg($offset) {
        $address = $this->memory[$this->ip + $offset];
        return $this->getAt($address);
    }
    
    private function put($offset, $value) {
        $address = $this->memory[$this->ip + $offset];
        $this->putAt($address, $value);
    }
    
    public function putAt($address, $value) {
        $this->memory[$address] = $value;
    }
    
    public function getAt($address) {
        return $this->memory[$address];
    }
}