# frozen_string_literal: true

require_relative '../../../utils/ruby/Aoc'

input = Aoc.get_input(year: 2022, day: 5, strip: false)
example = <<~EXAMPLE
      [D]#{'    '}
  [N] [C]#{'    '}
  [Z] [M] [P]
   1   2   3#{' '}

  move 1 from 2 to 1
  move 3 from 1 to 3
  move 2 from 2 to 1
  move 1 from 1 to 2
EXAMPLE
example = example.split("\n")

def part1(input)
  crates_input, moves_input = input.chunk_by(["\n", ''])

  stacked = Array.new(crates_input.last.integers.max) { [] }
  crates_input
    .map { |line| line.split('').each_slice(4).map { _1[1] } }
    .reverse
    .drop(1)
    .each do |stacks|
    stacks.each.with_index do |item, index|
      stacked[index] << item unless item == ' '
    end
  end

  moves_input.map(&:integers).each do |n, from, to|
    stacked[to - 1] += stacked[from - 1].pop(n).reverse
  end

  stacked.map(&:last).join
end

def part2(input)
  crates_input, moves_input = input.chunk_by(["\n", ''])

  stacked = Array.new(crates_input.last.integers.max) { [] }
  crates_input
    .map { |line| line.split('').each_slice(4).map { _1[1] } }
    .reverse
    .drop(1)
    .each do |stacks|
    stacks.each.with_index do |item, index|
      stacked[index] << item unless item == ' '
    end
  end

  moves_input.map(&:integers).each do |n, from, to|
    stacked[to - 1] += stacked[from - 1].pop(n)
  end

  stacked.map(&:last).join
end

puts "Part 1 (Example): #{part1(example)}"
puts "Part 1: #{part1(input)}"
puts "Part 2 (Example): #{part2(example)}"
puts "Part 2: #{part2(input)}"
