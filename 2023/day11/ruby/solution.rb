require_relative '../../../utils/ruby/Aoc'

input = Aoc.get_input(year: 2023, day: 11)
example = <<~EXAMPLE
...#......
.......#..
#.........
..........
......#...
.#........
.........#
..........
.......#..
#...#.....
EXAMPLE

example = example.split("\n").map(&:strip)

def print_map(map)
    puts map.map(&:join).join("\n")
end

def parse(input)
    map = input.map(&:chars)

    empty_rows = input.each_with_index.filter_map do |row, i|
        i if row.chars.all? { _1 == "." }
    end

    empty_cols = map.transpose.each_with_index.filter_map do |column, i|
        i if column.all? { _1 == "." }
    end

    galaxies = map.each.with_index.flat_map do |row, y|
        row.each.with_index.filter_map do |cell, x|
            [x, y] if cell == "#"
        end
    end

    [map, galaxies, empty_rows, empty_cols]
end

def distance(a, b, factor, empty_rows, empty_cols)
    lower_x, upper_x = [a[0], b[0]].sort
    lower_y, upper_y = [a[1], b[1]].sort

    empty_rows_covered = empty_rows.filter { _1.between?(lower_y, upper_y) }
    empty_cols_covered = empty_cols.filter { _1.between?(lower_x, upper_x) }

    (a[0] - b[0]).abs + (a[1] - b[1]).abs + (factor - 1) * (empty_rows_covered.size + empty_cols_covered.size)
end

def part1(input)
    map, galaxies, empty_rows, empty_cols = parse(input)

    galaxies.combination(2).sum { distance(_1, _2, 2, empty_rows, empty_cols) }
end

def part2(input)
    map, galaxies, empty_rows, empty_cols = parse(input)

    galaxies.combination(2).sum { distance(_1, _2, 1_000_000, empty_rows, empty_cols) }
end

puts "Part 1 (Example): #{part1(example)}"
puts "Part 1: #{part1(input)}"
puts "Part 2 (Example): #{part2(example)}"
puts "Part 2: #{part2(input)}"
