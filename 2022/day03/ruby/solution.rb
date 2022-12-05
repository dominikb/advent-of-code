require_relative '../../../utils/ruby/Aoc'

input = Aoc.get_input(year: 2022, day: 3)
example = <<~EXAMPLE
vJrwpWtwJgWrhcsFMMfFFhFp
jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL
PmmdzqPrVvPwwTWBwg
wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn
ttgJtRGJQctTZtZT
CrZsJsPPZsGzwwsLwLmpwMDw
EXAMPLE
example = example.split("\n").map(&:strip)

def scoring(item) = (('a'..'z').to_a + ('A'..'Z').to_a).index(item) + 1

def part1(input)
  input
    .map { _1.strip.split('') } # Items
    .map { _1.each_slice(_1.size / 2.0).to_a } # Rucksacks with equal compartments
    .map { (_1 & _2).first } # Union of compartments is duplicate item
    .map { scoring(_1) }
    .sum
end

def part2(input)
  input
    .map { _1.strip.split('') }
    .each_slice(3) # Groups
    .map { _1.reduce(&:intersection).first } # Intersection between rucksacks of group
    .map { scoring(_1) }
    .sum
end

puts "Part 1 (Example): #{part1(example)}"
puts "Part 1: #{part1(input)}"
puts "Part 2 (Example): #{part2(example)}"
puts "Part 2: #{part2(input)}"
