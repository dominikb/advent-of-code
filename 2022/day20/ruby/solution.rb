require_relative '../../../utils/ruby/Aoc'

input = Aoc.get_input(year: 2022, day: 20)
example = <<~EXAMPLE
  1
  2
  -3
  3
  -2
  0
  4
EXAMPLE
example = example.split("\n").map(&:strip)

class Item
  include Comparable
  attr_accessor :v, :original_index

  def initialize(v, index)
    @v = v
    @original_index = index
  end

  def inspect
    "Item(v=#{v},idx=#{original_index})"
  end

  def <=>(other)
    @v <=> other.v if other.is_a? Item
    @v <=> other
  end
end

##
# Given an index
# The new index for the given item is index + value
# 5 cases:
# value < 0 and index + value >= 0    => use index + value
# value < 0 and index + value < 0     => index' = max + index + value # positive change = index' - index
# value = 0                           => unchanged
# value > 0 and index + value <= max  => use index + value
# value > 0 and index + value > max   => index' = index + value - max # negative change = index' - index
def move(list, index)
  value = list[index].v
  max = list.size - 1

  case (index + value)
  in new_index if value < 0 && index + value >= 0
    move_item(list, index, new_index)
  in new_index if value < 0 && index + value < 0
    while new_index < 0
      new_index += max
    end
    move_item(list, index, new_index)
  in new_index if new_index == index then list
  in new_index if value > 0 && index + value <= max
    move_item(list, index, new_index)
  in new_index if value > 0 && index + value > max
    loops = new_index / list.size
    move_item(list, index, loops + new_index % list.size)
  in v then raise "Unmatched new_index: #{v}, index: #{index}, value: #{value}"
  end
end

def move_item(list, from, to)
  if from < to
    list[0...from] + list[from+1..to] + list[from..from] + list[to+1..]
  else
    list[0...to] + list[from..from] + list[to...from] + list[from+1..]
  end
end

def nth_after(numbers, nth, value = 0)
  idx = numbers.find_index { _1.v == value }
  numbers[(idx + nth) % numbers.size]
end

# example = "[-3,1,0]"
# numbers = eval(example).map.with_index { Item.new(_1, _2) }
# puts numbers.map(&:v).inspect
# puts move2(numbers, 0).map(&:v).inspect
# return

def part1(input)
  numbers = input.map(&:to_i).map.with_index { Item.new(_1, _2) }
  (0..numbers.size - 1).each do |index|
    # puts numbers.map(&:v).inspect
    numbers = move(numbers, numbers.find_index { _1.original_index == index })
  end
  # puts numbers.map(&:v).inspect
  nth_after(numbers, 1000).v +
    nth_after(numbers, 2000).v +
    nth_after(numbers, 3000).v
end

def part2(input) end

puts "Part 1 (Example): #{part1(example)}"
puts "Part 1: #{part1(input)}"
# puts "Part 2 (Example): #{part2(example)}"
# puts "Part 2: #{part2(input)}"
