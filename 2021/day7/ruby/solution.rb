require_relative '../../aoc'

include Aoc

input = get_input(year: 2021, day: 7)
example = <<~EXAMPLE
  16,1,2,0,4,2,7,1,2,14
EXAMPLE
example = example.split("\n").map(&:strip)

def part1(input)
  crabs = input.first.split(',').map(&:to_i)

  cost_for_target = ->(crabs, target_position) do
    crabs.map { _1 - target_position }.map(&:abs).sum
  end

  crabs.min.upto(crabs.max).map do |position|
    [position, cost_for_target.(crabs, position)]
  end.min_by(&:last).first
end

def part2(input)
  crabs = input.first.split(',').map(&:to_i)

  cost_table = Hash.new { |h, k| h[k] = h[k - 1] + k }
  cost_table[0] = 0

  cost_for_target = ->(crabs, target_position) do
    crabs.map { (target_position - _1).abs }.map { cost_table[_1] }.sum
  end

  crabs.min.upto(crabs.max).map do |position|
    [position, cost_for_target.(crabs, position)]
  end.min_by(&:last).last
end

puts "Part 1 (Example): #{part1(example)}"
puts "Part 1: #{part1(input)}"
puts "Part 2 (Example): #{part2(example)}"
puts "Part 2: #{part2(input)}"
