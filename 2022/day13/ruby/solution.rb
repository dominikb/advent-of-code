# frozen_string_literal: true

require_relative '../../../utils/ruby/Aoc'

input = Aoc.get_input(year: 2022, day: 13)
example = <<~EXAMPLE
  [1,1,3,1,1]
  [1,1,5,1,1]

  [[1],[2,3,4]]
  [[1],4]

  [9]
  [[8,7,6]]

  [[4,4],4,4]
  [[4,4],4,4,4]

  [7,7,7,7]
  [7,7,7]

  []
  [3]

  [[[]]]
  [[]]

  [1,[2,[3,[4,[5,6,7]]]],8,9]
  [1,[2,[3,[4,[5,6,0]]]],8,9]
EXAMPLE
example = example.split("\n")

def in_order?(left, right)
  case [left, right]
  in Integer => l, Integer => r then l <=> r
  in Array => l, Integer => r then in_order?(l, [r])
  in Integer => l, Array => r then in_order?([l], r)
  in [], [] then 0
  in [], Array => _ then -1
  in Array => _, [] then 1
  in [l, *lrest], [r, *rrest]
    case in_order?(l, r)
    in 0 then in_order?(lrest, rrest)
    in cmp then cmp
    end
  end
end

def part1(input)
  input
    .chunk_by("")
    .map { |pair| pair.map { eval(_1) } }
    .map { in_order?(*_1) }
    .map.with_index { |take, idx| take == -1 ? idx + 1 : 0 }
    .sum
end

def part2(input)
  dividers = %w[[[2]] [[6]]]
  (input + dividers)
    .reject(&:empty?)
    .map { eval(_1) }
    .sort { in_order?(_1, _2) }
    .map.with_index do |packet, idx|
    dividers.include?(packet.to_s) ? idx + 1 : 1
  end.reduce(&:*)
end

puts "Part 1 (Example): #{part1(example)}"
puts "Part 1: #{part1(input)}"
puts "Part 2 (Example): #{part2(example)}"
puts "Part 2: #{part2(input)}"
