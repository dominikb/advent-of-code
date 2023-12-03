require_relative '../../../utils/ruby/Aoc'

input = Aoc.get_input(year: 2023, day: 2)
example = <<~EXAMPLE
Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
EXAMPLE

example = example.split("\n").map(&:strip)

CONFIGURATION = {
    :red => 12,
    :green => 13,
    :blue => 14,
}

def parse(line)
    game, rest = line.split(":")
    id = game.split(" ").last.to_i

    draws = rest.split(";").map(&:strip).map do |draw|
        draw.split(",").map(&:strip).map do |count_and_color|
            count, color = count_and_color.split(" ")
            [color.to_sym, count.to_i]
        end.to_h
    end

    [id, draws]
end

def part1(input)
    input
    .map { |line| parse(line) }
    .filter_map do |id, draws|
        too_many_dice_in_total = draws.any? { |draw| draw.values.sum > CONFIGURATION.values.sum }
        too_many_of_one_color = draws.any? do |draw|
            draw.any? do |color, count|
                count > CONFIGURATION[color]
            end
        end

        next nil if too_many_dice_in_total || too_many_of_one_color

        id
    end
    .sum
end

def part2(input)
    input
    .map { |line| parse(line) }
    .map do |id, draws|
        draws.reduce({:red => 0, :green => 0, :blue => 0}) do |acc, draw|
            acc.keys.each do |color|
                acc[color] = max(acc[color], draw[color] || 0)
            end
            acc
        end
    end
    .map { |configuration| configuration.values.reduce(1, :*) }
    .sum
end

puts "Part 1 (Example): #{part1(example)}"
puts "Part 1: #{part1(input)}"
puts "Part 2 (Example): #{part2(example)}"
puts "Part 2: #{part2(input)}"
