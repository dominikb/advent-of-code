require_relative '../../../utils/ruby/Aoc'

year = 2018
day = 1
input = Aoc.get_input(year:, day:)
example = <<~EXAMPLE
  +3
  +3
  -2
  +1
  -3
EXAMPLE
example = example.split("\n").map(&:strip)

def part1(input)
  input.map(&:to_i).sum
  # Aoc.submit(year: 2018, day: 1, answer: 1)
end

def part2(input)
  changes = input.map(&:to_i)
  frequencies_hit = Hash.new { |h,k| h[k] = 0}
  current_frequency = 0
  while true do
    changes.each do |change|
      current_frequency += change
      c = (frequencies_hit[current_frequency] += 1)
      return current_frequency if c > 1
    end
  end
end

puts "Part 1 (Example): #{part1(example)}"
part1(input).tap do |answer|
  puts "Part 1: #{answer}"
  # Aoc.submit(year: 2018, day: 1, level: 1, answer:)
end
puts "Part 2 (Example): #{part2(example)}"
puts "Part 2: #{part2(input)}"
Aoc.submit(year: 2018, day: 1, level: 2, answer: part2(input))
