# frozen_string_literal: true

require_relative '../../../utils/ruby/Aoc'

input = Aoc.get_input(year: 2022, day: 12)
example = <<~EXAMPLE
Sabqponm
abcryxxl
accszExk
acctuvwj
abdefghi
EXAMPLE
example = example.split("\n")

MAX_DISTANCE = 999
def mapping = (('a'..'z').map.with_index { [_1, _2] }).to_h.merge({'S' => 0, 'E' => 25})

def neighbours(grid, (from_y, from_x))
  neighbours = []
  neighbours << [from_y - 1, from_x] if from_y >= 1
  neighbours << [from_y + 1, from_x] if from_y < grid.size - 1
  neighbours << [from_y, from_x - 1] if from_x >= 1
  neighbours << [from_y, from_x + 1] if from_x < grid[from_y].size - 1
  neighbours
end

def possible_moves(grid, distances, (from_y, from_x))
  cur_elevation = grid[from_y][from_x]
  neighbours(grid, [from_y, from_x]).filter do |(y, x)|
    could_step = (cur_elevation - grid[y][x]) <= 1
    is_shorter = distances[y][x] > distances[from_y][from_x] + 1
    could_step && is_shorter
  end
end

def build_distance_map(input)
  grid = input.map { |row| row.split('').map { mapping[_1] } }
  distance_map = grid.map { _1.map { MAX_DISTANCE } }

  end_y = input.find_index { _1.include?('E') }
  end_x = input[end_y].index('E')

  distance_map[end_y][end_x] = 0

  queue = [[end_y, end_x]]
  until queue.empty?
    (cur_y, cur_x) = cur = queue.shift
    neighbours = possible_moves(grid, distance_map, cur)
    queue += neighbours
    neighbours.each do |(y, x)|
      distance_map[y][x] = distance_map[cur_y][cur_x] + 1
    end
  end
  distance_map
end

def part1(input)
  distance_map = build_distance_map(input)

  start_y = input.find_index { _1.include?('S') }
  start_x = input[start_y].index('S')
  distance_map[start_y][start_x]
end

def part2(input)
  distance_map = build_distance_map(input)

  (0...input.size)
    .product(0...input[0].size)
    .filter { 'aS'.include?(input[_1][_2]) }
    .map { distance_map[_1][_2] }
    .min
end

puts "Part 1 (Example): #{part1(example)}"
puts "Part 1: #{part1(input)}"
puts "Part 2 (Example): #{part2(example)}"
puts "Part 2: #{part2(input)}"
