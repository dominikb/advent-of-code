require_relative '../../../utils/ruby/Aoc'

input = Aoc.get_input(year: 2023, day: 1)
example = <<~EXAMPLE
1abc2
pqr3stu8vwx
a1b2c3d4e5f
treb7uchet
EXAMPLE
example2 = <<~EXAMPLE
two1nine
eightwothree
abcone2threexyz
xtwone3four
4nineeightseven2
zoneight234
7pqrstsixteen
EXAMPLE

example = example.split("\n").map(&:strip)
example2 = example2.split("\n").map(&:strip)

def part1(input)
    input
    .map { |line| line.scan(/\d/).map(&:to_i) }
    .map { |numbers| [numbers.first, numbers.last].join }
    .map(&:to_i)
    .sum
end

class Lexer
    TOKENS = %w[zero one two three four five six seven eight nine 0 1 2 3 4 5 6 7 8 9].freeze

    MAX_LOOKAHEAD = TOKENS.map(&:length).max

    def token_value(token)
        token.size == 1 ? token.to_i : TOKENS.index(token)
    end

    def parse(input)
        index = 0
        tokens = []
        current_token = ""
        lookahead = 1

        while index < input.length
            current_token = input[index, lookahead]
            if TOKENS.include?(current_token)
                tokens << current_token
                index += 1 # Tokens can overlap. For example "oneight" is "one" and "eight".
                lookahead = 1
            else
                lookahead += 1
                if lookahead > MAX_LOOKAHEAD
                    index += 1
                    lookahead = 1
                end
            end
        end
        
        tokens.map { token_value(_1) }
    end
end


def part2(input)
    input
    .map { |line| Lexer.new.parse(line) }
    .map { |numbers| [numbers.first, numbers.last].join }
    .map(&:to_i)
    .sum
end

puts "Part 1 (Example): #{part1(example)}"
puts "Part 1: #{part1(input)}"
puts "Part 2 (Example): #{part2(example2)}"
puts "Part 2: #{part2(input)}"
