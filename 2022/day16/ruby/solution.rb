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

OUTPUT_FILE = __dir__ + '/results.txt'

def part1(input)
  rooms = input.map { parse(_1) }.index_by { _1[:room] }
  sp = shortest_paths(rooms)
  start = "AA"
  permutation_limit = 8

  non_zero = rooms.values.filter_map { _1[:flow_rate].zero? ? nil : _1[:room] }
  puts "Size: #{non_zero}"
  permutations = non_zero.permutation([non_zero.size, permutation_limit].min)

  t_start = 30

  sliceSize = permutations.size / 10
  slices = (0..9).map { permutations.lazy.drop(_1 * sliceSize).take(sliceSize) }

  begin
    File.delete(OUTPUT_FILE)
  rescue
  end
  children = slices.map do |slice|
    Process.fork do
      highest = [0, []]
      for path in slice
        dist = 0
        value = 0
        path.unshift(start)
        for from, to in path.each_cons(2)
          dist += sp[from][to] + 1
          break if dist < 0
          activated_at = t_start - dist
          value += rooms[to][:flow_rate] * (activated_at > 0 ? activated_at : 0) # Avoid underflow
        end

        if value > highest[0]
          highest = [value, dist, path.dup]
          puts "New highest [#{Process.pid}]: #{highest.inspect}"
        end
      end
      highest
      File.open(OUTPUT_FILE, 'a') do |file|
        file << highest.inspect
        file << "\n"
      end
    end
  end
  Process.waitall
  puts File.read(OUTPUT_FILE)

  Signal.trap('INT') do |signo|
    puts Signal.signame(signo)
    children.each { Process.kill('INT', _1) }
  end

  File.readlines(OUTPUT_FILE).map { eval(_1) }.max_by(&:first)
end

# Part 2: [1774, {"AR"=>6, "EJ"=>9, "OW"=>15, "VR"=>8, "AH"=>11, "HZ"=>14}]
# [2: 5.05751s]
def part2(input)
  rooms = input.map { parse(_1) }.index_by { _1[:room] }
  sp = shortest_paths(rooms)
  start = "AA"
  permutation_limit = 5

  non_zero = rooms.values.filter_map { _1[:flow_rate].zero? ? nil : _1[:room] }
  puts "Size: #{non_zero}"
  permutations = non_zero.permutation([non_zero.size, permutation_limit].min)

  t_start = 26

  sliceSize = permutations.size / 10
  slices = (0..9).map { permutations.lazy.drop(_1 * sliceSize).take(sliceSize) }
  # slices = [
  #   [[%w(JJ BB CC),
  #     %w(DD HH EE)]]
  # ]

  begin
    File.delete(OUTPUT_FILE)
    FileUtils.touch(OUTPUT_FILE)
  rescue
  end
  children = slices.map do |slice|
    Process.fork do
      highest = [0, []]
      for elephant_path in slice.drop(slice.size / 2)
        for my_path in slice.take(slice.size / 2)
          my_path_dist = [[my_path.first, sp[start][my_path.first]]]
          my_path.drop(1).each do |cur|
            prev, acc_dist = my_path_dist.last
            my_path_dist << [cur, sp[cur][prev] + acc_dist + 1]
          end
          elephant_path_dist = [[elephant_path.first, sp[start][elephant_path.first]]]
          elephant_path.drop(1).each do |cur|
            prev, acc_dist = elephant_path_dist.last
            elephant_path_dist << [cur, sp[cur][prev] + acc_dist + 1]
          end
          path = my_path_dist.to_h
          elephant_path_dist.each do |k, v|
            prev_v = path[k]
            if prev_v.nil? || prev_v > v
              path[k] = v
            end
            # next path[k] = v if !path.key?(k)
            # path[k] = v if path.fetch(k, -1) < v
          end

          value = path.sum do |room, delta_t|
            rooms[room][:flow_rate] * (t_start - delta_t - 1)
          end
          # dist = 0
          # value = 0
          # path.unshift(start)
          # for from, to in path.each_cons(2)
          #   dist += sp[from][to] + 1
          #   break if dist < 0
          #   activated_at = t_start - dist
          #   value += rooms[to][:flow_rate] * (activated_at > 0 ? activated_at : 0) # Avoid underflow
          # end

          if value > highest[0]
            highest = [value, path.dup]
            puts "New highest [#{Process.pid}]: #{highest.inspect}"
          end
        end
      end

      for elephant_path in slice.take(slice.size / 2)
        for my_path in slice.drop(slice.size / 2)
          my_path_dist = [[my_path.first, sp[start][my_path.first]]]
          my_path.drop(1).each do |cur|
            prev, acc_dist = my_path_dist.last
            my_path_dist << [cur, sp[cur][prev] + acc_dist + 1]
          end
          elephant_path_dist = [[elephant_path.first, sp[start][elephant_path.first]]]
          elephant_path.drop(1).each do |cur|
            prev, acc_dist = elephant_path_dist.last
            elephant_path_dist << [cur, sp[cur][prev] + acc_dist + 1]
          end
          path = my_path_dist.to_h
          elephant_path_dist.each do |k, v|
            prev_v = path[k]
            if prev_v.nil? || prev_v > v
              path[k] = v
            end
            # next path[k] = v if !path.key?(k)
            # path[k] = v if path.fetch(k, -1) < v
          end

          value = path.sum do |room, delta_t|
            rooms[room][:flow_rate] * (t_start - delta_t - 1)
          end
          # dist = 0
          # value = 0
          # path.unshift(start)
          # for from, to in path.each_cons(2)
          #   dist += sp[from][to] + 1
          #   break if dist < 0
          #   activated_at = t_start - dist
          #   value += rooms[to][:flow_rate] * (activated_at > 0 ? activated_at : 0) # Avoid underflow
          # end

          if value > highest[0]
            highest = [value, path.dup]
            puts "New highest [#{Process.pid}]: #{highest.inspect}"
          end
        end
      end
      File.open(OUTPUT_FILE, 'a') do |file|
        file << highest.inspect
        file << "\n"
      end
    end
  end
  Process.waitall

  Signal.trap('INT') do |signo|
    puts Signal.signame(signo)
    children.each { Process.kill('INT', _1) }
  end

  File.readlines(OUTPUT_FILE).map { eval(_1) }.max_by(&:first)
end

# puts "Part 1 (Example): #{part1(example)}"
# timed("1") { puts "Part 1: #{part1(input)}" }
timed("2ex") { puts "Part 2 (Example): #{part2(example)}" }
timed("2") { puts "Part 2: #{part2(input)}" }
