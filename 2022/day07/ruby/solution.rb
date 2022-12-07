# frozen_string_literal: true

require_relative '../../../utils/ruby/Aoc'

input = Aoc.get_input(year: 2022, day: 7)
example = <<~EXAMPLE
$ cd /
$ ls
dir a
14848514 b.txt
8504156 c.dat
dir d
$ cd a
$ ls
dir e
29116 f
2557 g
62596 h.lst
$ cd e
$ ls
584 i
$ cd ..
$ cd ..
$ cd d
$ ls
4060174 j
8033020 d.log
5626152 d.ext
7214296 k
EXAMPLE
example = example.split("\n")

class MyDir
  attr_accessor :children, :files
  attr_reader :path

  def initialize(path)
    @path = path
    @children = []
    @files = []
  end

  def size
    children.map(&:size).sum +
      files.map { _1[:size] }.sum
  end
end

def part1(input)
  current_path = []

  fs = Hash.new { _1[_2] = MyDir.new(_2) }

  input.each do |line|
    if line.start_with?('$')
      if match_data = line.match(%r|\$ cd (\S+)|)
        case match_data.captures.first
        in '..' then current_path.pop
        in dir then current_path << dir
        end
      end
    else
      case line
      in %r|dir (\S+)|
        subdirectory = line.split(' ').second
        fs[current_path].children << fs[current_path + [subdirectory]]
      in %r|(\d+) (\S+)|
        size, name = line.split(' ')
        fs[current_path].files << { name:, size: size.to_i }
      else
        nil
      end
    end
  end

  fs.values.map(&:size).filter { _1 < 100_000 }.sum
end

def part2(input)
  current_path = []
  p = -> (cur) { cur.size == 1 ? '/' : '/' + cur[1..].join('/') }

  fs = Hash.new { _1[_2] = MyDir.new(_2) }

  input.each do |line|
    if line.start_with?('$')
      if match_data = line.match(%r|\$ cd (\S+)|)
        case match_data.captures.first
        in '..' then current_path.pop
        in dir then current_path << dir
        end
      end
    else
      case line
      in %r|dir (\S+)|
        subdirectory = fs[p.(current_path + [line.split(' ').second])]
        fs[p.(current_path)].children << subdirectory
      in %r|(\d+) (\S+)|
        size, name = line.split(' ')
        fs[p.(current_path)].files << { name:, size: size.to_i }
      else
        nil
      end
    end
  end

  total = 70_000_000
  required = 30_000_000
  used = fs.fetch('/').size
  to_free = used - (total - required)
  fs
    .filter { |path, dir| dir.size >= to_free }
    .min_by { |path, dir| dir.size }[1].size
end

puts "Part 1 (Example): #{part1(example)}"
puts "Part 1: #{part1(input)}"
puts "Part 2 (Example): #{part2(example)}"
puts "Part 2: #{part2(input)}"
