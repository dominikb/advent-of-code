# frozen_string_literal: true

require_relative '../../../utils/ruby/Aoc'

input = Aoc.get_input(year: 2022, day: 6)
example = <<~EXAMPLE
  mjqjpqmgbljsphdztnvjfqwrcgsmlb
  bvwbjplbgvbhsrlpgdmjqwftvncz
  nppdvjthqldpwncqszvftbrmjlhg
  nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg
  zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw
EXAMPLE
example = example.split("\n")

def uniq_seq_index(signal, len)
  (0..).each do |n|
    return n + len if signal[n, len].chars.uniq.count == len
  end
end

def uniq_seq_index2(signal, len)
  signal.chars.each_cons(len).find_index { _1.uniq.count == len } + len
end

def part1(input)
  input.map { uniq_seq_index2(_1, 4) }.join(', ')
end

def part2(input)
  input.map { uniq_seq_index(_1, 14) }.join(', ')
end

puts "Part 1 (Example): #{part1(example)}"
puts "Part 1: #{part1(input)}"
puts "Part 2 (Example): #{part2(example)}"
puts "Part 2: #{part2(input)}"
