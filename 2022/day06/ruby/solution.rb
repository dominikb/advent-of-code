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
    if signal[n...(n + len)].chars.uniq.count == len
      # puts signal[n...(n + len)]
      return n + len
    end
  end
end
def part1(input)
  input.map { uniq_seq_index(_1, 4) }.join(', ')
end

def part2(input)
  input.map { uniq_seq_index(_1, 14) }.join(', ')
end

puts "Part 1 (Example): #{part1(example)}"
puts "Part 1: #{part1(input)}"
puts "Part 2 (Example): #{part2(example)}"
puts "Part 2: #{part2(input)}"
