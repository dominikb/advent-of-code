# frozen_string_literal: true

require_relative '../../../utils/ruby/Aoc'

input = Aoc.get_input(year: 2022, day: 14)
example = <<~EXAMPLE
  498,4 -> 498,6 -> 496,6
  503,4 -> 502,4 -> 502,9 -> 494,9
EXAMPLE
example = example.split("\n")

def rocks(line)
  line
    .split(' -> ')
    .map(&:integers)
    .each_cons(2)
    .flat_map do |(ax, ay), (bx, by)|
    case [(ax - bx), (ay - by)]
    in _, 0 then (ax < bx ? (ax..bx) : (bx..ax)).map { [_1, ay] }
    in 0, _ then (ay < by ? (ay..by) : (by..ay)).map { [ax, _1] }
    end
  end
end

def fall((sand_x, sand_y), grid, max_y, part2 = false)
  return :void if sand_y + 1 > max_y && !part2

  next_row = grid[sand_y + 1].dup
  next_row[sand_x] = "[#{next_row[sand_x]}]"

  return [sand_x, sand_y + 1] if grid[sand_y + 1][sand_x] == '.'
  return [sand_x - 1, sand_y + 1] if grid[sand_y + 1][sand_x - 1] == '.'
  return [sand_x + 1, sand_y + 1] if grid[sand_y + 1][sand_x + 1] == '.'

  :stop
end

def part1(input)
  rocks = input.flat_map { rocks(_1) }.to_a
  x_min, x_max = rocks.map(&:first).minmax
  y_min, y_max = rocks.map(&:second).minmax
  sand_source = [500 - x_min, 0]
  rocks = rocks.map { |(x, y)| [x - x_min, y] }
  grid = (0..y_max).map do |y|
    (x_min..x_max).map { |x| '.' }
  end
  rocks.each { |(x, y)| grid[y][x] = '#' }
  grid[sand_source.second][sand_source.first] = '*'

  sand = sand_source
  loop do
    sand_x, sand_y = sand
    case (falling = fall(sand, grid, y_max))
    in :stop
      grid[sand_y][sand_x] = 'o'
      sand = sand_source
    in :void then break
    in [x, y] then
      sand = [x, y]
    end
  end

  "\n" + grid.map { _1.join('') }.join("\n")
  grid.flatten.count { _1 == 'o' }
end

def part2(input)
  rocks = input.flat_map { rocks(_1) }.to_a
  x_min, x_max = rocks.map(&:first).minmax
  y_min, y_max = rocks.map(&:second).minmax
  sand_source = [500, 0]
  # rocks = rocks.map { |(x, y)| [x - x_min, y] }
  floor = (0...1_000).map { [_1, y_max + 2] }
  rocks += floor
  grid = (0..(y_max+2)).map do |y|
    (0..1_000).map { |x| '.' }
  end
  floor = (0...10000).map { [_1, y_max + 2] }
  rocks += floor
  rocks.each { |(x, y)| grid[y][x] = '#' }
  grid[sand_source.second][sand_source.first] = '*'

  sand = sand_source
  loop do
    sand_x, sand_y = sand
    case (falling = fall(sand, grid, y_max + 2))
    in :stop
      grid[sand_y][sand_x] = 'o'
      break if sand == sand_source
      sand = sand_source
    in :void then break
    in [x, y] then
      sand = [x, y]
    end
  end

  "\n" + grid.map { _1.join('') }.join("\n")
  grid.flatten.count { _1 == 'o' }
end

puts "Part 1 (Example): #{part1(example)}"
puts "Part 1: #{part1(input)}"
puts "Part 2 (Example): #{part2(example)}"
puts "Part 2: #{part2(input)}"
