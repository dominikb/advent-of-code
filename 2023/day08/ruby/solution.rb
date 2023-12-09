require_relative '../../../utils/ruby/Aoc'

input = Aoc.get_input(year: 2023, day: 8)
example = <<~EXAMPLE
LR

11A = (11B, XXX)
11B = (XXX, 11Z)
11Z = (11B, XXX)
22A = (22B, XXX)
22B = (22C, 22C)
22C = (22Z, 22Z)
22Z = (22B, 22B)
XXX = (XXX, XXX)
EXAMPLE

example = example.split("\n").map(&:strip)

Node = Class.new do
    attr_accessor :name, :left, :right

    def initialize(name, left, right)
        @name = name
        @left = left
        @right = right
    end

    def start? 
        name.end_with?("A")
    end

    def end?
        name.end_with?("Z")
    end
end

def parse(input)
    instructions = input.first.strip.chars.map(&:to_sym)

    name_indexed_nodes = input.drop(2).map do |line|
        name, left, right = line.gsub(/\W/, " ").split(/\s+/)
        node = Node.new(name, left, right)
        [name, node]
    end.to_h

    nodes = name_indexed_nodes.map do |name, node|
        node.left = name_indexed_nodes[node.left]
        node.right = name_indexed_nodes[node.right]
        node
    end

    [instructions, nodes]
end

def part1(input)
    instructions, nodes = parse(input)
    current = nodes.find(&:start?)
    steps = 0

    instructions.cycle do |move_to|
        return steps if current.end?
        steps += 1
        if move_to == :L
            current = current.left
        else
            current = current.right
        end
    end
end

def part2(input)
    instructions, nodes = parse(input)

    starting_positions = nodes.filter(&:start?)

    current = starting_positions
    ending_after = Array.new(current.size)
    steps = 0

    instructions.cycle do |move_to|
        current.each_with_index do |node, i|
            ending_after[i] = steps if node.end?
        end

        unless ending_after.any?(&:nil?)
            return ending_after.flatten.reduce(&:lcm)
        end

        steps += 1
        current.map! do |node|
            if move_to == :L
                node.left
            else
                node.right
            end
        end
    end
end

puts "Part 1 (Example): #{part1(example)}"
puts "Part 1: #{part1(input)}"
puts "Part 2 (Example): #{part2(example)}"
puts "Part 2: #{part2(input)}"
