require_relative '../../../utils/ruby/Aoc'

input = Aoc.get_input(year: 2022, day: 1)
example = <<~EXAMPLE
  1000
  2000
  3000

  4000

  5000
  6000

  7000
  8000
  9000

  10000
EXAMPLE
example = example.split("\n").map(&:strip)

def part1(input)
  input
    .chunk_by { _1.strip.empty? }
    .map { |calories| calories.map(&:to_i).sum }
    .max
end

def part2(input)
  input
    .chunk_by { _1.strip.empty? }
    .map { |calories| calories.map(&:to_i).sum }
    .sort.reverse
    .take(3)
    .sum
end

puts "Part 1 (Example): #{part1(example)}"
puts "Part 1: #{part1(input)}"
puts "Part 2 (Example): #{part2(example)}"
puts "Part 2: #{part2(input)}"
