require_relative '../../../utils/ruby/Aoc'

input = Aoc.get_input(year: 2023, day: 4)
example = <<~EXAMPLE
Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11
EXAMPLE

example = example.split("\n").map(&:strip)

def parse(line)
    id = line.split(':').first.split(' ').last.to_i

    numbers = line.split(':').last.split('|').map do |numbers|
        numbers.scan(/\d+/).map(&:to_i)
    end

    [id, numbers]
end

def part1(input)
    input
    .map { |line| parse(line) }
    .map(&:last) # Ignore ids
    .map { _1 & _2 }
    .reject(&:empty?)
    .map(&:size)
    .map { 2 ** (_1 - 1) }
    .sum
end

def part2(input)
    cards = input
    .map { |line| parse(line) }
    .map { |id, numbers| [id, 1, numbers.reduce(&:intersection).size] }

    (0...cards.size).each do |i|
        (id, count_in_deck, points) = cards[i]
        for k in (1..points)
            begin
                cards[i + k][1] += count_in_deck
            rescue NoMethodError # Out of bounds
            end
        end
    end

    cards.map { _2 }.sum
end

puts "Part 1 (Example): #{part1(example)}"
puts "Part 1: #{part1(input)}"
puts "Part 2 (Example): #{part2(example)}"
puts "Part 2: #{part2(input)}"
