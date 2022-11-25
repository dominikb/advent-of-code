require_relative '../../aoc'

include Aoc

input = get_input(year:, day:)
example = <<~EXAMPLE
acedgfb cdfbe gcdfa fbcad dab cefabd cdfgeb eafb cagedb ab |
cdfeb fcadb cdfeb cdbaf
EXAMPLE
example = example.split("\n").map(&:strip)

def part1(input)
end

def part2(input)
end

puts "Part 1 (Example): #{part1(example)}"
puts "Part 1: #{part1(input)}"
puts "Part 2 (Example): #{part2(example)}"
puts "Part 2: #{part2(input)}"
