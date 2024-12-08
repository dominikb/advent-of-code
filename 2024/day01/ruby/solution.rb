require_relative "../../../utils/ruby/Aoc"

input = Aoc.get_input(year: 2024, day: 1)
example = <<~EXAMPLE
  3   4
  4   3
  2   5
  1   3
  3   9
  3   3
EXAMPLE

example = example.split("\n").map(&:strip)

def part1(input)
  first_list = []
  second_list = []

  input.map(&:integers).each do |a, b|
    first_list << a
    second_list << b
  end

  first_list.sort!
  second_list.sort!

  first_list.zip(second_list).sum do |(a, b)|
    (a - b).abs
  end
end

def part2(input)
  first_list = []
  second_list = []

  input.map(&:integers).each do |a, b|
    first_list << a
    second_list << b
  end

  counter = second_list.tally

  first_list.sum do |a|
    counter.fetch(a, 0) * a
  end
end

puts "Part 1 (Example): #{part1(example)}"
puts "Part 1: #{part1(input)}"
puts "Part 2 (Example): #{part2(example)}"
puts "Part 2: #{part2(input)}"
