input = File.readlines(__dir__ + '/../input.txt').map(&:strip)
example = File.readlines(__dir__ + '/../example.txt').map(&:strip)

class Point
  attr_accessor :x, :y

  def initialize(x,y) = (@x, @y = x, y)
  def to(other, use_diagonal = false)
    if x == other.x
      return (y.upto(other.y) + other.y.upto(y)).map { |y| Point.new(x, y) }
    end
    if y == other.y
      return (x.upto(other.x) + other.x.upto(x)).map { |x| Point.new(x, y) }
    end
    if use_diagonal
      x_coords = x.step(other.x, x < other.x ? 1 : -1)
      y_coords = y.step(other.y, y < other.y ? 1 : -1)

      return x_coords.zip(y_coords).map { |x, y| Point.new(x, y) }
    end
  end
  def to_s = "#{x},#{y}"

  def self.from_string(string)
    Point.new(*string.split(',').map(&:to_i))
  end

  def eql?(other)
    if other.is_a? Point
      return (@x == other.x and @y == other.y)
    else
      super
    end
  end

  def hash
    x.hash ^ y.hash
  end
end

def print_grid(grid)
  max_x, max_y = grid.keys.map(&:x).max, grid.keys.map(&:y).max

  (0..max_y).each do |y|
    (0..max_x).each do |x|
      v = grid[Point.new(x, y)]
      print v == 0 ? '.' : v
    end
    puts
  end
end

def part1(input)
  points = input.flat_map do |row|
    a, b = row.split(' -> ').map { Point.from_string(_1) }
    a.to(b)
  end.reject(&:nil?)

  aggregated = points.each_with_object(Hash.new(0)) { _2[_1] += 1 }
  aggregated.values.filter { _1 >= 2 }.count
end

def part2(input)
  points = input.flat_map do |row|
    a, b = row.split(' -> ').map { Point.from_string(_1) }
    a.to(b, true)
  end.reject(&:nil?)

  aggregated = points.each_with_object(Hash.new(0)) { _2[_1] += 1 }
  aggregated.values.filter { _1 >= 2 }.count
end

puts "Part 1 (Example): #{part1(example)}"
puts "Part 1: #{part1(input)}"
puts "Part 2 (Example): #{part2(example)}"
puts "Part 2: #{part2(input)}"
