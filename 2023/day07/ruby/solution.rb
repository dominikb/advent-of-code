require_relative '../../../utils/ruby/Aoc'

input = Aoc.get_input(year: 2023, day: 7)
example = <<~EXAMPLE
32T3K 765
T55J5 684
KK677 28
KTJJT 220
QQQJA 483
EXAMPLE

example = example.split("\n").map(&:strip)

TYPES = [50000, 41000, 32000, 31100, 22100, 21110, 11111]

def parse(input)
    input.map do |line|
        hand, bid = line.split(' ').map(&:strip)
        [hand, bid.to_i]
    end
end

def type(hand)
    hand.chars.tally.values.sort.reverse.join.ljust(5, '0').to_i
end

def card_order_values(hand, cards_order)
    hand.chars.map do |card|
        cards_order.size - cards_order.index(card)
    end
end

def part1(input)
    parse(input)
    .map { |hand, bid| [type(hand), hand, bid] }
    .sort_by { |type, hand, bid| [type, card_order_values(hand, "AKQJT98765432")] }
    .each.with_index.sum { |(type, hand, bid), i| bid * (i + 1) }
end

# All possibilities to select n out of pool
# Each element can be selected multiple times
def selection(n, pool)
    return [[]] if n == 0

    pool.each.with_index.flat_map do |card, i|
        selection(n - 1, pool[i..-1]).map { |s| [card] + s }
    end
end

def type2(hand)
    hand_without_joker = hand.gsub('J', '')
    possible_joker_values = hand_without_joker.chars.uniq
    return TYPES.first if possible_joker_values.size <= 1

    selection(5 - hand_without_joker.size, possible_joker_values).map do |joker_values|
        type(hand_without_joker + joker_values.join)
    end.max
end

def part2(input)
    parse(input)
    .map { |hand, bid| [type2(hand), hand, bid] }
    .sort_by { |type, hand, bid| [type, card_order_values(hand, "AKQT98765432J")] }
    .each.with_index.sum { |(type, hand, bid), i| bid * (i + 1) }
end

puts "Part 1 (Example): #{part1(example)}"
puts "Part 1: #{part1(input)}"
puts "Part 2 (Example): #{part2(example)}"
puts "Part 2: #{part2(input)}"
