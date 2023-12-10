require_relative '../../../utils/ruby/Aoc'

input = Aoc.get_input(year: 2023, day: 10)
example = <<~EXAMPLE
FF7FSF7F7F7F7F7F---7
L|LJ||||||||||||F--J
FL-7LJLJ||||||LJL-77
F--JF--7||LJLJIF7FJ-
L---JF-JLJIIIIFJLJJ7
|F|F-JF---7IIIL7L|7|
|FFJF7L7F-JF7IIL---7
7-L-JL7||F7|L7F-7F7|
L.L7LFJ|||||FJL7||LJ
L7JLJL-JLJLJL--JLJ.L
EXAMPLE

PIPES = {
    "|" => [:north, :south],
    "-" => [:east, :west],
    "L" => [:north, :east],
    "J" => [:north, :west],
    "7" => [:south, :west],
    "F" => [:south, :east],
    "." => [],
    " " => [],
    "S" => [:north, :south, :east, :west],
}

example = example.split("\n").map(&:strip)

class Pos
    attr_accessor :x, :y
    def initialize(x, y)
        @x = x
        @y = y
    end
    def to_a = [x, y]
    def go!(direction)
        @x, @y = send(direction)
    end
    def north = Pos.new(x, y - 1)
    def south = Pos.new(x, y + 1)
    def east = Pos.new(x + 1, y)
    def west = Pos.new(x - 1, y)

    def eql?(other)
        x == other.x && y == other.y
    end
end

def parse(input)
    sketch = input.map { _1.chars }
    distances = sketch.map { _1.map { -1 } }
    start = sketch.each.with_index.flat_map do |row, y|
        row.each.with_index.filter_map do |cell, x|
            [x, y] if cell == "S"
        end
    end.first

    start = Pos.new(*start)
    distances[start.y][start.x] = 0

    [sketch, distances, start]
end

def find_path(sketch, distances, start)
    processed = sketch.map { _1.map { false } }

    queue = [start]
    while queue.any?
        pos = queue.shift

        cell = sketch[pos.y][pos.x]
        PIPES[cell].each do |direction|

            next_pos = pos.send(direction)
            next_cell = sketch[next_pos.y][next_pos.x]

            must_connect = case direction
            when :north then :south
            when :south then :north
            when :east then :west
            when :west then :east
            end

            next unless PIPES[next_cell].include?(must_connect)

            prev_dist = distances[next_pos.y][next_pos.x]
            new_dist = distances[pos.y][pos.x] + 1

            if prev_dist == -1 || new_dist < prev_dist
                distances[next_pos.y][next_pos.x] = new_dist
            end
            
            unless processed[next_pos.y][next_pos.x]
                queue << next_pos
            end
        end
        processed[pos.y][pos.x] = true
    end

    distances
end

def part1(input)
    sketch, distances, start = parse(input)

    distances = find_path(sketch, distances, start)
    distances.flatten.max
end

def part2(input)
    sketch, distances, start = parse(input)

    distances = find_path(sketch, distances, start)

    # START Scale up 
    scaled_up = (sketch.size * 2).times.map do |y|
        (sketch.first.size * 2).times.map do |x|
          next " " unless x % 2 == 0 && y % 2 == 0
      
          char = distances[y / 2][x / 2] >= 0 ? sketch[y / 2][x / 2] : " "
        end
      end
      
      scaled_up.each_with_index do |row, y|
        row.each_with_index do |char, x|
          scaled_up[y][x] = "-" if PIPES[scaled_up[y][x - 1]].include?(:east) && PIPES[scaled_up[y][x + 1]].include?(:west)
          scaled_up[y][x] = "|" if PIPES[scaled_up[y - 1][x]].include?(:south) && PIPES[scaled_up[y + 1][x]].include?(:north)
        end
      end
    # END Scale up

    # START flood
    start = Pos.new(0, 0)
    queue = [start]
    while queue.any?
        pos = queue.shift

        [:north, :south, :east, :west].each do |direction|
            neighbour = pos.send(direction)
            if scaled_up[neighbour.y][neighbour.x] == " "
                scaled_up[neighbour.y][neighbour.x] = "~"
                queue << neighbour
            end
        end
    end
    # END flood

    # START scale down
    distances.each_with_index do |row, y|
        row.each_with_index do |dist, x|
            distances[y][x] = scaled_up[y * 2][x * 2]
        end
    end
    # END scale down

    distances.flatten.count { _1 == " " }
end

puts "Part 1 (Example): #{part1(example)}"
puts "Part 1: #{part1(input)}"
puts "Part 2 (Example): #{part2(example)}"
puts "Part 2: #{part2(input)}"
