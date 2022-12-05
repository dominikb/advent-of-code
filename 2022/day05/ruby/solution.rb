require_relative '../../../utils/ruby/Aoc'

input = Aoc.get_input(year: 2022, day: 5, strip: false)
example = <<~EXAMPLE
    [D]    
[N] [C]    
[Z] [M] [P]
 1   2   3 

move 1 from 2 to 1
move 3 from 1 to 3
move 2 from 2 to 1
move 1 from 1 to 2
EXAMPLE
example = example.split("\n")

def part1(input)
  crates_input, moves_input = input.chunk_by(["\n", ''])

  stacked = Hash.new { |h,k| h[k] = [] }
  crates_input
    .map { |line| line.split('').each_slice(4).map { _1[1] } }
    .reverse
    .drop(1)
    .each do |stacks|
      stacks.each.with_index do |item, index|
        stacked[index + 1].push(item) unless item == ' '
      end
  end

  moves_input.map(&:integers).each do |n, from, to|
    n.times do
      stacked[to] << stacked[from].pop
    end
  end

  stacked.values.map(&:pop).join('')
end

def part2(input)
  crates_input, moves_input = input.chunk_by(["\n", ''])

  stacked = Hash.new { |h,k| h[k] = [] }
  crates_input
    .map { |line| line.split('').each_slice(4).map { _1[1] } }
    .reverse
    .drop(1)
    .each do |stacks|
    stacks.each.with_index do |item, index|
      stacked[index + 1].push(item) unless item == ' '
    end
  end

  moves_input.map(&:integers).each do |n, from, to|
    moving = []
    n.times { moving << stacked[from].pop }
    moving.reverse.each { stacked[to] << _1 }
  end

  stacked.values.map(&:pop).join('')
end

puts "Part 1 (Example): #{part1(example)}"
puts "Part 1: #{part1(input)}"
puts "Part 2 (Example): #{part2(example)}"
puts "Part 2: #{part2(input)}"
