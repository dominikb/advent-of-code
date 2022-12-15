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

def dist(x1, y1, x2, y2)
  (x1 - x2).abs + (y1 - y2).abs
end

def part1(input, y:)
  signals = input.map(&:integers).map { _1.take(2) }
  beacons = input.map(&:integers).map { _1.drop(2) }

  signals_with_dist = signals.zip(beacons).map do |(sx, sy), (bx, by)|
    [sx, sy, dist(sx, sy, bx, by)]
  end

  x_from = signals_with_dist.map { |sx, _sy, dist| sx - dist }.min
  x_to = signals_with_dist.map { |sx, _sy, dist| sx + dist }.max

  beacons_set = Set.new(beacons)

  (x_from..x_to).count do |x|
    signals_with_dist.any? do |sx, sy, dist_to_beacon|
      dist(x, y, sx, sy) <= dist_to_beacon && !beacons_set.include?([x, y])
    end
  end
end

def part1b(input, y:)
  target_y = y
  signals = input.map(&:integers).map { _1.take(2) }
  beacons = input.map(&:integers).map { _1.drop(2) }

  signals_with_dist = signals.zip(beacons).map do |(sx, sy), (bx, by)|
    [[sx, sy], dist(sx, sy, bx, by)]
  end

  rows = signals_with_dist.each_with_object(Hash.new { _1[_2] = SparseRange.new }) do |((sx, sy), dist), agg|
    (0..dist).each do |d|
      y = sy + (dist - d)
      agg[y].add (sx - d)..(sx + d) if y == target_y
      y = sy - (dist - d)
      agg[y].add (sx - d)..(sx + d) if y == target_y
    end
  end

  (rows[target_y].to_a - beacons.filter { _1.second == target_y }.map(&:first)).size
end

def part2(input, distress_limit:)
  signals = input.map(&:integers).map { _1.take(2) }
  beacons = input.map(&:integers).map { _1.drop(2) }

  signals_with_dist = signals.zip(beacons).map do |(sx, sy), (bx, by)|
    [[sx, sy], dist(sx, sy, bx, by)]
  end
  rows = signals_with_dist.each_with_object(Hash.new { _1[_2] = SparseRange.new }) do |((sx, sy), dist), agg|
    (0..dist).each do |d|
      agg[sy + (dist - d)].add((sx - d)..(sx + d))
      agg[sy - (dist - d)].add((sx - d)..(sx + d))
    end
  end

  relevant_row = (0..distress_limit)
  remaining = rows
    .filter { |k, v| relevant_row.cover?(k) }
    .reject { |k, v| v.cover?(relevant_row) }

  y, x = remaining.transform_values { _1.gap.to_a.first }.entries.first
  return [[x,y], x * 4000000 + y]
end

puts "Part 1 (Example): #{part1(example, y: 10)}"
timed("1b") { puts "Part 1b: #{part1b(input, y: 2_000_000)}" }
timed("2ex") { puts "Part 2 (Example): #{part2(example, distress_limit: 20)}" }
timed("2") { puts "Part 2: #{part2(input, distress_limit: 4_000_000)}" }
