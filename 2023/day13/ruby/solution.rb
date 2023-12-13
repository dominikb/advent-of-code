require_relative '../../../utils/ruby/Aoc'

input = Aoc.get_input(year: 2023, day: 13).join("\n").split("\n\n").map { _1.split("\n").map(&:strip) }
example = <<~EXAMPLE
#.##..##.
..#.##.#.
##......#
##......#
..#.##.#.
..##..##.
#.#.##.#.

#...##..#
#....#..#
..##..###
#####.##.
#####.##.
..##..###
#....#..#
EXAMPLE

example = example.split("\n\n").map { _1.split("\n").map(&:strip) }

def distance(a, b)
    a.chars.zip(b.chars).count { _1 != _2 }
end

def verify(mirror_index, input)
    total_distance = 0
    (0..mirror_index).each do |i|
        a = mirror_index - i
        b = mirror_index + i + 1

        return total_distance == ALLOWED_DISTANCE if (a < 0 || b >= input.length)
        total_distance += distance(input[a], input[b])
        return false if total_distance > ALLOWED_DISTANCE
    end
    total_distance == ALLOWED_DISTANCE
end

def horizontal(input)
    (0..(input.length - 2)).each do |i|
        return i + 1 if verify(i, input)# && distance(input[i], input[i + 1]) == ALLOWED_DISTANCE
    end
    nil
end

def vertical(input)
    input = input.map(&:chars).transpose.map(&:join)
    horizontal(input)
end

def part1(input)
    input.map do |grid|
        h = horizontal(grid)
        next h * 100 if h
        vertical(grid)
    end
    .sum
end

def part2(input)
    part1(input)
end


ALLOWED_DISTANCE = 0
puts "Part 1 (Example): #{part1(example)}"
puts "Part 1: #{part1(input)}"

ALLOWED_DISTANCE = 1
puts "Part 2 (Example): #{part2(example)}"
puts "Part 2: #{part2(input)}"
