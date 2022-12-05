require_relative '../../../utils/ruby/Aoc'

year = 2018
day = 2

input = Aoc.get_input(year:, day:)
example = <<~EXAMPLE
abcde
fghij
klmno
pqrst
fguij
axcye
wvxyz
EXAMPLE
example = example.split("\n").map(&:strip)

def part1(input)
  input
    .map { _1.split('').tally }
    .reduce([0, 0]) do |acc, item|
    [
      acc[0] + (item.values.any? { _1 == 2 } ? 1 : 0),
      acc[1] + (item.values.any? { _1 == 3 } ? 1 : 0),
    ]
  end.reduce(&:*)
end

def part2(input)
  input
    .product(input)
    .map { |a, b| a.chars.zip(b.chars).filter { |c1, c2| c1 == c2 }.map(&:first).join('') }
    .filter { _1.size == input.first.size - 1 }
    .first
end

puts "Part 1 (Example): #{part1(example)}"
part1(input).tap do |answer|
  puts "Part 1: #{answer}"
  # Aoc.submit(year:, day:, level: 1, answer:)
end
puts "Part 2 (Example): #{part2(example)}"
puts "Part 2: #{part2(input)}"
# Aoc.submit(year:, day:, level: 2, answer: part2(input))
