# frozen_string_literal: true

require_relative '../../../utils/ruby/Aoc'

input = Aoc.get_input(year: 2022, day: 9)
example = <<~EXAMPLE
R 5
U 8
L 8
D 3
R 17
D 10
L 25
U 20
EXAMPLE
example = example.split("\n")

class Pos
  attr_reader :x, :y

  def initialize(x, y)
    @x = x
    @y = y
  end

  def up = Pos.new(x, y + 1)

  def down = Pos.new(x, y - 1)

  def left = Pos.new(x - 1, y)

  def right = Pos.new(x + 1, y)

  def to_s
    "(#{x},#{y})"
  end
end

def move(x, y, dir)
  case dir
  in 'R' then [x + 1, y]
  in 'L' then [x - 1, y]
  in 'U' then [x, y + 1]
  in 'D' then [x, y - 1]
  end
end

def move_rope(hx, hy, tx, ty)
  dist = Math.sqrt((hx - tx) ** 2 + (hy - ty) ** 2)
  return [tx, ty] if dist <= 1.42 # sqrt 2

  dir_x = hx > tx ? 1 : -1
  dir_y = hy > ty ? 1 : -1

  if hx == tx
    [tx, ty + dir_y]
  elsif hy == ty
    [tx + dir_x, ty]
  else
    [tx + dir_x, ty + dir_y]
  end
end

def print_grid(hx, hy, tail)
  (26.downto(0)).each do |y|
    line = ""
    (0..26).each do |x|
      c = "."
      c = "s" if x == 0 && y == 0
      tail.reverse.each.with_index do |pos, i|
        tx, ty = pos
        c = "#{9 - i}" if tx == x && ty == y
      end
      c = "H" if hx == x && hy == y

      line += c + ' '
    end
    puts line
  end
  puts
end

def part1(input)
  hx, hy, tx, ty = 0, 0, 0, 0
  visited = {}
  visited["#{tx},#{ty}"] = true
  print_grid(hx, hy, [[tx, ty]])
  input.each do |line|
    dir, n = line.split(' ')
    puts "\n== #{line} ==\n"
    n.to_i.times do
      hx, hy = move(hx, hy, dir)
      tx, ty = move_rope(hx, hy, tx, ty)
      visited["#{tx},#{ty}"] = true
      print_grid(hx, hy, [[tx, ty]])
    end
  end
  visited.keys.count
end

def part2(input)
  hx, hy = 11, 5
  tail = 9.times.map { [11, 5] }
  visited = {}
  visited["#{tail.last.first}#{tail.last.last}"] = true
  print_grid(hx, hy, tail)
  input.each do |line|
    dir, n = line.split(' ')
    puts "\n== #{line} ==\n"
    n.to_i.times do
      hx, hy = move(hx, hy, dir)
      prev = [hx, hy]
      tail = tail.map do |t|
        tx, ty = t
        prev = move_rope(prev[0], prev[1], tx, ty)
        prev
      end
      visited["#{tail.last.first}#{tail.last.last}"] = true
      print_grid(hx, hy, tail)
    end
  end
  visited.keys.count
end

# puts "Part 1 (Example): #{part1(example)}"
# puts "Part 1: #{part1(input)}"
puts "Part 2 (Example): #{part2(example)}"
puts "Part 2: #{part2(input)}"
