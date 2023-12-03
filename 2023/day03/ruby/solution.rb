require_relative '../../../utils/ruby/Aoc'

input = Aoc.get_input(year: 2023, day: 3)
example = <<~EXAMPLE
467..114..
...*......
..35..633.
......#...
617*......
.....+.58.
..592.....
......755.
...$.*....
.664.598..
EXAMPLE

example = example.split("\n").map(&:strip)

def parse(line)
    line.split('').map { |c| c =~ /\d+/ ? c.to_i : c }
end

def at(mapping, x, y)
    mapping[y][x]
rescue
    '.'
end

def part?(char) = char != '.' && !(char.is_a?(Integer))
def adjacent?(mapping, x, y)
    (-1..1).each do |dy|
        (-1..1).each do |dx|
            return [x+dx, y+dy] if part?(at(mapping, x + dx, y + dy))
        end
    end

    false
end
def gear?(mapping, x, y) = at(mapping, x, y) == '*'

def part1(input)
    mapping = input.map { |line| parse(line) }

    part_numbers = []
    number = 0
    is_adjacent = false
    first_digit = true
    mapping.each_with_index do |line, y|
        line.each_with_index do |c, x|
            if c.is_a?(Integer)
                number = (number * 10) + c
                is_adjacent = adjacent?(mapping, x, y) if first_digit
                first_digit = false
            else
                is_adjacent = is_adjacent || adjacent?(mapping, x - 1, y)
                # puts "(x:#{x}|y:#{y}) #{number} #{is_adjacent}" if number > 0
                part_numbers << number if is_adjacent
                number = 0
                is_adjacent = false
                first_digit = true
            end
        end
    end
    part_numbers.sum
end

def part2(input)
    mapping = input.map { |line| parse(line) }

    part_numbers = []
    number = 0
    is_adjacent = false
    first_digit = true
    gear_index = nil
    mapping.each_with_index do |line, y|
        line.each_with_index do |c, x|
            if c.is_a?(Integer)
                number = (number * 10) + c
                is_adjacent = adjacent?(mapping, x, y) if first_digit
                first_digit = false
            else
                is_adjacent = is_adjacent || adjacent?(mapping, x - 1, y)
                if is_adjacent && gear?(mapping, *is_adjacent)
                    gear_index = is_adjacent
                end
                # puts "(x:#{x}|y:#{y}) #{number} #{is_adjacent}" if number > 0
                part_numbers << [number, gear_index] if is_adjacent
                number = 0
                is_adjacent = false
                first_digit = true
                gear_index = nil
            end
        end
    end
    part_numbers
    .filter { |number, gear_index| gear_index && number > 0 }
    .reduce({}) do |acc, (number, gear_index)|
            acc[gear_index] ||= []
            acc[gear_index] << number
            acc
    end
    .filter_map { |_, numbers| numbers if numbers.size == 2 }
    .map { |numbers| numbers.reduce(1, :*) }
    .sum
end

puts "Part 1 (Example): #{part1(example)}"
puts "Part 1: #{part1(input)}"
puts "Part 2 (Example): #{part2(example)}"
puts "Part 2: #{part2(input)}"
