<?php

$input = file_get_contents(__DIR__ . '/../input.txt');

ini_set('memory_limit', '1024M');

class Ingredient
{
    protected int $capacity;
    protected int $durability;
    protected int $flavor;
    protected int $texture;
    protected int $calories;
    protected string $name;
    protected int $amount = 0;

    /**
     * @return int
     */
    public function getAmount(): int
    {
        return $this->amount;
    }

    /**
     * @param int $amount
     *
     * @return Ingredient
     */
    public function setAmount(int $amount): Ingredient
    {
        $this->amount = $amount;

        return $this;
    }

    public function __construct(
        string $name,
        int $capacity,
        int $durability,
        int $flavor,
        int $texture,
        int $calories
    ) {
        $this->capacity = $capacity;
        $this->durability = $durability;
        $this->flavor = $flavor;
        $this->texture = $texture;
        $this->calories = $calories;
        $this->name = $name;
    }

    /**
     * @return int
     */
    public function getCapacity(): int
    {
        return $this->capacity;
    }

    /**
     * @return int
     */
    public function getDurability(): int
    {
        return $this->durability;
    }

    /**
     * @return int
     */
    public function getFlavor(): int
    {
        return $this->flavor;
    }

    /**
     * @return int
     */
    public function getTexture(): int
    {
        return $this->texture;
    }

    /**
     * @return int
     */
    public function getCalories(): int
    {
        return $this->calories;
    }

    /**
     * @return string
     */
    public function getName(): string
    {
        return $this->name;
    }
}

$ingredients = [];
foreach(explode(PHP_EOL, $input) as $line) {
    $parts = array_map(
        fn($e) => rtrim($e, ',:'),
        explode(' ', $line)
    );

    $ingredients[$parts[0]] = new Ingredient(
        $parts[0],
        (int) $parts[2],
        (int) $parts[4],
        (int) $parts[6],
        (int) $parts[8],
        (int) $parts[10]
    );
}

$possibilities = [];
$f = function($limit, $rest, &$setting, &$possibilities) use (&$f) {
    if ($limit === 0) {
        array_push($possibilities, $setting);
        return $possibilities;
    }
    
    $cur = array_shift($rest);
    
    for($i=$limit;$i>=0;$i--) {
        $setting[$cur] = $i;
        $possibilities = $f($limit - $i, $rest, $setting, $possibilities);
    }
    
    return $possibilities;
};

function p($limit, $items, &$options, $setting = []) {
    if (sizeof($items) === 1) {
        [$cur] = array_slice($items, 0, 1);
        $setting[$cur] = $limit;
        array_push($options, $setting);
    } else {
        for($i = $limit; $i >= 0; $i--) {
            [$cur] = array_slice($items, 0, 1);
            $setting[$cur] = $i;
            p($limit - $i, array_values(array_slice($items, 1)), $options, $setting);
        }
    }
    
    return $options;
}

$names = array_keys($ingredients);

$categories = ['capacity', 'durability', 'flavor', 'texture'];

$options = [];
$scores = [];
foreach(p(100, $names, $options) as $option) {
    $categorySums = [];
    foreach($categories as $category) {
        $method = 'get' . ucfirst($category);
        $categorySums[$category] = 0;
        foreach($option as $key => $val) {
            $n = $ingredients[$key]->{$method}();
            $categorySums[$category] += $val * $n;
        }
        if ($categorySums[$category] < 0) {
            $categorySums[$category] = 0;
        }
    }
    
    $scores[] = array_reduce(
        $categorySums,
        fn($x, $y) => $x * $y,
        1
    );
}

echo "Part1: " . max($scores) . PHP_EOL;


$options = [];
$scores = [];
foreach(p(100, $names, $options) as $option) {
    $categorySums = [];
    $calories = 0;
    foreach($option as $key => $amount) {
        $calories += $amount * $ingredients[$key]->getCalories();
    }
    if ($calories !== 500) continue;
    foreach($categories as $category) {
        $method = 'get' . ucfirst($category);
        $categorySums[$category] = 0;
        foreach($option as $key => $val) {
            $n = $ingredients[$key]->{$method}();
            $categorySums[$category] += $val * $n;
        }
        if ($categorySums[$category] < 0) {
            $categorySums[$category] = 0;
        }
    }

    $scores[] = array_reduce(
        $categorySums,
        fn($x, $y) => $x * $y,
        1
    );
}

echo "Part2: " . max($scores) . PHP_EOL;
