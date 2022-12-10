# frozen_string_literal: true

require_relative '../../../utils/ruby/Aoc'

input = Aoc.get_input(year: 2022, day: 10)
example = <<~EXAMPLE
  addx 15
  addx -11
  addx 6
  addx -3
  addx 5
  addx -1
  addx -8
  addx 13
  addx 4
  noop
  addx -1
  addx 5
  addx -1
  addx 5
  addx -1
  addx 5
  addx -1
  addx 5
  addx -1
  addx -35
  addx 1
  addx 24
  addx -19
  addx 1
  addx 16
  addx -11
  noop
  noop
  addx 21
  addx -15
  noop
  noop
  addx -3
  addx 9
  addx 1
  addx -3
  addx 8
  addx 1
  addx 5
  noop
  noop
  noop
  noop
  noop
  addx -36
  noop
  addx 1
  addx 7
  noop
  noop
  noop
  addx 2
  addx 6
  noop
  noop
  noop
  noop
  noop
  addx 1
  noop
  noop
  addx 7
  addx 1
  noop
  addx -13
  addx 13
  addx 7
  noop
  addx 1
  addx -33
  noop
  noop
  noop
  addx 2
  noop
  noop
  noop
  addx 8
  noop
  addx -1
  addx 2
  addx 1
  noop
  addx 17
  addx -9
  addx 1
  addx 1
  addx -3
  addx 11
  noop
  noop
  addx 1
  noop
  addx 1
  noop
  noop
  addx -13
  addx -19
  addx 1
  addx 3
  addx 26
  addx -30
  addx 12
  addx -1
  addx 3
  addx 1
  noop
  noop
  noop
  addx -9
  addx 18
  addx 1
  addx 2
  noop
  noop
  addx 9
  noop
  noop
  noop
  addx -1
  addx 2
  addx -37
  addx 1
  addx 3
  noop
  addx 15
  addx -21
  addx 22
  addx -6
  addx 1
  noop
  addx 2
  addx 1
  noop
  addx -10
  noop
  noop
  addx 20
  addx 1
  addx 2
  addx 2
  addx -6
  addx -11
  noop
  noop
  noop
EXAMPLE
example = example.split("\n")

class Clock
  attr_reader :value

  def initialize(*consumers)
    @value = 0
    @consumers = consumers
  end

  def add_consumer(consumer)
    @consumers << consumer
  end

  def do_cycle
    @consumers.each { _1.do_cycle(self) }
    @value += 1
  end
end

class CPU
  attr_reader :x, :instructions

  def initialize(instructions)
    @instructions = instructions.clone
    @x = 1
    @instruction_cycle_count = 0
  end

  def do_cycle(*)
    case @instructions.first.split(' ')
    in ['noop']
      @instructions.shift
    in 'addx', value
      @instruction_cycle_count += 1
      if @instruction_cycle_count == 2
        @instruction_cycle_count = 0
        @x += value.to_i
        @instructions.shift
      end
    end
  end
end

class CRT
  def initialize(cpu)
    @cpu = cpu
    @screen = 6.times.map { 40.times.map { '.' } }
  end

  def do_cycle(clock)
    row = clock.value.div(40)
    col = clock.value.modulo(40)

    @screen[row][col] = '#' if (col - 1..col + 1).include?(@cpu.x)
  end

  def to_s
    @screen.map { _1.join('') }.join("\n")
  end
end

def part1(input)
  cpu = CPU.new(input)
  clock = Clock.new(cpu)

  (20..220).step(40).map do |target_cycle|
    (target_cycle - 1 - clock.value).times { clock.do_cycle }
    cpu.x * target_cycle
  end.sum
end

def part2(input)
  cpu = CPU.new(input)
  crt = CRT.new(cpu)
  clock = Clock.new(crt, cpu)

  clock.do_cycle until cpu.instructions.empty?

  puts crt.to_s
end

puts "Part 1 (Example): #{part1(example)}"
puts "Part 1: #{part1(input)}"
puts "Part 2 (Example): #{part2(example)}"
puts "Part 2: #{part2(input)}"
