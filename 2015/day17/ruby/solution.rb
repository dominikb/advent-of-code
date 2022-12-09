# frozen_string_literal: true

require_relative '../../../utils/ruby/Aoc'

input = Aoc.get_input(year: 2015, day: 17)
example = <<~EXAMPLE
20
15
10
5
5
EXAMPLE
example = example.split("\n")

class EggNogContainer
  include Comparable
  attr_accessor :volume
  def initialize(volume)
    @volume = volume
  end
  def <=>(other)
    self.object_id <=> other.object_id
  end
end

def fit(volume, left)
  (1..left.size).flat_map do |n|
    left.combination(n)
        .reject { _1.map(&:volume).sum != volume}
        .map(&:sort)
        .map { Set.new(_1) }
  end
end

def part1(input)
  containers = input.map(&:to_i).map { EggNogContainer.new(_1) }
  fit(150, containers).size
end

def part2(input)
  containers = input.map(&:to_i).map { EggNogContainer.new(_1) }
  fit(150, containers).map(&:size).tally&.first&.second || 0
end

puts "Part 1 (Example): #{part1(example)}"
puts "Part 1: #{part1(input)}"
puts "Part 2 (Example): #{part2(example)}"
puts "Part 2: #{part2(input)}"
