# frozen_string_literal: true

require_relative '../../../utils/ruby/Aoc'

input = Aoc.get_input(year: 2022, day: 11)
example = <<~EXAMPLE
  Monkey 0:
    Starting items: 79, 98
    Operation: new = old * 19
    Test: divisible by 23
      If true: throw to monkey 2
      If false: throw to monkey 3

  Monkey 1:
    Starting items: 54, 65, 75, 74
    Operation: new = old + 6
    Test: divisible by 19
      If true: throw to monkey 2
      If false: throw to monkey 0

  Monkey 2:
    Starting items: 79, 60, 97
    Operation: new = old * old
    Test: divisible by 13
      If true: throw to monkey 1
      If false: throw to monkey 3

  Monkey 3:
    Starting items: 74
    Operation: new = old + 3
    Test: divisible by 17
      If true: throw to monkey 0
      If false: throw to monkey 1
EXAMPLE
example = example.split("\n")

def parse_monkey(monkey_input)
  n = monkey_input[0].integers.first
  items = monkey_input[1].integers
  op =
    case monkey_input[2].split(':').last.split(' ')
    in 'new', '=', 'old', '*', 'old' then ->(old) { old * old }
    in 'new', '=', 'old', '*', value then ->(old) { old * value.to_i }
    in 'new', '=', 'old', '+', value then ->(old) { old + value.to_i }
    else nil
    end
  test = ->(val) { val.modulo(monkey_input[3].integers.last) == 0 }
  true_target = monkey_input[4].integers.last
  false_target = monkey_input[5].integers.last

  { n:, items:, op:, test:, true_target:, false_target:, inspect_count: 0 }
end

def turn(n, monkeys)
  active_monkey = monkeys[n]
  active_monkey[:inspect_count] += active_monkey[:items].size
  active_monkey[:items].each do |item|
    new_item = active_monkey[:op].call(item) / 3
    if active_monkey[:test].call(new_item)
      monkeys[active_monkey[:true_target]][:items] << new_item
    else
      monkeys[active_monkey[:false_target]][:items] << new_item
    end
  end
  active_monkey[:items] = []
end

def round(monkeys)
  monkeys.keys.sort.each do |n|
    turn(n, monkeys)
  end
end

def monkey_print(monkeys)
  monkeys.map do |i, m|
    "Monkey #{m[:n]}: #{m[:items].join(', ')}"
  end.join("\n")
end

def part1(input)
  monkeys = input.chunk_by(["\n", ""]).map { parse_monkey(_1) }.map { [_1[:n], _1] }.to_h
  20.times { round(monkeys) }
  monkeys.values.map { _1[:inspect_count] }.sort.reverse.take(2).reduce(&:*)
end

def part2(input)
  # monkeys = input.chunk_by(["\n", ""]).map { parse_monkey(_1) }.map { [_1[:n], _1] }.to_h
  # 10_000.times { round(monkeys) }
  # monkeys.values.map { _1[:inspect_count] }.sort.reverse.take(2).reduce(&:*)
end

puts "Part 1 (Example): #{part1(example)}"
puts "Part 1: #{part1(input)}"
puts "Part 2 (Example): #{part2(example)}"
# puts "Part 2: #{part2(input)}"
