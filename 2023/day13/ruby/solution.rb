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

ALLOWED_SMUDGES = 0

def smudges(a, b)
    a.chars.zip(b.chars).sum { _1 != _2 ? 1 : 0 }
end

def verify(mirror_index, input, smudges)
    (0..mirror_index).each do |i|
        a = mirror_index - i
        b = mirror_index + i + 1
        break if a < 0 || b >= input.length

        smudges += smudges(input[a], input[b])
        return false if smudges > ALLOWED_SMUDGES
    end
    smudges == ALLOWED_SMUDGES
end

def horizontal(input)
    (0..(input.length - 2)).each do |i|
        s = smudges(input[i], input[i + 1])
        if s <= ALLOWED_SMUDGES
            return i if verify(i, input, s)
        end
    end
    nil
end

def vertical(input)
    input = input.map(&:chars).transpose.map(&:join)
    horizontal(input)
end

def part1(input)
    Kernel.const_set(:ALLOWED_SMUDGES, 0)
    input.map do |grid|
        # puts grid.inspect
        # puts
        # h = horizontal(grid)
        # next h * 100 if h
        # vertical(grid)
        [horizontal(grid)&.send(:*, 100), vertical(grid)]
    end#.sum
end

def part2(input)
    Kernel.const_set(:ALLOWED_SMUDGES, 0)
end

puts "Part 1 (Example): #{part1(example)}"
# puts "Part 1: #{part1(input)}"
# puts "Part 2 (Example): #{part2(example)}"
# puts "Part 2: #{part2(input)}"
