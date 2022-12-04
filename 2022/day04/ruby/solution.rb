require_relative '../../aoc'

include Aoc

class Range
  def overlaps?(other)
    cover?(other.first) || other.cover?(first)
  end
end

input = get_input(year: 2022, day: 4)
example = <<~EXAMPLE
2-4,6-8
2-3,4-5
5-7,7-9
2-8,3-7
6-6,4-6
2-6,4-8
EXAMPLE
example = example.split("\n").map(&:strip)

def part1(input)
  input
    .map { |line| line.match(%r|(\d+)-(\d+),(\d+)-(\d+)|)
                      .captures.map(&:to_i)
                      .each_slice(2).map { Range.new(*_1) } }
    .count { _1.cover?(_2) || _2.cover?(_1) }
end

def part2(input)
  input
    .map { |line| line.match(%r|(\d+)-(\d+),(\d+)-(\d+)|)
                      .captures.map(&:to_i)
                      .each_slice(2).map { Range.new(*_1) } }
    .count { _1.overlaps?(_2) }
end

puts "Part 1 (Example): #{part1(example)}"
puts "Part 1: #{part1(input)}"
puts "Part 2 (Example): #{part2(example)}"
puts "Part 2: #{part2(input)}"
