require_relative '../../../utils/ruby/Aoc'

input = Aoc.get_input(year: 2023, day: 9)
example = <<~EXAMPLE
0 3 6 9 12 15
1 3 6 10 15 21
10 13 16 21 30 45
EXAMPLE

example = example.split("\n").map(&:strip)

def parse(input)
    input.map { _1.split(" ").map(&:to_i) }
end

def diff(row)
    row.each_cons(2).map { _2 - _1 }
end

def part1(input)
    parse(input).sum do |history|
        seq = [history]
        seq << diff(seq.last) until seq.last.all?(&:zero?)
        seq.sum(&:last)
    end
end

def part2(input)
    parse(input).sum do |history|
        seq = [history]
        seq << diff(seq.last) until seq.last.all?(&:zero?)
        seq.reverse.reduce(0) do |current, e|
            e.first - current
        end
    end
end

puts "Part 1 (Example): #{part1(example)}"
puts "Part 1: #{part1(input)}"
puts "Part 2 (Example): #{part2(example)}"
puts "Part 2: #{part2(input)}"
