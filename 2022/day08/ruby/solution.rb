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

  grid = rows
  counting_grid = grid.map { _1.clone }

  count = 0
  grid.each.with_index do |row, row_index|
    row.each.with_index do |t, col_index|
      top = (columns[col_index][0...row_index].max || -1) < t
      bottom = (columns[col_index][row_index+1..].max || -1) < t
      left = (row[0...col_index].max || -1) < t
      right = (row[col_index+1..].max || -1) < t
      count += 1 if [top, bottom, left, right].any?
      counting_grid[row_index][col_index] = 'x' if [top, bottom, left, right].any?
    end
  end
  count
end

def part2(input)
  rows = input.map { _1.split('').map(&:to_i) }
  columns = rows.transpose

  grid = rows
  viewing_distances = grid.map { _1.clone }

  grid.each.with_index do |row, row_index|
    row.each.with_index do |t, col_index|
      c = ->(trees) do
        blocked = false
        trees.take_while do
          take = t >= 1 && (not blocked)
          blocked = _1 >= t || blocked
          take
        end.count
      end
      top = c.(columns[col_index][...row_index].reverse)
      bottom = c.(columns[col_index][row_index+1..])
      left = c.(row[...col_index].reverse)
      right = c.(row[col_index+1..])

      viewing_distances[row_index][col_index] = left * right * top * bottom
    end
  end
  viewing_distances.flatten.max
end

puts "Part 1 (Example): #{part1(example)}"
puts "Part 1: #{part1(input)}"
puts "Part 2 (Example): #{part2(example)}"
puts "Part 2: #{part2(input)}"
