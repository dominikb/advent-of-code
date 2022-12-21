require_relative '../../../utils/ruby/Aoc'

input = Aoc.get_input(year: 2022, day: 21)
example = <<~EXAMPLE
  root: pppw + sjmn
  dbpl: 5
  cczh: sllz + lgvd
  zczc: 2
  ptdq: humn - dvpt
  dvpt: 3
  lfqf: 4
  humn: 5
  ljgn: 2
  sjmn: drzm * dbpl
  sllz: 4
  pppw: cczh / lfqf
  lgvd: ljgn * ptdq
  drzm: hmdt - zczc
  hmdt: 32
EXAMPLE
example = example.split("\n").map(&:strip)

def parse_monkey(line)
  case line.split(' ')
  in name, first, op, second
    [name.tr(':', ''), op, [first, second]]
  in name, number
    [name.tr(':', ''), number.to_i]
  end
end

def part1(input)
  monkeys = input.map { parse_monkey(_1) }

  yelling = {}
  monkeys.delete_if do
    if _2.is_a? Integer
      yelling[_1] = _2
      true
    end
  end
  while monkeys.size > 0
    monkeys.delete_if do |name, op, (a, b)|
      a_num = yelling[a]
      b_num = yelling[b]
      if a_num && b_num
        yelling[name] =
          case op
          in '+' then a_num + b_num
          in '-' then a_num - b_num
          in '*' then a_num * b_num
          in '/' then a_num / b_num
          end
        true
      end
    end
  end
  yelling['root']
end

def solve_with(humn, monkeys, yelling, root_monkey)
  yelling['humn'] = humn
  while monkeys.size > 0
    monkeys.delete_if do |name, op, (a, b)|
      a_num = yelling[a]
      b_num = yelling[b]
      if a_num && b_num
        yelling[name] =
          case op
          in '+' then a_num + b_num
          in '-' then a_num - b_num
          in '*' then a_num * b_num
          in '/' then a_num / b_num
          end
        true
      end
    end
  end

  _, _, (a, b) = root_monkey
  [yelling[a] == yelling[b], yelling[a], yelling[b]]
end

def eval_eq(eq)
  case eq.tr('()', '').split(' ')
  in a, '*', humn, '-', b if humn[-4..] == 'humn'
    a = a.to_i; b = b.to_i
    "(#{humn.integers.empty? ? a : humn.integers * a}humn - #{a * b})"
  in a, '*', humn, '+', b if humn[-4..] == 'humn'
    a = a.to_i; b = b.to_i
    "(#{humn.integers.empty? ? a : humn.integers * a}humn + #{a * b})"
  in eq then raise "Unmatched '#{eq}'"
  end
end

def part2(input)
  monkeys = input.map { parse_monkey(_1) }

  root_monkey = monkeys.find do |name, *_rest|
    name == 'root'
  end

  yelling = {}
  monkeys.delete_if do
    if _2.is_a? Integer
      yelling[_1] = _2
      true
    end
  end
  # Solve as far as possible without using human
  changed = true
  while changed
    changed = false
    monkeys.delete_if do |name, op, (a, b)|
      a_num = yelling[a]
      b_num = yelling[b]
      if a_num && b_num && a != 'humn' && b != 'humn'
        changed = true
        yelling[name] =
          case op
          in '+' then a_num + b_num
          in '-' then a_num - b_num
          in '*' then a_num * b_num
          in '/' then a_num / b_num
          end
        true
      end
    end
  end

  # Collapse to formula
  formula = ''
  yelling['humn'] = 'humn'
  while monkeys.size > 1
    monkeys.delete_if do |name, op, (a, b)|
      if yelling.key?(a) && yelling.key?(b) && name != 'root'
        yelling[name] = T.from(yelling[a]).apply(op, T.from(yelling['b']))
        yelling[name] = "(} #{op} #{yelling[b]})"
        true
      end
    end
  end

  _name, _val, (a, b) = root_monkey
  puts yelling[a].inspect
  puts yelling[b].inspect

  # (0..).each do |humn|
  #   solution = solve_with(humn, monkeys.dup, yelling.dup, root_monkey)
  #   if solution.first
  #     puts solution.inspect
  #     return humn
  #   end
  # end
end

puts "Part 1 (Example): #{part1(example)}"
puts "Part 1: #{part1(input)}"
puts "Part 2 (Example): #{part2(example)}"
puts "Part 2: #{part2(input)}"
