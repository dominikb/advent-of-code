<?php

$input = file_get_contents(__DIR__ . '/../input.txt');

class Reindeer
{
    protected string $name;
    protected int $speed;
    protected int $movementDuration;
    protected int $restingDuration;
    /* Negative means resting, positive means moving. */
    protected int $state;
    protected int $coveredDistance = 0;
    protected int $points = 0;

    public function __construct(
        string $name,
        int $speed,
        int $movementDuration,
        int $restingDuration
    ) {
        $this->name = $name;
        $this->speed = $speed;
        $this->movementDuration = $movementDuration;
        $this->state = $movementDuration; // Start moving
        $this->restingDuration = $restingDuration;
    }

    public function tick(): void
    {
        if ($this->isMoving()) {
            $this->state--;
            $this->coveredDistance += $this->speed;
            if ($this->state === 0) {
                $this->state = -1 * $this->restingDuration;
            }
        } else {
            $this->state++;
            if ($this->state === 0) {
                $this->state = $this->movementDuration;
            }
        }
    }

    public function isMoving(): bool
    {
        return $this->state > 0;
    }

    public function getCoveredDistance(): int
    {
        return $this->coveredDistance;
    }

    public function getPoints(): int
    {
        return $this->points;
    }

    public function awardPoint(): void
    {
        $this->points += 1;
    }
}

$parseReindeers = function($input) {
    return array_map(
        function ($line) {
            $parts = explode(' ', $line);

            return new Reindeer(
                $parts[0],
                (int) $parts[3],
                (int) $parts[6],
                (int) $parts[13]
            );
        },
        explode(PHP_EOL, $input),
    );
};

$reindeers = $parseReindeers($input);

$tickAll = function () use (&$reindeers) {
    foreach ($reindeers as $r) {
        $r->tick();
    }
};

foreach (range(1, 2503) as $i) {
    $tickAll();
}

usort(
    $reindeers,
    fn($a, $b) => $a->getCoveredDistance() < $b->getCoveredDistance()
);

echo "Part1: " . $reindeers[0]->getCoveredDistance() . PHP_EOL;

$reindeers = $parseReindeers($input);

foreach(range(1, 2503) as $i) {
    foreach($reindeers as $r) $r->tick();

    $max = max(array_map(
        fn($r) => $r->getCoveredDistance(),
        $reindeers
    ));
    
    foreach ($reindeers as $r) {
        if ($r->getCoveredDistance() === $max) {
            $r->awardPoint();
        }
    }
}

usort(
    $reindeers,
    fn($a, $b) => $a->getPoints() < $b->getPoints()
);

echo "Part2: " . $reindeers[0]->getPoints() . PHP_EOL;