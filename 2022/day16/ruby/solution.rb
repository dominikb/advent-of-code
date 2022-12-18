# frozen_string_literal: true

require 'parallel'
require_relative '../../../utils/ruby/Aoc'

input = Aoc.get_input(year: 2022, day: 16)
example = <<~EXAMPLE
  Valve AA has flow rate=0; tunnels lead to valves DD, II, BB
  Valve BB has flow rate=13; tunnels lead to valves CC, AA
  Valve CC has flow rate=2; tunnels lead to valves DD, BB
  Valve DD has flow rate=20; tunnels lead to valves CC, AA, EE
  Valve EE has flow rate=3; tunnels lead to valves FF, DD
  Valve FF has flow rate=0; tunnels lead to valves EE, GG
  Valve GG has flow rate=0; tunnels lead to valves FF, HH
  Valve HH has flow rate=22; tunnel leads to valve GG
  Valve II has flow rate=0; tunnels lead to valves AA, JJ
  Valve JJ has flow rate=21; tunnel leads to valve II
EXAMPLE
example = example.split("\n")

def parse(line)
  parts = line.split(' ')
  flow_rate = line.integers.first.to_i
  room = parts.second
  tunnels = parts.drop(9).map { _1.tr(',', '') }
  { room:, flow_rate:, tunnels: }
end

def shortest_paths(rooms)
  paths = Hash.new { _1[_2] = Hash.new { 1_000_000 } }

  rooms.each do |name, room|
    paths[name][name] = 0
    room[:tunnels].each do |target|
      paths[name][target] = 1
    end
  end

  changed = true
  while changed
    changed = false

    rooms.each_key do |from|
      rooms.each_key do |to|
        rooms.each_key do |using|
          if paths[from][to] > paths[using][to] + paths[from][using]
            paths[from][to] = paths[using][to] + paths[from][using]
            changed = true
          end
        end
      end
    end
  end

  paths
end

def maximum_values_per_opened_valves(input, t_start)
  rooms = input.map { parse(_1) }.index_by { _1[:room] }
  sp = shortest_paths(rooms)
  non_zero_valves = rooms.values.filter { _1[:flow_rate] > 0 }.map { _1[:room] }.then { Set.new(_1) }

  top = Hash.new(0)
  queue = [["AA", t_start, 0, Set.new]]
  while !queue.empty?
    cur, time, pressure, opened = queue.shift
    top[opened.dup] = pressure if top[opened] < pressure
    (non_zero_valves - opened).each do |next_room|
      t = time - sp[cur][next_room] - 1
      next if t <= 0
      queue << [next_room, t, pressure + t * rooms[next_room][:flow_rate], opened + [next_room]]
    end
  end
  top
end

def part1(input)
  top = maximum_values_per_opened_valves(input, 30)
  top.entries.max_by { _2 }
end

def part2(input)
  top = maximum_values_per_opened_valves(input, 26)
  top.entries
     .combination(2)
     .filter { |(path1, _), (path2, _)| path1.disjoint?(path2) }
     .map { |(p1, v1), (p2, v2)| [v1 + v2, [p1, v1], [p2, v2]] }
     .max_by(&:first)
end

puts "Part 1 (Example): #{part1(example)}"
timed("1") { puts "Part 1b: #{part1(input)}" }
timed("2ex") { puts "Part 2 (Example): #{part2(example)}" }
timed("2") { puts "Part 2: #{part2(input)}" }
