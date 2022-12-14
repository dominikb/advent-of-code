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

def fall((sand_x, sand_y), grid, part2 = false)
  return :void if sand_y + 1 >= grid.size && !part2

  return [sand_x, sand_y + 1] if grid[sand_y + 1][sand_x] == '.'
  return [sand_x - 1, sand_y + 1] if grid[sand_y + 1][sand_x - 1] == '.'
  return [sand_x + 1, sand_y + 1] if grid[sand_y + 1][sand_x + 1] == '.'

  :stop
end

def part1(input)
  rocks = input.flat_map { rocks(_1) }.to_a
  x_max = rocks.map(&:first).max
  y_max = rocks.map(&:second).max
  grid = (0..y_max).map { (0..x_max).map { '.' } }
  rocks.each { |(x, y)| grid[y][x] = '#' }

  sand = [500, 0]
  loop do
    sand_x, sand_y = sand
    case fall(sand, grid)
    in :stop
      grid[sand_y][sand_x] = 'o'
      sand = [500, 0]
    in :void then break
    in [x, y] then sand = [x, y]
    end
  end

  grid.flatten.count { _1 == 'o' }
end

def part2(input)
  rocks = input.flat_map { rocks(_1) }.to_a
  y_max = rocks.map(&:second).max
  floor_width = 1000
  floor = rocks("0,#{y_max + 2} -> #{floor_width},#{y_max + 2}")
  rocks += floor
  grid = (0..(y_max + 2)).map { (0..floor_width).map { '.' } }
  rocks.each { |(x, y)| grid[y][x] = '#' }

  sand = [500, 0]
  loop do
    sand_x, sand_y = sand
    case fall(sand, grid)
    in :void then break
    in [x, y] then sand = [x, y]
    in :stop then
      grid[sand_y][sand_x] = 'o'
      break if sand == [500, 0]
      sand = [500, 0]
    end
  end

  grid.flatten.count { _1 == 'o' }
end

puts "Part 1 (Example): #{part1(example)}"
puts "Part 1: #{part1(input)}"
puts "Part 2 (Example): #{part2(example)}"
puts "Part 2: #{part2(input)}"
