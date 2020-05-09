<?php

$file = fopen('../input.txt', 'r');

class FuelCalculator {
    public static function calculateFuel($mass) {
        $mass = (int) $mass;
        
        $fuel = intval($mass / 3) - 2;
        if ($fuel > 0) {
            $fuel += FuelCalculator::calculateFuel($fuel);
        }
        return $fuel > 0 ? $fuel : 0;
    }
}

$sum = 0;
while (($line = fgets($file)) != null) {
    $sum += FuelCalculator::calculateFuel($line);
}

echo $sum;
