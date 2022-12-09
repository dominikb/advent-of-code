# frozen_string_literal: true

require_relative '../../../utils/ruby/Aoc'
require 'set'

input = Aoc.get_input(year: 2022, day: 9)
example = <<~EXAMPLE
  R 4
  U 4
  L 3
  D 1
  R 4
  D 1
  L 5
  R 2
EXAMPLE
example = example.split("\n")

class Pos
  attr_accessor :x, :y

  def initialize(x, y)
    @x = x
    @y = y
  end

  def up! = self.y += 1
  def down! = self.y -= 1
  def left! = self.x -= 1
  def right! = self.x += 1

  def dist(to) = [(x - to.x).abs, (y - to.y).abs].max
  def to_s = "(#{x},#{y})"
end

class Rope
  attr_reader :head, :tail

  def initialize(start, tail_length = 1)
    @head = start.clone
    @tail = tail_length.times.map { start.clone }
  end

  def move!(direction)
    case direction
    in 'U' then head.up!
    in 'D' then head.down!
    in 'L' then head.left!
    in 'R' then head.right!
    end
    move_tail!
    yield self if block_given?
  end

  private def move_tail!
    tail.reduce(head) { move_knot!(_1, _2) }
  end

  private def move_knot!(head, tail)
    return tail if head.dist(tail) <= 1

    dir_x = head.x > tail.x ? 1 : -1
    dir_y = head.y > tail.y ? 1 : -1

    tail.tap do
      tail.x += dir_x unless head.x == tail.x
      tail.y += dir_y unless head.y == tail.y
    end
  end
end

def part1(input)
  rope = Rope.new(Pos.new(0, 0), 1)
  input
    .map { _1.split(' ') }
    .flat_map { |dir, n| n.to_i.times.map { dir } }
    .each_with_object(Set.new) do |dir, visited|
    rope.move!(dir) { visited << rope.tail.last.to_s }
  end.size
end

def part2(input)
  rope = Rope.new(Pos.new(0, 0), 9)
  input
    .map { _1.split(' ') }
    .flat_map { |dir, n| n.to_i.times.map { dir } }
    .each_with_object(Set.new) do |dir, visited|
    rope.move!(dir) { visited << rope.tail.last.to_s }
  end.size
end

puts "Part 1 (Example): #{part1(example)}"
puts "Part 1: #{part1(input)}"
puts "Part 2 (Example): #{part2(example)}"
puts "Part 2: #{part2(input)}"
