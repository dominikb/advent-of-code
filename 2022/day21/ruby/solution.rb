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

  # Collapse to formula
  yelling['humn'] = 'humn'
  while monkeys.size > 1
    monkeys.delete_if do |name, op, (a, b)|
      if yelling.key?(a) && yelling.key?(b) && name != 'root'
        yelling[name] = "(#{yelling[a]} #{op} #{yelling[b]})"
        true
      end
    end
  end

  _name, _val, (a, b) = root_monkey
  equ = "#{yelling[a]} - #{yelling[b]}"
  python = IO.popen(
    "python3 #{__dir__}/eval_expr.py \"#{equ}\""
  )
  python.gets
end

puts "Part 1 (Example): #{part1(example)}"
puts "Part 1: #{part1(input)}"
puts "Part 2 (Example): #{part2(example)}"
puts "Part 2: #{part2(input)}"
