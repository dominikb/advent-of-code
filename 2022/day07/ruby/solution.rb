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

  def to_s
    prefix = (path.size - 1).times.map { '  ' }.join('') + '- '
    cur =  prefix + path.last + ' (dir)'
    dirs = children.map(&:to_s).join("\n")
    fs = files.map { '  ' + prefix + _1[:name] + ' (file, size=' + _1[:size].to_s + ')' }.join("\n")
    [cur, dirs, fs].reject { _1.strip.empty? }.join("\n")
  end
end

def parse_directories(input)
  current_path = []

  fs = Hash.new { _1[_2] = MyDir.new(_2) }

  input.each do |line|
    case line.split(' ')
    in '$', 'cd', '..' then current_path = current_path[...-1]
    in '$', 'cd', dir then current_path += [dir]
    in '$', 'ls' then nil
    in 'dir', dir_name then fs[current_path].children << fs[current_path + [dir_name]]
    in size, name then fs[current_path].files << { size: size.to_i, name: }
    end
  end

  fs
end

def part1(input)
  fs = parse_directories(input)

  fs.values.map(&:size).filter { _1 < 100_000 }.sum
end

def part2(input)
  fs = parse_directories(input)

  total = 70_000_000
  required = 30_000_000
  used = fs[['/']].size
  to_free = used - (total - required)
  fs.values.map(&:size).filter { _1 >= to_free }.min
end

puts "Part 1 (Example): #{part1(example)}"
puts "Part 1: #{part1(input)}"
puts "Part 2 (Example): #{part2(example)}"
puts "Part 2: #{part2(input)}"
