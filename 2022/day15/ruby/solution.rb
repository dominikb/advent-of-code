# frozen_string_literal: true

require_relative '../../../utils/ruby/Aoc'

input = Aoc.get_input(year: 2022, day: 15)
example = <<~EXAMPLE
  Sensor at x=2, y=18: closest beacon is at x=-2, y=15
  Sensor at x=9, y=16: closest beacon is at x=10, y=16
  Sensor at x=13, y=2: closest beacon is at x=15, y=3
  Sensor at x=12, y=14: closest beacon is at x=10, y=16
  Sensor at x=10, y=20: closest beacon is at x=10, y=16
  Sensor at x=14, y=17: closest beacon is at x=10, y=16
  Sensor at x=8, y=7: closest beacon is at x=2, y=10
  Sensor at x=2, y=0: closest beacon is at x=2, y=10
  Sensor at x=0, y=11: closest beacon is at x=2, y=10
  Sensor at x=20, y=14: closest beacon is at x=25, y=17
  Sensor at x=17, y=20: closest beacon is at x=21, y=22
  Sensor at x=16, y=7: closest beacon is at x=15, y=3
  Sensor at x=14, y=3: closest beacon is at x=15, y=3
  Sensor at x=20, y=1: closest beacon is at x=15, y=3
EXAMPLE
example = example.split("\n")

def points_within((x, y), dist)
  ((x - dist)..(x + dist)).product((y - dist)..(y + dist)).filter_map do |xd, yd|
    [xd, yd] if ((x - xd).abs + (y - yd).abs) < dist
  end + [[x, y]]
end

def dist(x1, y1, x2, y2)
  (x1 - x2).abs + (y1 - y2).abs
end

# Should be 5142231
def part1(input, y:)
  signals = input.map(&:integers).map { _1.take(2) }
  beacons = input.map(&:integers).map { _1.drop(2) }

  signals_with_dist = signals.zip(beacons).map do |(sx, sy), (bx, by)|
    [sx, sy, dist(sx, sy, bx, by)]
  end

  x_from = signals_with_dist.map { |sx, _sy, dist| sx - dist }.min
  x_to = signals_with_dist.map { |sx, _sy, dist| sx + dist }.max

  beacons_set = Set.new(beacons)

  (x_from-1..x_to+1).count do |x|
    signals_with_dist.any? do |sx, sy, dist_to_beacon|
      dist(x, y, sx, sy) <= dist_to_beacon && !beacons_set.include?([x, y])
    end
  end
end

def part2(input)
  signals = input.map(&:integers).map { _1.take(2) }
  beacons = input.map(&:integers).map { _1.drop(2) }

  distress_x = 0..20
  distress_y = 0..20

  grid = {}
  input
    .map(&:integers)
    .map { |sx, sy, bx, by| [sx, sy, (sx - bx).abs + (sy - by).abs] }
    .flat_map { |sx, sy, dist| points_within([sx, sy], dist) }
    .each { grid[_1] = 1 }

  # max_x = grid.keys.map(&:second).max
  # max_y = grid.keys.map(&:first).max

  puts
  for y in distress_y
    for x in distress_x
      next print('S') if signals.include?([x, y])
      next print('B') if beacons.include?([x, y])
      # print('.')
      print(grid.key?([x, y]) ? '#' : '.')
    end
    puts
  end
  # grid.keys.filter { _1.second == 10 }.count
end

puts "Part 1 (Example): #{part1(example, y: 10)}"
puts "Part 1: #{part1(input, y: 2_000_000)}"
# puts "Part 2 (Example): #{part2(example)}"
# puts "Part 2: #{part2(input)}"
