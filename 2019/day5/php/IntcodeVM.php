<?php

const ADD = 1;
const MULTIPLY = 2;
const INPUT = 3;
const OUTPUT = 4;
const JUMP_IF_TRUE = 5;
const JUMP_IF_FALSE = 6;
const LESS_THAN = 7;
const EQUALS = 8;
const HALT = 99;

const PARAMETER_MODE_ADRRESS = 0;
const PARAMETER_MODE_IMMEDIATE = 1;

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
            $opcode = ($this->memory[$this->ip]) % 100;
            switch ($opcode) {
                case ADD: $this->add();break;
                case MULTIPLY: $this->multiply();break;
                case INPUT: $this->input();break;
                case OUTPUT: $this->output();break;
                case JUMP_IF_TRUE: $this->jumpIfTrue();break;
                case JUMP_IF_FALSE: $this->jumpIfFalse();break;
                case LESS_THAN: $this->lessThan();break;
                case EQUALS: $this->equals();break;
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
    
    private function input() {
        $input = readline("Give me input: ");
        
        $this->put(1, (int) $input);
        $this->ip += 2;
    }
    
    private function output() {
        $value = $this->getArg(1);
        
        echo "OUT: $value" . PHP_EOL;
        $this->ip += 2;
    }
    
    private function jumpIfTrue() {
        if ($this->getArg(1) != 0) {
            $this->ip = $this->getArg(2);
        } else {
            $this->ip += 3;
        }
    }
    
    private function jumpIfFalse() {
        if ($this->getArg(1) == 0) {
            $this->ip = $this->getArg(2);
        } else {
            $this->ip += 3;
        }
    }
    
    private function lessThan() {
        if ($this->getArg(1) < $this->getArg(2)) {
            $this->put(3,1);
        } else {
            $this->put(3,0);
        }
        $this->ip += 4;
    }
    
    private function equals() {
        if ($this->getArg(1) == $this->getArg(2)) {
            $this->put(3,1);
        } else {
            $this->put(3,0);
        }
        $this->ip += 4;
    }

    public function result() {
        return $this->memory[0];
    }
    
    private function getArg($offset) {
        $mode = $this->parameterMode($offset);
        
        switch ($mode) {
            case PARAMETER_MODE_IMMEDIATE: 
                return $this->memory[$this->ip + $offset];
                
            case PARAMETER_MODE_ADRRESS:
            default:
                $address = $this->memory[$this->ip + $offset];
                return $this->getAt($address);
        }
    }
    
    private function parameterMode($offset) {
        $opcode = (string) $this->memory[$this->ip];
        $opcode = substr($opcode, 0, -2);
        $opcode = str_pad($opcode, 10, '0', STR_PAD_LEFT);
        
        $v = substr($opcode, strlen($opcode) - $offset, 1);
        
        return (int) $v;
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