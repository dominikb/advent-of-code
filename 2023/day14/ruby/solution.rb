require_relative '../../../utils/ruby/Aoc'

input = Aoc.get_input(year: 2023, day: 14)
example = <<~EXAMPLE
O....#....
O.OO#....#
.....##...
OO.#O....O
.O.....O#.
O.#..O.#.#
..O..#O..O
.......O..
#....###..
#OO..#....
EXAMPLE

example = example.split("\n").map(&:strip)

def rotate(grid, direction, reverse: false)
    case direction
    when :n then grid.transpose
    when :e then grid.map(&:reverse)
    when :s then if !reverse then grid.transpose.map(&:reverse) else grid.map(&:reverse).transpose end
    when :w then grid
    end
end

def shift(column)
    column.chunk { _1 == '#' }.flat_map do |_, rocks|
        rocks.sort!.reverse!
    end
end

def tilt(direction, grid)
    grid = rotate(grid, direction)

    grid.map! do |column|
        shift(column)
    end

    rotate(grid, direction, reverse: true)
end

def weight(grid)
    grid.each_with_index.map do |row, y|
        row.count('O') * (grid.size - y)
    end.sum
end

def parse(input)
    input.map(&:chars)
end

def cycle(grid, directions)
    directions.reduce(grid) do |_grid, direction|
        tilt(direction, _grid)
    end
end

def pretty(grid)
    grid.map(&:join).join("\n")
end

def part1(input)
    grid = parse(input)
    grid = cycle(grid, [:n])
    weight(grid)
end

def part2(input)
    cache = {}
    grid = parse(input)
    directions = [:n, :w, :s, :e]
    i = 0
    target = 1_000_000_000
    while i < target do
        grid = cycle(grid, directions)
        i += 1
        prev_i = cache[grid] || i
        cache[grid] = i

        if prev_i < i then
            loop_length = i - prev_i
            full_loops = (target - i) / loop_length
            i += full_loops * loop_length
        end
    end
    weight(grid)
end

puts "Part 1 (Example): #{part1(example)}"
puts "Part 1: #{part1(input)}"
puts "Part 2 (Example): #{part2(example)}"
puts "Part 2: #{part2(input)}"
