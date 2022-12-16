# frozen_string_literal: true

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

    rooms.keys.each do |from|
      rooms.keys.each do |to|
        rooms.keys.each do |using|
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

def part1(input)
  rooms = input.map { parse(_1) }.index_by { _1[:room] }
  sp = shortest_paths(rooms)
  start = "AA"
  permutation_limit = 8

  non_zero = rooms.values.filter_map { _1[:flow_rate].zero? ? nil : _1[:room] }
  puts "Size: #{non_zero}"
  permutations = non_zero.permutation([non_zero.size, permutation_limit].min)

  highest = [0, []]
  semaphore = Mutex.new
  t_start = 30
  i = 0
  max = permutations.size

  # require 'parallel'
  # sliceSlice = max / Parallel.processor_count
  # slices = (0..9).map do |n|
  #   permutations.lazy.drop(sliceSlice * n).take(sliceSlice)
  # end
  # return slices.map(&:inspect).join("\n")
  # Parallel.each(slices) do |_path|
  #   i += 1
  #   puts "progress #{(i / max.to_f).round(5)} [#{i}|#{max}]" if i.modulo(1_000_000) == 0
  #   dist = 0
  #   value = 0
  #   path = _path.to_a.unshift(start)
  #   for from, to in path.each_cons(2)
  #     dist += sp[from][to] + 1
  #     break if dist < 0
  #     activated_at = t_start - dist
  #     value += rooms[to][:flow_rate] * (activated_at > 0 ? activated_at : 0)
  #   end
  #
  #   if value > highest[0]
  #     semaphore.synchronize do
  #       if value > highest[0]
  #         highest = [value, dist, path.dup]
  #         puts "New highest: #{highest.inspect}"
  #       end
  #     end
  #   end
  # end
  #
  # return highest

  for path in permutations
    i += 1
    puts "progress #{(i / max.to_f).round(5)} [#{i}|#{max}]" if i.modulo(1_000_000) == 0
    dist = 0
    value = 0
    path.unshift(start)
    for from, to in path.each_cons(2)
      dist += sp[from][to] + 1
      break if dist < 0
      activated_at = t_start - dist
      value += rooms[to][:flow_rate] * (activated_at > 0 ? activated_at : 0)
    end

    if value > highest[0]
      semaphore.synchronize do
        if value > highest[0]
          highest = [value, dist, path.dup]
          puts "New highest: #{highest.inspect}"
        end
      end
    end
  end

  return highest
end

def part2(input) end

puts "Part 1 (Example): #{part1(example)}"
timed("1") { puts "Part 1: #{part1(input)}" }
# timed("2ex") { puts "Part 2 (Example): #{part2(example)}" }
# timed("2") { puts "Part 2: #{part2(input)}" }
