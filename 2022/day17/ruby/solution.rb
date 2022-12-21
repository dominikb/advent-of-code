# frozen_string_literal: true

require_relative '../../../utils/ruby/Aoc'

input = Aoc.get_input(year: 2022, day: 17)
example = <<~EXAMPLE
  >>><<><>><<<>><>>><<<>>><<<><<<>><>><<>>
EXAMPLE
example = example.split("\n")

ROCKS = [
  [:line, [[0, 0], [1, 0], [2, 0], [3, 0]]],
  [:plus, [[1, 0], [0, 1], [1, 1], [2, 1], [1, 2]]],
  [:l, [[2, 0], [2, 1], [1, 0], [0, 0], [2, 2]]],
  [:h_line, [[0, 0], [0, 1], [0, 2], [0, 3]]],
  [:block, [[0, 0], [1, 0], [0, 1], [1, 1]]],
].map { |name, pos| [name, pos.map { |x, y| [x + 2, y] }] }.freeze

def create_rocks_producer
  i = 0
  Enumerator.produce do
    ROCKS[i].tap do
      i = ((i + 1) % (ROCKS.size))
    end
  end
end

def collision?(chamber, rock)
  return rock.any? do |x, y|
    row = chamber[y]
    !row.nil? && row[x] != '.'
  end
  rock_positions = Set.new(rock)
  chamber_positions = chamber.keys.flat_map do |y|
    (0..6).filter_map { |x| chamber[y][x] != '.' ? [x, y] : nil }
  end.then { Set.new(_1) }

  !rock_positions.disjoint?(chamber_positions)
end

def out_of_bounds?(rock)
  rock.any? { |x, _y| x < 0 || x > 6 }
end

def move(rock, dx, dy)
  rock.map do |x, y|
    [x + dx, y + dy]
  end
end

def down(rock) = move(rock, 0, -1)

def left(rock)
  move(rock, -1, 0)
end

def right(rock)
  move(rock, 1, 0)
end

def prune!(chamber)
  max_ys = [0] * 7
  unknown_y_for_x = (0..6).to_a
  Range.new(*chamber.keys.minmax).to_a.reverse.each do |y|
    break if unknown_y_for_x.empty?

    unknown_y_for_x.delete_if do |x|
      if chamber[y][x] != '.' && y > max_ys[x]
        max_ys[x] = y
        true
      end
    end
  end

  y_min = max_ys.min
  y_max = chamber.keys.max
  pruned = y_max - y_min
  (y_min..y_max).each do |y|
    chamber[y - y_min] = chamber[y]
  end
  chamber.keys.filter { _1 > pruned }.each { chamber.delete(_1) }
  y_min
end

def print_chamber(chamber, rock = [])
  puts (Range.new(*(chamber.keys + rock.map(&:second)).minmax).map do |y|
    "| #{chamber[y].map.with_index { |cell, x| rock.include?([x, y]) ? '@' : cell }.join(' ')} |"
  end.reverse.join("\n"))
  puts "* * * * * * * * *"
end

def part1(input)
  jets = input.first
  jets2 = jets + jets + jets
  rock_count = 0
  # chamber = Hash.new { _1[_2] = %w[. . . . . . .] }
  chamber = {}
  chamber[0] = [['_'] * 7]
  rocks_producer = create_rocks_producer
  jet_idx = 0
  total_pruned = 0

  while rock_count < 2022
    tallest = chamber.keys.max
    # rock = rocks_producer.next.map { |x, y| [x, y + tallest + 4] }

    # We always start 3 lines above the tallest one. Thus we can move down and left/right 3 times at least
    type, path = rocks_producer.next
    rock =
      case jets2[jet_idx..jet_idx + 2]
      in '>>>'
        max_x_movement =
          case type
          in :line then 1
          in :plus | :l then 2
          else 3
          end
        path.map { |x, y| [x + max_x_movement, y + tallest + 1] }
        # Moving 1 right always works
      in '>><' | '><>' | '<>>' then path.map { |x, y| [x + 1, y + tallest + 1] }
      # Can move 2 left at max anyway
      in '<<<' then path.map { |x, y| [x - 2, y + tallest + 1] }
      # Moving 1 left always works
      in '<<>' | '<><' | '><<' then path.map { |x, y| [x - 1, y + tallest + 1] }
      in e
        puts({ e:, slice: jets2[jet_idx..jet_idx + 2], jet_idx:, jets:, jets_size: jets.size, jets2: }.inspect)
        raise "bad pattern for #{e}"
      end
    jet_idx = (jet_idx + 3) % jets.size
    # rock = rocks_producer.next.second.map { [_1, _2 + tallest + 4] }

    # Falling
    loop do
      case jets[jet_idx]
        # in '>' then next_pos = move(rock, 1, 0)
      in '>' then next_pos = right(rock)
      # in '<' then next_pos = move(rock, -1, 0)
      in '<' then next_pos = left(rock)
      end
      jet_idx = (jet_idx + 1) % jets.size
      unless out_of_bounds?(next_pos) || collision?(chamber, next_pos)
        rock = next_pos
      end
      next_pos = down(rock)
      break if collision?(chamber, next_pos)
      rock = next_pos
    end

    # Place rock
    rock.each do |x, y|
      if chamber[y].nil?
        chamber[y] = %w(. . . . . . .)
      end
      chamber[y][x] = '#'
    end
    rock_count += 1

    # Prune regularily
    pruned = prune!(chamber)
    total_pruned += pruned
  end
  chamber.keys.max + total_pruned
end

def part2(input)
  jets = input.first
  rock_count = 0
  rock_limit = 1000000000000
  # rock_limit = 2022
  chamber = {}
  chamber[0] = [['_'] * 7]
  rocks_producer = create_rocks_producer
  jet_idx = 0
  total_pruned = 0

  states = {}
  cycle_found = false

  while rock_count < rock_limit
    tallest = chamber.keys.max

    type, path = rocks_producer.next
    rock = path.map { [_1, _2 + tallest + 4] }

    # Falling
    loop do
      case jets[jet_idx]
      in '>' then next_pos = right(rock)
      in '<' then next_pos = left(rock)
      end
      jet_idx = (jet_idx + 1) % jets.size
      unless out_of_bounds?(next_pos) || collision?(chamber, next_pos)
        rock = next_pos
      end
      next_pos = down(rock)
      break if collision?(chamber, next_pos)
      rock = next_pos
    end

    # Place rock
    rock.each do |x, y|
      if chamber[y].nil?
        chamber[y] = %w(. . . . . . .)
      end
      chamber[y][x] = '#'
    end
    rock_count += 1

    # Prune regularily
    pruned = prune!(chamber)
    total_pruned += pruned

    if !cycle_found && states[[type, jet_idx, chamber]]
      cycle_found = true
      rocks_fallen_since = rock_count - states[[type, jet_idx, chamber]][:rock_count]
      pruned_rows_since = total_pruned - states[[type, jet_idx, chamber]][:total_pruned]
      # "prune" up to the max repetitions

      repetitions_possible = (rock_limit - rock_count) / rocks_fallen_since

      rocks_to_add = rocks_fallen_since * repetitions_possible
      new_pruned_to_add = pruned_rows_since * repetitions_possible

      rock_count += rocks_to_add
      total_pruned += new_pruned_to_add
    end
    states[[type, jet_idx, chamber]] = { rock_count:, total_pruned: }
  end
  chamber.keys.max + total_pruned
end

timed("1 Example") { puts "Part 1 (Example): #{part1(example)}" }
timed("1") { puts "Part 1: #{part1(input)}" }
timed("2ex") { puts "Part 2 (Example): #{part2(example)}" }
timed("2") { puts "Part 2: #{part2(input)}" }
