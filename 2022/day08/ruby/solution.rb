# frozen_string_literal: true

require_relative '../../../utils/ruby/Aoc'

input = Aoc.get_input(year: 2022, day: 8)
example = <<~EXAMPLE
  30373
  25512
  65332
  33549
  35390
EXAMPLE
example = example.split("\n")

def part1(input)
  rows = input.map { _1.split('').map(&:to_i) }
  columns = rows.transpose
  grid = rows.transpose

  (0...columns.size).product(0...rows.size).count do |x, y|
    tree = grid[x][y]
    rows[y][x + 1..].all? { _1 < tree } ||
      rows[y][...x].all? { _1 < tree } ||
      columns[x][...y].all? { _1 < tree } ||
      columns[x][y + 1..].all? { _1 < tree }
  end
end

def part2(input)
  rows = input.map { _1.split('').map(&:to_i) }
  columns = rows.transpose
  grid = rows.transpose

  dist = lambda do |trees, t|
    case trees.find_index { _1 >= t }
    in nil then trees.size
    in idx then idx + 1
    end
  end

  (0...columns.size).product(0...rows.size).map do |x, y|
    tree = grid[x][y]
    top = dist.call(columns[x][0...y].reverse, tree)
    bottom = dist.call(columns[x][y + 1..], tree)
    left = dist.call(rows[y][0...x].reverse, tree)
    right = dist.call(rows[y][x + 1..], tree)
    top * bottom * left * right
  end.max
end

puts "Part 1 (Example): #{part1(example)}"
puts "Part 1: #{part1(input)}"
puts "Part 2 (Example): #{part2(example)}"
puts "Part 2: #{part2(input)}"
