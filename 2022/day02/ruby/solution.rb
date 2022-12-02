require_relative '../../aoc'

include Aoc

input = get_input(year: 2022, day: 2)
example = <<~EXAMPLE
  A Y
  B X
  C Z
EXAMPLE
example = example.split("\n").map(&:strip)

def input_to_rps = {
  A: :rock,
  B: :paper,
  C: :scissors,
  X: :rock,
  Y: :paper,
  Z: :scissors,
}

def points_for_selection = {
  rock: 1, paper: 2, scissors: 3,
}

def points_for_outcome(me, other) =
  case [me, other]
  in _ if other == me then 3
  in [:rock, :scissors] then 6
  in [:scissors, :paper] then 6
  in [:paper, :rock] then 6
  else 0
  end

def score(me, other)
  points_for_selection[me] + points_for_outcome(me, other)
end

def part1(input)
  input
    .map { _1.split(' ').map(&:to_sym).map { |l| input_to_rps[l] } }
    .map { |other, me| score(me, other) }
    .sum
end

def pick_for_wanted_outcome = {
  rock: { X: :scissors, Y: :rock, Z: :paper },
  paper: { X: :rock, Y: :paper, Z: :scissors },
  scissors: { X: :paper, Y: :scissors, Z: :rock },
}

def part2(input)
  input
    .map { _1.split(' ').map(&:to_sym) }
    .map do |other, outcome|
      other_pick = input_to_rps[other]
      [other_pick, pick_for_wanted_outcome[other_pick][outcome]]
    end
    .map { |other, me| score(me, other) }
    .sum
end

puts "Part 1 (Example): #{part1(example)}"
puts "Part 1: #{part1(input)}"
puts "Part 2 (Example): #{part2(example)}"
puts "Part 2: #{part2(input)}"
