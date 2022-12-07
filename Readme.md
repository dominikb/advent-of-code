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