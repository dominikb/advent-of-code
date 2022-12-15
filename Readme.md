# Advent of Code Solutions

## 2022

### Ruby

#### Day 7
Be careful when using mutable objects as hash keys. They might change out from under you!
````ruby
hash = {} # => {}
key = [1, 2] # => [1, 2]
hash[key] = 1 # => {[1, 2]=>1}
hash[[1, 2]] # => 1

key.pop
hash[[1, 2]] # => nil
hash # => {[1]=>1}
````

### Day 14
Ranges can be used for accessing multiple array elements except for when they use a negative starting value.
````ruby
arr = [1, 2, 3, 4, 5]
arr[1..2] # => [2, 3]
arr[-1..2] # => []
````